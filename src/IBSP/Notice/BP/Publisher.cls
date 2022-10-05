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
<process language='objectscript' request='IBSP.Notice.Request.NoticeRequest' response='IBSP.Notice.Messages.NoticeRes' height='2500' width='2150' >
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
<property name='sc' type='%Library.Status' initialexpression='1' instantiate='0' />
<property name='validationError' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='' />
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
 
     if request.Subscriber '= "" {
         do context.subscribers.Insert(request.Subscriber)
     } elseif (request.UserIdType '= "") && (request.UserIdCode '= "") {
 
         $$$ThrowOnError(##class(IBSP.Notice.Service.SubscriberService).GetByUserId(request.UserIdType, request.UserIdCode, .subscriber))
         if subscriber = "" {
	     $$$ThrowStatus($$$ERROR($$$GeneralError, "Subscriber with "_request.UserIdType_ " "_ request.UserIdCode_ " does not exist."))
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
<foreach name='Loop over all subscribers' property='context.subscribers' key='context.k1' xpos='200' ypos='600' xend='200' yend='2250' >
<switch name='NotificationType' xpos='200' ypos='250' xend='200' yend='500' >
<case condition='request.isPushNotification()' name='Push' >
<code name='Calculate has to send' xpos='200' ypos='400' >
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
<default>
<code name='has to send = true' xpos='470' ypos='400' >
<![CDATA[ set context.hasToSendNotification = 1]]>
</code>
</default>
</switch>
<if name='Send notification' condition='context.hasToSendNotification' xpos='200' ypos='600' xend='200' yend='2150' >
<true>
<code name='Set subscriber' xpos='335' ypos='750' >
<![CDATA[ set request.Subscriber = context.subscribers.GetAt(context.k1)]]>
</code>
<code name='Validate content' xpos='335' ypos='850' >
<![CDATA[ set validationCommand = request.Topic.ValidationCommand
 
 if validationCommand '= "" {
 
     set validationCommand = "(req, res) set sc = 1 try { " _ validationCommand _ " } catch e { set sc = e.AsStatus() } quit sc"

     set context.sc = $xecute(validationCommand, request, .res)

     if context.sc = 1 {
         set context.hasToSendNotification = res
     } else {

         set context.hasToSendNotification = 0
         set err = ""
         do $system.Status.DecomposeStatus(context.sc,.err,"-d")
         set context.validationError = err(1)
     }
 } else {
     set context.sc = 1
 }]]>
</code>
<if name='Is Error' condition='context.sc &apos;= 1' xpos='335' ypos='950' xend='335' yend='2050' >
<true>
<assign name="Validation error" property="response.result" value="&quot;Topic validation error&quot;" action="set" xpos='335' ypos='1100' />
<code name='Create Notification' xpos='335' ypos='1200' >
<![CDATA[ set notification = ##class(IBSP.Notice.DAT.Notification).%New()
 set notification.Topic = request.Topic
 set notification.Element = request.Element
 set notification.BusinessOperation = ""
 set notification.NotificationType = request.NotificationType
 set notification.Subscriber = request.Subscriber
 set:(request.Token '= "") notification.DirectData = request.Token _ "|||"
 set notification.DirectData = notification.DirectData _ request.ContactWayAddress
 set notification.Text = request.Text
 set notification.Date = $zdatetime($horolog, 3)   
 set notification.Result = "VALIDATION-ERROR"
 set notification.Error = "Topic validation error " _ context.validationError

 do notification.%Save(0)]]>
</code>
</true>
<false>
<if name='Send notification' condition='context.hasToSendNotification' xpos='605' ypos='1100' xend='605' yend='1950' >
<true>
<switch name='NotificationType' xpos='875' ypos='1250' xend='875' yend='1500' >
<case condition='request.isPushNotification()' name='Push' >
<code name='Calculate text' xpos='1010' ypos='1400' >
<annotation><![CDATA[Decide whether push notification has to be sent or not.
Pull notifications must always be sent.]]></annotation>
<![CDATA[ if request.Text = "" {
 
     $$$ThrowOnError(##class(IBSP.Notice.Utils).GetTextParamsAsArray(request.TextParams, .params))
 
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

         if request.Topic.TemplateMsg '= "" {
             $$$ThrowOnError(##class(IBSP.Notice.Utils).GetTopicText(request.Topic, request.Subscriber.Lang, .params, .text))
             set params("msg") = text
         }
         if request.Topic.BodyTemplate '= "" {
             $$$ThrowOnError(##class(IBSP.Notice.Utils).GetTopicBody(request.Topic, .params, .text))
         }
            
     } else {
         $$$ThrowOnError(##class(IBSP.Notice.Utils).GetTopicText(request.Topic, request.Subscriber.Lang, .params, .text))
     }
     set request.Text = text
 }]]>
</code>
</case>
<default name='default' />
</switch>
<switch name='Outbound Adapter' xpos='875' ypos='1600' xend='875' yend='1850' >
<case condition='$zconvert(context.outboundAdapter, "L") = "telegram"' name='Telegram' >
<code name='Send Telegram Notification' xpos='1010' ypos='1750' >
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
<code name='Send Email Notification' xpos='1280' ypos='1750' >
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
<code name='Send HTTP/SMS Notification' xpos='1550' ypos='1750' >
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
<false>
<assign name="Vallidation not passed" property="response.result" value="&quot;Topic validation not passed&quot;" action="set" xpos='605' ypos='1250' />
<code name='Create Notification' xpos='605' ypos='1350' >
<![CDATA[ set notification = ##class(IBSP.Notice.DAT.Notification).%New()
 set notification.Topic = request.Topic
 set notification.Element = request.Element
 set notification.BusinessOperation = ""
 set notification.NotificationType = request.NotificationType
 set notification.Subscriber = request.Subscriber
 set:(request.Token '= "") notification.DirectData = request.Token _ "|||"
 set notification.DirectData = notification.DirectData _ request.ContactWayAddress
 set notification.Text = request.Text
 set notification.Date = $zdatetime($horolog, 3)   
 set notification.Result = "VALIDATION-NOT-SENT"
 set notification.Error = "Topic validation not passed"

 do notification.%Save(0)]]>
</code>
</false>
</if>
</false>
</if>
</true>
</if>
</foreach>
</sequence>
</process>
}

}
