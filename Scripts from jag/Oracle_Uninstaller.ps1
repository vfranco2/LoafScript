#Created by Jag and Vlad
#This Uninstaller works for removing Oracle from a system rather reimaging it. 


#Removing Environment variable from Machine level, basically setting to null, cannot fail...
[Environment]::SetEnvironmentVariable("TNS_ADMIN", $null, "Machine")
Write-Host "Step 1: Deleted environment variable TNS_ADMIN"


#Removing HLKM Software Oracle
try{ Remove-Item -path HKLM:\SOFTWARE\Oracle -recurse -ErrorAction Stop }
catch{"Char 9: Software\ Oracle Path does not exist or has already been deleted!"}
pause

#Removing HKLM Service\ OracleRemExecServicesV2 
try{
Remove-Item -path HKLM:\SYSTEM\CurrentControlSet\Services\OracleRemExecServiceV2 -recurse -ErrorAction Stop
}
catch{
"Char 15: System\currentControlSet\Services\OracleRemSerV2 ... Deleted or path not found"
}
pause


#Removing after restart
try{
Remove-Item -path C:\Program Files (x86)\Oracle -recurse -ErrorAction Stop
}
catch{
"Char 24 : Oracle program files error"
}
pause


#Remove Start menu
#try{
Get-Item -Path C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Oracle - OraClient12Home1_32bit
Remove-Item -path C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Oracle - OraClient12Home1_32bit -recurse -ErrorAction Stop
#
#}
#catch{
#"Start menu folder does not exist or was deleted"
#}
Remove-Item -path C:\Oracle -recurse 
Remove-Item -path C:\Users\jsingh8\AppData\Local\Temp\oraremservicev2 -recurse -ErrorAction Stop
pause


#Remove
