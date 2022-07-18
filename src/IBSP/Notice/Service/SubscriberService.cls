Class IBSP.Notice.Service.SubscriberService
{

ClassMethod GetByUserId(userIdType As %String, userIdCode As %String, Output subscriber As IBSP.Notice.DAT.Subscriber) As %Status
{
    set subscriber = ""
    $$$QuitOnError(##class(IBSP.Notice.Service.UserIdService).GetByTypeAndCode(userIdType, userIdCode, .userId))
    set:($isobject(userId) && userId.Subscriber.Active) subscriber = userId.Subscriber

    return $$$OK
}

ClassMethod GetByContactWay(contactWayType As %String, contactWayAddress As %String, Output subscriber As IBSP.Notice.DAT.Subscriber) As %Status
{
    set subscriber = ""
    $$$QuitOnError(##class(IBSP.Notice.Service.ContactWayService).GetByTypeAndAddress(contactWayType, contactWayAddress, .contactWay))
    set:($isobject(contactWay) && contactWay.Subscriber.Active) subscriber = contactWay.Subscriber

    return $$$OK
}

ClassMethod GetByTopic(topicKey As %String, Output subscribers As %ListOfObjects) As %Status
{
    set sc = $$$OK
    set subscribers = ##class(%ListOfObjects).%New()

    try {

        set select = "SELECT Subscriber "
        set from = "FROM IBSP_Notice_DAT.Subscription "
        set where = "WHERE Topic = ? "
                  _ "OR (CHARINDEX('*', Topic) > 0 "
                  _ "    AND ? %STARTSWITH SUBSTR(Topic, 1, CHARINDEX('*', Topic) -2))"
        set query = select _ from _ where

        set result = ##class(%SQL.Statement).%ExecDirect(, query, topicKey, topicKey)
        while result.%Next() {

            set subscriberId = result.%Get("Subscriber")
            set subscriber = ##class(IBSP.Notice.DAT.Subscriber).%OpenId(subscriberId)
            do:(subscriber.Active) subscribers.Insert(subscriber)
        }
    } catch ex {
        set sc = ex.AsStatus()
    }

    return sc
}

ClassMethod ExistsByUserId(userIdType As %String, userIdCode As %String) As %Boolean
{
    try {
        
        $$$ThrowOnError(##class(IBSP.Notice.Service.UserIdService).GetByTypeAndCode(userIdType, userIdCode, .userId))
        set exists = $isobject(userId)
    } catch ex {
        set exists = $$$NO
    }

    return exists
}

ClassMethod GetManagerEmail(subscriber As IBSP.Notice.DAT.Subscriber, Output managerEmail As %String(MAXLEN="")) As %Status
{
    $$$QuitOnError(..GetManagerBySubscriber(subscriber, .manager))
    return:('$data(manager) || (manager = "")) $$$OK
    return ##class(IBSP.Notice.Service.ContactWayService).GetEmailAddressBySubscriber(manager, .managerEmail)
}

ClassMethod GetManagerBySubscriber(subscriber As IBSP.Notice.DAT.Subscriber, Output manager As IBSP.Notice.DAT.Subscriber) As %Status [ Internal, Private ]
{
    $$$QuitOnError(##class(IBSP.Notice.Service.UserIdService).GetManagerIdBySubscriber(subscriber, .managerId))
    return:('$data(managerId) || (managerId = "")) $$$OK
    return ..GetByUserId(##class(IBSP.Notice.Service.UserIdService).#UserIdEmployeeIdType, managerId, .manager)
}

ClassMethod IsSubscribedToTopic(subscriberId As %BigInt, topicKey As %String) As %Boolean
{
    set subscribed = $$$NO

    try {

        set select = "SELECT COUNT(1) total "
        set from = "FROM IBSP_Notice_DAT.Subscription "
        set where = "WHERE Subscriber = ? "
                  _ "AND (Topic = ? "
                  _ "     OR (CHARINDEX('*', Topic) > 0 "
                  _ "         AND ? %STARTSWITH SUBSTR(Topic, 1, CHARINDEX('*', Topic) -2)))"
        set query = select _ from _ where

        set result = ##class(%SQL.Statement).%ExecDirect(, query, subscriberId, topicKey, topicKey)
        set:(result.%Next()) subscribed = (result.%Get("total") > 0)
    } catch ex {
        set subscribed = $$$NO
    }

    return subscribed
}

}
