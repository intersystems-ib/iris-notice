ROUTINE RESTUtils.INC.Modification [Type=INC]
#Include RESTUtils.INC.Providers

#Define UpdateInstance(%class, %id, %object, %options) $CLASSMETHOD($$$ModificationClass, "Update", %class, %id, %object, %options)

#Define CreateInstance(%class, %object, %options) $CLASSMETHOD($$$ModificationClass, "Create", %class, %object, %options)

#Define DeleteInstance(%class, %id, %options) $CLASSMETHOD($$$ModificationClass, "Delete", %class, %id, %options)
#Include RESTUtils.INC.Utils