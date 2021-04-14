#LoafScript built by Vlad Franco and Jagjot Singh

#Installs Oracle 32/64 Package


#Invokes the Custom Oracle Installers in RemoteData

#These installers have been changed from the standard ones found in \\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\1.Oracle
Write-host "This is the Oracle 32/64 Package Installer."

#Install Oracle 32 & 64 from RemoteData instead of the usual location in _Post Image.
#These installers have some changed parameters for installation to allow both clients to work side-by-side.
$ScriptPath = Split-Path $MyInvocation.InvocationName
& "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\1.Oracle\Oracle_Oracle_12c_x32\Deploy-Application.ps1"
$ScriptPath = Split-Path $MyInvocation.InvocationName
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
    [Environment]::SetEnvironmentVariable("TNS_ADMIN","C:\Oracle\product\12.1.0\dbhome_1\network\admin","Machine")
    [Environment]::SetEnvironmentVariable("ORACLE_HOME","C:\Windows\System32\OracleLink\product\12.1.0\dbhome_1","Machine")
}
catch{
    Write-Error "Could not set all environment variables"
}


#Copies .ora files to 32 and 64
try{
    If(Test-Path -path "C:\Oracle32\product\12.1.0\dbhome_1\network\admin"){
        xcopy "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\*.ora" "C:\Oracle32\product\12.1.0\dbhome_1\network\admin" /y
    }
    Else{
        Write-Error "ERROR: Oracle 32 directory not found or Oracle not installed"
    }
}
catch{
    "Couldn't copy .ora files to 64bit"
}
try{
    If(Test-Path -path "C:\Oracle64\product\12.1.0\dbhome_1\network\admin"){
        xcopy "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\*.ora" "C:\Oracle64\product\12.1.0\dbhome_1\network\admin" /y
    }
    Else{
        Write-Error "ERROR: Oracle 64 directory not found or Oracle not installed"
    }
}
catch{
    Write-Error "Couldn't copy .ora files to 32bit"
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
    write-host "32bit ORACLE_HOME key set"
}
catch{
    write-error "Could not set 32bit ORACLE_HOME key"
}
#Set 64bit key
try{
    IF(!(Test-Path $oracleHome64)) {
        New-Item -Path $oracleHome64 -Force | Out-Null
    }
    New-ItemProperty -Path $oracleHome64 -Name $oracleKeyName -Value $oracleKeyValue -PropertyType string -Force | Out-Null
    write-host "64bit ORACLE_HOME key set"
}
catch{
    write-error "Could not set 64bit ORACLE_HOME key"
}

pause