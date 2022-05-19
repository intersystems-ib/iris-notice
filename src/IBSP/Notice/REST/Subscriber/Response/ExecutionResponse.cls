Class IBSP.Notice.REST.Subscriber.Response.ExecutionResponse Extends (%Persistent, %XML.Adaptor, %JSON.Adaptor)
{

Property result As %Integer;

Property response As IBSP.Notice.REST.Subscriber.Response.AbstractResponse;

Storage Default
{
<Data name="ExecutionResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>result</Value>
</Value>
<Value name="3">
<Value>response</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notic1EB3.ExecutionReE2A0D</DataLocation>
<DefaultData>ExecutionResponseDefaultData</DefaultData>
<IdLocation>^IBSP.Notic1EB3.ExecutionReE2A0D</IdLocation>
<IndexLocation>^IBSP.Notic1EB3.ExecutionReE2A0I</IndexLocation>
<StreamLocation>^IBSP.Notic1EB3.ExecutionReE2A0S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
