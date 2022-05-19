Class IBSP.Notice.BS.RetrieveData.APIBusinessService Extends IBSP.Notice.BS.AbstractBusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property Adapter As Ens.InboundAdapter;

Property Method As %String(VALUELIST = ",POST,GET");

Property HTTPServer As %String;

Property HTTPPort As %Integer;

Property URL As %String;

Property ContentType As %String [ InitialExpression = "application/json" ];

Property ContentCharset As %String [ InitialExpression = "UTF-8" ];

Property Credentials As %String;

Property Body As %String(MAXLEN = "");

Property URLParams As %String(MAXLEN = "");

Property SSL As %Boolean;

Parameter SETTINGS = "Topic:Notification,SendIfPublished:Notification,Method:API Configuration,HTTPServer:API Configuration,HTTPPort:API Configuration,URL:API Configuration,ContentType:API Configuration,ContentCharset:API Configuration,Credentials:API Configuration:credentialsSelector,Body:API Configuration,URLParams:API Configuration,SSL:API Configuration";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
    $$$QuitOnError(..GetDataFromApi(.apiResponse))
    return ..Notify(apiResponse)
}

Method GetDataFromApi(Output apiResponse As EnsLib.HTTP.GenericMessage) As %Status [ Internal, Private ]
{
    set request = ..BuildRequest()
    set target = ..GetTarget()

    return ..SendRequestSync(target, request, .apiResponse)
}

Method BuildRequest(Output request As EnsLib.HTTP.GenericMessage) As EnsLib.HTTP.GenericMessage [ Internal, Private ]
{
    set headers = ..GetHeaders()
    set body = ..GetBody()

    return ##class(EnsLib.HTTP.GenericMessage).%New(body, , headers)
}

Method GetHeaders() As %ArrayOfDataTypes [ Internal, Private ]
{
    set headers = ##class(%ArrayOfDataTypes).%New()

    do headers.SetAt(..Method, "Method")
    do headers.SetAt(..HTTPServer, "HTTPServer")
    do headers.SetAt(..HTTPPort, "HTTPPort")
    do headers.SetAt(..GetURL(), "URL")
    do headers.SetAt(..ContentType, "ContentType")
    do headers.SetAt(..ContentCharset, "ContentCharset")
    do headers.SetAt(..Credentials, "Credentials")

    return headers
}

Method GetURL() As %String [ Internal, Private ]
{
    return:$$$IsGet(..Method) ..URL _ "?" _ ..URLParams
    return ..URL
}

Method GetBody() As %Stream.GlobalCharacter [ Internal, Private ]
{
    set body = ##class(%Stream.GlobalCharacter).%New()
    do:$$$IsPost(..Method) body.Write(..Body)

    return body
}

Method GetTarget() As %String [ Internal, Private ]
{
    return:..SSL "IBSP.Notice.BO.RetrieveData.HTTPSBusinessOperation"
    return "IBSP.Notice.BO.RetrieveData.HTTPBusinessOperation"
}

Method Notify(apiResponse As EnsLib.HTTP.GenericMessage) As %Status [ Internal, Private ]
{
    set jsonResponse = {}.%FromJSON(apiResponse.Stream)
    set data = jsonResponse.data
    return:(data = "") $$$OK

    set iterData = data.%GetIterator()

    while iterData.%GetNext(.key, .value, .type) {
        $$$ReturnOnError(..CreateRequestAndSendToPublisher(value))
    }

    return $$$OK
}

Method GetValuesFromData(data As %RegisteredObject, ByRef values As %DynamicObject, parentObjName As %String = "") As %Status [ Internal, Private ]
{
    set iter = data.%GetIterator()

    while iter.%GetNext(.key, .value, .type) {

        set paramName = key
        set:(parentObjName '= "") paramName = parentObjName _ "_" _ paramName

        if $$$IsObjectOrArray(type) {
            do ..GetValuesFromData(value, .values, paramName)
        } else {
            do values.%Set(paramName, value)
        }
    }

    return $$$OK
}

}
