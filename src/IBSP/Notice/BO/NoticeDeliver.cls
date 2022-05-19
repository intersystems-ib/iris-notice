Class IBSP.Notice.BO.NoticeDeliver Extends %RegisteredObject [ Abstract ]
{

ClassMethod SaveNotification(pRequest As IBSP.Notice.Request.NoticeRequest, pResult As %DynamicObject) As %Status
{
	set notification = ##class(IBSP.Notice.DAT.Notification).%New()
	set notification.Topic = pRequest.Topic
	set notification.Element = pRequest.Element
	set notification.BusinessOperation = ..%ClassName(1)
	set notification.NotificationType = pRequest.NotificationType
	set notification.Subscriber = pRequest.Subscriber
	set:(pRequest.Token '= "") notification.DirectData = pRequest.Token _ "|||"
	set notification.DirectData = notification.DirectData _ pRequest.ContactWayAddress
	set notification.Text = pRequest.Text
	set notification.Date = $zdatetime($horolog, 3)   
	set notification.Result = $case(pResult.ok, 1:"OK", :"ERROR")
	set:('pResult.ok) notification.Error = pResult.%ToJSON()

	return notification.%Save()
}

}
