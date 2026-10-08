Include (RESTUtils.INC.Utils, RESTUtils.INC.Log)

/// Not really used as persistent but useful to store temporarily to pass to the JOB
/// TODO add daily purge
Class RESTUtils.Service.Log.Helper.LogInfo Extends (%Persistent, %JSON.Adaptor)
{

Property OptionsAsJSON As %DynamicObject [ InitialExpression = {{}} ];

Property Application As %String(MAXLEN = "");

Property User As %String(MAXLEN = "") [ InitialExpression = {$USERNAME} ];

Property IsSecure As %Boolean;

Property Method As %String(MAXLEN = "");

Property Endpoint As %String(MAXLEN = "");

Property UserAgent As %String(MAXLEN = "");

Property RequestContentType As %String(MAXLEN = "");

Property ResponseContentType As %String(MAXLEN = "");

Property RequestContent As %Stream.GlobalCharacter;

Property Namespace As %String(MAXLEN = "");

Property Action As %String(MAXLEN = "");

Property Identifier As %String(MAXLEN = "");

Property ResponseStatus As %String(MAXLEN = "");

Property Browser As %String(MAXLEN = "");

Property OS As %String(MAXLEN = "");

Property IsMobile As %Boolean;

Parameter AmountToLeave = 1000;

Parameter DeleteQuery = {"delete from RESTUtils_Service_Log_Helper.LogInfo where id not in ( "_
    "select TOP "_..#AmountToLeave_" ID from RESTUtils_Service_Log_Helper.LogInfo "_
    "order by %id desc "_
    ")"};

Method %OnAfterSave(insert As %Boolean) As %Status
{
    Do ..RunDeleteQuery()
    Return $$$OK
}

ClassMethod RunDeleteQuery()
{
    Set args = 0
    Set qres = $$$ExecQuery(..#DeleteQuery, $$$InstallationNamespace, args...)
    Do:(qres.%SQLCODE < 0) $$$IntLog("Failed to purge log", "ERROR")
}

Storage Default
{
<Data name="LogInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Application</Value>
</Value>
<Value name="3">
<Value>User</Value>
</Value>
<Value name="4">
<Value>IsSecure</Value>
</Value>
<Value name="5">
<Value>Method</Value>
</Value>
<Value name="6">
<Value>Endpoint</Value>
</Value>
<Value name="7">
<Value>UserAgent</Value>
</Value>
<Value name="8">
<Value>RequestContentType</Value>
</Value>
<Value name="9">
<Value>ResponseContentType</Value>
</Value>
<Value name="10">
<Value>RequestContent</Value>
</Value>
<Value name="11">
<Value>Namespace</Value>
</Value>
<Value name="12">
<Value>Action</Value>
</Value>
<Value name="13">
<Value>Identifier</Value>
</Value>
<Value name="14">
<Value>ResponseStatus</Value>
</Value>
<Value name="15">
<Value>Browser</Value>
</Value>
<Value name="16">
<Value>OS</Value>
</Value>
<Value name="17">
<Value>IsMobile</Value>
</Value>
</Data>
<Data name="OptionsAsJSON">
<Attribute>OptionsAsJSON</Attribute>
<Structure>node</Structure>
<Subscript>"OptionsAsJSON"</Subscript>
</Data>
<DataLocation>^RESTUtils.ServiceF123.LogInfoD</DataLocation>
<DefaultData>LogInfoDefaultData</DefaultData>
<ExtentSize>727</ExtentSize>
<IdLocation>^RESTUtils.ServiceF123.LogInfoD</IdLocation>
<IndexLocation>^RESTUtils.ServiceF123.LogInfoI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,16,$lb("-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000","-10000000000000000000"),$lb(21,21,21,21,21,21,21,21,21,21,21,21,21,21,21),$lb(758198320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,758198320))</Histogram>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>4</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(4001,4052,4101,4150,4199,4248,4297,4346,4394,4442,4494,4543,4591,4644,4700,4748),$lb(2,1,2,2,1,2,1,2,1,2,1,2,1,1,2),"")</Histogram>
<Selectivity>1</Selectivity>
</Property>
<Property name="Action">
<AverageFieldSize>7.87</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" CREATE"," DELETE"," GET_RESOURCE"," INFO"," INFO"," SEARCH"," SEARCH"," SEARCH"," SEARCH"," SEARCH"," SEARCH"," SEARCH"," SEARCH"," SEARCH"," SEARCH"," UPDATE"),$lb(1,1,1,6,1,8,8,8,8,8,8,8,8,8,1),$lb(541282885,1129465153,1145392197,1145392197,1195725919,1195725919,1229866575,0,0,1229866575,1397047634,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1397047634,1431323713,542462020))</Histogram>
<OutlierSelectivity>.612105:"SEARCH"</OutlierSelectivity>
<Selectivity>6.4649%</Selectivity>
</Property>
<Property name="Application">
<AverageFieldSize>7.18</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" /BOS/API/"," /IAB/"," /IAB/"," /IAB/"," /IAB/"," /IAB/"," /IAB/"," /IAB/"," /IAB/"," /IAB/"," /IAB/"," /IAB/"," /IAB/"," /IAB/"," /IAB/"," /IAB/"),$lb(2,7,7,7,7,7,7,7,7,7,7,7,7,7,7),$lb(539968079,1112494895,1229013551,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,539969857))</Histogram>
<OutlierSelectivity>.955983:"/iab/"</OutlierSelectivity>
<Selectivity>4.4017%</Selectivity>
</Property>
<Property name="Browser">
<AverageFieldSize>14.9</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," GOOGLE CHROME"," GOOGLE CHROME"," GOOGLE CHROME"," GOOGLE CHROME"," GOOGLE CHROME"," GOOGLE CHROME"," GOOGLE CHROME"," GOOGLE CHROME"," GOOGLE CHROME"," GOOGLE CHROME"," GOOGLE CHROME"," GOOGLE CHROME"," GOOGLE CHROME"," GOOGLE CHROME"," MICROSOFT EDGE"),$lb(1,15,15,15,15,15,15,15,15,15,15,15,15,15,1),$lb(536870912,0,1196379975,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1196379975,1296646994,541935939))</Histogram>
<OutlierSelectivity>.944979:"Google Chrome"</OutlierSelectivity>
<Selectivity>2.7510%</Selectivity>
</Property>
<Property name="Endpoint">
<AverageFieldSize>14.87</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" EDIT/CREATE"," EDIT/DELETE/316"," EDIT/UPDATE/341"," INFO/NOTICE/NOTICE.DAT.SUBSCRIBER"," INFO/NOTICE/NOTICE.DAT.SUBSCRIBER"," INFO/NOTICE/NOTICE.DAT.SUBSCRIBER"," SEARCH"," SEARCH"," SEARCH"," SEARCH"," SEARCH"," SEARCH"," SEARCH"," SEARCH"," SEARCH"," UTIL/GET/P8078-L2"),$lb(6,6,1,35,35,1,8,8,8,8,8,8,8,8,1),$lb(541410377,1129465153,1145392197,1145392197,1431323713,1162103124,1229866575,0,0,0,0,1229866575,1397047634,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1397047634,1431587148,542463049))</Histogram>
<OutlierSelectivity>.612105:"search"</OutlierSelectivity>
<Selectivity>0.7053%</Selectivity>
</Property>
<Property name="Identifier">
<AverageFieldSize>2.6</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," "," "," "," "," "," "," "," "," "," 307"," 336"," P8078-L2"),$lb(2,2,2,2,2,2,2,2,2,2,2,2,1,2,1),$lb(536870912,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,858797824,808910848,859176960,858994176,1345859639,542128176))</Histogram>
<OutlierSelectivity>.856946:</OutlierSelectivity>
<Selectivity>0.2861%</Selectivity>
</Property>
<Property name="IsMobile">
<AverageFieldSize>2</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,1,$lb(-10000000000000000000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),$lb(0,1,1,1,1,1,1,1,1,1,1,1,1,1,1),"")</Histogram>
<OutlierSelectivity>.988996:0</OutlierSelectivity>
<Selectivity>1.1004%</Selectivity>
</Property>
<Property name="IsSecure">
<AverageFieldSize>3</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,1,0,$lb(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),$lb(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1),"")</Histogram>
<OutlierSelectivity>.999999:1</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="Method">
<AverageFieldSize>5.79</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" DELETE"," GET"," GET"," GET"," GET"," POST"," POST"," POST"," POST"," POST"," POST"," POST"," POST"," POST"," POST"," PUT"),$lb(1,5,5,5,1,6,6,6,6,6,6,6,6,6,2),$lb(541345100,1145392197,1195725824,0,0,0,0,0,0,1195725824,1347375956,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1330861056,1431568384,542135636))</Histogram>
<OutlierSelectivity>.660248:"POST"</OutlierSelectivity>
<Selectivity>11.3251%</Selectivity>
</Property>
<Property name="Namespace">
<AverageFieldSize>5.24</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" BOS"," IAB"," IAB"," IAB"," IAB"," IAB"," IAB"," IAB"," IAB"," IAB"," IAB"," IAB"," IAB"," IAB"," NOTICE"," NOTICE"),$lb(1,5,5,5,5,5,5,5,5,5,5,5,5,1,8),$lb(541216595,1112494848,1229013504,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1229013504,1313821769,0,0,542003028))</Histogram>
<OutlierSelectivity>.870702:"IAB"</OutlierSelectivity>
<Selectivity>6.4649%</Selectivity>
</Property>
<Property name="OS">
<AverageFieldSize>7.03</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," MACOS"," MACOS"," MACOS"," MACOS"," MACOS"," MACOS"," MACOS"," MACOS"," MACOS"," MACOS"," MACOS"," MACOS"," MACOS"," MACOS"," WINDOWS"),$lb(1,7,7,7,7,7,7,7,7,7,7,7,7,7,1),$lb(536870912,0,1296122703,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1296122703,1464421956,542591310))</Histogram>
<OutlierSelectivity>.944979:"macOS"</OutlierSelectivity>
<Selectivity>2.7510%</Selectivity>
</Property>
<Property name="OptionsAsJSON">
<AverageFieldSize>178.14</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="RequestContent">
<Histogram>$lb(.06666666666666666667,1,5,$lb(-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,-10000000000000000000,0,0,0,0,0,0,0,0,0,0,0),$lb(21,21,21,21,0,1,1,1,1,1,1,1,1,1,1),"")</Histogram>
<OutlierSelectivity>.284732:</OutlierSelectivity>
<Selectivity>0.1376%</Selectivity>
</Property>
<Property name="RequestContentType">
<AverageFieldSize>14.15</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" "," "," "," "," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"),$lb(2,2,2,1,18,18,18,18,18,18,18,18,18,18,18),$lb(536870912,0,0,0,0,0,0,0,1095782476,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,541151312))</Histogram>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="ResponseContentType">
<AverageFieldSize>17.99</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," APPLICATION/JSON"," PLAIN/TEXT"),$lb(18,18,18,18,18,18,18,18,18,18,18,18,18,18,1),$lb(541151312,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1095782476,1347174729,542133313))</Histogram>
<OutlierSelectivity>.998624:"application/json"</OutlierSelectivity>
<Selectivity>0.1376%</Selectivity>
</Property>
<Property name="ResponseStatus">
<AverageFieldSize>7.85</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" 200 OK"," 200 OK"," 200 OK"," 200 OK"," 200 OK"," 200 OK"," 200 OK"," 200 OK"," 200 OK"," 200 OK"," 200 OK"," 200 OK"," 200 OK"," 200 OK"," 200 OK"," 404"),$lb(8,8,8,8,8,8,8,8,8,8,8,8,8,8,1),$lb(540160048,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,842018848,875574272,540291124))</Histogram>
<OutlierSelectivity>.962861:"200 OK"</OutlierSelectivity>
<Selectivity>1.8569%</Selectivity>
</Property>
<Property name="User">
<AverageFieldSize>7.15</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" JRUIZ"," JRUIZ"," JRUIZ"," JRUIZ"," JRUIZ"," JRUIZ"," JRUIZ"," JRUIZ"," JRUIZ"," JRUIZ"," JRUIZ"," JRUIZ"," JRUIZ"," JRUIZ"," JRUIZ"," OMUNOZME"),$lb(7,7,7,7,7,7,7,7,7,7,7,7,7,7,1),$lb(541741653,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1246909769,1330468174,542068053))</Histogram>
<OutlierSelectivity>.949106:"jruiz"</OutlierSelectivity>
<Selectivity>5.0894%</Selectivity>
</Property>
<Property name="UserAgent">
<AverageFieldSize>118.13</AverageFieldSize>
<Histogram>$lb(.06666666666666666667,0,0,$lb(" HTTPIE"," MOZILLA/5.0 (MACINTOSH; INTEL MAC OS X 10_15_7) APPLEWEBKIT/537.36 (KHTML, LIKE GECKO) CHROME/145.0.0.0 SAFARI/537.36"," MOZILLA/5.0 (MACINTOSH; INTEL MAC OS X 10_15_7) APPLEWEBKIT/537.36 (KHTML, LIKE GECKO) CHROME/145.0.0.0 SAFARI/537.36"," MOZILLA/5.0 (MACINTOSH; INTEL MAC OS X 10_15_7) APPLEWEBKIT/537.36 (KHTML, LIKE GECKO) CHROME/145.0.0.0 SAFARI/537.36"," MOZILLA/5.0 (MACINTOSH; INTEL MAC OS X 10_15_7) APPLEWEBKIT/537.36 (KHTML, LIKE GECKO) CHROME/145.0.0.0 SAFARI/537.36"," MOZILLA/5.0 (MACINTOSH; INTEL MAC OS X 10_15_7) APPLEWEBKIT/537.36 (KHTML, LIKE GECKO) CHROME/145.0.0.0 SAFARI/537.36"," MOZILLA/5.0 (MACINTOSH; INTEL MAC OS X 10_15_7) APPLEWEBKIT/537.36 (KHTML, LIKE GECKO) CHROME/145.0.0.0 SAFARI/537.36"," MOZILLA/5.0 (MACINTOSH; INTEL MAC OS X 10_15_7) APPLEWEBKIT/537.36 (KHTML, LIKE GECKO) CHROME/145.0.0.0 SAFARI/537.36"," MOZILLA/5.0 (MACINTOSH; INTEL MAC OS X 10_15_7) APPLEWEBKIT/537.36 (KHTML, LIKE GECKO) CHROME/145.0.0.0 SAFARI/537.36"," MOZILLA/5.0 (MACINTOSH; INTEL MAC OS X 10_15_7) APPLEWEBKIT/537.36 (KHTML, LIKE GECKO) CHROME/145.0.0.0 SAFARI/537.36"," MOZILLA/5.0 (MACINTOSH; INTEL MAC OS X 10_15_7) APPLEWEBKIT/537.36 (KHTML, LIKE GECKO) CHROME/145.0.0.0 SAFARI/537.36"," MOZILLA/5.0 (MACINTOSH; INTEL MAC OS X 10_15_7) APPLEWEBKIT/537.36 (KHTML, LIKE GECKO) CHROME/145.0.0.0 SAFARI/537.36"," MOZILLA/5.0 (MACINTOSH; INTEL MAC OS X 10_15_7) APPLEWEBKIT/537.36 (KHTML, LIKE GECKO) CHROME/145.0.0.0 SAFARI/537.36"," MOZILLA/5.0 (MACINTOSH; INTEL MAC OS X 10_15_7) APPLEWEBKIT/537.36 (KHTML, LIKE GECKO) CHROME/145.0.0.0 SAFARI/537.36"," MOZILLA/5.0 (MACINTOSH; INTEL MAC OS X 10_15_7) APPLEWEBKIT/537.36 (KHTML, LIKE GECKO) CHROME/145.0.0.0 SAFARI/537.36"," MOZILLA/5.0 (WINDOWS NT 10.0; WIN64; X64) APPLEWEBKIT/537.36 (KHTML, LIKE GECKO) CHROME/145.0.0.0 SAFARI/537.36 EDG/145"),$lb(1,119,119,119,119,119,119,119,119,119,119,119,119,119,14),$lb(541611092,1213486160,1297046089,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1296122697,1464421956,541937498))</Histogram>
<OutlierSelectivity>.944979:"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36"</OutlierSelectivity>
<Selectivity>2.7510%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-180</BlockCount>
</SQLMap>
<StreamLocation>^RESTUtils.ServiceF123.LogInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
