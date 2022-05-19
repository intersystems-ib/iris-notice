Include notice

Class IBSP.Notice.BS.AbstractBusinessService Extends Ens.BusinessService [ Abstract, NoExtent ]
{

/// Must be overwritten in subclass
Parameter ADAPTER;

/// Must be overwritten in subclass
Parameter SETTINGS;

Parameter PUBLISHERTARGET = "IBSP.Notice.BP.Publisher";

/// TopicKey of the notification. Must exist in the table IBSP_Notice_DAT.Topic. It can be a comma-separated list if more than one Topic must be published
Property Topic As %String(MAXLEN = 1024);

/// Indicates if the notification must be notified again to subscriptors who already received it in the past (value "Y") or if those subscriptors don't have to receive it again (value "N")
Property SendIfPublished As %String(VALUELIST = ",Y,N");

Method CreateRequestAndSendToPublisher(data As %RegisteredObject, elementId As %String = "") As %Status
{
    set values = {}
    $$$QuitOnError(..GetValuesFromData(data, .values))
    return ..SendToPublisher(values, elementId)
}

Method GetValuesFromData(data As %RegisteredObject, ByRef values As %DynamicObject) As %Status [ Internal, Private ]
{
    return $$$ERROR($$$NotImplemented)
}

Method SendToPublisher(values As %DynamicObject, elementId As %String = "") As %Status [ Internal, Private ]
{
    for i = 1: 1: $length(..Topic, ",") {

        set topicKey = $piece(..Topic, ",", i)
        set topic = ##class(IBSP.Notice.DAT.Topic).UITopicKeyOpen(topicKey)
        $$$ReturnOnError(##class(IBSP.Notice.Utils).GetTopicUserId(topic, values, .userIdType, .userIdCode))

        set request = ##class(IBSP.Notice.Request.PushNoticeRequest).%New()
        set request.SendIfPublished = ..SendIfPublished
        set request.Element = elementId
        set request.Topic = topic
        set request.TextParams = values.%ToJSON()
        set request.UserIdType = userIdType
        set request.UserIdCode = userIdCode

        $$$ReturnOnError(..SendRequestAsync(..#PUBLISHERTARGET, request))
    }

    return $$$OK
}

}
