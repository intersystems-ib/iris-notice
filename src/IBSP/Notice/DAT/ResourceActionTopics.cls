Class IBSP.Notice.DAT.ResourceActionTopics Extends (%Persistent, %JSON.Adaptor)
{

Property ResourceAction As IBSP.Notice.DAT.ResourceAction;

Property Topic As IBSP.Notice.DAT.Topic;

Index IxResourceAction On ResourceAction;

Index UIResourceActionTopic On (ResourceAction, Topic) [ Unique ];

ForeignKey FKResourceAction(ResourceAction) References IBSP.Notice.DAT.ResourceAction() [ SqlName = FK_ResourceActionTopics_ResourceAction ];

ForeignKey FKTopic(Topic) References IBSP.Notice.DAT.Topic() [ SqlName = FK_ResourceActionTopics_Topic ];

Storage Default
{
<Data name="ResourceActionTopicsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ResourceAction</Value>
</Value>
<Value name="3">
<Value>Topic</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice419.ResourceActF3D5D</DataLocation>
<DefaultData>ResourceActionTopicsDefaultData</DefaultData>
<IdLocation>^IBSP.Notice419.ResourceActF3D5D</IdLocation>
<IndexLocation>^IBSP.Notice419.ResourceActF3D5I</IndexLocation>
<StreamLocation>^IBSP.Notice419.ResourceActF3D5S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
