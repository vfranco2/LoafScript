#loafscript built by Vlad Franco and Jag Singh
#hand deep in the bag

$Type = Read-Host -Prompt 'Are you a Faceuts user [y/n]?' 
If($type = "y"){ 
#Script Path for Oracle Client
$ScriptPath = Split-Path $MyInvocation.InvocationName
& ".\loaftext"
}
Else {
#Script Path for Oracle Client x32
$ScriptPath1 = Split-Path $MyInvocation.InvocationName
& ".\loaftext2" 
}
#Checks to see if Oracle 
try{
tnsping
}
catch{
"Oracle is not installed on this computer"
$error[0]
pause
}

try{
manage-bde c: -protectors -get
}
catch{
"Cannot get bitlocker pass"
pause
}

#Setting Enviorment Variables 
[Environment]::SetEnvironmentVariable("TNS_ADMIN","C:\Oracle\product\12.1.0\dbhome_1\network\admin","Machine")

#Checks to see if Oracle Path Exists
try{
If(Test-Path -path "C:\Oracle\product\12.1.0\dbhome_1\network\admin"){
xcopy "*.ora" "C:\Oracle\product\12.1.0\dbhome_1\network\admin" /y
}
Else{Write-Errror "ERROR STEP 3: Oracle file not found or not installed"
}
}
catch{
"Couldn't copy ora files"
}