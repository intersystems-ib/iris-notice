Class RESTUtils.Test.Persistent.pr2 Extends (%Persistent, RESTUtils.JSON.Adaptor)
{

Property uniqueProp As %Numeric [ Required ];

Property ten;

Property num As %Numeric;

Property wontAppear As %String(MAXLEN = "");

Property date As %Date;

Property bool As %Boolean;

Index IXUuniqueProp On uniqueProp [ Unique ];

Storage Default
{
<Data name="pr2DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>uniqueProp</Value>
</Value>
<Value name="3">
<Value>ten</Value>
</Value>
<Value name="4">
<Value>num</Value>
</Value>
<Value name="5">
<Value>wontAppear</Value>
</Value>
<Value name="6">
<Value>date</Value>
</Value>
<Value name="7">
<Value>bool</Value>
</Value>
</Data>
<DataLocation>^RESTUtils.Test.Persistent.pr2D</DataLocation>
<DefaultData>pr2DefaultData</DefaultData>
<IdLocation>^RESTUtils.Test.Persistent.pr2D</IdLocation>
<IndexLocation>^RESTUtils.Test.Persistent.pr2I</IndexLocation>
<StreamLocation>^RESTUtils.Test.Persistent.pr2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
