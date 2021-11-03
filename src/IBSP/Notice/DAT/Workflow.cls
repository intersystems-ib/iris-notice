/// Persitent Class for Command Workflows
Class IBSP.Notice.DAT.Workflow Extends (%Persistent, %JSON.Adaptor)
{

/// Main Command to execute this WF
Property Command As %String(MAXLEN = "");

/// Aliases to select this command, divided by |  
Property Alias As %String(MAXLEN = "");

/// Initial Status for this WorkFlow
Property InitStatus As IBSP.Notice.DAT.WFStatus;

/// Expiration time for this WorkFlow in seconds
Property Expiration As %Integer;

/// Help message ID for this WF
Property HelpMsg As IBSP.Notice.DAT.Message;

/// Active
Property Active As %Boolean;

ForeignKey FKMessage(HelpMsg) References IBSP.Notice.DAT.Message() [ SqlName = FK_HelpMsg_Message ];

ForeignKey FKStatus(InitStatus) References IBSP.Notice.DAT.WFStatus() [ SqlName = FK_InitStatus_WFStatus ];

Storage Default
{
<Data name="WorkflowDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Command</Value>
</Value>
<Value name="3">
<Value>Alias</Value>
</Value>
<Value name="4">
<Value>InitStatus</Value>
</Value>
<Value name="5">
<Value>Expiration</Value>
</Value>
<Value name="6">
<Value>HelpMsg</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice.DAT.WorkflowD</DataLocation>
<DefaultData>WorkflowDefaultData</DefaultData>
<IdLocation>^IBSP.Notice.DAT.WorkflowD</IdLocation>
<IndexLocation>^IBSP.Notice.DAT.WorkflowI</IndexLocation>
<StreamLocation>^IBSP.Notice.DAT.WorkflowS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
