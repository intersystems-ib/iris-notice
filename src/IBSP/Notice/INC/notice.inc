ROUTINE notice [Type=INC]

#; Status codes
#define ERRORSTATUS 0

#; UsedID types
#define CIP "cip"

#; ContactWay types
#define ApplicationId "applicationid"

#; Topics
#define AppTauliTopic "AppTauli"
#define isAppTauliTopic(%t) ($$$toUpperCase(%t) = $$$toUpperCase($$$AppTauliTopic))
#define buildValidTopic(%t) set:($find(%t, ".") = 0) %t = %t _ "." set:($$$getLastChar(%t) = ".") %t = %t _ "*"

#; Utils
#define getLastChar(%s) $extract(%s, *)
#define getLastTwoChars(%s) $extract(%s, *-1, *)
#define ValidCIPRegularExpression "\D{4}[0-1]\d{9}"
#define toUpperCase(%s) $zconvert(%s, "U")