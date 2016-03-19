

:Escape_chars
SETLOCAL
    SET _In=%~1
    SET _Out=%~2
    ECHO:Escaping [%~1]
    :: /F InFile 
    :: /M  - Multi-line mode.
    :: /X  - Enables extended substitution pattern

    ::2016-03-06: Removing Ampersants is not nessesary
    ::ECHO:-- Removing Ampersants 
    ::CALL "%~dp0\_\jrepl.bat" "\x26" "{x26}" /X /F "%_in%" /O "%_in%.esc2"
    COPY "%_in%" "%_in%.esc2"

    ::ECHO:-- Removing Quotes
    TITLE %_in% - Removing Quotes
    CALL "%~dp0\_\jrepl.bat" "\x22" "{x22}" /X /F "%_in%.esc2" /O "%_in%.esc3"

    ::ECHO:-- Removing Apostrophe
    TITLE %_in% - Removing Apostrophe
    CALL "%~dp0\_\jrepl.bat" "\x27" "{x27}" /X /F "%_in%.esc3" /O "%_in%.esc4"

    TITLE %_in% - Move result to out file [%_out%]
    MOVE "%_in%.esc4" "%_out%"
    :: Clear tmp files
    FOR /L %%a IN (2;1;4 ) DO IF EXIST "%_in%.esc%%a" DEL "%_in%.esc%%a" 
GOTO :EOF

::----------------------------------------------------------------------
