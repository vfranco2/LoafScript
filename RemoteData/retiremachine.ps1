﻿#LoafScript built by Vlad Franco, Kristian Rica, Michael Hang, and Jagjot Singh

#Retires Local Machine

$bars = "+---------------------------------------------------------------------------------------------+" + "`n"
$break = "`n"
$success = " | Success"
$na = " | N/A"
$failed = " | Failed"

#Header
Write-Host $break$bars"| Retire Machine | Retires Local Machine" -ForegroundColor Yellow
Write-Host $bars
Write-Host $bars"| Hit Enter to continue retire." -ForegroundColor Yellow
Write-Host "| Otherwise, close this window to exit." -ForegroundColor Yellow
Write-Host $bars
pause

try{
    Write-Host $bars"| Set Administrator Pass"$success -ForegroundColor Green
    net user Administrator Lemon001
}
catch{
    Write-Host $bars"| Set Administrator Pass"$failed -ForegroundColor Red
}
try{
    Write-Host $bars"| Set jsparrow Pass"$success -ForegroundColor Green
    net user jsparrow Lemon001
}
catch{
    Write-Host $bars"| Set jsparrow Pass"$failed -ForegroundColor Red
}
try{
    Add-Computer -WorkgroupName WG
    Write-Host $bars"| Set WorkGroup WG"$success -ForegroundColor Green
}
catch{
    Write-Host $bars"| Set WorkGroup WG"$failed -ForegroundColor Red
}
Write-Host $bars
pause