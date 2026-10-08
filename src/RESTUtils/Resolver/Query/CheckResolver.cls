Include RESTUtils.INC.Query.Regexp

Class RESTUtils.Resolver.Query.CheckResolver
{

ClassMethod CheckTable(table As %String(MAXLEN="")) As %Boolean [ Internal ]
{
    Return $MATCH(table, "^[a-zA-Z0-9]{2,50}(\_[a-zA-Z0-9]{2,50}){0,10}\.[a-zA-Z0-9]{2,50}$")
}

ClassMethod CheckOrderBy(orderBy As %String(MAXLEN="")) As %Boolean [ Internal ]
{
    Return $MATCH(orderBy, "^([A-Za-z1-9]{1,50}\.)?[A-Za-z1-9]{2,50}(->[A-Za-z1-9]{2,50}){0,2} (asc|desc)(,([A-Za-z1-9]{1,50}\.)?[A-Za-z1-9]{2,50}(->[A-Za-z1-9]{2,50}){0,2} (asc|desc)){0,2}$")
}

ClassMethod CheckColumn(column As %String(MAXLEN=""), isSelectColumn As %Boolean = 0, Output noExact As %Boolean = 0) As %Boolean [ Internal ]
{
    If (isSelectColumn){
        If ($MATCH(column, $$$SelectFunctionColumnREGEXP)){
            Set noExact = 1
            Return 1
        }
        Return $MATCH(column, $$$SelectColumnREGEXP)
    }
    Return ..CheckSimpleColumn(column)
}

ClassMethod CheckSimpleColumn(column As %String(MAXLEN="")) As %Boolean
{
    Return $MATCH(column, $$$ColumnREGEXP)
}

}
