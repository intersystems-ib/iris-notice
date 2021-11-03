/// Persitent Class for subscribers. Users or Groups.
Class IBSP.Notice.DAT.Subscriber Extends (%Persistent, Form.Adaptor)
{

Parameter FORMNAME = "Subscriber";

Parameter DISPLAYPROPERTY = "Name";

Parameter FORMORDERBY = "Name";

/// Name of user / Name of the Group
Property Name As %String(MAXLEN = "");

/// SurName of user
Property SurName As %String(MAXLEN = "");

/// Active = 1
Property Active As %Boolean [ InitialExpression = 1 ];

/// Preferred language of the user to send the notifications
Property Lang As IBSP.Notice.DAT.Lang(%JSONREFERENCE = "ID");

ForeignKey FKLang(Lang) References IBSP.Notice.DAT.Lang() [ SqlName = FK_Message_Lang ];

/// Necessary for RESTForms2. This query is called when the "list" URL is invoked
ClassMethod queryLIST() As %String
{
    quit "%id _id, " _
         "Name, " _
         "SurName, " _
         "(select u.Code from Notice_DAT.UserID u where u.Subscriber = t.%id and u.Type = 'employeeid') EmployeeId, " _
         "(select c.Address from Notice_DAT.ContactWay c where c.Subscriber = t.%id AND c.Type = 'email') Email, " _
         "(select count(*) from Notice_DAT.Subscription s where s.Subscriber = t.%id) NumSubscriptions, " _
         "(select count(*) from Notice_DAT.Notification n where n.Subscriber = t.%id and n.NotificationType = 'PULL') PullNotifications, " _
         "(select count(*) from Notice_DAT.Notification n where n.Subscriber = t.%id and n.NotificationType = 'PUSH') PushNotifications "
}

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
