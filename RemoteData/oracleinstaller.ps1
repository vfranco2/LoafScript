#LoafScript built by Vlad Franco, Kristian Rica, Michael Hang, and Jagjot Singh

#Installs Oracle 32 or 64 Bit, depending on input parameter

#Invokes the Oracle Installers in:
#\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\1.Oracle\Oracle_Oracle_12c_x32\Deploy-Application.ps1
#\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\1.Oracle\Oracle_Oracle_12c_x64\Deploy-Application.ps1

$oracleType = $args[0]
$bars = "+---------------------------------------------------------------------------------------------+" + "`n"
$break = "`n"
$success = " | Success"
$na = " | N/A"
$failed = " | Failed"

Write-Host $break$bars"| Oracle Installer | Invoking $oracleType bit Installer" -ForegroundColor Yellow
Write-Host $bars


IF(($oracleType -eq 64) -or ($oracleType -eq 32)){
    #Invoke installer
    & "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\1.Oracle\Oracle_Oracle_12c_x$oracleType\Deploy-Application.ps1"

    #Run Oracle file copier after install completes
    & '\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\oraclefiles.ps1'
}
ELSE{
    Write-Host $bars"| Unknown or no input parameter found. Please follow the command to run this file with '32' or '64', depending on desired version." -ForegroundColor Red
    Write-Host $bars
}




