#LoafScript built by Vlad Franco and Jagjot Singh

#Uninstalls Oracle 32bit, Oracle 64bit, and the Oracle 32bit/64bit Package


$bars = "+---------------------------------------------------------------------------------------------+" + "`n"
$break = "`n"
$success = " | Success"
$na = " | N/A"
$failed = " | Failed"

#Header
Write-Host $break$bars"| Oracle Uninstaller | Removes 32bit, 64bit, and 32bit/64bit Package" -ForegroundColor Yellow
#Oracle Detecter
try{
    IF((Test-Path -path C:\Oracle) -And (Test-Path -path "C:\Program Files (x86)\Oracle")) {
        Write-Host $bars"| Found Oracle 32bit" -ForegroundColor Green
    }
    ELSEIF((Test-Path -path C:\Oracle) -And (Test-Path -path "C:\Program Files\Oracle")) {
        Write-Host $bars"| Found Oracle 64bit" -ForegroundColor Green
    }
    ELSEIF((Test-Path -path "C:\Oracle64") -And (Test-Path -path "C:\Oracle32")) {
        Write-Host $bars"| Found Oracle 64bit & Oracle 32bit Package" -ForegroundColor Magenta
    }
    ELSE {
        Write-Host $bars"| No Complete Oracle Install Found" -ForegroundColor Cyan
    }
}
catch{
    Write-Host $bars"| No Complete Oracle Install Found" -ForegroundColor Red
}
Write-Host $bars
Write-Host $bars"| Hit Enter to continue installation." -ForegroundColor Yellow
Write-Host "| Otherwise, close this window to exit." -ForegroundColor Yellow
Write-Host $bars
pause


