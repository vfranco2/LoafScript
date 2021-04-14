#LoafScript built by Vlad Franco and Jagjot Singh
#This script is designed to streamline the new PC preparation process.

#----------------------
#XAML User Interface file found in LocalData folder

#Functions in \\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData (Referred to as RemoteData):
#BIOS PW, Admin Process, HPIA, Windows Update Assistant

#Functions in LocalData folder (Found in the directory your LoafScript is):
#Oracle Install, Office Updater, Oracle Uninstall
#----------------------


#-------------------------
# Load XAML UI File From LocalData
#-------------------------
$CurrentVersion = "3.2.0"
$xamlFile = ".\LocalData\LoafScriptUI.xaml"
$inputXML = Get-Content $xamlFile -Raw

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
     #pause
    throw
    pause
}
 
 
#-------------------------
# Load XAML Objects In PowerShell
#-------------------------
  
$xaml.SelectNodes("//*[@Name]") | %{"trying item $($_.Name)";
    try {
        Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop
    }
    catch{throw}
}


#-------------------------
# Display Form Variables In Script (TextBoxes, Buttons, Etc)
#-------------------------

Function Get-FormVariables{
    if ($global:ReadmeDisplay -ne $true){
        Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true
    }
    write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
    get-variable WPF*
}
 
Get-FormVariables


#-------------------------
#Button Functions/Output
#-------------------------

#-------------------------
#Updater Functions
#-------------------------
#Checks the LoafScript folder in \\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\ (Inside the parent LoafScript folder!)
#If the version of this script does not match, it prompts the user
Function downloadNewLoafScript{
    $CurrentLoaf = "LoafScript "+$CurrentVersion
    $WPFLoafGuiMainWindow.Title = $CurrentLoaf
    $FreshLoaf = Get-ChildItem -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\LoafScript*"
    $CompareLoaf = $FreshLoaf.ToString()
    $CompareLoaf = $CompareLoaf.substring(70)

    if ($CompareLoaf -ne $CurrentLoaf){
        $WPFLoafScriptUpdateText.Visibility="visible"
        $WPFLoafScriptUpdater.Visibility="visible"
    }
}
downloadNewLoafScript
$WPFLoafScriptUpdater.Add_Click({ 
    #$WPFLoaflog.Text = "Lol"
    $DownloadLoaf = Get-ChildItem -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\LoafScript*"
    $WPFLoaflog.Text = $DownloadLoaf
    Try{
        $HostName=$env:UserName
        #Copy-Item $DownloadLoaf -Destination "C:\Users\$HostName\Desktop" -Recurse -ErrorAction Stop
        Copy-Item $DownloadLoaf -Destination "..\" -Recurse -ErrorAction Stop
        $InstallLocation = Get-Item -Path "..\"
        $WPFLoaflog.Text = "Downloaded new version of LoafScript to: " + $InstallLocation + " - Navigate to the new install folder and relaunch the script."
    }
    Catch{
        $WPFLoaflog.Text = "$($Error[0])"
    }
    
})

#-------------------------
#Installer Functions
#-------------------------

#Oracle files only
#Launcher in LocalData, files in RemoteData
Function installOrafiles{
    start powershell ((Split-Path $MyInvocation.InvocationName) + ".\LocalData\oraclefiles.ps1")
}
$WPFOraproperties.Add_Click({ 
    $WPFLoaflog.Text = "Installing Oracle Environment Variables and .ora files"
    installOraFiles
})

