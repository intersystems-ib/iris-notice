Class IBSP.Notice.Request.NoticeRequest Extends (%Persistent, Ens.Request, %XML.Adaptor, %JSON.Adaptor) [ Abstract, NoExtent ]
{

Property Topic As IBSP.Notice.DAT.Topic;

Property Text As %String(MAXLEN = 4000);

Property TextParams As %String(MAXLEN = "");

Property Token As %String;

Property Element As %String;

Property Subscriber As IBSP.Notice.DAT.Subscriber;

Property Error As %String(MAXLEN = 4096);

Property UserIdCode As %String;

Property UserIdType As %String;

Property ContactWayAddress As %String(MAXLEN = 100);

Property NotificationType As %String(VALUELIST = ",PUSH,PULL");

Method isPushNotification() As %Boolean
{
    quit "PUSH" = ..NotificationType
}

Method isPullNotification() As %Boolean
{
    quit "PULL" = ..NotificationType
}

}
