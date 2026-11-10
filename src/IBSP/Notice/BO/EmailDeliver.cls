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

    set legalWarning = ##class(IBSP.Notice.Utils).GetParameter("MAIL_NOT_LEGAL_WARNING")
	set companyLogo = ##class(IBSP.Notice.Utils).GetParameter("CORPORATE_LOGO")

    set partBody = ##class(%Net.MailMessagePart).%New()
    set partBody.IsBinary = $$$NO
    set partBody.IsHTML = $$$YES
    set partBody.Charset = "UTF-8"

    do partBody.TextData.WriteLine("<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>")
    do partBody.TextData.WriteLine("<html xmlns='http://www.w3.org/1999/xhtml'>")
    do partBody.TextData.WriteLine("<head>")
    do partBody.TextData.WriteLine("<meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />")
    do partBody.TextData.WriteLine("<meta name='viewport' content='width=device-width, initial-scale=1.0'/>")
    do partBody.TextData.WriteLine("<style>")
    do partBody.TextData.WriteLine("P, A, LI {")
    do partBody.TextData.WriteLine("font-family: verdana;")
    do partBody.TextData.WriteLine("font-size: 12px;")
    do partBody.TextData.WriteLine("}")
    do partBody.TextData.WriteLine("</style>")
    do partBody.TextData.WriteLine("</head>")
    do partBody.TextData.WriteLine("<body>")
    do partBody.TextData.WriteLine("<p>")
    do partBody.TextData.Write(text)
    do partBody.TextData.WriteLine("</p>")

    do:(companyLogo '= "") partBody.TextData.WriteLine("<p><img class='foto' src='" _ companyLogo _ "' alt='Logo' border='0' width='190' height='55' /></p>")
    
    do partBody.TextData.WriteLine("<hr><p style='font-style: italic;'>This email is an automated message. Please do not reply to this email.</p>")
    do:(legalWarning '= "") partBody.TextData.WriteLine("<table cellpadding='0' cellspacing='0' border='0'><tr><td style='color:#b4b4b4;font-family:Verdana;font-size:10px;'>" _ legalWarning _ "</td></tr></table>")

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
