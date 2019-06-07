#loafscript built by Vlad Franco and Jag Singh

#Checks to see if Oracle is installed
try{
tnsping adtldev
pause
}
catch{
"Oracle is not installed on this computer"
$error[0]
pause
}

pause