ROUTINE RESTUtils.INC.Utils [Type=INC]
#Include RESTUtils.INC.Providers
#Include RESTUtils.INC.Language.Errors

#Define GetByIdOrIndex(%class, %id, %options) $CLASSMETHOD($$$UtilsClass, "GetByIdOrIndex", %class, %id, %options)
#Define ClassExists(%class, %namespace, %outCompiledClass, %outExtendsAdaptor) $CLASSMETHOD($$$UtilsClass, "ClassExists", %class, %namespace, %outCompiledClass, %outExtendsAdaptor)
#Define GetTable(%class, %namespace) $CLASSMETHOD($$$UtilsClass, "GetTable", %class, %namespace)
#Define ExecQuery(%query, %namespace, %args) $CLASSMETHOD($$$UtilsClass, "ExecQuery", %query, %namespace, %args)

#Include RESTUtils.INC.OptionsKeys
#Define SwapToInstallationNamespace If ($NAMESPACE '= $$$InstallationNamespace){ NEW $NAMESPACE zn $$$InstallationNamespace }
#Define WrapInCatch(%code, %error, %status) Try{ %code }Catch e {THROW ##Class(%Exception.General).%New(%error_e.DisplayString(), %status)}
#Define OnErrorThrow(%statusFunction, %exception) Try{ $$$ThrowOnError(%statusFunction)  ##Continue
 }Catch e { THROW %exception }

##; Should be called right at the start of every deprecated endpoint, adds info about deprecation for logging
##; TODO change to addwarn
#Define AddDeprecatedOp(%options) %options($$$INTISDEPRECATED) = 1
#Define AddWarn(%options, %msg) $CLASSMETHOD($$$UtilsClass, "AddWarning", %options, %msg)

#Include RESTUtils.INC.Status
#Define SwapNamespace(%optionsOrNamespace) Set namespace = $GET(%optionsOrNamespace($$$OPNAMESPACE), %optionsOrNamespace) ##continue
    Try{ NEW $NAMESPACE}Catch e {THROW $$$NamespaceNotFound} ##continue 
    zn:(namespace '= "") namespace


#Define IRISSystemVersion $SYSTEM.Version.GetNumber()

#Define HigherOrEqualVersionOfIRIS(%majorVersion) $PIECE($$$IRISSystemVersion,".",1,1) >= %majorVersion

##;Internal hardcodeds for Utils

#Define JSONAdaptorClass "%JSON.Adaptor"



