::@echo OFF
:: The original wget.bat is a vb script, that cannot handle TLS 1.2
:: https://stackoverflow.com/a/41618979
::powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ; wget %~1 -OutFile %~2"

CALL "%~dp0\wget.cmd" %*

:: End of File
