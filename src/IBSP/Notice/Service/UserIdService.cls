Class IBSP.Notice.Service.UserIdService
{

ClassMethod getByTypeAndCode(type As %String, code As %String, Output userId As IBSP.Notice.DAT.UserID) As %Status
{
    set sc = $$$OK

    try {

        set userId = ""

        &sql(
            SELECT ID INTO :id
              FROM IBSP_Notice_DAT.UserID
             WHERE Type = :type
               AND Code = :code
        )

        set:(id > 0) userId = ##class(IBSP.Notice.DAT.UserID).%OpenId(id) 
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod create(subscriber As IBSP.Notice.DAT.Subscriber, type As %String, code As %String) As %Status
{
    set sc = $$$OK

    try {

        if code '= "" {

            set userID = ##class(IBSP.Notice.DAT.UserID).%New()
            set userID.Subscriber = subscriber
            set userID.Type = type
            set userID.Code = code

            $$$ThrowOnError(userID.%Save(0))
        }
    } catch ex {
        set sc = ex.AsStatus
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
                  FROM IBSP_Notice_DAT.UserID
                 WHERE Subscriber = :subscriberId
                   AND Type = :type
            )

            set:(SQLCODE '= 0) sc = $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.UserIdService.delete] SQLCODE error " _ SQLCODE _ " " _ %msg)
        }
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod getCodeBySubscriberIdAndType(subscriberId As %BigInt, type As %String, Output code As %String(MAXLEN="")) As %Status
{
    set tSC = $$$OK

    try {
        &sql(
            SELECT Code INTO :code
			  FROM IBSP_Notice_DAT.UserId
			 WHERE Subscriber = :subscriberId
               AND Type = :type
        )
    } catch ex {
        set tSC = ex.AsStatus()
    }

    quit tSC
}

}
