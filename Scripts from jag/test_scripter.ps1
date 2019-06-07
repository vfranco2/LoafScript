$Host_Name = Read-Host -Prompt 'Enter in user name (case sensitive):'
Copy-Item ".\3.Bios PW" -Destination "C:\Users\$Host_Name\Desktop" -Recurse
#LAUNCH BIOS PASSWORD HERE
#Get-Item C:\Users\$Host_Name\Desktop
pause