@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
::**********************************************************************
SET $NAME=%~n0
SET $DESCRIPTION=Convert CSV file into Load file
SET $AUTHOR=Erik Bachmann, ClicketyClick.dk [ErikBachmann@ClicketyClick.dk]
SET $SOURCE=%~f0
::@(#)NAME
::@(-)  The name of the command or function, followed by a one-line description of what it does.
::@(#)  %$NAME% -- %$DESCRIPTION%
::@(#) 
::@(#)SYNOPSIS
::@(-)  In the case of a command, a formal description of how to run it and what command line options it takes. 
::@(-)  For program functions, a list of the parameters the function takes and which header file contains its definition.
::@(-)  
::@(#)  %$NAME% [CSV-file] > [KML-file]
::@(#) 
::@ (#)OPTIONS
::@(-)  Flags, parameters, arguments (NOT the Monty Python way)
::@ (#)  -h      Help page
::@ (#) 
::@ (#) 
::@(#)DESCRIPTION
::@(-)  A textual description of the functioning of the command or function.
::@(#)  A CSV file is a primitive file used for convertion
::@(#)  A Load file must match the strucuture of allCountries.txt
::@(#) 
::@(#)  Simple mapping of 
::@(#)      $GPSLatitude;$GPSLongitude;$Code;$Province-State;$City;$Location;$Elevation;$Note
::@(#)  to: 
::@(#)      $Lbnr;$Location;$City;$Province-State;$GPSLatitude;$GPSLongitude;$fclass;fcode;$Code;cc2;admin1;admin2;admin3;admin4;population;$Elevation;$TimeZone;$Moddate;
::@(#) 
::@ (#)EXAMPLES
::@(-)  Some examples of common usage.
::@ (#) 
::@ (#) 
::@ (#) 
::@ (#)EXIT STATUS
::@(-)  Exit status / errorlevel is 0 if OK, otherwise 1+.
::@ (#)
::@ (#)ENVIRONMENT
::@(-)  Variables affected
::@ (#)
::@ (#)
::@ (#)FILES, 
::@(-)  Files used, required, affected
::@ (#)
::@ (#)
::@ (#)BUGS / KNOWN PROBLEMS
::@(-)  If any known
::@ (#)
::@ (#)
::@(#)REQUIRES
::@(-)  Dependencies
::@ (#)
::@ (#)SEE ALSO
::@(-)  A list of related commands or functions.
::@ (#)  
::@ (#)  
::@ (#)REFERENCE
::@(-)  References to inspiration, clips and other documentation
::@ (#)  Author:
::@ (#)  URL: 
::@ (#) 
::@ (#)
::@(#)SOURCE
::@(-)  Where to find this source
::@(#)  %$Source%
::@(#)
::@(#)AUTHOR
::@(-)  Who did what
::@(#)  %$AUTHOR%
::*** HISTORY **********************************************************
::SET $VERSION=YYYY-MM-DD&SET $REVISION=hh:mm:ss&SET $COMMENT=Description/init
  SET $VERSION=2016-03-25&SET $REVISION=22:40:00&SET $COMMENT=Initial/ErikBachmann
::**********************************************************************
::@(#){COPY}%$VERSION:~0,4% %$Author%
::**********************************************************************
::ENDLOCAL

::"99000000","Roskilde Cathedral","Roskilde Domkirke","","55.642649","12.080365","","","DK","","","265","","","0","","40","Europe/Copenhagen","2016-03-18"

:Init
    (
    ECHO;%$NAME% v. %$VERSION%
    )>&2
    SET _Input=%~1
    ::SET _Contries=DEU DNK GBR GRL NLD NOR SWE USA
    ::SET _Contries=DE DK GB GR NL NO SE US
    SET _Contries=DK

    ::starting at: 99000101
    SET _lineNo=100

:Process
    ::FOR %%a IN (%_Contries%) DO CALL :WriteHeader %%a
    
    ECHO:$Lbnr;$Location;$City;$Province-State;$GPSLatitude;$GPSLongitude;-;$Code;-;-;-;-;-;$Elevation;-;$TimeZone;$Moddate
    FOR /F "skip=1 DELIMS=; Tokens=1,2,3,4,5,6,7,8,9*" %%a IN ( %_input% ) DO Call :writePos "%%a" "%%b" "%%c" "%%d" "%%e" "%%f" "%%g" "%%h" "%%i"
    
    ::FOR %%a IN (%_Contri:es%) DO CALL :WriteFooter %%a

    ECHO:Lines processed: %_lineNo%>&2
GOTO :EOF   *** :Process ***

::---------------------------------------------------------------------

:WritePos
    SET /A _LineNo+=1
    SETLOCAL
    REM ECHO:%~1/%2_%~3;%~4;%~5;%~6;%~7;%~8;%~9.
    REM SET $GPSLatitude
    REM SET $GPSLongitude
    REM SET $Code
    REM SET $Province-State
    REM SET $City
    SET $Location=%~6
    SET $Location=%$Location:(=[%
    SET $Location=%$Location:)=]%
    SET $Note=%~8.
    SET $Note=%$Note:(=[%
    SET $Note=%$Note:)=]%
    REM SET $Elevation
    
    TITLE %$NAME%[%_lineNo%] %~3 %~6 %~8
    SET _lbr=0000000%_lineNo%
    SET _lbr=99%_lbr:~-6%
    
::Lbnr	$Location	$City	$Province-State	$GPSLatitude	$GPSLongitude	?	$Code	?	?	?	?	?	$Elevation	?	Europe/Copenhagen	%DATE%
::$Lbnr	$Location	$City	$Province-State	$GPSLatitude	$GPSLongitude	$fclass	fcode	$Code	cc2	admin1	admin2	admin3	admin4	population	$Elevation	gtopo30	$TimeZone	$Moddate	

    ECHO:%_Lbr%;%~6;%~5;%~4;%~1;%~2;-;-;%~3;-;-;-;-;-;-;%~7-;-;Europe/Copenhagen;%DATE%

    ENDLOCAL
GOTO :EOF   *** :WritePos ***

::*** End of File *****************************************************