ROUTINE RESTUtils.INC.Filters [Type=INC]
#Include RESTUtils.INC.Providers

##; TODO move to RESTUtils.INC.REST.Providers

##;Utils used to obtain and check filter modifiers
#Define GetModifier(%modifiers, %name, %default) $CLASSMETHOD($$$FilterResolver,"GetModifier", %modifiers, %name, %default)
#Define HasModifier(%modifiers, %name) $CLASSMETHOD($$$FilterResolver, "HasModifier", %modifiers, %name)

##;Method called to convert a filter object to a where + arguments to query
#Define FiltersToWhereClause(%where, %args, %filter) $CLASSMETHOD($$$FilterResolver, "FiltersToWhereClause", %where, %args, %filter)

##; Allows to have an OR condition in a query, to use it set a key of the object to $$$OR and have the value of that key be
##; an object with filters defined inside
#Define OR "$$$OR"

##; Same but and
#Define AND "$$$AND"