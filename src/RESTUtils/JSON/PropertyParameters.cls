Class RESTUtils.JSON.PropertyParameters
{

/// If enabled it allows to update the referenced object when updating this one, else it only allows to change the reference, by default false.
Parameter %JSONCASCADECHANGES As BOOLEAN = 0;

/// If enabled, when the referenced object is passed with a null Id field it will be created, by default true.
Parameter %JSONCREATEONNULL As BOOLEAN = 1;

Parameter %JSONMAXSTREAMCHARS As INTEGER = 1000000;

}
