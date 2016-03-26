@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
::**********************************************************************
SET $NAME=%~n0
SET $DESCRIPTION=Updating location in IPCT (Reverse Geotagging)
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
  SET $VERSION=2016-03-25&SET $REVISION=10:12:00:00&SET $COMMENT=Call to sqlite fixed/ErikBachmann
::**********************************************************************
::@(#){COPY}%$VERSION:~0,4% %$Author%
::**********************************************************************
::ENDLOCAL

:Init
    SET _Gps2LocationSql=%TMP%\%~n0.sql
    SET _Gps2LocationTags=%TMP%\%~n0.tag
    
    ::ECHO:- Getting config
    CALL "%~dp0\Geotag.config.cmd"

    SET _LogFile=%TMP%\%~n0.log.txt
    SET _TraceFile=%TMP%\%~n0.trc.txt
    ECHO:%Date% - %TIME%: %$NAME%>%_logFile%
    ECHO:%Date% - %TIME%: %$NAME%>%_TraceFile%
    
    
    SET _FILE=%1
    SET _File=%_FILE:\=/%
    SET _FILENAME=%~n1                             .
    SET _latitude=%2
    SET _longitude=%3
    SET _latitude_string=%2                        .
    SET _longitude_string=%3                       .
    SET _Distance=10

    SET _=%_filename:~0,30%:%_longitude_string:~0,10% / %_latitude_string:~0,10%                            .
    SET /P _=%_:~0,53%;<NUL
    SET _ >>%_TraceFile%

:Process
    Title %~n0: %_file% - Convert GPS to location
    ECHO:%Date% - %TIME%: %$NAME% - %_file% - Convert GPS to location >>%_TraceFile%

    Title %~n0: %_file% - Convert GPS to location - Build sql
    CALL :mapGps2location "%_longitude%" "%_latitude%" "%_Distance%" >"%_Gps2LocationSql%" 2>>%_TraceFile%
    TYPE "%_Gps2LocationSql%" >>%_TraceFile%

    IF EXIST "%$Copyright%" (
        Title %~n0: %_file% -- Load IPTC - Copyright
        rem CALL "%$ExifTool%"  -@ "%$Copyright%" %_file% 2>"%tmp%\%~n0.EXIF.error" 
        rem TYPE "%tmp%\%~n0.EXIF.error"  >>%_TraceFile%
        COPY "%$Copyright%" "%_Gps2LocationTags%">nul
    )

    Title %~n0: Search geonames: %_fileName% - %_longitude%/%_latitude%
    ECHO:%Date% - %TIME%: %$NAME% - %_file% - Convert GPS to location>%_TraceFile%
    CALL "%$SQLite.exe%" %$SQLite.db.geoname% <"%_Gps2LocationSql%" >>"%_Gps2LocationTags%" 2>>%_TraceFile%
    TYPE "%_Gps2LocationTags%" >>%_TraceFile%

    Title %~n0: %_file% -- Load IPTC
    :: Delete tmp files from ExifTool
    IF EXIST "%_file%_exiftool_tmp" DEL "%_file:/=\%_exiftool_tmp"
    Title %~n0: Update image: %_fileName%
    CALL "%$ExifTool%"  -@ "%_Gps2LocationTags%" %_file% 2>"%tmp%\%~n0.EXIF.error"
    TYPE "%tmp%\%~n0.EXIF.error"  >>%_TraceFile%
    TYPE "%tmp%\%~n0.EXIF.error"
    Title %~n0: Image updated: %_fileName% - %_longitude%/%_latitude%

GOTO :EOF


:mapGps2location _longitude _latitude _Distance
    SET $long=%~1
    SET $Lat=%~2
    SET $DIST=%~3
    
    ECHO:-- lati[%$lat%]
    ECHO:-- long[%$long%]
    ECHO:-- dist[%$dist%]
    ECHO:-- [%$lat%][%$long%]_[%$dist%]>&2

    ECHO:-- Load module
    :: libsqlitefunctions.so
    ECHO:SELECT load_extension('%$SQLite_dir:\=/%%$SQLite.libSqlite%');

    ECHO:DROP TABLE IF EXISTS mytag;
    ECHO:-- Build temp table
    ECHO:CREATE TEMP TABLE IF NOT EXISTS mytag as
    ECHO:SELECT *,
    ECHO:3956 * 2 * ASIN^(SQRT^( POWER^(SIN^(^(%$lat% - latitude^) *  pi^(^)/180 / 2^), 2^) +COS^(%$lat% * pi^(^)/180^) * COS^(latitude * pi^(^)/180^) * POWER^(SIN^(^(%$long% - longitude^) * pi^(^)/180 / 2^), 2^) ^)^)
    ECHO:AS distance 
    ECHO:FROM geoname 
    ECHO:WHERE longitude BETWEEN ^(%$long% - %$dist%/abs^(cos^(^(%$lat%  * 0.01745327^)^)*69.0^)^) AND ^(%$long% + %$dist%/abs^(cos^(^(%$lat% * 0.01745327^)^)*69.0^)^)
    ECHO:AND latitude BETWEEN ^(%$lat%-^(%$dist%/69.0^)^) AND ^(%$lat%+^(%$dist%/69.0^)^)
    ECHO:ORDER BY distance
    ECHO:LIMIT 1
    ECHO:;

    ECHO:-- select * from mytag;

    :: Truncate alternatenames if longer than 32 characters
    ECHO:UPDATE mytag SET alternatenames=SUBSTR(alternatenames, 1, 32);

    ECHO:select 
    ECHO:char^(10^) ^|^| 
    ECHO:char^(10^) ^|^| '-IPTC:Country-PrimaryLocationName=' ^|^| countryinfo.name ^|^|
    ECHO:char^(10^) ^|^| '-XMP-photoshop:Country=' ^|^| countryinfo.name ^|^|
    ECHO:char^(10^) ^|^|
    ECHO:char^(10^) ^|^| '-IPTC:Country-PrimaryLocationCode=' ^|^| countryinfo.iso_alpha3 ^|^|
    ECHO:char^(10^) ^|^| '-XMP-iptcCore:CountryCode=' ^|^| countryinfo.iso_alpha3 ^|^|
    ECHO:char^(10^) 
    ECHO:from countryinfo, mytag 
    ECHO:where countryinfo.iso_alpha2 = mytag.country  limit 1;
    ECHO:
    
    ECHO:SELECT  
    ECHO:char^(10^) ^|^| '' ^|^|
    ECHO:char^(10^) ^|^| '-IPTC:Province-State=' ^|^| alternatenames ^|^|
    ECHO:char^(10^) ^|^| '-XMP-photoshop:State=' ^|^| alternatenames ^|^|
    ECHO:char^(10^) ^|^| '' ^|^|
    ECHO:char^(10^) ^|^| '-IPTC:City=' ^|^| asciiname^|^|
    ECHO:char^(10^) ^|^| '-XMP-photoshop:City=' ^|^| asciiname^|^|
    ECHO:char^(10^) ^|^| '' ^|^|
    ECHO:char^(10^) ^|^| '-IPTC:Sub-location=' ^|^| name ^|^|
    ECHO:char^(10^) ^|^| '-XMP-iptcCore:Location=' ^|^| name  ^|^|
    ECHO:char^(10^) ^|^| '' ^|^|
    ECHO:char^(10^) ^|^| '-IPTC:Headline=' ^|^| name ^|^|
    ECHO:char^(10^) ^|^| '' ^|^|
    ECHO:char^(10^) ^|^| '-IPTC:Caption-Abstract=' ^|^| asciiname^|^| '  ' ^|^| alternatenames ^|^|
    ECHO:char^(10^) ^|^| '-XMP-dc:Description=' ^|^| asciiname^|^| '  ' ^|^| alternatenames ^|^|
    ECHO:char^(10^) ^|^| '-IFD0:ImageDescription=' ^|^| asciiname^|^| '  ' ^|^| alternatenames ^|^|
    ECHO:char^(10^) ^|^| char^(10^)
    ECHO:from mytag;
    ECHO:
GOTO :EOF

::*** End of File *****************************************************