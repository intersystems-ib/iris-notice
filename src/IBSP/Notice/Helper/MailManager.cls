Class IBSP.Notice.Helper.MailManager Extends %RegisteredObject
{

/// Creates and object %Net.SMTP as Server to send mails
/// Here can be found Server, User & Password for Mail Utilities
ClassMethod GetMailServer() As %Net.SMTP
{
  Set server=##class(%Net.SMTP).%New()

  set mailServer = ##class(IBSP.Notice.Utils).GetParameter("MAIL_SERVER")
  // PARAM MAIL_SERVER Format: Server|Port|User|Password
  Set server.smtpserver=$PIECE(mailServer,"|",1)
  Set server.port=$PIECE(mailServer,"|",2)
  
  //Create object to carry authentication
  Set auth=##class(%Net.Authenticator).%New()
  
  Set auth.UserName=$PIECE(mailServer,"|",3)
  Set auth.Password=$PIECE(mailServer,"|",4)
  
  Set server.authenticator=auth
  Set server.AuthFrom=auth.UserName
  Quit server
}

/// Returns a Mail Message Object complete with Subject, Body and Attachments
/// PARAMS: 	pTo: TO: 
/// 			pCc: CC:
/// 			pSubject: Sunject of the mail
/// 			pBody: Body of the nail
ClassMethod CreateTextMessage(pTo As %String, pCc As %String, pSubject As %String, pBody As %String) As %Net.MailMessage
{
    do ##class(IBSP.Notice.Utils).Log(3,"CreateMessage To: "_pTo_" - Subject:"_pSubject)
    set msg = ##class(%Net.MailMessage).%New()
    
	// From of the message is loaded forma a paramter
	set msg.From = ##class(IBSP.Notice.Utils).GetParameter("MAIL_NOT_FROM")
	// To: from parameter
	Do msg.To.Insert(pTo)

	// Cc: from parameter
	set lCc = ##class(IBSP.Notice.Utils).GetParameter("MAIL_NOT_CC")
	FOR i=1:1:$LENGTH(lCc,";") {
		Set address=$P(lCc,";",i)
		If ($LENGTH(address)>5) {
			Do msg.Cc.Insert(address)
			do ##class(IBSP.Notice.Utils).Log(3,"Mail: Cc: "_address)
		}
	} 
	if (pCc '= "") { Do msg.Cc.Insert(pCc)}
 
    // Load BCC: Receivers from parameter
	set lBcc = ##class(IBSP.Notice.Utils).GetParameter("MAIL_NOT_BCC")
    FOR i=1:1:$LENGTH(lBcc,";") {
		Set address=$P(lBcc,";",i)
		If ($LENGTH(address) > 5) {
			Do msg.Bcc.Insert(address)
			do ##class(IBSP.Notice.Utils).Log(3,"Mail: Bcc: "_address)
		}
	} 
	
    // Mail properties
    Set msg.IsBinary=0
    Set msg.IsHTML=1
    set msg.IsMultiPart=1

	// Subject from parameter 
    set msg.Subject = pSubject
    set partBody = ##class(%Net.MailMessagePart).%New()
    set partBody.IsBinary = 0
    set partBody.IsHTML = 1
    do partBody.TextData.Write( ##class(IBSP.Notice.Helper.MailManager).ComposeMail(pBody))
    
    do msg.Parts.SetAt(partBody,1)
    
    // attachments
    // This parameter has the list of Attachment Types that have to be included into the mail
    Quit msg
}

/// Generates the formatted body of the mail
///  RETURNS: 	qBody as %String
/// PARAMS: 	pBodyin Body of the message
/// 			text# Can be loaded until 10 fields into variables (as %# into the message)
ClassMethod ComposeMail(pBodyin As %String, text1 As %String = "", text2 As %String = "", text3 As %String = "", text4 As %String = "", text5 As %String = "", text6 As %String = "", text7 As %String = "", text8 As %String = "", text9 As %String = "", textA As %String = "") As %String
{
	do ##class(IBSP.Notice.Utils).Log(3,"ComposeMail call: Body: "_pBodyin)
	set llegal = ##class(IBSP.Notice.Utils).GetParameter("MAIL_NOT_LEGAL_WARNING")
	set llogo = ##class(IBSP.Notice.Utils).GetParameter("CORPORATE_LOGO")

	set qBody = "<html><head><title>IBERIA NOTIFICATIONS</title><meta http-equiv=""content-type"" content=""text/html;charset=iso-8859-1"" /><meta http-equiv=""X-UA-Compatible"" content=""IE=edge"" /><meta name=""viewport"" content=""width=device-width, initial-scale=1.0 "" /><meta name=""format-detection"" content=""telephone=no"" />"_
                "<style type=""text/css"">body { margin:0 !important; padding:0 !important; font-family: sans-serif !important; font-size: 12px; text-align:left; -webkit-text-size-adjust:100% !important; -ms-text-size-adjust:100% !important; -webkit-font-smoothing:antialiased !important; }img { border:0 !important; outline:none !important; max-width:100%; }table { border-collapse:collapse; mso-table-lspace:0px; mso-table-rspace:0px; border-collapse: separate; border-spacing: 0; }td { border-collapse:collapse; mso-line-height-rule:exactly; border-collapse: separate; border-spacing: 0; }a { border-collapse:collapse; mso-line-height-rule:exactly; border-collapse: separate; border-spacing: 0; color: #094E93; }span { border-collapse:collapse; mso-line-height-rule:exactly; border-collapse: separate; border-spacing: 0; }@media only screen and (max-width:600px) {.em_main_table { width: 100% !important; background-size: 115% 100%; }.em_main_table .td-background { background-size: 115% 100%; }td.logo { height: 135px; }td.logo_solo { height: 60px; }td.logo img { max-width: 95%; height: 45px; }.column-6, table.td-column-6 { width: 50% !important; }td.logo-footer img { width: 100%; height: auto; max-width: 250px; }#contenido-campana td, h1 { padding: 0 20px; }}@media only screen and (max-width:450px) {.em_main_table { width: 100% !important; }.em_main_table .td-background { background-size: 115% 100%; }td.logo { max-width: 100%; height: 105px; }td.logo_solo { max-width: 100%; height: 50px; }td.logo img { max-width: 90%; height: auto; max-height: 40px; }.column-6, .column-6 td { width: 100% !important; padding: 0px !important; text-align: center !important; }.column-6 { padding: 0 20px !important; }td.td-column-6, table.td-column-6 { width: 50% !important; }td.logo-footer { height: auto; padding-bottom: 20px !important; }img.img-rrss { max-width: 50px; width: 100%; margin: 0px !important; }td.responsive-hidden {display: none;}}@media only screen and (max-width:300px) {td.logo_solo { max-width: 100%; height: 40px; }td.logo img { max-width: 90%; height: auto; max-height: 30px; }}"_
                "</style></head>"_
                "<body style=""margin:0 !important; padding:0 !important; font-family: sans-serif; -webkit-text-size-adjust:100% !important; -ms-text-size-adjust:100% !important; -webkit-font-smoothing:antialiased !important;"">"_
                "<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"" align=""center"">"_
                		"<tbody><!-- ENCABEZADO --><tr><td align=""center"" valign=""top""> "_
                		/*"<!-- CABECERA LOGO --><table align=""center"" class=""em_main_table"" width=""600"" border=""0"" cellspacing=""0"" cellpadding=""0"" style=""table-layout:fixed;margin-left:auto;margin-right:auto;"">"_
                		" <tbody> <tr><td class=""td-background"" width=""100%"" valign=""top"" align=""center"" bgcolor=""#2f2a95""> "_
                		" <table><tr><td height=""15"" width=""20"">&nbsp;</td></tr><tr><td width=""20"">&nbsp;</td>"_
                		            "<td width=""280"" valign=""middle""><table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"" align=""left""> <tbody><tr>	<td class=""logo logo_solo"" height=""65"" align=""left"" valign=""top"">"_
                		            		"<img border=""0"" src=""https://intersystems.cysnet.net/imagesNewsletter/localsummit2018-cabecera.png"" alt="""" title=""InterSystems"" height=""45"" /></td></tr></tbody>	</table></td>"_
                		            		"<td width=""280"" valign=""middle"" align=""right""><table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"" align=""right""> <tbody><tr><td class=""logo logo_solo"" height=""65"" align=""right"" valign=""top""></td></tr></tbody></table></td><td width=""20"">&nbsp;</td></tr></table></td></tr></tbody></table>"_*/
                		"<!-- CONTENIDO --> <tr><td align=""center"" valign=""top""> <table id=""contenido-campana"" align=""center"" class=""em_main_table"" width=""600"" border=""0"" cellspacing=""0"" cellpadding=""0"" style=""table-layout:fixed;margin-left:auto;margin-right:auto;"">"_
                			"<tbody> <tr><td style=""margin-left:auto;margin-right:auto;color:#2068B0;text-align:left;""><style type=""text/css"">p {margin-bottom: 1em;}</style><br/><br/>"_
                			pBodyin_
                			"</td></tr></tbody> </table></td></tr>"_
                		"<!-- FOOTER --> <tr><td height=""20"">&nbsp;</td></tr><tr><td align=""center"" valign=""top""> <table align=""center"" class=""em_main_table"" width=""600"" border=""0"" cellspacing=""0"" cellpadding=""0"" style=""table-layout:fixed;margin-left:auto;margin-right:auto;"" bgcolor=""#2B2B94""><tbody>"_
                		"<!-- LOGO DEL FOOTER --><tr style=""text-align: left;""><td width=""20"">&nbsp;</td><td valign=""middle"" style=""vertical-align:middle; font-size: 0""> <!--[if mso]><table border=""0"" cellspacing=""0"" cellpadding=""0"" style=""table-layout:fixed;"" ><tr><td width=""280"" valign=""middle"" style=""vertical-align:middle; font-size: 0""><![endif]--> <table class=""column-6"" width=""280"" height=""100"" border=""0"" cellspacing=""0"" cellpadding=""0"" align=""left""> <tbody><tr>	"_
                			//"<td class=""td-column-6"" valign=""middle"" style=""vertical-align:middle; font-size: 0"" width=""50""><a style=""padding-top:60px;border:0px;"" href=""https://twitter.com/intersystems_ib"" target=""_blanc""><img class=""img-rrss"" src=""https://intersystems.cysnet.net/imagesNewsletter/localsummit2018-twitter.png"" alt=""Twitter"" width=""50"" height=""50"" border=""0"" /></a></td>"_
                			//"<td class=""responsive-hidden"" width=""40"">&nbsp;</td><td class=""td-column-6"" style=""vertical-align:middle; font-size: 0"" valign=""middle""><a href=""https://www.youtube.com/user/InterSystemsIberia/feed"" target=""_blanc"" style=""border:0px;padding-top:60px;""><img class=""img-rrss"" src=""https://intersystems.cysnet.net/imagesNewsletter/localsummit2018-youtube.png"" alt=""Youtube"" width=""50"" height=""50"" border=""0"" /></a></td>"_
                			"<td class=""responsive-hidden"" width=""20"">&nbsp;</td></tr></tbody>	</table><!--[if mso]></td><td width=""280"" valign=""middle"" align=""right""><![endif]--> "_
                			"<table class=""column-6"" width=""262"" border=""0"" cellspacing=""0"" cellpadding=""0"" align=""right""> <tbody><tr><td class=""logo-footer"" height=""81"" style=""text-align:right;"" align=""right"" valign=""middle"">"_
                			"<img width=""190"" class=""foto"" src="""_llogo_
                			""" alt=""InterSystems Logo"" border=""0"" height=""55"" /></td></tr></tbody></table><!--[if mso]></td></tr></table><![endif]--></td><td width=""20"">&nbsp;</td></tr></tbody> </table></td></tr>"_
                			"<!-- TEXTO PARA EL PIE DE LA PÁGINA: AVISO LEGAL --> <tr><td align=""center"" valign=""top""> <table align=""center"" class=""em_main_table"" width=""600"" border=""0"" cellspacing=""0"" cellpadding=""0"" style=""table-layout:fixed;margin-left:auto;margin-right:auto;""><tbody> <tr><td height=""20"">&nbsp;</td> </tr> <tr style=""text-align: left;""><td width=""100%"" valign=""middle"" style=""color:#b4b4b4;font-size:10px;padding-left:20px;padding-right:20px;""> "_
                			llegal_
                			"</td></tr><tr><td height=""20"">&nbsp;</td> </tr> </tbody> </table></td></tr>"_
                			"<tr><td align=""center"" valign=""top""></td></tr></tbody></table></body></html>"
	
	
	do ##class(IBSP.Notice.Utils).Log(3,"ComposeMail: Return oBody:"_$EXTRACT(qBody, 0, 20)_" ...")
	
	quit qBody
}

}
