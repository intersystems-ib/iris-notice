Class IBSP.Notice.Service.ContactWayService
{

Parameter ContactWayTelegramType = "telegram";

Parameter ContactWayEmailType = "email";

ClassMethod GetByTypeAndAddress(type As %String, address As %String, Output contactWay As IBSP.Notice.DAT.ContactWay) As %Status
{
    set sc = $$$OK

    try {

        set contactWay = ""

        &sql(
            SELECT ID INTO :id
              FROM IBSP_Notice_DAT.ContactWay
             WHERE Type = :type
               AND Address = :address
        )

        set:(id > 0) contactWay = ##class(IBSP.Notice.DAT.ContactWay).%OpenId(id) 
    } catch ex {
        set sc = ex.AsStatus()
    }

    return sc
}

ClassMethod Create(subscriber As IBSP.Notice.DAT.Subscriber, type As %String, address As %String) As %Status
{
    return:(address = "") $$$OK

    set userID = ##class(IBSP.Notice.DAT.ContactWay).%New()
    set userID.Subscriber = subscriber
    set userID.Type = type
    set userID.Address = address

    return userID.%Save(0)
}

ClassMethod Update(subscriber As IBSP.Notice.DAT.Subscriber, type As %String, address As %String) As %Status
{
    return:(address = "") $$$OK

    set subscriberId = subscriber.%Id()

    &sql(
        UPDATE IBSP_Notice_DAT.ContactWay
            SET Address = :address
            WHERE Subscriber = :subscriberId
            AND Type = :type
    )

    return:(SQLCODE '= 0) $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.ContactWayService.Update] SQLCODE error " _ SQLCODE _ " " _ %msg)

    return $$$OK
}

ClassMethod Delete(subscriber As IBSP.Notice.DAT.Subscriber, type As %String) As %Status
{
    return:(type = "") $$$OK

    set subscriberId = subscriber.%Id()

    &sql(
        DELETE
            FROM IBSP_Notice_DAT.ContactWay
            WHERE Subscriber = :subscriberId
            AND Type = :type
    )

    return:(SQLCODE '= 0) $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.ContactWayService.Delete] SQLCODE error " _ SQLCODE _ " " _ %msg)

    return $$$OK
}

ClassMethod GetAddressBySubscriberIdAndType(subscriberId As %BigInt, type As %String, Output address As %String(MAXLEN="")) As %Status
{
    set sc = $$$OK

    try {
        &sql(
            SELECT Address INTO :address
			  FROM IBSP_Notice_DAT.ContactWay
			 WHERE Subscriber = :subscriberId
               AND Type = :type
        )
    } catch ex {
        set sc = ex.AsStatus()
    }

    return sc
}

ClassMethod GetTelegramAddressBySubscriber(subscriber As IBSP.Notice.DAT.Subscriber, Output telegramAddress As %String(MAXLEN="")) As %Status
{
    return ..GetAddressBySubscriberIdAndType(subscriber.%Id(), ..#ContactWayTelegramType, .telegramAddress)
}

ClassMethod GetEmailAddressBySubscriber(subscriber As IBSP.Notice.DAT.Subscriber, Output emailAddress As %String(MAXLEN="")) As %Status
{
    return ..GetAddressBySubscriberIdAndType(subscriber.%Id(), ..#ContactWayEmailType, .emailAddress)
}

}
