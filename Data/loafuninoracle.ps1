#loafscript built by Vlad Franco and Jag Singh


#This Uninstaller works for removing Oracle from a system rather reimaging it. 

write-host "CLOSE THIS WINDOW IF YOU WANT TO KEEP YOUR ORACLE!!" -ForegroundColor Yellow

pause
pause

#STEP 1
#Removing Environment variable from Machine level, basically setting to null, cannot fail...
[Environment]::SetEnvironmentVariable("TNS_ADMIN", $null, "Machine")
Write-Host "Step 1: Deleted environment variable TNS_ADMIN"


#STEP 2
#Remove Registry Keys
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


#STEP 3
#Remove C drive Oracle
try{
Remove-Item -path C:\Oracle -recurse -force -ErrorAction Stop
}
catch{
"Char 24 : Error removing Oracle from C drive"
}
pause


#STEP 4
#Remove Program Files Oracle 32
try{
Remove-Item -path "C:\Program Files (x86)\Oracle" -recurse -force -ErrorAction Stop
}
catch{
"Char 24 : Error removing Oracle from program files x86"
}
pause
#Remove Program Files Oracle 64
try{
Remove-Item -path "C:\Program Files\Oracle" -recurse -force -ErrorAction Stop
}
catch{
"Char 24 : Error removing Oracle from program files 64"
}
pause


#STEP 5
#Remove start menu folder 32
try{
Remove-Item -path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Oracle - OraClient12Home1_32bit" -recurse -force -ErrorAction Stop
}
catch{
"Char 24 : Error removing Oracle from start menu 32"
}
pause
#Remove start menu folder 64
try{
Remove-Item -path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Oracle - OraClient12Home1" -recurse -force -ErrorAction Stop
}
catch{
"Char 24 : Error removing Oracle from start menu 64"
}
pause


#STEP 6
try{
Remove-Item -path "C:\Users\vfranco1\AppData\Local\Temp\oraremservicev2" -recurse -force -ErrorAction Stop
pause
}
catch{
"Char 24 : Error removing temp files"
}