Class IBSP.Notice.Request.RESTNoticeRequest Extends IBSP.Notice.Request.NoticeRequest
{

Method %OnNew(noticeRequest As IBSP.Notice.Request.NoticeRequest = "") As %Status [ Private, ServerOnly = 1 ]
{
    return:('$isobject(noticeRequest)) $$$OK

    set ..Topic = noticeRequest.Topic
    set ..Text = noticeRequest.Text
    set ..Token = noticeRequest.Token
    set ..Element = noticeRequest.Element
    set ..Subscriber = noticeRequest.Subscriber
    set ..Error = noticeRequest.Error
    set ..UserIdCode = noticeRequest.UserIdCode
    set ..UserIdType = noticeRequest.UserIdType
    set ..ContactWayAddress = noticeRequest.ContactWayAddress
    set ..NotificationType = noticeRequest.NotificationType

    return $$$OK
}

Storage Default
{
<Data name="RESTNoticeRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Topic</Value>
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
</Data>
<DataLocation>^IBSP.Notic7B55.RESTNoticeR1B6AD</DataLocation>
<DefaultData>RESTNoticeRequestDefaultData</DefaultData>
<IdLocation>^IBSP.Notic7B55.RESTNoticeR1B6AD</IdLocation>
<IndexLocation>^IBSP.Notic7B55.RESTNoticeR1B6AI</IndexLocation>
<StreamLocation>^IBSP.Notic7B55.RESTNoticeR1B6AS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
