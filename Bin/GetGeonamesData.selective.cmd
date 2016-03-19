@ECHO OFF
SETLOCAL
:init
    REM CALL "%~dp0\_banner"
    CALL "%~dp0\_Header"

    CALL "%~dp0\Geotag.config.cmd"
    SET _LogFile=%$NAME%.log
    
    ::SET _GeonamesURL

    IF EXIST "%_DataDir%\myCountries.txt" DEL "%_DataDir%\myCountries.txt"
    ::              a:Zip b:target c:URL d:description
    FOR /F "Delims=	 tokens=1,5" %%a IN ('TYPE "%~dp0\CountryInfo.selective.txt"^|FINDSTR -v "^#"') DO (
        CALL "%~dp0\_\_Action" "- %%b"
        CALL "%~dp0\_\_State" "- %%a"
        TITLE %$NAME%: Downloading %%a - %%b - please wait...
        CALL "%~dp0\_\_Status" "Downloading..."

        ECHO:^<[%_GeonamesURL%+%%a.zip]>>"%_LogFile%"
        ECHO:^>"%_DataDir%\%%a.zip">>"%_LogFile%"
        CALL "%~dp0\_\wget.bat" "%_GeonamesURL%%%a.zip" "%_DataDir%\%%a.zip"
        TITLE %$NAME%:Download done  %%a - %%b
        CALL "%~dp0\_\_Status" "Downloaded"

        TITLE %$NAME%:Unzipping %%a - %%b
        CALL "%~dp0\_\unzip.bat" "%_DataDir%\%%a.zip" "%_DataDir%"
        TYPE "%_DataDir%\%%a.txt">>"%_DataDir%\myCountries.txt"
    )

::*** End of File *****************************************************