#Bios Password
#Files in RemoteData
Function BiosPW{
    $HostName=$env:UserName
    Try{
        Copy-Item "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\BiosPass" -Destination "C:\Users\$HostName\Desktop" -Recurse -ErrorAction Stop
    }
    Catch{
        "The file already is copied to the desktop! Or there's an error or something."
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

#Admin Process DLL
#Files in RemoteData
Function APDLL{
    #Fetch Hostname
    $HostName=$env:UserName
    #Moves Bios and has check if it already exists 
    Try{
        Copy-Item "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\Loafscript\RemoteData\jvm.dll" -Destination "C:\Program Files (x86)\Oracle\JInitiator 1.3.1.29\bin\hotspot" -Recurse -ErrorAction Stop
    }
    Catch{
        "Error occured!"}
}
$WPFAdminprocess.Add_Click({ 
    $WPFLoaflog.Text = "Copying .dll file to JInitiator folder"
    APDLL
})

#Run HPIA
#Files in \\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\
Function HpiaExe{
    $NewHpia = Get-ChildItem -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\*.exe" -Filter "*hpia*" 
    $ScriptPath = Split-Path $MyInvocation.InvocationName
    & $NewHpia
}
$WPFRunhpia.Add_Click({ 
    $WPFLoaflog.Text = "Running HPIA - Found in \\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image"
    HpiaExe
})

#Run Windows Update Assistant
#Files in \\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\
Function WinUpdate{
    $NewWindows10 = Get-ChildItem -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\Windows10Upgrade9252.exe"
    & $NewWindows10
}
$WPFRunupdateassistant.Add_Click({ 
    $WPFLoaflog.Text = "Running Windows 10 Update Assistant"
    WinUpdate
})

#Oracle Installers
#Launcher in LocalData, files in \\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\1.Oracle
#32bit Installer
Function installOra32{
    start powershell ((Split-Path $MyInvocation.InvocationName) + ".\LocalData\oracleinstaller.ps1 32")
}
$WPFOrainstall32.Add_Click({ 
    $WPFLoaflog.Text = "Installing Oracle 32"
    installOra32
})

#64bit installer
Function installOra64{
    start powershell ((Split-Path $MyInvocation.InvocationName) + ".\LocalData\oracleinstaller.ps1 64")
}
$WPFOrainstall64.Add_Click({ 
    $WPFLoaflog.Text = "Installing Oracle 64"
    installOra64
})

#-------------------------
#Checker functions
#-------------------------

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

#-------------------------
#Uninstaller functions
#-------------------------

#Uninstall Oracle
#Files in LocalData
Function UnOra{
    start powershell ((Split-Path $MyInvocation.InvocationName) + ".\LocalData\oracleuninstaller.ps1")
}
$WPFOrauninstall.Add_Click({ 
    $WPFLoaflog.Text = "Uninstalling Oracle"
    UnOra
})

#Launch programs & features (usually for MS Office)
Function UnProg{
    appwiz.cpl
}
$WPFProgfeat.Add_Click({ 
    $WPFLoaflog.Text = "Launching Programs & Features"
    UnProg
})

#-------------------------
#Personalization functions
#-------------------------

#Dark/Light theme keys
$registryPathDk1 = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Themes"
$registryPathDk2 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
$NameDK = "AppsUseLightTheme"

#Force Dark Mode
Function Dkforce{
    IF(!(Test-Path $registryPathDk1)) {
        New-Item -Path $registryPathDk1 -Force | Out-Null
    }
    New-ItemProperty -Path $registryPathDk1 -Name $NameDK -Value 0 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key edited, dark mode forced"

    IF(!(Test-Path $registryPathDk2)) {
        New-Item -Path $registryPathDk2 -Force | Out-Null
    }
    New-ItemProperty -Path $registryPathDk2 -Name $NameDK -Value 0 -PropertyType DWORD -Force | Out-Null
    write-host "Local User key edited, dark mode forced"
}
$WPFDkinstall.Add_Click({ 
    $WPFLoaflog2.Text = "Dark mode forced"
    Dkforce
})

#Force Light Mode
Function Ltforce{
    IF(!(Test-Path $registryPathDk1)) {
        New-Item -Path $registryPathDk1 -Force | Out-Null
    }
    New-ItemProperty -Path $registryPathDk1 -Name $NameDK -Value 1 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key edited, light mode forced"

    IF(!(Test-Path $registryPathDk2)) {
        New-Item -Path $registryPathDk2 -Force | Out-Null
    }
    New-ItemProperty -Path $registryPathDk2 -Name $NameDK -Value 1 -PropertyType DWORD -Force | Out-Null
    write-host "Local User key edited, light mode forced"
}
$WPFLtinstall.Add_Click({ 
    $WPFLoaflog2.Text = "Light mode forced"
    Ltforce
})

#Background keys
$registryPathBg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop"
$NameBG = "NoChangingWallPaper"

#Force Unlock Background (Theme stuff)
Function Bgforce{
    IF(!(Test-Path $registryPathBg)) {
        New-Item -Path $registryPathBg -Force | Out-Null
    }
    New-ItemProperty -Path $registryPathBg -Name $NameBG -Value 0 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key added, edited, background editing unlocked"
}
$WPFBginstall.Add_Click({ 
    $WPFLoaflog2.Text = "Background editing unlocked"
    Bgforce
})

#Microsoft Store
$registryPathWindowsUpdate = "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate"
$registryPathWindowsUpdateAU = "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
$registryPathWindowsStore = "HKLM:\Software\Policies\Microsoft\WindowsStore"
$NameDoNotConnect = "DoNotConnectToWindowsUpdateInternetLocations"
$NameNoAutoUpdate = "NoAutoUpdate"
$NameUseWUServer = "UseWUServer"
$NameRemoveWindowsStore = "RemoveWindowsStore"

#Force Unlock Microsoft Store
Function MSStoreUnlock{
    IF(!(Test-Path $registryPathWindowsUpdate)) {
        New-Item -Path $registryPathWindowsUpdate -Force | Out-Null
    }
    New-ItemProperty -Path $registryPathWindowsUpdate -Name $NameDoNotConnect -Value 0 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key edited, Windows Update Internet Locations unlocked"

    IF(!(Test-Path $registryPathWindowsUpdateAU)) {
        New-Item -Path $registryPathWindowsUpdateAU -Force | Out-Null
    }
    New-ItemProperty -Path $registryPathWindowsUpdateAU -Name $NameNoAutoUpdate -Value 0 -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $registryPathWindowsUpdateAU -Name $NameUseWUServer -Value 0 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key edited, Windows Update Auto-Update, Windows Update Server unlocked"

    IF(!(Test-Path $registryPathWindowsStore)) {
        New-Item -Path $registryPathWindowsStore -Force | Out-Null
    }
    New-ItemProperty -Path $registryPathWindowsStore -Name $NameRemoveWindowsStore -Value 0 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key edited, Windows Update Auto-Update, Microsoft Store enabled"

    #I would reset it right from here but the default reset command does not work - not sure why, might be permissions or a missing Windows package.
    #Gotta use the built-in settings app to reset the Windows Store.
    #Reset-AppxPackage Microsoft.WindowsStore
    start ms-settings:appsfeatures-app
}
$WPFMSStoreUnlock.Add_Click({ 
    $WPFLoaflog2.Text = "Microsoft Store unlocked - REQUIRES RESET FROM APPS & FEATURES IN SETTINGS - RE-LOCK ONCE FINISHED WITH IT!"
    MSStoreUnlock
})

#Force Lock Microsoft Store
Function MSStoreLock{
    IF(!(Test-Path $registryPathWindowsUpdate)) {
        New-Item -Path $registryPathWindowsUpdate -Force | Out-Null
    }
    New-ItemProperty -Path $registryPathWindowsUpdate -Name $NameDoNotConnect -Value 1 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key edited, Windows Update Internet Locations locked"

    IF(!(Test-Path $registryPathWindowsUpdateAU)) {
        New-Item -Path $registryPathWindowsUpdateAU -Force | Out-Null
    }
    New-ItemProperty -Path $registryPathWindowsUpdateAU -Name $NameNoAutoUpdate -Value 1 -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $registryPathWindowsUpdateAU -Name $NameUseWUServer -Value 1 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key edited, Windows Update Auto-Update, Windows Update Server locked"

    IF(!(Test-Path $registryPathWindowsStore)) {
        New-Item -Path $registryPathWindowsStore -Force | Out-Null
    }
    New-ItemProperty -Path $registryPathWindowsStore -Name $NameRemoveWindowsStore -Value 1 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key edited, Windows Update Auto-Update, Microsoft Store disabled"
}
$WPFMSStoreLock.Add_Click({ 
    $WPFLoaflog2.Text = "Microsoft Store locked"
    MSStoreLock
})

#Lock Screen keys
$registryPathLockScreenKey = "HKLM:\Software\Policies\Microsoft\Windows\Personalization"
$NameLockChange = "NoChangingLockScreen"
$NameLockImage = "LockScreenImage"

#Force Unlock Lock Screen (Theme stuff)
Function LockScreenForce{
    IF(!(Test-Path $registryPathLockScreenKey)) {
        New-Item -Path $registryPathLockScreenKey -Force | Out-Null
    }
    New-ItemProperty -Path $registryPathLockScreenKey -Name $NameLockChange -Value 0 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key edited, lock screen editing unlocked"

    Add-Type -AssemblyName System.Windows.Forms
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Title = "Please Select File"
    $OpenFileDialog.InitialDirectory = [Environment]::GetFolderPath('Desktop')
    $OpenFileDialog.filter = 'JPG Images (*.jpg)|*.jpg|PNG Images (*.png)|*.png'
    $OpenFileDialog.ShowDialog() | Out-Null
    $Global:SelectedFile = $OpenFileDialog.FileName

    New-ItemProperty -Path $registryPathLockScreenKey -Name $NameLockImage -Value $SelectedFile -PropertyType string -Force | Out-Null
    write-host "Local Machine key edited, lock screen image set"
}
$WPFLockScreenUnlock.Add_Click({ 
    $WPFLoaflog2.Text = "Lock screen editing unlocked"
    LockScreenForce
})

#-------------------------
#Experimental functions
#-------------------------

#Oracle 32bit/64bit Package installer
#Launcher in LocalData, files in RemoteData
Function installOraPackage{
    start powershell ((Split-Path $MyInvocation.InvocationName) + ".\LocalData\oracleinstallerpackage.ps1")
}
$WPFOraclePackage.Add_Click({ 
    $WPFLoaflog3.Text = "Installing Oracle 32bit/64bit Package"
    installOraPackage
})


#-------------------------
#Launch UI
#-------------------------

#write-host "To show the form, run the following" -ForegroundColor Cyan
$Form.ShowDialog() | out-null