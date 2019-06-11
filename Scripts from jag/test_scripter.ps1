$User_Name = Read-Host -Prompt 'Enter in user name (case sensitive):'
Copy-Item "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\3.Bios PW" -Destination "C:\Users\$User_Name\Desktop" -Recurse

#LAUNCH BIOS PASSWORD HERE
$ScriptPath = Split-Path $MyInvocation.InvocationName
& "C:\Users\vfranco1\Desktop\3.Bios PW\biosPW.bat"

pause