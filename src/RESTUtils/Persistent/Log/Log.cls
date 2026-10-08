Include (RESTUtils.INC.Utils, RESTUtils.INC.Log, RESTUtils.INC.Config)

/// internal log, this holds warnings, errors and some info, 
/// this does not log the calls, this is for severe/important.
/// To log endpoint calls se logDefinition
/// Only working in installatio namespace
Class RESTUtils.Persistent.Log.Log Extends %Persistent
{

/// Severity
Property Level As %String(VALUELIST = ",INFO,WARN,ERROR");

Property Msg As %String(MAXLEN = "");

Property LogTime As %TimeStamp;

Parameter AmountToLeave = 1000;

Parameter DeleteQuery = {"delete from RESTUtils_Persistent_Log.Log where id not in ( "_
    "select TOP "_..#AmountToLeave_" ID from RESTUtils_Persistent_Log.Log "_
    "order by %id desc "_
    ")"};

/// Ensure everytime we save, we have no more than the max amount of logs.
Method %OnAfterSave(insert As %Boolean) As %Status
{
    Set args = 0
    Set qres = $$$ExecQuery(..#DeleteQuery, $$$InstallationNamespace, args...)
    Do:(qres.%SQLCODE < 0) $$$IntLog("Failed to purge log", "ERROR")
    Return $$$OK
}

Method %OnAddToSaveSet(depth As %Integer, insert As %Integer, callcount As %Integer) As %Status [ Private, ServerOnly = 1 ]
{
    Set ..LogTime = $zdatetime($horolog,3)
    Return $$$OK
}

ClassMethod GetDeleteQuery() As %String(MAXLEN="")
{
    Return "delete from RESTUtils_Persistent_Log.Log where id not in ( "_
    "select TOP "_$$$GetAmountOfLogsToLeave_" ID from RESTUtils_Persistent_Log.Log "_
    "order by %id desc "_
    ")"
}

Index IXLevel On Level;

Storage Default
{
<Data name="LogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Level</Value>
</Value>
<Value name="3">
<Value>Msg</Value>
</Value>
<Value name="4">
<Value>LogTime</Value>
</Value>
</Data>
<DataLocation>^RESTUtils.Persistent.Log.LogD</DataLocation>
<DefaultData>LogDefaultData</DefaultData>
<ExtentSize>505</ExtentSize>
<IdLocation>^RESTUtils.Persistent.Log.LogD</IdLocation>
<IndexLocation>^RESTUtils.Persistent.Log.LogI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,16,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>4</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(19121,19170,19217,19257,19298,19341,19383,19426,19467,19509,19550,19590,19630,19663,19696,19729),$lb(3,2,3,3,2,3,2,3,2,3,3,2,3,3,2),"")</Histogram>
<Selectivity>1</Selectivity>
</Property>
<Property name="Level">
<AverageFieldSize>7</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" ERROR"," ERROR"," ERROR"," ERROR"," ERROR"," ERROR"," ERROR"," ERROR"," ERROR"," ERROR"," ERROR"," ERROR"," ERROR"," ERROR"," ERROR"," ERROR"),$lb(7,7,7,7,7,7,7,7,7,7,7,7,7,7,7),$lb(541413970,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,541413970))</Histogram>
<OutlierSelectivity>.999999:"ERROR"</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="Msg">
<AverageFieldSize>21.49</AverageFieldSize>
<Histogram>
<![CDATA[$lb(.06666666666666666667,0,0,$lb(" FAILED TO PURGE LOG"," FAILED TO PURGE LOG"," FAILED TO PURGE LOG"," FAILED TO PURGE LOG"," FAILED TO PURGE LOG"," FAILED TO PURGE LOG"," FAILED TO PURGE LOG"," FAILED TO PURGE LOG"," FAILED TO PURGE LOG"," FAILED TO PURGE LOG"," FAILED TO PURGE LOG"," FAILED TO PURGE LOG"," FAILED TO PURGE LOG"," FAILED TO PURGE LOG"," FAILED TO PURGE LOG"," FAILURE CALLING LOG: <INVALID OREF> 192 LOG+3^RESTUTILS.SERVICE.LOG.LOGSERVICE.1"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,5),$lb(541475145,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1162092628,1431455008,541475145))]]></Histogram>
<OutlierSelectivity>.992079:"Failed to purge log"</OutlierSelectivity>
<Selectivity>0.7921%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-16</BlockCount>
</SQLMap>
<StreamLocation>^RESTUtils.Persistent.Log.LogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
