Class IBSP.Notice.REST.Subscriber.Response.ErrorResponse Extends IBSP.Notice.REST.Subscriber.Response.AbstractResponse
{

Property errorMessage As %String(MAXLEN = "");

Method %OnNew(errorMessage As %String) As %Status [ Private ]
{
    set ..errorMessage = errorMessage
    return $$$OK
}

Storage Default
{
<Data name="ErrorResponseState">
<Value name="1">
<Value>errorMessage</Value>
</Value>
</Data>
<State>ErrorResponseState</State>
<StreamLocation>^IBSP.Notice1EB3.ErrorResponseS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
