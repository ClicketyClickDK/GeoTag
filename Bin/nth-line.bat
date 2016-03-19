@ECHO OFF
:: URL: http://stackoverflow.com/questions/2701910/windows-batch-file-to-echo-a-specific-line-number
:: http://stackoverflow.com/a/27122848
:: Autor: Amr Ali 
    CALL :ReadNthLine "%~1" %~2
GOTO :EOF

:ReadNthLine File nLine
    FOR /F %%A IN ('^<"%~1" FIND /C /V ""') DO IF %2 GTR %%A (ECHO Error: No such line %2. 1>&2 & EXIT /b 1)
    FOR /F "tokens=1* delims=]" %%A IN ('^<"%~1" FIND /N /V "" ^| FINDSTR /B /C:"[%2]"') DO ECHO.%%B
EXIT /b