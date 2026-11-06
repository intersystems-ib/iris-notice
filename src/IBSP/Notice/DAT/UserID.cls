/// Persitent Class for list of IDs of a Subscriber
Class IBSP.Notice.DAT.UserID Extends (%Persistent, RESTUtils.JSON.Adaptor)
{

/// Subscriber
Property Subscriber As IBSP.Notice.DAT.Subscriber;

/// Type of UserId
Property Type As IBSP.Notice.DAT.UserIDType;

/// Code of User
Property Code As %String(MAXLEN = "");

ForeignKey FKSubscriber(Subscriber) References IBSP.Notice.DAT.Subscriber() [ SqlName = FK_UserID_Subcriber ];

Index IXSubscriber On Subscriber;

Index IXSubscriberType On (Subscriber, Type);

Storage Default
{
<Data name="UserIDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Subscriber</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice.DAT.UserIDD</DataLocation>
<DefaultData>UserIDDefaultData</DefaultData>
<IdLocation>^IBSP.Notice.DAT.UserIDD</IdLocation>
<IndexLocation>^IBSP.Notice.DAT.UserIDI</IndexLocation>
<StreamLocation>^IBSP.Notice.DAT.UserIDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
