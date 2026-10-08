Class RESTUtils.Test.Persistent.pr3 Extends (%Persistent, RESTUtils.JSON.Adaptor)
{

Parameter %JSONDIFFERENTIATENULLFROMEMPTYSTRING = 1;

Property uniqueProp As %Numeric [ Required ];

Property ten;

Property num As %Numeric;

Property wontAppear As %String(MAXLEN = "");

Property date As %Date;

Property bool As %Boolean;

Property pr2 As RESTUtils.Test.Persistent.pr2(%JSONCASCADECHANGES = 1);

Storage Default
{
<Data name="pr3DefaultData">
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
<Value name="8">
<Value>pr2</Value>
</Value>
</Data>
<DataLocation>^RESTUtils.Test.Persistent.pr3D</DataLocation>
<DefaultData>pr3DefaultData</DefaultData>
<ExtentSize>1</ExtentSize>
<IdLocation>^RESTUtils.Test.Persistent.pr3D</IdLocation>
<IndexLocation>^RESTUtils.Test.Persistent.pr3I</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="bool">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="date">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="num">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="pr2">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="ten">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="uniqueProp">
<AverageFieldSize>3</AverageFieldSize>
<OutlierSelectivity>.999999:3</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="wontAppear">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^RESTUtils.Test.Persistent.pr3S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
