Class IBSP.Notice.REST.Response.ErrorResponse Extends IBSP.Notice.REST.Response.AbstractResponse
{

Property errorMessage As %String(MAXLEN = "");

Method %OnNew(errorMessage As %String) As %Status [ Private ]
{
    set ..errorMessage = errorMessage
    quit $$$OK
}

Storage Default
{
<Data name="ErrorResponseState">
<Value name="1">
<Value>errorMessage</Value>
</Value>
</Data>
<State>ErrorResponseState</State>
<StreamLocation>^IBSP.Notice5BCA.ErrorResponseS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
