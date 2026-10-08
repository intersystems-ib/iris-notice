ROUTINE RESTUtils.INC.Log [Type=INC]
#Include RESTUtils.INC.Providers

#Define Log(%options, %action) $CLASSMETHOD($$$LogService, "CollectAndLog", %options, %action)
#Define IntLog(%msg, %level) $CLASSMETHOD($$$LogService, "InternalLog", %msg, %level)
#Define PurgeInternalLog $CLASSMETHOD($$$LogPersistant, "RunDeleteQuery")
