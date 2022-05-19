Class IBSP.Notice.BS.RetrieveData.SQLBusinessService Extends IBSP.Notice.BS.AbstractBusinessService
{

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

Property Adapter As EnsLib.SQL.InboundAdapter;

/// Identifying element of the notification. Is the name of the field in the BD that identifies each record. It is used to avoid notifying several times the same element to the same subscriptor.
Property ElementID As %String;

Parameter SETTINGS = "Topic:Notification,SendIfPublished:Notification,ElementID:Notification";

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As IBSP.Notice.Messages.NoticeReq) As %Status
{
    set elementId = ""
    set:(..ElementID '= "") elementId = pInput.Get(..ElementID)

    return ..CreateRequestAndSendToPublisher(pInput, elementId)
}

Method GetValuesFromData(pInput As EnsLib.SQL.Snapshot, ByRef values As %DynamicObject, parentObjName As %String = "") As %Status [ Internal, Private ]
{
    for i = 1: 1: pInput.GetColumnCount() {
        do values.%Set(pInput.GetColumnName(i), pInput.GetData(i))
    }

    return $$$OK
}

}
