#LoafScript built by Vlad Franco and Jag Singh 
#This script is designed to streamline the new PC preparation process.

#----------------------
#Functions in Intern Refresh:
#CAB, BIOS PW, Admin Process, HPIA

#Functions in local Data folder:
#Oracle Install, Office Updater, Oracle Uninstall
#----------------------


$inputXML = @"
<Window x:Class="LoafGui.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:LoafGui"
        mc:Ignorable="d"
        Title="LoafScript 2.4.1" Height="590" Width="400">
    <TabControl>
        <TabItem Header="Setup">
            <Grid>
                <Image HorizontalAlignment="Left" Height="65" Margin="10,10,0,0" VerticalAlignment="Top" Width="65" Source="\\nacorpcl/NOC_Install_Files/NOC/CDS/Client/Intern Refresh/LoafScript/Data/LoafIcon.png"/>

                <GroupBox Header="Installs" HorizontalAlignment="Left" Height="190" Margin="10,80,0,0" VerticalAlignment="Top" Width="132"/>
                <Button x:Name="Orainstall32" Content="Oracle 32" HorizontalAlignment="Left" Height="18" Margin="20,102,0,0" VerticalAlignment="Top" Width="106"/>
                <Button x:Name="Orainstall64" Content="Oracle 64" HorizontalAlignment="Left" Height="18" Margin="20,125,0,0" VerticalAlignment="Top" Width="106"/>
                <Button x:Name="Oraproperties" Content="Oracle TNS/Env" HorizontalAlignment="Left" Height="18" Margin="20,148,0,0" VerticalAlignment="Top" Width="106"/>
                <Button x:Name="BiosPass" Content="BIOS PW" HorizontalAlignment="Left" Height="18" Margin="20,171,0,0" VerticalAlignment="Top" Width="106"/>
                <Button x:Name="Oupdate32" Content="Office 32" HorizontalAlignment="Left" Height="18" Margin="20,194,0,0" VerticalAlignment="Top" Width="106"/>
                <Button x:Name="Adminprocess" Content="Admin Process" HorizontalAlignment="Left" Height="18" Margin="20,217,0,0" VerticalAlignment="Top" Width="106"/>
                <Button x:Name="Runhpia" Content="Run HPIA" HorizontalAlignment="Left" Height="18" Margin="20,240,0,0" VerticalAlignment="Top" Width="106"/>

                <GroupBox Header="Verification" HorizontalAlignment="Left" Height="100" Margin="10,275,0,0" VerticalAlignment="Top" Width="132"/>
                <Button x:Name="Oracheck" Content="Check Oracle" HorizontalAlignment="Left" Height="18" Margin="20,297,0,0" VerticalAlignment="Top" Width="106"/>
                <Button x:Name="Bitcheck" Content="Check Bitlocker" HorizontalAlignment="Left" Height="18" Margin="20,320,0,0" VerticalAlignment="Top" Width="106"/>
                <Button x:Name="Bioscheck" Content="Check Bios" HorizontalAlignment="Left" Height="18" Margin="20,343,0,0" VerticalAlignment="Top" Width="106"/>

                <GroupBox Header="Uninstalls" HorizontalAlignment="Left" Height="72" Margin="10,380,0,0" VerticalAlignment="Top" Width="132"/>
                <Button x:Name="Orauninstall" Content="Oracle" HorizontalAlignment="Left" Height="18" Margin="20,400,0,0" VerticalAlignment="Top" Width="106"/>
                <Button x:Name="Progfeat" Content="Office" HorizontalAlignment="Left" Height="18" Margin="20,423,0,0" VerticalAlignment="Top" Width="106"/>

                <GroupBox Header="Deprecated" HorizontalAlignment="Left" Height="71" Margin="10,457,0,0" VerticalAlignment="Top" Width="132"/>
                <Button x:Name="Cabinstall" Content="CAB Pega" HorizontalAlignment="Left" Height="18" Margin="20,477,0,0" VerticalAlignment="Top" Width="106"/>
                <Button x:Name="Oupdate64" Content="Office 64" HorizontalAlignment="Left" Height="18" Margin="20,500,0,0" VerticalAlignment="Top" Width="106"/>

                <TextBox x:Name="Loaflog" HorizontalAlignment="Left" Height="508" Margin="147,10,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="230"/>
            </Grid>
        </TabItem>
        <TabItem Header="Personalization">
            <Grid>
                <Image HorizontalAlignment="Left" Height="65" Margin="10,10,0,0" VerticalAlignment="Top" Width="65" Source="\\nacorpcl/NOC_Install_Files/NOC/CDS/Client/Intern Refresh/LoafScript/Data/LoafIcon.png"/>

                <GroupBox Header="Personalization" HorizontalAlignment="Left" Height="190" Margin="10,80,0,0" VerticalAlignment="Top" Width="132"/>
                <Button x:Name="Dkinstall" Content="Dark Mode" HorizontalAlignment="Left" Height="18" Margin="20,102,0,0" VerticalAlignment="Top" Width="106"/>
                <Button x:Name="Ltinstall" Content="Light Mode" HorizontalAlignment="Left" Height="18" Margin="20,125,0,0" VerticalAlignment="Top" Width="106"/>
                <Button x:Name="Bginstall" Content="Backgrounds" HorizontalAlignment="Left" Height="18" Margin="20,148,0,0" VerticalAlignment="Top" Width="106"/>
                <Button x:Name="Pwinstall" Content="High Performance" HorizontalAlignment="Left" Height="18" Margin="20,171,0,0" VerticalAlignment="Top" Width="106"/>
                
                <TextBox x:Name="Loaflog2" HorizontalAlignment="Left" Height="508" Margin="147,10,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="230"/>
            </Grid>
        </TabItem>
    </TabControl>
