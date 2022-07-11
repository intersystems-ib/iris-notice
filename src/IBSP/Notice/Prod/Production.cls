Class IBSP.Notice.Prod.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="IBSP.Notice.Prod.Production" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="IBSP.Notice.BS.REST.NotifyBusinessService" Category="" ClassName="IBSP.Notice.BS.REST.NotifyBusinessService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="IBSP.Notice.BP.REST.ActionManager" Category="" ClassName="IBSP.Notice.BP.REST.ActionManager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="IBSP.Notice.BP.Publisher" Category="" ClassName="IBSP.Notice.BP.Publisher" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="REST Test" Category="" ClassName="IBSP.Notice.BO.RESTDeliver" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="SSLCheckServerIdentity">0</Setting>
    <Setting Target="Adapter" Name="Credentials">superuser</Setting>
    <Setting Target="Adapter" Name="HTTPPort">52773</Setting>
    <Setting Target="Adapter" Name="HTTPServer">localhost</Setting>
    <Setting Target="Adapter" Name="URL">notice/api/test</Setting>
  </Item>
  <Item Name="IBSP.Notice.API.NOT.Command.BS" Category="" ClassName="IBSP.Notice.API.NOT.Command.BS" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="JavaGateway" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="JavaHome">/usr</Setting>
  </Item>
  <Item Name="IBSP.Notice.BP.Telegram.CommandManager" Category="" ClassName="IBSP.Notice.BP.Telegram.CommandManager" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="IBSP.Notice.BO.EmailDeliver" Category="" ClassName="IBSP.Notice.BO.EmailDeliver" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="IBSP.Notice.BO.TelegramDeliver" Category="" ClassName="IBSP.Notice.BO.TelegramDeliver" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="DefaultFormat">MarkdownV2</Setting>
    <Setting Target="Adapter" Name="HTTPPort">3443</Setting>
    <Setting Target="Adapter" Name="HTTPServer">ibtools.iscinternal.com</Setting>
    <Setting Target="Adapter" Name="SSLCheckServerIdentity">0</Setting>
    <Setting Target="Adapter" Name="SSLConfig">SSL</Setting>
    <Setting Target="Adapter" Name="URL">/app/telegram/sendMessage</Setting>
  </Item>
  <Item Name="SQL Test" Category="" ClassName="IBSP.Notice.BS.RetrieveData.SQLBusinessService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Query">select code As employeeid
from IBSP_Notice_DAT.ContactWay
where Type = "employeeid"</Setting>
    <Setting Target="Host" Name="Topic">Workday.NotFilled.Telegram</Setting>
    <Setting Target="Adapter" Name="JGService">JavaGateway</Setting>
    <Setting Target="Adapter" Name="KeyFieldName"></Setting>
    <Setting Target="Adapter" Name="MaxVarCharLengthAsString"></Setting>
    <Setting Target="Adapter" Name="DSN">Local</Setting>
  </Item>
  <Item Name="IBSP.Notice.BS.RetrieveData.APIBusinessService" Category="" ClassName="IBSP.Notice.BS.RetrieveData.APIBusinessService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Body">{
  "name":"David",
  "surname":"Gonzalez",
  "dob":"05/03/1984",
  "cip":"GOBU0840305003",
  "phone":"677112507"
}</Setting>
    <Setting Target="Host" Name="Credentials">superuser</Setting>
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
    <Setting Target="Host" Name="HTTPPort">52773</Setting>
    <Setting Target="Host" Name="HTTPServer">localhost</Setting>
    <Setting Target="Host" Name="URL">notice/api/test</Setting>
    <Setting Target="Host" Name="Method">POST</Setting>
    <Setting Target="Host" Name="URLParams"><![CDATA[name=Lucía&surname=González&cip=GOCO1141130000]]></Setting>
  </Item>
  <Item Name="IBSP.Notice.BO.RetrieveData.HTTPBusinessOperation" Category="" ClassName="IBSP.Notice.BO.RetrieveData.HTTPBusinessOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Credentials"></Setting>
    <Setting Target="Adapter" Name="SSLCheckServerIdentity">0</Setting>
  </Item>
  <Item Name="IBSP.Notice.BO.RetrieveData.HTTPSBusinessOperation" Category="" ClassName="IBSP.Notice.BO.RetrieveData.HTTPBusinessOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Credentials"></Setting>
    <Setting Target="Adapter" Name="SSLCheckServerIdentity">0</Setting>
    <Setting Target="Adapter" Name="SSLConfig">SSL</Setting>
  </Item>
  <Item Name="SMS Deliver" Category="" ClassName="IBSP.Notice.BO.RESTDeliver" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="Credentials">SMS_Lleidanet</Setting>
    <Setting Target="Adapter" Name="HTTPPort">443</Setting>
    <Setting Target="Adapter" Name="HTTPServer">api.lleida.net</Setting>
    <Setting Target="Adapter" Name="SSLConfig">SSL</Setting>
    <Setting Target="Adapter" Name="URL">/sms/v2/</Setting>
  </Item>
</Production>
}

}
