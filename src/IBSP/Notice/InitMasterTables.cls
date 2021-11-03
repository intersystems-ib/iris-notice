Class IBSP.Notice.InitMasterTables
{

ClassMethod Init() As %Status
{
    set ret = $$$OK

    try {

        $$$ThrowOnError(..CreateLangauges())
        $$$ThrowOnError(..CreateParameters())
    } catch ex {
        set ret = ex.AsStatus()
    }

    quit ret
}

/// Create default languages
ClassMethod CreateLangauges() As %Status
{
	set ret = $$$OK

	try {

		set english = ##class(IBSP.Notice.DAT.Lang).%New()
		set english.ISO = "en"
		set english.Description = "English"
		$$$ThrowOnError(english.%Save(0))

		set spanish = ##class(IBSP.Notice.DAT.Lang).%New()
		set spanish.ISO = "es"
		set spanish.Description = "Castellano"
		$$$ThrowOnError(spanish.%Save(0))

		set catalan = ##class(IBSP.Notice.DAT.Lang).%New()
		set catalan.ISO = "ca"
		set catalan.Description = "Català"
		$$$ThrowOnError(catalan.%Save(0))

        write !, "Languages loaded"
	} catch ex {
		set ret = ex.AsStatus()
	}

	quit ret
}

/// Create default languages
ClassMethod CreateParameters() As %Status
{
	set ret = $$$OK

	try {

		set defaultLanguageParam = ##class(IBSP.Notice.DAT.Params).%New()
		set defaultLanguageParam.ParamID = "DefaultLang"
		set defaultLanguageParam.ParamDesc = "Default language ID"
		set defaultLanguageParam.ParamValue = "1"
		set defaultLanguageParam.ParamType = "TEXT"
		$$$ThrowOnError(defaultLanguageParam.%Save(0))

        write !, "Default language parameter loaded"
	} catch ex {
		set ret = ex.AsStatus()
	}

	quit ret
}

}
