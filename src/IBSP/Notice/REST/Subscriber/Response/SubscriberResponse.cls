Class IBSP.Notice.REST.Subscriber.Response.SubscriberResponse Extends IBSP.Notice.REST.Subscriber.Response.AbstractResponse
{

Property id As %BigInt;

Property name As %String(MAXLEN = "");

Property surname As %String(MAXLEN = "");

Property language As %String;

Property applicationId As %String(MAXLEN = "");

Property cip As %String(MAXLEN = "");

Property topics As list Of %String(MAXLEN = "");

Storage Default
{
<Data name="SubscriberResponseState">
<Value name="1">
<Value>id</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
<Value name="3">
<Value>surname</Value>
</Value>
<Value name="4">
<Value>language</Value>
</Value>
<Value name="5">
<Value>applicationId</Value>
</Value>
<Value name="6">
<Value>cip</Value>
</Value>
<Value name="7">
<Value>topics</Value>
</Value>
</Data>
<State>SubscriberResponseState</State>
<StreamLocation>^IBSP.Notic1EB3.SubscriberR72F2S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
