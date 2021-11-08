Include notice

Class IBSP.Notice.REST.Service.SubscriberService Extends %REST.Impl
{

Parameter ExposeServerExceptions = 0;

ClassMethod createSubscriber(request As IBSP.Notice.REST.Request.CreateSubscriberRequest) As %DynamicObject
{
    set executionResponse = ##class(IBSP.Notice.REST.Response.ExecutionResponse).%New()

    try {

        TSTART

        $$$ThrowOnError(..validateIfUserAlreadyExists(request.cip))
        $$$ThrowOnError(..validateTopics(request.topics))
        $$$ThrowOnError(..createSubscriberFromRequest(request, .subscriber))
        $$$ThrowOnError(..createApplicationIdFromRequest(subscriber, request))
        $$$ThrowOnError(..createCipFromRequest(subscriber, request))
        $$$ThrowOnError(..createSubscriptionsFromRequest(subscriber, request))

        set executionResponse.result = $$$OK
        set response = ##class(IBSP.Notice.REST.Response.SaveSubscriberResponse).%New(subscriber.%Id())
        set executionResponse.response = response

        TCOMMIT
    } catch ex {
        TROLLBACK
        do ..buildErrorResponse(ex.DisplayString(), .executionResponse)
    }

    do executionResponse.%JSONExportToString(.responseString)

    quit {}.%FromJSON(responseString)
}

ClassMethod updateSubscriber(request As IBSP.Notice.REST.Request.UpdateSubscriberRequest) As %DynamicObject
{
    set executionResponse = ##class(IBSP.Notice.REST.Response.ExecutionResponse).%New()

    try {

        TSTART

        $$$ThrowOnError(..getSubscriberByCip(request.cip, .subscriber))
        $$$ThrowOnError(..validateTopics(request.topicsToAdd))
        $$$ThrowOnError(..validateTopics(request.topicsToDelete))
        $$$ThrowOnError(..updateSubscriberFromRequest(request, subscriber))
        $$$ThrowOnError(..updateApplicationIdFromRequest(subscriber, request))
        $$$ThrowOnError(..updateSubscriptionsFromRequest(subscriber, request))

        set executionResponse.result = $$$OK
        set response = ##class(IBSP.Notice.REST.Response.SaveSubscriberResponse).%New(subscriber.%Id())
        set executionResponse.response = response

        TCOMMIT
    } catch ex {
        TROLLBACK
        do ..buildErrorResponse(ex.DisplayString(), .executionResponse)
    }

    do executionResponse.%JSONExportToString(.responseString)

    quit {}.%FromJSON(responseString)
}

ClassMethod getSubscriber(cip As %String) As %DynamicObject
{
    set executionResponse = ##class(IBSP.Notice.REST.Response.ExecutionResponse).%New()

    try {

        $$$ThrowOnError(..getSubscriberResponseByCip(cip, .response))
        set executionResponse.result = $$$OK
        set executionResponse.response = response
    } catch ex {
        do ..buildErrorResponse(ex.DisplayString(), .executionResponse)
    }

    do executionResponse.%JSONExportToString(.responseString)

    quit {}.%FromJSON(responseString)
}

ClassMethod validateIfUserAlreadyExists(cip As %String) As %Status [ Internal, Private ]
{
    quit:(cip = "") $$$OK
 
    set exists = ##class(IBSP.Notice.Service.SubscriberService).existsByUserId($$$CIP, cip)
    quit:(exists) $$$ERROR($$$GeneralError, "User with cip " _ cip _ " already exists")

    quit $$$OK
}

ClassMethod validateTopics(topics As %Collection.ListOfDT) As %Status [ Internal, Private ]
{
    quit:(topics = "") $$$OK
    quit:(topics.Count() = 0) $$$OK

    for i = 1: 1: topics.Count() {

        set topic = topics.GetAt(i)
        set topicPackage = $$$toUpperCase($piece(topic, "."))

        return:('$$$isAppTauliTopic(topicPackage)) $$$ERROR($$$GeneralError, "Invalid topic " _ topic)
    }
 
    quit $$$OK
}

ClassMethod createSubscriberFromRequest(request As IBSP.Notice.REST.Request.CreateSubscriberRequest, Output subscriber As IBSP.Notice.DAT.Subscriber) As %Status [ Internal, Private ]
{
    set subscriber = ##class(IBSP.Notice.DAT.Subscriber).%New()
    set subscriber.Name = request.name
    set subscriber.SurName = request.surname

    set language = ..getLanguage(request.language)
    set:($isobject(language)) subscriber.Lang = language

    quit subscriber.%Save(0)
}

ClassMethod createApplicationIdFromRequest(subscriber As IBSP.Notice.DAT.Subscriber, request As IBSP.Notice.REST.Request.CreateSubscriberRequest) As %Status [ Internal, Private ]
{
    quit ##class(IBSP.Notice.Service.ContactWayService).create(subscriber, $$$ApplicationId, request.applicationId)
}

ClassMethod createCipFromRequest(subscriber As IBSP.Notice.DAT.Subscriber, request As IBSP.Notice.REST.Request.CreateSubscriberRequest) As %Status [ Internal, Private ]
{
    quit ##class(IBSP.Notice.Service.UserIdService).create(subscriber, $$$CIP, request.cip)
}

ClassMethod createSubscriptionsFromRequest(subscriber As IBSP.Notice.DAT.Subscriber, request As IBSP.Notice.REST.Request.CreateSubscriberRequest) As %Status [ Internal, Private ]
{
    set topics = request.topics
    quit:(topics = "") $$$OK
    quit:(topics.Count() = 0) $$$OK

    if (topics = "") || (topics.Count() = 0) {
        set topics = ##class(%ListOfDataTypes).%New()
        do topics.Insert($$$AppTauliTopic)
    }

    set sc = $$$OK

    try {

        for i = 1: 1: topics.Count() {

            set topic = topics.GetAt(i)
            $$$buildValidTopic(topic)

            $$$ThrowOnError(##class(IBSP.Notice.Service.SubscriptionService).create(subscriber, topic))
        }

    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod getLanguage(requestLanguage As %String) As IBSP.Notice.DAT.Lang [ Internal, Private ]
{
    try {

        set requestLanguage = $$$getLastTwoChars(requestLanguage)
        set:(requestLanguage '= "") language = ##class(IBSP.Notice.DAT.Lang).UIISOOpen(requestLanguage)
        set:('$isobject(language)) language = ##class(IBSP.Notice.DAT.Lang).getDefault()
    } catch ex {
        set language = ""
    }

    quit language
}

ClassMethod getSubscriberByCip(cip As %String, Output subscriber As IBSP.Notice.DAT.Subscriber) As %Status [ Internal, Private ]
{
    set sc = $$$OK

    try {

        $$$ThrowOnError(##class(IBSP.Notice.Service.SubscriberService).getByUserId($$$CIP, cip, .subscriber))
        set:('$isobject(subscriber)) sc = $$$ERROR($$$GeneralError, "User with cip " _ cip _ " doesn't exist")
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod updateSubscriberFromRequest(request As IBSP.Notice.REST.Request.UpdateSubscriberRequest, subscriber As IBSP.Notice.DAT.Subscriber) As %Status [ Internal, Private ]
{
    set subscriber.Name = request.name
    set subscriber.SurName = request.surname

    set language = ..getLanguage(request.language)
    set:($isobject(language)) subscriber.Lang = language

    quit subscriber.%Save(0)
}

ClassMethod updateApplicationIdFromRequest(subscriber As IBSP.Notice.DAT.Subscriber, request As IBSP.Notice.REST.Request.UpdateSubscriberRequest) As %Status [ Internal, Private ]
{
    quit ##class(IBSP.Notice.Service.ContactWayService).update(subscriber, $$$ApplicationId, request.applicationId)
}

ClassMethod updateSubscriptionsFromRequest(subscriber As IBSP.Notice.DAT.Subscriber, request As IBSP.Notice.REST.Request.UpdateSubscriberRequest) As %Status [ Internal, Private ]
{
    set sc = $$$OK

    try {

        $$$ThrowOnError(..addSubscriptions(subscriber, request))
        $$$ThrowOnError(..deleteSubscriptions(subscriber, request))
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod addSubscriptions(subscriber As IBSP.Notice.DAT.Subscriber, request As IBSP.Notice.REST.Request.UpdateSubscriberRequest) As %Status [ Internal, Private ]
{
    set topics = request.topicsToAdd
    quit:(topics = "") $$$OK
    quit:(topics.Count() = 0) $$$OK

    set sc = $$$OK

    try {

        for i = 1: 1: topics.Count() {

            set topic = topics.GetAt(i)
            $$$buildValidTopic(topic)

            $$$ThrowOnError(##class(IBSP.Notice.Service.SubscriptionService).getSubscriptionBySubscriberIdAndTopic(subscriber.%Id(), $$$toUpperCase(topic), .subscription))
            if '$isobject(subscription) {
                $$$ThrowOnError(##class(IBSP.Notice.Service.SubscriptionService).create(subscriber, topic))
            }
        }

    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod deleteSubscriptions(subscriber As IBSP.Notice.DAT.Subscriber, request As IBSP.Notice.REST.Request.UpdateSubscriberRequest) As %Status [ Internal, Private ]
{
    set topics = request.topicsToDelete
    quit:(topics = "") $$$OK
    quit:(topics.Count() = 0) $$$OK

    set sc = $$$OK

    try {

        for i = 1: 1: topics.Count() {

            set topic = topics.GetAt(i)
            $$$buildValidTopic(topic)

            $$$ThrowOnError(##class(IBSP.Notice.Service.SubscriptionService).delete(subscriber, $$$toUpperCase(topic)))
        }

    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod getSubscriberResponseByCip(cip As %String, Output response As IBSP.Notice.REST.Response.SubscriberResponse) As %Status [ Internal, Private ]
{
    set sc = $$$OK

    try {

        set response = ##class(IBSP.Notice.REST.Response.SubscriberResponse).%New()

        $$$ThrowOnError(##class(IBSP.Notice.Service.SubscriberService).getByUserId($$$CIP, cip, .subscriber))

        if $isobject(subscriber) {

            set subscriberId = subscriber.%Id()

            set response.id = subscriberId
            set response.name = subscriber.Name
            set response.surname = subscriber.SurName
            set:($isobject(subscriber.Lang)) response.language = subscriber.Lang.ISO
            set response.cip = cip

            $$$ThrowOnError(##class(IBSP.Notice.Service.ContactWayService).getContactWayAddressBySubscriberIdAndType(subscriberId, $$$ApplicationId, .applicationId))
            set response.applicationId = applicationId

            $$$ThrowOnError(##class(IBSP.Notice.Service.SubscriptionService).getTopicsBySubscriberId(subscriberId, .topics))
            set response.topics = topics
        }
    } catch ex {
        set sc = ex.AsStatus()
    }

    quit sc
}

ClassMethod buildErrorResponse(errorMessage As %String, Output executionResponse As IBSP.Notice.REST.Response.ExecutionResponse) As %Status [ Internal, Private ]
{
    set executionResponse.result = $$$ERRORSTATUS

    set response = ##class(IBSP.Notice.REST.Response.ErrorResponse).%New(errorMessage)
    set executionResponse.response = response

    quit $$$OK
}

}
