Class RESTUtils.Resolver.Import.Definition.ImportFromJSON
{

ClassMethod Import(content As %Stream.Object) As %DynamicObject
{
    Try{
        Return:(content.Size = 0) {}
        Return {}.%FromJSON(content)
    }Catch e {
    }
    Return {}
}

}
