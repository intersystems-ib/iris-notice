Class IBSP.Notice.Service.NotificationService
{

ClassMethod IsPublishedForSubscriber(topicId As %BigInt, element As %String, subscriberId As %BigInt) As %Boolean
{
	set result = $$$NO

	try {

		&sql(
			SELECT count(*) INTO :count
			  FROM IBSP_Notice_DAT.Notification
			 WHERE NotificationType = 'PUSH'
			   AND Result = 'OK'
			   AND Subscriber = :subscriberId
			   AND Element = :element
			   AND Topic = :topicId
		)

		set result = (count > 0)
	} catch ex {
		; No action needed
	}

	return result
}

ClassMethod GetNumNotificationsBySubscriber(subscriber As IBSP.Notice.DAT.Subscriber, Output numPullNotifications As %Integer, Output numPushNotifications As %Integer) As %Status
{
	#define IsPullNotification(%notificationType) ("PULL" = %notificationType)

    set sc = $$$OK

    try {

        set (numPullNotifications, numPushNotifications) = 0

        set select = "SELECT NotificationType, count(*) As NumNotifications "
        set from = "FROM IBSP_Notice_DAT.Notification "
        set where = "WHERE Subscriber = ? "
		set groupBy = "GROUP BY NotificationType "
        set query = select _ from _ where _ groupBy

        set statement = ##class(%SQL.Statement).%New()
        $$$ThrowOnError(statement.%Prepare(query))

        set result = statement.%Execute(subscriber.%Id())

        while result.%Next() {

			set notificationType = result.%Get("NotificationType")
			set numNotifications = result.%Get("NumNotifications")

			if $$$IsPullNotification(notificationType) {
				set numPullNotifications = numNotifications
			} else {
				set numPushNotifications = numNotifications
			}
		}
    } catch ex {
        set sc = ex.AsStatus()
    }
    
    return sc
}

ClassMethod DeleteAllBySubscriber(subscriber As IBSP.Notice.DAT.Subscriber) As %Status
{
    set subscriberId = subscriber.%Id()

    &sql(
        DELETE
            FROM IBSP_Notice_DAT.Notification
            WHERE Subscriber = :subscriberId
    )

    return:((SQLCODE '= 0) && (SQLCODE '= 100)) $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.NotificationService.DeleteAllBySubscriber] SQLCODE error " _ SQLCODE _ " " _ %msg)

    return $$$OK
}

}
