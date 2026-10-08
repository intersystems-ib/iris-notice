ROUTINE RESTUtils.INC.Status [Type=INC]

##; TODO change to RESTUtils.INC.REST.Status

##; Status we handle, this will display as an error regardless of environment
#Define BADREQUEST -400
#Define NOTFOUND -404
#Define NOTSUPPORTED -415
#Define FORBIDDEN -403
#Define INTERNALERROR -500

##; Add any errors that are handled
#Define IsHandled(%exception) (($$$BADREQUEST=%exception.Code)||($$$NOTFOUND=%exception.Code)||($$$NOTSUPPORTED=%exception.Code)||($$$FORBIDDEN=%exception.Code))

##; If a system is Development we can have verbose errors, else avoid displaying too much info
#If ($SYSTEM.Version.SystemMode()="DEVELOPMENT")||($SYSTEM.Version.SystemMode()="")
    #Define IsDev 1
#Else
    #Define IsDev 0
#EndIf