Include (RESTUtils.INC.Status, RESTUtils.INC.OptionsKeys, RESTUtils.INC.Content.Export, RESTUtils.INC.Utils, RESTUtils.INC.Modification, RESTUtils.INC.Language.Errors)

Class RESTUtils.Service.Modification.ModificationService
{

// ************ Object modification ************* //

ClassMethod Update(class As %String(MAXLEN=""), Id As %Numeric, object As %DynamicObject, ByRef options = "") As %DynamicObject
{
    Do ..IntUpdate(class, Id, object, .options)
    Return $$$ExportSingleObjectToJSON(class, Id, .options)
}

ClassMethod Create(class As %String(MAXLEN=""), object As %DynamicObject, ByRef options = "") As %DynamicObject
{
    Set Id = ..IntUpdate(class, "", object, .options)
    Return $$$ExportSingleObjectToJSON(class, Id, .options)
}

ClassMethod IntUpdate(class As %String(MAXLEN=""), Id As %Numeric = "", object As %DynamicObject, ByRef options = "") [ Internal ]
{
    Try{
        Set JSONMappingName = $GET(options($$$OPUPDATEJSONMAPPINGNAME), "")
        TSTART
        If (Id '= ""){
            ///Do not swap namespace since we call a utils method
            Set obj = $$$GetByIdOrIndex(class, Id, .options)
            THROW:(obj = "") $$$ObjectNotFound
        }
        $$$SwapNamespace(options)
        If (Id=""){
            $$$OnErrorThrow(..GetNewObject(class, .obj),$$$FailureCreatingObject)
        }
        //Import
        $$$WrapInCatch($$$ThrowOnError(obj.%JSONImport(object, JSONMappingName)), "Error importing: ", $$$BADREQUEST)

        //Save
        $$$WrapInCatch($$$ThrowOnError(obj.%Save(0)) Set Id = obj.%Id(),  "Error saving: ", $$$BADREQUEST)

        TCOMMIT
    }Catch e {
        ///Ensure that any exception rollsback the transaction, then throw it again
        TROLLBACK
        THROW e
    }
    Return Id
}

/// This is a required workaround, since when macros receive code as an argument remove all spaces in the given code, making us unable to have
/// for example: set object =$CLASSMETHOD(class, "%New") since it ends up being: setobject=$CLASSMETHOD(class,"%New") which is not a valid
/// objectscript expression
ClassMethod GetNewObject(class As %String(MAXLEN=""), Output object As %Persistent) As %Status
{
    Set object = $CLASSMETHOD(class, "%New")
    Return object '= ""
}

ClassMethod Delete(class As %String(MAXLEN=""), Id As %Numeric = "", ByRef options = "") [ Internal ]
{
    Try{
        TSTART
        $$$SwapNamespace(options)
        Set obj = $$$GetByIdOrIndex(class, Id, .options)
        THROW:(obj = "") $$$ObjectNotFound
        #DIM obj As %Persistent
        $$$WrapInCatch($$$ThrowOnError($CLASSMETHOD(class, "%DeleteId", obj.%Id())), "Error deleting: ", $$$BADREQUEST)
        TCOMMIT 
    }Catch e {
        TROLLBACK
        THROW e
    }
}

}
