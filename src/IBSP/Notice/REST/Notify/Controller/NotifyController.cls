Class IBSP.Notice.REST.Notify.Controller.NotifyController Extends IBSP.Notice.REST.AbstractController
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/:resource" Method="POST" Call="NotifyResource"/>
<Route Url="/:resource/:action" Method="POST" Call="NotifyResourceAction"/>
</Routes>
}

ClassMethod NotifyResource(resource As %String) As %Status
{
    return ..Notify(resource)
}

ClassMethod NotifyResourceAction(resource As %String, action As %String) As %Status
{
    return ..Notify(resource, action)
}

ClassMethod Notify(resource As %String, action As %String = "-") As %Status [ Internal, Private ]
{
    set request = ..BuildRequest(resource, action)
    set response = ##class(IBSP.Notice.REST.Notify.Service.NotifyService).Notify(request)

    do ##class(IBSP.Notice.REST.Notify.Service.NotifyService).%WriteResponse(response)

    return $$$OK
}

ClassMethod BuildRequest(resource As %String, action As %String = "-") As IBSP.Notice.REST.Notify.Request.NotifyRequest [ Internal, Private ]
{
    set request = ##class(IBSP.Notice.REST.Notify.Request.NotifyRequest).%New()

    set requestJSON = {}.%FromJSON(%request.Content)
    set userIdType = requestJSON.%Remove("userIdType")
    set userIdCode = requestJSON.%Remove("userIdCode")
    do requestJSON.%Set(userIdType, userIdCode)

    set request.resource = resource
    set request.action = action
    set request.userIdType = userIdType
    set request.userIdCode = userIdCode
    set request.data = requestJSON.%ToJSON()

    return request
}

}
