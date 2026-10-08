ROUTINE RESTUtils.INC.Search [Type=INC]
#Include RESTUtils.INC.Providers

##; Internal avoid calling it from outside the package
#Define IntSearchTable(%table, %filter, %size, %page, %order, %total, %query, %replaced, %options) $CLASSMETHOD($$$SearchLogicImplementationClass, "IntSearchTable", %table, %filter, %size, %page, %order, %total, %query, %replaced, %options)

##; Call to search
#Define SearchClassMethod(%class, %filter, %amount, %query, %replaced, %options) $CLASSMETHOD($$$SearchClass, "SearchClass", %class, %filter, %amount, %query, %replaced, %options)