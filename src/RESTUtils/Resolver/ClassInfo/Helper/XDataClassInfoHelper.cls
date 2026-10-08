Class RESTUtils.Resolver.ClassInfo.Helper.XDataClassInfoHelper Extends (%RegisteredObject, %JSON.Adaptor, %XML.Adaptor)
{

Property Name As %String(MAXLEN = "", XMLPROJECTION = "ATTRIBUTE");

Property Include As %String(MAXLEN = "", XMLPROJECTION = "ATTRIBUTE");

Property Reference As %String(VALUELIST = ",INOUT,INPUTONLY,OUTPUTONLY,NONE", XMLPROJECTION = "ATTRIBUTE");

Property FieldName As %String(MAXLEN = "");

}
