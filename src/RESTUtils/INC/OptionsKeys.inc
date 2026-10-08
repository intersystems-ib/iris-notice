ROUTINE RESTUtils.INC.OptionsKeys [Type=INC]
##; Options provide a way to alter the behaviour, they are passed through a subscribed variable

##; TODO move RESTUtils.INC.REST.OptionsKeys

##; Query related, allows to pass through a select clause that will be used in the query
##; do NOT allow external input to modify this, this should be set statically or by a trusted source, since it is not checked.
##; include the select keyword
##; TODO this should probably be removed
#Define CUSTOMSELECTCLAUSE "CustomSelectClause"

##; Filter related
#Define IGNOREARRAYNULLVALUE "IgnoreArrayNullValue"


##; Options imported from the body

##; This one is checked and can be passed through, allows columns, column alias and arrow syntax
##; Should be set in the body of the request, do not include the select keyword, only the columns
##; can accept *
#Define BODYSELECTCLAUSE "$$$SELECT"

##; Can be used to group by a column, useful to extract unique values
#Define BODYGROUPBYCLAUSE "$$$GROUPBY"

##; Possible parameters, can be passed through body or through headers

##; PATH. Namespace where the table is located
#Define OPNAMESPACE "namespace"
##; PATH. backend persistent class
#Define OPCLASS "class"
##; PATH. Allows to specify the identifier to open the object by
#Define OPIDENTIFIER "identifier"
##; BODY. Specifies how to filter the table, for more info /help/search/filter
#Define OPFILTER "filter"
##; BODY. Allows to specify the selected columns when exportType is JSON/EXCEL, check /help/search/select for more, by default only selects Id
#Define OPSELECT "select"
##; BODY. Allows to specify groupping for the query, can be multiple columns for example: "Name,Description" Do not leave any spaces. Can specify to the table with t. for exmaple: "t.Name"
#Define OPGROUPBY "group"
##; BODY. For compatibility, preferably use group
#Define OPGROUPBODY "groupBy"
##; BODY. Allows to specify ordering of the results, can be multiple columns for example: "Name asc,Description desc" Do not leave any spaces except between {{column}} {{direction}}. Can specify to the table with t. for exmaple: "t.Name asc" Always state the direction (asc|desc).
#Define OPORDER "order"
##; BODY. For compatibility, preferably use order
#Define OPORDERBY "orderBy"
##; BODY. Pagination of the results, must be 1 or higher, if not sent defaults to 1
#Define OPPAGE "page"
##; BODY. Size of the page, aka amount of results to return, must be 1 or higher, if not set defaults to 50
#Define OPSIZE "size"
##; URL or BODY. Allows to specify how results should be exported, can be EXCEL (export to an Excel file, ¡¡specifiy the columns for this one!!), JSON (Export the columns selected to a JSON body), JSONMAPPING (Uses a JSONMapping to (with the id field) open and export the object)
#Define OPEXPORTTYPE "exportType"
##; URL or BODY. Allows to specify what JSONMapping to use when exporting by JSONMAPPING, if not specified and the export type is JSONMapping, the class default is used
#Define OPJSONMAPPINGNAME "JSONMappingName"
##; URL or BODY. Allows to specify what class should be exported from the results (Only works with JSONMAPPING), defaults to class parameter (If class and JSONEnabledClass have different values you should sepcify the columnId parameter)
#Define OPJSONENABLEDCLASS "JSONEnabledClass"
##; BODY. Allows to specify what column represents the identity with which the %OpenId method will be called (Only works with JSONMAPPING)
#Define OPIDCOLUMN "idColumn"
##; URL. Allows to specify what JSONMAPPING should be used when importing the JSON body.
#Define OPUPDATEJSONMAPPINGNAME "updateJSONMappingName"
##; URL or BODY. Allows to specify the format for the EXCEL (Only works with EXCEL exportType)
#Define OPEXCELFORMATTING "EXCELFormatting"
##; URL or BODY. Suggests that the request doesn't need to be logged, this is implemented by the log (see RESTUtils.Persistent.LogDefinition), and each custom log implementation will decide if this parameter is honored or ignored.
#Define OPNOLOG "noLog"
##; URL. Used to open by the unique index specified, if a column has a unique index that is only of itself, send the property name to use the unique index of that property
#Define OPUNIQUEINDEX "uniqueIndex"
##; BODY. Send a JSON structure to customize the result more (Only works with JSON exportType)
#Define OPCUSTOMEXPORTBODY "exportStructure"

##; Out, if something is written to this options, method that write out should try to add them if possible
#Define OUTWARN "OUTWarn"

##;Internal of the utility

#Define INTTIMESTART "INTsts"
#Define INTTIMEEND "INTets"
#Define INTEXTENDSADAPTOR "INTExtendsAdaptor"






#Define INCLUDECOLUMNTYPES "includeColumnTypes"

#Define OUTCOLUMNTYPES "OUTCOLUMNTYPES"

##;Definitions for the options parameters

#Define ClassRelatedEndpointParameters $$$OPCLASS,$$$OPNAMESPACE,$$$OPJSONMAPPINGNAME,$$$OPNOLOG

#Define InstanceRelatedEndpointParameters $$$ClassRelatedEndpointParameters,$$$INCLUDECOLUMNTYPES

#Define ModifyEndpointParameters $$$InstanceRelatedEndpointParameters,$$$OPUPDATEJSONMAPPINGNAME

##; Parameters for each endpoint 

#Define SearchEndpointParameters $$$ClassRelatedEndpointParameters,$$$OPFILTER,$$$OPSELECT,$$$OPGROUPBY,$$$OPORDER,$$$OPPAGE,$$$OPSIZE,$$$OPEXPORTTYPE,$$$INCLUDECOLUMNTYPES,$$$OPNOLOG,$$$OPCUSTOMEXPORTBODY

#Define ClassInfoEndpointParamters $$$OPJSONMAPPINGNAME

#Define DeleteEndpointPrameters $$$OPNAMESPACE,$$$OPCLASS,$$$OPIDENTIFIER,$$$OPNOLOG,$$$OPUNIQUEINDEX

#Define UpdateEndpointParameters $$$ModifyEndpointParameters,$$$OPIDENTIFIER,$$$OPUNIQUEINDEX

#Define CreateEndpointParameters $$$ModifyEndpointParameters

#Define GetEndpointParameters $$$InstanceRelatedEndpointParameters,$$$OPIDENTIFIER,$$$OPUNIQUEINDEX,$$$OPNOLOG