ROUTINE RESTUtils.INC.Authorization [Type=INC]
#Include RESTUtils.INC.Providers

#Define UserIsAllowed(%class, %endpoint) $CLASSMETHOD($$$AuthService, "UserIsAllowed", %class, %endpoint)
#Define GetEverythingUserIsAllowed $CLASSMETHOD($$$AuthService, "GetEverythingUserIsAllowed")
#Define DefaultMappingNameKey "DEFAULT"
#Define AuthPersistanceTable $CLASSMETHOD($$$AuthPersistance,"GetSQLTable")