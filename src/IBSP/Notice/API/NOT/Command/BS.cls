Class IBSP.Notice.API.NOT.Command.BS Extends Ens.BusinessService
{

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	quit ..SendRequestAsync("IBSP.Notice.BP.Telegram.CommandManager", pInput)
}

}
