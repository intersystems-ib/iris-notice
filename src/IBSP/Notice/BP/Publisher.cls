/// 
Class IBSP.Notice.BP.Publisher Extends Ens.BusinessProcessBPL [ ClassType = persistent, ProcedureBlock ]
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='IBSP.Notice.Request.NoticeRequest' response='IBSP.Notice.Messages.NoticeRes' height='2000' width='2000' >
<context>
<property name='outboundAdapter' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='subscribers' type='IBSP.Notice.DAT.Subscriber' collection='list' instantiate='0' />
<property name='hasToSendNotification' type='%Boolean' initialexpression='1' instantiate='0' />
<property name='k1' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
</context>
<sequence xend='200' yend='700' >
<switch name='Notification Type' xpos='200' ypos='250' xend='200' yend='500' >
<case condition='request.isPullNotification()' name='Pull' >
<code name='set context data' xpos='200' ypos='400' >
<annotation><![CDATA[Set Outbound Adapter & Subscribers]]></annotation>
<![CDATA[ set context.outboundAdapter = "telegram"
 set topic = request.Topic
 set:($isobject(topic)) context.outboundAdapter = topic.OutboundAdapter
     
 do context.subscribers.Insert(request.Subscriber)]]>
</code>
</case>
<default name='default' >
<code name='set context data' xpos='470' ypos='400' >
<annotation><![CDATA[Get Outbound Adapter & Subscribers from Topic]]></annotation>
<![CDATA[ try {
 
     set topic = request.Topic
     set:($isobject(topic)) context.outboundAdapter = topic.OutboundAdapter
 
     if (request.UserIdType '= "") && (request.UserIdCode '= "") {
 
         $$$ThrowOnError(##class(IBSP.Notice.Service.SubscriberService).GetByUserId(request.UserIdType, request.UserIdCode, .subscriber))
         if subscriber = "" {
	     $$$ThrowStatus($$$ERROR($$$GeneralError, "Subscriber with " _ userIdType _ " " _ request.UserId _ " does not exist."))
	 }
 
	 do context.subscribers.Insert(subscriber)
 
     } else {
 
         $$$ThrowOnError(##class(IBSP.Notice.Service.SubscriberService).GetByTopic(topic.TopicKey, .subscribers))
         set context.subscribers = subscribers
     }
 } catch ex {
     $$$LOGERROR("Error: " _ ex.DisplayString())
 }]]>
</code>
</default>
</switch>
<foreach name='Loop over all subscribers' property='context.subscribers' key='context.k1' xpos='200' ypos='600' xend='200' yend='1650' >
<switch name='NotificationType' xpos='200' ypos='250' xend='200' yend='500' >
<case condition='request.isPushNotification()' name='Push' >
<code name='Calculate has to send' xpos='335' ypos='400' >
<annotation><![CDATA[Decide whether push notification has to be sent or not.
Pull notifications must always be sent.]]></annotation>
<![CDATA[ if request.SendIfPublished = "Y" {
 
     set context.hasToSendNotification = 1
 } else {
 
     set element = request.Element
     if element = "" {
      
         set context.hasToSendNotification = 1
     } else {
     
         set topic = request.Topic
         set subscriber = context.subscribers.GetAt(context.k1)
         
         set context.hasToSendNotification = '##class(IBSP.Notice.Service.NotificationService).IsPublishedForSubscriber(topic.%Id(), element, subscriber.%Id())
     }
 }]]>
</code>
</case>
<default name='default' />
</switch>
<if name='Send notification' condition='context.hasToSendNotification' xpos='200' ypos='600' xend='200' yend='1550' >
<true>
<code name='Set subscriber' xpos='335' ypos='750' >
<![CDATA[ set request.Subscriber = context.subscribers.GetAt(context.k1)]]>
</code>
<switch name='NotificationType' xpos='335' ypos='850' xend='335' yend='1100' >
<case condition='request.isPushNotification()' name='Push' >
<code name='Calculate text' xpos='470' ypos='1000' >
<annotation><![CDATA[Decide whether push notification has to be sent or not.
Pull notifications must always be sent.]]></annotation>
<![CDATA[ $$$ThrowOnError(##class(IBSP.Notice.Utils).GetTextParamsAsArray(request.TextParams, .params))
 
 if $zconvert(context.outboundAdapter, "L") = "http" {
 
     set contactWayType = request.Topic.ContactWay
     set contactWayAddress = request.ContactWayAddress
 
     if (contactWayAddress = "") {

         set subscriberId = request.Subscriber.%Id()
         set contactWayType = request.Topic.ContactWay
         $$$ThrowOnError(##class(IBSP.Notice.Service.ContactWayService).GetAddressBySubscriberIdAndType(subscriberId, contactWayType, .contactWayAddress))
         set request.ContactWayAddress = contactWayAddress
     }
     
     set params(contactWayType) = contactWayAddress

     $$$ThrowOnError(##class(IBSP.Notice.Utils).GetTopicBody(request.Topic, .params, .text))
 } else {
     $$$ThrowOnError(##class(IBSP.Notice.Utils).GetTopicText(request.Topic, request.Subscriber.Lang, .params, .text))
 }
 set request.Text = text]]>
</code>
</case>
<default name='default' />
</switch>
<switch name='Outbound Adapter' xpos='335' ypos='1200' xend='335' yend='1450' >
<case condition='$zconvert(context.outboundAdapter, "L") = "telegram"' name='Telegram' >
<code name='Send Telegram Notification' xpos='470' ypos='1350' >
<![CDATA[ try {
 
     set telegramAddresses = ##class(%ListOfDataTypes).%New()
     
     if (request.ContactWayAddress '= "") {
         do telegramAddresses.Insert(request.ContactWayAddress)
     } else {
         $$$ThrowOnError(##class(IBSP.Notice.Service.ContactWayService).GetAddressesBySubscriberIdAndType(request.Subscriber.%Id(), "telegram", .telegramAddresses))
     }
     
     for i = 1: 1: telegramAddresses.Size {
     
         set telegramAddress = telegramAddresses.GetAt(i)
         
         set telegramRequest = ##class(IBSP.Notice.Request.TelegramNoticeRequest).%New(request)
     
         if (telegramRequest.Token = "") {
     
             $$$ThrowOnError(##class(IBSP.Notice.Utils).GetTopicToken(telegramRequest.Topic, .token))
             set telegramRequest.Token = token
         }

         set telegramRequest.ContactWayAddress = telegramAddress

         if telegramRequest.isPullNotification() {

             set telegramRequest.Silent = 1
             set telegramRequest.ReplyId = request.ReplyId
         
             $$$ThrowOnError(process.SendRequestSync("IBSP.Notice.BO.TelegramDeliver", telegramRequest, .response))
 
         } else {
 
             $$$ThrowOnError(process.SendRequestAsync("IBSP.Notice.BO.TelegramDeliver", telegramRequest, .response))
         }
     }
 } catch ex {
     $$$LOGERROR("Error: "_ex.DisplayString())
 }
 ]]>
</code>
</case>
<case condition='$zconvert(context.outboundAdapter, "L") = "email"' name='Email' >
<code name='Send Email Notification' xpos='740' ypos='1350' >
<![CDATA[ try {
 
     set topic = request.Topic
     
     set emailAddresses = ##class(%ListOfDataTypes).%New()
     
     if request.ContactWayAddress '= "" {
         do emailAddresses.Insert(request.ContactWayAddress)
     } else {
         $$$ThrowOnError(##class(IBSP.Notice.Service.ContactWayService).GetAddressesBySubscriberIdAndType(request.Subscriber.%Id(), "email", .emailAddresses))
     }
     
     for i = 1: 1: emailAddresses.Size {
     
         set emailAddress = emailAddresses.GetAt(i)
         set emailRequest = ##class(IBSP.Notice.Request.EmailNoticeRequest).%New(request)
         set:($isobject(topic)) emailRequest.Subject = ##class(IBSP.Notice.Utils).GetTranslatedMessage(topic.SubjectMsg, emailRequest.Subscriber.Lang, topic.Subject)
         
         $$$ThrowOnError(##class(IBSP.Notice.Utils).GetTopicManagerNotification(topic, .managerNotification))
         set emailRequest.ManagerNotification = managerNotification
         
         set emailRequest.ContactWayAddress = emailAddress
         
         $$$ThrowOnError(process.SendRequestAsync("IBSP.Notice.BO.EmailDeliver", emailRequest))
     }
 } catch ex {
     $$$LOGERROR("Error: " _ ex.DisplayString())
 }]]>
</code>
</case>
<case condition='($zconvert(context.outboundAdapter, "L") = "http") || ($zconvert(context.outboundAdapter, "L") = "sms")' name='HTTP / SMS' >
<code name='Send HTTP/SMS Notification' xpos='1010' ypos='1350' >
<![CDATA[ try {
 
     set restRequest = ##class(IBSP.Notice.Request.RESTNoticeRequest).%New(request)
     
     if (restRequest.ContactWayAddress = "") {

         set subscriberId = restRequest.Subscriber.%Id()
         set contactWayType = restRequest.Topic.ContactWay
         $$$ThrowOnError(##class(IBSP.Notice.Service.ContactWayService).GetAddressBySubscriberIdAndType(subscriberId, contactWayType, .contactWayAddress))
         set restRequest.ContactWayAddress = contactWayAddress
     }
     
     $$$ThrowOnError(process.SendRequestAsync(request.Topic.ExecutionComponent, restRequest))
 } catch ex {
     $$$LOGERROR("Error: "_ex.DisplayString())
 }]]>
</code>
</case>
<default name='default' />
</switch>
</true>
</if>
</foreach>
</sequence>
</process>
}

}
