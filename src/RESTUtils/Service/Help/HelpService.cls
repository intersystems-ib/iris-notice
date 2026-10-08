Include (RESTUtils.INC.Language.Errors, RESTUtils.INC.OptionsKeys, RESTUtils.INC.Help)

Class RESTUtils.Service.Help.HelpService
{

ClassMethod GetAvailableEndpoints() As %DynamicArray
{
    Return [
    "info",
    "get",
    "search",
    "create",
    "update",
    "delete"
  ]
}

ClassMethod GetHelp(endpoint As %String(MAXLEN=""), displayVersion As %Boolean = 1) As %DynamicObject
{
    Set result = {}
    Set:(displayVersion) result.version = $$$Version
    Set url = $PIECE(endpoint, "/", *, *)
    Set twoPartUrl = $PIECE(endpoint, "/", *-1, *)
    If (url = "all"){
        Set endpoints = ..GetAvailableEndpoints()
        Set iter = endpoints.%GetIterator()
        while(iter.%GetNext("", .name)){
            D result.%Set(name, ..GetHelp(name, 0))
        }
    }ElseIf (url = "get"){
        Set result.description = "Returns an object, if found, of the class opened by either id or an index"
        Set result.requirements = "The class must extend %Persistent and %JSON.Adaptor or RESTUtils.JSON.Adaptor."
        Set result.method = "GET"
        Set result.path = "/get/{{namespace}}/{{class}}/{{identifier}}"
        Set result.parameters = $$$GetParametersHelp($$$GetEndpointParameters)
    }ElseIf ((url = "allowed") || (twoPartUrl = "auth/allowed")){
        Set result.description = "Lists, based on the defined rules for authorization, what the user can access through the endpoints"
        Set result.requirements = ""
        Set result.method = "GET"
        Set result.path = "/auth/allowed"
        Set result.parameters = []
    }ElseIf (url = "search"){
        Set result.description = "Search endpoint that allows to filter through a given persistent class"
        Set result.requirements = "The class must extend %Persistent and, for the JSON exports %JSON.Adaptor or RESTUtils.JSON.Adaptor."_
            "The body must be JSON and the request have the header Content-Type set to application/JSON"
        Set result.method = "POST"
        Set result.path = "/search/{{namespace}}/{{class}}"
        Set result.parameters = $$$GetParametersHelp($$$SearchEndpointParameters)
    }ElseIf (url = "info"){
        Set result.description = "Provides information about the properties of a given class"
        Set result.requirements = "The class must extend %Persistent and extend RESTUtils.JSON.Adaptor"
        Set result.method = "GET"
        Set result.path = "/class/{{namespace}}/{{class}}"
        Set result.parameters = $$$GetParametersHelp($$$ClassInfoEndpointParamters)
    }ElseIf ($PIECE(endpoint, "/", *-1, *) = "search/filter"){
    }ElseIf ((url = "create") ||(twoPartUrl = "edit/create")){
        Set result.description = "Creates a new instance of the class"
        Set result.requirements = "The class must extend %Persistent and extend RESTUtils.JSON.Adaptor, can work with %JSON.Adaptor but if the class "_
            "has references the behaviour might not work as intended. The body must be JSON and the request have the header Content-Type set to application/JSON"
        Set result.method = "POST"
        Set result.path = "/edit/create/{{namespace}}/{{class}}"
        Set result.parameters = $$$GetParametersHelp($$$CreateEndpointParameters)
    }ElseIf ((url = "update") ||(twoPartUrl = "edit/update")){
        Set result.description = "Updates an existing instance of the class"
        Set result.requirements = "The class must extend %Persistent and extend RESTUtils.JSON.Adaptor, can work with %JSON.Adaptor but if the class "_
            "has references the behaviour might not work as intended. The body must be JSON and the request have the header Content-Type set to application/JSON"
        Set result.method = "PUT"
        Set result.path = "/edit/create/{{namespace}}/{{class}}/{{identifier}}"
        Set result.parameters = $$$GetParametersHelp($$$UpdateEndpointParameters)
    }ElseIf ((url = "delete") ||(twoPartUrl = "edit/delete")){
        Set result.description = "Deletes an existing instance of the class"
        Set result.requirements = "The class must extend %Persistent"
        Set result.method = "DELETE"
        Set result.path = "/edit/delete/{{namespace}}/{{class}}/{{identifier}}"
        Set result.parameters = $$$GetParametersHelp($$$DeleteEndpointPrameters)
    }ElseIf ((url = "endpoints") || (url  ="") || (url  ="help")){
        Set result.info = "Navigate to /help/{{endpointHelp}} for info about the different endpoints"
        Set result.endpointHelp = ..GetAvailableEndpoints()
    }Else{
        THROW $$$HelpNotFound
    }
    Return result
}

ClassMethod RenderAllReadmeEndpoints() As %String(MAXLEN="")
{
    Set readme = ""
    Set endpoints = ..GetAvailableEndpoints()
    Set iter = endpoints.%GetIterator()
    while(iter.%GetNext("", .name)){
        Set readme = readme _ ..ReadmeEndpoint(name, ..GetHelp(name, 0))
    }
    Return readme
}

ClassMethod ReadmeEndpoint(key As %String(MAXLEN=""), endpoint As %DynamicObject) As %String(MAXLEN="")
{
    Set upMethod = $ZCONVERT(endpoint.method, "U")
    Set icon = $CASE(upMethod, "DELETE":"red", "PATCH":"yellow", "PUT":"orange", "POST":"green",:"blue")
    Set result = "## !["_upMethod_"](https://img.shields.io/badge/"_upMethod_"-"_icon_") `"_key_"`"_$char(10)_
    "### Description"_$char(10)_
    endpoint.description_$char(10)_
    "## Requirements"_$char(10)_
    endpoint.requirements_$char(10)_
    "### Endpoint "_$char(10)_
    "```http "_$char(10)_
    upMethod_" /get/{{namespace}}/{{class}}/{{identifier}} "_$char(10)_
    "```"_$CHAR(10)_
    "#### Parameters"_$Char(10)_
    "| Name"_$JUSTIFY(" ", 30)_"| Location"_$JUSTIFY(" ", 20)_"| Description     |"_ $CHAR(10)_"|:---------:|:---------:|:----------|"_$CHAR(10)
    Set iter = endpoint.parameters.%GetIterator()
    while(iter.%GetNext(.name, .description)){
        Set loc = $PIECE(description, ".", 1)
        Set desc = $PIECE(description, ".", 2, *)
        Set result = result _ "| "_name_$JUSTIFY(" ", 30-$LENGTH(name))_"       | "_loc_$JUSTIFY(" ", 20-$LENGTH(loc))_"| "_desc_$CHAR(10)
    }
    Return result_$CHAR(10)_$CHAR(10)_$CHAR(10)
}

ClassMethod HelpPage() As %String(MAXLEN="")
{
    Return "<!DOCTYPE html> "_
    "<html lang=""en""> "_
    "<head> "_
    "<meta charset=""UTF-8""> "_
    "<meta name=""viewport"" content=""width=device-width, initial-scale=1.0""> "_
    "<title>Simple Accordion</title> "_
    "<style> "_
    "body { "_
    "font-family: Arial, sans-serif; "_
    "margin: 40px; "_
    "background: #f5f5f5; "_
    "} "_
    ".accordion { "_
    "max-width: 600px; "_
    "margin: auto; "_
    "} "_
    ".accordion-item { "_
    "background: white; "_
    "border-radius: 8px; "_
    "margin-bottom: 10px; "_
    "overflow: hidden; "_
    "box-shadow: 0 2px 5px rgba(0,0,0,0.1); "_
    "} "_
    ".accordion-header { "_
    "padding: 15px; "_
    "cursor: pointer; "_
    "font-weight: bold; "_
    "background: #e0e0e0; "_
    "} "_
    ".accordion-content { "_
    "max-height: 0; "_
    "overflow: hidden; "_
    "transition: max-height 0.3s ease; "_
    "padding: 0 15px; "_
    "} "_
    ".accordion-content p { "_
    "margin: 15px 0; "_
    "} "_
    ".accordion-item.active .accordion-content { "_
    "max-height: 200px; "_
    "} "_
    "</style> "_
    "</head> "_
    "<body> "_
    "<div class=""accordion""> "_
    "<div class=""accordion-item""> "_
    "<div class=""accordion-header"">Section 1</div> "_
    "<div class=""accordion-content""> "_
    "<p>This is the content for section 1.</p> "_
    "</div> "_
    "</div> "_
    "<div class=""accordion-item""> "_
    "<div class=""accordion-header"">Section 2</div> "_
    "<div class=""accordion-content""> "_
    "<p>This is the content for section 2.</p> "_
    "</div> "_
    "</div> "_
    "<div class=""accordion-item""> "_
    "<div class=""accordion-header"">Section 3</div> "_
    "<div class=""accordion-content""> "_
    "<p>This is the content for section 3.</p> "_
    "</div> "_
    "</div> "_
    "</div> "_
    "<script> "_
    "const items = document.querySelectorAll('.accordion-header'); "_
    "items.forEach(header => { "_
    "header.addEventListener('click', () => { "_
    "const item = header.parentElement; "_
    "// toggle current "_
    "item.classList.toggle('active'); "_
    "// optional: close others "_
    "document.querySelectorAll('.accordion-item').forEach(i => { "_
    "if (i !== item) i.classList.remove('active'); "_
    "}); "_
    "}); "_
    "}); "_
    "</script> "_
    "</body> "_
    "</html>"
}

}
