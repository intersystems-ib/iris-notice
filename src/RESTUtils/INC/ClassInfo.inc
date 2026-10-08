ROUTINE RESTUtils.INC.ClassInfo [Type=INC]
#Include RESTUtils.INC.Providers

#Define GetClassInfo(%class, %namespace) $CLASSMETHOD($$$ClassInfoClass, "ExportUniqueValuesOfClass", %class, %namespace)
#Define GetColumnsFromJSONMapping(%class, %namespace, %JSONMappingName) $CLASSMETHOD($$$ClassInfoClass, "GetColumnsFromJSONMapping", %class, %namespace, %JSONMappingName)
#Define ToExternalType(%type, %isIdentity, %referenceDepth, %isInDepthReference) $CLASSMETHOD($$$ToExternalTypeDefinition, "TypeToExternal", %type, %isIdentity, %referenceDepth, %isInDepthReference)