Class IBSP.Notice.Service.TelegramCommandService
{

Parameter TopicErrorComand = "Errors.Command";

Parameter TopicErrorUnauthorized = "Errors.Unauthorized";

/// Finds a command by its action string text
ClassMethod FindCommandByInputString(inputString As %String, Output command As IBSP.Notice.DAT.TelegramCommand) As %Status
{
	set actionString = $piece(inputString, " ", 1)
	set command = ##class(IBSP.Notice.DAT.TelegramCommand).UIActionCommandOpen(actionString, .sc)

    return sc
}

ClassMethod CreateNoticeRequestError(Output noticeRequest As IBSP.Notice.Request.PullNoticeRequest) As %Status
{
	set topicKey = ..#TopicErrorComand
	set topic = ##class(IBSP.Notice.DAT.Topic).UITopicKeyOpen(topicKey)
	set values("COMMAND") = ##class(IBSP.Notice.Utils).FormatCommandText(noticeRequest.Command)
	$$$QuitOnError(##class(IBSP.Notice.Utils).GetTopicText(topic, noticeRequest.Subscriber.Lang, .values, .text))

	set noticeRequest.Topic = topic
	set noticeRequest.DataTarget = ""
	set noticeRequest.Text = text

	return $$$OK
}

ClassMethod CreateNoticeRequestInternal(Output noticeRequest As IBSP.Notice.Request.PullNoticeRequest) As %Status
{
	set noticeRequest.Topic = ""
	set noticeRequest.DataTarget = ""
	set noticeRequest.Text = ..GetInternalCommandsText(noticeRequest)

	quit $$$OK
}

ClassMethod CreateNoticeRequestNotAuth(command As IBSP.Notice.DAT.TelegramCommand, Output noticeRequest As IBSP.Notice.Request.PullNoticeRequest) As %Status
{
	set topicKey = ..#TopicErrorUnauthorized
	set topic = ##class(IBSP.Notice.DAT.Topic).UITopicKeyOpen(topicKey)
	set actionCommand = command.ActionCommand
	set values("COMMAND") = ##class(IBSP.Notice.Utils).FormatCommandText(actionCommand)
	$$$QuitOnError(##class(IBSP.Notice.Utils).GetTopicText(topic, noticeRequest.Subscriber.Lang, .values, .text))
	
	set noticeRequest.Topic = topic
	set noticeRequest.Command = actionCommand
	set noticeRequest.DataTarget = command.ExecutionComponent
	set noticeRequest.Text = text

	return $$$OK
}

ClassMethod CreateNoticeRequest(command As IBSP.Notice.DAT.TelegramCommand, text As %String, Output noticeRequest As IBSP.Notice.Request.PullNoticeRequest) As %Status
{
	set noticeRequest.Topic = command.Topic
	set noticeRequest.Command= command.ActionCommand
	set noticeRequest.DataTarget = command.ExecutionComponent
	set noticeRequest.Text = text

	return $$$OK
}

ClassMethod GetInternalCommandsText(noticeRequest As IBSP.Notice.Request.PullNoticeRequest) As %String [ Internal, Private ]
{
    #define IsChatId(%command) ("chatid" = %command)
    #define IsSenderId(%command) ("senderid" = %command)

	set command = noticeRequest.Command
	set:($e(command, 1) = "/") command = $e(command, 2, *)
	set messageID = "INTERNAL." _ command
	set values("ID") = $case(command, "chatid": noticeRequest.ContactWayAddress
	                                , "senderid": noticeRequest.UserIdCode
									, : "UNKNOWN")
	
	set message = ##class(IBSP.Notice.Utils).GetTranslatedMessage(messageID, noticeRequest.Subscriber.Lang)
	return ##class(IBSP.Notice.Utils).ReplaceMessageTags(message, , .values)
}

}
