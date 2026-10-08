Include (RESTUtils.INC.Authorization, RESTUtils.INC.Providers, RESTUtils.INC.Utils)

/// Hardcoded the compile after, haven't found another option
Class RESTUtils.Service.Authorization.AuthorizationService [ CompileAfter = RESTUtils.Persistent.Authorization.AuthorizationDefinition ]
{

/// Checks if the user is allowed, by default will iterate through any matched authorizations until one matches
ClassMethod UserIsAllowed(class As %String(MAXLEN=""), endpoint As %String(MAXLEN=""), namespace As %String(MAXLEN="") = "", needsWrite As %Boolean = 0, Output authMatched As RESTUtils.Persistent.Authorization.AuthorizationDefinition = "") As %Boolean
{
    Set:(namespace = "") namespace = $NAMESPACE
    ///Allow everything for superUsers
    Return:(..UserIsAll()) 1
    ///Always block auth class for non-superUsers 
    Return:(class = "RESTUtils.Authorization.Authorization") 0
    //TODO remove this to enable the service
    Return 1
    Set args($I(args)) = class_","
    Set args($I(args)) = endpoint_","
    Set args($I(args)) = namespace
    Set qres = $$$ExecQuery(..IsAllowedQuery(), $$$InstallationNamespace, args...)
    while(qres.%Next()){
        Set authMatched = $CLASSMETHOD($$$AuthPersistance, "%OpenId", qres.Id)
        Return:(..UserHasResource(authMatched.IRISResource)) 1
    }
    Set authMatched = ""
    Return 0
}

ClassMethod UserIsAll() As %Boolean
{
    Return ##Class(%SYSTEM.Security).CheckUserPermission($USERNAME, "%All", "READ,WRITE,USE")
}

ClassMethod GetEverythingUserIsAllowed(verbose As %Boolean = 0) As %DynamicObject
{
    $$$SwapToInstallationNamespace
    Set result = {}
    Set qres = $$$ExecQuery(..GetAllQuery(), $$$InstallationNamespace, args...)
    while(qres.%Next()){
        Set perm = {}
        If (..UserHasResource(qres.IRISResource)){
            Set perm.AllowedEndpoints = ..ListToArray($LISTFROMSTRING(qres.AllowedEndpoints))
            Set perm.AllowedJSONMappings = ..ListToArray($LISTFROMSTRING(qres.AllowedJSONMappings))
            Set perm.Classes = ..ListToArray($LISTFROMSTRING(qres.ListOfClasses))
            Set perm.Namespace = qres.Namespace
            Do result.%Set(qres.Name, perm)
        }
    }
    Return result
}

ClassMethod IsValidMappingName(auth As RESTUtils.Persistent.Authorization.AuthorizationDefinition, JSONMappingName As %String(MAXLEN="") = "") As %Boolean
{
    Return:(auth.AllowedJSONMappings = "*") 1
    Set AllowedJSONMappingsList = $LISTTOSTRING(auth.AllowedJSONMappings)
    Return:(($LISTFIND(AllowedJSONMappingsList, $$$DefaultMappingNameKey)) && (JSONMappingName = ""))
    Return $LISTFIND(AllowedJSONMappingsList, JSONMappingName)'=0
}

ClassMethod UserHasResource(IRISResource As %String(MAXLEN=""))
{
    Return ((IRISResource = "") || (##Class(%SYSTEM.Security).CheckUserPermission($USERNAME, IRISResource, "READ,WRITE")) = 1)
}

ClassMethod ListToArray(list As %List) As %DynamicArray
{
    Return:(list="") []
    Return [].%FromJSON("["""_$LISTTOSTRING(list, """,""")_"""]")
}

// Queries

ClassMethod IsAllowedQuery() As %String(MAXLEN="")
{
 
    Return "select ID Id from "_$$$AuthPersistanceTable_" where ? LIKE "_
    " CalculatedClassList and ? LIKE CalculatedAllowedEndpoints and namespace = ?"
}

ClassMethod GetAllQuery() As %String(MAXLEN="")
{
    Return "select "_
    "(select list(ID) from %Dictionary.CompiledClass cc "_
    "where Super like '%Persistent%' "_
    "and Name Not like 'd%%' escape 'd' "_
    "and (cc.Name||',') LIKE au.CalculatedClassList "_
    ") as ListOfClasses, "_
    "IRISResource, AllowedEndpoints, AllowedJSONMappings, Name, namespace As Namespace "_
    "from "_$$$AuthPersistanceTable_" au"
}

}
