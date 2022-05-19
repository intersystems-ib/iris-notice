Class IBSP.Notice.DAT.ResourceAction Extends (%Persistent, %JSON.Adaptor)
{

Property Resource As %String(MAXLEN = "") [ Required ];

Property Action As %String(MAXLEN = "") [ Required ];

Property Description As %String(MAXLEN = "") [ Required ];

Index UIResourceAction On (Resource, Action) [ Unique ];

Storage Default
{
<Data name="ResourceActionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Resource</Value>
</Value>
<Value name="3">
<Value>Action</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice419.ResourceActionD</DataLocation>
<DefaultData>ResourceActionDefaultData</DefaultData>
<IdLocation>^IBSP.Notice419.ResourceActionD</IdLocation>
<IndexLocation>^IBSP.Notice419.ResourceActionI</IndexLocation>
<StreamLocation>^IBSP.Notice419.ResourceActionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
