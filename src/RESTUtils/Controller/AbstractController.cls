Include (RESTUtils.INC.Status, RESTUtils.INC.OptionsKeys, RESTUtils.INC.Authorization, RESTUtils.INC.Log, RESTUtils.INC.Content.Import, RESTUtils.INC.Utils, RESTUtils.INC.Language.Errors, RESTUtils.INC.Language.Warning)

Class RESTUtils.Controller.AbstractController Extends %CSP.REST
{

// Overrides of the %CSP.REST

ClassMethod OnPreDispatch(pUrl As %String(MAXLEN=""), pMethod As %String(MAXLEN=""), ByRef pContinue As %Boolean) As %Status
{
    ///By default we let it through
    Set pContinue = 1

    //Get parameters
    Try{
    Do ..GetParameters(.options, $$$OPCLASS)
    }Catch e {
        Do ..HandleException(e)
        Set pContinue = 0
        Return $$$OK
    }
    Set class = $GET(options($$$OPCLASS))
    
    ///If no class is provided we cannot check auth, we let the endpoint determine what to do
    Return:(class="") $$$OK
    
    ///Check
    If ('$$$UserIsAllowed(class, pUrl)){
        Set %response.Status = (-$$$FORBIDDEN)
        Set pContinue = 0
    }
    Return $$$OK
}

ClassMethod OnHandleCorsRequest(url As %String(MAXLEN="")) As %Status
{
    Set origin = $PIECE(%request.GetCgiEnv("HTTP_REFERER"),"/",1,3)
    Do %response.SetHeader("Access-Control-Allow-Methods","GET,POST,PUT,DELETE,OPTIONS")
	Do %response.SetHeader("Access-Control-Allow-Credentials","true")
    ///TODO this should be moved to a config global
	Do %response.SetHeader("Access-Control-Allow-Origin",origin)
	Do %response.SetHeader("Access-Control-Allow-Headers","Access-Control-Allow-Origin, Origin, X-Requested-With, Content-Type, Accept, Authorization, Cache-Control, Credentials")
	Do %response.SetHeader("Accept-CH", "Sec-CH-UA, Sec-CH-UA-Platform, Sec-CH-UA-Mobile")
    Quit $$$OK
}

Parameter CONTENTTYPE = "application/json";

Parameter CHARSET = "UTF-8";

Parameter UseSession As Integer = 1;

Parameter CONVERTINPUTSTREAM = 1;

Parameter HandleCorsRequest = 1;

/// Ensures the REST output is not transformed, useful for putting out binary, for example.
ClassMethod ClearCharset()
{
    Set %response.CharSet = ""
    Set %response.NoCharSetConvert = 1
}

// End overrides

// Body utils

// Body utils in

ClassMethod GetJSONRequestBody() As %DynamicObject
{
    Return $$$ImportContent(%request.Content, "JSON")
}

// Body utils out

ClassMethod PrintSearchResultToJSON(result As %DynamicArray, total As %Numeric = "", query As %String(MAXLEN="") = "", replaced As %String(MAXLEN="") = "", columns As %String(MAXLEN="") = "", ByRef options = "")
{
    Set obj = {}
    Set:(total '= "") obj.total = total
    Set:((columns '= "") && ($GET(options($$$INCLUDECOLUMNTYPES)) '= "")) obj.columns = columns
    If ($$$IsDev){
        Set:(query '= "") obj.query = query
        Set:(replaced '= "") obj.replaced = replaced
    }
    Set obj.result = result
    Do ..PrintJSON(obj, .options)
}

ClassMethod PrintResourceToJSON(resource As %DynamicObject, ByRef options = "")
{
    Set result = {"resource":(resource)}
    Do ..PrintJSON(result, .options)
}

ClassMethod PrintJSON(obj As %DynamicAbstractObject, ByRef options = "")
{
    Set %response.ContentType = "application/json"
    Do ..AddWarnings(.obj, .options)
    Do obj.%ToJSON(.str)
}

/// String or Stream
ClassMethod PrintHTML(str As %String(MAXLEN=""))
{
    Set %response.ContentType = "text/html"
    try{
        If (str.%IsA("%Stream.Object")){
            While('str.AtEnd){
                Write str.Read()
            }
        }Else{
            THROW $$$InvalidElementForPrint
        }
    }Catch e {
        Write str
    }
}

ClassMethod AddWarnings(ByRef obj As %DynamicAbstractObject, ByRef options = "")
{
    If (obj.%IsA("%Library.DynamicObject")){
        Set warnings = $GET(options($$$OUTWARN), "")
        Set:(warnings '= "") obj.warnings = [].%FromJSON("["""_$LISTTOSTRING(warnings, """,""")_"""]")
    }
}

/// TODO maybe should be binary stream?
ClassMethod PrintExcel(data As %String(MAXLEN=""))
{
    ///Add headers for download         
    Set %response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    Do %response.SetHeader("Content-Disposition", "attachment; filename=""export.xlsx""")
    ///Really important the following two headers to avoid conversion for charset of any type
    Do ..ClearCharset()
    Write data
}

// Exception utils

/// All exceptions should be allowed to bubble up until the controller where they should be redirected here
ClassMethod HandleException(e As %Exception.AbstractException)
{
    Set %response.Status = ..#HTTP500INTERNALSERVERERROR
    If ($$$IsHandled(e)){
        Set %response.Status = -e.Code
        Set message = e.Name
    }ElseIf ($$$IsDev){
        Set message = e.DisplayString()
    }Else{
        Set message = "Error"
    }
    If (%response.ContentType = "application/json"){
        Write {"error":(message)}.%ToJSON()
    }Else{
        Write message
    }
}

// Options 

/// Pass a variable byref that will be a subscripted variable with the parameters.
/// Then pass each parameter name as the variable args, can provide a default value for
/// each via name|defaultValue
/// If the subscripted variable options already contains any of the parameters it won't be changed
ClassMethod GetParameters(ByRef options, parameterNames...)
{
    Set parameterNames = $GET(parameterNames, 0)
    while(parameterNames > 0){
        Set param = parameterNames(parameterNames)
        Set paramName = $PIECE(param, "|", 1)
        Set value = $GET(%request.Data(paramName, 1), $PIECE(param, "|", 2))
        If (value = ""){
            Set upperName = paramName
            Set $EXTRACT(upperName, 1, 1) = $ZCONVERT($EXTRACT(upperName, 1, 1), "U")
            Set value = $GET(%request.Data(upperName, 1))
        }
        Do:(value '= "") ..SetIfNull(.options, paramName, value)
        Set parameterNames = parameterNames - 1
    }
    Do ..CheckParameters(.options)
}

/// TODO this is the proper way for all parameters
ClassMethod GetOptions(ByRef options, bodyType As %String(VALUELIST=",,JSON") = "JSON", parameters...)
{
    Set body = ""
    Set:(bodyType="JSON") body = ..GetJSONRequestBody()
    Do ..JSONBodyToOptions(.options, body)
    Do ..GetParameters(.options, parameters...)
    Do ..CheckParameters(.options)
}

ClassMethod CheckParameters(ByRef options)
{
    Set errorList = ""
    If ($GET(options($$$OPCLASS)) '= ""){
        ///Check class exists
        THROW:($$$ClassExists($GET(options($$$OPCLASS)), $GET(options($$$OPNAMESPACE), $NAMESPACE), "", .extendsAdaptor ) = 0) $$$ClassNotFound
        ///Check class extends adaptor
        THROW:((%request.ContentType = "application/json") && (extendsAdaptor = "NO")) $$$ClassDoesNotExtendAdaptor
        ///Add warn if the class does not extend the custom adaptor
        Do:(extendsAdaptor = "ADAPTOR") $$$WarnClassExtendingAdaptor(.options)
        Set options($$$INTEXTENDSADAPTOR) = extendsAdaptor
    }
}

/// Passes all obtainable properties from the JSON body to the options
ClassMethod JSONBodyToOptions(ByRef options, body As %DynamicObject = "")
{
    ///TODO recheck
    Return:(body = "")

    Set class = body.%Get($$$OPCLASS)
    Do:(class '= "") ..SetIfNull(.options, $$$OPCLASS, class)

    Set namespace = body.%Get($$$OPNAMESPACE)
    Do:(namespace '= "") ..SetIfNull(.options, $$$OPNAMESPACE, namespace)

    Set groupBy = body.%Get($$$OPGROUPBY)
    Set:(groupBy = "") groupBy = body.%Get($$$OPGROUPBODY)
    Set:(groupBy = "") groupBy = body.%Get($$$BODYGROUPBYCLAUSE)
    Do:(groupBy '= "") ..SetIfNull(.options, $$$OPGROUPBY, groupBy)

    Set select = body.%Get($$$OPSELECT)
    Set:(select = "") select = body.%Get($$$BODYSELECTCLAUSE)
    Do:(select '= "") ..SetIfNull(.options, $$$OPSELECT, select)

    Set exportType = body.%Get($$$OPEXPORTTYPE)
    Do:(exportType '= "") ..SetIfNull(.options, $$$OPEXPORTTYPE, exportType)

    Set JSONMappingName = body.%Get($$$OPJSONMAPPINGNAME)
    Do:(JSONMappingName '= "") ..SetIfNull(.options, $$$OPJSONMAPPINGNAME, JSONMappingName)

    Set order = body.%Get($$$OPORDER)
    Set:(order = "") order = body.%Get($$$OPORDERBY)
    Do:(order '= "") ..SetIfNull(.options, $$$OPORDER, order)

    Set filter = body.%Get($$$OPFILTER)
    Do:(filter '= "") ..SetIfNull(.options, $$$OPFILTER, filter)

    Set filter = body.%Get($$$OPPAGE)
    Do:(filter '= "") ..SetIfNull(.options, $$$OPPAGE, filter)

    Set filter = body.%Get($$$OPSIZE)
    Do:(filter '= "") ..SetIfNull(.options, $$$OPSIZE, filter)

    Set filter = body.%Get($$$OPEXPORTTYPE)
    Do:(filter '= "") ..SetIfNull(.options, $$$OPEXPORTTYPE, filter)

    Set structure = body.%Get($$$OPCUSTOMEXPORTBODY)
    Do:(structure '= "") ..SetIfNull(.options, $$$OPCUSTOMEXPORTBODY, structure)
}

/// All options should be set with this, this allows to block options when inheriting the RESTController
ClassMethod SetIfNull(ByRef options, key, val)
{
    Set:($GET(options(key)) = "") options(key) = val
}

// Logging

/// After executting the endpoint
ClassMethod PostDispatch(action = "", id = "", body = "", ByRef options) [ Final, Internal, Private ]
{
    Do $$$Log(.options, action)
}

ClassMethod StartTime(ByRef options)
{
    Set options($$$INTTIMESTART) = $ZHOROLOG
}

ClassMethod Login(skipheader As %Boolean = 1) As %Status [ ProcedureBlock = 0 ]
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim tMatchURL As %String
    $$$SysLog(3,"OAuth2","[%CSP.REST]","Login: %request.Method="_%request.Method)
           
    Try {
        
        #; Don't want the session token
        Set %response.OutputSessionToken=0
        
        #; Also set language to prevent any attempt to call %response.MatchLanguage as this can cause PROTECT errors reading from ^IRIS.Msg global
        If %response.Language="" Set %response.Language="en"
        
        Set tMatchURL=$Extract(%request.URL,$Length(%request.Application),*)
      
        #; Process CORS request
        #; Call DispatchMap() to read the endpoint-specific settings
        Set route = ..DispatchMap(tMatchURL,%request.Method,.verbsMatched,.args)
        set className = $listget(route,3,$classname()) , requireCors = $listget(route,4,"") , newURL = $listget(route,5,"")
        Set tSC = $classmethod(className,"ProcessCorsRequest",newURL,requireCors)
        If $$$ISERR(tSC) Quit
            
        If %request.Method="OPTIONS" {
            
            #; We want to allow OPTIONS requests even if not authorized
            Set tSC=..OnHandleOptionsRequest(tMatchURL)
            If $$$ISERR(tSC) Quit
         
        } else {
            
            #; Set the Http Status
            Set %response.Status=..#HTTP401UNAUTHORIZED
            
            #; By default we want Basic authentication
            Do %response.SetHeader("WWW-Authenticate",..GetAuthChallenge())
        }
        
    } Catch (e) {
        #; Login should always return 401 error on failure. 
        Set %response.Status=..#HTTP401UNAUTHORIZED
        #; Login needs to return $$$OK for the response to be sent. 
        #; Returning an error will result in 401 responses being lost.
        Set tSC=$$$OK
        #; Real error is logged for debugging.
        $$$SysLog(3,"Login","[%CSP.REST]","Error "_e.DisplayString())
        
    }
    
    #; We need to manually write out the headers here because PAGE has not been called
    Do %response.WriteHTTPHeader()
        
    #; Done
    Quit tSC
}

}
