Class IBSP.Notice.REST.Notify.Service.NotifyService Extends %REST.Impl
{

Parameter ExposeServerExceptions = 0;

Parameter APIBS = "IBSP.Notice.BS.REST.NotifyBusinessService";

ClassMethod Notify(request As IBSP.Notice.REST.Notify.Request.NotifyRequest) As %DynamicObject
{
    set resp = {}
    
    set pushRequest = ##class(IBSP.Notice.Request.PushNoticeRequest).%New()
    set pushRequest.Action = request.resource _ "/" _ request.action
    set pushRequest.UserIdType = request.userIdType
    set pushRequest.UserIdCode = request.userIdCode
    set pushRequest.TextParams = request.data
    set pushRequest.SendIfPublished = "Y"

    do ##class(Ens.Director).CreateBusinessService(..#APIBS, .service)

    try {
        $$$ThrowOnError(service.OnProcessInput(pushRequest, .response))
        set:(response '= "") resp.message = response.StringValue
    } catch ex {
        set resp.message = ex.DisplayString()
    }

    return resp
}

}
