Include RESTUtils.INC.Status

Class RESTUtils.Resolver.Export.TSInterfaceResolver
{

ClassMethod ResolveInterface(interface As %String(MAXLEN="")) As %DynamicObject
{
    Set interfaceList = $LISTFROMSTRING(..RegularizeInterface(interface), $char(10))
    Set ptr = 0
    Set result = {}
    while($LISTNEXT(interfaceList, ptr, line)){
        Set firstChar = $EXTRACT(line, 1, 1) 
        Set lastChar = $EXTRACT(line, *, *)
        If ((firstChar = """") && (lastChar = """")){

        }ElseIf ((firstChar = "[") && (lastChar = "]")){
        }Else{
            THROW ##Class(%Exception.General).%New("Invalid key", $$$BADREQUEST)
        }
    }
    Return {}
}

ClassMethod ParseInterface(interface) As %DynamicObject
{
    Set result = ""
    Set firstChar =  $EXTRACT(interface, 1, 1)
    THROW:((firstChar'= "{") && (firstChar '= "[") && (firstChar '= $EXTRACT(interface, *, *))) ##Class(%Exception.General).%New("Invalid interface", $$$BADREQUEST)
    Set isArray = firstChar = "["
    Set int = $LISTFROMSTRING(..RegularizeInterface($EXTRACT(interface, 2, *-1)),$CHAR(10))
    Set ptr = 0
    Set counter = 1
    while($LISTNEXT(int, ptr, line)){
        If ($EXTRACT(line, 1, 1) = "["){
            Set twoDotPos = $LENGTH($PIECE(line, "]", 1)) + $FIND($PIECE(line, "]", 2, *), ":")
            THROW:(twoDotPos = 0) ##Class(%Exception.General).%New("Invalid key", $$$BADREQUEST)
            Set line = """"_$PIECE($PIECE($EXTRACT(line, 1, twoDotPos-1), "[", 2), ":", 1) _ """:"""_$EXTRACT(line, twoDotPos+1, *)_""""
        }Else{
            Set twoDotPos = ..FirstCharOutStr(line, ":")
            THROW:(twoDotPos = 0) ##Class(%Exception.General).%New("Invalid key", $$$BADREQUEST)
            Set line = """"_$REPLACE($EXTRACT(line, 1, twoDotPos-1), """", "") _ """:"""_$REPLACE($EXTRACT(line, twoDotPos+1, *), """", "\""")_""""
        }
        Set:(line '= "") result = $LISTUPDATE(result, counter, line)
        Set counter = counter + 1
    }
    Set result = $LISTTOSTRING(result,",")
    If (isArray){
        Set result = "["_result_"]"
        Return [].%FromJSON(result)
    }Else{
        Set result = "{"_result_"}"
        Return {}.%FromJSON(result)
    }
}

ClassMethod FirstCharOutStr(str As %String(MAXLEN=""), char As %String(MAXLEN=1), stringChar As %String = """") As %Numeric
{
    Set counter = 0
    Set length = $LENGTH(str)
    Set insideOfStr = 0
    Set prevChar = ""
    while(counter < length){
        Set counter = counter + 1
        Set actualChar = $EXTRACT(str, counter, counter)
        Set:((actualChar [ stringChar) && (prevChar '= "\")) insideOfStr = 'insideOfStr
        Return:((insideOfStr = 0) && (actualChar = char)) counter 
        Set prevChar  = actualChar
    }
    Return 0
}

ClassMethod RegularizeInterface(interface As %String(MAXLEN="")) As %String(MAXLEN="")
{
    Return $REPLACE($TRANSLATE(interface, ";,"_$CHAR(13), $CHAR(10)_$CHAR(10)), $CHAR(10)_$CHAR(10), $CHAR(10))
}

Parameter AllowedValueTypes = "string,number,boolean,array,object";

Parameter AllowedKeyTypes = "string";

}
