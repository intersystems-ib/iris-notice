Include RESTUtils.INC.Utils

Class RESTUtils.Installation.RoleGenerator
{

Parameter RESTUTILSBaseUserRole = "restutils-base-role";

Parameter RESTUTILSBaseUserRoleDescription = "Auto generated role for basic use of RESTUtils, do not modify. Can be recreated by deleting and running ##class(RESTUtils.Installation.RoleGenerator).GenerateRole()";

ClassMethod CreateSQLPrivilege(Grantable, Grantee, Grantor, Namespace, Privilege, SQLObject) As %Status
{
    NEW $NAMESPACE
    ZN "%SYS"
    Set prv = ##Class(Security.SQLPrivileges).%New()
    Set prv.Grantable = Grantable
    Set prv.Grantee = Grantee
    Set prv.Grantor = Grantor
    Set prv.Namespace = Namespace
    Set prv.Privilege = Privilege
    Set prv.SQLObject = SQLObject
    Return prv.%Save()
}

ClassMethod GetNamespaceResource() As %String(MAXLEN="")
{
    D ##Class(%SYS.Namespace).GetNSInfo($NAMESPACE,.info)
    Return $GET(info("Resource"))
}

ClassMethod GenerateRole() As %Status
{
    TSTART
    Set namespace = $NAMESPACE
    Set resource = ..GetNamespaceResource()
    NEW $NAMESPACE
    ZN "%SYS"
    Try{
        If (##Class(Security.Roles).Exists(..#RESTUTILSBaseUserRole) = 0){
            THROW:(resource = "") ##Class(%Exception.General).%New("Failed to find resource", "Failed to find resource of Namespace" _ $NAMESPACE)
            $$$ThrowOnError(##Class(Security.Roles).Create(..#RESTUTILSBaseUserRole, ..#RESTUTILSBaseUserRoleDescription, resource_":R"))
            $$$ThrowOnError(..CreateSQLPrivilege("0",..#RESTUTILSBaseUserRole,"_SYSTEM",namespace,"s","1,RESTUtils_Persistent_Log.LogDefinition"))
            $$$ThrowOnError(..CreateSQLPrivilege("0",..#RESTUTILSBaseUserRole,"_SYSTEM",namespace,"d","1,RESTUtils_Persistent_Log.Log"))
            $$$ThrowOnError(..CreateSQLPrivilege("0",..#RESTUTILSBaseUserRole,"_SYSTEM",namespace,"i","1,RESTUtils_Persistent_Log.Log"))
            $$$ThrowOnError(..CreateSQLPrivilege("0",..#RESTUTILSBaseUserRole,"_SYSTEM",namespace,"r","1,RESTUtils_Persistent_Log.Log"))
            $$$ThrowOnError(..CreateSQLPrivilege("0",..#RESTUTILSBaseUserRole,"_SYSTEM",namespace,"s","1,RESTUtils_Persistent_Log.Log"))
            $$$ThrowOnError(..CreateSQLPrivilege("0",..#RESTUTILSBaseUserRole,"_SYSTEM",namespace,"u","1,RESTUtils_Persistent_Log.Log"))
            $$$ThrowOnError(..CreateSQLPrivilege("0",..#RESTUTILSBaseUserRole,"_SYSTEM",namespace,"d","1,RESTUtils_Service_Log_Helper.LogInfo"))
            $$$ThrowOnError(..CreateSQLPrivilege("0",..#RESTUTILSBaseUserRole,"_SYSTEM",namespace,"i","1,RESTUtils_Service_Log_Helper.LogInfo"))
            $$$ThrowOnError(..CreateSQLPrivilege("0",..#RESTUTILSBaseUserRole,"_SYSTEM",namespace,"s","1,RESTUtils_Service_Log_Helper.LogInfo"))
            $$$ThrowOnError(..CreateSQLPrivilege("0",..#RESTUTILSBaseUserRole,"_SYSTEM",namespace,"u","1,RESTUtils_Service_Log_Helper.LogInfo"))
            W !,"Created role "_ ..#RESTUTILSBaseUserRole, !
        }
    }Catch e {
        TROLLBACK
        THROW e
    }
    TCOMMIT
    Return $$$OK
}

}
