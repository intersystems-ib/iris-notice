/// Notification Commands API
/// Dispatch class defined by RESTSpec in IBSP.Notice.API.NOT.Command.v1.spec
Class IBSP.Notice.API.NOT.Command.v1.disp Extends %CSP.REST [ GeneratedBy = IBSP.Notice.API.NOT.Command.v1.spec.cls, ProcedureBlock ]
{

/// The class containing the RESTSpec which generated this class
Parameter SpecificationClass = "IBSP.Notice.API.NOT.Command.v1.spec";

/// Ignore any writes done directly by the REST method.
Parameter IgnoreWrites = 1;

/// By default convert the input stream to Unicode
Parameter CONVERTINPUTSTREAM = 1;

/// The default response charset is utf-8
Parameter CHARSET = "utf-8";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
  <!-- Procesa mensajes para enviar posteriormente información según la petición recibida en texto de mensaje -->
  <Route Url="/:BotName" Method="post" Call="getNotificationByDataEntered" />
</Routes>
}

/// Procesa mensajes para enviar posteriormente información según la petición recibida en texto de mensaje
ClassMethod getNotificationByDataEntered(pBotName As %String) As %Status
{
    Try {
        Do ##class(%REST.Impl).%SetContentType("application/json")
        If '##class(%REST.Impl).%CheckAccepts("application/json") Do ##class(%REST.Impl).%ReportRESTError(..#HTTP406NOTACCEPTABLE,$$$ERROR($$$RESTBadAccepts)) Quit
        If $isobject(%request.Content) Set pupdateMsg=%request.Content
        Set response=##class(IBSP.API.NOT.Command.v1.impl).getNotificationByDataEntered(pBotName,.pupdateMsg)
        Do ##class(IBSP.API.NOT.Command.v1.impl).%WriteResponse(response)
    } Catch (ex) {
        Do ##class(%REST.Impl).%ReportRESTError(..#HTTP500INTERNALSERVERERROR,ex.AsStatus(),$parameter("IBSP.Notice.API.NOT.Command.v1.impl","ExposeServerExceptions"))
    }
    Quit $$$OK
}

}
