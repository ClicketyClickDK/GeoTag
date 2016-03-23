@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
::**********************************************************************
SET $NAME=%~n0
SET $DESCRIPTION=Get latest/newest/highest version number from scripts and insert into table System
SET $AUTHOR=Erik Bachmann, ClicketyClick.dk [ErikBachmann@ClicketyClick.dk]
SET $SOURCE=%~f0 
::@(#)NAME
::@(-)  The name of the command or function, followed by a one-line description of what it does.
::@(#)      %$NAME% -- %$DESCRIPTION%
::@(#) 
::@(#)SYNOPSIS
::@(-)  In the case of a command, a formal description of how to run it and what command line options it takes. 
::@(-)  For program functions, a list of the parameters the function takes and which header file contains its definition.
::@(-)  
::@(#)      %$NAME%
:: [File] [n]
::@(#) 
::@ (#)OPTIONS
::@ (-)  Flags, parameters, arguments (NOT the Monty Python way)
::@ (#)  -h      Help page
::@ (#) n   Number of lines to print, default=10 
::@ (#) 
::@(#)DESCRIPTION
::@(-)  A textual description of the functioning of the command or function.
::@(#)  Loop through all scripts and extract version meta data.
::@(#)  Insert the latest change into the system table 
::@(#) 
::@ (#)EXAMPLES
::@ (-)  Some examples of common usage.
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
::@(-)  Dependecies
::@ (#)  _Debug.cmd      Setting up debug environment for batch scripts 
::@ (#)  _GetOpt.cmd     Parse command line options and create environment vars
::@(#)  "%~dp0\Geotag.config.cmd"
::@(#)  "%~dp0\_\merge.cmd"
::@(#)  
::@ (#)SEE ALSO
::@ (-)  A list of related commands or functions.
::@ (#)
::@ (#)  
::@(#)REFERENCE
::@(-)  References to inspiration, clips and other documentation
::@ (#)  Author:
::@ (#)  URL: 
::@ (#) 
::@(#)
::@(#)SOURCE
::@(-)  Where to find this source
::@(#)  %$Source%
::@(#)
::@ (#)AUTHOR
::@(-)  Who did what
::@ (#)  %$AUTHOR%
::*** HISTORY **********************************************************
::SET $VERSION=YYYY-MM-DD&SET $REVISION=hh:mm:ss&SET $COMMENT=Description/init
  SET $VERSION=2016-03-21&SET $REVISION=11:47:00&SET $COMMENT=init / ErikBachmann
::**********************************************************************
::@(#)(c)%$Version:~0,4% %$Author%
::********************************************************************** 

:MAIN
    CALL :init
    CALL :Process
    CALL :Finalize
GOTO :EOF

::---------------------------------------------------------------------

:init
    CALL "%~dp0\_header"
    CALL "%~dp0\Geotag.config.cmd"

    SET tmpFile=%temp%\getVersion.txt
    SET tmpBat=%temp%\getVersion.bat
    SET tmpName=%temp%\getVersion.file
    SET tmpSql=%temp%\getVersion.sql
    SET tmpMerge=%temp%\getVersion.merge
    FOR %%a IN ("%TmpFile%" "%tmpBat%" "%TmpName%" "%tmpSql%" "%tmpMerge%") DO IF EXIST "%%a" DEL "%%a"
GOTO :EOF   *** :init ***

::---------------------------------------------------------------------

:Process
    TITLE %$NAME% v.%$Version% - %$DESCRIPTION%
    (
        for %%a IN ( bin\*.cmd bin\*.bat ) do (
            ECHO: ^&SET $FILE=%%a>>"%tmpName%" 
            FIND "  SET $VERSION" <%%a >>"%tmpFile%"
        )
    )
    TITLE %$NAME% :: Merge Version data and file name
    CALL "%~dp0\_\merge" "%tmpFile%" "%tmpName%" "%tmpMerge%"
    TITLE %$NAME% :: Sort Version data and file name
    sort < "%tmpMerge%" >"%tmpFile%"

    TITLE %$NAME% :: Count all lines in file
    FOR /F "tokens=1 delims=:" %%G IN ('FINDSTR /nr ".*" "%tmpFile%"') DO (SET _num_lines=%%G)

    TITLE %$NAME% ECHO: Lines:%_num_lines%
    SET /A skip=_num_lines-1
    IF /I %skip% LEQ 0 Set skip=0
    TITLE %$NAME% :: Find latest version
    MORE /E +%skip% "%tmpFile%" >"%tmpbat%"

    SETLOCAL
        TITLE %$NAME% :: Set environment for latest Version data and file name
        CALL "%tmpbat%"
        ECHO v.[%$VERSION%] r.[%$REVISION%]
        TITLE %$NAME% : Latest v.[%$VERSION%] r.[%$REVISION%]

        TITLE %$NAME% :: Build SQL load     
        (
            ECHO:INSERT OR REPLACE INTO system^(section, name, value, note^) VALUES^('system','SoftwareVersion','%$VERSION%','Main version of scripting'^);
            ECHO:INSERT OR REPLACE INTO system^(section, name, value, note^) VALUES^('system','SoftwareRevision','%$REVISION%','Main revision of scripting'^);
            ECHO:INSERT OR REPLACE INTO system^(section, name, value, note^) VALUES^('system','SoftwareNewestFile','%$FILE%','Newest file revision of scripting'^);
            ECHO:.mode line
            ::ECHO:SELECT * FROM system WHERE section = 'system' AND ^(name IN ('SoftwareVersion', 'SoftwareRevision', 'SoftwareNewestFile'^) ^);
            ECHO:SELECT * FROM system WHERE section = 'system' AND name like 'Software%%' ;
        )>"%tmpSql%"

        TITLE %$NAME% :: Load Version data and file name
        :: Note the terminating ".quit": -init ignores .q in the SQL load file
        CALL "%$SQLite.exe%" "%$SQLite.db.geoname%" -init "%tmpSql%" .quit
    ENDLOCAL
GOTO :EOF   *** :Process ***

::---------------------------------------------------------------------

:Finalize
    ECHO DEL "%tmpbat%" "%tmpFile%" "%tmpSql%"
GOTO :EOF   *** :Finalize ***

::*** End of File *****************************************************