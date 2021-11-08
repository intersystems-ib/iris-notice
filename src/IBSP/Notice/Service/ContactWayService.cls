Class IBSP.Notice.Service.ContactWayService
{

ClassMethod create(subscriber As IBSP.Notice.DAT.Subscriber, type As %String, address As %String) As %Status
{
    set sc = $$$OK

    try {

        if address '= "" {

            set userID = ##class(IBSP.Notice.DAT.ContactWay).%New()
            set userID.Subscriber = subscriber
            set userID.Type = type
            set userID.Address = address

            $$$ThrowOnError(userID.%Save(0))
        }
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod update(subscriber As IBSP.Notice.DAT.Subscriber, type As %String, address As %String) As %Status
{
    set sc = $$$OK

    try {

        if address '= "" {

            set subscriberId = subscriber.%Id()

            &sql(
                UPDATE IBSP_Notice_DAT.ContactWay
                   SET Address = :address
                 WHERE Subscriber = :subscriberId
                   AND Type = :type
            )

            set:(SQLCODE '= 0) sc = $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.ContactWayService.update] SQLCODE error " _ SQLCODE _ " " _ %msg)
        }
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod getContactWayAddressBySubscriberIdAndType(subscriberId As %BigInt, type As %String, Output address As %String(MAXLEN="")) As %Status
{
    set tSC = $$$OK

    try {
        &sql(
            SELECT Address INTO :address
			  FROM IBSP_Notice_DAT.ContactWay
			 WHERE Subscriber = :subscriberId
               AND Type = :type
        )
    } catch ex {
        set tSC = ex.AsStatus()
    }

    quit tSC
}

}
