ROUTINE RESTUtils.INC.Providers [Type=INC]

##; All classes that invoke another class in this package do so via macros that inherit from this one.
##; If, for example, a class needs to call the ExportResultSet method of the class RESTUtils.Search.Export.Export
##; it won't call it directly, instead it would use the macro $$$ExportResultSet defined in the Export.inc file.

##; Some general terms to define this mess:
##; Services -> Provide a service, usually related with persistance, can execute queries and should define the interactions
##;     between the broader system and the resolvers.
##; Resolvers -> Logic classes, should avoid, as reasonably as possible, to interact with the system,
##;     shouldn't execute queries nor access globals and must isolate the logic, should also be accesed through the services
##; Definitions -> Classes where something mutable or extendable is defined, used by services or resolvers, one
##;     example can be filters, where we can edit or add a new filter to extend functionalities
##; Helper -> Msg like class, might be persistent as a necessity but shouldn't leave any trace in the system,
##;             when it's use is done can be deleted, to ensure they are properly deleted periodic purges can be added


#Define Version "0.9.1"

##; Namespace where the utility is actually installed
#Define InstallationNamespace ##function(""""_$NAMESPACE_"""")

##; Filter

#Define FilterDefinition "RESTUtils.Resolver.Filter.Definition.FilterDefinition"

#Define FilterResolver "RESTUtils.Resolver.Filter.FilterResolver"

##; Search

#Define SearchLogicImplementationClass "RESTUtils.Resolver.Query.QueryResolver"

#Define SearchCheckResolver "RESTUtils.Resolver.Query.CheckResolver"

#Define SearchClass "RESTUtils.Service.Search.SearchService"

##; Import
#Define ImportResolver "RESTUtils.Resolver.Import.ImportResolver"

##; Export

#Define ExportClass "RESTUtils.Resolver.Export.ExportResolver"

#Define ExportToJSONMappingClass "RESTUtils.Resolver.Export.Definitions.ExportToJSONMapping"

##; Auth

#Define AuthService "RESTUtils.Service.Authorization.AuthorizationService"

#Define AuthPersistance "RESTUtils.Persistent.Authorization.AuthorizationDefinition"

##; Modification

#Define ModificationClass "RESTUtils.Service.Modification.ModificationService"

##; Utils

#Define UtilsClass "RESTUtils.Util.GeneralUtils"

##; Info

#Define ClassInfoClass "RESTUtils.Service.ClassInfo.ClassInfoService"

#Define ToExternalTypeDefinition "RESTUtils.Resolver.ClassInfo.Definition.ToExternalTypeDefinition"

##; Log
#Define LogPersistant "RESTUtils.Persistent.Log.Log"

#Define LogDefinitionPersistant "RESTUtils.Persistent.Log.LogDefinition"

#Define LogService "RESTUtils.Service.Log.LogService"

##; Help
#Define HelpService "RESTUtils.Service.Help.HelpService"

#Define HelpParameterService "RESTUtils.Service.Help.ParameterService"

#Define HelpOptionsKeys "RESTUtils.INC.OptionsKeys"

#Define HelpResolver "RESTUtils.Resolver.OptionsKeys.OptionsKeysInfoResolver"

##;Custom json imp
#Define JSONIMPRESTUtils "RESTUtils.JSON.Adaptor"


##;Import
#Define ImportService RESTUtils.Service.Import.ImportService