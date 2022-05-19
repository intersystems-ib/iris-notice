/// Notification Commands API<br/>
/// Business logic class defined by OpenAPI in IBSP.Notice.API.NOT.Command.v1.spec<br/>
/// Updated May 10, 2022 14:33:15
Class IBSP.Notice.API.NOT.Command.v1.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

Parameter APIBS = "IBSP.Notice.API.NOT.Command.BS";

/// Guarda la información sobre la acción<br/>
/// The method arguments hold values for:<br/>
///     BotName<br/>
///     updateMsg, Mensaje Update con información de Mensaje de texto<br/>
ClassMethod getNotificationByDataEntered(BotName As %String, updateMsg As %Stream.Object) As %DynamicObject
{
	#dim tResponse as IBSP.Notice.Messages.NoticeRes
	set jsonOut = ""
	set updateMsgJSON = {}.%FromJSON(updateMsg.Read())

	try {
		set tRequest = ..BuildRequest(BotName, updateMsgJSON)
				
		$$$ThrowOnError(##class(Ens.Director).CreateBusinessService(..#APIBS,.tService))
		Set tResponse = ""
		do tService.OnProcessInput(tRequest,.tResponse)
					
	} catch errObj {
		#dim errObj as %Exception.AbstractException
		Set ^zcpr($increment(^zcpr))="Error BS IMPL: "_errObj.DisplayString()
	} 
	
	set jsonOut = {"Status":"Received"}
    Quit jsonOut
}

ClassMethod BuildRequest(botName As %String, updateMsgJSON As %DynamicObject) As IBSP.Notice.Request.PullNoticeRequest [ Private ]
{
	set command = updateMsgJSON.message.text
	set chatId = updateMsgJSON.message.chat.id
	set userId = updateMsgJSON.message.from.id
	set replyMsg = updateMsgJSON.message."message_id"

	set request = ##class(IBSP.Notice.Request.PullNoticeRequest).%New()

	set request.Command = command
	set request.ReplyId = replyMsg
	set request.ContactWayAddress = chatId
	set request.UserIdCode = userId
	$$$ThrowOnError(##class(IBSP.Notice.Utils).GetBotToken(botName, .token))
	set request.Token = token

	quit request
}

}
