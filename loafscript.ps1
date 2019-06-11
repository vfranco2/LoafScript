#loafscript built by Vlad Franco and Jag Singh


#Select loaf option
do{$Type = Read-Host -Prompt 'Select an option
s=Setup
u=Uninstaller
'}
until(($Type -eq "s") -or ($Type -eq "u"))

switch ($Type){
"s" {#Script Path for Oracle Client x32
start powershell ((Split-Path $MyInvocation.InvocationName) + ".\Data\loafsetup.ps1")}

"u" {#Script Path for Oracle Client x64
start powershell ((Split-Path $MyInvocation.InvocationName) + ".\Data\loafuninstaller.ps1")}
}