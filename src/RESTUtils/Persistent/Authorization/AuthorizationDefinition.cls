/// Defines what classes and endpoints can be accessed by what resources. 
/// Can only be edited (via the API) by %All users
/// Some properties are defined as a comma separated list but you must store %String do not store %List
/// Create them only in the installation namespace
Class RESTUtils.Persistent.Authorization.AuthorizationDefinition Extends %Persistent [ SqlTableName = REST_Authorization ]
{

Property Name As %String(MAXLEN = "") [ Required ];

/// Comma separated list of classes, can contain * as a wildcard
Property ClassList As %String(MAXLEN = "") [ Required ];

Property CalculatedClassList As %String(MAXLEN = "") [ SqlComputeCode = {Set {*} = $REPLACE({ClassList}_",", "*", "%")}, SqlComputed ];

/// This is optional, a role can be provided to check if the user holds it. if not provided all are allowed
Property IRISResource As %String(MAXLEN = "");

/// Comma separated list of endpoints, can contain * as a wildcard
Property AllowedEndpoints As %String(MAXLEN = "") [ InitialExpression = "*", Required ];

Property CalculatedAllowedEndpoints As %String(MAXLEN = "") [ SqlComputeCode = {Set {*} = $REPLACE({AllowedEndpoints}_",", "*", "%")}, SqlComputed ];

/// Comma separated list of JSONMappings allowed, this only affects if modification endpoints are allowed, 
/// use $$$DefaultMappingNameKey (defined in Authorization.inc), to allow the null Mapping key to use the default mapping.
/// Can use * to specify all, this is the default behaviour.
/// If no edit endpoints are specified ignore this
Property AllowedJSONMappings As %String(MAXLEN = "") [ InitialExpression = "*", Required ];

/// Namespace which this rule affects, by default installation namespace
Property Namespace As %String(MAXLEN = "") [ InitialExpression = {$NAMESPACE}, Required ];

Index UIXName On Name [ Unique ];

Index IXAuthAccessCheck On (CalculatedClassList, CalculatedAllowedEndpoints, Namespace);

ClassMethod GetSQLTable() As %String(MAXLEN="") [ CodeMode = objectgenerator, ForceGenerate ]
{
    $$$ThrowOnError(%code.WriteLine(" Return """_%compiledclass.SqlSchemaName _ "."_ %compiledclass.SqlTableName_""""))
}

Storage Default
{
<Data name="AuthorizationDefinitionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>ClassList</Value>
</Value>
<Value name="4">
<Value>CalculatedClassList</Value>
</Value>
<Value name="5">
<Value>IRISResource</Value>
</Value>
<Value name="6">
<Value>AllowedEndpoints</Value>
</Value>
<Value name="7">
<Value>CalculatedAllowedEndpoints</Value>
</Value>
<Value name="8">
<Value>AllowedJSONMappings</Value>
</Value>
<Value name="9">
<Value>Namespace</Value>
</Value>
</Data>
<DataLocation>^RESTUtilsA708.AuthorizatiF8EDD</DataLocation>
<DefaultData>AuthorizationDefinitionDefaultData</DefaultData>
<ExtentSize>1</ExtentSize>
<IdLocation>^RESTUtilsA708.AuthorizatiF8EDD</IdLocation>
<IndexLocation>^RESTUtilsA708.AuthorizatiF8EDI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="AllowedEndpoints">
<AverageFieldSize>3</AverageFieldSize>
<OutlierSelectivity>.999999:"*"</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="AllowedJSONMappings">
<AverageFieldSize>3</AverageFieldSize>
<OutlierSelectivity>.999999:"*"</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="CalculatedAllowedEndpoints">
<AverageFieldSize>4</AverageFieldSize>
<OutlierSelectivity>.999999:"%,"</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="CalculatedClassList">
<AverageFieldSize>8</AverageFieldSize>
<OutlierSelectivity>.999999:"BOS.%,"</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="ClassList">
<AverageFieldSize>7</AverageFieldSize>
<OutlierSelectivity>.999999:"BOS.*"</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="IRISResource">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="Name">
<AverageFieldSize>9</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Namespace">
<AverageFieldSize>5</AverageFieldSize>
<OutlierSelectivity>.999999:"BOS"</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="UIXName">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^RESTUtilsA708.AuthorizatiF8EDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
