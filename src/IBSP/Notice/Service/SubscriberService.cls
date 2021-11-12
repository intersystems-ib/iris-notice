Class IBSP.Notice.Service.SubscriberService
{

ClassMethod getByUserId(userIdType As %String, userIdCode As %String, Output subscriber As IBSP.Notice.DAT.Subscriber) As %Status
{
    set sc = $$$OK

    try {

        set subscriber = ""
        $$$ThrowOnError(##class(IBSP.Notice.Service.UserIdService).getByTypeAndCode(userIdType, userIdCode, .userId))
        set:($isobject(userId)) subscriber = userId.Subscriber
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod getByContactWay(contactWayType As %String, contactWayAddress As %String, Output subscriber As IBSP.Notice.DAT.Subscriber) As %Status
{
    set sc = $$$OK

    try {

        set subscriber = ""
        $$$ThrowOnError(##class(IBSP.Notice.Service.ContactWayService).getByTypeAndAddress(contactWayType, contactWayAddress, .contactWay))
        set:($isobject(contactWay)) subscriber = contactWay.Subscriber
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod existsByUserId(userIdType As %String, userIdCode As %String) As %Boolean
{
    try {
        
        $$$ThrowOnError(##class(IBSP.Notice.Service.UserIdService).getByTypeAndCode(userIdType, userIdCode, .userId))
        set exists = $isobject(userId)
    } catch ex {
        set exists = $$$NO
    }

    quit exists
}

}
