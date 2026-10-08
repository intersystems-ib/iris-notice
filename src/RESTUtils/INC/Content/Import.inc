ROUTINE RESTUtils.INC.Content.Import [Type=INC]
#Include RESTUtils.INC.Providers

#Define ImportContent(%content, %type) $CLASSMETHOD($$$ImportResolver, "ImportData", %content, %type)