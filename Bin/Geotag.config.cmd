::@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
::**********************************************************************
SET $NAME=%~n0
SET $DESCRIPTION=Configuration file for Geonames reverse geotagging
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
::SET $VERSION=2016-02-19&SET $REVISION=00:00:00&SET $COMMENT=Initial/ErikBachmann
  SET $VERSION=2016-03-25&SET $REVISION=09:54:00&SET $COMMENT=Absolut path on key stubs/ErikBachmann
::**********************************************************************
::@(#){COPY}%$VERSION:~0,4% %$Author%
::**********************************************************************
ENDLOCAL

::IF DEFINED _Geotag.config.cmd GOTO :EOF

::*** Log and Trace
    IF NOT DEFINED _StartTime SET _StartTime=%Date% %TIME%
    CALL :logTrace _TraceFile .trc
    CALL :logTrace _LogFile .log

::*** Path stubs ******************************************************
:: Do not use "" in paths or names
    ::SET _ImageDir=%~dp0\..\images\
    ::SET _WebDir=%~dp0\..\web\
    CALL "%~dp0_GetAbsolutPath.cmd" "%~dp0\..\images\" _ImageDir
    CALL "%~dp0_GetAbsolutPath.cmd" "%~dp0\..\web\" _WebDir

    SET $SQLite_dir=%~dp0\sqlite\
    SET $ExifTool_dir=%~dp0\ExifTool\
    SET $ImageMagick_dir=%~dp0\ImageMagick\
    SET $UnderScore_dir=%~dp0\_\
    ::SET $Cygwin_dir=C:\Program Files\cygwin64\bin\

    CALL "%~dp0_GetAbsolutPath.cmd" "%~dp0\..\DATA\" _DataDir
    CALL "%~dp0_GetAbsolutPath.cmd" "%~dp0\..\SQL\" _SqlDir
    
    CALL "%~dp0_GetAbsolutPath.cmd" "%~dp0\..\images\" _Pics.TargetDir
    CALL "%~dp0_GetAbsolutPath.cmd" "%~dp0\..\raw\" _Pics.RawDir

::*** Paths to check **************************************************
::               ;Name     ;Path
    SET _CheckPaths1=;Binary / scripts;Bin\
    SET _CheckPaths2=;Underscore script library;Bin\_\
    SET _CheckPaths3=;ExifTool - Meta data handling;Bin\ExifTool\
    SET _CheckPaths4=;ImageMagick - manipulating images;Bin\ImageMagick\
    SET _CheckPaths5=;Download and database;Data\
    SET _CheckPaths6=;Documentation;Doc\
    SET _CheckPaths7=;Images - input;Images\
    SET _CheckPaths8=;Test;Test\
    SET _CheckPaths9=;Images - output;Web\
    SET _CheckPathsA=;.Archive - for various old stuff;.Archive\
    SET _CheckPathsB=;SQLite - SQL database;Bin\SQLite\
    SET _CheckPathsC=;SQLite - SQL scripts;Sql\

::*** Packages to install *********************************************
::                   ; a:Name    ;b:zip                                   ;c:url                                        ;d:description
    SET _InstallPackage0=;..\Data;geoname.zip;http://www.clicketyclick.dk/data/public/geotag/data/;GeoTag preloaded database
    SET _InstallPackage1=;ImageMagick;ImageMagick-7.0.0-0-portable-Q16-x86.zip;http://www.imagemagick.org/download/binaries/;ImageMagick is a software suite to create, edit, compose, or convert images
    SET _InstallPackage2=;UnderScore;master.zip;https://github.com/ClicketyClickDK/Underscore/archive/;Generic DOS batch script library
    ::SET _InstallPackage2=;_;master.zip;https://github.com/ClicketyClickDK/Underscore/archive/;Underscore - Generic DOS batch script library
    SET _InstallPackage3=;ExifTool;exiftool-10.11.zip;http://www.sno.phy.queensu.ca/~phil/exiftool/;ExifTool by Phil Harvey - Read, Write and Edit Meta Information!
    SET _InstallPackage4=;SQLite;sqlite-tools-win32-x86-3110100.zip;https://www.sqlite.org/2016/;SQLite is a self-contained, serverless, zero-configuration, transactional SQL database engine.
    SET _InstallPackage5=;SQLite;sqlite.extension-functions.zip;http://clicketyclick.dk/databases/sqlite/;SQLite Extensions: Math, String and Aggregate
    SET _InstallPackage6=;Pics;master.zip;https://github.com/ClicketyClickDK/Pics/archive/;Handling pictures from camera, SD, mobile or other devices
    
::*** Data files to load **********************************************
    SET _GeonamesURL=http://download.geonames.org/export/dump/
    SET _LoadFiles=allCountries.txt allCountries.local.txt admin1CodesASCII.txt admin2Codes.txt alternateNames.txt countryInfo-n.txt iso-languagecodes.txt featureCodes_en.txt timeZones.txt continentCodes.txt

::*** Image templates *************************************************
    SET _ImagePattern=*.jpg
    SET _ImageExt=jpg

::*** SQLite **********************************************************
    SET $SQLite.exe=%$SQLite_dir%sqlite3.exe
    SET $SQLite.libSqlite=libsqlitefunctions.so
    SET $SQLite.db.geoname=%_DataDir%\geonames.sqlite
    SET $SQLite.db.image=images.sqlite

::*** Copyright *******************************************************
    IF NOT DEFINED $Copyright SET $Copyright=Copyright.IPTC 
    ::SET $Copyright=Copyright.Erik.IPTC 
    ::SET $Copyright=Copyright.Signe.IPTC 

::*** ExifTool ********************************************************
    ::SET $ExifTool.exe=exiftool(-k).exe
    SET $ExifTool.exe=exiftool.exe
    SET $ExifTool=%$ExifTool_dir%\%$ExifTool.exe%
    SET _SetFileDataOriginalFlags="-filemodifydate<datetimeoriginal" 

::*** ImageMagick *****************************************************
    SET PATH=%PATH%;%$ImageMagick_dir%;
    ::SET $ImageMagick.exe=
    Set ImageMagick.Convert=%$ImageMagick_dir%\convert.exe
    Set ImageMagick.Identify=%$ImageMagick_dir%\identify.exe

::*** Underscore Script Library ***************************************
    ::SET $UnderScore.exe=

::*** Cygwin **********************************************************
    :: Please note that Cygwin is not a part of this package
    ::SET $Cygwin.exe=
  
    SET _CheckPackages1=;ExifTool;%$ExifTool%
    SET _CheckPackages2=;SQLite;%$SQLite.exe%
    SET _CheckPackages3=;ImageMagick;%ImageMagick.Convert%

::*** Separator lines and fillers *************************************
    SET _Line=----------------------------------------------------------------------
    SET _blanks=                                                                   !

::*** Tag to avoid rereading ******************************************
    SET _Geotag.config.cmd=1

GOTO :EOF

::---------------------------------------------------------------------

:: Creating log or trace file
:logTrace _Tracefile .trc
    IF DEFINED %~1 GOTO :EOF
    SETLOCAL
        SET _=%~1
        ::CALL "%~dp0_GetAbsolutPath.cmd" "%~dp0\..\%$NAME%%~2" _
        SET _=%TEMP%\%$NAME%%~2
        ECHO:%$NAME% v. %$VERSION% r. %$REVISION% - %_StartTime%>"%_%"
    ENDLOCAL&SET %~1=%_%
GOTO :EOF   ::*** :logTrace ***

::*** End of File *****************************************************