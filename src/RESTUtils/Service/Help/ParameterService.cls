Include (RESTUtils.INC.Log, RESTUtils.INC.Language.Errors)

Class RESTUtils.Service.Help.ParameterService
{

Parameter OptionsKeysINCRoutine = "RESTUtils.INC.OptionsKeys";

ClassMethod GetParametersOfEndpoint(parameterkey... As %String(MAXLEN="")) As %DynamicObject
{
    Set macros = {}
    While(..OrderDefinedMacros(.key, .macro)){
        Continue:('..MacroIsOption(macro))
        Set macroValue = ..GetMacroValue(macro)
        Continue:('..IncludeMacro(macroValue, parameterkey...))
        Do macros.%Set(macroValue, ..GetMacroComment(key))
    }
    Return macros
}

ClassMethod OrderDefinedMacros(ByRef key = "", Output value As %String(MAXLEN="")) As %Boolean
{
    Set key = $ORDER(^rINC(..#OptionsKeysINCRoutine, 0, key))
    Return:(key = "") 0
    Set value = $GET(^rINC(..#OptionsKeysINCRoutine, 0, key))
    Return 1
}

ClassMethod MacroIsOption(macro As %String(MAXLEN="")) As %Boolean
{
    Return macro ] "#Define OP"
}

ClassMethod IncludeMacro(macro As %String(MAXLEN=""), parameterkey... As %String(MAXLEN="")) As %Boolean
{
    While(parameterkey > 0){
        Return:(parameterkey(parameterkey) = macro) 1
        Set parameterkey = parameterkey - 1
    }
    Return 0
}

ClassMethod GetMacroValue(macro As %String(MAXLEN="")) As %String(MAXLEN="")
{
    Return $PIECE(macro, """", 2, 2)
}

ClassMethod GetMacroComment(macroLine As %String(MAXLEN="")) As %String(MAXLEN="")
{
    Return $ZSTRIP($GET(^rINC(..#OptionsKeysINCRoutine, 0, macroLine - 1)), "<", "##; ")
}

}
