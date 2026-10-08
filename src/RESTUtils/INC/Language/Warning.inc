ROUTINE RESTUtils.INC.Language.Warning [Type=INC]
#Include RESTUtils.INC.Providers
#Include RESTUtils.INC.Status
#Include RESTUtils.INC.Utils

#Define WarnClassExtendingAdaptor(%options) $$$AddWarn(%options, "Class extends %JSON.Adaptor instead of RESTUtils.JSON.Adaptor, some functionalities might not work as expected.")
#Define WarnDeprecatedEndpointWarning(%options) $$$AddWarn(%options, "Warning, this endpoint is deprecated and might be removed in the future")