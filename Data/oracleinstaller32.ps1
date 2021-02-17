﻿#loafscript built by Vlad Franco and Jag Singh

#Installs Oracle 32 Bit

$ScriptPath = Split-Path $MyInvocation.InvocationName
& "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\1.Oracle\Oracle_Oracle_12c_x32\Deploy-Application.ps1"
#& "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\Data\1.Oracle\Oracle_Oracle_12c_x32\Deploy-Application.ps1"

#Setting Enviorment Variables 
[Environment]::SetEnvironmentVariable("TNS_ADMIN","C:\Oracle\product\12.1.0\dbhome_1\network\admin","Machine")


#Checks to see if Oracle Path Exists
try{
If(Test-Path -path "C:\Oracle\product\12.1.0\dbhome_1\network\admin"){
xcopy "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\Data\*.ora" "C:\Oracle\product\12.1.0\dbhome_1\network\admin" /y
}
Else{Write-Errror "ERROR STEP 3: Oracle file not found or not installed"
}
}
catch{
"Couldn't copy ora files"
}

pause