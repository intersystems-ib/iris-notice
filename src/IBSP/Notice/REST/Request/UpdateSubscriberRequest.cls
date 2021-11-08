Class IBSP.Notice.REST.Request.UpdateSubscriberRequest Extends (%Persistent, %XML.Adaptor, %JSON.Adaptor)
{

Property name As %String(MAXLEN = "");

Property surname As %String(MAXLEN = "");

Property language As %String;

Property applicationId As %String(MAXLEN = "");

Property cip As %String(MAXLEN = "");

Property topicsToAdd As list Of %String(MAXLEN = "");

Property topicsToDelete As list Of %String(MAXLEN = "");

Storage Default
{
<Data name="UpdateSubscriberRequestDefaultData">
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
<Value>topicsToAdd</Value>
</Value>
<Value name="8">
<Value>topicsToDelete</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notic16AF.UpdateSubsc6E80D</DataLocation>
<DefaultData>UpdateSubscriberRequestDefaultData</DefaultData>
<IdLocation>^IBSP.Notic16AF.UpdateSubsc6E80D</IdLocation>
<IndexLocation>^IBSP.Notic16AF.UpdateSubsc6E80I</IndexLocation>
<StreamLocation>^IBSP.Notic16AF.UpdateSubsc6E80S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
