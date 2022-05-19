Class IBSP.Notice.InitMasterTables
{

/// do ##class(IBSP.Notice.InitMasterTables).Init()
ClassMethod Init() As %Status
{
    $$$QuitOnError(..CreateLangauges())
    return ..CreateParameters()
}

ClassMethod CreateLangauges() As %Status [ Internal, Private ]
{
	set iso = "en", description = "English"
	$$$QuitOnError(..CreateLanguage(iso, description))

	set iso = "es", description = "Castellano"
	$$$QuitOnError(..CreateLanguage(iso, description))

	set iso = "ca", description = "Català"
	$$$QuitOnError(..CreateLanguage(iso, description))

	write !, "Languages loaded"
	return $$$OK
}

ClassMethod CreateLanguage(iso As %String, description As %String) As %Status [ Internal, Private ]
{
	set language = ##class(IBSP.Notice.DAT.Lang).%New()
	set language.ISO = iso
	set language.Description = description

	return language.%Save(0)
}

ClassMethod CreateParameters() As %Status [ Internal, Private ]
{
	$$$QuitOnError(..CreateDefaultLanguageParam())
	$$$QuitOnError(..CreateDefaultIdForSubscribersParam())
	$$$QuitOnError(..CreateBotTelegramIdParam())
	$$$QuitOnError(..CreateMailSendingParams())
	return ..CreateOtherParams()
}

ClassMethod CreateDefaultLanguageParam() As %Status [ Internal, Private ]
{
	set id = "DefaultLang", description = "Default language ID", value = "1", type = "TEXT"
	$$$QuitOnError(..CreateParam(id, description, value, type))

	write !, "Default language parameter loaded"
	return $$$OK
}

ClassMethod CreateDefaultIdForSubscribersParam() As %Status [ Internal, Private ]
{
	set id = "DefaultID", description = "Default ID for Subscribers", value = "employeeid", type = "TEXT"
	$$$QuitOnError(..CreateParam(id, description, value, type))

	write !, "Default ID for subscribers parameter loaded"
	return $$$OK
}

ClassMethod CreateBotTelegramIdParam() As %Status [ Internal, Private ]
{
	set id = "BotISCIberia", description = "ID BotISCIberia", value = "bot2014268095:AAGFz2f0r7PydW5jFp4JkPZVBHOkC8qSHlA", type = "BOT"
	$$$QuitOnError(..CreateParam(id, description, value, type))

	write !, "Bot Telegram ID parameter loaded"
	return $$$OK
}

ClassMethod CreateMailSendingParams() As %Status [ Internal, Private ]
{
	set id = "MAIL_SERVER", description = "Mail Server|Port|User|Password", value = "mail.iscinternal.com|25|ilicense|Ib2!Li6?2020", type = "TEXT"
	$$$QuitOnError(..CreateParam(id, description, value, type))

	set id = "MAIL_NOT_FROM", description = "Mail Notice From", value = "Iberia Notifications - BASE <iberia.notifications@intersystems.com>", type = "TEXT"
	$$$QuitOnError(..CreateParam(id, description, value, type))

	set id = "MAIL_NOT_BCC", description = "Mail Notice Bcc:", value = "jose.ruiz@intersystems.com", type = "TEXT"
	$$$QuitOnError(..CreateParam(id, description, value, type))

	set id = "MAIL_NOT_LEGAL_WARNING", description = "Legal Warning for the foot of the mails", value = "<p><strong>LEGAL WARNING</strong></p><p>This message and its attachments are addressed exclusively to the recipient, and may contain confidential information. Reproduction or distribution is not permitted without the express authorization of InterSystems Iberia SL. If you are not the final recipient, please delete it and inform us in this way</p><p>In accordance with the provisions of the Organic Law 15/1999, of December 13, on the Protection of Personal Data (LOPD), we inform you that your data is included in a file held by InterSystems Iberia SL for the purpose of inform you of our activities.</p><p>Likewise, we inform you of the possibility of exercising the rights of access, rectification, cancellation and opposition of your data in the tax domicile of InterSystems Iberia SL, located in Avenida de Europa, 12, Edificio Monaco. PARQUE Empresarial de la Moraleja, 28108 Alcobendas Madrid.</p>", type = "TEXT"
	$$$QuitOnError(..CreateParam(id, description, value, type))

	set id = "MAIL_NOT_CC", description = "Mail Notice Cc:", value = "", type = "TEXT"
	$$$QuitOnError(..CreateParam(id, description, value, type))

	set id = "MAIL_NOT_SUBJ", description = "Mail Notice Subject", value = "BASE: Iberia WorkDay Notification", type = "TEXT"
	$$$QuitOnError(..CreateParam(id, description, value, type))

	write !, "Mail sending parameters loaded"
	return $$$OK
}

ClassMethod CreateOtherParams() As %Status [ Internal, Private ]
{
	set id = "LOG_LEVEL", description = "0: Nothing to log - 1: Only Errors - 2: Errors+Warnings - 3: All for Debug", value = "3", type = "NUMBER"
	$$$QuitOnError(..CreateParam(id, description, value, type))

	set id = "CORPORATE_LOGO", description = "Corporate Logo", value = "data:image/png;base64,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", type = "NUMBER"
	$$$QuitOnError(..CreateParam(id, description, value, type))

	write !, "Extra parameters loaded"
	return $$$OK
}

ClassMethod CreateParam(id As %String, description As %String, value As %String, type As %String) As %Status [ Internal, Private ]
{
	set defaultLanguageParam = ##class(IBSP.Notice.DAT.Params).%New()
	set defaultLanguageParam.ParamID = id
	set defaultLanguageParam.ParamDesc = description
	set defaultLanguageParam.ParamValue = value
	set defaultLanguageParam.ParamType = type
	
	return defaultLanguageParam.%Save(0)
}

}
