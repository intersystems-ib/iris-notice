ROUTINE RESTUtils.INC.Query.Check [Type=INC]
#Include RESTUtils.INC.Providers

#Define CheckTable(%table) $CLASSMETHOD($$$SearchCheckResolver, "CheckTable", %table)

#Define CheckOrderBy(%clause) $CLASSMETHOD($$$SearchCheckResolver, "CheckOrderBy", %clause)

#Define CheckColumn(%column, %isSelectColumn, %noExact) $CLASSMETHOD($$$SearchCheckResolver, "CheckColumn", %column, %isSelectColumn, %noExact)

#Define CheckSimpleColumn(%column) $CLASSMETHOD($$$SearchCheckResolver, "CheckSimpleColumn", %column)

