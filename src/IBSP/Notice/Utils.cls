Class IBSP.Notice.Utils
{

/// Log&Debug method
/// PARAMS: pType: 1: ERROR / 2: WARN / 3: DEBUG
/// 			pText: Text to include
/// ##class(UTIL.Function).Log(3, "TEXT to LOG")
ClassMethod Log(pType As %String, pText As %String)
{
	set level = ..GetParameter("LOG_LEVEL")
	if (pType <= level) {
	
		if (pType = 3) {set Type = "DEBUG"
		} elseif (pType = 2) {set Type = "WARN"
		} elseif (pType = 1) {set Type = "ERROR"}
		set ind=$INCREMENT(^NOTlog(Type))
		set ^NOTlog(Type,ind)=$zdatetime($horolog,3)_":"_Type_"|"_pText
	}
}

/// Returns the value of a given parameter. This parameters can be used across REP and CLP applications.
ClassMethod GetParameter(paramID As %String) As %String
{
	&sql(SELECT ParamValue, ParamType into :newID, :ptype
		FROM IBSP_Notice_DAT.Params
		WHERE ParamID=:paramID)	
	if (SQLCODE=100) {
		do ##class(IBSP.Notice.Utils).Log(2,"WARNING: Parameter not defined: "_paramID)
		quit "ERROR"
	}
		
	if (ptype = "SECUENCE") {
		set nextID = newID + 1 
		&sql(UPDATE IBSP_Notice_DAT.Params
		SET ParamValue = :nextID
		WHERE ParamID=:paramID)
	} 
	quit newID
}

/// Extract all the parameters received for a command
ClassMethod ExtractParametersFromCommand(command As %String) As %String
{
	Quit $piece(command, " ", 2, *)
}

/// Gets the token for a topic
ClassMethod GetTopicToken(topic As IBSP.Notice.DAT.Topic, Output token As %String) As %Status
{
	set tSC = $$$OK

	try {

		set token = ""

		return:('$isobject(topic)) tSC

		set botName = topic.BotName
		$$$ThrowOnError(..GetBotToken(botName, .token))
	} catch ex {
		set tSC = ex.AsStatus()
	}

	quit tSC
}

/// Gets the token for a bot
ClassMethod GetBotToken(botName As %String, Output token As %String) As %Status
{
	set tSC = $$$OK

	try {

		set token = ""

		set paramBot = ##class(IBSP.Notice.DAT.Params).PKParamsOpen(botName)
		set:($isobject(paramBot)) token = paramBot.ParamValue
	} catch ex {
		set tSC = ex.AsStatus()
	}

	quit tSC
}

/// Gets the UserId Type and Code for a topic
ClassMethod GetTopicUserId(topic As IBSP.Notice.DAT.Topic, params As %DynamicObject, Output userIdType As %String, Output userIdCode As %String) As %Status
{
	set tSC = $$$OK

	try {

		set (userIdType, userIdCode) = ""

		return:('$isobject(topic)) tSC

		set topicDestination = topic.Destination
		return:(topicDestination = "") tSC

		for i = 1: 1: $length(topicDestination, ",") {

			set destination = $piece(topicDestination, ",", i)
			
			if (params.%Get(destination) '= "") {

				set userIdType = destination
				set userIdCode = params.%Get(destination)

				quit
			}
		}
	} catch ex {
		set tSC = ex.AsStatus()
	}

	quit tSC
}

/// Gets if the notification has to be sent to the employee manager too.
ClassMethod GetTopicManagerNotification(topic As IBSP.Notice.DAT.Topic, Output managerNotification As %Boolean) As %Status
{
	#define IsManagerId(%destination) "managerid" = %destination

	set tSC = $$$OK

	try {

		set managerNotification = $$$NO

		return:('$isobject(topic)) tSC

		set topicDestination = topic.Destination
		return:(topicDestination = "") tSC

		for i = 1: 1: $length(topicDestination, ",") {

			set destination = $piece(topicDestination, ",", i)
			
			if ($$$IsManagerId(destination)) {

				set managerNotification = $$$YES

				quit
			}
		}
	} catch ex {
		set tSC = ex.AsStatus()
	}

	quit tSC
}

/// Gets the topic text params as an array
ClassMethod GetTextParamsAsArray(params As %String, ByRef paramsArray As %String) As %Status
{
	set tSC = $$$OK

	try {

		set paramsArray = ""
		set paramsJSON = {}.%FromJSON(params)

		set iter = paramsJSON.%GetIterator()
		while iter.%GetNext(.key , .value ) {
			set paramsArray(key) = value
		}
	} catch ex {
		set tSC = ex.AsStatus()
	}
	
	quit tSC
}

/// Gets the final text for a topic in the corresponding language and replaces the tags with the input parameters ARRAY
ClassMethod GetTopicText(topic As IBSP.Notice.DAT.Topic, lang As IBSP.Notice.DAT.Lang, ByRef params, Output text As %String) As %Status
{
	#define DefaultLang ##class(IBSP.Notice.DAT.Lang).GetDefault()

	set tSC = $$$OK

	try {

		set text = ""
		return:('$isobject(topic)) tSC

		set message = ..GetTopicMessage(topic, lang)
		set text = ..ReplaceMessageTags(message, topic.IsHtmlFormat(), .params)
	} catch ex {
		set tSC = $$$OK
	}

	quit tSC
}

/// Returns the topic message depending on the language.
/// If there's no message for this language, the message for the default language is returned.
/// If there's no message for the default language either, the topic template is returned.
ClassMethod GetTopicMessage(topic As IBSP.Notice.DAT.Topic, lang As IBSP.Notice.DAT.Lang) As %String [ Internal, Private ]
{
	quit ..GetTranslatedMessage(topic.TemplateMsg, lang, topic.Template)
}

/// Returns the topic message depending on the language.
/// If there's no message for this language, the message for the default language is returned.
/// If there's no message for the default language either, the default message is returned.
ClassMethod GetTranslatedMessage(messageID As %String, lang As IBSP.Notice.DAT.Lang, defaultMessage As %String = "") As %String
{
	#define DefaultLang ##class(IBSP.Notice.DAT.Lang).GetDefault()
	#define IsDefaultLang(%lang) (%lang = $$$DefaultLang)

	set language = lang
	set:('$isobject(language)) language = $$$DefaultLang

	set message = ##class(IBSP.Notice.DAT.Message).UIMsgLangOpen(messageID, language.%Id())

	quit:($isobject(message)) message.Message
	quit:($$$IsDefaultLang(language)) defaultMessage

	set message = ##class(IBSP.Notice.DAT.Message).UIMsgLangOpen(messageID, $$$DefaultLang.%Id())

	quit:($isobject(message)) message.Message
	quit defaultMessage
}

ClassMethod GetTopicBody(topic As IBSP.Notice.DAT.Topic, ByRef params, Output text As %String) As %Status
{
	set tSC = $$$OK

	try {

		set text = ""
		return:('$isobject(topic)) tSC

		set bodyTemplate = topic.BodyTemplate
		set text = ..ReplaceMessageTags(bodyTemplate, $$$YES, .params)
	} catch ex {
		set tSC = $$$OK
	}

	quit tSC
}

/// Replaces the tags in the message with the inpunt params ARRAY
ClassMethod ReplaceMessageTags(message As %String, formatText As %Boolean = 0, ByRef params) As %String
{
	set text = $replace(message, "##ENTER##", $char(10))

	set:($g(params("HORA")) = "") text = $replace(text, "##TIME##", $ztime($p($h, ",", 2), 2)) //i.e "19:12"
	set:($g(params("FECHA")) = "") text = $replace(text, "##DATE##", $zdate($h, 2)) //i.e "18 Jun 2020"
	set:($g(params("FECHAHORA")) = "") text = $replace(text, "##DATETIME##", $zdatetime($h, 2, 2)) //i.e "18 Jun 2020 19:12"
		
	set key = ""
	do {
	
		set key = $order(params(key))
		quit:(key = "")
		set text = $replace(text, "##" _ key _ "##", $g(params(key)))
	} while key '= ""
	
	set text = ..RemoveNotFilledConditions(text)
	set text = ..RemoveNotUsedTags(text)
	set:('formatText) text = ..FormatText(text)

	quit text
}

/// Replace characters to adapt to sender restrictions
ClassMethod FormatText(text As %String) As %String
{
	// In all other places characters 
	// '_', '*', '[', ']', '(', ')', '~', '`', '>', '#', '+', '-', '=', '|', '{', '}', '.', '!' 
	// must be escaped with the preceding character '\'.
	set text = $replace(text, "[", "\[")
	set text = $replace(text, "]", "\]")
	set text = $replace(text, "(", "\(")
	set text = $replace(text, ")", "\)")
	set text = $replace(text, "~", "\~")
	set text = $replace(text, "`", "\`")
	set text = $replace(text, ">", "\>")
	set text = $replace(text, "#", "\#")
	set text = $replace(text, "+", "\+")
	set text = $replace(text, "-", "\-")
	set text = $replace(text, "=", "\=")
	set text = $replace(text, "|", "\|")
	set text = $replace(text, "{", "\{")
	set text = $replace(text, "}", "\})")
	set text = $replace(text, ".", "\.")
	set text = $replace(text, "!", "\!")
	quit text
}

/// Replace characters to adapt to sender restrictions
ClassMethod FormatCommandText(text As %String) As %String
{
	// '_', '*'
	// must be escaped with the preceding character '\'.
	set text = $replace(text, "_", "\_")
	set text = $replace(text, "*", "\*") 
	quit text
}

ClassMethod RemoveNotFilledConditions(text As %String) As %String [ Internal, Private ]
{
	set header = "[[", trailer = "]]"
	set pos1 = 1, pos2 = 1, aux = 1
	set tagHeader = "##"
	set aux2 = 1
	set textNoEmptyConditions = ""

	do {

		set pos1 = $find(text, header, pos2)

		if pos1 '= 0 {

			set aux = $find(text, trailer, pos1)

			if aux '= 0 {

				set aux2 = $find(text, tagHeader, pos1)

				if (aux2 > pos1) && (aux2 < aux) {
					set textNoEmptyConditions = textNoEmptyConditions _ $extract(text, pos2, pos1 - $l(header) - 1)
				} else {
					set textNoEmptyConditions = textNoEmptyConditions _ $extract(text, pos2, aux - 1)
				}
			} else {

				// if trailer is not found, copy the last part of the text (at least with a wrong not closed condition) and finish looking for conditions
				set textNoEmptyConditions = textNoEmptyConditions _ $extract(text, pos2, *)
				set pos1 = 0
			}

			set pos2 = aux
		} else {

			// if no more conditions found copy the last part of the text
			set textNoEmptyConditions = textNoEmptyConditions _ $extract(text, pos2, *)
		}

	} while pos1 '= 0

	set textNoEmptyConditions = $replace(textNoEmptyConditions, "[[", "")
	set textNoEmptyConditions = $replace(textNoEmptyConditions, "]]", "")

	return textNoEmptyConditions
}

/// Remove all i.e. ##TAG## that weren't parsed
ClassMethod RemoveNotUsedTags(text As %String) As %String [ Internal, Private ]
{
	set header = "##", trailer = "##"
	set pos1 = 1, pos2 = 1, aux = 1
	set textNoTags = ""

	do {

		set pos1 = $find(text, header, pos2)

		if pos1 '= 0 {

			set aux = $find(text, trailer, pos1)

			if aux '= 0 {
				set textNoTags = textNoTags _ $extract(text, pos2, pos1 - $l(header) - 1)
			} else {

				// if trailer is not found, copy the last part of the text (at least with a wrong not closed tag) and finish looking for tags
				set textNoTags = textNoTags _ $extract(text, pos2, *)
				set pos1 = 0
			}

			set pos2 = aux
		} else {

			// if no more tags found copy the last part of the text
			set textNoTags = textNoTags _ $extract(text, pos2, *)
		}
	} while pos1 '= 0
	
	quit textNoTags
}

/// Find chatId or userId in the Subscribers Address field
/// If any of these is found, the command is approved
ClassMethod IsUserApproved(userId As %String, commandName As %String) As %Boolean
{
	//TODO in JIRA https://jira.intersystems.co.uk/browse/IBINT-100
	quit $$$YES
}

}
