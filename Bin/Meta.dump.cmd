@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
::**********************************************************************
SET $NAME=%~n0
SET $DESCRIPTION=Dump meta data from previously tagged images [ExifTool]
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
::@(#)  %$NAME% [Image path] [Image extension] [tag]
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
::@(#) Dump images located outside the default
::@(#)     %$NAME% "X:\Myimages\"
::@(#) 
::@(#) Dump images located outside the default and with another extension
::@(#)     %$NAME% "X:\Myimages\" "PNG"
::@(#) 
::@(#) Dump images located outside the default and tag the dumpfile
::@(#)     %$NAME% "X:\Myimages\2015\" "" "2015"
::@(#) 
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
::@(#)  Geotag.config.cmd
::@(#)  ExifTool
::@(#)
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
    ::ECHO:- Getting config
    CALL "%~dp0\Geotag.config.cmd"

    SET #ImageDir=%~1
    IF NOT DEFINED #ImageDir SET #ImageDir=%_ImageDir%
    SET #ImageExt=%~2
    IF NOT DEFINED #ImageExt SET #ImageExt=%_ImageExt%
    
    SET #ImageTag=%~3
    IF DEFINED #ImageTag SET #ImageTag=%_ImageTag%.
    
    SET _META=%TMP%\meta.%#ImageTag%csv
    ::SET _META.TABLE=%TMP%\meta.
    ::SET _LOAD=%TMP%\load.meta.sql

    CALL "%~dp0\_\_action" "File path"
    CALL "%~dp0\_\_status" "%#ImageDir%"
    
    CALL "%~dp0\_\_action" "File extention"
    CALL "%~dp0\_\_status" "%#ImageExt%"
    
    CALL "%~dp0\_\_action" "Image tags"
    CALL "%~dp0\_\_status" "%#ImageTag%"
    
:Process
    ECHO:- Dumping meta data
    ::
    :: -r[.]       (-recurse)           Recursively process subdirectories
    :: -progress                        Show file progress count
    :: -csv[=CSVFILE]                   Export/import tags in CSV format
    :: -m          (-ignoreMinorErrors) Ignore minor errors and warnings
    :: -n          (--printConv)        Read/write numerical tag values
    :: -p FMTFILE  (-printFormat)       Print output in specified format
    :: -ext EXT    (-extension)         Process files with specified extension
    :: -charset [[TYPE=]CHARSET]        Specify encoding for special characters
    SET _CMD="%$ExifTool%" -recurse -progress -csv -m -n -p "%_SqlDir:\=/%/dumpGeotag.fmt" -ext %#ImageExt% "%#ImageDir:\=/%"  -charset filename=Latin
    ECHO:%_CMD%
    CALL %_CMD% >"%_META%"

    DIR "%_META%"
    ECHO:- Dump ended 
GOTO :EOF    

::*** End of File *****************************************************