Class IBSP.Notice.DAT.UserIDType Extends (%Persistent, RESTUtils.JSON.Adaptor)
{

/// Código técnico estable, por ejemplo employeeid o managerid.
Property Code As %String(MAXLEN = "") [ Required ];

/// Nombre que se muestra en la interfaz.
Property Description As %String(MAXLEN = "") [ Calculated, SqlComputeCode = {
    Set {*} = {Code}}, SqlComputed ];

/// Los tipos inactivos se conservan en el histórico, pero no se ofrecen
/// al crear nuevos identificadores.
Property Active As %Boolean [ InitialExpression = 1, Required ];

Index CodeUnique On Code [ Unique ];
Storage Default
{
<Data name="UserIDTypeDefaultData">
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
<DataLocation>^IBSP.Notice.DAT.UserIDTypeD</DataLocation>
<DefaultData>UserIDTypeDefaultData</DefaultData>
<IdLocation>^IBSP.Notice.DAT.UserIDTypeD</IdLocation>
<IndexLocation>^IBSP.Notice.DAT.UserIDTypeI</IndexLocation>
<StreamLocation>^IBSP.Notice.DAT.UserIDTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
