@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
::**********************************************************************
SET $NAME=%~n0
SET $DESCRIPTION=Load meta data from images and load into database [SQLite]
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

    ::ECHO:- Getting config
    CALL "%~dp0\Geotag.config.cmd"
    SET #ImageTag=%~1

    IF DEFINED #ImageTag SET #ImageTag=%#ImageTag%.

    SET _LOAD=%TMP%\load.meta.%#ImageTag%sql

:Process
    ECHO:- Loading load file for metadata [%_LOAD%]
    ECHO:-- Loading meta geonames data into geonames >>"%_LOAD%"
    
    :: Note the terminating ".quit": -init ignores .q in the SQL load file
    SET _CMD="%$SQLite.exe%" "%_DataDir:\=/%%$SQLite.db.image%" -init "%_LOAD%" .quit
    ECHO:%_CMD%
    CALL %_CMD%

    TIMEOUT 15
GOTO :EOF

::*** End of File *****************************************************