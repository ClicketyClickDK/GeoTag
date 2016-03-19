@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
::**********************************************************************
SET $NAME=%~n0
SET $DESCRIPTION=Install scripts and utilites for geotagging
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
::@(#)  %$NAME% [args]
::@(#) 
::@(#)OPTIONS
::@(-)  Flags, parameters, arguments (NOT the Monty Python way)
::@ (#)  -h      Help page
::@(#)  PATH    Path to images 
::@(#) 
::@(#)DESCRIPTION
::@(-)  A textual description of the functioning of the command or function.
::@# The script will:
::@# 1) Test the structure
::@# 2) Update the provided script to newest version
::@# 3) Create a configuration file: "C:\TMP\Bin\Meta.config.cmd"
::@# 4) Create the geotagging database (Data\geotag.sqlite)
::@# 5) Create the image search database (Data\image.sqlite)
::@# 6) Download and unzip the Geoname data from Geonames.org
::@# 7) Convert the data and load the data into the Geotag database

::@(#)  Dump meta data from images to a single datafile
::@(#)  Split meta data into types (tables)
::@(#)  Create database and tables (if not exist)
::@(#)  Load data into database
::@(#)  Split bundled data like Keywords and Suplemtal Categories
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
  SET $VERSION=2016-02-19&SET $REVISION=00:00:00&SET $COMMENT=Initial/ErikBachmann
::**********************************************************************
::@(#){COPY}%$VERSION:~0,4% %$Author%
::**********************************************************************
::ENDLOCAL

:init
    REM CALL "%~dp0\_banner"
    CALL "%~dp0\_Header"

    :: General configuration
    CALL "%~dp0\Geotag.config.cmd"

    ECHO:Paths:
    FOR /F "DELIMS=; Tokens=2*" %%a IN ('SET _CheckPaths') DO CALL :CheckPaths "%%a" "%%b"
    ECHO:Packages:
    FOR /F "DELIMS=; Tokens=2*" %%a IN ('SET _CheckPackages') DO CALL :CheckPackages "%%a" "%%b"
    
GOTO :EOF

::---------------------------------------------------------------------

:CheckPaths
    CALL "%~dp0\_\_Action.cmd" "- %~1"
    CALL SET _Status=-
    IF NOT EXIST "%~2" MKDIR "%~2"&SET _Status=+

    CALL "%~dp0\_\_Status.cmd" "%_Status% %~2"
GOTO :EOF   *** :_CheckPaths ***

::---------------------------------------------------------------------

:CheckPackages
    CALL "%~dp0\_\_Action.cmd" "- %~1"
    CALL SET _Status=-
    IF NOT EXIST "%~2" (
        CALL "%~dp0\_\_Status.cmd" "MISSING"
        SET _Status=+
    ) ELSE (
        CALL "%~dp0\_\_Status.cmd" "Found"
    )
GOTO :EOF   *** :_CheckPaths ***

::*** End of File *****************************************************