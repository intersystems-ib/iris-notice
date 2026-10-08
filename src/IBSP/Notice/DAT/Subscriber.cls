/// Persitent Class for subscribers. Users or Groups.
Class IBSP.Notice.DAT.Subscriber Extends (%Persistent, RESTUtils.JSON.Adaptor, %XML.Adaptor)
{

/// Name of user / Name of the Group
Property Name As %String(MAXLEN = "");

/// SurName of user
Property SurName As %String(MAXLEN = "");

/// Active = 1
Property Active As %Boolean [ InitialExpression = 1 ];

/// Preferred language of the user to send the notifications
Property Lang As IBSP.Notice.DAT.Lang;

ForeignKey FKLang(Lang) References IBSP.Notice.DAT.Lang() [ SqlName = FK_Message_Lang ];

Index BXActive On Active [ Type = bitmap ];

Storage Default
{
<Data name="SubscriberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>SurName</Value>
</Value>
<Value name="4">
<Value>Active</Value>
</Value>
<Value name="5">
<Value>Lang</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice.DAT.SubscriberD</DataLocation>
<DefaultData>SubscriberDefaultData</DefaultData>
<IdLocation>^IBSP.Notice.DAT.SubscriberD</IdLocation>
<IndexLocation>^IBSP.Notice.DAT.SubscriberI</IndexLocation>
<StreamLocation>^IBSP.Notice.DAT.SubscriberS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
