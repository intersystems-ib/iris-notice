Class IBSP.Notice.DAT.Message Extends (%Persistent, %JSON.Adaptor)
{

/// ID of this message. Every MsgID can have several laguages.
Property MsgID As %String(MAXLEN = "");

/// Language of the message 
Property Lang As IBSP.Notice.DAT.Lang;

/// Type of way to contact
Property Message As %String(MAXLEN = "");

Index IxMsgID On MsgID;

Index UIMsgLang On (MsgID, Lang) [ Unique ];

ForeignKey FKLang(Lang) References IBSP.Notice.DAT.Lang() [ SqlName = FK_Message_Lang ];

Storage Default
{
<Data name="MessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MsgID</Value>
</Value>
<Value name="3">
<Value>Lang</Value>
</Value>
<Value name="4">
<Value>Message</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice.DAT.MessageD</DataLocation>
<DefaultData>MessageDefaultData</DefaultData>
<IdLocation>^IBSP.Notice.DAT.MessageD</IdLocation>
<IndexLocation>^IBSP.Notice.DAT.MessageI</IndexLocation>
<StreamLocation>^IBSP.Notice.DAT.MessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
