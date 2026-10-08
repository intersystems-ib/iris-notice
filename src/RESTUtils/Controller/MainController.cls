Include (RESTUtils.INC.Search, RESTUtils.INC.OptionsKeys, RESTUtils.INC.Content.Export, RESTUtils.INC.Utils, RESTUtils.INC.ClassInfo, RESTUtils.INC.Help, RESTUtils.INC.Language.Errors)

Class RESTUtils.Controller.MainController Extends RESTUtils.Controller.AbstractController
{

/// TODO check out %response.OutputSessionToken
/// TODO check out AccessCheck
/// TODO check out %response.IgnoreRESTOutput
XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <!--TODO: Add option for multiclass handling-->
    <!--TODO: Conditional update/delete-->
    <!--TODO: Bulk operations-->
    <Route Url="/" Method="GET" Call="GetHtmlHelpPage"/>

    <!--Check out what the user is allowed to access -->
    <Route Url="/auth/allowed" Method="GET" Call="AllAllowed" />

    <!--Get info about a class-->
    <Route Url="/info/:namespace/:class" Method="GET" Call="ClassInfo" />

    <!--Search-->
    <Route Url="/search" Method="POST" Call="Search"/>
    <Route Url="/search/:namespace/:class" Method="POST" Call="SearchClass"/>

    <!--Get by Id/Index-->
    <Route Url="/get/:namespace/:class/:identifier" Method="GET" Call="GetClassElementByIdOrIndex"/>
    <Route Url="/get/:identifier" Method="GET" Call="GetByIdOrIndex"/>

    <!--TODO implement-->
    <!--<Route Url="/bulk" Method="POST" Call="BulkOperation" />-->

    <!--General modification controller-->
    <Map Prefix="/edit" Forward="RESTUtils.Controller.ModifyController"/>

    <!--Help-->
    <Route Url="/help" Method="GET" Call="Help"/>
    <Route Url="/help(/[a-z]{0,20}(/[a-z]{0,20}){0,2})/?" Method="GET" Call="Help"/>
    <Route Url="/v" Method="GET" Call="Help"/>
    <Route Url="/version" Method="GET" Call="Help"/>
    <Route Url="/h" Method="GET" Call="Help"/>
    <!--<Route Url="/example/:namespace/:class/graph" Method="GET" Call="GetGraphExample"/>-->


    <!--Logout used to end the session and revoke the token-->
    <Route Url="/logmeout" Method="GET" Call="Logout"/>
</Routes>
}

// Auth

ClassMethod AllAllowed() As %Status
{
    Try{
        Do ..StartTime(.options)
        Do ..PrintJSON($$$GetEverythingUserIsAllowed)
    }Catch e {
        Do ..HandleException(e)
    }
    Do ..PostDispatch("ALLOWED",,, .options)
    Return $$$OK
}

// Class info

ClassMethod ClassInfo(namespace As %String(MAXLEN=""), class As %String(MAXLEN="")) As %Status
{
    Try{
        Do ..StartTime(.options)
        ///Check options
        Throw:(class = "") $$$ClassNotFound
        Throw:(namespace = "") $$$NamespaceNotFound

        ///TODO change to optionsKeys
        Do ..GetParameters(.options, $$$ClassInfoEndpointParamters)
        ///Get resultingObject
        Set result = {
            "uniqueValues":($$$GetClassInfo(class, namespace)),
            "columns":($$$GetColumnsFromJSONMapping(class, namespace, $GET(options($$$OPJSONMAPPINGNAME))))
        }
        Do ..PrintJSON(result)
    }Catch e {
        Do ..HandleException(e)
    }
    Do ..PostDispatch("INFO", , , .options)
    Return $$$OK
}

// Search

ClassMethod SearchClass(namespace As %String(MAXLEN=""), class As %String(MAXLEN=""), ByRef options = "") As %Status
{
    Set options($$$OPNAMESPACE) = namespace
    Set options($$$OPCLASS) = class
    Return ..Search(.options)
}

ClassMethod Search(ByRef options = "") As %Status
{
    Try{
        Set body = ""
        Do ..StartTime(.options)
        ///Get body and parameters
        Do ..GetOptions(.options, "JSON", $$$SearchEndpointParameters)
        Set class = $GET(options($$$OPCLASS))
        Set body = $GET(options($$$OPFILTER), {})
        //Search
        Set result = $$$SearchClassMethod(class, body, .total, .query, .replaced, .options)
        Set columns = $GET(options($$$OUTCOLUMNTYPES))
        //Print
        If (options($$$OPEXPORTTYPE) = $$$ExportToExcel){
            Do ..PrintExcel(result)
        }Else{
            Do ..PrintSearchResultToJSON(result, total, query, replaced, columns, .options)
        }
    }Catch e {
        Do ..HandleException(e)
    }
    Do ..PostDispatch("SEARCH", , body, .options)
    Return $$$OK
}

ClassMethod GetClassElementByIdOrIndex(namespace As %String(MAXLEN=""), class As %String(MAXLEN=""), identifier As %String(MAXLEN=""), ByRef options = "") As %Status
{
    Set options($$$OPNAMESPACE) = namespace
    Set options($$$OPCLASS) = class
    Return ..GetByIdOrIndex(identifier, .options)
}

ClassMethod GetByIdOrIndex(identifier As %String(MAXLEN=""), ByRef options = "") As %Status
{
    Try{
        Do ..StartTime(.options)
        Set id = ""
        ///Get parameters
        Set options($$$OPIDENTIFIER) = identifier
        Do ..GetOptions(.options, , $$$GetEndpointParameters)
        Set class = $GET(options($$$OPCLASS))

        ///Export object
        Set obj = $$$GetByIdOrIndex(class, identifier, .options)
        THROW:(obj = "") ##Class(%Exception.General).%New("Not found", $$$NOTFOUND)
        ///Print
        Do ..PrintResourceToJSON($$$ExportSingleObjectToJSON(class, obj.%Id(), .options), .options)
        Set id = obj.%Id()
    }Catch e {
        Do ..HandleException(e)
    }
    Do ..PostDispatch("GET_RESOURCE", id,, .options)
    Return $$$OK
}

ClassMethod BulkOperation() As %Status
{
    Set %response.Status = 404
    Return $$$OK
}

ClassMethod Help(ignored...) As %Status
{
    Try{
        Do ..StartTime(.options)
        D ..PrintJSON($$$GetHelp(%request.URL))
    }Catch e {
        Do ..HandleException(e)
    }
    Do ..PostDispatch("HELP",,, .options)
    Return $$$OK
}

ClassMethod GetHtmlHelpPage() As %Status
{
    Try{
        Do ..StartTime(.options)
        D ..PrintHTML($$$GetHelpPage)
    }Catch e {
        Do ..HandleException(e)
    }
    Do ..PostDispatch("HELP_PAGE",,, .options)
    Return $$$OK
}

ClassMethod GetGraphExample(namespace As %String(MAXLEN=""), class As %String(MAXLEN=""))
{
    Try{
        Do ..PrintHTML(##class(RESTUtils.Util.Examples).GraphGenerator(namespace, class))
    }Catch e {
        Do ..HandleException(e)
    }
    Do ..PostDispatch("EXAMPLE_GRAPH",,, .options)
    Return $$$OK
}

}
