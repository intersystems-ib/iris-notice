Class IBSP.Notice.Service.ResourceActionService
{

ClassMethod GetByResourceAndAction(resource As %String, action As %String, Output resourceAction As IBSP.Notice.DAT.ResourceAction) As %Status
{
    set resourceAction = ##class(IBSP.Notice.DAT.ResourceAction).UIResourceActionOpen(resource, action, .sc)

    return sc
}

ClassMethod GetTopicsByResourceAction(resourceAction As IBSP.Notice.DAT.ResourceAction, Output topics As %ListOfObjects) As %Status
{
    set sc = $$$OK

    try {

        set topics = ##class(%ListOfObjects).%New()

        set select = "SELECT Topic "
        set from = "    FROM IBSP_Notice_DAT.ResourceActionTopics "
        set where = "  WHERE ResourceAction = ? "
        set query = select _ from _ where

        set result = ##class(%SQL.Statement).%ExecDirect(, query, resourceAction.%Id())

        while result.%Next() {

			set topicId = result.%Get("Topic")
			set topic = ##class(IBSP.Notice.DAT.Topic).%OpenId(topicId)

			do:(topic.Active) topics.Insert(topic)
		}

    } catch ex {
        set sc = ex.AsStatus()
    }

    return sc
}

}
