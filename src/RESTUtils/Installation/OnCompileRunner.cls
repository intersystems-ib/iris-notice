Class RESTUtils.Installation.OnCompileRunner [ DependsOn = (RESTUtils.Installation.RoleGenerator, RESTUtils.Installation.TaskGenerator, RESTUtils.Resolver.ClassInfo.Definition.ToExternalTypeDefinition) ]
{

ClassMethod OnCompile() [ CodeMode = objectgenerator ]
{
    $$$ThrowOnError(##class(RESTUtils.Installation.RoleGenerator).GenerateRole())
    //$$$ThrowOnError(##class(RESTUtils.Installation.TaskGenerator).GenerateTask())
    D ##class(RESTUtils.Resolver.ClassInfo.Definition.ToExternalTypeDefinition).GenGlobal()
}

}
