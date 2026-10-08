Class RESTUtils.Test.AbstractTest Extends %UnitTest.TestCase [ Abstract ]
{

ClassMethod CheckTest(name = "", expectedResult, result, Output failed As %Boolean = 0, class, method, args...)
{
    Set mainStr = ""
    Set:(name '= "") mainStr = ..WriteColor(3, name) _ "    "
    Set mainStr = mainStr_"args: "
    Set argumentList = ""
    Set c = 0
    while (c < args){
        Set c = c + 1
        Set mainStr = mainStr_ args(c) _" | "
        Set argumentList = $LISTUPDATE(argumentList, $LISTLENGTH(argumentList) +1 , args(c))
    }
    W mainStr_ $JUSTIFY("",150-$LENGTH(mainStr)) _ "    "
    Set success = $$$AssertTrue(expectedResult = result, name)
    If (success){
        W ..WriteColor(2, "Success"), ! 
    }Else{
        W ..WriteColor(1, "Failed"),!, "        exepecting: "_..WriteColor(6, expectedResult) _ "        got: "_..WriteColor(5, result),!,!
        Set failed = 1
    }
}

ClassMethod WriteColor(color As %Numeric, text As %String(MAXLEN="")) As %String(MAXLEN="")
{
    Return $Char(27)_"[3"_color_"m"_text_$Char(27)_"[0m"
}

}
