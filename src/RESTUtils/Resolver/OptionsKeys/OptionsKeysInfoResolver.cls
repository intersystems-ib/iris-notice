Include (RESTUtils.INC.OptionsKeys, RESTUtils.INC.Providers)

/// TODO move global accesses to service
Class RESTUtils.Resolver.OptionsKeys.OptionsKeysInfoResolver
{

ClassMethod GetParametersHelp(endpoint As %String(MAXLEN="")) As %DynamicObject
{
    Return ..GetOptions(..GetEndpointParameters("SearchEndpointParameters"))
}

ClassMethod GetEndpointParameters(endpointKey As %String(MAXLEN="")) As %List
{
    Set macros = {}
    Set macroKey = "" 
    FOR{
        Set macroKey = ..OrderOptionsKeys(macroKey)
        quit:(macroKey = "")
        Set macro = ..GetMacro(macroKey, .comment)
        Do macros.%Set(macroKey, macro)
    }
    Return ..ResolveMacro($LISTFROMSTRING(macros.%Get(endpointKey)), macros)
}

ClassMethod ResolveMacro(macro As %List, macros As %DynamicObject) As %List
{
    Set c = 1
    Set length = $LISTLENGTH(macro)
    while(c<=length){
        Set value = macros.%Get($EXTRACT($LISTGET(macro, c),4,*))
        If ($EXTRACT(value, 1, 3) = "$$$"){
            Set value = $LISTTOSTRING(..ResolveMacro($LISTFROMSTRING(value), macros))
        }
        Set macro = $LISTUPDATE(macro, c, value)
        Set c = c + 1
    }
    Return $LISTFROMSTRING($LISTTOSTRING(macro))
}

ClassMethod GetOptions(parameterList As %List) As %DynamicObject
{
    Set result = {}
    Set macroKey = "" 
    FOR{
        Set macroKey = ..OrderOptionsKeys(macroKey)
        quit:(macroKey = "")  
        If (..IsOption(macroKey)){
            Set macro = ..GetMacro(macroKey, .comment)
            continue:($LISTFIND(parameterList, macro) = 0)
            Do result.%Set(macro, comment)
        }
    }
    Return result
}

ClassMethod OrderOptionsKeys(macroKey As %String(MAXLEN=""))
{
    Return $ORDER(^rINC($$$HelpOptionsKeys,"P","E",macroKey))
}

ClassMethod IsOption(macro) As %Boolean
{
    Return $EXTRACT(macro, 1, 2) = "OP"
}

ClassMethod GetMacro(macroKey As %String(MAXLEN=""), Output comment As %String(MAXLEN="")) As %String(MAXLEN="")
{
    Set macroInfo = $LISTFROMSTRING(^rINC("RESTUtils.INC.OptionsKeys","P","E",macroKey),$char(1))
    Set line = $PIECE($LISTGET(macroInfo, 5), "^")
    Set comment = ..GetComment(line)
    Return $REPLACE($LISTGET(macroInfo,4), """", "")
}

ClassMethod GetComment(line As %Numeric) As %String(MAXLEN="")
{
    Set comment = $PIECE(^rINC("RESTUtils.INC.OptionsKeys","0", line - 1), ";", 2, *)
    Return $CASE($EXTRACT(comment, 1, 1), " ":$EXTRACT(comment, 2, *), :comment)
}

}
