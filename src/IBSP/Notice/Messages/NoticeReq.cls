Class IBSP.Notice.Messages.NoticeReq Extends Ens.Request
{

/// Topic where the notification will be thrown at
Property Topic As %String;

/// Text to notify
Property Text As %String(MAXLEN = 4000);

Property SendIfPublished As %String;

Property Element As %String;

Property Subject As %String(MAXLEN = 200);

Property ManagerNotification As %Boolean [ InitialExpression = 0 ];

Storage Default
{
<Data name="NoticeReqDefaultData">
<Subscript>"NoticeReq"</Subscript>
<Value name="1">
<Value>Topic</Value>
</Value>
<Value name="2">
<Value>Text</Value>
</Value>
<Value name="3">
<Value>SendIfPublished</Value>
</Value>
<Value name="4">
<Value>Element</Value>
</Value>
<Value name="5">
<Value>Subject</Value>
</Value>
<Value name="6">
<Value>ManagerNotification</Value>
</Value>
</Data>
<DefaultData>NoticeReqDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
