ROUTINE RESTUtils.INC.Help [Type=INC]
#Include RESTUtils.INC.Providers

#Define GetHelp(%endpoint) $CLASSMETHOD($$$HelpService, "GetHelp", %endpoint)

#Define GetHelpPage $CLASSMETHOD($$$HelpService, "HelpPage")

#Define GetParametersHelp(%parameters) $CLASSMETHOD($$$HelpParameterService, "GetParametersOfEndpoint", %parameters)