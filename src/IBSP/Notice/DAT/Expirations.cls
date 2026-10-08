Class IBSP.Notice.DAT.Expirations Extends (%Persistent, RESTUtils.JSON.Adaptor)
{

Parameter FORMNAME = "Expirations";

Parameter DISPLAYPROPERTY = "Type";

Parameter FORMORDERBY = "Type";

/// Indicates whether the expiration is currently active.
Property Active As %Boolean [ InitialExpression = 1 ];

/// Expiration date of the certificate, license, contract or other item.
Property ExpirationDate As %Date;

/// Instructions to renew or extend the item.
Property RenovationInstructions As %String;

/// Entity or user that issued the item.
Property IssuedBy As %String;

/// Date on which the item was issued.
Property IssuedDate As %Date;

/// Intended use or purpose of the item.
Property Use As %String;

/// Public or internal URL for the item.
Property URL As %String;

/// Customer or client associated with the item.
Property Customer As %String;

/// License or document identifier.
Property LicenseID As %String;

/// Notes or contextual information.
Property Notes As %String;

/// Current status of the record.
Property Status As %String(VALUELIST = ",Open,Closed");

/// Type of document or agreement.
Property Type As %String(VALUELIST = ",Certificate,License,Contract,Other");

Index IdxStatus On Status;

Index IdxType On Type;

Index IdxActive On Active;

Index IdxExpirationDate On ExpirationDate;

Index IdxCustomer On Customer;

Index IdxLicenseID On LicenseID;

Storage Default
{
<Data name="ExpirationsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Active</Value>
</Value>
<Value name="3">
<Value>ExpirationDate</Value>
</Value>
<Value name="4">
<Value>RenovationInstructions</Value>
</Value>
<Value name="5">
<Value>IssuedBy</Value>
</Value>
<Value name="6">
<Value>IssuedDate</Value>
</Value>
<Value name="7">
<Value>Use</Value>
</Value>
<Value name="8">
<Value>URL</Value>
</Value>
<Value name="9">
<Value>Customer</Value>
</Value>
<Value name="10">
<Value>LicenseID</Value>
</Value>
<Value name="11">
<Value>Notes</Value>
</Value>
<Value name="12">
<Value>Status</Value>
</Value>
<Value name="13">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice.DAT.ExpirationsD</DataLocation>
<DefaultData>ExpirationsDefaultData</DefaultData>
<IdLocation>^IBSP.Notice.DAT.ExpirationsD</IdLocation>
<IndexLocation>^IBSP.Notice.DAT.ExpirationsI</IndexLocation>
<StreamLocation>^IBSP.Notice.DAT.ExpirationsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
