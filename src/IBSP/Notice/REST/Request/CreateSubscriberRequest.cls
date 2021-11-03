Class IBSP.Notice.REST.Request.CreateSubscriberRequest Extends (%Persistent, %XML.Adaptor, %JSON.Adaptor)
{

Property name As %String(MAXLEN = "");

Property surname As %String(MAXLEN = "");

Property language As %String(VALUELIST = ",en,es,ca") [ InitialExpression = "ca" ];

Property applicationId As %String(MAXLEN = "");

Property cip As %String(MAXLEN = "");

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
</Data>
<DataLocation>^IBSP.Notic16AF.CreateSubscE055D</DataLocation>
<DefaultData>CreateSubscriberRequestDefaultData</DefaultData>
<IdLocation>^IBSP.Notic16AF.CreateSubscE055D</IdLocation>
<IndexLocation>^IBSP.Notic16AF.CreateSubscE055I</IndexLocation>
<StreamLocation>^IBSP.Notic16AF.CreateSubscE055S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
