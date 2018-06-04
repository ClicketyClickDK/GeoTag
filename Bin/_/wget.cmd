::@echo OFF
:: The original wget.bat is a vb script, that cannot handle TLS 1.2
:: https://stackoverflow.com/a/41618979
::powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ; wget %~1 -OutFile %~2"

powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol = 'tls12, tls11, tls' ; wget %~1 -OutFile %~2"


GOTO :EOF
:: 
:: Please note:
:: TLS 1.2 is NOT a default secure protocol in WinHTTP in Windows:
:: https://support.microsoft.com/en-us/help/3140245/update-to-enable-tls-1-1-and-tls-1-2-as-a-default-secure-protocols-in
:: 
:: Failing on HTTPS TLS 1.2:
:: 
:: certutil  
:: Powershell.download
:: Powershell.wget
:: Powershell.curl
:: Powershell.Invoke-WebRequest
:: BITSAdmin
:: 
:: End of File