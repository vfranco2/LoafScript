#loafscript built by Vlad Franco and Jag Singh


#Prompts user to uninstall either oracle or ms office (more oracle options coming soon!)
do{$Type = Read-Host -Prompt 'Uninstall Oracle 32/64 or uninstall MS Office?
o=Oracle
m=MS Office'}
until(($Type -eq "o") -or ($Type -eq "m"))

switch ($Type){
"o" {#Launch Oracle uninstaller script
start powershell ((Split-Path $MyInvocation.InvocationName) + ".\loafuninoracle.ps1")}

"m" {#Launch programs and features
appwiz.cpl}
}



