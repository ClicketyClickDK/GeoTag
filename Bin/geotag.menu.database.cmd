@ECHO OFF
REM.-- Prepare the Command Processor
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION

REM URL: http://www.dostips.com/DtTipsMenu.php

::@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
::**********************************************************************
SET $NAME=%~n0
SET $DESCRIPTION=Database menu for Geonames reverse geotagging
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
  SET $VERSION=2016-03-11&SET $REVISION=00:00:00&SET $COMMENT=Initial/ErikBachmann
::**********************************************************************
::@(#){COPY}%$VERSION:~0,4% %$Author%
::**********************************************************************
::ENDLOCAL
:init
    CALL "%~dp0\_banner"
    
    CALL "%~dp0\geotag.config.cmd"
    
:menuLOOP
    IF /I "q"=="%_sel%" GOTO :EOF
    CLS
    SET _Menu.Level=3
    SET _Alternatives=
    CALL "%~dp0\_banner"
    REM CALL "%~dp0\_Header"
    
    FOR /F "tokens=1,2,* delims=_ " %%A in ('"FINDSTR /b /c:":menu_" "%~f0""') do ECHO:  %%B  %%C & CALL :LocalSet _Alternatives %%B

:menuSelect
    ECHO:
    CHOICE /C %_Alternatives% /M "Menu %_Menu.Level% - Make a choice: "
    ECHO:
    SET _To=%Errorlevel%
    SET /A _From=%_to% - 1
    REM ECHO: from %_from% - %_to%
    SET _TO=1
    CALL SET _Sel=%%_Alternatives:~%_from%,%_To%%%%
    REM ECHO: %_Sel% - errorlevel %Errorlevel%
    REM ECHO call:menu_%_sel%
    REM pause    
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

:menu0_Q   Quit
    REM ECHO: Quitting
    REM CALL :Menu_q
GOTO:EOF


:: Menu 1

:menu_S     SQLite prompt - Geoname
    ECHO:-- Geoname database SQLite prompt
    ECHO: .q for exit
    CALL "%~dp0\..\bin\sqlite\sqlite3.exe" data\geonames.sqlite
    TIMEOUT /T 15
GOTO :EOF

:menu_I     SQLite prompt - Images
    ECHO:-- Image database SQLite prompt
    ECHO: .q for exit
    CALL "%~dp0\..\bin\sqlite\sqlite3.exe" data\images.sqlite
    TIMEOUT /T 15
GOTO :EOF

:menu_B     Backup databases
    ECHO:-- Backup databases
    FOR %%a IN (images geonames) DO (
        ECHO:Backup: %%a
        TITLE %$NAME%: Backup databases - %%a [Please wait]
        CALL "%~dp0\..\bin\sqlite\sqlite3.exe" data\%%a.sqlite ".echo on" ".database" ".tables" ".backup main data/%%a.sqlite.bak" .quit
        TITLE %$NAME%: Backup databases - %%a [Done]
        ECHO:Files:
        FOR %%b IN (data\%%a.*) DO CALL %~dp0\_\_action "%%~fb"&CALL %~dp0\_\_status "%%~tb  %%~zb"
    )
    TIMEOUT /T 15
GOTO :EOF




:menu_

:menu_Q Quit (Return to main)
    echo :Return to main
    ::TIMEOUT /T 5
EXIT /b
::*** End of File *****************************************************