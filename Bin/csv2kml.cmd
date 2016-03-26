@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
::**********************************************************************
SET $NAME=%~n0
SET $DESCRIPTION=Convert CSV file to KML
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
::@(#)  Simple mapping of 
::@(#)      $GPSLatitude;$GPSLongitude;$Code;$Province-State;$City;$Location;$Elevation;$Note
::@(#)  to: 
::@(#)   <Placemark>
::@(#)       <name>%_LineNo%_%$location%</name>
::@(#)       <description>country;state;city;location;elevation;note</description>
::@(#)       <Point>
::@(#)          <coordinates>longitude, latitude, 0,0</coordinates>
::@(#)       </Point>
::@(#)   </Placemark>
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
  SET $VERSION=2016-03-25&SET $REVISION=22:33:00&SET $COMMENT=Initial/ErikBachmann
::**********************************************************************
::@(#){COPY}%$VERSION:~0,4% %$Author%
::**********************************************************************
::ENDLOCAL

:Init
    ECHO;%$NAME% v. %$VERSION%
    SET _Input=%~1
    ::SET _Contries=DEU DNK GBR GRL NLD NOR SWE USA
    ::SET _Contries=DE DK GB GR NL NO SE US
    SET _Contries=DK

    SET _lineNo=0

:Process
    FOR %%a IN (%_Contries%) DO CALL :WriteHeader %%a
    
    FOR /F "skip=1 DELIMS=; Tokens=1,2,3,4,5,6,7,8,9*" %%a IN ( %_input% ) DO Call :writePos "%%a" "%%b" "%%c" "%%d" "%%e" "%%f" "%%g" "%%h" "%%i"
    
    FOR %%a IN (%_Contries%) DO CALL :WriteFooter %%a

    ECHO:Lines processd: %_lineNo%
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
    (
        ECHO:           ^<Placemark^>
        REM ECHO:               ^<name^>%_LineNo%_%~6^</name^>
        ECHO:               ^<name^>%_LineNo%_%$location%^</name^>
        REM                              3       4     5    6        7         8
        REM                             country;state;city;location;elevation;note
       rem ECHO:               ^<description^>%~3;%~4;%~5;%~6;%~7;%~8^</description^>
       ECHO:               ^<description^>%~3;%~4;%~5;%$location%;%~7;%$note:~0,-1%^</description^>
        ECHO:               ^<Point^>
        REM                                   longitude, latitude	
        ECHO:                   ^<coordinates^>%~2, %~1, 0,0^</coordinates^>
        ECHO:               ^</Point^>
        ECHO:           ^</Placemark^>
    )>> "%~3.kml" 
    ENDLOCAL
GOTO :EOF   *** :WritePos ***

::---------------------------------------------------------------------

:WriteHeader
    ::ECHO WriteHeader [%~1]
    
    (
        ECHO:^<^?xml version='1.0' encoding='UTF-8'^?^>
        ECHO:^<kml xmlns='http://www.opengis.net/kml/2.2'^>
        ECHO:   ^<Document^>
        ECHO:       ^<name^>%~1^</name^>
        ECHO:       ^<description^>Beskrivelse af kort %~1^</description^>
        ECHO:       ^<Folder^>
        ECHO:           ^<name^>%~1.kml^</name^>
    ) > "%~1.kml"
ECHO:
GOTO :EOF   *** :WriteHeader ***

::---------------------------------------------------------------------

:WriteFooter
    ::ECHO WriteFooter [%~1]
    (
        ECHO:       ^</Folder^>
        ECHO:   ^</Document^>
        ECHO:^</kml^>
    ) >> "%~1.kml"
GOTO :EOF   *** :WriteFooter ***

::*** End of File *****************************************************