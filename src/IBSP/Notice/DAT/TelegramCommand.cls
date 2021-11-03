/// Persistent Class for list of commands available in Telegram
Class IBSP.Notice.DAT.TelegramCommand Extends (%Persistent, %JSON.Adaptor) [ Language = objectscript ]
{

Property ActionCommand As %String(MAXLEN = "") [ Required ];

Property DescriptionText As %String(MAXLEN = "");

Property ExecutionComponent As %String(MAXLEN = "");

Property Topic As IBSP.Notice.DAT.Topic;

Property Internal As %Boolean [ InitialExpression = 0, Required ];

Index UIActionCommand On ActionCommand [ Unique ];

ForeignKey FKSTopic(Topic) References IBSP.Notice.DAT.Topic() [ SqlName = FK_TelegramCommand_Topic ];

/// Checks if an usernId is subscribed to the topic associated to this command
Method isUserSubscribed(pUserId As %String) As %Boolean
{
	quit ##class(IBSP.Notice.Utils).IsUserApproved(pUserId, ..ActionCommand)
}

/// Checks if the command is an internal one or not
Method isInternal() As %Boolean
{
	Quit ..Internal
}

Storage Default
{
<Data name="TelegramCommandDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActionCommand</Value>
</Value>
<Value name="3">
<Value>DescriptionText</Value>
</Value>
<Value name="4">
<Value>ExecutionComponent</Value>
</Value>
<Value name="5">
<Value>Topic</Value>
</Value>
<Value name="6">
<Value>Internal</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice419.TelegramComA6BED</DataLocation>
<DefaultData>TelegramCommandDefaultData</DefaultData>
<IdLocation>^IBSP.Notice419.TelegramComA6BED</IdLocation>
<IndexLocation>^IBSP.Notice419.TelegramComA6BEI</IndexLocation>
<StreamLocation>^IBSP.Notice419.TelegramComA6BES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
