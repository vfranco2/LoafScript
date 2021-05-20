#LoafScript built by Vlad Franco and Jagjot Singh
#This script is designed to streamline the new PC preparation process.

#----------------------
#XAML User Interface file found in LocalData folder

#Functions in \\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData (Referred to as RemoteData):
#Oracle Files, BIOS PW, Admin Process, HPIA, Windows Update Assistant, Oracle 32 Or 64 Install, Oracle Uninstall, Oracle 32/64 Package Install, Retire Machine
#----------------------


#-------------------------
# LoafScript Version, Output Variables
#-------------------------
$CurrentVersion = "3.4.0"


#-------------------------
# Load XAML UI File From LocalData
#-------------------------
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
#Functions/Output
#-------------------------

#-------------------------
#Theme Functions
#-------------------------

#Shuffles between 10 LoafScript icons
Function LoafScriptIconShuffle {
    $LoafIconElements = @($WPFLoafIconSetup,$WPFLoafIconInstalls,$WPFLoafIconPersonalization,$WPFLoafIconExperimental)
    $LoafIcons = @('LoafIcon.png','LoafIcon180.png','LoafIconAnniversary.png','LoafIconBite.png','LoafIconBurnt.png','LoafIconButter.png','LoafIconCPU.png','LoafIconMoldy.png','LoafIconTerminal.png','LoafIconToasted.png')
    $LoafRemoteSource = '\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\LoafIcons\'
    try{
        
        #Loop through all icons in .xaml file, assign image to them
        foreach ($IconElement in $LoafIconElements) {
            #Random number gen
            $RandoLoaf = (Get-Random -Maximum 9)
            $IconElement.Source = ($LoafRemoteSource + $LoafIcons[$RandoLoaf])
        }
    }
    catch{
        foreach ($IconElement in $LoafIconElements) {
            $IconElement.Source = '\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\LoafIcons\Loaficon.png'
        }
    }
}
LoafScriptIconShuffle

#This is pretty bomb, themes LoafScript based on .ini file in \\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\.
#Click on theme button under Personalization to swap theme out.
Function LoafScriptThemer{
    #Colors
    $Jet = '#121212'
    $Charcoal = '#40434E'
    $Steel = '#696773'
    $Deep = '#2E4057'
    $Sea = '#4D9DE0'
    $Champagne = '#EEE0CB'
    $Greenery = '#6BAB90'
    
    #Set theme to light in case of .csv error
    $SelectedTheme = "light"

    try{
        #Get theme settings from remote folder
        $ThemeFile = Import-Csv '\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\themes.csv'
        #Boolean for profile creation if it is not found in csv
        $FoundUser = 0

        #Loop through users found, set selected theme
        foreach ($ThemeUser in $ThemeFile) {
            if ($ThemeUser.User -eq $env:UserName){
                $SelectedTheme = $ThemeUser.Theme
                $FoundUser = 1
            }
        }

        #Will be 0 if no users found, set theme to light and create profile with light as default
        if ($FoundUser -eq 0){
            $ThemeFile.User = $env:UserName
            $ThemeFile.Theme = 'light'
            $ThemeFile | Export-Csv '\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\themes.csv' -Append
        }

        #Set theme colors
        IF($SelectedTheme -eq "dark"){
            $BGColor = $Jet
            $TextColor = '#FFFFFF'
            $ButtonColor = $Charcoal
            $TabColor = $Steel
        }
        ELSEIF($SelectedTheme -eq "cobalt"){
            $BGColor = $Deep
            $TextColor = '#FFFFFF'
            $ButtonColor = $Sea
            $TabColor = $Sea
        }
        ELSEIF($SelectedTheme -eq "nature"){
            $BGColor = '#EEE0CB'
            $TextColor = '#000000'
            $ButtonColor = $Greenery
            $TabColor = $Greenery
        }
        ELSEIF($SelectedTheme -eq "light"){ }
        ELSE{ }

        #Assign colors to .xaml elements, looping through collections of them
        IF(($SelectedTheme -eq "dark") -or ($SelectedTheme -eq "cobalt") -or ($SelectedTheme -eq "nature")){

            $WPFLoafGuiMainWindow.Background = $BGColor
            $WPFLoafGuiTabControl.Background = $BGColor

            $WPFLoafScriptUpdateText.Foreground = $TextColor

            $WPFLoafGUITabSetup.Background = $TabColor
            $WPFLoafGUITabInstalls.Background = $TabColor
            $WPFLoafGUITabPersonalization.Background = $TabColor
            $WPFLoafGUITabExperimental.Background = $TabColor

            $Buttonlist = @($WPFButtonAdminprocess,$WPFButtonBgUnlock,$WPFButtonBioscheck,$WPFButtonBiosPass,$WPFButtonBitcheck,$WPFButtonColorUnlock,$WPFButtonLockScreenUnlock,
                            $WPFButtonMSStoreLock,$WPFButtonMSStoreUnlock,$WPFButtonOracheck,$WPFButtonOraclePackage,$WPFButtonOrainstall32,$WPFButtonOrainstall64,$WPFButtonOraproperties,
                            $WPFButtonOrauninstall,$WPFButtonProgfeat,$WPFButtonRetireLocal,$WPFButtonRunhpia,$WPFButtonRunupdateassistant,$WPFButtonThemeUnlock,$WPFButtonPowerBIInstall32,$WPFButtonPowerBIInstall64)

            $GroupBoxlist = @($WPFLoafGuiGroupBoxSetup,$WPFLoafGuiGroupBoxVerification,$WPFLoafGuiGroupBoxUninstalls,$WPFLoafGuiGroupBoxSoftware,$WPFLoafGuiGroupBoxOracle,$WPFLoafGuiGroupBoxPersonalization,$WPFLoafGuiGroupBoxExperimental)

            $Loafloglist = @($WPFLoaflog1,$WPFLoaflog2,$WPFLoaflog3,$WPFLoaflog4)

            foreach($Buttonitem in $Buttonlist){
                $Buttonitem.Background = $ButtonColor
                $Buttonitem.Foreground = $TextColor
            }

            foreach($GroupBoxitem in $GroupBoxlist){
                $GroupBoxitem.Foreground = $TextColor
                $GroupBoxitem.BorderBrush = $BGColor
            }

            foreach($Loaflogitem in $Loafloglist){
                $Loaflogitem.Background = $BGColor
                $Loaflogitem.Foreground = $TextColor
            }
        }
    }
    catch{
        $WPFLoaflog1.Text = "Error setting theme!"
        #$WPFLoaflog1.Text = "$($Error[0])"
    }

}
LoafScriptThemer

