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
<Map Prefix="/subscriber" Forward="IBSP.Notice.REST.Subscriber.Controller.SubscriberController"/>
<Map Prefix="/notify" Forward="IBSP.Notice.REST.Notify.Controller.NotifyController"/>
<Route Url="/test" Method="POST" Call="Test"/>
<Route Url="/test" Method="GET" Call="TestGet"/>
</Routes>
}

ClassMethod Test() As %Status
{
    set responseObj = {}.%FromJSON(%request.Content)
    set responseObj.obj = {}
    set responseObj.obj.a = "1"
    set responseObj.obj.b = 2
    set responseObj.data = []
    set responseObj.data."0" = {}
    set responseObj.data."0".a = "AAA"
    set responseObj.data."0".b = "123"
    set responseObj.data."1" = {}
    set responseObj.data."1".a = "BBB"
    set responseObj.data."1".b = "456"

    set response = responseObj.%ToJSON()

    write response
    quit $$$OK
}

ClassMethod TestGet() As %Status
{
    set name = %request.Get("name")
    set surname = %request.Get("surname")
    set cip = %request.Get("cip")

    set responseObj = {}
    set responseObj.a = name
    set responseObj.b = surname
    set responseObj.c = cip

    set response = responseObj.%ToJSON()

    write response
    quit $$$OK
}

}
