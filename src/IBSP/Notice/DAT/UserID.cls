/// Persitent Class for list of IDs of a Subscriber
Class IBSP.Notice.DAT.UserID Extends (%Persistent, Form.Adaptor)
{

Parameter FORMNAME = "UserID";

Parameter DISPLAYPROPERTY = "Type";

Parameter FORMORDERBY = "Type";

/// Subscriber
Property Subscriber As IBSP.Notice.DAT.Subscriber(%JSONREFERENCE = "ID");

/// Type of UserId
Property Type As %String;

/// Code of User
Property Code As %String;

ForeignKey FKSubscriber(Subscriber) References IBSP.Notice.DAT.Subscriber() [ SqlName = FK_UserID_Subcriber ];

/// Necessary for RESTForms2. This query is called when the "list" URL is invoked
ClassMethod queryLIST() As %String
{
    quit "%id _id, " _
         "Type, " _
         "Code "
}

Storage Default
{
<Data name="UserIDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Subscriber</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice.DAT.UserIDD</DataLocation>
<DefaultData>UserIDDefaultData</DefaultData>
<IdLocation>^IBSP.Notice.DAT.UserIDD</IdLocation>
<IndexLocation>^IBSP.Notice.DAT.UserIDI</IndexLocation>
<StreamLocation>^IBSP.Notice.DAT.UserIDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
