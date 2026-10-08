Include (RESTUtils.INC.Modification, RESTUtils.INC.OptionsKeys)

Class RESTUtils.Controller.ModifyController Extends RESTUtils.Controller.AbstractController
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/create/:namespace/:class" Method="POST" Call="CreateClass"/>
    <Route Url="/create" Method="POST" Call="Create"/>
    <Route Url="/update/:namespace/:class/:id" Method="PUT" Call="UpdateClass"/>
    <Route Url="/update/:id" Method="PUT" Call="Update"/>
    <Route Url="/delete/:namespace/:class/:id" Method="DELETE" Call="DeleteClass"/>
    <Route Url="/delete/:id" Method="DELETE" Call="Delete"/>
</Routes>
}

// Modify resources endpoints

ClassMethod CreateClass(namespace As %String(MAXLEN=""), class As %String(MAXLEN=""), ByRef options = "") As %Status
{
    Set options($$$OPNAMESPACE) = namespace
    Set options($$$OPCLASS) = class
    Return ..Create(.options)
}

ClassMethod Create(ByRef options = "")
{
    Set id = ""
    Try{
        Do ..StartTime(.options)
        Do ..GetParameters(.options, $$$CreateEndpointParameters)
        Set class = options($$$OPCLASS)
        Set body = ..GetJSONRequestBody()
        Set result = $$$CreateInstance(class, body, .options)
        Set %response.Status = 201
        Do ..PrintResourceToJSON(result)
        Set id = result.Id
    }Catch e {
        Do ..HandleException(e)
    }
    Do ..PostDispatch("CREATE", id, body, .options)
    Return $$$OK
}

ClassMethod UpdateClass(namespace As %String(MAXLEN=""), class As %String(MAXLEN=""), id As %String(MAXLEN=""), ByRef options = "") As %Status
{
    Set options($$$OPNAMESPACE) = namespace
    Set options($$$OPCLASS) = class
    Return ..Update(id, .options)
}

ClassMethod Update(Id As %String(MAXLEN=""), ByRef options = "") As %Status
{
    Try{
        Do ..StartTime(.options)
        Set options($$$OPIDENTIFIER) = Id
        Do ..GetParameters(.options, $$$UpdateEndpointParameters)
        Set class = options($$$OPCLASS)
        Set body = ..GetJSONRequestBody()
        Set result = $$$UpdateInstance(class, Id, body, .options)
        Do ..PrintResourceToJSON(result)
    }Catch e {
        Do ..HandleException(e)
    }
    Do ..PostDispatch("UPDATE", Id, body, .options)
    Return $$$OK
}

ClassMethod DeleteClass(namespace As %String(MAXLEN=""), class As %String(MAXLEN=""), id As %String(MAXLEN=""), ByRef options = "") As %Status
{
    Set options($$$OPNAMESPACE) = namespace
    Set options($$$OPCLASS) = class
    Return ..Delete(id, .options)
}

ClassMethod Delete(Id As %String(MAXLEN=""), ByRef options = "") As %Status
{
    Try{
        Do ..StartTime(.options)
        Set options($$$OPIDENTIFIER) = Id
        Do ..GetParameters(.options, $$$DeleteEndpointPrameters)
        Do $$$DeleteInstance($GET(options($$$OPCLASS)), Id, .options)
    }Catch e {
        Do ..HandleException(e)
    }
    Do ..PostDispatch("DELETE", Id,, .options)
    Return $$$OK
}

// Utils

ClassMethod GetModifyParameters(ByRef options = "", bodyType As %String(VALUELIST=",,JSON"), Output class As %String(MAXLEN=""), Output body As %DynamicObject = "")
{
    Do ..GetOptions(.options, bodyType, $$$ModifyEndpointParameters)
    Set class = options($$$OPCLASS)
    Set:((%request.Method = "POST") || (%request.Method = "PUT")) body = ..GetJSONRequestBody()
}

}
