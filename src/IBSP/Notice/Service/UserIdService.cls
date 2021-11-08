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

}
