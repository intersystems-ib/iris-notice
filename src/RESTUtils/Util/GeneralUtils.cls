Include (RESTUtils.INC.OptionsKeys, RESTUtils.INC.Status, RESTUtils.INC.Utils, RESTUtils.INC.Language.Errors)

Class RESTUtils.Util.GeneralUtils
{

ClassMethod ExecQuery(query As %String(MAXLEN=""), namespace As %String(MAXLEN=""), args...) As %SQL.Statement
{
    $$$SwapNamespace(namespace)
    Set qres = ##Class(%SQL.Statement).%ExecDirect(, query, args...)
    Do:(qres.%SQLCODE < 0) ..HandleQueryError(qres.%SQLCODE, qres.%Message)
    Return qres
}

ClassMethod HandleQueryError(code As %Numeric, msg As %String(MAXLEN=""))
{
    If ($LISTFIND($$$HandledSQLCodes, code)){
        THROW:(code = -99) $$$ForbiddenSQL
        THROW $$$BadRequestSQL(code, msg)
    }
    THROW $$$UnhandledSQL(code, msg)
}

/// TODO maybe move to an instance service?
ClassMethod GetByIdOrIndex(class As %String(MAXLEN=""), identifier As %String(MAXLEN=""), ByRef options = "") As %JSON.Adaptor
{
    $$$SwapNamespace(options)
    THROW:(..ClassExists(class, $NAMESPACE) = 0) $$$ClassNotFound
    Set uniqueIndex = $GET(options($$$OPUNIQUEINDEX))
    If (uniqueIndex '= ""){
        Set obj = ..OpenByIndex(class, uniqueIndex, identifier)
    }Else{
        Set obj = $CLASSMETHOD(class, "%OpenId", identifier)
    }
    Return obj
}

/// TODO maybe move to an instance service?
ClassMethod OpenByIndex(class As %String(MAXLEN=""), uniqueIndex As %String(MAXLEN=""), identifier As %String(MAXLEN="")) As %JSON.Adaptor
{
    Try{
        Return $CLASSMETHOD(class, uniqueIndex_"Open", identifier)
    }Catch e {
        Try{
            Set qres = ..ExecQuery(..#FindUniqueIndexFromPropQuery, $NAMESPACE, class, uniqueIndex)
            Do qres.%Next()
            Return $CLASSMETHOD(class, qres.Name_"Open", identifier)
        }Catch e {
        }
    }
    THROW $$$IndexNotFound
}

/// Finds a unique index given a property, TODO this ought to be changed to a global for faster access
Parameter FindUniqueIndexFromPropQuery = {"select Name Name from %Dictionary.CompiledIndex "_
    "where parent = ? "_
    "and Properties = ? "_
    "and _Unique = 1"};

/// TODO this ought to be changed to a global for faster access
ClassMethod ClassExists(class As %String(MAXLEN=""), namespace As %String(MAXLEN="") = "", Output classInstance As %Dictionary.CompiledClass, Output extendsAdaptor As %String(VALUELIST=",NO,ADAPTOR,RESTUTILS") = "NO") As %Boolean
{
    $$$SwapNamespace(namespace)
    Set classInstance = ##Class(%Dictionary.CompiledClass).%OpenId(class)
    If (..ExistsClassInGlobal(class)){
        Do ..ClassExtendsAdaptorInGlobal(class, .classExtendsAdaptor, .classExtendsUtilsAdaptor)
        If (classExtendsUtilsAdaptor){
            Set extendsAdaptor = "RESTUTILS"
        }
        ElseIf (classExtendsAdaptor){
            Set extendsAdaptor = "ADAPTOR"
        }
        Return 1
    }
    Return 0
}

/// TODO check if this is used
ClassMethod ResolveExtendsAdaptor(class As %Dictionary.CompiledClass) As %String(VALUELIST=",NO,ADAPTOR,RESTUTILS")
{
    Set key = ""
    Set result = "NO"
    FOR{
        Set method = class.Methods.GetNext(.key)
        #DIM method As %Dictionary.CompiledMethod
        quit:((key = "") && (method = ""))
        Return:(method.Origin = $$$JSONIMPRESTUtils) "RESTUTILS"
        Set:(method.Origin = $$$JSONAdaptorClass) result = "ADAPTOR"
    }
    Return result
}

ClassMethod GetTable(class As %String(MAXLEN=""), namespace As %String(MAXLEN="") = "") As %String(MAXLEN="")
{
    $$$SwapNamespace(namespace)
    Set table = ..GetClassTableInGlobal(class)
    THROW:(table = "") $$$TableNotFound
    Return table
}

ClassMethod AddWarning(ByRef options, msg As %String(MAXLEN=""))
{
    Set list = $GET(options($$$OUTWARN), "")
    Set:($LISTFIND(list, msg) = 0) options($$$OUTWARN) = $LISTUPDATE(list, $LISTLENGTH(list) + 1, msg)
}

// Globals

// TODO check if this can be accessed by a regular user, if not permissions should be added as needed

ClassMethod ExistsClassInGlobal(class As %String(MAXLEN="")) As %Boolean [ Final, Internal, Private ]
{
    Return $ORDER(^oddCOM(class, "")) '= ""
}

ClassMethod GetClassTableInGlobal(class As %String(MAXLEN="")) As %String(MAXLEN="") [ Final, Internal, Private ]
{
    Return $GET(^oddCOM(class, 53))
}

/// TODO, this checks the class but it has been known to provide wrong results, where it indicates it does extend adaptor, 
/// yet the generated methods do not use the custom adaptor instead using the default
ClassMethod ClassExtendsAdaptorInGlobal(class As %String(MAXLEN=""), Output extendsAdaptor As %Boolean = 0, Output extendsUtilsAdaptor As %Boolean = 0) [ Final, Internal, Private ]
{
    ///We use the PropertyClasses since they are more consitent than superclasses. Superclasses need to be resolved, since
    /// although the class might not extend directly %JSON.Adaptor a superclass of the given class might.
    Set propertyParameterList = $LISTFROMSTRING($GET(^oddCOM(class, 48)))
    Set extendsUtilsAdaptor = $LISTFIND(propertyParameterList, "RESTUtils.JSON.PropertyParameters") '= 0
    Set extendsAdaptor = $LISTFIND(propertyParameterList, "%JSON.PropertyParameters") '= 0
}

}
