Class IBSP.Notice.Request.PushNoticeRequest Extends IBSP.Notice.Request.NoticeRequest
{

Property SendIfPublished As %String;

Method %OnNew() As %Status [ Private, ServerOnly = 1 ]
{
    set ..NotificationType = "PUSH"

    quit $$$OK
}

Storage Default
{
<Data name="PushNoticeRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SendIfPublished</Value>
</Value>
<Value name="3">
<Value>Text</Value>
</Value>
<Value name="4">
<Value>TextParams</Value>
</Value>
<Value name="5">
<Value>Token</Value>
</Value>
<Value name="6">
<Value>Element</Value>
</Value>
<Value name="7">
<Value>Subscriber</Value>
</Value>
<Value name="8">
<Value>Error</Value>
</Value>
<Value name="9">
<Value>UserIdCode</Value>
</Value>
<Value name="10">
<Value>UserIdType</Value>
</Value>
<Value name="11">
<Value>ContactWayAddress</Value>
</Value>
<Value name="12">
<Value>NotificationType</Value>
</Value>
<Value name="13">
<Value>Topic</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notic7B55.PushNoticeR4BC3D</DataLocation>
<DefaultData>PushNoticeRequestDefaultData</DefaultData>
<IdLocation>^IBSP.Notic7B55.PushNoticeR4BC3D</IdLocation>
<IndexLocation>^IBSP.Notic7B55.PushNoticeR4BC3I</IndexLocation>
<StreamLocation>^IBSP.Notic7B55.PushNoticeR4BC3S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
