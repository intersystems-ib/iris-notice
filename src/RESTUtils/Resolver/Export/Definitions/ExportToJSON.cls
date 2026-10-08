Include (RESTUtils.INC.OptionsKeys, RESTUtils.INC.Utils, RESTUtils.INC.ClassInfo)

Class RESTUtils.Resolver.Export.Definitions.ExportToJSON
{

ClassMethod Export(qres As %SQL.StatementResult, ByRef options, ByRef total As %Numeric = 0) As %DynamicArray [ Final, Internal ]
{
    $$$SwapNamespace(options)
    Set result = []
    Set columns = ..GetColumns(qres, $GET(options($$$OPNAMESPACE)), .columnExport)
    Set options($$$OUTCOLUMNTYPES) = columnExport
    If ($GET(options($$$OPCUSTOMEXPORTBODY)) '= ""){
        Set structure = options($$$OPCUSTOMEXPORTBODY)
        try{
            Set:(structure.%IsA("%DynamicObject")) result = {}
            while(qres.%Next()){
                If ('structure.%IsA("%DynamicObject")){
                    Do result.%Push(..ResolveBodyLevel(qres, structure.%Get(0), columns, columnExport))
                }Else{
                    D ..ResolveBodyLevel(qres, structure, columns, columnExport, 0, .result)
                }
            }
        }Catch e {
            Do qres.%Next()
            Return ..ResolveBodyLevel(qres, structure, columns, columnExport, 0)
        }
    }Else{
        while(qres.%Next()){
            Do result.%Push(..ExportAllColumns(qres, columns, columnExport))
        }
    }
    Return result
}

ClassMethod ExportAllColumns(qres As %SQL.StatementResult, columns As %DynamicObject, columnExport As %DynamicObject) As %DynamicObject
{
    Set obj = {}
    Set iter = columns.%GetIterator()
    while(iter.%GetNext(, .colKey)){
        Set value = qres.%Get(colKey)
        Set externalColType = columnExport.%Get(colKey, "")
        If (externalColType = "DATE"){
            Set value = $ZDATE(value, 3)
        }ElseIf (externalColType = "CLOB"){
            Try{
                If (value '= ""){
                    Set value = $CLASSMETHOD($LISTGET(value, 2), "%Open", value)
                }Else{
                    Set value = ""
                }
            }Catch e {
                THROW ##Class(%Exception.General).%New("Failure opening stream", $$$INTERNALERROR)
            }
        }        
        Do obj.%Set(colKey, value, ..FromExportToJSONType(externalColType, value))
    }
    Return obj
}

ClassMethod ResolveBodyLevel(qres As %SQL.StatementResult, structure As %DynamicAbstractObject, columns As %DynamicObject, columnExport As %DynamicObject, isArray As %Boolean = 0, ByRef result = "") As %DynamicAbstractObject
{
    Return:(structure = "") ""
    Return:(structure  = "@*@") ..ExportAllColumns(qres, columns, columnExport)
    try{
        D structure.%IsA("%DynamicAbstractObject")
    }Catch e {
        If (($EXTRACT(structure, 1, 1) = "@") && ($EXTRACT(structure, *, *) = "@")){
            Return qres.%Get($EXTRACT(structure, 2, *-1))
        }
        Return structure
    }
    
    If (result = ""){
        If (isArray){
            Set result = []
        }Else{
            Set result = {}
        }
    }
    
    Set iter = structure.%GetIterator()
    Set allValuesAreNull = 1
    while(iter.%GetNext(.key, .value, .valueType)){
        Try{ Set type = value.%IsA("%DynamicArray")}Catch e {Set type = 0}
        Set replacedValue = ..ResolveBodyLevel(qres, structure.%Get(key), columns, columnExport, type)
        Set:(replacedValue '= value) valueType = ""
        Set value = replacedValue
        If (value = ""){
            Set valueType = "null"
            ///TODO add option to add nulls
            continue
        }Else{
            Set allValuesAreNull = 0
        }
        
        If (isArray){
            Do result.%Push(value, valueType)
        }Else{
            ///Resolve key
            If (($EXTRACT(key, 1, 1) = "@") && ($EXTRACT(key, *, *) = "@")){
                Set key = qres.%Get($EXTRACT(key, 2, *-1))
            }
            Do result.%Set(key, value, valueType)
        }
    }
    Return:(allValuesAreNull) ""
    Return result
}

ClassMethod FromExportToJSONType(exportType As %String(MAXLEN=""), value) As %String(MAXLEN="")
{
    Return:(value = "") "null"
    Return:(exportType = "Bool") "boolean"
    Return:(exportType = "BIT") "boolean"
    Return:(exportType = "Number") "number"
    Return:(exportType = "NUMERIC") "number"
    Return:(exportType = "CLOB") "stream>base64"
    Return "string"
}

ClassMethod GetColumns(qres As %SQL.StatementResult, namespace As %String(MAXLEN="") = "", Output columnExport As %DynamicObject = {{}}) As %DynamicArray [ Final ]
{
    $$$SwapNamespace(namespace)
    Set columns = []
    Set forColumnExport = []
    Set list = qres.%GetMetadata().columns
    FOR{
        Set column = list.GetNext(.k)
        #DIM column As %SQL.StatementColumn
        quit:(k="")
        Set colName = column.colName
        Set colType = column.typeClass
        Set colIsIdentity = column.isIdentity
        Do columns.%Push(colName)
        Do forColumnExport.%Push({
            "colName":(colName),
            "colType":(colType),
            "colIsIdentity":(colIsIdentity)
        })
    }
    Set columnExport = {}
    Set iter = forColumnExport.%GetIterator()
    while(iter.%GetNext("", .column)){
        $$$SwapToInstallationNamespace
        Do columnExport.%Set(column.colName, $$$ToExternalType(column.colType, column.colIsIdentity, 0, ""))
    }
    Return columns
}

}
