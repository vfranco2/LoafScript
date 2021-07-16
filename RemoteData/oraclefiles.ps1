#LoafScript built by Vlad Franco, Kristian Rica, Michael Hang, and Jagjot Singh

#Installs Oracle Environment Variables and .ora files

$bars = "+---------------------------------------------------------------------------------------------+" + "`n"
$break = "`n"
$success = " | Success"
$na = " | N/A"
$failed = " | Failed"

#Header
Write-Host $break$bars"| Oracle Files | Copies sqlnet.ora, tnsnames.ora to Local Machine, Sets Environment Variables" -ForegroundColor Yellow
Write-Host $bars

#Setting Enviorment Variables 
[Environment]::SetEnvironmentVariable("TNS_ADMIN","C:\Oracle\product\12.1.0\dbhome_1\network\admin","Machine")

#Oracle Detector, Checks To See If Oracle Path Exists
try{
    IF((Test-Path -path "C:\Oracle\product\12.1.0\dbhome_1\network\admin") -And (Test-Path -path "C:\Program Files (x86)\Oracle")) {
        Write-Host $bars"| Found Oracle 32bit" -ForegroundColor Green
        xcopy "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\*.ora" "C:\Oracle\product\12.1.0\dbhome_1\network\admin" /y
    }
    ELSEIF((Test-Path -path "C:\Oracle\product\12.1.0\dbhome_1\network\admin") -And (Test-Path -path "C:\Program Files\Oracle")) {
        Write-Host $bars"| Found Oracle 64bit" -ForegroundColor Green
        xcopy "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\*.ora" "C:\Oracle\product\12.1.0\dbhome_1\network\admin" /y
    }
    ELSEIF((Test-Path -path "C:\Oracle64") -And (Test-Path -path "C:\Oracle32")) {
        Write-Host $bars"| Found Oracle 64bit & Oracle 32bit Package" -ForegroundColor Magenta
        
        [Environment]::SetEnvironmentVariable("TNS_ADMIN","C:\Oracle64\product\12.1.0\dbhome_1\network\admin","Machine")

        try{
            If(Test-Path -path "C:\Oracle32\product\12.1.0\dbhome_1\network\admin"){
                xcopy "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\*.ora" "C:\Oracle32\product\12.1.0\dbhome_1\network\admin" /y
            }
            Else{
                Write-Host $bars"| ERROR: Oracle 32 directory not found or Oracle not installed" -ForegroundColor Red
            }
        }
        catch{
            Write-Host $bars"| Couldn't copy .ora files to 32bit" -ForegroundColor Red
        }
        try{
            If(Test-Path -path "C:\Oracle64\product\12.1.0\dbhome_1\network\admin"){
                xcopy "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\*.ora" "C:\Oracle64\product\12.1.0\dbhome_1\network\admin" /y
            }
            Else{
                Write-Host $bars"| ERROR: Oracle 64 directory not found or Oracle not installed" -ForegroundColor Red
            }
        }
        catch{
            Write-Host $bars"| Couldn't copy .ora files to 64bit" -ForegroundColor Red
        }
    }
    ELSE {
        Write-Host $bars"| No Complete Oracle Install Found, Couldn't Copy .ora Files" -ForegroundColor Red
    }
}
catch{
    Write-Host $bars"| No Complete Oracle Install Found, Couldn't Copy .ora Files" -ForegroundColor Red
}
Write-Host $bars
pause