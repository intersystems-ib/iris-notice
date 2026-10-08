Include (RESTUtils.INC.Status, RESTUtils.INC.OptionsKeys, RESTUtils.INC.Utils, RESTUtils.INC.ClassInfo, RESTUtils.INC.Content.Export, RESTUtils.INC.Language.Errors)

Class RESTUtils.Resolver.Export.ExportResolver
{

/// Should be as %Any, but since it has been introduced in 2025 might break in earlier versions
ClassMethod ExportResultSet(qres As %SQL.StatementResult, type As %String(MAXLEN="") = "", ByRef options, ByRef total As %Numeric = 0) [ Final, Internal ]
{
    Set exportType = $GET(options($$$OPEXPORTTYPE))
    If (exportType = ""){
        Set options($$$OPEXPORTTYPE) = $$$ExportToColumns
        Return $CLASSMETHOD($THIS, "ExportToJSON", qres, .options, .total)
    }
    THROW:('..ExportMethodExists(exportType)) $$$ExportMethodNotFound
    Return $CLASSMETHOD($THIS, "ExportTo"_exportType, qres, .options, .total)
}

ClassMethod ExportMethodExists(exportMethod As %String(MAXLEN="")) As %Boolean
{
    Return ((exportMethod = $$$ExportToJSON) || (exportMethod = $$$ExportToExcel) || (exportMethod = $$$ExportToColumns) || (exportMethod=""))
}

ClassMethod ExportToJSON(qres As %SQL.StatementResult, ByRef options, Output total As %Numeric) As %Library.DynamicArray
{
    Return ##Class(RESTUtils.Resolver.Export.Definitions.ExportToJSON).Export(qres, .options, .total)
}

ClassMethod ExportToJSONMAPPING(qres As %SQL.StatementResult, ByRef options, Output total As %Numeric) As %Library.DynamicArray
{
    Return ##Class(RESTUtils.Resolver.Export.Definitions.ExportToJSONMapping).Export(qres, .options, .total)
}

/// Call this do not call the definition directly
ClassMethod ExportJSONMappingObject(jsonEnabledClass As %String(MAXLEN=""), id, ByRef options) As %DynamicObject
{
    Return $$$IntExportSingleObjectToJSON(jsonEnabledClass, id, .options)
}

ClassMethod ExportToEXCEL(qres As %SQL.StatementResult, ByRef options, ByRef total As %Numeric = 0) As %String(MAXLEN="") [ Final, Internal, Private ]
{
    ///Escape \u0000 that equates to $CHAR(0) since it causes an exception
    Return ##class(RESTUtils.Resolver.Export.Definitions.ExportToExcel).AsExcel($REPLACE(..ExportToJSON(qres, .options).%ToJSON(), "\u0000", ""), $GET(options($$$OPEXCELFORMATTING),"{}"))
}

ClassMethod ExportFromJSONToEXCEL(json As %DynamicArray, ByRef options, ByRef total As %Numeric = 0) As %String(MAXLEN="") [ Final ]
{
    ///Escape \u0000 that equates to $CHAR(0) since it causes an exception
    Return ##class(RESTUtils.Resolver.Export.Definitions.ExportToExcel).AsExcel($REPLACE(json.%ToJSON(), "\u0000", ""), $GET(options($$$OPEXCELFORMATTING),"{}"))
}

}