Function ChangeLoafScriptTheme{
    param (
        $ThemeName
    )
    try{
        $ThemeFile = Import-Csv '\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\themes.csv'

        #Loop through users found, set selected theme
        foreach ($ThemeUser in $ThemeFile) {
            if ($ThemeUser.User -eq $env:UserName){
                $ThemeUser.Theme = $ThemeName
                $ThemeFile | Export-Csv '\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\themes.csv'
                $WPFLoaflog3.Text = "Changed to "+$ThemeName+" theme!"
                #Refresh the script
                start-process powershell.exe -argument "& '.\LoafScript.ps1'"
                exit
            }
        }
    }
    catch{
        $WPFLoaflog1.Text = "Error setting theme!"
        #$WPFLoaflog1.Text = "$($Error[0])"
    }
}
$WPFButtonLightTheme.Add_Click({
    ChangeLoafScriptTheme light
})
$WPFButtonDarkTheme.Add_Click({
    ChangeLoafScriptTheme dark
})
$WPFButtonCobaltTheme.Add_Click({
    ChangeLoafScriptTheme cobalt
})
$WPFButtonNatureTheme.Add_Click({
    ChangeLoafScriptTheme nature
})

#-------------------------
#Updater Functions
#-------------------------
#Checks the LoafScript folder in \\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\ (Inside the parent LoafScript folder!)
#If the version of this script does not match, it prompts the user
Function downloadNewLoafScript{
    $WPFLoafGuiMainWindow.Title = "LoafScript " + $CurrentVersion + " - 2-Year Anniversary Edition"
    $NewestVersion = Get-ChildItem -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\LoafScript*"
    $CompareVersion = $NewestVersion.ToString()
    $CompareVersion = $CompareVersion.substring(81)

    if ([version]$CompareVersion -gt [version]$CurrentVersion){
        $WPFLoafScriptUpdateText.Visibility="visible"
        $WPFLoafScriptUpdater.Visibility="visible"
    }
}
downloadNewLoafScript
$WPFLoafScriptUpdater.Add_Click({
    $DownloadLoaf = Get-ChildItem -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\LoafScript*"
    $WPFLoaflog1.Text = $DownloadLoaf
    Try{
        $HostName=$env:UserName
        Copy-Item $DownloadLoaf -Destination "..\" -Recurse -ErrorAction Stop
        $InstallLocation = Get-Item -Path "..\"
        $WPFLoaflog1.Text = "Downloaded new version of LoafScript to: " + $InstallLocation + " - Navigate to the new install folder and relaunch the script."
    }
    Catch{
        $WPFLoaflog1.Text = "$($Error[0])"
    }
    
})

