Include notice

Class IBSP.Notice.REST.Subscriber.Service.SubscriberService Extends %REST.Impl
{

Parameter ExposeServerExceptions = 0;

ClassMethod CreateSubscriber(request As IBSP.Notice.REST.Subscriber.Request.CreateSubscriberRequest) As %DynamicObject
{
    set executionResponse = ##class(IBSP.Notice.REST.Subscriber.Response.ExecutionResponse).%New()

    try {

        TSTART

        $$$ThrowOnError(..ValidateIfUserAlreadyExists(request.cip))
        $$$ThrowOnError(..ValidateTopics(request.topics))
        $$$ThrowOnError(..CreateSubscriberFromRequest(request, .subscriber))
        $$$ThrowOnError(..CreateApplicationIdFromRequest(subscriber, request))
        $$$ThrowOnError(..CreateCipFromRequest(subscriber, request))
        $$$ThrowOnError(..CreateSubscriptionsFromRequest(subscriber, request))

        set executionResponse.result = $$$OK
        set response = ##class(IBSP.Notice.REST.Subscriber.Response.SaveSubscriberResponse).%New(subscriber.%Id())
        set executionResponse.response = response

        TCOMMIT
    } catch ex {
        TROLLBACK
        do ..BuildErrorResponse(ex.DisplayString(), .executionResponse)
    }

    do executionResponse.%JSONExportToString(.responseString)

    return {}.%FromJSON(responseString)
}

ClassMethod UpdateSubscriber(request As IBSP.Notice.REST.Subscriber.Request.UpdateSubscriberRequest) As %DynamicObject
{
    set executionResponse = ##class(IBSP.Notice.REST.Subscriber.Response.ExecutionResponse).%New()

    try {

        TSTART

        $$$ThrowOnError(..GetSubscriberByApplicationId(request.applicationId, .subscriber))
        $$$ThrowOnError(..ValidateTopics(request.topicsToAdd))
        $$$ThrowOnError(..ValidateTopics(request.topicsToDelete))
        $$$ThrowOnError(..UpdateSubscriberFromRequest(request, subscriber))
        $$$ThrowOnError(..UpdateCipFromRequest(subscriber, request))
        $$$ThrowOnError(..UpdateSubscriptionsFromRequest(subscriber, request))

        set executionResponse.result = $$$OK
        set response = ##class(IBSP.Notice.REST.Subscriber.Response.SaveSubscriberResponse).%New(subscriber.%Id())
        set executionResponse.response = response

        TCOMMIT
    } catch ex {
        TROLLBACK
        do ..BuildErrorResponse(ex.DisplayString(), .executionResponse)
    }

    do executionResponse.%JSONExportToString(.responseString)

    return {}.%FromJSON(responseString)
}

ClassMethod GetSubscriber(cip As %String, applicationid As %String) As %DynamicObject
{
    set executionResponse = ##class(IBSP.Notice.REST.Subscriber.Response.ExecutionResponse).%New()

    try {

        if cip '= "" {
            $$$ThrowOnError(..GetSubscriberResponseByCip(cip, .response))
        } else {
            $$$ThrowOnError(..GetSubscriberResponseByApplicationId(applicationid, .response))
        }
        
        set executionResponse.result = $$$OK
        set executionResponse.response = response
    } catch ex {
        do ..BuildErrorResponse(ex.DisplayString(), .executionResponse)
    }

    do executionResponse.%JSONExportToString(.responseString)

    return {}.%FromJSON(responseString)
}

ClassMethod DeleteSubscriber(cip As %String) As %DynamicObject
{
    set executionResponse = ##class(IBSP.Notice.REST.Subscriber.Response.ExecutionResponse).%New()

    try {

        TSTART

        $$$ThrowOnError(..GetSubscriberByCip(cip, .subscriber))
        $$$ThrowOnError(..DeleteSubscriberApplicationId(subscriber))
        $$$ThrowOnError(..DeleteSubscriberCip(subscriber))
        $$$ThrowOnError(..DeleteSubscriberSubscriptions(subscriber))
        $$$ThrowOnError(..DeleteSubscriberNotifications(subscriber))
        $$$ThrowOnError(..DeleteSubscriberObj(subscriber))
        set executionResponse.result = $$$OK
        set response = ##class(IBSP.Notice.REST.Subscriber.Response.SaveSubscriberResponse).%New(-1)
        set executionResponse.response = response

        TCOMMIT
    } catch ex {
        TROLLBACK
        do ..BuildErrorResponse(ex.DisplayString(), .executionResponse)
    }

    do executionResponse.%JSONExportToString(.responseString)

    return {}.%FromJSON(responseString)
}

