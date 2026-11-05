Class IBSP.Notice.DAT.ContactWayType Extends (%Persistent, RESTUtils.JSON.Adaptor, %XML.Adaptor)
{

/// Código técnico estable, 
Property Code As %String(MAXLEN = "") [ Required ];

/// Nombre que se muestra en la interfaz.
Property Description As %String(MAXLEN = "") [ Calculated, SqlComputeCode = {Set {*} = {Code}}, SqlComputed ];

/// Los tipos inactivos se conservan en el histórico, pero no se ofrecen
/// al crear nuevos identificadores.
Property Active As %Boolean [ InitialExpression = 1, Required ];

Index CodeUnique On Code [ Unique ];
Storage Default
{
<Data name="ContactWayTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice419.ContactWayTypeD</DataLocation>
<DefaultData>ContactWayTypeDefaultData</DefaultData>
<IdLocation>^IBSP.Notice419.ContactWayTypeD</IdLocation>
<IndexLocation>^IBSP.Notice419.ContactWayTypeI</IndexLocation>
<StreamLocation>^IBSP.Notice419.ContactWayTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
