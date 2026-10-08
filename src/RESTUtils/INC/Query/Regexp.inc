ROUTINE RESTUtils.INC.Query.Regexp [Type=INC]
##;TODO Move the allowed operations to a definition, this should be editable
#Define SelectAllowedOperations "(SUM|COUNT|AVG)"

#Define OldSelectColumnREGEXP "^(([A-Za-z0-9]{1,50}\.)?[A-Za-z0-9]{2,50}?(->[A-Za-z0-9]{2,50}){0,2}( As [A-Za-z0-9\.]{2,50})?|\*)$"

#Define BaseColumnRegexp "[A-Za-z0-9]{2,50}?(->[A-Za-z0-9]{2,50}){0,2}"
#Define FunctionColumnRegexp $$$SelectAllowedOperations_"\("_$$$BaseColumnRegexp_"\)"
#Define LiteralColumnRegexp "'[a-zA-Z\.\,_\- 0-9\(\)]{1,30}'"
#Define PlainColumn "(("_$$$BaseColumnRegexp_")|("_$$$FunctionColumnRegexp_")|("_$$$LiteralColumnRegexp_"))"
#Define AliasRegexp "( As [A-Za-z0-9\.]{2,50})?"



#Define SelectFunctionColumnREGEXP "^"_$$$SelectAllowedOperations_"\((DISTINCT )?((([A-Za-z0-9]{1,50}\.)?[A-Za-z0-9]{2,50}?(->[A-Za-z0-9]{2,50}){0,2}\)( As [A-Za-z0-9\.]{2,50})?)|\*\))$"

#Define IntAliasRegexp "( As [A-Za-z0-9\.]{2,50})?"
#Define IntAllRegexp "(\*)"
#Define IntTableSpecRegexp "([A-Za-z0-9]{1,50}\.)?"
#Define IntColumnRegexp "([A-Za-z0-9]{2,50}?)"
#Define IntColArrowRegexp "(->[A-Za-z0-9]{2,50}){0,2}"
#Define IntLiteralRegexp "('[a-zA-Z\.\,_\- 0-9\)\(\$]{1,30}')"
#Define IntDistinctRegexp "(DISTINCT )?"

#Define IntBaseColumnRegexp $$$IntTableSpecRegexp_$$$IntColumnRegexp_$$$IntColArrowRegexp

#Define IntSelectColumn "(("_$$$IntBaseColumnRegexp_")|("_$$$IntLiteralRegexp_")"_$$$IntAliasRegexp_")"

#Define IntSelectColumnREGEXP "^("_$$$IntSelectColumn_"|"_$$$IntAllRegexp_")$" 


##;Ideally this two ought to be the only ones that are actually used

#Define SelectColumnREGEXP "^(DISTINCT )?(((([A-Za-z0-9]{1,50}\.)?[A-Za-z0-9]{2,50}?(->[A-Za-z0-9]{2,50}){0,2})|('[a-zA-Z\.\,_\- 0-9\)\(\$]{1,30}'))( As [A-Za-z0-9\.]{2,50})?|\*)$"

#Define ColumnREGEXP "^([A-Za-z0-9]{1,50}\.)?[A-Za-z0-9]{2,50}?(->[A-Za-z0-9]{2,50}){0,2}$"


