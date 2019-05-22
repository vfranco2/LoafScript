#loafscript built by Vlad Franco and Jag Singh
#& "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\1.Oracle\Oracle_Oracle_12c_x32\Deploy-Application.ps1"}
#& "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\1.Oracle\Oracle_Oracle_12c_x64\Deploy-Application.ps1"}

do{$Type = Read-Host -Prompt 'Install Oracle? 3=32bit, 6=64bit, n=skip oracle'}
until(($Type -eq "3") -or ($Type -eq "6") -or ($Type -eq "n"))

switch ($Type){
"3" {#Script Path for Oracle Client x32
$ScriptPath = Split-Path $MyInvocation.InvocationName
& "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\1.Oracle\Oracle_Oracle_12c_x32\Deploy-Application.ps1"}

"6" {#Script Path for Oracle Client x64
$ScriptPath1 = Split-Path $MyInvocation.InvocationName
& "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\1.Oracle\Oracle_Oracle_12c_x64\Deploy-Application.ps1"}

"n" {#Skip that shit
Write-Host "Oracle Installation Skipped"}
}


#Setting Enviorment Variables 
[Environment]::SetEnvironmentVariable("TNS_ADMIN","C:\Oracle\product\12.1.0\dbhome_1\network\admin","Machine")


#Checks to see if Oracle Path Exists
try{
If(Test-Path -path "C:\Oracle\product\12.1.0\dbhome_1\network\admin"){
xcopy ".\Data\*ora" "C:\Oracle\product\12.1.0\dbhome_1\network\admin" /y
}
Else{Write-Errror "ERROR STEP 3: Oracle file not found or not installed"
}
}
catch{
"Couldn't copy ora files"
}


#Checks to see if Oracle is installed
try{
tnsping adtldev
}
catch{
"Oracle is not installed on this computer"
$error[0]
pause
}


#Checks bitlocker
manage-bde c: -protectors -get


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


#Check BIOS version
Write-Host "Bios Version"
wmic bios get smbiosbiosversion
wmic bios get serialnumber


#Get hostname
hostname >> H:\zzzhosts.txt


#Office updater script
do{$Type = Read-Host -Prompt 'Setup Office stuff? 6=64bit updater, 3=32bit updater, n=Skip this step'}
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


#Restart computer
Restart-Computer -Confirm:$true

pause