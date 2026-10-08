Include RESTUtils.INC.Filters

/// Class that defines what the available filters are, can be added/extended 
/// A filter ought to update the whereClause and the arguments with args($I(args)) as needed to add it's filter functionality
/// It will receive:
/// - column: the column to filter, it has been already been checked and escaped, do not edit it add it directly
/// - value: the value for the filter, for example: "Name$LIKE": "Paco" -> Then Paco is the value
/// - modifiers: Modifiers available for the filter, they can be simple:  "Name$LIKE$not": "Paco" or have value
/// 
/// Although not enforced for modifiers, all the modifiers name, and if able, the values ought to be lowercase
/// The filter names always must be uppercase
/// A method implementing a filter ought to follow the spec and be named as {{FilterName}}Filter
Class RESTUtils.Resolver.Filter.Definition.FilterDefinition
{

/// This is the default fallback if no specific filter is provided
ClassMethod EQUALSFilter(ByRef whereClause As %String(MAXLEN=""), ByRef args, column As %String(MAXLEN=""), value, modifiers As %String(MAXLEN="") = "") [ Internal ]
{
    Return:(value = "")
    Set filter = column_" = ? "
    Set:($$$HasModifier(modifiers, "not")) filter = column_" != ? "
    Set whereClause = $LISTUPDATE(whereClause, $LISTLENGTH(whereClause)+1, filter)
    Set args($I(args)) = value
}

ClassMethod GTEFilter(ByRef whereClause As %String(MAXLEN=""), ByRef args, column As %String(MAXLEN=""), value, modifiers As %String(MAXLEN="") = "") [ Internal ]
{
    Do ..SimpleOp(.whereClause, .args, column, value, modifiers, ">=")
}

ClassMethod GTFilter(ByRef whereClause As %String(MAXLEN=""), ByRef args, column As %String(MAXLEN=""), value, modifiers As %String(MAXLEN="") = "") [ Internal ]
{
    Do ..SimpleOp(.whereClause, .args, column, value, modifiers, ">")
}

ClassMethod LTEFilter(ByRef whereClause As %String(MAXLEN=""), ByRef args, column As %String(MAXLEN=""), value, modifiers As %String(MAXLEN="") = "") [ Internal ]
{
    Do ..SimpleOp(.whereClause, .args, column, value, modifiers, "<=")
}

ClassMethod LTFilter(ByRef whereClause As %String(MAXLEN=""), ByRef args, column As %String(MAXLEN=""), value, modifiers As %String(MAXLEN="") = "") [ Internal ]
{
    Do ..SimpleOp(.whereClause, .args, column, value, modifiers, "<")
}

ClassMethod SimpleOp(ByRef whereClause As %String(MAXLEN=""), ByRef args, column As %String(MAXLEN=""), value, modifiers As %String(MAXLEN="") = "", op As %String(MAXLEN="")) [ Internal ]
{
    Return:(value = "")
    Set replaceValue = " ? "
    Set:($$$HasModifier(modifiers, "date")) replaceValue = " TO_TIMESTAMP(?, 'yyyy-mm-dd') "
    If ($$$HasModifier(modifiers, "ts")){
        Set replaceValue = " TO_TIMESTAMP(?, 'yyyy-mm-dd hh:mi:ss') "
        Set value = $REPLACE(value, "T", " ", 1)
    }
    
    Set filter = column_" "_op_" "_replaceValue
    Set:($$$HasModifier(modifiers, "not")) filter = "NOT("_ column_" "_op_" "_replaceValue_" )"
    Set whereClause = $LISTUPDATE(whereClause, $LISTLENGTH(whereClause)+1, filter)
    Set args($I(args)) = value
}

ClassMethod WORDSFilter(ByRef whereClause As %String(MAXLEN=""), ByRef args, column As %String(MAXLEN=""), value, modifiers As %String(MAXLEN="") = "") [ Internal ]
{
    Return:(value = "")
    Set value = $TRANSLATE(value, ",.", "  ")
    Set wordList = $LISTFROMSTRING(value, " ")
    Set ptr = 0
    Set subWhere = ""
    while($LISTNEXT(wordList, ptr, word)){
        Set subWhere = $LISTUPDATE(subWhere, $LISTLENGTH(subWhere)+1, column _ " LIKE ? ")
        Set args($I(args)) = "%"_word_"%"
    }
    Set joinWith = " AND "
    Set:($$$HasModifier(modifiers, "or")) joinWith = " OR "
    Set whereClause = $LISTUPDATE(whereClause, $LISTLENGTH(whereClause)+1, "("_$LISTTOSTRING(subWhere, joinWith)_")")
}

ClassMethod LIKEFilter(ByRef whereClause As %String(MAXLEN=""), ByRef args, column As %String(MAXLEN=""), value, modifiers As %String(MAXLEN="") = "") [ Internal ]
{
    Return:(value = "")
    Set filter = " LIKE ? ESCAPE 'Â¡'"
    Set:($$$HasModifier(modifiers, "not")) filter = " NOT "_filter
    Set filter = column_filter
    Set whereClause = $LISTUPDATE(whereClause, $LISTLENGTH(whereClause)+1, filter)
    Set args($I(args)) = "%"_$REPLACE(value, "%", "Â¡%")_"%"
}

/// This filter must always be implemented, else when handling an array if the option IgnoreArrayNullValue is not true, it will cause an exception
ClassMethod NULLFilter(ByRef whereClause As %String(MAXLEN=""), ByRef args, column As %String(MAXLEN=""), value, modifiers As %String(MAXLEN="") = "") [ Internal ]
{
    Return:(value = "")
    Set filter = column _ $CASE(((value'="") && (value'=0)), 1:" IS NOT NULL ", :" IS NULL " )
    Set whereClause = $LISTUPDATE(whereClause, $LISTLENGTH(whereClause)+1, filter)
}

/// TODO this ought to go
ClassMethod DATEFilter(ByRef whereClause As %String(MAXLEN=""), ByRef args, column As %String(MAXLEN=""), value, modifiers As %String(MAXLEN="") = "") [ Internal ]
{
    Return:(value = "")
    Set filter = ..NumericValuesCompModifier(column, " TO_TIMESTAMP(?, 'yyyy-MM-DD') ", modifiers)
    Set whereClause = $LISTUPDATE(whereClause, $LISTLENGTH(whereClause)+1, filter)
    Set args($I(args)) = $PIECE($PIECE(value, "T"), " ")
}

/// TODO this ought to go
ClassMethod TIMESTAMPFilter(ByRef whereClause As %String(MAXLEN=""), ByRef args, column As %String(MAXLEN=""), value, modifiers As %String(MAXLEN="") = "") [ Internal ]
{
    Return:(value = "")
    Set filter = ..NumericValuesCompModifier(column, " TO_TIMESTAMP(?, 'yyyy-mm-dd hh:mi:ss') ", modifiers)
    Set whereClause = $LISTUPDATE(whereClause, $LISTLENGTH(whereClause)+1, filter)
    Set args($I(args)) = $REPLACE(value, "T", " ", 1)
}

// Utilities

/// TODO this ough to go 
ClassMethod NumericValuesCompModifier(column As %String(MAXLEN=""), valueParam As %String(MAXLEN="") = " ? ", modifiers) As %String(MAXLEN="")
{
    Set op = $CASE($$$GetModifier(modifiers, "comp", ""), "lt":"<", "lte":"<=", "gt":">", "gte":">=", :"=")
    Set filter = column _ " "_op_" "_valueParam_" "
    If ($$$HasModifier(modifiers, "not")){
        Set filter = " NOT("_filter_") "
    }
    Return filter
}

/// Valid filter check
ClassMethod CheckFilterMethods() [ CodeMode = objectgenerator, Final, ForceGenerate ]
{
    Set ValidFormalSpec = "&whereClause:%String(MAXLEN=""""),&args,column:%String(MAXLEN=""""),value,modifiers:%String(MAXLEN="""")="""""
    Set isValid = 1
    Set qres = ##Class(%SQL.Statement).%ExecDirect(,"select Name, FormalSpec from %Dictionary.MethodDefinition where Parent = ? and NAME LIKE '%Filter'", %class.Name)
    while(qres.%Next()){
        If (qres.FormalSpec '= ValidFormalSpec){
            Write !,qres.Name _ "   Not valid"
            Set isValid = 0
        }Else{
            Write !,qres.Name _ "   Ok"
        }
    }
    If ('isValid){
        Write !,!,"All methods that end with Filter are Filter implementation methods that must follow the FormalSpec:",!
        Write ValidFormalSpec,!
        THROW ##Class(%Exception.General).%New(5003, "Invalid formal spec for Filter method in search utils")
    }
}

}
