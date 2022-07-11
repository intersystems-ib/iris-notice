Class IBSP.Notice.BO.TelegramDeliver Extends (EnsLib.REST.Operation, Ens.BusinessOperation, IBSP.Notice.BO.NoticeDeliver)
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Parameter AuthHeader = "x-bot-token";

Property DefaultFormat As %String;

Parameter SETTINGS = "DefaultFormat:Basic";

Method SendMessage(pRequest As IBSP.Notice.Request.TelegramNoticeRequest, Output pResponse As IBSP.Notice.Messages.NoticeRes) As %Status
{
	#dim tSC as %Status = $$$OK
	#dim errObj as %Exception.AbstractException
	set tResponse = ""
	set result = "OK"

	try {

		set textNotify = pRequest.Text
		set botToken = pRequest.Token
		set chatId = pRequest.ContactWayAddress
		set format = ""
		set:($isobject(pRequest.Topic)) format = pRequest.Topic.Format
        set replyId = pRequest.ReplyId
		Set silent = pRequest.Silent
		
		$$$ThrowOnError(..SendRESTRequest(textNotify, format, botToken, chatId, replyId, silent, .tResponse))
		$$$ThrowOnError(..SaveNotification(pRequest, tResponse))
	} catch errObj {

		set tSC = errObj.AsStatus()

        set result = "ERROR"

        set tResponse = {}
        set tResponse.ok = $$$NO
        set tResponse.errorMessage = errObj.DisplayString()

		$$$ThrowOnError(..SaveNotification(pRequest, tResponse))
	}
	
	set pResponse = ##class(IBSP.Notice.Messages.NoticeRes).%New()
	set pResponse.result = result
	
	quit tSC
}

Method SendRESTRequest(pText As %String, pFormat As %String, pBotToken As %String, pChatID As %String, pReplyId As %String = "", pSilent As %Boolean = 0, Output pResponse As %RegisteredObject) As %Status [ Private ]
{
	set tSC = $$$OK
	
	try  {

		$$$ThrowOnError(..SetRequest(pText, pFormat, pChatID, pReplyId, pSilent, .request))
		$$$ThrowOnError(..SetXAuthToken(.request, pBotToken))
		$$$ThrowOnError(..Adapter.SendFormData(.tResponse, "POST", request))
        do tResponse.Data.Rewind()
		set pResponse = {}.%FromJSON(tResponse.Data)
	} catch errObj {

		set tSC = errObj.AsStatus()
		$$$LOGERROR(tResponse.Data.Read())
        do tResponse.Data.Rewind()
		set pResponse = {}.%FromJSON(tResponse.Data)
	}

	quit tSC
}

Method SetRequest(pText As %String, pFormat As %String, pChatID As %String, pReplyId As %String = "", pSilent As %Boolean = 0, ByRef pHTTPRequest As %Net.HttpRequest) As %Status [ Private ]
{
	set tSC = $$$OK
	
	try {

		set json = {}
		set json."chat_id" = pChatID
		set json.text = pText
		set:(pReplyId '= "") json."reply_to_message_id" = pReplyId
		set json."disable_notification" = pSilent
		set json."parse_mode" = $case(pFormat, "": ..DefaultFormat, : pFormat)
		set jsonString = json.%ToJSON()
		
		set pHTTPRequest = ##class(%Net.HttpRequest).%New()
		set pHTTPRequest.ContentType = "application/json"
		set pHTTPRequest.ContentCharset = "UTF-8"
		$$$ThrowOnError(pHTTPRequest.EntityBody.Write(jsonString))
	} catch errObj {

		set tSC = errObj.AsStatus()
	}
	
	quit tSC
}

Method SetXAuthToken(ByRef pHTTPRequest As %Net.HttpRequest, pBotToken As %String) As %Status [ Private ]
{
	quit pHTTPRequest.SetHeader(..#AuthHeader, pBotToken)
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="IBSP.Notice.Request.TelegramNoticeRequest"> 
		<Method>SendMessage</Method>
	</MapItem>
</MapItems>
}

}
