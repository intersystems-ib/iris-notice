/// Used in testing
Class RESTUtils.Test.Persistent.pr Extends (%Persistent, RESTUtils.JSON.Adaptor)
{

Property algo;

Property Name As %String(MAXLEN = "");

Property Num As %Numeric;

Property DDate As %Date;

Property pr2 As RESTUtils.Test.Persistent.pr2;

Property image As %Stream.GlobalBinary;

Storage Default
{
<Data name="prDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>algo</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Num</Value>
</Value>
<Value name="5">
<Value>DDate</Value>
</Value>
<Value name="6">
<Value>pr2</Value>
</Value>
<Value name="7">
<Value>image</Value>
</Value>
</Data>
<DataLocation>^RESTUtils.Test.Persistent.prD</DataLocation>
<DefaultData>prDefaultData</DefaultData>
<ExtentSize>2</ExtentSize>
<IdLocation>^RESTUtils.Test.Persistent.prD</IdLocation>
<IndexLocation>^RESTUtils.Test.Persistent.prI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="DDate">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="Name">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="Num">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="algo">
<AverageFieldSize>6.5</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="image">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="pr2">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^RESTUtils.Test.Persistent.prS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
