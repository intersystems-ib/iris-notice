Include (RESTUtils.INC.Filters, RESTUtils.INC.Search, RESTUtils.INC.Status, RESTUtils.INC.OptionsKeys, RESTUtils.INC.Utils, RESTUtils.INC.Language.Errors, RESTUtils.INC.Query.Check)

Class RESTUtils.Resolver.Query.QueryResolver [ Final ]
{

ClassMethod IntSearchTable(table As %String(MAXLEN=""), filter As %DynamicObject, size As %Numeric = 50, page As %Numeric = 1, order As %String(MAXLEN="") = "", Output total As %Integer = 0, Output query As %String(MAXLEN="") = "", Output replaced As %String(MAXLEN="") = "", ByRef options = "") As %SQL.StatementResult [ Final, Internal ]
{
    ///Checks
    THROW:(size <= 0) $$$InvalidSize
    THROW:(page <= 0) $$$InvalidPage

    Set groupByOption = $GET(options($$$OPGROUPBY))
    Set namespace = $GET(options($$$OPNAMESPACE))

    //Select clause
    Set select = ..SelectClause(.options, groupByOption '= "")

    //From clause
    THROW:($$$CheckTable(table) = 0) $$$InvalidTable
    Set from =  " from "_..CleanTable(table) _ "T "

    //where clause
    Set args = 0
    Do $$$FiltersToWhereClause(.where, .args, filter)
    Set whereClause = ($CASE(where'="", 1:" where "_ $LISTTOSTRING(where," and ")_" ", :"" ))

    ///TODO, should be checked if the selected columns rename any existing columns, and if so add the tablequalifier
    ///to avoid an error
    //Order by
    Do ..OrderByClause(.order, size, page)
    
    //Group by
    Set groupBy = ..GroupByClause(groupByOption)

    ///Build query without select or order by
    Set query = from _ whereClause _ groupBy

    //Total query, ran before adding the pagination and the order
    Set total = ..GetTotal("select count(*) total from (select 1 total "_ query _ ")", namespace, args...)

    ///Add the pagination and the select clause, this is done since the query might need to be wrapped for versions lower than 2025
    If ($$$HigherOrEqualVersionOfIRIS(2025)){
        Set query = select_query _ order _ ..GetLimitPagination(size, page)
    }Else{
        Set query = ..GetRowNumPagination(select, query, size, page)
    }

    ///Run and export
    Set qres = $$$ExecQuery(query, namespace, args...)
    
    
    
    Set replaced = ..ReplaceQuery(query, args...)
    Return qres
}

// ************ Clean and regularize ************ //

ClassMethod CleanTable(table As %String(MAXLEN="")) As %String(MAXLEN="") [ Internal ]
{
    Return """"_$REPLACE(table,".",""".""")_""" "
}

ClassMethod CleanOrderBy(orderBy As %String(MAXLEN="")) As %String(MAXLEN="") [ Internal ]
{
    Set listOfOrder = ..GetListFromString(orderBy, ",")
    Set ptr = 0
    Set c = 0
    Set result = ""
    while($LISTNEXT(listOfOrder, ptr, order)){
        Set direction = $PIECE(order, " ", 2)
        Set:(direction '= "") direction = " "_direction
        Set c = c + 1
        Set result = $LISTUPDATE(result, c, ..CleanColumn($PIECE(order, " ", 1))_direction)
    }
    Return $LISTTOSTRING(result)
}

ClassMethod CleanColumn(column As %String(MAXLEN=""), isSelectColumn As %Boolean = 0, addExact As %Boolean = 0) As %String(MAXLEN="") [ Internal ]
{
    ///Settting of empty vars to avoid error
    Set dot = "", function = "", alias = ""
    Set buffer = column
    
    ///Check if it's a literal
    If ($FIND(buffer, "'") '= 0){
        Do ..HandleAlias(.buffer, .alias)
        THROW:(($EXTRACT(buffer, 1, 1)'= "'") || ($EXTRACT(buffer, *, *)'= "'")) $$$InvalidLiteral
        ///No processing for literals, only check for an Alias
        Return buffer _ alias
    }
    ///Alias
    If (buffer [ " As "){
        Do ..HandleAlias(.buffer, .alias)
    }
    ///Function
    If (buffer [ "("){
        Set function = $PIECE(buffer, "(", 1)
        Set buffer = $PIECE($PIECE(buffer, "(", 2), ")", 1)
        THROW:((addExact) && (function'="")) $$$TooManyFunctions
    }

    ///Check DISTINCT
    Set hasDistinct = 0
    If (buffer [ "DISTINCT "){
        Set hasDistinct = 1
        Set buffer = $PIECE(buffer, "DISTINCT ", 2, *)
    }

    /// Table specification (t.)
    If (buffer [ "."){
        Set dot = """"_$PIECE(buffer, ".", 1)_"""."
        Set buffer = $PIECE(buffer, ".", 2)
    }
    
    ///Surround the columns with "
    Set:(buffer '= "*") buffer = """"_$REPLACE(buffer, "->", """->""")_""""
    
    ///Putting it all together
    Set buffer = dot_buffer
    Set:(hasDistinct) buffer = "DISTINCT "_buffer
    Set:(function '= "") buffer = function_"("_buffer_")"
    Set:(addExact) buffer = "%Exact("_ buffer_")"
    Set:(alias '= "") buffer = buffer _ alias
    Return buffer
}

ClassMethod HandleAlias(ByRef buffer As %String(MAXLEN=""), Output escapedAlias As %String(MAXLEN="") = "")
{
    Set spl = ..GetListFromString(buffer, " As ")
    Set:($LISTGET(spl, 2) '= "") escapedAlias = " As "_""""_$LISTGET(spl, 2)_""""
    Set buffer = $LISTGET(spl, 1)
}

ClassMethod SelectClause(ByRef options, addExact As %Boolean = 0) As %String(MAXLEN="") [ Internal, Private ]
{
    Return:($GET(options($$$CUSTOMSELECTCLAUSE)) '= "") $GET(options($$$CUSTOMSELECTCLAUSE))
    Set select = $GET(options($$$OPSELECT))
    If (select '= ""){
        Set cleanedColumnList = ..CleanColumnList(select, "Bad select column", 1, addExact, 1)
        THROW:(cleanedColumnList = "") $$$InvalidNothingToSelect
        Return "Select "_cleanedColumnList

    }
    Return "Select %ID id "
}

// ****************** Order By ****************** //

ClassMethod OrderByClause(ByRef order As %String(MAXLEN=""), size As %Numeric, page As %Numeric) [ Internal ]
{
    If (order=""){
        ///Earlier versions have issues with %ID
        If ('$$$HigherOrEqualVersionOfIRIS(2025)){
            Set order = ""
            Return
        }
        Set order = " %ID "
    }Else{
        THROW:($$$CheckOrderBy(order) = 0) $$$InvalidOrderBy
        Set order = ..CleanOrderBy(order)
    }
    Set order = " Order by "_order
}

// ****************** Pagination ****************** //

ClassMethod GetLimitPagination(size As %Numeric = 50, page As %Numeric = 1)
{
    Return " LIMIT "_ size _" OFFSET "_ (size * (page-1))
}

ClassMethod GetRowNumPagination(select As %String(MAXLEN=""), query As %String(MAXLEN=""), size As %Numeric = 50, page As %Numeric = 1) As %String(MAXLEN="")
{
    Set rowColumn = "_ROW"
    Return "select * from ("_select_", ROW_NUMBER() As "_rowColumn_" "_query_") T where "_rowColumn_" >= "_ ((page-1) * size) _ " and "_rowColumn _ " < " _ ((page * size) + 1) _ order
}

// ****************** Group By ****************** //

ClassMethod GroupByClause(groupBy As %String(MAXLEN="") = "") As %String(MAXLEN="")
{
    If (groupBy'=""){
        Set cleanedColumnList = ..CleanColumnList(groupBy, "Bad group by column", 0)
        Return:(cleanedColumnList'="") " Group by  "_cleanedColumnList_" "
    }
    Return ""
}

/// Mostly for debugging porpouses, not too accurate
ClassMethod ReplaceQuery(query, args...) [ Final, Internal, Private ]
{
    Return:($GET(args) = "") query
    Set c = 0
    while(c < args){
        Set c = c+1
        Set query = $REPLACE(query, "?", "'"_args(c)_"'", 1, 1)
    }
    Return query
}

ClassMethod GetTotal(query As %String(MAXLEN=""), namespace As %String(MAXLEN=""), args...) [ Final, Internal, Private ]
{
    Set qres = $$$ExecQuery(query, namespace, args...)
    $$$SwapNamespace(namespace)
    Do qres.%Next() 
    Return qres.total
}

ClassMethod CleanColumnList(listOfColumns As %String(MAXLEN=""), badColumnErrorMsg As %String(MAXLEN=""), isSelectColumn As %Boolean = 1, addExact As %Boolean = 0, allowConcat As %Boolean = 0) As %String(MAXLEN="")
{
    Set cleanedColumnList = ""
    Set columnList = ..GetListFromString(listOfColumns, ",")
    Set ptr = 0
    while($LISTNEXT(columnList, ptr, column)){
        Set cleanedColumnList = $LISTUPDATE(cleanedColumnList, $LISTLENGTH(cleanedColumnList)+1, ..CleanCompColumn(column, badColumnErrorMsg, isSelectColumn, addExact, allowConcat))
    }
    Return $LISTTOSTRING(cleanedColumnList, ", ")
}

ClassMethod CleanCompColumn(column As %String(MAXLEN=""), badColumnErrorMsg As %String(MAXLEN=""), isSelectColumn As %Boolean = 1, addExact As %Boolean = 0, allowConcat As %Boolean = 0) As %String(MAXLEN="")
{
    Set isList = ..GetListFromString(column, "||", "'")
    If ($LISTLENGTH(isList) '= 1){
        THROW:(allowConcat = 0) ##Class(%Exception.General).%New(badColumnErrorMsg, $$$BADREQUEST)
        Set res = ""
        Set ptr = 0
        while($LISTNEXT(isList, ptr, col)){
            Set res = $LISTUPDATE(res, $LISTLENGTH(res) + 1, ..CleanCompColumn(col, badColumnErrorMsg, isSelectColumn, addExact, allowConcat))
        }
        Return $LISTTOSTRING(res, "||")
    }Else{
        THROW:($$$CheckColumn(column, isSelectColumn, .isFunction) = 0) $$$InvalidColumn(badColumnErrorMsg, column)
        Return ..CleanColumn(column, isSelectColumn, ((addExact) && (isFunction = 0)))
    }
}

ClassMethod GetListFromString(str As %String(MAXLEN=""), split As %String(MAXLEN="") = ",", stringChar As %String(MAXLEN=1) = "'") As %List
{
    Set result = ""
    Set pos = 0
    Set buffer = ""
    Set inString = 0
    Set stringLength = $LENGTH(str)
    Set splitLength = $LENGTH(split)
    while(pos<stringLength){
        Set pos = pos + 1
        Set char = $EXTRACT(str, pos, pos)
        Set:(char = stringChar) inString = 'inString
        Set buffer = buffer _ char
        If ('inString && ($EXTRACT(buffer, *-splitLength+1, *)  = split)){
            Set result = $LISTUPDATE(result, $LISTLENGTH(result) + 1, $EXTRACT(buffer, 1, *-splitLength)) 
            Set buffer = ""
        }
    }
    Set result = $LISTUPDATE(result, $LISTLENGTH(result) + 1, buffer)
    THROW:(inString) $$$StringNotClosed
    Return result
}

}
