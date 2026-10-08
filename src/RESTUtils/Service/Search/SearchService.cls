Include (RESTUtils.INC.Status, RESTUtils.INC.Search, RESTUtils.INC.Content.Export, RESTUtils.INC.OptionsKeys, RESTUtils.INC.Utils)

/// TODO move here query execution from resolver, resolver should not interact with persistance
Class RESTUtils.Service.Search.SearchService
{

// *************** Search methods *************** //

ClassMethod SearchClass(class As %String(MAXLEN=""), filter As %DynamicObject, Output total As %Integer = 0, Output query As %String(MAXLEN="") = "", Output replaced As %String(MAXLEN="") = "", ByRef options = "") As %DynamicArray
{
    ///Optionally add the jsonEnabledClass
    If ($GET(options($$$OPJSONENABLEDCLASS)) = ""){
        Set options($$$OPJSONENABLEDCLASS) = class
    }
    Set table = $$$GetTable(class, $GET(options($$$OPNAMESPACE)))
    Do ..CheckOptions(.options)
    Set qres = $$$IntSearchTable(table, filter, $GET(options($$$OPSIZE), 50), $GET(options($$$OPPAGE), 1), $GET(options($$$OPORDER)), .total, .query, .replaced, .options)
    Set res = $$$ExportResultSet(qres, $GET(options($$$OPEXPORTTYPE)), .options)
    Return res
}

ClassMethod SearchTable(table As %String(MAXLEN=""), filter As %DynamicObject, Output total As %Integer = 0, Output query As %String(MAXLEN="") = "", Output replaced As %String(MAXLEN="") = "", ByRef options = "") As %DynamicArray
{
    Set jsonEnabledClass = $GET(options($$$OPJSONENABLEDCLASS))
    Do ..CheckOptions(options)
    Set qres = $$$IntSearchTable(table, filter, $GET(options($$$OPSIZE), 50), $GET(options($$$OPPAGE), 1), $GET(options($$$OPORDER)), .total, .query, .replaced, .options)
    Return $$$ExportResultSet(qres, $GET(options($$$OPEXPORTTYPE)), .options)
}

/// Any required checks should preferably be done here
ClassMethod CheckOptions(ByRef options) As %Boolean [ Final, Internal, Private ]
{
    Set errors = ""
    Set jsonEnabledClass = $GET(options($$$OPJSONENABLEDCLASS))
    Set select = $GET(options($$$CUSTOMSELECTCLAUSE))
    Set idColumn = $GET(options($$$OPIDCOLUMN))
    Set exportType = $GET(options($$$OPEXPORTTYPE))
    If (exportType = $$$ExportToJSON){
        Do:(jsonEnabledClass = "") ..AppendToList(.errors, "To export to JSON " _ $$$OPJSONENABLEDCLASS _ " must be provided in options")
        Do:((select '= "") && (idColumn = "")) ..AppendToList(.errors, "If exporting to JSON  and " _ $$$CUSTOMSELECTCLAUSE _ " is provided,  the option "_$$$OPIDCOLUMN _ " must tbe defined")
    }
    THROW:(errors'="") ##Class(%Exception.General).%New($LISTTOSTRING(errors, $CHAR(13)), $$$BADREQUEST)
}

ClassMethod AppendToList(ByRef list As %List, str As %String(MAXLEN="")) As %List [ Final, Internal, Private ]
{
    Set list = $LISTUPDATE(list, $LISTLENGTH(list)+1, str)
    Return list
}

}
