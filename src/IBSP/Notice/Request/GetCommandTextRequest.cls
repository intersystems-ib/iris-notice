Class IBSP.Notice.Request.GetCommandTextRequest Extends Ens.Request
{

Property Topic As IBSP.Notice.DAT.Topic;

Property Parameters As %String(MAXLEN = "");

Property Subscriber As IBSP.Notice.DAT.Subscriber;

Storage Default
{
<Data name="GetCommandTextRequestDefaultData">
<Subscript>"GetCommandTextRequest"</Subscript>
<Value name="1">
<Value>Topic</Value>
</Value>
<Value name="2">
<Value>Parameters</Value>
</Value>
<Value name="3">
<Value>Subscriber</Value>
</Value>
</Data>
<DefaultData>GetCommandTextRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
