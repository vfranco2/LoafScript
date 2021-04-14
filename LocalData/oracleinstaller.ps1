#LoafScript built by Vlad Franco and Jagjot Singh

#Installs Oracle 32 or 64 Bit, depending on input parameter

#Invokes the Oracle Installers in:
#\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\1.Oracle\Oracle_Oracle_12c_x32\Deploy-Application.ps1
#\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\1.Oracle\Oracle_Oracle_12c_x64\Deploy-Application.ps1

$oracleType = $args[0]
Write-Host $oracleType
IF(($oracleType -eq 64) -or ($oracleType -eq 32)){
    #Invoke installer
    $ScriptPath = Split-Path $MyInvocation.InvocationName
    & "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\1.Oracle\Oracle_Oracle_12c_x$oracleType\Deploy-Application.ps1"


    #Setting Enviorment Variables 
    [Environment]::SetEnvironmentVariable("TNS_ADMIN","C:\Oracle\product\12.1.0\dbhome_1\network\admin","Machine")


    #Checks to see if Oracle Path Exists
    try{
        If(Test-Path -path "C:\Oracle\product\12.1.0\dbhome_1\network\admin"){
            xcopy "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\*.ora" "C:\Oracle\product\12.1.0\dbhome_1\network\admin" /y
        }
        Else{
            Write-Error "ERROR: Oracle directory not found or Oracle not installed"
        }
    }
    catch{
        Write-Error "Couldn't copy .ora files"
    }

    pause
}
ELSE{
    Write-Error "Unknown or no input parameter found. Please follow the command to run this file with '32' or '64', depending on desired version."
    pause
    exit
}