#-------------------------
#Setup Functions
#-------------------------

#Oracle files only
#Files in RemoteData
Function installOrafiles{
    start-process powershell.exe -argument "& '\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\oraclefiles.ps1'"
}
$WPFButtonOraproperties.Add_Click({ 
    $WPFLoaflog1.Text = "Installing Oracle Environment Variables and .ora files"
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
$WPFButtonBiosPass.Add_Click({
    $WPFLoaflog1.Text = "Installing BIOS Password"
    BiosPW
})

#Run HPIA
#Files in \\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\
Function HpiaExe{
    $NewHpia = Get-ChildItem -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\*.exe" -Filter "*hpia*" 
    $ScriptPath = Split-Path $MyInvocation.InvocationName
    & $NewHpia
}
$WPFButtonRunhpia.Add_Click({ 
    $WPFLoaflog1.Text = "Running HPIA - Found in \\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image"
    HpiaExe
})

#Run Windows Update Assistant
#Files in \\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\
Function WinUpdate{
    $NewWindows10 = Get-ChildItem -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\Windows10Upgrade9252.exe"
    & $NewWindows10
}
$WPFButtonRunupdateassistant.Add_Click({ 
    $WPFLoaflog1.Text = "Running Windows 10 Update Assistant"
    WinUpdate
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
$WPFButtonOracheck.Add_Click({ 
    $WPFLoaflog1.Text = chkOra 
})

#Bitlocker Check
Function chkBit{
    manage-bde c: -protectors -get}
$WPFButtonBitcheck.Add_Click({ 
    $WPFLoaflog1.Text = chkBit
})

#Check BIOS
Function chkBios{
    wmic bios get smbiosbiosversion
    wmic bios get serialnumber}
$WPFButtonBioscheck.Add_Click({ 
    $WPFLoaflog1.Text = chkBios 
})

#-------------------------
#Uninstaller functions
#-------------------------

#Uninstall Oracle
#Files in RemoteData
Function UnOra{
    start-process powershell.exe -argument "& '\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\oracleuninstaller.ps1'"
}
$WPFButtonOrauninstall.Add_Click({ 
    $WPFLoaflog1.Text = "Uninstalling Oracle"
    UnOra
})

#Launch programs & features (usually for MS Office)
Function UnProg{
    appwiz.cpl
}
$WPFButtonProgfeat.Add_Click({ 
    $WPFLoaflog1.Text = "Launching Programs & Features"
    UnProg
})

#Retire Machine
#Files in RemoteData
Function retireMachine{
    start-process powershell.exe -argument "& '\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\retiremachine.ps1'"
}
$WPFButtonRetireLocal.Add_Click({ 
    $WPFLoaflog1.Text = "Retiring Local Machine"
    retireMachine
})

#-------------------------
#Installer functions
#-------------------------

#Admin Process DLL
#Files in RemoteData
Function APDLL{
    #Fetch Hostname
    $HostName=$env:UserName
    Try{
        Copy-Item "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\Loafscript\RemoteData\jvm.dll" -Destination "C:\Program Files (x86)\Oracle\JInitiator 1.3.1.29\bin\hotspot" -Recurse -ErrorAction Stop
    }
    Catch{
        "Error occured!"
    }
}
$WPFButtonAdminprocess.Add_Click({ 
    $WPFLoaflog2.Text = "Copying .dll file to JInitiator folder"
    APDLL
})

#PowerBI Install
Function installPowerBI{
    param (
        $BIVersion
    )
    if($BIVersion -eq 64){
        $BILauncher = Get-ChildItem -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Manual SW installations\Microsoft Power BI Desktop\PBIDesktopSetup_x64.exe"
    }
    else{
        $BILauncher = Get-ChildItem -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Manual SW installations\Microsoft Power BI Desktop\PBIDesktopSetup.exe"
    }    
    $ScriptPath = Split-Path $MyInvocation.InvocationName
    & $BILauncher
}
$WPFButtonPowerBIInstall32.Add_Click({ 
    $WPFLoaflog2.Text = "Installing PowerBI 32bit"
    installPowerBI 32
})
$WPFButtonPowerBIInstall64.Add_Click({ 
    $WPFLoaflog2.Text = "Installing PowerBI 64bit"
    installPowerBI 64
})

#Oracle Installers
#Launcher in LocalData, files in \\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\1.Oracle
#32bit Installer
Function installOra32{
    start-process powershell.exe -argument "& '\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\oracleinstaller.ps1' 32"
}
$WPFButtonOrainstall32.Add_Click({ 
    $WPFLoaflog2.Text = "Installing Oracle 32"
    installOra32
})

#64bit installer
Function installOra64{
    start-process powershell.exe -argument "& '\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\oracleinstaller.ps1' 64"
}
$WPFButtonOrainstall64.Add_Click({ 
    $WPFLoaflog2.Text = "Installing Oracle 64"
    installOra64
})

#Oracle 32bit/64bit Package installer
#Launcher in LocalData, files in RemoteData
Function installOraPackage{
    #start powershell ((Split-Path $MyInvocation.InvocationName) + ".\LocalData\oracleinstallerpackage.ps1")
    start-process powershell.exe -argument "& '\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\oracleinstallerpackage.ps1'"
}
$WPFButtonOraclePackage.Add_Click({ 
    $WPFLoaflog2.Text = "Installing Oracle 32bit/64bit Package"
    installOraPackage
})

#-------------------------
#Personalization functions
#-------------------------

#Dark/Light theme keys
$registryPathTheme1 = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Themes"
$registryPathTheme2 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
$NameTheme = "AppsUseLightTheme"

#Force Dark Mode
Function Themeforce{
    IF(!(Test-Path $registryPathTheme1)) {
        New-Item -Path $registryPathTheme1 -Force | Out-Null
    }
    IF(!(Test-Path $registryPathTheme2)) {
        New-Item -Path $registryPathTheme2 -Force | Out-Null
    }

    $CurrentTheme1 = Get-ItemPropertyValue -Path $registryPathTheme2 -Name $NameTheme
    IF($CurrentTheme1 -eq 0){
        New-ItemProperty -Path $registryPathTheme1 -Name $NameTheme -Value 1 -PropertyType DWORD -Force | Out-Null
        New-ItemProperty -Path $registryPathTheme2 -Name $NameTheme -Value 1 -PropertyType DWORD -Force | Out-Null
        $WPFLoaflog3.Text = "System Theme Changed To Light Mode"
    }
    ELSE{
        New-ItemProperty -Path $registryPathTheme1 -Name $NameTheme -Value 0 -PropertyType DWORD -Force | Out-Null
        New-ItemProperty -Path $registryPathTheme2 -Name $NameTheme -Value 0 -PropertyType DWORD -Force | Out-Null
        $WPFLoaflog3.Text = "System Theme Changed To Dark Mode"
    }
}
$WPFButtonThemeUnlock.Add_Click({
    Themeforce
})

#Color Options keys
$registryPathCUColor = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$NameNoDispAppearancePageCU = "NoDispAppearancePage"
$NameNoColorChoiceCU = "NoColorChoice"

#Unlock Color Options
Function Colorforce{
    IF(Test-Path $registryPathCUColor) {
        New-ItemProperty -Path $registryPathCUColor -Name $NameNoDispAppearancePageCU -Value 0 -PropertyType DWORD -Force | Out-Null
    }
    IF(Test-Path $registryPathCUColor) {
        New-ItemProperty -Path $registryPathCUColor -Name $NameNoColorChoiceCU -Value 0 -PropertyType DWORD -Force | Out-Null
    }
    write-host "Local Machine keys removed, color options unlocked"
    start ms-settings:colors
}
$WPFButtonColorUnlock.Add_Click({ 
    $WPFLoaflog3.Text = "Color options unlocked"
    Colorforce
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
$WPFButtonBgUnlock.Add_Click({ 
    $WPFLoaflog3.Text = "Background editing unlocked"
    Bgforce
})

#Microsoft Store keys
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
    #Default reset command is:
    #Reset-AppxPackage Microsoft.WindowsStore
    start ms-settings:appsfeatures-app
}
$WPFButtonMSStoreUnlock.Add_Click({ 
    $WPFLoaflog3.Text = "Microsoft Store unlocked - REQUIRES RESET FROM APPS & FEATURES IN SETTINGS - RE-LOCK ONCE FINISHED WITH IT!"
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
$WPFButtonMSStoreLock.Add_Click({ 
    $WPFLoaflog3.Text = "Microsoft Store locked"
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
$WPFButtonLockScreenUnlock.Add_Click({ 
    $WPFLoaflog3.Text = "Lock screen editing unlocked"
    LockScreenForce
})

#-------------------------
#Experimental functions
#-------------------------

#Nothing here right now, all functions are stable

#-------------------------
#Launch UI
#-------------------------

#write-host "To show the form, run the following" -ForegroundColor Cyan
$Form.ShowDialog() | out-null