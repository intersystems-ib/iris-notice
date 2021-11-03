Class IBSP.Notice.DAT.Params Extends (%Persistent, %JSON.Adaptor)
{

// Parameter ID

Property ParamID As %String;

Property ParamDesc As %String(MAXLEN = "");

Property ParamValue As %String(MAXLEN = "");

Property ParamType As %String(MAXLEN = "");

Index PKParams On ParamID [ PrimaryKey ];

Storage Default
{
<Data name="ParamsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ParamID</Value>
</Value>
<Value name="3">
<Value>ParamDesc</Value>
</Value>
<Value name="4">
<Value>ParamValue</Value>
</Value>
<Value name="5">
<Value>ParamType</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice.DAT.ParamsD</DataLocation>
<DefaultData>ParamsDefaultData</DefaultData>
<IdLocation>^IBSP.Notice.DAT.ParamsD</IdLocation>
<IndexLocation>^IBSP.Notice.DAT.ParamsI</IndexLocation>
<StreamLocation>^IBSP.Notice.DAT.ParamsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
