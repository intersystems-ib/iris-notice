Class IBSP.Notice.BO.RetrieveData.SQLBusinessOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Parameter TopicErrorNotAvailable = "Errors.NotAvailable";

Parameter TopicErrorResponseTooLong = "Errors.ResponseTooLong";

Property Adapter As EnsLib.SQL.OutboundAdapter;

/// This query must return only one row (may have several columns)
Property Query As %String(MAXLEN = "");

/// This query must be fulfilled in case it returns several records
/// It will fill ROWS parameter to be shown in the message.
/// ROWS will have a header with the name of the columns (in the same order as the query) and a row for each record returned by the query
Property QueryROWS As %String(MAXLEN = "");

Parameter SETTINGS = "Query:Basic,QueryROWS:Basic";

Parameter INVOCATION = "Queue";

Parameter RESPONSETEXTMAXLENGTH = 4000;

/// This is the default message handler.  All request types not declared in the message map are delivered here
Method OnMessage(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
	#dim tResult as %ResultSet
	set tSC = $$$OK
	try {
		set pResponse = ##class(IBSP.Notice.Messages.DirectDeliverReq).%New()
		set pResponse.Topic = pRequest.Topic.TopicKey
		
		Set queryToExecute = ..Query
		Set queryRowsToExecute = ..QueryROWS
		Set receivedParams = pRequest.Parameters
		if (receivedParams'="") {
			FOR i=1:1:$length(receivedParams, " ") {				
				Set queryToExecute = $replace(queryToExecute, "##PARAM"_i_"##", $piece(receivedParams, " ", i))	
				Set queryRowsToExecute = $replace(queryRowsToExecute, "##PARAM"_i_"##", $piece(receivedParams, " ", i))	
			}
		
		}
		// Execute query with single values
		if ..Query '= "" { 
			$$$ThrowOnError(..ExecuteQuery(.tResult, queryToExecute))
			$$$ThrowOnError(tResult.%Next()) // just checks first record
			for i=1:1:tResult.GetColumnCount() // loop over columns
			{
				set values(tResult.GetColumnName(i)) = tResult.GetData(i)
			}
			set tResult = ""
		}
		
		// Execute query with multiple rows
		if ..QueryROWS '= "" { 
			$$$ThrowOnError(..ExecuteQuery(.tResult, queryRowsToExecute))
			while tResult.%Next() // loop over records
			{
				for i=1:1:tResult.GetColumnCount() // loop over columns
				{
					set values(i_":"_tResult.GetColumnName(i)) = $g(values(i_":"_tResult.GetColumnName(i))) _ $case($g(values(i_":"_tResult.GetColumnName(i)))="", 1:"",:"|") _ tResult.GetData(i)
				}
			}
			set values("ROWS") = ""
			do ..AddROWS(.values)
		}

		set language = pRequest.Subscriber.Lang
		
		$$$ThrowOnError(##class(IBSP.Notice.Utils).GetTopicText(pRequest.Topic, language, .values, .text))

		if ($length(text) > ..#RESPONSETEXTMAXLENGTH) {

			set topicKey = ..#TopicErrorResponseTooLong
			set pResponse.Topic = topicKey
			set topic = ##class(IBSP.Notice.DAT.Topic).UITopicKeyOpen(topicKey)
			$$$ThrowOnError(##class(IBSP.Notice.Utils).GetTopicText(topic, language, , .text))
		}
		
		set pResponse.Text = text
	} catch ex {
		#dim ex as %Exception.AbstractException
		// ERROR #5821: Cannot instantiate query: 'SQLCODE = -461, %msg = Connection error'
		$$$LOGERROR(ex.DisplayString())
		set tSC = $$$OK // $$$LOGERROR, but return message by setting BO Status as OK
		set pResponse.Error = ex.DisplayString()
		set topicKey = ..#TopicErrorNotAvailable
		set pResponse.Topic = topicKey
		set language = pRequest.Subscriber.Lang
		set topic = ##class(IBSP.Notice.DAT.Topic).UITopicKeyOpen(topicKey)
		$$$ThrowOnError(##class(IBSP.Notice.Utils).GetTopicText(topic, language, , .text))
		set pResponse.Text = text
	}
	Quit tSC
}

Method ExecuteQuery(ByRef RS As %ResultSet, queryStr As %String) As %Status
{
	set tSC = $$$OK
	try {
		if ..Adapter.DSN="" // Query to tables with access within the namespace
		{
			Set tResult=##class(%ResultSet).%New("%DynamicQuery:SQL")
			$$$ThrowOnError(tResult.Prepare(queryStr))
			$$$ThrowOnError(tResult.Execute())
		}
		else // Do the query using the Adapter
		{
			$$$ThrowOnError(..Adapter.ExecuteQuery(.tResult,queryStr))
		}
		set RS = tResult
	}catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

ClassMethod AddROWS(ByRef values) As %Status
{
	set key = ""
	set header = ""
	set row = ""
	set colsep = " • " // column separator
	set eol = $c(10)
	do {
		set key = $order(values(key))
		quit:key=""

		// continue to next value if it is not value form queryROWS
		continue:'$find(key,":")
		// set header
		set header = header _ $case(header="",1:"",:colsep) _ $tr($p(key,":",2),"_"," ")
		// set each row
		for r = 1:1:$l(values(key),"|") {
			set row(r) = $g(row(r)) _ $case($g(row(r))="",1:"",:colsep) _ $p(values(key),"|",r)
		}
	}while key '= ""
	
	if $order(row("")) '= "" // set "ROWS" if exists rows
	{
		//Format header (underline & bold): __\* + header + \*__ + \n
		set header = "__*" _ header _ "*__" _ eol
		
		set values("ROWS") = header
		set key = ""
		do {
			set key = $order(row(key))
			quit:key=""
			
			set row(key) = ..BoldSubstr(row(key), colsep)
			set values("ROWS") = values("ROWS") _ row(key) _ eol
		}while key '= ""
	}
}

/// Emphasize (MarkdownV2) every substrtobold found in str
/// Example: ..BoldSubstr("how:are:you?", ":") -> "how*:*are*:*you?"
ClassMethod BoldSubstr(str As %String, substrtobold As %String) As %String
{
	set substrBolded = "*" _ substrtobold _ "*"
	set start = 1
	set strout = ""
	do {
		set end = $find(str,substrtobold,start)
		if end '= 0 {
			set chunk = $extract(str,start,end-$l(substrtobold)-1) _ substrBolded
		}else{
			set chunk = $extract(str,start,*)
		}
		set strout = strout _ chunk
		set start = end
	}while end > 0
	
	quit strout
}

}
