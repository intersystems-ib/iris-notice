Class IBSP.Notice.Request.PullNoticeRequest Extends IBSP.Notice.Request.NoticeRequest
{

Property DataTarget As %String;

Property Command As %String;

Property ReplyId As %String;

Method %OnNew() As %Status [ Private, ServerOnly = 1 ]
{
    set ..NotificationType = "PULL"

    quit $$$OK
}

Storage Default
{
<Data name="PullNoticeRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DataTarget</Value>
</Value>
<Value name="3">
<Value>Command</Value>
</Value>
<Value name="4">
<Value>ReplyId</Value>
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
<Value>Text</Value>
</Value>
<Value name="14">
<Value>TextParams</Value>
</Value>
<Value name="15">
<Value>Topic</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notic7B55.PullNoticeR8799D</DataLocation>
<DefaultData>PullNoticeRequestDefaultData</DefaultData>
<IdLocation>^IBSP.Notic7B55.PullNoticeR8799D</IdLocation>
<IndexLocation>^IBSP.Notic7B55.PullNoticeR8799I</IndexLocation>
<StreamLocation>^IBSP.Notic7B55.PullNoticeR8799S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
