Class IBSP.Notice.REST.Notify.Request.NotifyRequest Extends (%Persistent, %XML.Adaptor, %JSON.Adaptor)
{

Property resource As %String(MAXLEN = "");

Property action As %String(MAXLEN = "");

Property userIdType As %String(MAXLEN = "");

Property userIdCode As %String(MAXLEN = "");

/// Necessary data (in JSON format) to build the notification
Property data As %String(MAXLEN = "");

Storage Default
{
<Data name="NotifyRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>resource</Value>
</Value>
<Value name="3">
<Value>action</Value>
</Value>
<Value name="4">
<Value>userIdType</Value>
</Value>
<Value name="5">
<Value>userIdCode</Value>
</Value>
<Value name="6">
<Value>data</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice651D.NotifyRequestD</DataLocation>
<DefaultData>NotifyRequestDefaultData</DefaultData>
<IdLocation>^IBSP.Notice651D.NotifyRequestD</IdLocation>
<IndexLocation>^IBSP.Notice651D.NotifyRequestI</IndexLocation>
<StreamLocation>^IBSP.Notice651D.NotifyRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
