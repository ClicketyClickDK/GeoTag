@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
::**********************************************************************
SET $NAME=%~n0
SET $DESCRIPTION=Spliting combined tags [like keywords] from previously tagged images [SQLite]
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
    SET _StartTime=%Date% %TIME%

    SET #ImageTag=%~1
    IF DEFINED #ImageTag SET #ImageTag=%#ImageTag%.

    REM SET #ImageDir=%~1
    REM IF NOT DEFINED #ImageDir SET #ImageDir=_ImageDir
    REM SET #ImagePattern=%~2
    REM IF NOT DEFINED #ImagePattern SET #ImagePattern=_ImagePattern

    ::"Y:\master\2011\2011-04-05_Eriks_fødselsdag\2011-04-05T17-19-00_IMG_2101.JPG"

    :: Tables to create
    SET FIELDSET=FILE IMAGE LOCATION DESCRIPTION CREATOR EDITOR KEYWORDS CATEGORIES INSTRUCTIONS
    SET SPLITFIELDSET=KEYWORDS-KEYWORD CATEGORIES-CATEGORY

    :: Table structures
    SET TABLE_FILE=filename, filesize, filetype, date
    SET TABLE_IMAGE=filename, ImageWidth, ImageHeight, Orientation
    SET TABLE_LOCATION=filename, GPSLatitude, GPSLongitude, GPSLatitudeRef, GPSLongitudeRef, GPSAltitude, GPSImgDirection, CountryCode, Country, ProvinceState, City, subLocation
    SET TABLE_DESCRIPTION=filename, headline, CaptionAbstract, Comment
    SET TABLE_CREATOR=filename, Copyright, Credit, URL, Contact, CreatorAddress, CreatorCity, CreatorRegion, CreatorPostalCode, CreatorCountry, CreatorWorkEmail, CreatorWorkTelephone, CreatorWorkURL
    SET TABLE_EDITOR=filename, Byline, BylineTitle, CaptionWriter, EditStatus
    ::SET TABLE_KEYWORDS=filename, Subject , Keywordlist
    SET TABLE_KEYWORDS=filename, Keywordlist
    SET TABLE_CATEGORIES=filename, SupplementalCategories
    SET TABLE_INSTRUCTIONS=filename, FixtureIdentifier, ObjectName, TransmissionReference, OriginatingProgram, ProgramVersion, Source, SpecialInstructions

    SET TABLE_KEYWORD=filename, Keyword
    SET TABLE_CATEGORY=filename, Category

    SET _META=%TMP%\meta.%#ImageTag%csv
    SET _META.TABLE=%TMP%\meta.%#ImageTag%
    SET _LOAD=%TMP%\load.meta.%#ImageTag%sql

:Process
    ECHO:- Preprocess meta
    IF EXIST "%_META%" move "%_META%" "%_META%.tmp0"
    
    REM ::  /M  - Multi-line mode. 
    REM ::  /X  - Enables extended substitution pattern syntax
    REM ::  /F InFile
    REM ::  /O OutFile
    ECHO:-- Removing newlines in comments and subjects
    CALL "%$UnderScore_dir%\jrepl.bat" "\r\r\n" " " /X /M /F "%_META%.tmp0" /O "%_META%.tmp1"

    CALL :Escape_chars "%_META%.tmp1" "%_META%.split"
    
    REM ECHO:-- Removing Ampersants 
    REM CALL "%$UnderScore_dir%\jrepl.bat" "\x26" "+" /X /M /F "%_META%.tmp1" /O "%_META%.tmp2"
    REM ECHO:-- Removing Quotes
REM ::    CALL "%$UnderScore_dir%\jrepl.bat" "\x22" "{x22}" /X /F "%_META%.tmp2" /O "%_META%.tmp3"
    REM CALL "%$UnderScore_dir%\jrepl.bat" "\x22" "\x22\x22" /X /F "%_META%.tmp2" /O "%_META%.tmp3"
    REM ECHO:-- Removing Apostrophe
REM ::    CALL "%$UnderScore_dir%\jrepl.bat" "\x27" "{x27}" /X /F "%_META%.tmp3" /O "%_META%.tmp4"
    REM CALL "%$UnderScore_dir%\jrepl.bat" "\x27" "\x27\x27" /X /F "%_META%.tmp3" /O "%_META%.tmp4"

    ::COPY "%_META%.tmp4" "%_META%.split"
    SET _META=%_META%.split
    
    ::ECHO:- Building load file for metadata [%_LOAD%]
    ECHO:-- Loading meta geonames data into geonames >"%_LOAD%"
