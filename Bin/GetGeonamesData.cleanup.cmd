@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
::**********************************************************************
SET $NAME=%~n0
SET $DESCRIPTION=Cleanup download meta data from Geoname.org
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
::@(#)REQUIRES
::@(-)  Dependencies
::@(#)  GetGeonamesDataFiles.txt 
::@(#)  wget.exe
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

    CALL "%~dp0\Geotag.config.cmd"
    
:Process
    ECHO::Removing downloads and temporary data
    
    ::IF NOT EXIST data MKDIR data
    ::CD data
    ECHO:- Data files
    ::              a:Zip b:target c:URL d:description
    FOR /F "Delims=; tokens=1,2,3,4*" %%a IN ('TYPE "%~dp0\GetGeonamesDataFiles.txt"^|FINDSTR ";http://"') DO (
        CALL :RemoveDataFiles "%%a" "%%b"
    )
    
    CALL :RemoveDataFiles "countryInfo-n.txt" "Data\"
    CALL :RemoveDataFiles "digest.rdf" "Data\"
     
    ECHO:- Install packages
    ::  ::SET _InstallPackage1=; a:Name    ;b:zip                                   ;c:url                                        ;d:description
    FOR /F "Delims=; tokens=3" %%a IN ('TYPE "%~dp0\Geotag.config.cmd "^|FINDSTR "_InstallPackage"') DO (
        CALL :RemoveDataFiles "%%a" "%temp%"
    )

    CALL :RemoveDataFiles "Pics.master.zip" "%temp%"
    CALL :RemoveDataFiles "UnderScore.master.zip" "%temp%"
    CALL :RemoveDataFiles "_.master.zip" "%temp%"
    
    CALL "%~dp0_\_Action.cmd" "digest.rdf"
    CALL :RemoveDataFile "digest.rdf" "Data\"
GOTO :EOF

:RemoveDataFiles file directory
    SET _File=%~1
    SET _FileName=%~n1
    CALL "%~dp0_\_Action.cmd" "- %~n1"
    FOR %%a IN (txt txt.esc zip ) DO CALL :RemoveDataFile "%_FileName%.%%a" %2
    ECHO:
GOTO :EOF

:RemoveDataFile file directory
    ::CALL "%~dp0_\_Action.cmd" "- %~1"
    TITLE %$NAME%: %~1
    IF EXIST "%~2\%~1" (
        DEL "%~2\%~1"
        rem CALL "%~dp0_\_Status.cmd" "Deleted"
        SET /P _=X<nul
    ) ELSE (
        rem CALL "%~dp0_\_Status.cmd" "Not found"
        SET /P _=.<nul
    )
GOTO :EOF   *** :RemoveDataFile ***

    ECHO:
    ECHO:Unzipping:
    SET _ZipFiles=allCountries alternateNames
    FOR %%a IN (%_ZipFiles% ) DO (
        CALL "%~dp0\_\_Action" "%%a"
        IF EXIST "%_DataDir%\%%a.zip" (
            TITLE %$NAME%: Unzipping %%a.zip
            CALL "%~dp0_\_State" "Unzipping.."
            CALL "%~dp0_\unzip.bat" "%_DataDir%%%a.zip" "%_DataDir%" >>"%_LogFile%" 2>&1
            
            IF EXIST "%_DataDir%\%%a.txt" (
                TITLE %$NAME%: Unzipped %%a.zip
                CALL "%~dp0_\_Status" "Unzipped"
            ) ELSE (
                TITLE %$NAME%: Unzip failed %%a.zip
                CALL "%~dp0_\_Status" "FAILED! Check logfile %_LogFile""
            )

        ) ELSE (
            TITLE %$NAME%: Zip not found %%a.zip
            CALL "%~dp0_\_Status" "ZIP file not found: %_DataDir%\%%a.zip"
        )
    )
    
GOTO :EOF    

::---------------------------------------------------------------------

:: Will both echo string to STDOUT and update title bar
:EchoTitle
    TITLE %$NAME%: %*
    ECHO:%*
GOTO :EOF

::*** End of File *****************************************************