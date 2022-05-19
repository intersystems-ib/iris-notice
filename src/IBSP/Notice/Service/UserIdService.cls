Class IBSP.Notice.Service.UserIdService
{

Parameter UserIdManagerIdType = "managerid";

Parameter UserIdEmployeeIdType = "employeeid";

ClassMethod GetByTypeAndCode(type As %String, code As %String, Output userId As IBSP.Notice.DAT.UserID) As %Status
{
    set sc = $$$OK
    set userId = ""

    &sql(
        SELECT ID INTO :id
            FROM IBSP_Notice_DAT.UserID
            WHERE Type = :type
            AND Code = :code
    )

    return:(SQLCODE '= 0) $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.UserIdService.GetByTypeAndCode] SQLCODE error " _ SQLCODE _ " " _ %msg)

    set:(id > 0) userId = ##class(IBSP.Notice.DAT.UserID).%OpenId(id, .sc) 

    quit sc
}

ClassMethod Create(subscriber As IBSP.Notice.DAT.Subscriber, type As %String, code As %String) As %Status
{
    return:(code = "") $$$OK

    set userID = ##class(IBSP.Notice.DAT.UserID).%New()
    set userID.Subscriber = subscriber
    set userID.Type = type
    set userID.Code = code

    return userID.%Save(0)
}

ClassMethod Delete(subscriber As IBSP.Notice.DAT.Subscriber, type As %String) As %Status
{
    return:(type = "") $$$OK

    set subscriberId = subscriber.%Id()

    &sql(
        DELETE
            FROM IBSP_Notice_DAT.UserID
            WHERE Subscriber = :subscriberId
            AND Type = :type
    )

    return:(SQLCODE '= 0) $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.UserIdService.Delete] SQLCODE error " _ SQLCODE _ " " _ %msg)

    return $$$OK
}

ClassMethod GetCodeBySubscriberIdAndType(subscriberId As %BigInt, type As %String, Output code As %String(MAXLEN="")) As %Status
{
    &sql(
        SELECT Code INTO :code
            FROM IBSP_Notice_DAT.UserId
            WHERE Subscriber = :subscriberId
            AND Type = :type
    )

    return:(SQLCODE '= 0) $$$ERROR($$$GeneralError, "[IBSP.Notice.Service.UserIdService.GetCodeBySubscriberIdAndType] SQLCODE error " _ SQLCODE _ " " _ %msg)

    return $$$OK
}

ClassMethod GetEmployeeIdBySubscriberId(subscriberId As %BigInt, Output employeeId As %String) As %Status
{
    return ..GetCodeBySubscriberIdAndType(subscriberId, ..#UserIdEmployeeIdType, .employeeId)
}

ClassMethod GetManagerIdBySubscriber(subscriber As IBSP.Notice.DAT.Subscriber, Output managerId As %String) As %Status
{
    return ..GetCodeBySubscriberIdAndType(subscriber.%Id(), ..#UserIdManagerIdType, .managerId)
}

}
