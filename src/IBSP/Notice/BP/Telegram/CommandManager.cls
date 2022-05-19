Class IBSP.Notice.BP.Telegram.CommandManager Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='IBSP.Notice.Request.PullNoticeRequest' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='command' type='IBSP.Notice.DAT.TelegramCommand' instantiate='0' />
<property name='userId' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='response' type='IBSP.Notice.Request.PullNoticeRequest' instantiate='0' />
<property name='inputString' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='BOResponse' type='IBSP.Notice.Messages.DirectDeliverReq' instantiate='0' />
<property name='subscriber' type='IBSP.Notice.DAT.Subscriber' instantiate='0' />
</context>
<sequence xend='200' yend='1500' >
<code name='Extraer comando y usuario de request' xpos='200' ypos='250' >
<annotation><![CDATA[A partir de la cadena recibida, se buscará a qué comando pertenece la acción.
También se obtiene el suscriptor al que hay que mandarle el mensaje]]></annotation>
<![CDATA[ Set context.userId = request.UserIdCode
 Set context.inputString = request.Command
 Set command = ""
 do ##class(IBSP.Notice.Service.TelegramCommandService).FindCommandByInputString(context.inputString, .command)
 Set context.command = command
 
 try {

     set contactWayType = "telegram"
     $$$ThrowOnError(##class(IBSP.Notice.Service.SubscriberService).GetByContactWay(contactWayType, request.ContactWayAddress, .subscriber))
     if subscriber = "" {
         $$$ThrowStatus($$$ERROR($$$GeneralError, "Subscriber with " _ context.contactWayType _ " " _ request.ContactWayAddress _ " does not exist."))
     }
  
     set context.subscriber = subscriber
 } catch ex {
     $$$LOGERROR("Error: " _ ex.DisplayString())
 }]]>
</code>
<if name='¿Existe el comando?' condition='context.command&apos;=""' xpos='200' ypos='350' xend='200' yend='1300' >
<true>
<if name='¿Es interno el comando?' condition='context.command.isInternal()' xpos='470' ypos='500' xend='470' yend='1200' >
<true>
<code name='Crear respuesta' xpos='470' ypos='650' >
<![CDATA[ set noticeRequest = request
 set noticeRequest.Subscriber = context.subscriber
 do ##class(IBSP.Notice.Service.TelegramCommandService).CreateNoticeRequestInternal(.noticeRequest)

 set context.response = noticeRequest]]>
</code>
</true>
<false>
<if name='¿El usuario está suscrito?' condition='context.command.isUserSubscribed(context.userId)' xpos='740' ypos='650' xend='740' yend='1100' >
<annotation><![CDATA[Comprueba si el usuario que ha invocado el comando está suscrito al topic asociado.]]></annotation>
<true>
<call name='Llamada al componente' target='@context.command.ExecutionComponent' async='0' timeout='30' xpos='1010' ypos='800' >
<annotation><![CDATA[Se llama al componente de ejecución asociado al comando (BS/BP/BO)]]></annotation>
<request type='IBSP.Notice.Request.GetCommandTextRequest' >
<assign property="callrequest.Topic" value="context.command.Topic" action="set" />
<assign property="callrequest.Parameters" value="##class(IBSP.Notice.Utils).ExtractParametersFromCommand(context.inputString)" action="set" />
<assign property="callrequest.Subscriber" value="context.subscriber" action="set" />
</request>
<response type='Ens.Response' >
<assign property="context.BOResponse" value="callresponse" action="set" />
</response>
</call>
<code name='Crea respuesta con texto' xpos='1010' ypos='1000' >
<annotation><![CDATA[Crea la notificación con el texto obtenido anteriormente.]]></annotation>
<![CDATA[
 set noticeRequest = request
 set noticeRequest.Subscriber = context.subscriber
 do ##class(IBSP.Notice.Service.TelegramCommandService).CreateNoticeRequest(context.command, context.BOResponse.Text, .noticeRequest)
 
 set context.response = noticeRequest]]>
</code>
</true>
<false>
<code name='Crear respuesta no autorizado' xpos='740' ypos='800' >
<![CDATA[ set noticeRequest = request
 set noticeRequest.Subscriber = context.subscriber
 do ##class(IBSP.Notice.Service.TelegramCommandService).CreateNoticeRequestNotAuth(context.command, .noticeRequest)
 
 set context.response = noticeRequest]]>
</code>
</false>
</if>
</false>
</if>
</true>
<false>
<code name='Crear respuesta NO COMMAND' xpos='200' ypos='500' >
<![CDATA[ set noticeRequest = request
 set noticeRequest.Subscriber = context.subscriber
 do ##class(IBSP.Notice.Service.TelegramCommandService).CreateNoticeRequestError(.noticeRequest)

 set context.response = noticeRequest]]>
</code>
</false>
</if>
<call name='Call to Publisher' target='IBSP.Notice.BP.Publisher' async='1' xpos='200' ypos='1400' >
<request type='IBSP.Notice.Request.PullNoticeRequest' >
<assign property="callrequest" value="context.response" action="set" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
</process>
}

}