</Window>
"@ 

$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML
 
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
try{
    $Form=[Windows.Markup.XamlReader]::Load( $reader )
}
catch{
    Write-Warning "Unable to parse XML, with error: $($Error[0])`n Ensure that there are NO SelectionChanged or TextChanged properties in your textboxes (PowerShell cannot process them)"
    throw
}
 

#-------------------------
# Load XAML Objects In PowerShell
#-------------------------
  
$xaml.SelectNodes("//*[@Name]") | %{"trying item $($_.Name)";
    try {Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop}
    catch{throw}
    }
 
Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
get-variable WPF*
}
 
Get-FormVariables


#-------------------------
#Button Functions/Output
#-------------------------

#Installer Functions

#Oracle Installers
#Launcher in local Data, files in Intern Refresh
Function installOra32{
start powershell ((Split-Path $MyInvocation.InvocationName) + ".\Data\oracleinstaller32.ps1")}
$WPFOrainstall32.Add_Click({ 
$WPFLoaflog.Text = "Installing Oracle 32"
installOra32
})
Function installOra64{
start powershell ((Split-Path $MyInvocation.InvocationName) + ".\Data\oracleinstaller64.ps1")}
$WPFOrainstall64.Add_Click({ 
$WPFLoaflog.Text = "Installing Oracle 64"
installOra64
})

#Oracle files only
#Launcher in local Data, files in Intern Refresh
Function installOrafiles{
start powershell ((Split-Path $MyInvocation.InvocationName) + ".\Data\oraclefiles.ps1")}
$WPFOraproperties.Add_Click({ 
$WPFLoaflog.Text = "Installing Oracle Env and .ora files"
installOraFiles
})

#Bios Password
#Files in Intern Refresh
Function BiosPW{
$HostName=$env:UserName
Try{
Copy-Item "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\Data\BiosPass" -Destination "C:\Users\$HostName\Desktop" -Recurse -ErrorAction Stop
}
Catch{
"The file already is copied to the desktop!"
}

Set-Location -Path "C:\Users\$HostName\Desktop\BiosPass"
start-process "cmd.exe" "/c .\BiosPw.Bat" -Wait
Set-Location -Path "C:\Users\$HostName"
Remove-Item "C:\Users\$HostName\Desktop\BiosPass" -Recurse –Force
Set-Location $PSScriptRoot
}
$WPFBiosPass.Add_Click({
$WPFLoaflog.Text = "Installing BIOS Password"
BiosPW
})

