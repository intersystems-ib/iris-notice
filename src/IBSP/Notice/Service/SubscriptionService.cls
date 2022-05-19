Class IBSP.Notice.Service.SubscriptionService
{

ClassMethod Create(subscriber As IBSP.Notice.DAT.Subscriber, topic As %String) As %Status
{
    return:(topic = "") $$$OK

    set subscription = ##class(IBSP.Notice.DAT.Subscription).%New()
    set subscription.Subscriber = subscriber
    set subscription.Topic = topic

    return subscription.%Save(0)
}

ClassMethod Delete(subscriber As IBSP.Notice.DAT.Subscriber, topic As %String) As %Status
{
    return:(topic = "") $$$OK

    set subscriberId = subscriber.%Id()

    &sql(
        DELETE
            FROM IBSP_Notice_DAT.Subscription
            WHERE Subscriber = :subscriberId
            AND UPPER(Topic) = :topic
    )

    return:((SQLCODE '= 0) && (SQLCODE '= 100)) $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.SubscriptionService.Delete] SQLCODE error " _ SQLCODE _ " " _ %msg)

    return $$$OK
}

ClassMethod DeleteAll(subscriber As IBSP.Notice.DAT.Subscriber) As %Status
{
    set subscriberId = subscriber.%Id()

    &sql(
        DELETE
            FROM IBSP_Notice_DAT.Subscription
            WHERE Subscriber = :subscriberId
    )

    return:((SQLCODE '= 0) && (SQLCODE '= 100)) $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.SubscriptionService.DeleteAll] SQLCODE error " _ SQLCODE _ " " _ %msg)

    return $$$OK
}

ClassMethod GetSubscriptionBySubscriberIdAndTopic(subscriberId As %BigInt, topic As %String, Output subscription As IBSP.Notice.DAT.Subscription) As %Status
{
    set sc = $$$OK
    set subscription = ""

    &sql(
        SELECT ID INTO :id
            FROM IBSP_Notice_DAT.Subscription
            WHERE Subscriber = :subscriberId
            AND UPPER(Topic) = :topic
    )

    return:(SQLCODE '= 0) $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.SubscriptionService.GetSubscriptionBySubscriberIdAndTopic] SQLCODE error " _ SQLCODE _ " " _ %msg)

    set:(id > 0) subscription = ##class(IBSP.Notice.DAT.Subscription).%OpenId(id, .sc) 

    return sc
}

ClassMethod GetTopicsBySubscriberId(subscriberId As %BigInt, Output topics As %ListOfDataTypes) As %Status
{
    set topics = ##class(%ListOfDataTypes).%New()

    &sql(
        DECLARE subscriptions CURSOR FOR
        SELECT Topic INTO :topic
            FROM IBSP_Notice_DAT.Subscription
            WHERE Subscriber = :subscriberId
        ORDER BY Topic
    )
    &sql(OPEN subscriptions)
    return:(SQLCODE '= 0) $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.SubscriptionService.GetTopicsBySubscriberId] SQLCODE error " _ SQLCODE _ " " _ %msg)

    for {
        &sql(FETCH subscriptions)
        quit:(SQLCODE '= 0)

        do topics.Insert(topic)
    }
    return:(SQLCODE '= 100) $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.SubscriptionService.GetTopicsBySubscriberId] SQLCODE error " _ SQLCODE _ " " _ %msg)

    &sql(CLOSE subscriptions)
    return:(SQLCODE '= 0) $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.SubscriptionService.GetTopicsBySubscriberId] SQLCODE error " _ SQLCODE _ " " _ %msg)

    return $$$OK
}

ClassMethod GetNumSubscriptionsBySubscriber(subscriber As IBSP.Notice.DAT.Subscriber, Output numSubscriptions As %Integer) As %Status
{
    set sc = $$$OK

    try {

        set numSubscriptions = 0

        set select = "SELECT count(*) As NumSubscriptions "
        set from = "FROM IBSP_Notice_DAT.Subscription "
        set where = "WHERE Subscriber = ? "
        set query = select _ from _ where

        set result = ##class(%SQL.Statement).%ExecDirect(, query, subscriber.%Id())
        set:(result.%Next()) numSubscriptions = result.%Get("NumSubscriptions")
    } catch ex {
        set sc = ex.AsStatus()
    }
    
    return sc
}

}
