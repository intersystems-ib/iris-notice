Class IBSP.Notice.Service.SubscriptionService
{

ClassMethod create(subscriber As IBSP.Notice.DAT.Subscriber, topic As %String) As %Status
{
    set sc = $$$OK

    try {

        if topic '= "" {

            set subscription = ##class(IBSP.Notice.DAT.Subscription).%New()
            set subscription.Subscriber = subscriber
            set subscription.Topic = topic

            $$$ThrowOnError(subscription.%Save(0))
        }
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod delete(subscriber As IBSP.Notice.DAT.Subscriber, topic As %String) As %Status
{
    set sc = $$$OK

    try {

        if topic '= "" {

            set subscriberId = subscriber.%Id()

            &sql(
                DELETE
                 FROM IBSP_Notice_DAT.Subscription
                 WHERE Subscriber = :subscriberId
                   AND UPPER(Topic) = :topic
            )

            set:((SQLCODE '= 0) && (SQLCODE '= 100)) sc = $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.SubscriptionService.delete] SQLCODE error " _ SQLCODE _ " " _ %msg)
        }
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod deleteAll(subscriber As IBSP.Notice.DAT.Subscriber) As %Status
{
    set sc = $$$OK

    try {

        set subscriberId = subscriber.%Id()

        &sql(
            DELETE
                FROM IBSP_Notice_DAT.Subscription
                WHERE Subscriber = :subscriberId
        )

        set:((SQLCODE '= 0) && (SQLCODE '= 100)) sc = $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.SubscriptionService.deleteAll] SQLCODE error " _ SQLCODE _ " " _ %msg)
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod getSubscriptionBySubscriberIdAndTopic(subscriberId As %BigInt, topic As %String, Output subscription As IBSP.Notice.DAT.Subscription) As %Status
{
    set sc = $$$OK

    try {

        set subscription = ""

        &sql(
            SELECT ID INTO :id
              FROM IBSP_Notice_DAT.Subscription
             WHERE Subscriber = :subscriberId
               AND UPPER(Topic) = :topic
        )

        set:(id > 0) subscription = ##class(IBSP.Notice.DAT.Subscription).%OpenId(id) 
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod getTopicsBySubscriberId(subscriberId As %BigInt, Output topics As %ListOfDataTypes) As %Status
{
    set tSC = $$$OK

    try {
        set topics = ##class(%ListOfDataTypes).%New()

        &sql(
            DECLARE subscriptions CURSOR FOR
            SELECT Topic INTO :topic
			  FROM IBSP_Notice_DAT.Subscription
			 WHERE Subscriber = :subscriberId
            ORDER BY Topic
        )
        &sql(OPEN subscriptions)
        return:(SQLCODE '= 0) $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.SubscriptionService.getTopicsBySubscriberId] SQLCODE error " _ SQLCODE _ " " _ %msg)

        for {
            &sql(FETCH subscriptions)
            quit:(SQLCODE '= 0)

            do topics.Insert(topic)
        }
        return:(SQLCODE '= 100) $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.SubscriptionService.getTopicsBySubscriberId] SQLCODE error " _ SQLCODE _ " " _ %msg)

        &sql(CLOSE subscriptions)
        return:(SQLCODE '= 0) $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.SubscriptionService.getTopicsBySubscriberId] SQLCODE error " _ SQLCODE _ " " _ %msg)
    } catch ex {
        set tSC = ex.AsStatus()
    }

    quit tSC
}

}
