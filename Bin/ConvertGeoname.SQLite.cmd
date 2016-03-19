@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
SET $NAME=%~n0
::**********************************************************************
SET $DESCRIPTION=Convert meta data [Escape Quotes and Apostrophs]
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
::@(#)      %$NAME%
::@(#) 
::@ (#)OPTIONS
::@(-)  Flags, parameters, arguments (NOT the Monty Python way)
::@ (#)  -h      Help page
::@ (#) 
::@ (#) 
::@(#)DESCRIPTION
::@(-)  A textual description of the functioning of the command or function.
::@(#)  Will download datafiles from Geonames.org, unzip the files
::@(#)  and load the data into a SQLite database.
::@(#)  The database is required for reverse geotagging of images.
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
::@ (#)REQUIRES
::@(-)  Dependencies
::@ (#)  
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
    CALL "%~dp0\_Header"
    
    CALL "%~dp0\Geotag.config.cmd"

:Processing
    ECHO:-- Extracting Country info
    TITLE %$NAME%: Extracting Country info
    TYPE "%_DataDir%\countryInfo.txt" | FINDSTR /v "^#" >"%_DataDir%\countryInfo-n.txt"

    FOR %%a IN (%_LoadFiles%) DO (
        IF NOT EXIST "%_DataDir%\%%a" (
            ECHO:File not found: [%_DataDir%\%%a]
        ) ELSE (
            CALL "%~dp0\_escape.csv.cmd" "%_DataDir%\%%a" "%_DataDir%\%%a.esc"
        )
    )

    TITLE %$NAME%: Data ready to load. Run "%~dp0\BuildGeoname.SQLite.cmd"
    ECHO: Data is processed and ready to load:
    FOR %%a IN (%_LoadFiles%) DO ECHO: - "%_DataDir%\%%a.esc"

    ECHO: Run "%~dp0\BuildGeoname.SQLite.cmd"
    TimeOut /t 15

::*** End of File *****************************************************