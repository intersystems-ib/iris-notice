Class IBSP.Notice.Service.ContactWayService
{

ClassMethod getByTypeAndAddress(type As %String, address As %String, Output contactWay As IBSP.Notice.DAT.ContactWay) As %Status
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

    quit sc
}

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

ClassMethod delete(subscriber As IBSP.Notice.DAT.Subscriber, type As %String) As %Status
{
    set sc = $$$OK

    try {

        if type '= "" {

            set subscriberId = subscriber.%Id()

            &sql(
                DELETE
                  FROM IBSP_Notice_DAT.ContactWay
                 WHERE Subscriber = :subscriberId
                   AND Type = :type
            )

            set:(SQLCODE '= 0) sc = $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.ContactWayService.delete] SQLCODE error " _ SQLCODE _ " " _ %msg)
        }
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod getAddressBySubscriberIdAndType(subscriberId As %BigInt, type As %String, Output address As %String(MAXLEN="")) As %Status
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
