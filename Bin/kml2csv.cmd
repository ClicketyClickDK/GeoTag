@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
::**********************************************************************
SET $NAME=%~n0
SET $DESCRIPTION=Convert KML file to CSV
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
::@(#)   <Placemark>
::@(#)       <name>%_LineNo%_%$location%</name>
::@(#)       <description>country;state;city;location;elevation;note</description>
::@(#)       <Point>
::@(#)          <coordinates>longitude, latitude, 0,0</coordinates>
::@(#)       </Point>
::@(#)   </Placemark>
::@(#) 
::@(#)  to: 
::@(#)      $GPSLatitude;$GPSLongitude;$Code;$Province-State;$City;$Location;$Elevation;$Note
::@(#) 
::@ (#)EXAMPLES
::@(-)  Some examples of common usage.
::@(#)  kml2csv.cmd ebp.kml > out.csv
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

SET $DESCRIPTION=
(
    ECHO:%$NAME%
    ECHO:-- %$DESCRIPTION%
    ECHO:
)>&2

:: kml2csv.cmd ebp.kml >out.csv
    SET _lineNo=0
    
    ECHO:$GPSLatitude;$GPSLongitude;$Code;$Province-State;$City;$Location;$Elevation;$Note

    FOR /F "delims=¤" %%a IN ('type %1') DO CALL :parsekml "%%a"
GOTO :EOF

::---------------------------------------------------------------------

:parsekml
    SET STR=%1
    SET STR=%STR:<=[%
    SET STR=%STR:>=]%
    SET STR=%STR:!=.%
    SET STR=%STR:~1,-1%

    :: Remove leading blanks
    for /f "tokens=* " %%a in ("%str%") do set str=%%a

    IF /I "[name]"=="%str:~0,6%" SET _NAME=%STR:~6,-7%

    ::[description][![CDATA[54.8879381800194 10.4121851899972        N       E       8       ;       DNK     Denmark DK-5970 ├år├©sk├©bing   ├år├©sk├©bing   ├år├©sk├©bing   Kirke;]]][/description]
    IF /I "[description]"=="%str:~0,13%" (
        SET _DESC=%str:~13,-14%
        IF "[[CDATA["=="!_Desc:~0,8!" SET _DESC=!_Desc:~8,-3!
    )

    IF /I "[coordinates]"=="%str:~0,13%" FOR /F "delims=, tokens=1,2" %%b IN ("%STR:~13,-14%") DO SET _COOR=%%c;%%b

    IF /I "[/Placemark]"=="%str:~0,13%" (
        ECHO:%_Coor: =%;%_desc%
        CALL SET /A _LineNo+=1
        TITLE %$NAME%: [!_LineNo!] %_name%
    )

GOTO :EOF   *** :parsekml ***

::*** End of File *****************************************************