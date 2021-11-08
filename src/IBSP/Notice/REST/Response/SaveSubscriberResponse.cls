Class IBSP.Notice.REST.Response.SaveSubscriberResponse Extends IBSP.Notice.REST.Response.AbstractResponse
{

Property id As %BigInt;

Method %OnNew(id As %BigInt) As %Status [ Private ]
{
    set ..id = id
    quit $$$OK
}

Storage Default
{
<Data name="SaveSubscriberResponseState">
<Value name="1">
<Value>id</Value>
</Value>
</Data>
<State>SaveSubscriberResponseState</State>
<StreamLocation>^IBSP.Notic5BCA.SaveSubscriB03CS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