#Office 32 Updater
#Files in local Data
Function uoff32{
$ScriptPath = Split-Path $MyInvocation.InvocationName
& ".\Data\Update Office to Semi Annual Channel.bat"
}
$WPFOupdate32.Add_Click({ 
$WPFLoaflog.Text = uoff32
})

#Admin Process DLL
#Files in Intern refresh
Function APDLL{
#Fetch Hostname
$HostName=$env:UserName
#Moves Bios and has check if it already exists 
Try{
Copy-Item "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\Loafscript\Data\jvm.dll" -Destination "C:\Program Files (x86)\Oracle\JInitiator 1.3.1.29\bin\hotspot" -Recurse -ErrorAction Stop
}
Catch{
"Error occured!"}
}
$WPFAdminprocess.Add_Click({ 
$WPFLoaflog.Text = "Copying .dll file to JInitiator folder"
APDLL
})

#Run HPIA
#Files in Intern Refresh
Function HpiaExe{
$ScriptPath = Split-Path $MyInvocation.InvocationName
& "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\Loafscript\Data\sp97054.exe"}
$WPFRunhpia.Add_Click({ 
$WPFLoaflog.Text = "Running HPIA"
HpiaExe
})


#Checker functions

#Check Oracle
Function chkOra{
try{
tnsping adtldev
}
catch{
"Oracle is not installed on this computer"
$error[0]
}}
$WPFOracheck.Add_Click({ 
$WPFLoaflog.Text = chkOra 
})

#Bitlocker Check
Function chkBit{
manage-bde c: -protectors -get}
$WPFBitcheck.Add_Click({ 
$WPFLoaflog.Text = chkBit
})

#Check BIOS
Function chkBios{
wmic bios get smbiosbiosversion
wmic bios get serialnumber}
$WPFBioscheck.Add_Click({ 
$WPFLoaflog.Text = chkBios 
})


#Uninstaller functions

#Uninstall Oracle
#Files in local Data
Function UnOra{
start powershell ((Split-Path $MyInvocation.InvocationName) + ".\Data\loafuninoracle.ps1")}
$WPFOrauninstall.Add_Click({ 
$WPFLoaflog.Text = "Uninstalling Oracle"
UnOra
})

#Launch programs & features (usually for MS Office)
Function UnProg{
appwiz.cpl}
$WPFProgfeat.Add_Click({ 
$WPFLoaflog.Text = "Launching Programs & Features"
UnProg
})


#Deprecated functions

#Cab Installer for Pega
#Files in Intern Refresh
Function Cabin{
Try{
Copy-Item "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\Data\CabInstaller" -Destination "C:\Intel" -Recurse -ErrorAction Stop
}
Catch{
"The file already is copied to the Intel folder!"
}
Set-Location -Path "C:\Intel\CabInstaller"
start-process "cmd.exe" "/c .\install.Bat"
Set-Location $PSScriptRoot
}
$WPFCabinstall.Add_Click({ 
$WPFLoaflog.Text = "Running Cab Installer"
Cabin
})

#Office 64 updater
#Files in local data
Function uoff64{
$ScriptPath = Split-Path $MyInvocation.InvocationName
& ".\Data\Update Office to Semi Annual Channel - 64bit.bat"
}
$WPFOupdate64.Add_Click({ 
$WPFLoaflog.Text = uoff32
})


#Personalization functions
$registryPathDk1 = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Themes"
$registryPathDk2 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
$registryPathBg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop"
$registryPathPw = "HKLM:\System\CurrentControlSet\Control\Power"
$registryPathPw2 = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\NameSpace\{025A5937-A6BE-4686-A844-36FE4BEC8B6D}"
$NameDK = "AppsUseLightTheme"
$NameBG = "NoChangingWallPaper"
$NamePW = "CsEnabled"
$NamePW2 = "PreferredPlan"

