/// Persistent Class with the lists of subcriptions that any subscriptor has
Class IBSP.Notice.DAT.Subscription Extends (%Persistent, Form.Adaptor)
{

Parameter FORMNAME = "Subscription";

Parameter DISPLAYPROPERTY = "Topic";

Parameter FORMORDERBY = "Topic";

/// Subscriber
Property Subscriber As IBSP.Notice.DAT.Subscriber(%JSONREFERENCE = "ID");

/// Topic subscribed
Property Topic As %String(MAXLEN = "");

ForeignKey FKSubscriber(Subscriber) References IBSP.Notice.DAT.Subscriber() [ SqlName = FK_Subscription_Subcriber ];

/// Necessary for RESTForms2. This query is called when the "list" URL is invoked
ClassMethod queryLIST() As %String
{
    quit "%id _id, " _
         "Topic "
}

Storage Default
{
<Data name="SubscriptionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Subscriber</Value>
</Value>
<Value name="3">
<Value>Topic</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice.DAT.SubscriptionD</DataLocation>
<DefaultData>SubscriptionDefaultData</DefaultData>
<IdLocation>^IBSP.Notice.DAT.SubscriptionD</IdLocation>
<IndexLocation>^IBSP.Notice.DAT.SubscriptionI</IndexLocation>
<StreamLocation>^IBSP.Notice.DAT.SubscriptionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
