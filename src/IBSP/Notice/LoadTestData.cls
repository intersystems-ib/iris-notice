Class IBSP.Notice.LoadTestData
{

/// do ##class(IBSP.Notice.LoadTestData).Load()
ClassMethod Load() As %Status
{
    $$$QuitOnError(..LoadTopic())
    $$$QuitOnError(..LoadResourceAction())
    $$$QuitOnError(..LoadResourceActionTopics())
    $$$QuitOnError(..LoadSubscriber())
    $$$QuitOnError(..LoadContactWay())
    $$$QuitOnError(..LoadUserId())
    $$$QuitOnError(..LoadSubscription())
    write !, "Test data loaded"
}

ClassMethod LoadTopic() As %Status [ Internal, Private ]
{
    &sql(
        INSERT
          INTO IBSP_Notice_DAT.Topic (Active, BodyFormat, BodyTemplate, OutboundAdapter, ContactWay, Destination, TopicKey, ExecutionComponent)
        VALUES (1, 'JSON', '{"applicationId": "##APPLICATIONID##","name":"##NAME##","surname":"##SURNAME##"}', 'HTTP', 'applicationId', 'cip', 'Test', 'REST Test')
    )

    return:(SQLCODE '= 0) $$$ERROR($$$GeneralError, "[IBSP.Notice.LoadTestData LoadTopic] SQLCODE error " _ SQLCODE _ " " _ %msg)
    return $$$OK
}

ClassMethod LoadResourceAction() As %Status [ Internal, Private ]
{
    &sql(
        INSERT
          INTO IBSP_Notice_DAT.ResourceAction ("Action", Description, Resource)
        VALUES ('*', 'Prueba', 'cita')
    )

    return:(SQLCODE '= 0) $$$ERROR($$$GeneralError, "[IBSP.Notice.LoadTestData LoadResourceAction] SQLCODE error " _ SQLCODE _ " " _ %msg)
    return $$$OK
}

ClassMethod LoadResourceActionTopics() As %Status [ Internal, Private ]
{
    &sql(
        INSERT
          INTO IBSP_Notice_DAT.ResourceActionTopics (ResourceAction, Topic)
        VALUES (1, 1)
    )

    return:(SQLCODE '= 0) $$$ERROR($$$GeneralError, "[IBSP.Notice.LoadTestData LoadResourceActionTopics] SQLCODE error " _ SQLCODE _ " " _ %msg)
    return $$$OK
}

ClassMethod LoadSubscriber() As %Status [ Internal, Private ]
{
    &sql(
        INSERT
          INTO IBSP_Notice_DAT.Subscriber (Active, Lang, Name, SurName)
        VALUES (1, 2, 'Benito', 'Camela')
    )

    return:(SQLCODE '= 0) $$$ERROR($$$GeneralError, "[IBSP.Notice.LoadTestData LoadSubscriber] SQLCODE error " _ SQLCODE _ " " _ %msg)
    return $$$OK
}

ClassMethod LoadContactWay() As %Status [ Internal, Private ]
{
    &sql(
        INSERT
          INTO IBSP_Notice_DAT.ContactWay(Address, Subscriber, "Type")
        VALUES ('1234', 1, 'applicationId')
    )

    return:(SQLCODE '= 0) $$$ERROR($$$GeneralError, "[IBSP.Notice.LoadTestData LoadContactWay] SQLCODE error " _ SQLCODE _ " " _ %msg)
    return $$$OK
}

ClassMethod LoadUserId() As %Status [ Internal, Private ]
{
    &sql(
        INSERT
          INTO IBSP_Notice_DAT.UserID (Code, Subscriber, "Type")
        VALUES ('CACA0691212069', 1, 'cip')
    )

    return:(SQLCODE '= 0) $$$ERROR($$$GeneralError, "[IBSP.Notice.LoadTestData LoadUserId] SQLCODE error " _ SQLCODE _ " " _ %msg)
    return $$$OK
}

ClassMethod LoadSubscription() As %Status [ Internal, Private ]
{
    &sql(
        INSERT
          INTO IBSP_Notice_DAT.Subscription (Subscriber, Topic)
        VALUES (1, 'Test')
    )

    return:(SQLCODE '= 0) $$$ERROR($$$GeneralError, "[IBSP.Notice.LoadTestData LoadSubscription] SQLCODE error " _ SQLCODE _ " " _ %msg)
    return $$$OK
}

}
