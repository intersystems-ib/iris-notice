/// Persitent Class for possibles command available on a specific status
Class IBSP.Notice.DAT.WFStatusCommand Extends (%Persistent, %JSON.Adaptor)
{

/// Status where this command can be executed
Property WFStatus As IBSP.Notice.DAT.WFStatus;

/// REGEX Command to execute on this status
Property Command As %String(MAXLEN = "");

/// Next Status for this WorkFlow / NULL = No further statuses. End.
Property NextStatus As IBSP.Notice.DAT.WFStatus;

/// List of actions to perform if this commnd is executed   
Property Actions As %String(MAXLEN = "");

/// Active
Property Active As %Boolean;

ForeignKey FKWFStatus(WFStatus) References IBSP.Notice.DAT.WFStatus() [ SqlName = FK_WFStatus_WFStatus ];

ForeignKey FKNextStatus(NextStatus) References IBSP.Notice.DAT.WFStatus() [ SqlName = FK_NextStatus_WFStatus ];

Storage Default
{
<Data name="WFStatusCommandDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WFStatus</Value>
</Value>
<Value name="3">
<Value>Command</Value>
</Value>
<Value name="4">
<Value>NextStatus</Value>
</Value>
<Value name="5">
<Value>Actions</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice419.WFStatusCom9037D</DataLocation>
<DefaultData>WFStatusCommandDefaultData</DefaultData>
<IdLocation>^IBSP.Notice419.WFStatusCom9037D</IdLocation>
<IndexLocation>^IBSP.Notice419.WFStatusCom9037I</IndexLocation>
<StreamLocation>^IBSP.Notice419.WFStatusCom9037S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
