Include RESTUtils.INC.Utils

/// TODO roles/permissions should be given when attempting to log, else it might fail for some users
Class RESTUtils.Service.Log.LogService
{

ClassMethod CollectAndLog(ByRef options = "", action As %String(MAXLEN="") = "")
{
    Try {
        ///Fallback in case the package is mapped
        Set:($GET(options($$$OPNAMESPACE)) = "") options($$$OPNAMESPACE)= $NAMESPACE
        $$$SwapToInstallationNamespace
        Set info = ..BundleInfo(.options, action)
        $$$ThrowOnError(info.%Save(0))
        Do ..StopTime(.options)
        JOB ..Log(info.%Id())
    }Catch e {
        Do ..InternalLog("Error when creating log: " _ e.DisplayString(), "ERROR")
    }
}

ClassMethod BundleInfo(ByRef options, action As %String(MAXLEN="") = "") As RESTUtils.Service.Log.Helper.LogInfo
{
    Set info = ##Class(RESTUtils.Service.Log.Helper.LogInfo).%New()
    Set info.Application = %request.AppMatch
    Set info.IsSecure = %request.Secure
    Set info.Method = %request.Method
    Set info.Endpoint = $PIECE(%request.URL, info.Application, 2)
    
    ///Content
    Set info.RequestContentType = %request.ContentType
    Set info.ResponseContentType = %response.ContentType
    Do ..GetRequestContent(.info)
    Do ..GetOptions(.info, .options)
    Set info.ResponseStatus = %response.Status
    Set info.Action = action
    
    ///user agent and high entropy
    Do ..GetAgentInfo(.info)
    Return info
}

ClassMethod StopTime(ByRef options)
{
    Set options($$$INTTIMEEND) = $ZHOROLOG
}

ClassMethod Log(infoID As %String(MAXLEN=""))
{
    Try{
        Do ..OpenLogObjects(infoID, .info, .logDefinition)
        ///TODO this should be a warning with a max limit per day
        THROW:(logDefinition = "") ##Class(%Exception.General).%New("Failed to match any log definitions Namespace: "_ info.Namespace _ "   App: "_info.Application)
        Do ..LogToLogDefinition(logDefinition, info)
    }Catch e {
        Do ..InternalLog("Failure calling log: " _ e.DisplayString(), "ERROR")
    }
    If (info '= ""){
        $$$SwapToInstallationNamespace
        Do info.%DeleteId(info.%Id())
    }
}

ClassMethod OpenLogObjects(infoID As %String(MAXLEN=""), Output info As RESTUtils.Service.Log.Helper.LogInfo, Output logDefinition As RESTUtils.Persistent.Log.LogDefinition)
{
    $$$SwapToInstallationNamespace
    Set info = ##Class(RESTUtils.Service.Log.Helper.LogInfo).%OpenId(infoID)
    THROW:(info = "") ##Class(%Exception.General).%New("Failed to open the information object!!!!")
    ///Use the app log, if not found use namespace wide
    Set logDefinition = ##Class(RESTUtils.Persistent.Log.LogDefinition).UIXNamespaceApplicationOpen(info.Namespace, info.Application)
    Set:(logDefinition = "") logDefinition = ##Class(RESTUtils.Persistent.Log.LogDefinition).UIXNamespaceApplicationOpen(info.Namespace, "")
}

ClassMethod LogToLogDefinition(logDefinition As RESTUtils.Persistent.Log.LogDefinition, logInfo As RESTUtils.Service.Log.Helper.LogInfo)
{
    Try{
        Set namespace = logDefinition.Namespace
        $$$SwapToInstallationNamespace
        Do $CLASSMETHOD(logDefinition.Class, logDefinition.Method, logInfo)
        $$$ThrowOnError(logInfo.%DeleteId(logInfo.%Id()))
    }Catch e {
        Do ..InternalLog("Failure logging: " _ e.DisplayString(), "ERROR")
    }
}

ClassMethod InternalLog(msg As %String(MAXLEN=""), level As %String(VALUELIST=",INFO,WARN,ERROR"))
{
    $$$SwapToInstallationNamespace
    Set log = $CLASSMETHOD($$$LogPersistant, "%New")
    Set log.Msg = msg
    Set log.Level = level
    $$$ThrowOnError(log.%Save())
}

ClassMethod GetRequestContent(ByRef info As RESTUtils.Service.Log.Helper.LogInfo)
{
    Set info.RequestContent = ##Class(%Stream.GlobalCharacter).%New()
    Set cStream = %request.Content
    Return:(cStream = "")
    Do cStream.Rewind()
    while('cStream.AtEnd){
        Do info.RequestContent.Write(cStream.Read())
    }
}

ClassMethod GetOptions(ByRef info As RESTUtils.Service.Log.Helper.LogInfo, ByRef options)
{
    Set k = ""
    FOR{
        Set k = $ORDER(options(k))
        quit:(k="")
        Do info.OptionsAsJSON.%Set(k, options(k))
    }
    Set info.Namespace = $GET(options($$$OPNAMESPACE), $NAMESPACE)
    Set info.Identifier = $GET(options($$$OPIDENTIFIER))
}

ClassMethod GetAgentInfo(ByRef info As RESTUtils.Service.Log.Helper.LogInfo)
{
    ///Preferably use HighEntropy values else UserAgent as a fallback
    Set info.UserAgent = %request.UserAgent
    Try{
        Do ..ParseHighEntropyValues(.isMobile, .os, .browser)
    }Catch e {
        Do ..InternalLog("Parsing of HighEntropyValues data failed: " _ e.DisplayString() _ " Headers: mobile: " _ $GET(%request.CgiEnvs("HTTP_SEC_CH_UA_MOBILE")) _ " OD: " _  $GET(%request.CgiEnvs("HTTP_SEC_CH_UA_PLATFORM"))_" Browser: " _ $GET(%request.CgiEnvs("HTTP_SEC_CH_UA")), "WARN")
    }
    
    If (browser '= ""){
        Set info.IsMobile = isMobile
        Set info.OS = os
        Set info.Browser = browser
    }Else{
        Try {
            Do ..ParseUserAgentHeader(.os, .browser)
        } Catch e {
            Do ..InternalLog("Parsing of UserAgent data failed: " _ e.DisplayString() _ " Headers: " _ %request.UserAgent, "WARN")
            Return
        }
        Set info.OS = os
        Set info.Browser = browser
    }
}

ClassMethod ParseHighEntropyValues(Output isMobile As %Boolean = "", Output os As %String(MAXLEN="") = "", Output browser As %String(MAXLEN="") = "")
{
    Set:($GET(%request.CgiEnvs("HTTP_SEC_CH_UA_MOBILE")) '= "") isMobile = $GET(%request.CgiEnvs("HTTP_SEC_CH_UA_MOBILE")) '= "?0"
    Set:($GET(%request.CgiEnvs("HTTP_SEC_CH_UA_PLATFORM")) '= "") os = $REPLACE($GET(%request.CgiEnvs("HTTP_SEC_CH_UA_PLATFORM")), """", "")
    IF ($GET(%request.CgiEnvs("HTTP_SEC_CH_UA")) '= ""){
        Set browserList = $LISTFROMSTRING($GET(%request.CgiEnvs("HTTP_SEC_CH_UA")))
        Set pbrowserList = $LISTFROMSTRING(..#HighEntropyBrowserList)
        Set ptr = 0
        while($LISTNEXT(browserList , ptr, possibleBrowser)){
            Set browPtr = 0
            while($LISTNEXT(pbrowserList, browPtr, brw)){
                If (brw = $PIECE(possibleBrowser, """", 2, 2)){
                    Set browser = brw
                    Return
                }
            }
        }
    }
}

Parameter HighEntropyBrowserList = "Microsoft Edge,Google Chrome,Chromium,Opera,Brave,Vivaldi,Arc";

ClassMethod ParseUserAgentHeader(Output os As %String(MAXLEN=""), Output browser As %String(MAXLEN=""))
{
    Set userAgent = $GET(%request.CgiEnvs("HTTP_USER_AGENT"))
    If (userAgent){
        Set osList = $LISTFROMSTRING(..#UserAgentOS)
        Set ptr = 0
        while($LISTNEXT(osList, ptr, pOS)){
            Set:(userAgent [ pOS ) os = pOS
            quit
        }
        Set browserList = $LISTFROMSTRING(..#UserAgentBrowsers)
        Set ptr = 0
        while($LISTNEXT(browserList, ptr, pBroswer)){
            Set:(userAgent [ $PIECE(pBroswer, ":", 1) ) browser = $PIECE(pBroswer, ":", 2) 
            quit
        }

    }
}

Parameter UserAgentOS = "iPhone,iPad,Android,Windows,macOS,CrOS,Linux";

Parameter UserAgentBrowsers = "Edg:Microsoft Edge,OPR:Opera,Brave:Brave,Vivaldi:Vivaldi,Arc:Arc,Chrome:Google Chrome,Chromium:Chromium,Firefox:Firefox,Safari:Safari";

}
