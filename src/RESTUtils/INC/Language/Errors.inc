ROUTINE RESTUtils.INC.Language.Errors [Type=INC]
#Include RESTUtils.INC.Providers
#Include RESTUtils.INC.Status

#Define GEx(%msg, %status) ##Class(%Exception.General).%New(%msg, %status)

#Define ClassNotFound $$$GEx("Class does not exist", $$$NOTFOUND)

#Define NamespaceNotFound $$$GEx("Namespace not found", $$$BADREQUEST)

#Define ClassDoesNotExtendAdaptor $$$GEx("Class does not extend JSON adaptor", $$$BADREQUEST)

#Define ContentNotSupported $$$GEx("Content-type not supported", $$$NOTSUPPORTED)

#Define IndexNotFound  $$$GEx("Index does not exist", $$$NOTFOUND)

#Define TableNotFound $$$GEx("Table not found", $$$NOTFOUND)

#Define ExportMethodNotFound  $$$GEx("Export method not found", $$$NOTFOUND)

#Define StringNotClosed $$$GEx("String not closed", $$$BADREQUEST)

#Define ObjectNotFound $$$GEx("Object not found", $$$NOTFOUND)

##; clean errors

#Define TooManyFunctions $$$GEx("Too many functions for column", $$$BADREQUEST)

#Define InvalidFunction $$$GEx("Invalid function in column", $$$BADREQUEST)

#Define InvalidLiteral $$$GEx("Invalid literal in column", $$$BADREQUEST)

#Define InvalidTable $$$GEx("Invalid talbe", $$$BADREQUEST)

#Define InvalidSize $$$GEx("Invalid size", $$$BADREQUEST)

#Define InvalidPage $$$GEx("Invalid page", $$$BADREQUEST)

#Define InvalidNothingToSelect $$$GEx("Nothing to select", $$$BADREQUEST)

#Define InvalidOrderBy $$$GEx("InvalidOrderBy", $$$BADREQUEST)

#Define InvalidColumn(%msg, %column) $$$GEx(%msg _ " in "_%column, $$$BADREQUEST)

##; Help errors

#Define HelpNotFound $$$GEx("Not found", $$$NOTFOUND)

#Define FailedToObtainParameters $$$GEx("Can't provide help, contact administrator", $$$INTERNALERROR)


##; Search errors



##; Modification errors
#Define FailureCreatingObject $$$GEx("Failure creating object, do not retry", $$$INTERNALERROR)


##; SQL Errors
#Define HandledSQLCodes $LISTBUILD(-23, -24, -27, -29, -30, -31, -98, -99, -149)
#Define GeneralSQLError $$$GEx("Failed running query", $$$BADREQUEST)
#Define BadRequestSQL(%code, %msg) $$$GEx("Code: "_ %code _ "Message: " _ %msg, $$$BADREQUEST)
#Define ForbiddenSQL() $$$GEx("Privilege failure", $$$FORBIDDEN)
#Define UnhandledSQL(%code, %msg) $$$GEx("Code: "_ %code _ "Message: " _ %msg, "")


##; Print errors
#Define InvalidElementForPrint ##Class(%Exception.General).%New("Invalid element for print", $$$BADREQUEST)




##; Import errors
#Define TooManyItems ##Class(%Exception.General).%New("Too many items for import, can not add more", $$$BADREQUEST)
#Define ImportIdNotFound ##Class(%Exception.General).%New("Import not found", $$$NOTFOUND)
#Define FailedToCreateClass(%class) ##Class(%Exception.General).%New("Failed to create item for class: " _ %class, $$$NOTFOUND)
#Define RequiresRESTUtilsAdaptor ##Class(%Exception.General).%New("To import all classes must extend the RESTUtils adaptor", $$$BADREQUEST)

