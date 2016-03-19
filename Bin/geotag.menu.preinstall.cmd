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
  SET $VERSION=2016-03-11&SET $REVISION=00:00:00&SET $COMMENT=Initial/ErikBachmann
::**********************************************************************
::@(#){COPY}%$VERSION:~0,4% %$Author%
::**********************************************************************
::ENDLOCAL
:init

    CALL "%~dp0\bin\geotag.config.cmd"

    
:menuLOOP
    IF /I "q"=="%_sel%" GOTO :EOF
    CLS
    SET _Menu.Level=3
    SET _Alternatives=
    CALL "%~dp0\_banner"
    
    ECHO:
    REM ECHO:= Menu ================================================================
    REM ECHO:

    FOR /F "tokens=1,2,* delims=_ " %%A in ('"FINDSTR /b /c:":menu_" "%~f0""') do ECHO:  %%B  %%C & CALL :LocalSet _Alternatives %%B



REM ECHO:
REM ECHO:= Menu %_Menu.Level%===============================================================
REM ECHO:


:menuSelect
    ECHO:
    CHOICE /C %_Alternatives% /M "Menu %_Menu.Level% - Make a choice: "
    ECHO:
    SET _To=%Errorlevel%
    SET /A _From=%_to% - 1
    SET _TO=1
    CALL SET _Sel=%%_Alternatives:~%_from%,%_To%%%%
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


:: Menu 1

:menu_#  Attention^! 
:menu_# The software packages has not yet been downloaded and installed
:menu_#  And the database has not yet been configured.
:menu_#  Please run the installation to download and configure 
:menu_#  Refere to the "Read Me" for more info
:menu_

::---------------------------------------------------------------------

:menu_R     Read ME
    CALL notepad ReadMe.txt
GOTO:EOF


:menu_I   *** Install *** - The full monty
    CALL "%~dp0\geotag.menu.install" 1  - Checking paths
    CALL "%~dp0\geotag.menu.install" 2  - Download and install packages
    CALL "%~dp0\geotag.menu.install" 3  - Download meta data from Geoname.org
    CALL "%~dp0\geotag.menu.install" 4  - Convert meta data
    CALL "%~dp0\geotag.menu.install" 5  - Build databases
    CALL "%~dp0\geotag.menu.install" 6  - Load meta data
    CALL "%~dp0\geotag.menu.install" 7  - Post process loaded meta data
    ECHO:Installation done
    TREE
    PAUSE
GOTO:EOF


:menu_C     Edit config file
    ECHO:-- Getting config
    CALL notepad "%~dp0\..\bin\Geotag.config.cmd"
    ECHO:*** Restarting menu ***
    TIMEOUT /T 3
    "%~f0"
GOTO :EOF


:menu_

:menu_q Quit (Return to main)
    echo :Return to main
    ENDLOCAL&CALL SET "_SEL=Q"
    ECHO:preinstall [%_sel%]
    ::TIMEOUT /T 5
    EXIT /b 1
GOTO :EOF

::*** End of File *****************************************************