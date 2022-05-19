Class IBSP.Notice.BO.EmailDeliver Extends (Ens.BusinessOperation, IBSP.Notice.BO.NoticeDeliver)
{

Parameter INVOCATION = "Queue";

Property DefaultFormat As %String;

Parameter SETTINGS = "DefaultFormat:Basic";

Method SendMessage(pRequest As IBSP.Notice.Request.EmailNoticeRequest, Output pResponse As IBSP.Notice.Messages.NoticeRes) As %Status
{
    #dim tSC as %Status = $$$OK
	#dim errObj as %Exception.AbstractException
	set tResponse = {}
	set result = "OK"

	try {
	
        set email = pRequest.ContactWayAddress
        do ##class(IBSP.Notice.Utils).Log(3, "Email to: " _ email)

        //Search Manager to CC:
        set managerEmail = ""
        if pRequest.ManagerNotification {
            $$$ThrowOnError(##class(IBSP.Notice.Service.SubscriberService).GetManagerEmail(pRequest.Subscriber, .managerEmail))
        }

        set subject = pRequest.Subject
        set:(subject = "") subject = ##class(IBSP.Notice.Utils).GetParameter("MAIL_NOT_SUBJ")
        set body = pRequest.Text

        set msg = ##class(IBSP.Notice.Helper.MailManager).CreateTextMessage(email, managerEmail, subject, body)
        set server = ##class(IBSP.Notice.Helper.MailManager).GetMailServer()
        $$$ThrowOnError(server.Send(msg))

        // Save the notification in the Notification table
        set tResponse.ok = $$$YES
        $$$ThrowOnError(..SaveNotification(pRequest, tResponse))
	} catch errObj {

		set tSC = errObj.AsStatus()

        set result = "ERROR"

        set tResponse.ok = $$$NO
        set tResponse.errorMessage = errObj.DisplayString()
		$$$ThrowOnError(..SaveNotification(pRequest, tResponse))
	}

	set pResponse = ##class(IBSP.Notice.Messages.NoticeRes).%New()
	set pResponse.result = result

	quit tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="IBSP.Notice.Request.EmailNoticeRequest"> 
		<Method>SendMessage</Method>
	</MapItem>
</MapItems>
}

}
