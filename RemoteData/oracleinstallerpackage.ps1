#LoafScript built by Vlad Franco, Kristian Rica, Michael Hang, and Jagjot Singh

#Installs Oracle 32/64 Package

$oracleType = $args[0]
$bars = "+---------------------------------------------------------------------------------------------+" + "`n"
$break = "`n"
$success = " | Success"
$na = " | N/A"
$failed = " | Failed"

#Invokes the Custom Oracle Installers in RemoteData

#These installers have been changed from the standard ones found in \\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\1.Oracle
Write-Host $break$bars"| Oracle 32/64 Package Installer | Installs Both 32bit and 64bit Oracle Side-By-Side" -ForegroundColor Yellow
Write-Host $bars

#Install Oracle 32 & 64 from RemoteData instead of the usual location in _Post Image.
#These installers have some changed parameters for installation to allow both clients to work side-by-side.
& "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\1.Oracle\Oracle_Oracle_12c_x32\Deploy-Application.ps1"
& "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\1.Oracle\Oracle_Oracle_12c_x64\Deploy-Application.ps1"


#Set Symbolic Link Folders
Start-Process -Verb RunAs cmd.exe -Args '/c', 'mklink /d C:\Windows\SysWOW64\OracleLink C:\Oracle32'
Start-Process -Verb RunAs cmd.exe -Args '/c', 'mklink /d C:\Windows\System32\OracleLink C:\Oracle64'


#Setting Enviorment Variables
try{
    #Path variable
    $pathLink = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
    $pathLink = "C:\Windows\System32\OracleLink\product\12.1.0\dbhome_1\bin;" + $pathLink
    [System.Environment]::SetEnvironmentVariable('PATH', $pathLink, 'Machine')

    #Environment Variables
    [Environment]::SetEnvironmentVariable("TNS_ADMIN","C:\Oracle64\product\12.1.0\dbhome_1\network\admin","Machine")
    [Environment]::SetEnvironmentVariable("ORACLE_HOME","C:\Windows\System32\OracleLink\product\12.1.0\dbhome_1","Machine")
}
catch{
    Write-Host $bars"| Error: Could not set all environment variables" -ForegroundColor Red
    Write-Host $bars
}


#Copies .ora files to 32 and 64
try{
    If(Test-Path -path "C:\Oracle32\product\12.1.0\dbhome_1\network\admin"){
        xcopy "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\*.ora" "C:\Oracle32\product\12.1.0\dbhome_1\network\admin" /y
    }
    Else{
        Write-Host $bars"| ERROR: Oracle 32 directory not found or Oracle not installed" -ForegroundColor Red
        Write-Host $bars
    }
}
catch{
    Write-Host $bars"| Couldn't copy .ora files to 32bit" -ForegroundColor Red
    Write-Host $bars
}
try{
    If(Test-Path -path "C:\Oracle64\product\12.1.0\dbhome_1\network\admin"){
        xcopy "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\*.ora" "C:\Oracle64\product\12.1.0\dbhome_1\network\admin" /y
    }
    Else{
        Write-Host $bars"| ERROR: Oracle 64 directory not found or Oracle not installed" -ForegroundColor Red
        Write-Host $bars
    }
}
catch{
    Write-Host $bars"| Couldn't copy .ora files to 64bit" -ForegroundColor Red
    Write-Host $bars
}


#Setting Registry Keys
#ORACLE_HOME Keys
$oracleHome32 = "HKLM:\SOFTWARE\WOW6432Node\Oracle\KEY_OraClient12Home1_32bit"
$oracleHome64 = "HKCU:\SOFTWARE\Oracle\KEY_OraClient12Home1"
$oracleKeyName = "ORACLE_HOME"
$oracleKeyValue = "C:\Windows\System32\OracleLink\product\12.1.0\dbhome_1"

#Set 32bit key
try{
    IF(!(Test-Path $oracleHome32)) {
        New-Item -Path $oracleHome32 -Force | Out-Null
    }
    New-ItemProperty -Path $oracleHome32 -Name $oracleKeyName -Value $oracleKeyValue -PropertyType string -Force | Out-Null
    write-host $bars"| 32bit ORACLE_HOME key set" -ForegroundColor Green
}
catch{
    write-host $bars"| Could not set 32bit ORACLE_HOME key" -ForegroundColor Red
}
Write-Host $bars
#Set 64bit key
try{
    IF(!(Test-Path $oracleHome64)) {
        New-Item -Path $oracleHome64 -Force | Out-Null
    }
    New-ItemProperty -Path $oracleHome64 -Name $oracleKeyName -Value $oracleKeyValue -PropertyType string -Force | Out-Null
    write-host $bars"| 64bit ORACLE_HOME key set" -ForegroundColor Green
}
catch{
    write-host $bars"| Could not set 64bit ORACLE_HOME key" -ForegroundColor Red
}
Write-Host $bars

pause