Class IBSP.Notice.Messages.SubscriberDeliverReq Extends Ens.Request
{

/// Production target where we will send the request
Property Target As %String;

/// Subscriptor name
Property Name As %String;

/// Subscriptor surname
Property SurName As %String;

/// Notice with the info to notify
Property Notice As IBSP.Notice.Messages.NoticeReq;

/// Subscriber
Property Subscriber As IBSP.Notice.DAT.Subscriber;

Storage Default
{
<Data name="SubscriberDeliverReqDefaultData">
<Subscript>"SubscriberDeliverReq"</Subscript>
<Value name="1">
<Value>Target</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>SurName</Value>
</Value>
<Value name="4">
<Value>Notice</Value>
</Value>
<Value name="5">
<Value>Subscriber</Value>
</Value>
</Data>
<DefaultData>SubscriberDeliverReqDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
