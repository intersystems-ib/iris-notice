Class IBSP.Notice.REST.Subscriber.Controller.SubscriberController Extends IBSP.Notice.REST.AbstractController
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="" Method="POST" Call="CreateSubscriber"/>
<Route Url="" Method="PUT" Call="UpdateSubscriber"/>
<Route Url="" Method="GET" Call="GetSubscriber"/>
<Route Url="" Method="DELETE" Call="DeleteSubscriber"/>
</Routes>
}

ClassMethod CreateSubscriber() As %Status
{
    set request = ##class(IBSP.Notice.REST.Subscriber.Request.CreateSubscriberRequest).%New()
    $$$QuitOnError(request.%JSONImport(%request.Content))

    set response = ##class(IBSP.Notice.REST.Subscriber.Service.SubscriberService).CreateSubscriber(request)
    do ##class(IBSP.Notice.REST.Subscriber.Service.SubscriberService).%WriteResponse(response)

    return $$$OK
}

ClassMethod UpdateSubscriber() As %Status
{
    set request = ##class(IBSP.Notice.REST.Subscriber.Request.UpdateSubscriberRequest).%New()
    $$$QuitOnError(request.%JSONImport(%request.Content))

    set response = ##class(IBSP.Notice.REST.Subscriber.Service.SubscriberService).UpdateSubscriber(request)
    do ##class(IBSP.Notice.REST.Subscriber.Service.SubscriberService).%WriteResponse(response)

    return $$$OK
}

ClassMethod GetSubscriber() As %Status
{
    set cip = %request.Get($$$CIP)
    set applicationid = %request.Get($$$ApplicationId)
    //return:('..IsValidCIP(cip)) ..ReturnHttpBadRequest()
    return:((cip = "") && (applicationid = "")) ..ReturnHttpBadRequest()

    set response = ##class(IBSP.Notice.REST.Subscriber.Service.SubscriberService).GetSubscriber(cip, applicationid)
    do ##class(IBSP.Notice.REST.Subscriber.Service.SubscriberService).%WriteResponse(response)

    return $$$OK
}

ClassMethod DeleteSubscriber() As %Status
{
    set cip = %request.Get($$$CIP)
    return:('..IsValidCIP(cip)) ..ReturnHttpBadRequest()

    set response = ##class(IBSP.Notice.REST.Subscriber.Service.SubscriberService).DeleteSubscriber(cip)
    do ##class(IBSP.Notice.REST.Subscriber.Service.SubscriberService).%WriteResponse(response)

    return $$$OK
}

ClassMethod IsValidCIP(cip As %String) As %Boolean [ Internal, Private ]
{
    /*return:(cip = "") $$$NO
    return $match(cip, $$$ValidCIPRegularExpression)*/
    return cip '= ""
}

ClassMethod ReturnHttpBadRequest() As %Status [ Internal, Private ]
{

    set error = ##class(IBSP.Notice.REST.Subscriber.Response.ExecutionResponse).%New()
    set error.result = $$$ERRORSTATUS
    //set errorMessage = "CIP parameter is required and must have the folling format: 4 letters, followed by a '0' or a '1' and 9 more digits"
    set errorMessage = "cip or applicationid parameters are required"
    set response = ##class(IBSP.Notice.REST.Subscriber.Response.ErrorResponse).%New(errorMessage)
    set error.response = response

    set %response.Status = ..#HTTP400BADREQUEST

    do error.%JSONExportToString(.errorString)

    write errorString
    return $$$OK
}

}
