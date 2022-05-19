/// Persitent Class to save Topics of the messages.
Class IBSP.Notice.DAT.Topic Extends (%Persistent, Form.Adaptor)
{

Parameter FORMNAME = "Topic";

Parameter DISPLAYPROPERTY = "TopicKey";

Parameter FORMORDERBY = "TopicKey";

/// Key of the Topic. Format XXXX.XXXX.XXXX 
Property TopicKey As %String(MAXLEN = "");

/// Template for this Topic
Property Template As %String(MAXLEN = "");

/// MsgID for this template
Property TemplateMsg As %String;

/// Bot Name
Property BotName As %String(MAXLEN = "");

/// Contact way for this topic
Property ContactWay As %String(MAXLEN = "");

/// Format of the Notification (HTML / TXT)
Property Format As %String(MAXLEN = "");

/// This indicates the people that should be notified (i.e. managerid, parentid,...)
/// It can be a list separated by comma (i.e. "employeeid,managerid")
/// Each element of the list must match with a Type of UserID of the subscriber
Property Destination As %String(MAXLEN = "");

/// Active = 1
Property Active As %Boolean [ InitialExpression = 1 ];

/// Subject of the email to be sent
Property Subject As %String(MAXLEN = "");

/// Subject MsgID for multi language
Property SubjectMsg As %String;

Property OutboundAdapter As %String;

Property BodyFormat As %String;

Property BodyTemplate As %String(MAXLEN = "");

Property ExecutionComponent As %String(MAXLEN = "");

Index UITopicKey On TopicKey [ Unique ];

/// Indicates the HTML Topic format
Parameter HTMLFORMAT = "HTML";

/// Indicates the HTTP Outbound Adapter
Parameter HTTPOUTBOUNDADAPTER = "HTTP";

Method IsHtmlFormat() As %Boolean
{
    quit ..#HTMLFORMAT = ..Format
}

Method IsHttpOutboundAdapter() As %Boolean
{
    quit ..#HTTPOUTBOUNDADAPTER = ..OutboundAdapter
}

/// Necessary for RESTForms2. This query is called when the "list" URL is invoked
ClassMethod queryLIST() As %String
{
    quit "%id _id, " _
         "TopicKey, " _
         "ContactWay, " _
         "Format, " _
         "Destination, " _
         "BotName, " _
         "Template, " _
         "(select count(*) from IBSP_Notice_DAT.Notification n where n.Topic = t.%id) Notifications "
}

ClassMethod queryLISTTOPICKEYS() As %String
{
	return "TopicKey"
}

Storage Default
{
<Data name="TopicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TopicKey</Value>
</Value>
<Value name="3">
<Value>Template</Value>
</Value>
<Value name="4">
<Value>TemplateMsg</Value>
</Value>
<Value name="5">
<Value>BotName</Value>
</Value>
<Value name="6">
<Value>ContactWay</Value>
</Value>
<Value name="7">
<Value>Format</Value>
</Value>
<Value name="8">
<Value>Destination</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
<Value name="10">
<Value>Subject</Value>
</Value>
<Value name="11">
<Value>SubjectMsg</Value>
</Value>
<Value name="12">
<Value>OutboundAdapter</Value>
</Value>
<Value name="13">
<Value>BodyFormat</Value>
</Value>
<Value name="14">
<Value>BodyTemplate</Value>
</Value>
<Value name="15">
<Value>ExecutionComponent</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice.DAT.TopicD</DataLocation>
<DefaultData>TopicDefaultData</DefaultData>
<IdLocation>^IBSP.Notice.DAT.TopicD</IdLocation>
<IndexLocation>^IBSP.Notice.DAT.TopicI</IndexLocation>
<StreamLocation>^IBSP.Notice.DAT.TopicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
