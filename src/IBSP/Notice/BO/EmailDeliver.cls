Class IBSP.Notice.BO.EmailDeliver Extends (Ens.BusinessOperation, IBSP.Notice.BO.NoticeDeliver)
{

Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Property Adapter As EnsLib.EMail.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method SendMessage(pRequest As IBSP.Notice.Request.EmailNoticeRequest, Output pResponse As IBSP.Notice.Messages.NoticeRes) As %Status
{
    set sc = $$$OK

	set response = {}
	set result = "OK"

	try {
	
        set email = pRequest.ContactWayAddress

        set subject = pRequest.Subject
        set text = pRequest.Text

        set mailMessage = ..CreateMailMessage(email, subject, text)
        $$$ThrowOnError(..Adapter.SendMail(mailMessage, .failedRecipients))

        set response.ok = $$$YES
        $$$ThrowOnError(..SaveNotification(pRequest, response))
	} catch ex {

		set sc = ex.AsStatus()

        set result = "ERROR"

        set response.ok = $$$NO
        set response.errorMessage = ex.DisplayString()
		$$$ThrowOnError(..SaveNotification(pRequest, response))
	}

	set pResponse = ##class(IBSP.Notice.Messages.NoticeRes).%New()
	set pResponse.result = result

	quit sc
}

ClassMethod CreateMailMessage(to As %String, subject As %String, text As %String) As %Net.MailMessage
{
    set mailMessage = ##class(%Net.MailMessage).%New()
    
    set mailMessage.IsBinary = $$$NO
    set mailMessage.IsHTML = $$$YES
    set mailMessage.IsMultiPart = $$$YES
    set mailMessage.Charset = "UTF-8"

	do mailMessage.To.Insert(to)

    set mailMessage.Subject = subject

    set partBody = ##class(%Net.MailMessagePart).%New()
    set partBody.IsBinary = $$$NO
    set partBody.IsHTML = $$$YES
    set partBody.Charset = "UTF-8"

    do partBody.TextData.WriteLine("<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>")
    do partBody.TextData.WriteLine("<html xmlns='http://www.w3.org/1999/xhtml'>")
    do partBody.TextData.WriteLine("<head>")
    do partBody.TextData.WriteLine("<meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />")
    do partBody.TextData.WriteLine("<meta name='viewport' content='width=device-width, initial-scale=1.0'/>")
    do partBody.TextData.WriteLine("</head>")
    do partBody.TextData.WriteLine("<style>")
    do partBody.TextData.WriteLine("P, A, LI {")
    do partBody.TextData.WriteLine("font-family: verdana;")
    do partBody.TextData.WriteLine("font-size: 12px;")
    do partBody.TextData.WriteLine("}")
    do partBody.TextData.WriteLine("</style>")
    do partBody.TextData.WriteLine("<body>")
    do partBody.TextData.WriteLine("<p>")

    do partBody.TextData.Write(text)

    do partBody.TextData.WriteLine("</p>")
    do partBody.TextData.WriteLine("<br><br><hr><p><b>Consorci Corporació Sanitària Parc Taulí</b>")

    set base64Image = "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"
    do partBody.TextData.WriteLine("<br><br>")
    do partBody.TextData.WriteLine("<img src='data:image/png;base64," _ base64Image _ "' alt='Logo' />")
    
    do partBody.TextData.WriteLine("</p><hr><p style='font-style: italic;'>Aquest mail es un enviament automàtic. Si us plau, no respongui a aquest mail. </p>")

    do partBody.TextData.WriteLine("</body>")
    do partBody.TextData.WriteLine("</html>")
    
    do mailMessage.Parts.SetAt(partBody, 1)
    
    quit mailMessage
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
