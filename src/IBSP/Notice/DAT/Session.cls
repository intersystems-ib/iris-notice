/// Persistent class with real sessions with users
Class IBSP.Notice.DAT.Session Extends (%Persistent, %JSON.Adaptor)
{

/// Subscriber executing the session
Property Subscriber As IBSP.Notice.DAT.Subscriber;

/// WorkFlow in execution
Property Workflow As IBSP.Notice.DAT.Workflow;

/// Start Date of this session
Property StartDate As %DateTime;

/// End Date of this session
Property EndDate As %DateTime;

/// Last Update of this session
Property LastUpdate As %DateTime;

/// String to save Context Variables for this session
Property ContextVariables As %String(MAXLEN = "");

ForeignKey FKSubscriber(Subscriber) References IBSP.Notice.DAT.Subscriber() [ SqlName = FK_Session_Subscriber ];

ForeignKey FKWorkflow(Workflow) References IBSP.Notice.DAT.Workflow() [ SqlName = FK_Session_Workflow ];

Storage Default
{
<Data name="SessionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Subscriber</Value>
</Value>
<Value name="3">
<Value>Workflow</Value>
</Value>
<Value name="4">
<Value>StartDate</Value>
</Value>
<Value name="5">
<Value>EndDate</Value>
</Value>
<Value name="6">
<Value>LastUpdate</Value>
</Value>
<Value name="7">
<Value>ContextVariables</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice.DAT.SessionD</DataLocation>
<DefaultData>SessionDefaultData</DefaultData>
<IdLocation>^IBSP.Notice.DAT.SessionD</IdLocation>
<IndexLocation>^IBSP.Notice.DAT.SessionI</IndexLocation>
<StreamLocation>^IBSP.Notice.DAT.SessionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