ClassMethod ValidateIfUserAlreadyExists(cip As %String) As %Status [ Internal, Private ]
{
    return:(cip = "") $$$OK
 
    set exists = ##class(IBSP.Notice.Service.SubscriberService).ExistsByUserId($$$CIP, cip)
    return:(exists) $$$ERROR($$$GeneralError, "User with cip " _ cip _ " already exists")

    return $$$OK
}

ClassMethod ValidateTopics(topics As %Collection.ListOfDT) As %Status [ Internal, Private ]
{
    return:(topics = "") $$$OK
    return:(topics.Count() = 0) $$$OK

    for i = 1: 1: topics.Count() {

        set topic = topics.GetAt(i)
        set topicPackage = $$$toUpperCase($piece(topic, "."))

        return:('$$$isAppTauliTopic(topicPackage)) $$$ERROR($$$GeneralError, "Invalid topic " _ topic)
    }
 
    return $$$OK
}

ClassMethod CreateSubscriberFromRequest(request As IBSP.Notice.REST.Subscriber.Request.CreateSubscriberRequest, Output subscriber As IBSP.Notice.DAT.Subscriber) As %Status [ Internal, Private ]
{
    set subscriber = ##class(IBSP.Notice.DAT.Subscriber).%New()
    set subscriber.Name = request.name
    set subscriber.SurName = request.surname

    set language = ..GetLanguage(request.language)
    set:($isobject(language)) subscriber.Lang = language

    return subscriber.%Save(0)
}

ClassMethod CreateApplicationIdFromRequest(subscriber As IBSP.Notice.DAT.Subscriber, request As IBSP.Notice.REST.Subscriber.Request.CreateSubscriberRequest) As %Status [ Internal, Private ]
{
    return ##class(IBSP.Notice.Service.ContactWayService).Create(subscriber, $$$ApplicationId, request.applicationId)
}

ClassMethod CreateCipFromRequest(subscriber As IBSP.Notice.DAT.Subscriber, request As IBSP.Notice.REST.Subscriber.Request.CreateSubscriberRequest) As %Status [ Internal, Private ]
{
    return ##class(IBSP.Notice.Service.UserIdService).Create(subscriber, $$$CIP, request.cip)
}

ClassMethod CreateSubscriptionsFromRequest(subscriber As IBSP.Notice.DAT.Subscriber, request As IBSP.Notice.REST.Subscriber.Request.CreateSubscriberRequest) As %Status [ Internal, Private ]
{
    set topics = request.topics

    if (topics = "") || (topics.Count() = 0) {
        set topics = ##class(%ListOfDataTypes).%New()
        do topics.Insert($$$AppTauliTopic)
    }

    for i = 1: 1: topics.Count() {

        set topic = topics.GetAt(i)
        $$$buildValidTopic(topic)

        $$$ReturnOnError(##class(IBSP.Notice.Service.SubscriptionService).Create(subscriber, topic))
    }

    return $$$OK
}

ClassMethod GetLanguage(requestLanguage As %String) As IBSP.Notice.DAT.Lang [ Internal, Private ]
{
    try {

        set requestLanguage = $$$getLastTwoChars(requestLanguage)
        set:(requestLanguage '= "") language = ##class(IBSP.Notice.DAT.Lang).UIISOOpen(requestLanguage)
        set:('$isobject(language)) language = ##class(IBSP.Notice.DAT.Lang).GetDefault()
    } catch ex {
        set language = ""
    }

    return language
}

ClassMethod GetSubscriberByCip(cip As %String, Output subscriber As IBSP.Notice.DAT.Subscriber) As %Status [ Internal, Private ]
{
    $$$QuitOnError(##class(IBSP.Notice.Service.SubscriberService).GetByUserId($$$CIP, cip, .subscriber))
    return:('$isobject(subscriber)) $$$ERROR($$$GeneralError, "User with cip " _ cip _ " doesn't exist")

    return $$$OK
}

ClassMethod GetSubscriberByApplicationId(applicationId As %String, Output subscriber As IBSP.Notice.DAT.Subscriber) As %Status [ Internal, Private ]
{
    $$$QuitOnError(##class(IBSP.Notice.Service.SubscriberService).GetByContactWay($$$ApplicationId, applicationId, .subscriber))
    return:('$isobject(subscriber)) $$$ERROR($$$GeneralError, "User with applicationId " _ applicationId _ " doesn't exist")

    return $$$OK
}

ClassMethod UpdateSubscriberFromRequest(request As IBSP.Notice.REST.Subscriber.Request.UpdateSubscriberRequest, subscriber As IBSP.Notice.DAT.Subscriber) As %Status [ Internal, Private ]
{
    set subscriber.Name = request.name
    set subscriber.SurName = request.surname

    set language = ..GetLanguage(request.language)
    set:($isobject(language)) subscriber.Lang = language

    return subscriber.%Save(0)
}

ClassMethod UpdateApplicationIdFromRequest(subscriber As IBSP.Notice.DAT.Subscriber, request As IBSP.Notice.REST.Subscriber.Request.UpdateSubscriberRequest) As %Status [ Internal, Private ]
{
    return ##class(IBSP.Notice.Service.ContactWayService).Update(subscriber, $$$ApplicationId, request.applicationId)
}

ClassMethod UpdateCipFromRequest(subscriber As IBSP.Notice.DAT.Subscriber, request As IBSP.Notice.REST.Subscriber.Request.UpdateSubscriberRequest) As %Status [ Internal, Private ]
{
    return ##class(IBSP.Notice.Service.UserIdService).Update(subscriber, $$$CIP, request.cip)
}

ClassMethod UpdateSubscriptionsFromRequest(subscriber As IBSP.Notice.DAT.Subscriber, request As IBSP.Notice.REST.Subscriber.Request.UpdateSubscriberRequest) As %Status [ Internal, Private ]
{
    $$$QuitOnError(..AddSubscriptions(subscriber, request))
    return ..DeleteSubscriptions(subscriber, request)
}

ClassMethod AddSubscriptions(subscriber As IBSP.Notice.DAT.Subscriber, request As IBSP.Notice.REST.Subscriber.Request.UpdateSubscriberRequest) As %Status [ Internal, Private ]
{
    set topics = request.topicsToAdd
    return:(topics = "") $$$OK
    return:(topics.Count() = 0) $$$OK

    for i = 1: 1: topics.Count() {

        set topic = topics.GetAt(i)
        $$$buildValidTopic(topic)

        $$$ReturnOnError(##class(IBSP.Notice.Service.SubscriptionService).GetSubscriptionBySubscriberIdAndTopic(subscriber.%Id(), $$$toUpperCase(topic), .subscription))
        if '$isobject(subscription) {
            $$$ReturnOnError(##class(IBSP.Notice.Service.SubscriptionService).Create(subscriber, topic))
        }
    }

    return $$$OK
}

ClassMethod DeleteSubscriptions(subscriber As IBSP.Notice.DAT.Subscriber, request As IBSP.Notice.REST.Subscriber.Request.UpdateSubscriberRequest) As %Status [ Internal, Private ]
{
    set topics = request.topicsToDelete
    return:(topics = "") $$$OK
    return:(topics.Count() = 0) $$$OK

    for i = 1: 1: topics.Count() {

        set topic = topics.GetAt(i)
        $$$buildValidTopic(topic)

        $$$ReturnOnError(##class(IBSP.Notice.Service.SubscriptionService).Delete(subscriber, $$$toUpperCase(topic)))
    }

    return $$$OK
}

ClassMethod GetSubscriberResponseByCip(cip As %String, Output response As IBSP.Notice.REST.Subscriber.Response.SubscriberResponse) As %Status [ Internal, Private ]
{
    set response = ##class(IBSP.Notice.REST.Subscriber.Response.SubscriberResponse).%New()

    $$$QuitOnError(##class(IBSP.Notice.Service.SubscriberService).GetByUserId($$$CIP, cip, .subscriber))

    if $isobject(subscriber) {

        set subscriberId = subscriber.%Id()

        set response.id = subscriberId
        set response.name = subscriber.Name
        set response.surname = subscriber.SurName
        set:($isobject(subscriber.Lang)) response.language = subscriber.Lang.ISO
        set response.cip = cip

        $$$QuitOnError(##class(IBSP.Notice.Service.ContactWayService).GetAddressBySubscriberIdAndType(subscriberId, $$$ApplicationId, .applicationId))
        set response.applicationId = applicationId

        $$$QuitOnError(##class(IBSP.Notice.Service.SubscriptionService).GetTopicsBySubscriberId(subscriberId, .topics))
        set response.topics = topics
    }

    return $$$OK
}

ClassMethod GetSubscriberResponseByApplicationId(applicationid As %String, Output response As IBSP.Notice.REST.Subscriber.Response.SubscriberResponse) As %Status [ Internal, Private ]
{
    set response = ##class(IBSP.Notice.REST.Subscriber.Response.SubscriberResponse).%New()

    $$$QuitOnError(##class(IBSP.Notice.Service.SubscriberService).GetByContactWay($$$ApplicationId, applicationid, .subscriber))

    if $isobject(subscriber) {

        set subscriberId = subscriber.%Id()

        set response.id = subscriberId
        set response.name = subscriber.Name
        set response.surname = subscriber.SurName
        set:($isobject(subscriber.Lang)) response.language = subscriber.Lang.ISO

        $$$QuitOnError(##class(IBSP.Notice.Service.UserIdService).GetCodeBySubscriberIdAndType(subscriberId, $$$CIP, .cip))
        set response.cip = cip

        set response.applicationId = applicationid

        $$$QuitOnError(##class(IBSP.Notice.Service.SubscriptionService).GetTopicsBySubscriberId(subscriberId, .topics))
        set response.topics = topics
    }

    return $$$OK
}

ClassMethod DeleteSubscriberApplicationId(subscriber As IBSP.Notice.DAT.Subscriber) As %Status [ Internal, Private ]
{
    return ##class(IBSP.Notice.Service.ContactWayService).Delete(subscriber, $$$ApplicationId)
}

ClassMethod DeleteSubscriberCip(subscriber As IBSP.Notice.DAT.Subscriber) As %Status [ Internal, Private ]
{
    return ##class(IBSP.Notice.Service.UserIdService).Delete(subscriber, $$$CIP)
}

ClassMethod DeleteSubscriberSubscriptions(subscriber As IBSP.Notice.DAT.Subscriber) As %Status [ Internal, Private ]
{
    return ##class(IBSP.Notice.Service.SubscriptionService).DeleteAll(subscriber)
}

ClassMethod DeleteSubscriberNotifications(subscriber As IBSP.Notice.DAT.Subscriber) As %Status [ Internal, Private ]
{
    return ##class(IBSP.Notice.Service.NotificationService).DeleteAllBySubscriber(subscriber)
}

ClassMethod DeleteSubscriberObj(subscriber As IBSP.Notice.DAT.Subscriber) As %Status [ Internal, Private ]
{
    return ##class(IBSP.Notice.DAT.Subscriber).%DeleteId(subscriber.%Id())
}

ClassMethod BuildErrorResponse(errorMessage As %String, Output executionResponse As IBSP.Notice.REST.Subscriber.Response.ExecutionResponse) As %Status [ Internal, Private ]
{
    set executionResponse.result = $$$ERRORSTATUS

    set response = ##class(IBSP.Notice.REST.Subscriber.Response.ErrorResponse).%New(errorMessage)
    set executionResponse.response = response

    return $$$OK
}

}
