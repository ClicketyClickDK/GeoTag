@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION&::(Don't pollute the global environment with the following)
::**********************************************************************
SET $NAME=%~n0
SET $DESCRIPTION=Get history from all scripts
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
::@(#)      %$NAME% [--HTML]
:: [File] [n]
::@(#) 
::@(#)OPTIONS
::@ (-)  Flags, parameters, arguments (NOT the Monty Python way)
::@(#)  -h      Help page
::@(#) --HTML   Output as HTML table (Default: text)
::@(#) 
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
::SET $VERSION=2016-03-21&SET $REVISION=11:47:00&SET $COMMENT=init / ErikBachmann
::SET $VERSION=2016-03-24&SET $REVISION=17:34:00&SET $COMMENT=HTML history / ErikBachmann
  SET $VERSION=2016-03-24&SET $REVISION=18:30:00&SET $COMMENT=Robust list / ErikBachmann
::**********************************************************************
::@(#)(c)%$Version:~0,4% %$Author%
::********************************************************************** 

:MAIN
    CALL :init %*
    CALL :Process
    CALL :Finalize
GOTO :EOF

::---------------------------------------------------------------------

:init
    CALL "%~dp0\_header"
    CALL "%~dp0\Geotag.config.cmd"
    CALL "%~dp0\_\_getopt" %*
    
    ECHO:
    SET _OldFile=SET
    SET _scripts="%~dp0\*.cmd" "%~dp0\*.bat" "%~dp0\*.sql"
    SET _scripts=bin\*.cmd bin\*.bat bin\*.sql .\*.cmd .\*.bat
    ::SET _scripts=*.cmd *.bat *.sql 

    SET tmpFile=%temp%\getVersion.File.txt
    SET tmpVer=%temp%\getVersion.Ver.txt
    SET tmpBat=%temp%\getVersion.Bat.bat
    SET tmpName=%temp%\getVersion.Name.txt
    SET tmpMerge=%temp%\getVersion.merge.txt
    FOR %%a IN ("%TmpFile%" "%TmpVer%" "%TmpBat%" "%TmpName%" "%tmpSql%" "%tmpMerge%") DO IF EXIST "%%a" DEL "%%a"
    
    ::SET @
    ::SET $
GOTO :EOF   *** :init ***

::---------------------------------------------------------------------

:Process
    TITLE %$NAME% v.%$Version% - %$DESCRIPTION%
    (
        FOR %%a IN ( %_scripts% ) do (
            REM IF /I ".sqlite"=="%%~xa" GOTO :EOF
            REM ECHO:- %%a
            TITLE %$NAME%: [%%a]
            FIND "%_OldFile% $VERSION=2" <%%a >"%tmpFile%"
            REM TYPE "%tmpFile%"
            SET _num_lines=0
            FOR /F "tokens=1 delims=:" %%G IN ('FINDSTR /n ":" "%tmpFile%"') DO SET _num_lines=%%G
            REM ECHO Antal linjer: !_num_lines!.
            REM FOR /L %%A IN (1,1,!_num_lines!) DO ECHO -
            FOR /L %%A IN (1,1,!_num_lines!) DO ECHO: ^&SET $FILE=%%a>>"%tmpName%" 
            TYPE "%tmpFile%" >>"%tmpVer%"
        )
    )
    TITLE %$NAME% :: Merge Version data and file name
    CALL "%~dp0_\merge" "%tmpVer%" "%tmpName%" "%tmpMerge%"

    TITLE %$NAME% :: loop through all lines in file
    FOR /F "tokens=1,2,3,4 delims=&" %%a IN ('TYPE "%tmpMerge%"') DO CALL :processFile1 "%%a" "%%b" "%%c" "%%d"

    TITLE %$NAME% :: Sort Version data and file name
    sort < "%tmpBat%" >"%tmpFile%"
    
    IF DEFINED @%$NAME%.html (
        ECHO:^<TABLE^>
    )
    FOR /F "tokens=1,2,3,4 delims=;" %%a IN ('TYPE "%tmpFile%"') DO CALL :processFile2 "%%a" "%%b" "%%c" "%%d"

    IF DEFINED @%$NAME%.html (
        ECHO:^</TABLE^>
    )
GOTO :EOF   *** :Process ***

:ProcessFile1
    SET #VERSION=%~1
    SET #REVISION=%~2
    Set #COMMENT=%~3
    SET #FILE=%~4
    
    ::ECHO:--"%#VERSION:~0,2%"
    IF ":  "==":%#VERSION:~0,2%" SET #VERSION=%#VERSION:~2%
    IF ":::"==":%#VERSION:~0,2%" SET #VERSION=%#VERSION:~2%
    ::ECHO %#VERSION% %#REVISION% %#COMMENT% %#FILE%
    SET #VERSION=%#VERSION:~13%
    SET #REVISION=%#REVISION:~14%
    SET #COMMENT=%#COMMENT:~13%
    SET #FILE=%#FILE:~10%

    ECHO:%#VERSION%;%#REVISION%;%#COMMENT%;%#FILE%>>"%tmpBat%"
GOTO:EOF
:ProcessFile2
    REM ECHO:--
    REM IF NOT "%_OldFile%"=="%#VERSION%" ECHO:%#VERSION%&SET _OldFile=%#VERSION%
    REM ECHO:- %#REVISION% %#FILE% %#COMMENT%
    IF DEFINED @%$NAME%.html (
        IF NOT "%_OldFile%"=="%~1" ECHO:^<TR^>^<TH^>%~1^</TH^>^</TR^>&SET _OldFile=%~1
        ECHO:^<TR^>^<TD^>^&nbsp;^</TD^>^<TD^>%~2^</TD^>^<TD^>%~4^</TD^>^<TD^>%~3^</TD^>^</TR^> 
    ) ELSE (
        IF NOT "%_OldFile%"=="%~1" ECHO:%~1&SET _OldFile=%~1
        CALL "%~dp0\_\_action" "- %~2 %~4%"
        ECHO:%~3 
    )
GOTO:EOF
::---------------------------------------------------------------------

:Finalize
    ::ECHO DEL "%tmpbat%" "%tmpFile%" "%tmpSql%"
    ::IF DEFINED @%$NAME%.html ECHO HTML  
GOTO :EOF   *** :Finalize ***

::*** End of File *****************************************************