Class IBSP.Notice.BS.REST.NotifyBusinessService Extends Ens.BusinessService
{

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	//return ..SendRequestAsync("IBSP.Notice.BP.REST.ActionManager", pInput)
	return ..SendRequestSync("IBSP.Notice.BP.REST.ActionManager", pInput, .pOutput)
}

}
