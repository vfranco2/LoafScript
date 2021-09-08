$bars = "+---------------------------------------------------------------------------------------------+" + "`n"
$break = "`n"
$success = " | Success"
$na = " | N/A"
$failed = " | Failed"

$RE = 'Cisco Anyconnect Secure'
$Key = 'REGISTRY::HKEY_CLASSES_ROOT\Installer\Products\'

#Find key
try{
    Get-ChildItem $Key -Rec -EA SilentlyContinue | ForEach-Object {
        $CurrentKey = (Get-ItemProperty -Path $_.PsPath)
        If ($CurrentKey -match $RE){
            Write-Host $bars"| Found Cisco Anyconnect Key At" $CurrentKey.PSPath -ForegroundColor Yellow
            Write-Host $bars"| Hit Enter to continue removal." -ForegroundColor Yellow
            Write-Host "| Otherwise, close this window to exit." -ForegroundColor Yellow
            Write-Host $bars
            pause
            try{
                Remove-Item -path $CurrentKey.PSPath -recurse -ErrorAction Stop
                Write-Host $bars"| Removed Cisco Anyconnect Key!" $CurrentKey.PSPath -ForegroundColor Green
            }
            catch{
                Write-Host $bars"| Error Removing Cisco Anyconnect Key" -ForegroundColor Red
            }

        }
    }
}
catch{
    Write-Host $bars"| No Known Cisco Anyconnect Key Found" -ForegroundColor Red
}
Write-Host $bars
pause
