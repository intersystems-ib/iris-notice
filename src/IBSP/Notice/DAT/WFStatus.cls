/// Persitent Class for Command Workflows
Class IBSP.Notice.DAT.WFStatus Extends (%Persistent, %JSON.Adaptor)
{

/// Descripting text representing this Status
Property Status As %String;

/// Message to display when this status is executed
Property MainMsg As IBSP.Notice.DAT.Topic;

/// Message to show if there is an error in this status   
Property ErrorMsg As IBSP.Notice.DAT.Topic;

/// New status if there is an error
Property ErrorStatus As IBSP.Notice.DAT.WFStatus;

/// Active
Property Active As %Boolean;

ForeignKey FKStatus(ErrorStatus) References IBSP.Notice.DAT.WFStatus() [ SqlName = FK_ErrorStatus_WFStatus ];

ForeignKey FKMainMsg(MainMsg) References IBSP.Notice.DAT.Message() [ SqlName = FK_MainMsg_Message ];

ForeignKey FKErrorMsg(ErrorMsg) References IBSP.Notice.DAT.Message() [ SqlName = FK_ErrorMsg_Message ];

Storage Default
{
<Data name="WFStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Status</Value>
</Value>
<Value name="3">
<Value>MainMsg</Value>
</Value>
<Value name="4">
<Value>ErrorMsg</Value>
</Value>
<Value name="5">
<Value>ErrorStatus</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice.DAT.WFStatusD</DataLocation>
<DefaultData>WFStatusDefaultData</DefaultData>
<IdLocation>^IBSP.Notice.DAT.WFStatusD</IdLocation>
<IndexLocation>^IBSP.Notice.DAT.WFStatusI</IndexLocation>
<StreamLocation>^IBSP.Notice.DAT.WFStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