#Remove Environment Variables
Write-Host $bars"| Environment Variables"
#C:\Oracle\product\12.1.0\dbhome_1\bin from Path
try{
    $pathLink = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
    $pathLink = ($pathLink.Split(';') | Where-Object { $_.TrimEnd('\') -ne 'C:\Oracle\product\12.1.0\dbhome_1\bin' }) -join ';'
    [System.Environment]::SetEnvironmentVariable('PATH', $pathLink, 'Machine')
    Write-Host $bars"| Remove Path Environment Variable Oracle Standard"$success -ForegroundColor Green
}
catch{
    Write-Host $bars"| Remove Path Environment Variable Oracle Standard"$failed -ForegroundColor Red
}
#C:\Windows\System32\OracleLink\product\12.1.0\dbhome_1\bin from Path
try{
    $pathLink = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
    $pathLink = ($pathLink.Split(';') | Where-Object { $_.TrimEnd('\') -ne 'C:\Windows\System32\OracleLink\product\12.1.0\dbhome_1\bin' }) -join ';'
    [System.Environment]::SetEnvironmentVariable('PATH', $pathLink, 'Machine')
    Write-Host $bars"| Remove Path Environment Variable Oracle Package"$success -ForegroundColor Green
}
catch{
    Write-Host $bars"| Remove Path Environment Variable Oracle Package"$failed -ForegroundColor Red
}
#TNS_ADMIN
try{
    [Environment]::SetEnvironmentVariable("TNS_ADMIN", $null, "Machine")
    Write-Host $bars"| Remove Environment Variable TNS_ADMIN"$success -ForegroundColor Green
}
catch{
    Write-Host $bars"| Remove Environment Variable TNS_ADMIN"$failed -ForegroundColor Red
}
#ORACLE_HOME
try{
    [Environment]::SetEnvironmentVariable("ORACLE_HOME", $null, "Machine")
    Write-Host $bars"| Remove Environment Variable ORACLE_HOME"$success -ForegroundColor Green
}
catch{
    Write-Host $bars"| Remove Environment Variable ORACLE_HOME"$failed -ForegroundColor Red
}
Write-Host $bars


#Remove Registry Keys
Write-Host $bars"| Registry Keys"
#32bit keys
try{
    IF(Test-Path -path HKLM:\SOFTWARE\WOW6432Node\Oracle) {
        Remove-Item -path HKLM:\SOFTWARE\WOW6432Node\Oracle -recurse -ErrorAction Stop
        Write-Host $bars"| Remove HKLM:\SOFTWARE\WOW6432Node\Oracle Key (For 32bit)"$success -ForegroundColor Green
    }
    ELSE {
        Write-Host $bars"| Remove HKLM:\SOFTWARE\WOW6432Node\Oracle Key (For 32bit)"$na -ForegroundColor Cyan
    }
}
catch{
    Write-Host $bars"| Remove HKLM:\SOFTWARE\WOW6432Node\Oracle Key (For 32bit)"$failed -ForegroundColor Red
}
#64bit keys
try{
    IF(Test-Path -path HKLM:\SOFTWARE\Oracle) {
        Remove-Item -path HKLM:\SOFTWARE\Oracle -recurse -ErrorAction Stop
        Write-Host $bars"| Remove HKLM:\SOFTWARE\Oracle Key (For 64bit)"$success -ForegroundColor Green
    }
    ELSE {
        Write-Host $bars"| Remove HKLM:\SOFTWARE\Oracle Key (For 64bit)"$na -ForegroundColor Cyan
    }
}
catch{
    Write-Host $bars"| Remove HKLM:\SOFTWARE\Oracle Key (For 64bit)"$failed -ForegroundColor Red
}
#OracleRemExecService
try{
    IF(Test-Path -path HKLM:\SYSTEM\CurrentControlSet\Services\OracleRemExecServiceV2) {
        Remove-Item -path HKLM:\SYSTEM\CurrentControlSet\Services\OracleRemExecServiceV2 -recurse -ErrorAction Stop
        Write-Host $bars"| Remove HKLM:\SYSTEM\CurrentControlSet\Services\OracleRemExecServiceV2 Key"$success -ForegroundColor Green
    }
    ELSE {
        Write-Host $bars"| Remove HKLM:\SYSTEM\CurrentControlSet\Services\OracleRemExecServiceV2 Key"$na -ForegroundColor Cyan
    }
}
catch{
    Write-Host $bars"| Remove HKLM:\SYSTEM\CurrentControlSet\Services\OracleRemExecServiceV2 Key"$failed -ForegroundColor Red
}
Write-Host $bars


#Remove Root Oracle Files
Write-Host $bars"| Root Oracle Files"
#Standard Install Folder
try{
    IF(Test-Path -path C:\Oracle) {
        Remove-Item -path C:\Oracle -recurse -force -ErrorAction Stop
        Write-Host $bars"| Remove C:\Oracle"$success -ForegroundColor Green
    }
    ELSE {
        Write-Host $bars"| Remove C:\Oracle"$na -ForegroundColor Cyan
    }
}
catch{
    Write-Host $bars"| Remove C:\Oracle"$failed -ForegroundColor Red
}
#32bit Package Install Folder
try{
    IF(Test-Path -path C:\Oracle32) {
        Remove-Item -path C:\Oracle32 -recurse -force -ErrorAction Stop
        Write-Host $bars"| Remove C:\Oracle32"$success -ForegroundColor Green
    }
    ELSE {
        Write-Host $bars"| Remove C:\Oracle32"$na -ForegroundColor Cyan
    }
}
catch{
    Write-Host $bars"| Remove C:\Oracle32"$failed -ForegroundColor Red
}
#64bit Package Install Folder
try{
    IF(Test-Path -path C:\Oracle64) {
        Remove-Item -path C:\Oracle64 -recurse -force -ErrorAction Stop
        Write-Host $bars"| Remove C:\Oracle64"$success -ForegroundColor Green
    }
    ELSE {
        Write-Host $bars"| Remove C:\Oracle64"$na -ForegroundColor Cyan
    }
}
catch{
    Write-Host $bars"| Remove C:\Oracle64"$failed -ForegroundColor Red
}
Write-Host $bars


#Remove Oracle 32 Bit
Write-Host $bars"| Oracle 32bit"
#Program Files (x86)
try{
    IF(Test-Path -path "C:\Program Files (x86)\Oracle") {
        Remove-Item -path "C:\Program Files (x86)\Oracle" -recurse -force -ErrorAction Stop
        Write-Host $bars"| Remove C:\Program Files (x86)\Oracle"$success -ForegroundColor Green
    }
    ELSE {
        Write-Host $bars"| Remove C:\Program Files (x86)\Oracle"$na -ForegroundColor Cyan
    }
}
catch{
    Write-Host $bars"| Remove C:\Program Files (x86)\Oracle"$failed -ForegroundColor Red
}
#Start Menu
try{
    IF(Test-Path -path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Oracle - OraClient12Home1_32bit") {
        Remove-Item -path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Oracle - OraClient12Home1_32bit" -recurse -force -ErrorAction Stop
        Write-Host $bars"| Remove Oracle Start Menu (For 32bit)"$success -ForegroundColor Green
    }
    ELSE {
        Write-Host $bars"| Remove Oracle Start Menu (For 32bit)"$na -ForegroundColor Cyan
    }
}
catch{
    Write-Host $bars"| Remove Oracle Start Menu (For 32bit)"$failed -ForegroundColor Red
}
#32bit Package Symbolic Link
try{
    IF(Test-Path -path "C:\Windows\SysWOW64\OracleLink") {
        #Remove-Item -path "C:\Windows\SysWOW64\OracleLink" -recurse -force -ErrorAction Stop
        $(get-item "C:\Windows\SysWOW64\OracleLink").Delete()
        Write-Host $bars"| Remove 32bit Package Symbolic Link"$success -ForegroundColor Green
    }
    ELSE {
        Write-Host $bars"| Remove 32bit Package Symbolic Link"$na -ForegroundColor Cyan
    }
}
catch{
    Write-Host $bars"| Remove 32bit Package Symbolic Link"$failed -ForegroundColor Red
}
Write-Host $bars


#Remove Oracle 64 Bit
Write-Host $bars"| Oracle 64bit"
#Program Files
try{
    IF(Test-Path -path "C:\Program Files\Oracle") {
        Remove-Item -path "C:\Program Files\Oracle" -recurse -force -ErrorAction Stop
        Write-Host $bars"| Remove C:\Program Files\Oracle"$success -ForegroundColor Green
    }
    ELSE {
        Write-Host $bars"| Remove C:\Program Files\Oracle"$na -ForegroundColor Cyan
    }
}
catch{
    Write-Host $bars"| Remove C:\Program Files\Oracle"$failed -ForegroundColor Red
}
#Start Menu
try{
    IF(Test-Path -path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Oracle - OraClient12Home1") {
        Remove-Item -path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Oracle - OraClient12Home1" -recurse -force -ErrorAction Stop
        Write-Host $bars"| Remove Oracle Start Menu (For 64bit)"$success -ForegroundColor Green
    }
    ELSE {
        Write-Host $bars"| Remove Oracle Start Menu (For 64bit)"$na -ForegroundColor Cyan
    }
}
catch{
    Write-Host $bars"| Remove Oracle Start Menu (For 64bit)"$failed -ForegroundColor Red
}
#64bit Package Symbolic Link
try{
    IF(Test-Path -path "C:\Windows\System32\OracleLink") {
        #Remove-Item -path "C:\Windows\System32\OracleLink" -recurse -force -ErrorAction Stop
        $(get-item "C:\Windows\System32\OracleLink").Delete()
        Write-Host $bars"| Remove 64bit Package Symbolic Link"$success -ForegroundColor Green
    }
    ELSE {
        Write-Host $bars"| Remove 64bit Package Symbolic Link"$na -ForegroundColor Cyan
    }
}
catch{
    Write-Host $bars"| Remove 64bit Package Symbolic Link"$failed -ForegroundColor Red
}
Write-Host $bars
pause