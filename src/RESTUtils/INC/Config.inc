ROUTINE RESTUtils.INC.Config [Type=INC]
#Define ConfigGlobal ^RESTUtilsConfig
#Define GetAmountOfLogsToLeave $GET($$$ConfigGlobal("AmountOfLogsToLeave"),1000)