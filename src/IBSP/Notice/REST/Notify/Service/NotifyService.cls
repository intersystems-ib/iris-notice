Class IBSP.Notice.REST.Notify.Service.NotifyService Extends %REST.Impl
{

Parameter ExposeServerExceptions = 0;

Parameter APIBS = "IBSP.Notice.BS.REST.NotifyBusinessService";

ClassMethod Notify(request As IBSP.Notice.REST.Notify.Request.NotifyRequest) As %DynamicObject
{
    set resp = {}
    
    set pullRequest = ##class(IBSP.Notice.Request.PullNoticeRequest).%New()
    set pullRequest.Command = request.resource _ "/" _ request.action
    set pullRequest.UserIdType = request.userIdType
    set pullRequest.UserIdCode = request.userIdCode
    set pullRequest.TextParams = request.data

    do ##class(Ens.Director).CreateBusinessService(..#APIBS, .service)

    try {
        $$$ThrowOnError(service.OnProcessInput(pullRequest, .response))
        set:(response '= "") resp.message = response.StringValue
    } catch ex {
        set resp.message = ex.DisplayString()
    }

    return resp
}

}
