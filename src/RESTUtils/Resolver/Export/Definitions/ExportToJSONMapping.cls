Include (RESTUtils.INC.Utils, RESTUtils.INC.OptionsKeys, RESTUtils.INC.ClassInfo)

Class RESTUtils.Resolver.Export.Definitions.ExportToJSONMapping
{

/// TODO, ideally, this should stream and patch it together, to make it faster
ClassMethod Export(qres As %SQL.StatementResult, ByRef options, Output total As %Numeric = 0) As %DynamicArray [ Final, Internal ]
{
    $$$SwapNamespace(options)
    Set jsonEnabledClass = $GET(options($$$OPJSONENABLEDCLASS))
    Set IdColumn = $GET(options($$$OPIDCOLUMN), "Id")
    Set JSONMappingName = $GET(options($$$OPJSONMAPPINGNAME))
    Set:($GET(options($$$INCLUDECOLUMNTYPES)) '= "") options($$$OUTCOLUMNTYPES) = $$$GetColumnsFromJSONMapping(jsonEnabledClass, "", JSONMappingName)
    Set result = []
    While(qres.%Next()){
        Set id = qres.%Get(IdColumn)
        Do result.%Push(..IntExportJSONMappingObject(jsonEnabledClass, id, .options))
    }
    Return result
}

/// TODO add method to allow to return a stream directly instead of reimporting
ClassMethod IntExportJSONMappingObject(jsonEnabledClass As %String(MAXLEN=""), id, ByRef options = "") As %DynamicObject [ Final, Internal ]
{
    Set JSONMappingName = $GET(options($$$OPJSONMAPPINGNAME))
    $$$SwapNamespace(options)
    Set DBObj = $CLASSMETHOD(jsonEnabledClass, "%OpenId", id)
    THROW:(DBObj="") ##Class(%Exception.General).%New("Not found", $$$NOTFOUND)
    #DIM DBObj As %JSON.Adaptor
    $$$ThrowOnError(DBObj.%JSONExportToStream(.export, JSONMappingName))
    Set obj = {}.%FromJSON(export)
    Return obj
}

}
