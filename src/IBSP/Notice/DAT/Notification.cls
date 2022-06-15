Class IBSP.Notice.DAT.Notification Extends (%Persistent, Form.Adaptor)
{

Parameter FORMNAME = "Notification";

Parameter DISPLAYPROPERTY = "NotificationType";

Parameter FORMORDERBY = "NotificationType";

/// Topic notified
Property Topic As IBSP.Notice.DAT.Topic;

/// ID of the element notified
Property Element As %String;

/// Business Operation which notified
Property BusinessOperation As %String;

/// Notification type. Possible values: PULL for Direct notifications or PUSH for subscriber based notifications
Property NotificationType As %String;

/// Subscribier who was notified. Only filled if it is a PUSH notification
Property Subscriber As IBSP.Notice.DAT.Subscriber;

/// Direct Data where the notification was sent. Only filled if it is a PULL notification
Property DirectData As %String(MAXLEN = "");

/// Text sent in the notification
Property Text As %String(MAXLEN = "");

/// Datetime when the notification was sent
Property Date As %TimeStamp;

/// Result of the notification
Property Result As %String(MAXLEN = "");

/// Save the JSON response from the Sender if the Result is "ERROR" 
Property Error As %String(MAXLEN = "");

ForeignKey FKSubscriber(Subscriber) References IBSP.Notice.DAT.Subscriber() [ SqlName = FK_Notification_Subcriber ];

ForeignKey FKSTopic(Topic) References IBSP.Notice.DAT.Topic() [ SqlName = FK_Notification_Topic ];

/// Necessary for RESTForms2. This query is called when the "list" URL is invoked
ClassMethod queryLIST() As %String
{
    quit "%id _id, " _
         "to_char(""Date"",'YYYY-MM-DD HH24:mi:ss') As ""Date"", " _
         "NotificationType As ""Type"", " _
         "replace(case " _
         "  when length(replace(replace(Text, CHAR(10), ''), '\', '')) < 61 then " _
         "    replace(replace(Text, CHAR(10), ''), '\', '') " _ 
         "  else " _
         "    substr(replace(replace(Text, CHAR(10), ''), '\', ''), 1, 60) || '...' " _
         "end , '""', '\""') Text"
}

Storage Default
{
<Data name="NotificationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Topic</Value>
</Value>
<Value name="3">
<Value>Element</Value>
</Value>
<Value name="4">
<Value>BusinessOperation</Value>
</Value>
<Value name="5">
<Value>NotificationType</Value>
</Value>
<Value name="6">
<Value>Subscriber</Value>
</Value>
<Value name="7">
<Value>DirectData</Value>
</Value>
<Value name="8">
<Value>Text</Value>
</Value>
<Value name="9">
<Value>Date</Value>
</Value>
<Value name="10">
<Value>Result</Value>
</Value>
<Value name="11">
<Value>Error</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice.DAT.NotificationD</DataLocation>
<DefaultData>NotificationDefaultData</DefaultData>
<IdLocation>^IBSP.Notice.DAT.NotificationD</IdLocation>
<IndexLocation>^IBSP.Notice.DAT.NotificationI</IndexLocation>
<StreamLocation>^IBSP.Notice.DAT.NotificationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