#Force Dark Mode
Function Dkforce{
IF(!(Test-Path $registryPathDk1))
  {
    New-Item -Path $registryPathDk1 -Force | Out-Null
    New-ItemProperty -Path $registryPathDk1 -Name $NameDK -Value 0 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key added, edited, dark mode forced"}
 ELSE {
    New-ItemProperty -Path $registryPathDk1 -Name $NameDK -Value 0 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key edited, dark mode forced"}
IF(!(Test-Path $registryPathDk2))
  {
    New-Item -Path $registryPathDk2 -Force | Out-Null
    New-ItemProperty -Path $registryPath2 -Name $NameDK -Value 0 -PropertyType DWORD -Force | Out-Null
    write-host "Local User key added, edited, dark mode forced"}
 ELSE {
    New-ItemProperty -Path $registryPathDk2 -Name $NameDK -Value 0 -PropertyType DWORD -Force | Out-Null
    write-host "Local User key edited, dark mode forced"}
}
$WPFDkinstall.Add_Click({ 
$WPFLoaflog2.Text = "Dark mode forced"
Dkforce
})

#Force Light Mode
Function Ltforce{
IF(!(Test-Path $registryPathDk1))
  {
    New-Item -Path $registryPathDk1 -Force | Out-Null
    New-ItemProperty -Path $registryPathDk1 -Name $NameDK -Value 1 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key added, edited, light mode forced"}
 ELSE {
    New-ItemProperty -Path $registryPathDk1 -Name $NameDK -Value 1 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key edited, light mode forced"}
IF(!(Test-Path $registryPathDk2))
  {
    New-Item -Path $registryPathDk2 -Force | Out-Null
    New-ItemProperty -Path $registryPath2 -Name $NameDK -Value 1 -PropertyType DWORD -Force | Out-Null
    write-host "Local User key added, edited, light mode forced"}
 ELSE {
    New-ItemProperty -Path $registryPathDk2 -Name $NameDK -Value 1 -PropertyType DWORD -Force | Out-Null
    write-host "Local User key edited, light mode forced"}
}
$WPFLtinstall.Add_Click({ 
$WPFLoaflog2.Text = "Light mode forced"
Ltforce
})

#Force Unlock Background (Theme stuff)
Function Bgforce{
IF(!(Test-Path $registryPathBg))
  {
    New-Item -Path $registryPathBg -Force | Out-Null
    New-ItemProperty -Path $registryPathBg -Name $NameBG -Value 0 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key added, edited, background editing unlocked"}
 ELSE {
    New-ItemProperty -Path $registryPathBg -Name $NameBG -Value 0 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key edited, background editing unlocked"}
}
$WPFBginstall.Add_Click({ 
$WPFLoaflog2.Text = "Background editing unlocked"
Bgforce
})

#Force Unlock Power Options
Function PowerOpen{
#powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
#powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
#powercfg -duplicatescheme a1841308-3541-4fab-bc81-f71556f20b4a

IF(!(Test-Path $registryPathPw))
  {
    New-Item -Path $registryPathPw -Force | Out-Null
    New-ItemProperty -Path $registryPathPw -Name $NamePW -Value 0 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key added, edited, power options unlocked. Please reboot your machine."}
 ELSE {
    New-ItemProperty -Path $registryPathPw -Name $NamePW -Value 0 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key edited, power options unlocked. Please reboot your machine"}

IF(!(Test-Path $registryPathPw2))
  {
    New-Item -Path $registryPathPw2 -Force | Out-Null
    New-ItemProperty -Path $registryPathPw2 -Name $NamePW2 -Value 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c -PropertyType STRING -Force | Out-Null
    write-host "Local Machine key added, edited, High Performance forced. Please reboot your machine."}
 ELSE {
    New-ItemProperty -Path $registryPathPw2 -Name $NamePW2 -Value 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c -PropertyType STRING -Force | Out-Null
    write-host "Local Machine key edited, High Performance forced. Please reboot your machine"}
}
$WPFPwinstall.Add_Click({ 
$WPFLoaflog2.Text = "High Performance forced. Please reboot your machine."
PowerOpen
})


#-------------------------
#Launch Form
#-------------------------

#write-host "To show the form, run the following" -ForegroundColor Cyan
$Form.ShowDialog() | out-null