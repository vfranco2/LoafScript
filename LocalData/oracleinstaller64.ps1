#LoafScript built by Vlad Franco and Jagjot Singh

#Installs Oracle 64 Bit


#Invokes the Oracle Installer in \\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\1.Oracle\Oracle_Oracle_12c_x64\Deploy-Application.ps1
$ScriptPath = Split-Path $MyInvocation.InvocationName
& "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\1.Oracle\Oracle_Oracle_12c_x64\Deploy-Application.ps1"
#& "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\1.Oracle\Oracle_Oracle_12c_x64\Deploy-Application.ps1"


#Setting Enviorment Variables 
[Environment]::SetEnvironmentVariable("TNS_ADMIN","C:\Oracle\product\12.1.0\dbhome_1\network\admin","Machine")


#Checks to see if Oracle Path Exists
try{
    If(Test-Path -path "C:\Oracle\product\12.1.0\dbhome_1\network\admin"){
        xcopy "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\*.ora" "C:\Oracle\product\12.1.0\dbhome_1\network\admin" /y
    }
    Else{
        Write-Errror "ERROR: Oracle directory not found or Oracle not installed"
    }
}
catch{
    "Couldn't copy .ora files"
}

pause