Include (RESTUtils.INC.Utils, RESTUtils.INC.Status, RESTUtils.INC.ClassInfo, RESTUtils.INC.Language.Errors)

/// TODO this should be broken down into a Resolver
Class RESTUtils.Service.ClassInfo.ClassInfoService
{

// Unique values

ClassMethod ExportUniqueValuesOfClass(class As %String(MAXLEN=""), namespace As %String(MAXLEN="") = "") As %DynamicObject
{
    Try{
        $$$SwapNamespace(namespace)
        Set indices = ..GetIndices(class, .compiledClass)
        Set indexGlobal = ..GetIndexLocation(compiledClass)
        Set resultObject = ..GetProperties(compiledClass)
        Return ..IterateIndex(indexGlobal, indices, .resultObject)
    }Catch e {
        
        Return {}
    }
}

ClassMethod GetIndices(className As %String(MAXLEN=""), Output compiledClass As %Dictionary.CompiledClass) As %Library.ArrayOfObjects(ELEMENTTYPE="%Dictionary.CompiledIndex") [ Final, Internal, Private ]
{
    Set compiledClass = ##Class(%Dictionary.CompiledClass).%OpenId(className)
    THROW:(compiledClass = "")
    Return compiledClass.Indices
}

ClassMethod GetIndexLocation(class As %Dictionary.CompiledClass) As %String(MAXLEN="") [ Final, Internal, Private ]
{
    #DIM storage As %Dictionary.CompiledStorage
    ///Obtain first storage definition
    Set storage = class.Storages.GetNext("")
    THROW:(storage = "") ##Class(%Exception.General).%New("Failed to find storage definition for class")
    Return storage.IndexLocation
}

ClassMethod GetProperties(compiledClass As %Dictionary.CompiledClass) As %DynamicObject
{
    Set result = {}
    Set properties = compiledClass.Properties
    Set key = ""
    FOR{
        Set prop = properties.GetNext(.key)
        #DIM prop As %Dictionary.CompiledProperty
        quit:(prop = "")    
        Set parameterArray = prop.Parameters
        Set parameterKey = ""
        ///TODO finish and check
        Set valueList = prop.%GetParameter("VALUELIST")
        Do:(valueList '= "") result.%Set(, [].%FromJSON("["""_$LISTTOSTRING($LISTFROMSTRING($EXTRACT(prop.Name,2,*),$EXTRACT(prop.Name,1,1)), """,""")_"""]"))
    }
    Return result
}

ClassMethod IterateIndex(indexGlobal As %String(MAXLEN=""), indices As %Library.ArrayOfObjects(ELEMENTTYPE="%Dictionary.CompiledIndex"), ByRef result As %DynamicObject) As %DynamicObject [ Final, Internal, Private ]
{
    Set result = {}
    Set key = ""
    FOR {
        Set index = indices.GetNext(.key)
        quit:(index="")
        ///TODO check index.Properties when collation is specified
        continue:(($EXTRACT(index.Name, 1, 1) = "$") || ($LISTLENGTH($LISTFROMSTRING(index.Properties)) '= 1) || (result.%Get(index.Properties) '= ""))
        Do ..IterateIndexValues(indexGlobal, index, .result)
    }
    Return result
}

ClassMethod IterateIndexValues(indexGlobal As %String(MAXLEN=""), index As %Dictionary.CompiledIndex, ByRef indexObject As %DynamicObject) As %DynamicArray [ Final, Internal, Private ]
{
    Set valueArr = []
    Set indexValue = ""
    FOR{
        Set indexValue = $ORDER(@indexGlobal@(index.Name, indexValue))
        If (indexValue = ""){
            Do:(valueArr.%Size()>0) indexObject.%Set(index.Properties, valueArr)
            quit
        }
        Do valueArr.%Push($CASE(indexValue, -100000000000000:"", :indexValue))
        quit:(valueArr.%Size()>30)
    }
}

// JSONMapping export

ClassMethod GetColumnsFromJSONMapping(className As %String(MAXLEN=""), namespace As %String(MAXLEN="") = "", JSONMappingName As %String(MAXLEN="") = "") As %DynamicArray [ Final ]
{
    $$$SwapNamespace(namespace)
    Set class = ##Class(%Dictionary.CompiledClass).%OpenId(className)
    THROW:(class="") $$$ClassNotFound
    If (JSONMappingName '= ""){
        Return ..ExtractMappingProperties(class, JSONMappingName, 4)
    }else{
        Return ..ExtractClassProperties(class, 4)
    }
}

ClassMethod ExtractClassProperties(class As %Dictionary.CompiledClass, referenceDepth As %Numeric = 0) As %DynamicObject [ Final, Internal, Private ]
{
    Set properties = class.Properties
    Set key = ""
    #DIM prop As %Dictionary.CompiledProperty
    FOR {
        ///Iterate the props
        Set prop = properties.GetNext(.key)
        quit:(prop="")
        ///TODO either transient or private properties are not extracted by JSON adaptor, ought to be tested
        continue:((prop.Name = "%Concurrency") || (prop.Transient))

        //Name for the prop
        Set propName = prop.Name
        Set jsonFieldname = prop.Parameters.GetAt("%JSONFIELDNAME")
        If ((prop.Identity) ||(propName = "%%OID")){
            ///Identity is always exported as Id
            Set propName = "Id"
        }ElseIf (jsonFieldname '= "") {
            Set propName = jsonFieldname
        }
        
        ///Add to the resultSet
        Set propertyClass = ##Class(%Dictionary.CompiledClass).%OpenId(prop.Type)
        Set include = prop.Parameters.GetAt("%JSONINCLUDE")
        Set referenceType = prop.Parameters.GetAt("%JSONREFERENCE")
        Do ..SetValueToResult(.result, propName, include, referenceType, propertyClass, prop.Identity, referenceDepth)      
    }
    Return result
}

ClassMethod ExtractMappingProperties(class As %Dictionary.CompiledClass, mappingName As %String(MAXLEN=""), referenceDepth As %Numeric = 0) As %DynamicObject [ Final, Internal, Private ]
{
    ///Open the XData
    Set xData = ##Class(%Dictionary.CompiledXData).%OpenId(class.%Id()_"||"_mappingName)
    THROW:(xData = "") ##Class(%Exception.General).%New("Mapping not found", $$$NOTFOUND)
    Set reader = ##class(%XML.Reader).%New()
    Try{
        $$$ThrowOnError(reader.OpenStream(xData.Data))
    }Catch e {
        THROW ##Class(%Exception.General).%New("Failed to open stream for mapping: "_e.DisplayString())
    }
    ///This class will be used to extract the different possible properties
    Do reader.Correlate("Property", "RESTUtils.Resolver.ClassInfo.Helper.XDataClassInfoHelper")
    
    //Iterate
    While reader.Next(.prop,.sc) {
        ///Check the object didn't fail importing
        Try{$$$ThrowOnError(sc)}Catch e {THROW ##Class(%Exception.General).%New("Failed to import properties from mapping: "_e.DisplayString())}
        Try{
            #DIM prop As RESTUtils.Resolver.ClassInfo.Helper.XDataClassInfoHelper
            Set propType = ##Class(%Dictionary.CompiledProperty).%OpenId(class.%Id()_"||"_prop.Name)
            Set propTypeClass = ##Class(%Dictionary.CompiledClass).%OpenId(propType.RuntimeType)
        }Catch e {
            THROW ##Class(%Exception.General).%New("Failed to find property for class: "_e.DisplayString())
        }
        Set propName = prop.Name
        Set:(prop.FieldName '= "") propName = prop.FieldName
        Do ..SetValueToResult(.result, propName, prop.Include, prop.Reference, propTypeClass, propType.Identity, referenceDepth)
        
    }
    Return result
}

/// TODO this should be moved to a resolver since it is logic
ClassMethod SetValueToResult(ByRef result, propName As %String(MAXLEN=""), include As %String(MAXLEN=""), referenceType As %String(MAXLEN=""), propTypeClass As %String(MAXLEN=""), isIdentity As %Boolean, referenceDepth As %Numeric)
{
    Set:($GET(result) = "") result = {"in":{}, "out":{}, "both":{}}
    Set externalType = ..TypeToExternal(propTypeClass, isIdentity, referenceDepth - 1, .isInDepthReference)
    If ((isInDepthReference) && (referenceType '= "ID")){
        Set propValue = ..ExtractClassProperties(propTypeClass, referenceDepth -1)
        Do:(..IncludeProp(include, "IN")) result.in.%Set(propName, propValue.in)
        Do:(..IncludeProp(include, "OUT")) result.out.%Set(propName, propValue.out)
        Do:(..IncludeProp(include, "BOTH")) result.both.%Set(propName, propValue.both)
    }else{
        Do:(..IncludeProp(include, "IN")) result.in.%Set(propName, externalType)
        Do:(..IncludeProp(include, "OUT")) result.out.%Set(propName, externalType)
        Do:(..IncludeProp(include, "BOTH")) result.both.%Set(propName, externalType)
    }
    Do result.out.%Set("Id", "VARCHAR")
    Return result
}

ClassMethod TypeToExternal(type As %Dictionary.CompiledClass, isIdentity As %Boolean, referenceDepth As %Numeric = 0, Output isInDepthReference As %Boolean = 0)
{
    $$$SwapToInstallationNamespace
    Return $$$ToExternalType(type, isIdentity, referenceDepth, .isInDepthReference)
}

ClassMethod IncludeProp(JSONInclude As %String(VALUELIST=",,INOUT,INPUTONLY,OUTPUTONLY,NONE"), type As %String(VALUELIST=",IN,OUT,BOTH")) As %Boolean
{
    Return:((JSONInclude = "INOUT") || (JSONInclude = "")) 1
    Return:(JSONInclude = "NONE") 0
    Return (((JSONInclude = "INPUTONLY") && (type = "IN")) || ((JSONInclude = "OUTPUTONLY") && (type = "OUT")))
    Return 0
}

}
