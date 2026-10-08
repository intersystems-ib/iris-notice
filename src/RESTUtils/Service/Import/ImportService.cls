Include (RESTUtils.INC.Language.Errors, RESTUtils.INC.Utils)

Class RESTUtils.Service.Import.ImportService
{

/// Globals
Parameter ImportGlobal = "^RESTUtilsImport";

Parameter AmountOfIdsKey = "$IDS";

Parameter ItemLimit = 1000000;

ClassMethod AppendId(importId As %String(MAXLEN=""), class As %String(MAXLEN=""), providedId As %String(MAXLEN=""), localId As %String(MAXLEN=""))
{
    $$$SwapToInstallationNamespace
    THROW:(@..#ImportGlobal@(importId) = "") $$$ImportIdNotFound
    THROW:(..GetAmountOfIds(importId) >= ..#ItemLimit) $$$TooManyItems
    Set @..#ImportGlobal@(importId, class, providedId) = localId
}

ClassMethod ResolveId(importId As %String(MAXLEN=""), class As %String(MAXLEN=""), providedId As %String(MAXLEN="")) As %String(MAXLEN="")
{
    $$$SwapToInstallationNamespace
    THROW:(@..#ImportGlobal@(importId) = "") $$$ImportIdNotFound
    Return @..#ImportGlobal@(importId, class, providedId)
}

ClassMethod GetAmountOfIds(importId As %String(MAXLEN=""))
{
    $$$SwapToInstallationNamespace
    Return @..#ImportGlobal@(importId, ..#AmountOfIdsKey)
}

ClassMethod IncrementAmountOfIds(importId As %String(MAXLEN=""))
{
    $$$SwapToInstallationNamespace
    Set:(@..#ImportGlobal@(importId, ..#AmountOfIdsKey) = "") @..#ImportGlobal@(importId, ..#AmountOfIdsKey) = 0 
    Set @..#ImportGlobal@(importId, ..#AmountOfIdsKey) = @..#ImportGlobal@(importId, ..#AmountOfIdsKey) + 1
}

}
