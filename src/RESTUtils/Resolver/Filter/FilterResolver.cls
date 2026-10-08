Include (RESTUtils.INC.Search, RESTUtils.INC.Status, RESTUtils.INC.Filters, RESTUtils.INC.OptionsKeys, RESTUtils.INC.Query.Check)

Class RESTUtils.Resolver.Filter.FilterResolver [ Final ]
{

// ****************** Filters ******************* //

/// Main filter method
ClassMethod FiltersToWhereClause(ByRef whereClause As %List = "", ByRef args, filter As %DynamicObject) [ Final, Internal ]
{
    Set iterator = filter.%GetIterator()
    while(iterator.%GetNext(.key, .value)){
        If (key [ $$$OR){
            ///Multi column OR condition
            Do ..HandleObject(.whereClause, .args, value, "or")
        }ElseIf (key [ $$$AND){
            Do ..HandleObject(.whereClause, .args, value, "and")
        }else{
            ///Skip keys that do not have a column value
            continue:(($PIECE(key, "$", 1)="") || ($PIECE(key, "!", 1)=""))
            //Check the column
            Set column = ..GetFilterColumn(key, .transformation)
            ///Get the type, filters are caseless
            Set filterType = ..GetFilterType(key, .modifiers)
            Set modifiers = modifiers _ "$"_transformation
            //Check if it's an array or is a value
            If (..IsArray(value)){
                ///Signle column OR condition
                Do ..HandleArray(filterType _"Filter", .whereClause, .args, column, value, modifiers)
            }Else{
                Do $CLASSMETHOD($$$FilterDefinition, filterType _"Filter", .whereClause, .args, column, value, modifiers)
            }
        }
    }
}

ClassMethod GetFilterColumn(key As %String(MAXLEN=""), Output transformation As %String(MAXLEN="")) As %String(MAXLEN="") [ Final, Internal ]
{
    Set column = $PIECE(key, "$")
    Set transformation = $PIECE(column, "!", 2)
    Set column = $PIECE(column, "!", 1)
    THROW:($$$CheckSimpleColumn(column) = 0) ##Class(%Exception.General).%New($$$BADREQUEST, "Bad filter column "_ column)
    Return ..CleanColumn(column)
}

ClassMethod GetFilterType(key As %String(MAXLEN=""), Output modifiers = "") As %String(MAXLEN="") [ Internal ]
{
    Set filterType = $ZCONVERT($PIECE(key, "$", 2), "u")
    Set:(filterType = "") filterType = "EQUALS"
    ///Modifiers always must start with $
    Set modifiers = "$"_$PIECE(key, "$", 3, *)
    Return filterType
}

// ******************* Array ******************** //

ClassMethod IsArray(possibleArray) As %Boolean [ Final, Internal ]
{
    Try{
        Return possibleArray.%IsA("%DynamicArray")
    }Catch e {
    }
    Return 0
}

ClassMethod HandleArray(filterMethod As %String(MAXLEN=""), ByRef whereClause As %String(MAXLEN=""), ByRef args, column As %String(MAXLEN=""), value, modifiers As %String(MAXLEN="") = "") [ Final, Internal ]
{
    Set subClause = ""
    Set iterator = value.%GetIterator()
    while(iterator.%GetNext("", .val)){
        ///Can pass an object to specify deeper OR clause
        ///If an array inclues a null value, "", unless specified elsewise we handle it as a IS NULL
        If ((val="") && ('..HasModifier(modifiers, $$$IGNOREARRAYNULLVALUE))){
            Do $CLASSMETHOD($$$FilterDefinition, "NULLFilter", .subClause, .args, column, 0, modifiers)
        }Else{
            Do $CLASSMETHOD($$$FilterDefinition, filterMethod, .subClause, .args, column, val, modifiers)
        }
    }    
    Set:(subClause '= "") whereClause = $LISTUPDATE(whereClause, $LISTLENGTH(whereClause)+1, " (" _ $LISTTOSTRING(subClause, " or ")_") ")
}

// ******************* Object ******************* //

ClassMethod IsObject(possibleObject) As %Boolean [ Final, Internal ]
{
    Try{
        Return possibleObject.%IsA("%DynamicObject")
    }Catch e {
    }
    Return 0
}

ClassMethod HandleObject(ByRef whereClause As %List = "", ByRef args, filter As %DynamicObject, joinType As %String(VALUELIST=",and,or"))
{
    THROW:(..IsObject(filter) = 0) ##Class(%Exception.General).%New("An OR or AND condition must have an object as a child", $$$BADREQUEST)
    Do ..FiltersToWhereClause(.where, .args, filter)
    Set:(where'="") whereClause = $LISTUPDATE(whereClause, $LISTLENGTH(whereClause)+1, " ("_$LISTTOSTRING(where," "_joinType_" ")_") ")
}

// ***************** Modifiers ****************** //

ClassMethod HasModifier(modifiers As %String(MAXLEN=""), name As %String(MAXLEN="")) As %Boolean [ Final, Internal ]
{
    Return ((modifiers_"$") [ ("$"_name_"$")) || ((modifiers_"$") [ ("$"_name_":"))
}

ClassMethod GetModifier(modifiers As %String(MAXLEN=""), name As %String(MAXLEN=""), default As %String(MAXLEN="") = "") As %String(MAXLEN="") [ Final, Internal ]
{
    Return:('..HasModifier(modifiers, name)) default
    Return $PIECE($PIECE($PIECE(modifiers, "$"_name, 2), ":", 2), "$", 1)
}

// ************ Clean and regularize ************ //

ClassMethod CleanColumn(column As %String(MAXLEN="")) As %String(MAXLEN="") [ Final ]
{
    Return """"_$REPLACE($replace(column, "->", """->"""), " ", """ """)_""""
}

}
