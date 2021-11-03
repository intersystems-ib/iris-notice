Class IBSP.Notice.REST.Service.SubscriberService Extends %REST.Impl
{

Parameter ExposeServerExceptions = 0;

ClassMethod createSubscriber(request As %Stream.Object) As %DynamicObject
{
    #define ERRORSTATUS 0

    set response = ##class(IBSP.Notice.REST.Response.ExecutionResponse).%New()

    try {

        set createSubscriberRequest = ##class(IBSP.Notice.REST.Request.CreateSubscriberRequest).%New()
        $$$ThrowOnError(createSubscriberRequest.%JSONImport(request))

        set subscriber = ##class(IBSP.Notice.DAT.Subscriber).%New()
        set subscriber.Name = createSubscriberRequest.name
        set subscriber.SurName = createSubscriberRequest.surname

        set language = ..getLanguage(createSubscriberRequest.language)
        set:($isobject(language)) subscriber.Lang = language

        $$$ThrowOnError(subscriber.%Save(0))

        $$$ThrowOnError(..createUserID(subscriber, "applicationid", createSubscriberRequest.applicationId))
        $$$ThrowOnError(..createUserID(subscriber, "cip", createSubscriberRequest.cip))

        set response.result = $$$OK
        set response.id = subscriber.%Id()
    } catch ex {

        set response.result = $$$ERRORSTATUS
        set response.errorMessage = ex.DisplayString()
    }

    do response.%JSONExportToString(.responseString)

    quit {}.%FromJSON(responseString)
}

ClassMethod getLanguage(requestLanguage As %String) As IBSP.Notice.DAT.Lang [ Internal, Private ]
{
    try {

        set:(requestLanguage '= "") language = ##class(IBSP.Notice.DAT.Lang).UIISOOpen(requestLanguage)
        set:('$isobject(language)) language = ##class(IBSP.Notice.DAT.Lang).GetDefault()
    } catch ex {
        set language = ""
    }

    quit language
}

ClassMethod createUserID(subscriber As IBSP.Notice.DAT.Subscriber, type As %String, code As %String) As %Status [ Internal, Private ]
{
    set ret = $$$OK

    try {

        if code '= "" {

            set userID = ##class(IBSP.Notice.DAT.UserID).%New()
            set userID.Subscriber = subscriber
            set userID.Type = type
            set userID.Code = code

            $$$ThrowOnError(userID.%Save(0))
        }
    } catch ex {
        set ret = ex.AsStatus()
    }

    quit ret
}

}
