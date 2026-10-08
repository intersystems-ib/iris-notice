Class RESTUtils.Installation.TaskGenerator [ CompileAfter = RESTUtils.Util.PurgeTask ]
{

ClassMethod GenerateTask() As %Status
{
    
    Set ns = $NAMESPACE
    NEW $NAMESPACE
    zn "%SYS"
    Set task = ##Class(%SYS.Task).%New()
    Set task.DailyFrequency = 4
    Set task.TaskClass = "RESTUtils.Util.PurgeTask"
    Set task.Name          = "Purge RESTUtils"
    Set task.Description   = "Auto generated task to purge temporal classes"
    Set task.NameSpace     = ns 

    // ---- Scheduling -------------------------------------------------
    Set task.DailyFrequency    = 1
    Set task.DailyFrequencyTime = 4
    Set task.TimePeriod = 0
    Set task.TimePeriodEvery   = 1          // every 1 day
    Set task.DailyStartTime    = $ZTH("00:00")   ;// run at midnight
    Set task.Expires           = 0         
    Set task.StartDate         = $H+1
    Set task.RescheduleOnStart = 1  
    Return task.%Save()
}

}
