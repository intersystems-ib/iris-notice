Class IBSP.Notice.BO.RetrieveData.HTTPBusinessOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method OnMessage(request As EnsLib.HTTP.GenericMessage, Output response As EnsLib.HTTP.GenericMessage) As %Status
{
    #define IsHTTPStatusError(%sc) $$$StatusEquals(%sc, $$$EnsErrHTTPStatus)

    do ..SetAdapterParametersFromRequest(request)
    do ..BuildHttpRequest(request, .httpRequest)

    set method = request.HTTPHeaders.GetAt("Method")

    set sc = ..Adapter.SendFormData(.httpResponse, method, httpRequest)

    return:($$$ISERR(sc) && '$$$IsHTTPStatusError(sc)) sc

    return ..BuildResponse(httpResponse, .response)
}

Method SetAdapterParametersFromRequest(request As EnsLib.HTTP.GenericMessage) As %Status [ Internal, Private ]
{
    set ..Adapter.HTTPServer = request.HTTPHeaders.GetAt("HTTPServer")
    set ..Adapter.HTTPPort = request.HTTPHeaders.GetAt("HTTPPort")
    set ..Adapter.URL = request.HTTPHeaders.GetAt("URL")
    set ..Adapter.Credentials = request.HTTPHeaders.GetAt("Credentials")

    return $$$OK
}

Method BuildHttpRequest(request As EnsLib.HTTP.GenericMessage, Output httpRequest As %Net.HttpRequest) As %Status [ Internal, Private ]
{
    set httpRequest = ##class(%Net.HttpRequest).%New()

    do httpRequest.EntityBody.Write()
    do httpRequest.EntityBody.CopyFrom(request.Stream)

    set httpRequest.ContentType = request.HTTPHeaders.GetAt("ContentType")
    set httpRequest.ContentCharset = request.HTTPHeaders.GetAt("ContentCharset")

    return $$$OK
}

Method BuildResponse(httpResponse As %Net.HttpResponse, Output response As EnsLib.HTTP.GenericMessage) As %Status [ Internal ]
{
    if $IsObject(httpResponse.Data) {
		set stream = httpResponse.Data
	} else {
        set stream = ##class(%Stream.GlobalBinary).%New()
		$$$QuitOnError(stream.Write(httpResponse.Data))
	}

	set response = ##class(EnsLib.HTTP.GenericMessage).%New(stream, , httpResponse)
	do response.HTTPHeaders.SetAt(httpResponse.StatusLine, "StatusLine")

	return $$$OK
}

}
