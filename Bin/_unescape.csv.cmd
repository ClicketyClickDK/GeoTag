
:UnEscape_chars
    SET _In=%~1
    SET _Out=%~2
    
    ECHO:-- Removing Ampersants 
    CALL "%~dp0\_\jrepl.bat" "{x26}" "+" /X /M /F "%_in%" /O "%_in%.esc2"

    ECHO:-- Removing Quotes
    CALL "%~dp0\_\jrepl.bat" "{x22}" "\x22\x22" /X /F "%_in%.esc2" /O "%_in%.esc3"

    ECHO:-- Removing Apostrophe
    CALL "%~dp0\_\jrepl.bat" "{x27}" "\x27\x27" /X /F "%_in%.esc3" /O "%_in%.esc4"

    :: Move result to out file
    MOVE "%_in%.esc4" "%_out%"
    :: Clear tmp files
    FOR /L %%a IN (2;1;4 ) DO IF EXIST "%_in%.esc%%a" DEL "%_in%.esc%%a" 

GOTO :EOF

::----------------------------------------------------------------------
