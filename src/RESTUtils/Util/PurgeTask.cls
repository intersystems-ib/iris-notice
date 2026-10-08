Include RESTUtils.INC.Log

Class RESTUtils.Util.PurgeTask Extends %SYS.Task.Definition
{

Method OnTask() As %Status
{
    Return $$$PurgeInternalLog
}

}
