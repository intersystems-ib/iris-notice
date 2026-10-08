Include RESTUtils.INC.Utils

/// Defines where to call to log endpoint calls, definitions can only be in installation namespace!!!
Class RESTUtils.Persistent.Log.LogDefinition Extends %Persistent
{

/// Spec for a method that will be called to log
Parameter MethodValidFormalSpec = "info:RESTUtils.Service.Log.Helper.LogInfo";

/// namespace the log affects and is defined in
Property Namespace As %String(MAXLEN = "") [ Required ];

/// Web app that this log applies, leave blank to affect the whole namespace
Property Application As %String(MAXLEN = "");

/// Class of the logging method is defined
Property Class As %String(MAXLEN = "") [ Required ];

/// ClassMethod the logging is defined in
Property Method As %String(MAXLEN = "") [ Required ];

Index UIXNamespaceApplication On (Namespace, Application) [ Unique ];

Method %OnValidateObject() As %Status
{
    Return:($NAMESPACE '= $$$InstallationNamespace) ##Class(%Exception.StatusException).%New("Log should only be set in the installation namespace")
    Set namespace = ..Namespace
    $$$SwapNamespace(namespace)
    Set method = ##Class(%Dictionary.CompiledMethod).%OpenId(..Class _ "||" _ ..Method)
    Return:(method = "") ##Class(%Exception.StatusException).%New("Method does not exist")
    Return:(method.FormalSpec '= ..#MethodValidFormalSpec) ##Class(%Exception.StatusException).%New("Invalid arguments for a log method")
    Return:(method.ClassMethod = 0) ##Class(%Exception.StatusException).%New("Method has to be a ClassMethod")
    Return:(method.ReturnType '=  "") ##Class(%Exception.StatusException).%New("Method should not have any return")
    Return $$$OK
}

Storage Default
{
<Data name="LogDefinitionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Namespace</Value>
</Value>
<Value name="3">
<Value>Application</Value>
</Value>
<Value name="4">
<Value>Class</Value>
</Value>
<Value name="5">
<Value>Method</Value>
</Value>
</Data>
<DataLocation>^RESTUtils.Pe35BF.LogDefinitionD</DataLocation>
<DefaultData>LogDefinitionDefaultData</DefaultData>
<ExtentSize>1</ExtentSize>
<IdLocation>^RESTUtils.Pe35BF.LogDefinitionD</IdLocation>
<IndexLocation>^RESTUtils.Pe35BF.LogDefinitionI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Application">
<AverageFieldSize>10</AverageFieldSize>
<OutlierSelectivity>.999999:"/bos/api"</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="Class">
<AverageFieldSize>41</AverageFieldSize>
<OutlierSelectivity>.999999:"BOS.REST.Controller.RESTUtilsController"</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="Method">
<AverageFieldSize>18</AverageFieldSize>
<OutlierSelectivity>.999999:"RESTUtilsLogging"</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="Namespace">
<AverageFieldSize>5</AverageFieldSize>
<OutlierSelectivity>.999999:"BOS"</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="UIXNamespaceApplication">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^RESTUtils.Pe35BF.LogDefinitionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
