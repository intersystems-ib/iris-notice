Include RESTUtils.INC.Utils

/// TODO move to a differnt package, this is also being used by export
/// Defines with the method TypeToExternal the type mapping between the internal Iris classes to what it is actually outputted in JSON
Class RESTUtils.Resolver.ClassInfo.Definition.ToExternalTypeDefinition [ DependsOn = RESTUtils.Util.GeneralUtils ]
{

/// As any since, it might return an object when breaking down a persistent class
ClassMethod TypeToExternal(type As %Dictionary.CompiledClass, isIdentity As %Boolean, referenceDepth As %Numeric = 0, Output isInDepthReference As %Boolean = 0)
{
    K isInDepthReference
    Set isInDepthReference = 0
    Return:(isIdentity) "IDENTITY"
    Set name = type.Name
    Do:(..IsGlobalGenerated() = 0) ..GenGlobal()
    Set odbcType = ..GetODBCType(name)
    Return:(odbcType '= "") odbcType
    If ((type.PrimarySuper [ "~%Library.Persistent") || (type.PrimarySuper [ "~%Library.Serial")){
        Set isInDepthReference = (referenceDepth > 1)
        Return "REFERENCE:"_type.Name 
    }
    Return "VARCHAR"
}

ClassMethod GenGlobal()
{
    K @..#TypeGlobal
    Set args = 0
    Set qres = $$$ExecQuery(..#GlobalGenQuery, $$$InstallationNamespace, args...)
    while(qres.%Next()){
        Set @..#TypeGlobal@(qres.ID) = qres.odbcType
    }
    D ..CustomOverrides()
}

ClassMethod CustomOverrides()
{
    Set @..#TypeGlobal@("%Library.GlobalCharacterStream")="CLOB"
    Set @..#TypeGlobal@("%Stream.GlobalBinary")="CLOB"
}

ClassMethod IsGlobalGenerated() As %Boolean
{
    Return $ORDER(@..#TypeGlobal@("")) '= ""
}

ClassMethod GetODBCType(type As %String(MAXLEN="")) As %String(MAXLEN="")
{
    Return $GET(@..#TypeGlobal@(type))
}

Parameter TypeGlobal = "^RESTUTILSGENERATEDTYPEGLOBAL";

Parameter GlobalGenQuery = {"select "_
    "ID, odbcType "_
    "from %Dictionary.CompiledClass c "_
    "where ID LIKE 'd%Library.%' escape 'd' "_
    "and odbcType is not null"};

}
