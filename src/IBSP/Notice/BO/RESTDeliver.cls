Class IBSP.Notice.BO.RESTDeliver Extends (EnsLib.REST.Operation, Ens.BusinessOperation, IBSP.Notice.BO.NoticeDeliver)
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Property Token As %String(MAXLEN = "");

Parameter SETTINGS = "Token:Basic";

Parameter AuthHeader = "Authorization";

Parameter ApplicationJson = "application/json";

Parameter UTF8 = "UTF-8";

Method SendMessage(request As IBSP.Notice.Request.RESTNoticeRequest, Output response As %RegisteredObject) As %Status
{
	set result = "OK"
    set httpResponseData = {}

    try {

		$$$ThrowOnError(..BuildHttpRequest(request, .httpRequest))
        $$$ThrowOnError(..Adapter.SendFormData(.httpResponse, "POST", httpRequest))

        set:(httpResponse.Data '= "") httpResponseData = {}.%FromJSON(httpResponse.Data)
        set httpResponseData.ok = $$$YES
    } catch ex {

        set result = "ERROR"

        set httpResponseData = {}
        set httpResponseData.ok = $$$NO
        set httpResponseData.errorMessage = ex.DisplayString()
    }

    set response = ##class(IBSP.Notice.Messages.NoticeRes).%New()
	set response.result = result

    return ..SaveNotification(request, httpResponseData)
}

Method BuildHttpRequest(request As IBSP.Notice.Request.RESTNoticeRequest, Output httpRequest As %Net.HttpRequest) As %Status [ Internal, Private ]
{
    set httpRequest = ##class(%Net.HttpRequest).%New()
    set httpRequest.ContentType = ..#ApplicationJson
    set httpRequest.ContentCharset = ..#UTF8

    $$$QuitOnError(..SetAuthorizationToken(.httpRequest))

    return ..SetBody(request, .httpRequest)
}

Method SetAuthorizationToken(Output httpRequest As %Net.HttpRequest) As %Status [ Internal, Private ]
{
    return:(..Token = "") $$$OK

    set bearerToken = "Bearer " _ ..Token
    return httpRequest.SetHeader(..#AuthHeader, bearerToken)
}

Method SetBody(request As IBSP.Notice.Request.RESTNoticeRequest, Output httpRequest As %Net.HttpRequest) As %Status [ Internal, Private ]
{
    set textJSON = {}.%FromJSON(request.Text)
    do textJSON.%Set(request.Topic.ContactWay, request.ContactWayAddress)
    set text = textJSON.%ToJSON()

    return httpRequest.EntityBody.Write(text)
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="IBSP.Notice.Request.RESTNoticeRequest"> 
		<Method>SendMessage</Method>
	</MapItem>
</MapItems>
}

}
