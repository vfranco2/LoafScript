setlocal
reg query HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\ClickToRun\Configuration\ /v CDNBaseUrl
if %errorlevel%==0 (goto SwitchChannel) else (goto End)
:SwitchChannel
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\ClickToRun\Configuration /v CDNBaseUrl /t REG_SZ /d "http://officecdn.microsoft.com/pr/b8f9b850-328d-4355-9145-c59439a0c4cf" /f
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\ClickToRun\Configuration /v UpdateUrl /f
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\ClickToRun\Configuration /v UpdateToVersion /f
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\ClickToRun\Updates /v UpdateToVersion /f
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Office\16.0\Common\OfficeUpdate\ /f
rem "%CommonProgramFiles%\microsoft shared\ClickToRun\OfficeC2RClient.exe" /update user
:End
Endlocal