REM (
    REM :: libsqlitefunctions.so
    REM ::ECHO:SELECT load_extension('%$SQLite_dir:\=/%%$SQLite.libSqlite%');

   REM ECHO:.echo on
   REM ::ECHO:.changes on
   REM ::ECHO:.scanstats on
   REM ::ECHO:.timer on
REM ) >>"%_LOAD%"

    ::ECHO:SELECT load_extension^('%$SQLite_dir:\=/%%$SQLite.libSqlite%'^); >>"%_LOAD%"

    ECHO:.separator "\t" >>"%_LOAD%"
    
    FOR %%a IN ( %FIELDSET% ) DO (
        ECHO:- Extract %%a 
        TITLE %$NAME%: Extract "%%a"
        REM ::ECHO:    from "%_META%" 
        REM ::ECHO:    to "%_META.TABLE%%%a.csv"
        findstr "^%%a" "%_META%" >"%_META.TABLE%%%a.csv"
        REM ECHO:- Build SQL

        (
            ECHO:--%%a
            ECHO:CREATE TABLE IF NOT EXISTS image_%%a ^( !TABLE_%%a! ^);
            ECHO:CREATE TEMP TABLE DummyTable^( %%a, !TABLE_%%a! ^);
            ECHO:.import "%_META.TABLE:\=/%%%a.csv" DummyTable
            ECHO:INSERT INTO image_%%a SELECT !TABLE_%%a! FROM DummyTable;
            ECHO:DROP TABLE DummyTable;
            ECHO:
        ) >>"%_LOAD%"
    )

    ::CALL :split KEYWORDS    KEYWORD
    ::CALL :split CATEGORIES  CATEGORY
    FOR %%a IN ( %SPLITFIELDSET% ) DO (
        FOR /F "DELIMS=- TOKENS=1,*" %%b IN ( "%%a" ) DO CALL :split "%%b" "%%c"
    )

    TITLE %$NAME%: Clean up
    ECHO;-- Clean up after deleting tables and dublicates
    ECHO:Vacuum;>>"%_LOAD%"
    ECHO:.mode tabs>>"%_LOAD%"
    
    FOR %%a IN ( %FIELDSET% ) DO ( 
        ECHO:SELECT printf^("%%-30s:%%10s" , "image_%%a", count^(*^) ^) FROM image_%%a;
    )>>"%_LOAD%"
    

    FOR %%a IN ( %SPLITFIELDSET% ) DO (
        FOR /F "DELIMS=- TOKENS=1,*" %%b IN ( "%%a" ) DO ( 
            ECHO:SELECT printf^("%%-30s:%%10s" , "image_%%c", count^(*^) ^) FROM image_%%c;
        )>>"%_LOAD%"
    )

