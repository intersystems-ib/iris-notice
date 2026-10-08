ROUTINE RESTUtils.INC.Content.Export [Type=INC]
#Include RESTUtils.INC.Providers

##;Method called to export a resultset, determines the export type via the options, see Export.inc and OptionsKeys.inc for more info
#Define ExportResultSet(%qres, %exportType, %options) $CLASSMETHOD($$$ExportClass, "ExportResultSet", %qres, %exportType, %options)

##;Export options, are always uppercase

##; Always start exporttype parameters with ExportTo
##; Export via a JSONMapping, see OptionsKeys.inc
#Define ExportToJSON "JSONMAPPING"
##; Creates excel with the resulting search rows
#Define ExportToExcel "EXCEL"
##; The default, exports as a JSON the resulting search rows
#Define ExportToColumns "JSON"

#Define GetColumns(%qres, %namespace, %columnExport) $CLASSMETHOD($$$ExportClass, "GetColumns", %qres, %namespace, %columnExport)

#Define IntExportSingleObjectToJSON(%jsonEnabledClass, %id, %options) $CLASSMETHOD($$$ExportToJSONMappingClass, "IntExportJSONMappingObject", %jsonEnabledClass, %id, %options)

#Define ExportSingleObjectToJSON(%jsonEnabledClass, %id, %options) $CLASSMETHOD($$$ExportClass, "ExportJSONMappingObject", %jsonEnabledClass, %id, %options)

#Define ExportJSONToExcel(%json, %options) $CLASSMETHOD($$$ExportClass, "ExportFromJSONToEXCEL", %json, %options)
