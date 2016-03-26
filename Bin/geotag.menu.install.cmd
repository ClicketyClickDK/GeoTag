@ECHO OFF
REM.-- Prepare the Command Processor
::SETLOCAL ENABLEEXTENSIONS
::SETLOCAL ENABLEDELAYEDEXPANSION

REM URL: http://www.dostips.com/DtTipsMenu.php

::@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
::**********************************************************************
SET $NAME=%~n0
SET $DESCRIPTION=Install menu for Geonames reverse geotagging
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
::@(#)  %$NAME%
::@(#) 
::@ (#)OPTIONS
::@(-)  Flags, parameters, arguments (NOT the Monty Python way)
::@ (#)  -h      Help page
::@ (#) 
::@ (#) 
::@(#)DESCRIPTION
::@(-)  A textual description of the functioning of the command or function.
::@(#)  Names and paths to 
::@(#)  -   Utilities
::@(#)  -   Data files
::@(#)  -   Data base files
::@(#)  -   Temporary files
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
::SET $VERSION=2016-03-11&SET $REVISION=00:00:00&SET $COMMENT=Initial/ErikBachmann
  SET $VERSION=2016-03-24&SET $REVISION=08:10:00&SET $COMMENT=Database build extracted from default install/ErikBachmann
::**********************************************************************
::@(#){COPY}%$VERSION:~0,4% %$Author%
::**********************************************************************
::ENDLOCAL
:init

    CALL "%~dp0\geotag.config.cmd"

    SET _call=%~1

    IF DEFINED _Call GOTO :menu_%_Call%
    
:menuLOOP
    IF /I "q"=="%_sel%" GOTO :EOF
    SET _Menu.Level=3
    SET _Alternatives=
    CALL "%~dp0\_banner"
    ECHO:

    FOR /F "tokens=1,2,* delims=_ " %%A in ('"FINDSTR /b /c:":menu_" "%~f0""') do ECHO:  %%B  %%C & CALL :LocalSet _Alternatives %%B

:menuSelect
    ECHO:
    rem ECHO:Alt[%_Alternatives%]

    CHOICE /C %_Alternatives% /M "Menu %_Menu.Level% - Make a choice: "
    ECHO:
    SET _To=%Errorlevel%
    SET /A _From=%_to% - 1
    REM ECHO: from %_from% - %_to%

    SET _TO=1
    CALL SET _Sel=%%_Alternatives:~%_from%,%_To%%%%
    REM ECHO: %_Sel% - errorlevel %Errorlevel%

    call:menu_%_sel%
GOTO:menuLOOP

:LocalSet
    SET _LocalSet=%2
    IF "#"=="%_LocalSet%" GOTO :EOF

    ::echo _LocalSet=%_localset%
    CALL SET %1=%%%1%%%_LocalSet%
GOTO :EOF

::-----------------------------------------------------------
:: menu functions follow below here
::-----------------------------------------------------------

::---------------------------------------------------------------------

:menu_Q Quit (Return to main)
    echo :Return to main
    ENDLOCAL&CALL SET "_SEL=Q"
    ECHO:preinstall [%_sel%]
    ::TIMEOUT /T 5
EXIT /b

:menu_C     Edit config file
    ECHO:-- Getting config
    CALL notepad "%~dp0\Geotag.config.cmd"
    SET _sel=
    ECHO:*** Restarting menu ***
    TIMEOUT /T 3
    
    CALL "%$Source%"
GOTO :EOF

:menu_I   Install software and database
    CALL :menu_1
    CALL :menu_2
    ::CALL :menu_3
    ::CALL :menu_4
    ::CALL :menu_5
    ::CALL :menu_6
    ::CALL :menu_7
GOTO:EOF

:menu_
:menu_# Or step though the installation:
::menu_
:menu_1     - Checking paths
    ECHO:Checking paths
    CALL "%~dp0\Meta.CheckPaths.cmd"
    TIMEOUT /T 15
    ECHO:
GOTO:EOF

:menu_2     - Download and install packages (including database)
    ECHO:-Download and install packages
    CALL "%~dp0\Meta.InstallPackages.cmd"
    ECHO:
GOTO:EOF


:menu_#  Database rebuild


:menu_3     - Download meta data from Geoname.org
    ECHO:- Download meta data from Geoname.org
    CALL "%~dp0\GetGeonamesData.cmd"
    ECHO:
GOTO:EOF

:menu_4     - Convert meta data
    ECHO:- Convert meta data
    CALL "%~dp0\ConvertGeoname.SQLite.cmd"
    ECHO:
GOTO:EOF

:menu_5     - Build databases *Warning* - Overwrites existing database
    ECHO:- Build databases
    CALL "%~dp0\BuildGeoname.SQLite.cmd"
    ECHO:
GOTO:EOF

:menu_6     - Load meta data
    ECHO:- Load meta data
    CALL "%~dp0\LoadGeoname.SQLite.cmd"
    ECHO:
GOTO:EOF

:menu_7     - Post process loaded meta data 
    ECHO:- Post process meta data
    CALL "%~dp0\PostLoadGeoname.SQLite.cmd"
    ECHO:
GOTO:EOF


::*** End of File *****************************************************