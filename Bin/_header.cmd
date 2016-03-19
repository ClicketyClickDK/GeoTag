:Header
    ECHO:%$NAME% v. %$VERSION% r. %$REVISION%
    ECHO:- %$DESCRIPTION%
    ::ECHO:/ %$AUTHOR%
    IF DEFINED _LogFile   ECHO:%$NAME% v. %$VERSION% r. %$REVISION% - %_StartTime%>>"%_LogFile%"
    IF DEFINED _TraceFile ECHO:%$NAME% v. %$VERSION% r. %$REVISION% - %_StartTime%>>"%_TraceFile%"
GOTO :EOF