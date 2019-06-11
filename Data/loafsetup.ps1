#loafscript built by Vlad Franco and Jag Singh


#Oracle Installer Prompt
do{$Type = Read-Host -Prompt 'Install Oracle? 3=32bit, 6=64bit, n=skip oracle'}
until(($Type -eq "3") -or ($Type -eq "6") -or ($Type -eq "n"))
switch ($Type){
"3" {#Script Path for Oracle Client x32
start powershell ((Split-Path $MyInvocation.InvocationName) + ".\oracleinstaller32.ps1")}
"6" {#Script Path for Oracle Client x64
start powershell ((Split-Path $MyInvocation.InvocationName) + ".\oracleinstaller64.ps1")}
"n" {#Skip that shit
Write-Host "Oracle Installation Skipped"}
}


#Checks bitlocker
manage-bde c: -protectors -get


#Check BIOS version
Write-Host "Bios Version"
wmic bios get smbiosbiosversion
wmic bios get serialnumber


#Get hostname
hostname >> H:\zzzhosts.txt


#Office updater script
do{$Type = Read-Host -Prompt 'Run MS Office Updater?  3=32bit updater, 6=64bit updater, n=Skip this step'}
until(($Type -eq "6") -or ($Type -eq "3") -or ($Type -eq "n"))
switch ($Type){
"6" {#Update office 64 bit
$ScriptPath = Split-Path $MyInvocation.InvocationName
& ".\Data\Update Office to Semi Annual Channel - 64bit.bat"
}
"3" {#Update office 32 bit
$ScriptPath = Split-Path $MyInvocation.InvocationName
& ".\Data\Update Office to Semi Annual Channel.bat"
}
"n" {#Skip that shit
Write-Host "Office update Skipped"}
}


#HIPA Prompt
do{$Type = Read-Host -Prompt 'Launch HIPA? y/n'}
until(($Type -eq "y") -or ($Type -eq "n"))
switch ($Type){
"y" {#Path for HIPA launcher
$ScriptPath = Split-Path $MyInvocation.InvocationName
& "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\2.Drivers\sp94976.exe"}
"n" {#Skip that shit
Write-Host "HIPA Skipped"}
}


#BIOS Password
