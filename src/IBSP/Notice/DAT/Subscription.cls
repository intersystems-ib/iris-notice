/// Persistent Class with the lists of subcriptions that any subscriptor has
Class IBSP.Notice.DAT.Subscription Extends (%Persistent, RESTUtils.JSON.Adaptor)
{

/// Subscriber
Property Subscriber As IBSP.Notice.DAT.Subscriber;

/// Topic subscribed
Property Topic As %String(MAXLEN = "");

/// Reminder offsets for expiration topics. Examples: 1d, 2d, 40d.
Property Alerts As list Of %String;

ForeignKey FKSubscriber(Subscriber) References IBSP.Notice.DAT.Subscriber() [ SqlName = FK_Subscription_Subcriber ];

Index IXSubscriber On Subscriber;

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
<Value name="4">
<Value>Alerts</Value>
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