::    FOR %%a IN ( %SPLITFIELDSET% ) DO (

::    ECHO:-- Removing Quotes
::    CALL "%$UnderScore_dir%\jrepl.bat" "\x22" "{x22}" /X /F "%_META%.tmp2" /O "%_META%.tmp3"
::    ECHO:-- Removing Apostrophe
::    CALL "%$UnderScore_dir%\jrepl.bat" "\x27" "{x27}" /X /F "%_META%.tmp3" /O "%_META%.tmp4"





    FOR %%a IN ( %SPLITFIELDSET% ) DO (
        FOR /F "DELIMS=- TOKENS=1,*" %%b IN ( "%%a" ) DO ( 
            ECHO:- Unescape %%c
            TITLE %$NAME%: Unescape "%%c"
            CALL :UnEscape_chars "%_META.TABLE%%%c.csv" "%_META.TABLE%%%c.csv"
        )
    )

    FOR %%a IN ( %FIELDSET% ) DO (
        ECHO:- Unescape %%a 
        TITLE %$NAME%: Unescape "%%a"
        CALL :Escape_chars "%_META.TABLE%%%a.csv" "%_META.TABLE%%%a.csv"
    )
    
    ECHO:SELECT "Quitting";>>"%_LOAD%"
    ECHO:.quit>>"%_LOAD%"


    DIR "%_LOAD%"
    

    ECHO: Start: [%_StartTime%]
    ECHO: End:   [%Date% %TIME%]
    TITLE %$NAME% v. %$VERSION% rev. %$Revision% - done!
GOTO :EOF

::----------------------------------------------------------------------

:Escape_chars
SETLOCAL
    SET _In=%~1
    SET _Out=%~2
    
    ECHO:-- Removing Ampersants 
    CALL "%$UnderScore_dir%\jrepl.bat" "\x26" "{x26}" /X /M /F "%_in%" /O "%_in%.esc2"

    ECHO:-- Removing Quotes
    CALL "%$UnderScore_dir%\jrepl.bat" "\x22" "{x22}" /X /F "%_in%.esc2" /O "%_in%.esc3"

    ECHO:-- Removing Apostrophe
    CALL "%$UnderScore_dir%\jrepl.bat" "\x27" "[x27}" /X /F "%_in%.esc3" /O "%_in%.esc4"

    :: Move result to out file
    MOVE "%_in%.esc4" "%_out%"
    :: Clear tmp files
    FOR /L %%a IN (2;1;4 ) DO IF EXIST "%_in%.esc%%a" DEL "%_in%.esc%%a" 
GOTO :EOF

::----------------------------------------------------------------------

:UnEscape_chars
    SET _In=%~1
    SET _Out=%~2
    
    ECHO:-- Removing Ampersants 
    CALL "%$UnderScore_dir%\jrepl.bat" "{x26}" "+" /X /M /F "%_in%" /O "%_in%.esc2"

    ECHO:-- Removing Quotes
    CALL "%$UnderScore_dir%\jrepl.bat" "{x22}" "\x22\x22" /X /F "%_in%.esc2" /O "%_in%.esc3"

    ECHO:-- Removing Apostrophe
    CALL "%$UnderScore_dir%\jrepl.bat" "{x27}" "\x27\x27" /X /F "%_in%.esc3" /O "%_in%.esc4"

    :: Move result to out file
    MOVE "%_in%.esc4" "%_out%"
    :: Clear tmp files
    FOR /L %%a IN (2;1;4 ) DO IF EXIST "%_in%.esc%%a" DEL "%_in%.esc%%a" 

GOTO :EOF

::----------------------------------------------------------------------

:Split
    ECHO: -- splitting %1 >&2
    IF EXIST "%_META.TABLE%%~2.csv" DEL "%_META.TABLE%%~2.csv"
    TITLE %$NAME%: Splitting %1 [please wait]

    FOR /F %%a IN  ('FIND /c "." ^<%_META.TABLE%%~1.CSV') DO SET "_LinesTotal=%%a"
    SET _LinesCount=0
    
    FOR /F "DELIMS=;" %%a IN ( 'TYPE "%_META.TABLE%%~1.CSV"' ) DO (
        CALL :Split_csv "%%a"
    ) >>"%_META.TABLE%%~2.csv"
    
    
    ECHO:- Build SQL
    CALL :Split_BuildSql "%~1" "%~2" >>"%_LOAD%"
GOTO :EOF   ::*** :Split ***

::----------------------------------------------------------------------

:split_csv

    SET _=%~1
    SET _=%_: =_%
    SET /A _LinesCount+=1
    TITLE %$NAME%: splitting %_LinesCount% / %_LinesTotal% [%_:~0,72%]
    ::[%~1]
::SETLOCAL
    FOR /F "tokens=1,2,3*" %%a IN ( "%_%" ) DO (
        CALL :shift_csv "%%c"
    )

GOTO :EOF

::----------------------------------------------------------------------

:shift_csv
    SET __=%~1
    ::SET __=%__: =_%
    SET __=%__:,_=;%
    SET __=%__:_= %

    
    FOR /F "delims=; tokens=1*" %%d IN ( "%__%" ) DO (
    IF "_, ="=="_%%d" GOTO :EOF
    IF "_ ="=="_%%d" GOTO :EOF
    ECHO:%%b	%%d
    IF NOT "_"=="_%%e" CALL :shift_csv "%%e"
)    
GOTO :EOF

::----------------------------------------------------------------------

:split_buildSql
        ECHO:-- %~2 
        ECHO:CREATE TABLE IF NOT EXISTS image_%~2 ^( !TABLE_%~2! ^);
        ECHO:.import "%_META.TABLE:\=/%%~2.csv" image_%~2

        ::ECHO:INSERT INTO image_%~2 SELECT !TABLE_%~2! FROM DummyTable;

        ECHO:-- Drop original concatenated table
        ECHO:DROP TABLE IF EXISTS image_%~1;
        ECHO:CREATE TEMP TABLE IF NOT EXISTS image_%~1^( dummy ^);
        
        ECHO:-- Clean out dublets
        :: http://stackoverflow.com/questions/8190541/deleting-duplicate-rows-from-sqlite-database
        ECHO:DELETE FROM image_%~2
        ECHO:WHERE  rowid NOT IN ^(
        ECHO:   SELECT      max(rowid) 
        ECHO:   FROM        image_%~2
        ECHO:   GROUP BY    %~2
        ECHO:^);
        ECHO:
GOTO :EOF

::*** End of File ***