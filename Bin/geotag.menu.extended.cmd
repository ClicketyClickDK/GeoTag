@ECHO OFF
REM.-- Prepare the Command Processor
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
::**********************************************************************
SET $NAME=%~n0
SET $DESCRIPTION=Extended menu for Geonames reverse geotagging
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
::@ (#) Menu build on example from
::@ (#)  URL: http://www.dostips.com/DtTipsMenu.php
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
    :: Get configuration
    CALL "%~dp0\bin\geotag.config.cmd"

:menuLOOP
    IF /I "q"=="%_sel%" GOTO :EOF
    SET _SET=
    SET _Alternatives=
    CALL "%~dp0\_banner"
    
    SET _Menu.Level=5
    TITLE %$NAME% - Build index menu
::    ECHO:= Main menu ===========================================================
    FOR /F "tokens=1,2,* delims=_ " %%A in ('"FINDSTR /b /c:":menu_" "%~f0""') do ECHO:  %%B  %%C & CALL :LocalSet _Alternatives %%B

:menuSelect
    ECHO:
    ::ECHO:Alt[%_Alternatives%]
    CHOICE /C %_Alternatives% /M "Menu %_Menu.Level% : Make a choice: "
    ECHO:
    SET _To=%Errorlevel%
    SET /A _From=%_to% - 1
    SET _TO=1
    CALL SET _Sel=%%_Alternatives:~%_from%,%_To%%%%
    CALL:MENU_%_sel%
GOTO:menuLOOP

::---------------------------------------------------------------------

::Append the menu number to choice alternatives
:LocalSet Menu
    SET _LocalSet=%2
    IF "#"=="%_LocalSet%" GOTO :EOF
    CALL SET %1=%%%1%%%_LocalSet%
GOTO :EOF


::---------------------------------------------------------------------
:: menu functions follow below here
::---------------------------------------------------------------------

:: Menu 1 - Main menu --------------------------------------------------

::menu_#  Database found
:menu_

:: Import, convert, Export
:menu_K   --KML 2 CSV (Google maps -> import)
    ECHO:To be implemented..
    ::CALL BIN\Meta.dump.cmd
    pause
GOTO:EOF

:menu_C   --CSV 2 KML (Export -> Google maps)
    ECHO:To be implemented..
    ::CALL BIN\Meta.dump.cmd
    pause
GOTO:EOF




:menu_S   Split dump file into tables
    CALL BIN\Meta.split.cmd 
    pause
GOTO:EOF
:menu_L   Load meta data to index
    CALL BIN\Meta.load.cmd 
    pause
GOTO:EOF


:menu_N  Clean up temporary data files
    CALL "bin\GetGeonamesData.cleanup.cmd"
    TIMEOUT /T 15
GOTO:EOF
::---------------------------------------------------------------------
:menu_

:menu_Q Quit
    CALL :Banner
    ECHO :quit
    ::TIMEOUT /T 5
EXIT /b

::*** End of File *****************************************************