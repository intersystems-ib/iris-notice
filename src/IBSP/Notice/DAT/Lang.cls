Class IBSP.Notice.DAT.Lang Extends (%Persistent, Form.Adaptor)
{

Parameter FORMNAME = "Lang";

Parameter DISPLAYPROPERTY = "Description";

Parameter FORMORDERBY = "ISO";

/// Code ISO639-1: Acronym of the Language (es = Spanish ; ca = Català ; pt = Português ; en = English)
Property ISO As %String;

/// Description on the language
Property Description As %String;

Index UIISO On ISO [ Unique ];

/// Returns the default language
ClassMethod GetDefault() As IBSP.Notice.DAT.Lang
{
    #define DefaultLanguageParamID "DefaultLang"

    set defaultLang = $$$NULLOREF
    
    try {

        set defaultLangParam = ##class(IBSP.Notice.DAT.Params).PKParamsOpen($$$DefaultLanguageParamID)
        if $isobject(defaultLangParam) {
            set defaultLanguageId = defaultLangParam.ParamValue
            set defaultLang = ..%OpenId(defaultLanguageId)
        }
    } catch ex {
        ; do nothing
    }

    quit defaultLang
}

/// Necessary for RESTForms2. This query is called to retrieve all the available languages
ClassMethod queryLIST() As %String
{
    quit "%id _id, " _
         "ISO, " _
         "Description "
}

Storage Default
{
<Data name="LangDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ISO</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^IBSP.Notice.DAT.LangD</DataLocation>
<DefaultData>LangDefaultData</DefaultData>
<IdLocation>^IBSP.Notice.DAT.LangD</IdLocation>
<IndexLocation>^IBSP.Notice.DAT.LangI</IndexLocation>
<StreamLocation>^IBSP.Notice.DAT.LangS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
