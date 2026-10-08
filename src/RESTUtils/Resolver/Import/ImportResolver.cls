Include RESTUtils.INC.Providers

Class RESTUtils.Resolver.Import.ImportResolver
{

/// As any 
ClassMethod ImportData(content As %Stream.Object, type As %String(MAXLEN="") = "JSON")
{
    Try{
        Return $CLASSMETHOD("RESTUtils.Resolver.Import.Definition.ImportFrom"_type, "Import", content)
    }Catch e {
        THROW ##Class(%Exception.General).%New("Failed to import: "_ e.DisplayString())
    }
}

}
