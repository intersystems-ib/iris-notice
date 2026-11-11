Class IBSP.Notice.BO.RetrieveData.SQLBusinessOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

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

Method GetData(request As Ens.Request, Output response As Ens.StringContainer) As %Status
{
	set sc = $$$OK

	try {

        if (..Adapter.DSN = "") {
            $$$ThrowOnError(..GetDataFromLocalDB(.params))
        } else {
            $$$ThrowOnError(..GetDataFromExternalDB(.params))
        }

        set response = ##class(Ens.StringContainer).%New(params.%ToJSON())
	} catch ex {
        set sc = ex.AsStatus()
	}

	quit sc
}

Method GetDataFromLocalDB(Output params As %DynamicObject) As %Status [ Internal, Private ]
{
    set sc = $$$OK

	try {
		
        set params = {}

        // Execute query with single values
		if (..Query '= "") { 

            set result = ##class(%SQL.Statement).%ExecDirect(, ..Query)
            if (result.%Next()) {
                
                set metadata = result.%GetMetadata()
                for i = 1: 1: metadata.columnCount { // loop over columns

                    set columnName = $zcvt(metadata.columns.GetAt(i).colName, "l")
                    set params = params.%Set(columnName, result.%GetData(i))
                }
            }
            
            set result = ""
        }
		
		// Execute query with multiple rows
        if (..QueryROWS '= "") {

            set result = ##class(%SQL.Statement).%ExecDirect(, ..QueryROWS)
            set params.rows = []
            while result.%Next() { // loop over records

                set metadata = result.%GetMetadata()
                set row = {}

                for i = 1: 1:  metadata.columnCount { // loop over columns

                    set columnName = $zcvt(metadata.columns.GetAt(i).colName, "l")
                    set row = row.%Set(columnName, result.%GetData(i))
                }

                do params.rows.%Push(row)
            }
        }
	} catch ex {
		set sc = $$$OK
	}

	quit sc
}

Method GetDataFromExternalDB(Output params As %DynamicObject) As %Status [ Internal, Private ]
{
    set sc = $$$OK

	try {

        set params = {}

		// Execute query with single values
		if (..Query '= "") { 

			$$$ThrowOnError(..Adapter.ExecuteQuery(.result, ..Query))
			if (result.%Next()) { // just checks first record

                for i = 1: 1: result.GetColumnCount() {// loop over columns

                    set columnName = $zcvt(result.GetColumnName(i), "l")
                    set params = params.%Set(columnName, result.GetData(i))
                }
            }
			set result = ""
		}
		
		// Execute query with multiple rows
		if (..QueryROWS '= "") { 

			$$$ThrowOnError(..Adapter.ExecuteQuery(.result, ..QueryROWS))
            set params.rows = []
			while result.%Next() {// loop over records

                set row = {}
				for i = 1: 1: result.GetColumnCount() { // loop over columns

                    set columnName = $zcvt(result.GetColumnName(i), "l")
                    set row = row.%Set(columnName, result.GetData(i))
				}
                do params.rows.%Push(row)
			}
		}
	} catch ex {
        set sc = ex.AsStatus()
	}

	quit sc
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Ens.Request"> 
		<Method>GetData</Method>
	</MapItem>
</MapItems>
}

}
