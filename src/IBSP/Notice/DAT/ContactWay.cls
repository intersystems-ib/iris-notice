/// Persitent Class to save different contact ways for subcribers.
Class IBSP.Notice.DAT.ContactWay Extends (%Persistent, RESTUtils.JSON.Adaptor)
{

/// Subscriber
Property Subscriber As IBSP.Notice.DAT.Subscriber;

/// Type of way to contact
Property Type As %String(MAXLEN = "");

/// Address of way to contact
Property Address As %String(MAXLEN = "");

ForeignKey FKSubscriber(Subscriber) References IBSP.Notice.DAT.Subscriber() [ SqlName = FK_Contactway_Subcriber ];

Index IXSubscriber On Subscriber;

Index IXSubscriberType On (Subscriber, Type);

/// Necessary for RESTForms2. This query is called when the "list" URL is invoked
ClassMethod queryLIST() As %String
{
    quit "%id _id, " _
         "Type, " _
         "Address "
}

Storage Default
{
<Data name="ContactWayDefaultData">
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
<Value>Address</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice.DAT.ContactWayD</DataLocation>
<DefaultData>ContactWayDefaultData</DefaultData>
<IdLocation>^IBSP.Notice.DAT.ContactWayD</IdLocation>
<IndexLocation>^IBSP.Notice.DAT.ContactWayI</IndexLocation>
<StreamLocation>^IBSP.Notice.DAT.ContactWayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
