Class IBSP.Notice.REST.Subscriber.Response.SaveSubscriberResponse Extends IBSP.Notice.REST.Subscriber.Response.AbstractResponse
{

Property id As %BigInt;

Method %OnNew(id As %BigInt) As %Status [ Private ]
{
    set ..id = id
    return $$$OK
}

Storage Default
{
<Data name="SaveSubscriberResponseState">
<Value name="1">
<Value>id</Value>
</Value>
</Data>
<State>SaveSubscriberResponseState</State>
<StreamLocation>^IBSP.Notic1EB3.SaveSubscriB03CS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
