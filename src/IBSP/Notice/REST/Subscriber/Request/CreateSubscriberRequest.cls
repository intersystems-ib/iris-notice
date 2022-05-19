Class IBSP.Notice.REST.Subscriber.Request.CreateSubscriberRequest Extends (%Persistent, %XML.Adaptor, %JSON.Adaptor)
{

Property name As %String(MAXLEN = "");

Property surname As %String(MAXLEN = "");

Property language As %String;

Property applicationId As %String(MAXLEN = "");

Property cip As %String(MAXLEN = "");

Property topics As list Of %String(MAXLEN = "");

Storage Default
{
<Data name="CreateSubscriberRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
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
<DataLocation>^IBSP.Notic2F5C.CreateSubscE055D</DataLocation>
<DefaultData>CreateSubscriberRequestDefaultData</DefaultData>
<IdLocation>^IBSP.Notic2F5C.CreateSubscE055D</IdLocation>
<IndexLocation>^IBSP.Notic2F5C.CreateSubscE055I</IndexLocation>
<StreamLocation>^IBSP.Notic2F5C.CreateSubscE055S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
