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
::SET $VERSION=2016-02-19&SET $REVISION=00:00:00&SET $COMMENT=Initial/ErikBachmann
::SET $VERSION=2016-03-23&SET $REVISION=15:33:00&SET $COMMENT=Robocopy output to trace/ErikBachmann
::SET $VERSION=2016-03-24&SET $REVISION=08:12:00&SET $COMMENT=Include preloaded database/ErikBachmann
  SET $VERSION=2016-03-24&SET $REVISION=22:23:00&SET $COMMENT=getHistory/ErikBachmann
::**********************************************************************
::@(#){COPY}%$VERSION:~0,4% %$Author%
::**********************************************************************
::ENDLOCAL

:init
    REM CALL "%~dp0\_banner"
    CALL "%~dp0\_Header"

    CALL "%~dp0\Geotag.config.cmd"

    SET _StartTime=%Date% %TIME%
    SET _RootDir=%CD%\
    SET _LogFile=%$NAME%.log

:Processing

    ECHO:Download and install packages
    
    ECHO:ATTENTION: This will overwrite current packages (and upgrade if nessesary)
    TIMEOUT /T 15
    ::                    a:target b:zip c:url d:comment
    FOR /F "DELIMS=; Tokens=2,3,4*" %%a IN ('SET _InstallPackage') DO CALL :InstallPackage "%%a" "%%b" "%%c" "%%d"
    TIMEOUT /T 15
GOTO :EOF

:InstallPackage
        ::ECHO:%_Line%
        SET _PackageName=%~1
        SET _PackageZip=%~2
        SET _PackageUrl=%~3
        SET _PackageDesc=%~4
        SET _PackageState=
        ::set _Package
        ::pause
        IF "ImageMagick"=="%_PackageName%" CALL :getLatestImageMagick %_PackageUrl% >>"%_LogFile%" 2>&1
        TITLE %_PackageName% - %_PackageDesc%
        ECHO:%_PackageName% - %_PackageDesc%>>"%_TraceFile%"
        ECHO:URL: %_PackageUrl%%_PackageZip%>>"%_TraceFile%"
        CALL "%~dp0\_\_Action" %_PackageName%
        CALL "%~dp0\_\_State" Downloading...
        ::  b:zip c:url 
        CALL :_Download "%_PackageZip%" "%_PackageUrl%" "%_PackageName%" >>"%_LogFile%" 2>&1

        IF NOT DEFINED _PackageState (
            CALL "%~dp0\_\_State" Unzipping
            rem ::            b:zip     a:target
            rem ECHO:CALL :_Unzip "%_PackageZip%" "%_PackageName%" "%_PackageName%"  
            rem >>"%_LogFile%"  2>&1

            CALL :_Unzip "%_PackageZip%" "%_PackageName%" "%_PackageName%"  >>"%_LogFile%"  2>&1
            
            :: Patches
            IF "ExifTool"=="%_PackageName%" COPY /y /V "%~dp0%_PackageName%\exiftool(-k).exe" "%~dp0%_PackageName%\exiftool.exe" >nul
            
            IF "SQLite"=="%_PackageName%" CALL :postSqlite
            IF "Pics"=="%_PackageName%" (
                MOVE /Y "%TEMP%\%_PackageZip%" "%TEMP%\%_PackageName%.%_PackageZip%" > NUL
            )
            
            IF EXIST "%~dp0%_PackageName%\%_PackageName%-master" (
                XCOPY /S/E/V /y "%~dp0%_PackageName%\%_PackageName%-master\*.*" "%~dp0%_PackageName%\" >nul
                RMDIR /S /Q "%~dp0%_PackageName%\%_PackageName%-master"
            )
            IF "UnderScore"=="%_PackageName%" (
            rem IF "_"=="%_PackageName%" (
                TITLE %_PackageName% - Rename ZIP 
                MOVE /Y "%TEMP%\%_PackageZip%" "%TEMP%\%_PackageName%.%_PackageZip%" > NUL
                rem MOVE /Y "%~dp0%_PackageName%\" "%~dp0_\" > NUL
                REM robocopy "C:\Temp\Geotag\Test\tmp\underscore\ " "C:\Temp\Geotag\Test\tmp\_\ " /S /MOVE
                TITLE %_PackageName% - Raise level
                robocopy "%~dp0%_PackageName%\ " "%~dp0_\ " /S /MOVE >>"%_TraceFile%"

            )
            TITLE %_PackageName% - Done
        )
        IF NOT DEFINED _PackageState (
            TITLE %_PackageName% - Installed
            CALL "%~dp0\_\_Status" "Installed"
        ) ELSE (
            TITLE %_PackageName% - %_PackageState%
            CALL "%~dp0\_\_Status" "%_PackageState%"
        )
        CALL "%~dp0\getHistory" >"%~dp0\..\DOC\history.txt"
        CALL "%~dp0\getHistory" -html >"%~dp0\..\DOC\history.html"
        
GOTO :EOF

::----------------------------------------------------------------------

:PostSqlite
    CALL "bin\_absolutPath.cmd" "bin\SQLite\sqlite-tools-win32-x86-*.*" _CurrentSqlite
    IF EXIST "%_CurrentSqlite%" (
        XCOPY /S/E/V /y "%_CurrentSqlite%\*.*" "%~dp0%_PackageName%\" >nul
        RMDIR /S /Q "%_CurrentSqlite%"
    )
GOTO :EOF   *** :PostSqlite ***

::----------------------------------------------------------------------

:getLatestImageMagick
    SET _latestImageMagick=%~1
    ::CALL "%~dp0\_\wget.bat" "%_latestImageMagick%digest.rdf" "%_datadir%\digest.rdf"
    CALL "%~dp0\_\wget.cmd" "%_latestImageMagick%digest.rdf" "%_datadir%\digest.rdf"

    FOR /F "DELIMS== tokens=2" %%a IN ('findstr "ImageMagick-.*-portable-.*-x86.zip" ^<%_datadir%\digest.rdf') DO CALL SET "_latestImageMagick=%%a"
    ECHO:--%_latestImageMagick:~1,-2%
    SET _packageZip=%_latestImageMagick:~1,-2%
GOTO :EOF   *** :getLatestImageMagick ***

::----------------------------------------------------------------------

:_Download ZIP URL
    ::CALL "%~dp0\_\_Action" "- %_ImageMagickZip%"
    TITLE %~1%
    :: If no zip in temp
    IF NOT EXIST "%TEMP%\%~1" (
        TITLE %~1 Downloading...
        ECHO:%~1 Downloading>>"%_TraceFile%"
        ::                     ZIP URL
        ::CALL "%~dp0\_\Wget.bat" "%~2%~1" "%TEMP%\%~1"
        CALL "%~dp0\_\Wget.cmd" "%~2%~1" "%TEMP%\%~1"
        IF EXIST "%TEMP%\%~1" (
            TITLE %~1 Downloaded
            ECHO:%~1 Downloaded>>"%_TraceFile%"
            DIR "%TEMP%\%~1">>"%_TraceFile%"
        ) ELSE (
            SET _PackageState=Download failed
            ECHO:Download failed>>"%_TraceFile%"
        )
    ) ELSE (
        TITLE %~1 Download skipped
        CALL "%~dp0\_\_Status" "Zip Found in temp. Download skipped"
        ECHO:Zip Found in temp. Download skipped>>"%_TraceFile%"
        DIR "%TEMP%\%~1">>"%_TraceFile%"
    )
GOTO :EOF   *** :_Download ***

::----------------------------------------------------------------------

:_UnZip zip target
SETLOCAL
    CALL "%~dp0_GetAbsolutPath" "%TEMP%\%~1" _source
    CALL "%~dp0_GetAbsolutPath" "%~dp0%~2"   _target
    
    
    IF EXIST "%TEMP%\%~1" (
        TITLE %~3: Unzipping %1
        ECHO:%~3: Unzipping: "%_source%" "%_target%" >> "%_traceLog%"
        CALL "%~dp0\_\unZip.bat" "%_source%" "%_target%"
        TITLE %~3: Unzipped %1
        ECHO:%~3: Unzipped %1>>"%_traceLog%"
        CALL "%~dp0\_\_State" "Unzipped"
    ) ELSE (
        TITLE %~3: Unzip failed %1
        CALL SET _PackageState=Zip not found in temp
        CALL "%~dp0\_\_Status" "%_PackageState%"
    )
ENDLOCAL
GOTO :EOF   *** :_UnZip ***

::----------------------------------------------------------------------

:CheckPaths
    CALL "%~dp0\_\_Action" "- %~1"
    CALL SET _Status=-
    IF NOT EXIST "%~2" MKDIR "%~2"&SET _Status=+

    CALL "%~dp0\_\_Status" "%_Status% %~2"
GOTO :EOF   *** :_CheckPaths ***

::*** End of File ******************************************************