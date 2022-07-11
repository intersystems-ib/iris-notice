/// 
Class IBSP.Notice.BP.REST.ActionManager Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='IBSP.Notice.Request.PullNoticeRequest' response='Ens.StringResponse' height='2000' width='2000' >
<context>
<property name='resourceAction' type='IBSP.Notice.DAT.ResourceAction' instantiate='0' />
<property name='subscriber' type='IBSP.Notice.DAT.Subscriber' instantiate='0' />
<property name='topics' type='IBSP.Notice.DAT.Topic' collection='list' instantiate='0' />
<property name='subscriberTopics' type='IBSP.Notice.DAT.Topic' collection='list' instantiate='0' />
<property name='k1' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='publisherRequest' type='IBSP.Notice.Request.PullNoticeRequest' instantiate='0' />
</context>
<sequence xend='200' yend='1400' >
<code name='Get Subscriber' xpos='200' ypos='250' >
<![CDATA[ try {
 
     $$$ThrowOnError(##class(IBSP.Notice.Service.SubscriberService).GetByUserId(request.UserIdType, request.UserIdCode, .subscriber))
     set:(subscriber '= "") request.Subscriber = subscriber
 } catch ex {
     $$$LOGERROR("Error: " _ ex.DisplayString())
 }
]]>
</code>
<if name='Exists subscriber?' condition='request.Subscriber &apos;= ""' xpos='200' ypos='350' xend='200' yend='1300' >
<true>
<code name='Get ResourceAction' xpos='470' ypos='500' >
<![CDATA[ try {

     set command = request.Command
 
     if command '= "" {
 
         set resource = $piece(command, "/", 1)
         set action = $piece(command, "/", 2)
         
         $$$ThrowOnError(##class(IBSP.Notice.Service.ResourceActionService).GetByResourceAndAction(resource, action, .resourceAction))
 
         if (resourceAction = "") {
             $$$ThrowOnError(##class(IBSP.Notice.Service.ResourceActionService).GetByResourceAndAction(resource, "*", .resourceAction))
         }
   
         set context.resourceAction = resourceAction
     }
 } catch ex {
     $$$LOGERROR("Error: " _ ex.DisplayString())
 }
]]>
</code>
<if name='Exists ResourceAction?' condition='context.resourceAction &apos;= ""' xpos='470' ypos='600' xend='470' yend='1200' >
<true>
<code name='Get Topics' xpos='740' ypos='750' >
<![CDATA[ try {

     $$$ThrowOnError(##class(IBSP.Notice.Service.ResourceActionService).GetTopicsByResourceAction(context.resourceAction, .topics))
     set context.topics = topics
 } catch ex {
     $$$LOGERROR("Error: " _ ex.DisplayString())
 }]]>
</code>
<if name='Exist topics?' condition='context.topics.Size &gt; 0' xpos='740' ypos='850' xend='740' yend='1100' >
<true>
<foreach name='Loop over all topics' property='context.topics' key='context.k1' xpos='1010' ypos='1000' xend='200' yend='350' >
<code name='Calculate text and call Publisher' xpos='200' ypos='250' >
<![CDATA[ set topic = context.topics.GetAt(context.k1)
 
 set subscriberId = request.Subscriber.%Id()

 if ##class(IBSP.Notice.Service.SubscriberService).IsSubscribedToTopic(subscriberId, topic.TopicKey) {
 
     set contactWayType = topic.ContactWay
     $$$ThrowOnError(##class(IBSP.Notice.Service.ContactWayService).GetAddressesBySubscriberIdAndType(subscriberId, contactWayType, .contactWayAddresses))
     
     for i = 1: 1: contactWayAddresses.Size {
     
         set contactWayAddress = contactWayAddresses.GetAt(i)

         $$$ThrowOnError(##class(IBSP.Notice.Utils).GetTextParamsAsArray(request.TextParams, .params))
         set params(contactWayType) = contactWayAddress

         if topic.TemplateMsg '= "" {
             $$$ThrowOnError(##class(IBSP.Notice.Utils).GetTopicText(topic, request.Subscriber.Lang, .params, .text))
             set params("msg") = text
         }
         if topic.BodyTemplate '= "" {
             $$$ThrowOnError(##class(IBSP.Notice.Utils).GetTopicBody(topic, .params, .text))
         }

         set pullRequest = request
         set pullRequest.Topic = topic
         set pullRequest.Text = text
         set pullRequest.ContactWayAddress = contactWayAddress
         $$$ThrowOnError(process.SendRequestSync("IBSP.Notice.BP.Publisher", pullRequest, .resp))
     }
 }
]]>
</code>
</foreach>
</true>
<false>
<assign name="No Topic error" property="response.StringValue" value="&quot;There's no topic for the ResourceAction &quot; _ request.Command" action="set" xpos='740' ypos='1000' />
</false>
</if>
</true>
<false>
<assign name="No ResourceAction error" property="response.StringValue" value="&quot;There's no action for &quot; _ request.Command" action="set" xpos='470' ypos='750' />
</false>
</if>
</true>
<false>
<assign name="No Subscriber error" property="response.StringValue" value="&quot;There's no user with &quot; _ request.UserIdType _ &quot; &quot; _ request.UserIdCode" action="set" xpos='200' ypos='500' />
</false>
</if>
</sequence>
</process>
}

}
