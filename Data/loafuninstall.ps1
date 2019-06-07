#loafscript built by Vlad Franco and Jag Singh


do{$Type = Read-Host -Prompt 'Open Programs and Features to uninstall Office 64 bit? y/n'}
until(($Type -eq "y") -or ($Type -eq "n"))

switch ($Type){
"y" {#Launch programs and features
appwiz.cpl}

"n" {#Skip that shit
Write-Host "Programs and Features skipped"}
}