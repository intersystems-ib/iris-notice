Include RESTUtils.INC.Language.Errors

/// TODO finish
Class RESTUtils.Exception.LogException Extends %Exception.General
{

Method %OnNew(pName As %String = "", pCode As %String(VALUELIST=",ERROR,WARN,INFO") = "", pLocation As %String = "", pData As %String = "", pInnerException As %Exception.AbstractException = {$$$NULLOREF}) As %Status [ Private ]
{
    Return ##super(pName, pCode, pLocation, pData, pInnerException)
}

}
