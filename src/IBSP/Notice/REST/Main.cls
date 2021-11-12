Include notice

Class IBSP.Notice.REST.Main Extends %CSP.REST
{

Parameter CONTENTTYPE = "application/json";

Parameter CHARSET = "UTF-8";

Parameter UseSession As Integer = 1;

Parameter CONVERTINPUTSTREAM = 1;

Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/subscriber" Method="POST" Call="createSubscriber"/>
<Route Url="/subscriber" Method="PUT" Call="updateSubscriber"/>
<Route Url="/subscriber" Method="GET" Call="getSubscriber"/>
<Route Url="/subscriber" Method="DELETE" Call="deleteSubscriber"/>
</Routes>
}

ClassMethod createSubscriber() As %Status
{
    set sc = $$$OK

    try {

        set request = ##class(IBSP.Notice.REST.Request.CreateSubscriberRequest).%New()
        $$$ThrowOnError(request.%JSONImport(%request.Content))

        set response = ##class(IBSP.Notice.REST.Service.SubscriberService).createSubscriber(request)
        do ##class(IBSP.Notice.REST.Service.SubscriberService).%WriteResponse(response)
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod updateSubscriber() As %Status
{
    set sc = $$$OK

    try {

        set request = ##class(IBSP.Notice.REST.Request.UpdateSubscriberRequest).%New()
        $$$ThrowOnError(request.%JSONImport(%request.Content))

        set response = ##class(IBSP.Notice.REST.Service.SubscriberService).updateSubscriber(request)
        do ##class(IBSP.Notice.REST.Service.SubscriberService).%WriteResponse(response)
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod getSubscriber() As %Status
{
    set sc = $$$OK

    try {

        set cip = %request.Get($$$CIP)
        set applicationid = %request.Get($$$ApplicationId)
        //if '..isValidCIP(cip) {
        if (cip = "") && (applicationid = "") {
            do ..returnHttpBadRequest()
            quit
        }

        set response = ##class(IBSP.Notice.REST.Service.SubscriberService).getSubscriber(cip, applicationid)
        do ##class(IBSP.Notice.REST.Service.SubscriberService).%WriteResponse(response)
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod deleteSubscriber() As %Status
{
    set sc = $$$OK

    try {

        set cip = %request.Get($$$CIP)
        if '..isValidCIP(cip) {
            do ..returnHttpBadRequest()
            quit
        }

        set response = ##class(IBSP.Notice.REST.Service.SubscriberService).deleteSubscriber(cip)
        do ##class(IBSP.Notice.REST.Service.SubscriberService).%WriteResponse(response)
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod isValidCIP(cip As %String) As %Boolean [ Private ]
{
    /*quit:(cip = "") $$$NO
    quit $match(cip, $$$ValidCIPRegularExpression)*/
    quit cip '= ""
}

ClassMethod returnHttpBadRequest() As %Status
{

    set error = ##class(IBSP.Notice.REST.Response.ExecutionResponse).%New()
    set error.result = $$$ERRORSTATUS
    //set errorMessage = "CIP parameter is required and must have the folling format: 4 letters, followed by a '0' or a '1' and 9 more digits"
    set errorMessage = "cip or applicationid parameters are required"
    set response = ##class(IBSP.Notice.REST.Response.ErrorResponse).%New(errorMessage)
    set error.response = response

    set %response.Status = ..#HTTP400BADREQUEST

    do error.%JSONExportToString(.errorString)

    write errorString
    quit $$$OK
}

}
