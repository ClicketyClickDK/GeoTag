
:AbsolutPath relativePath return
SETLOCAL
    FOR /F %%i IN ("%~1") DO SET _absolutePath=%%~fi
ENDLOCAL&SET %~2=%_absolutePath%
GOTO :EOF
