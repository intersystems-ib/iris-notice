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
<Route Url="/test/:param" Method="GET" Call="testGet"/>
<Route Url="/test" Method="POST" Call="testPost"/>
<Route Url="/subscriber" Method="POST" Call="createSubscriber"/>
</Routes>
}

ClassMethod createSubscriber() As %Status
{
    set sc = $$$OK

    try {

        set response = ##class(IBSP.Notice.REST.Service.SubscriberService).createSubscriber(%request.Content)
        do ##class(IBSP.Notice.REST.Service.SubscriberService).%WriteResponse(response)
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod testGet(param As %String) As %Status
{
    set sc = $$$OK

	try {

        set response = {}
        set response.message = "Get called with param value " _ param

        do response.%ToJSON()
	} catch ex {
		set sc = ex.AsStatus()
	}

	quit sc
}

ClassMethod testPost() As %Status
{
    set sc = $$$OK

	try {

		set request = ##class(%DynamicObject).%FromJSON(%request.Content)

        set response = {}
        set response.message = "Post called with param value " _ request.param

        do response.%ToJSON()
	} catch ex {
		set sc = ex.AsStatus()
	}

	quit sc
}

}
