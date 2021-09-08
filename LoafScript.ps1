$CurrentVersion = "3.7.0"
#LoafScript built by Vlad Franco, Kristian Rica, Michael Hang, and Jagjot Singh
#This script is designed to streamline the new PC preparation process.

#----------------------
#XAML User Interface file found in LocalData folder
#----------------------

#----------------------
#Global Path Variables
#----------------------
$LSRemote = '\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData'

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
#Setup Functions
#-------------------------
#Oracle files only
#Files in RemoteData
Function installOrafiles{
    start-process powershell.exe -argument "& '$LSRemote\oraclefiles.ps1'"
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
        Copy-Item "$LSRemote\BiosPass" -Destination "C:\Users\$HostName\Desktop" -Recurse -ErrorAction Stop
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

#Set BGInfo
#Files in 
Function BGInfoSetter{
    & "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Manual SW installations\bg info script\Bginfo64.exe" "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Manual SW installations\bg info script\BGinfoSettingsProd.bgi" /timer:0 /silent /nolicprompt
}
$WPFButtonRunBGInfo.Add_Click({
    $WPFLoaflog1.Text = "Running BGInfo"
    BGInfoSetter
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
    wmic bios get serialnumber
}
$WPFButtonBioscheck.Add_Click({ 
    $WPFLoaflog1.Text = chkBios 
})

#Check BIOS
Function HPDiag{
    
}
$WPFButtonHPDiag.Add_Click({ 
    $WPFLoaflog1.Text = "Running HP Diagnostic Tool (Coming Soon)"
    HPDiag 
})

#-------------------------
#Uninstaller functions
#-------------------------
#Uninstall Oracle
#Files in RemoteData
Function UnOra{
    start-process powershell.exe -argument "& '$LSRemote\oracleuninstaller.ps1'"
}
$WPFButtonOrauninstall.Add_Click({ 
    $WPFLoaflog1.Text = "Uninstalling Oracle"
    UnOra
})

#Remove Cisco AnyConnect Registry Keys
Function CiscoKiller{
    start-process powershell.exe -argument "& '$LSRemote\AnyConnectKiller.ps1'"
}
$WPFButtonCiscoKiller.Add_Click({ 
    $WPFLoaflog1.Text = "Removing Cisco AnyConnect Keys"
    CiscoKiller
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
    start-process powershell.exe -argument "& '$LSRemote\retiremachine.ps1'"
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
        Copy-Item "$LSRemote\jvm.dll" -Destination "C:\Program Files (x86)\Oracle\JInitiator 1.3.1.29\bin\hotspot" -Recurse -ErrorAction Stop
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
    elseif($BIVersion -eq 32){
        $BILauncher = Get-ChildItem -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Manual SW installations\Microsoft Power BI Desktop\PBIDesktopSetup.exe"
    }
    else{
        $WPFLoaflog2.Text = "PowerBI pprameter error!"
    }
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

#Install Notepad/Paint
Function NotePaint{
    dism /online /add-capability /capabilityname:Microsoft.Windows.MSPaint~~~~0.0.1.0
    dism /online /add-capability /capabilityname:Microsoft.Windows.Notepad~~~~0.0.1.0
    $WPFLoaflog2.Text = "Notepad and Paint installed. Check the Start Menu and make sure they are installed."
}
$WPFButtonNotepadPaint.Add_Click({ 
    $WPFLoaflog2.Text = "Installing Notepad and Paint"
    NotePaint
})

#Oracle Installers
#Files in \\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\1.Oracle
#32bit Installer
Function installOra32{
    start-process powershell.exe -argument "& '$LSRemote\oracleinstaller.ps1' 32"
}
$WPFButtonOrainstall32.Add_Click({ 
    $WPFLoaflog2.Text = "Installing Oracle 32"
    installOra32
})

#64bit installer
Function installOra64{
    start-process powershell.exe -argument "& '$LSRemote\oracleinstaller.ps1' 64"
}
$WPFButtonOrainstall64.Add_Click({ 
    $WPFLoaflog2.Text = "Installing Oracle 64"
    installOra64
})

#Oracle 32bit/64bit Package installer
#Files in RemoteData
Function installOraPackage{
    start-process powershell.exe -argument "& '$LSRemote\oracleinstallerpackage.ps1'"
}
$WPFButtonOraclePackage.Add_Click({ 
    $WPFLoaflog2.Text = "Installing Oracle 32bit/64bit Package"
    installOraPackage
})

#Cisco Installers
#Cisco Client Installer
Function installCiscoClient{
    $CCInstaller = Get-ChildItem -Path "$LSRemote\Cisco\INSTALL_FOR_CISCO_AMP.exe"
    & $CCInstaller
}
$WPFButtonCiscoClient.Add_Click({
    $WPFLoaflog2.Text = "Installing Cisco Client"
    installCiscoClient
})

#Cisco ISE Installer
Function installCiscoISE{
    $CIInstaller = Get-ChildItem -Path "$LSRemote\Cisco\CISCO_ISE_INSTALL.msi"
    & $CIInstaller
}
$WPFButtonCiscoISE.Add_Click({
    $WPFLoaflog2.Text = "Installing Cisco ISE"
    installCiscoISE
})

#Cisco AMP Installer
Function installCiscoAMP{
    $CAInstaller = Get-ChildItem -Path "$LSRemote\Cisco\INSTALL_FOR_CISCO_AMP.exe"
    & $CAInstaller
}
$WPFButtonCiscoAMP.Add_Click({
    $WPFLoaflog2.Text = "Installing Cisco AMP"
    installCiscoAMP
})

#Cisco XML
#Files in RemoteData
Function installCiscoXML{
    Try{
        Copy-Item "$LSRemote\Cisco\hap_prod_vpn_client_profile_ise.xml.xml" -Destination "C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\Profile" -Recurse -ErrorAction Stop
    }
    Catch{
        $WPFLoaflog2.Text = "Error copying Cisco .xml file!"
    }
}
$WPFButtonCiscoXML.Add_Click({ 
    $WPFLoaflog2.Text = "Copying .XML file to Cisco Folder"
    installCiscoXML
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
$registryPathBgUnlock = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop"
$registryPathBgSetter = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System"
$NameBgUnlock = "NoChangingWallPaper"
$NameBgLink = "Wallpaper"
$NameBgStyle = "WallpaperStyle"

#Force Unlock Background (Theme stuff)
Function Bgforce{
    #Unlock Editing
    IF(!(Test-Path $registryPathBgUnlock)) {
        New-Item -Path $registryPathBgUnlock -Force | Out-Null
    }
    New-ItemProperty -Path $registryPathBgUnlock -Name $NameBgUnlock -Value 0 -PropertyType DWORD -Force | Out-Null
    write-host "Local Machine key added, edited, background editing unlocked"

    #Set Background Values
    IF(!(Test-Path $registryPathBgSetter)) {
        New-Item -Path $registryPathBgSetter -Force | Out-Null
    }
    #New-ItemProperty -Path $registryPathBgSetter -Name $NameBgLink -Value 0 -PropertyType DWORD -Force | Out-Null
    New-ItemProperty -Path $registryPathBgSetter -Name $NameBgStyle -Value "4" -PropertyType string -Force | Out-Null
    write-host "Local Machine key edited, lock screen editing unlocked"

    Add-Type -AssemblyName System.Windows.Forms
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Title = "Please Select File"
    $OpenFileDialog.InitialDirectory = [Environment]::GetFolderPath('Desktop')
    $OpenFileDialog.filter = 'JPG Images (*.jpg)|*.jpg|PNG Images (*.png)|*.png'
    $OpenFileDialog.ShowDialog() | Out-Null
    $Global:SelectedFile = $OpenFileDialog.FileName

    write-host $SelectedFile

    New-ItemProperty -Path $registryPathBgSetter -Name $NameBgLink -Value $SelectedFile -PropertyType string -Force | Out-Null
    write-host "Local Machine key edited, background image set"
}
$WPFButtonBgUnlock.Add_Click({ 
    $WPFLoaflog3.Text = "Background editing unlocked"
    Bgforce
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

#Microsoft Store keys
$registryPathWindowsUpdate = "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate"
$registryPathWindowsUpdateAU = "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
$registryPathWindowsStore = "HKLM:\Software\Policies\Microsoft\WindowsStore"
$NameDoNotConnect = "DoNotConnectToWindowsUpdateInternetLocations"
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

#-------------------------
#Experimental functions
#-------------------------
#Kanye
Function KanyeLaunch{
    start-process powershell.exe -argument "& '$LSRemote\kanyealien.ps1'"
}
$WPFButtonKanye.Add_Click({ 
    $WPFLoaflog4.Text = "Kanye"
    KanyeLaunch
})

#-------------------------
#Theme Functions
#-------------------------
#This is pretty bomb, themes LoafScript based on .ini file in RemoteData.
#Major functions found in LoafThemes.ps1
    #1) Shuffle LoafScript Icons
    #2) Set Themes
#Click on theme button under Personalization to swap theme out.
Function LoafScriptThemer{
    #-------------------------
    #Icon Data
    #-------------------------
    #Shuffles LoafScript icons
    $LoafIconElements = @($WPFLoafIconSetup,$WPFLoafIconInstalls,$WPFLoafIconPersonalization,$WPFLoafIconExperimental)
    $LoafIcons = @('LoafIcon.png','LoafIcon180.png','LoafIconAnniversary.png','LoafIconBite.png','LoafIconBurnt.png','LoafIconButter.png','LoafIconCPU.png','LoafIconMoldy.png','LoafIconTerminal.png','LoafIconToasted.png',
                    'LoafIconAlliance.png','LoafIconNeon.png','LoafIconPS.png','LoafIconVF.png')
    $LoafRemoteSource = '\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\LoafIcons\'
    try{
        #Loop through all icons in .xaml file, assign image to them
        foreach ($IconElement in $LoafIconElements) {
            #Random number gen
            $RandoLoaf = (Get-Random -Maximum 14)
            $IconElement.Source = ($LoafRemoteSource + $LoafIcons[$RandoLoaf])
        }
    }
    catch{
        foreach ($IconElement in $LoafIconElements) {
            $IconElement.Source = '\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\LoafIcons\Loaficon.png'
        }
    }

    #-------------------------
    #Theme Data
    #-------------------------
    #Colors
    $Jet = '#121212'
    $Charcoal = '#40434E'
    $Steel = '#696773'
    $Deep = '#2E4057'
    $Sea = '#4D9DE0'
    $Diver = '#FFD166'
    $Champagne = '#EEE0CB'
    $Greenery = '#6BAB90'
    $Sand = '#ffe8d6'
    $Lava = '#E76F51'
    $Ice = '#ade8f4'
    $Snow = '#e9ecef'
    $Rock = '#949494'
    $YeezyBlue = '#9dadad'
    $YeezyTan = '#dac6ab'
    $YeezyAsh = '#939499'
    $Cafe = '#7F5539'
    $Latte = '#DDB892'
    $Mocha = '#B08968'

    #Color Schem
    $SchemeDark = $Jet, '#FFFFFF', $Charcoal, $Steel
    $SchemeCobalt = $Deep, '#FFFFFF', $Sea, $Diver
    $SchemeNature = $Champagne, '#000000', $Greenery, $Greenery
    $SchemeVolcanic  = $Sand, '#000000', $Lava, $Rock
    $SchemeArctic = $Snow, '#000000', $Ice, $Rock
    $SchemeYeezy = $YeezyAsh, '#000000', $YeezyTan, $YeezyBlue
    $SchemeCoffee = $Latte, '#000000', $Mocha, $Cafe

    
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
            $userobj = New-Object PSObject
            $userobj | Add-Member Noteproperty -Name User -value $env:UserName
            $userobj | Add-Member Noteproperty -Name Theme -value 'light'
            $userobj | Export-CSV -Path '\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\RemoteData\themes.csv' -Append
        }

        #Set theme colors
        IF($SelectedTheme -eq "dark"){
            $SelectedScheme = $SchemeDark
        }
        ELSEIF($SelectedTheme -eq "cobalt"){
            $SelectedScheme = $SchemeCobalt
        }
        ELSEIF($SelectedTheme -eq "nature"){
            $SelectedScheme = $SchemeNature
        }
        ELSEIF($SelectedTheme -eq "volcanic"){
            $SelectedScheme = $SchemeVolcanic
        }
        ELSEIF($SelectedTheme -eq "arctic"){
            $SelectedScheme = $SchemeArctic
        }
        ELSEIF($SelectedTheme -eq "yeezy"){
            $SelectedScheme = $SchemeYeezy
        }
        ELSEIF($SelectedTheme -eq "coffee"){
            $SelectedScheme = $SchemeCoffee
        }
        ELSEIF($SelectedTheme -eq "light"){ }
        ELSE{ }

        #Assign colors to .xaml elements, looping through collections of them
        IF($SelectedTheme -ne "light"){

            $WPFLoafGuiMainWindow.Background = $SelectedScheme[0]
            $WPFLoafGuiTabControl.Background = $SelectedScheme[0]

            $WPFLoafScriptUpdateText.Foreground = $SelectedScheme[1]

            $WPFLoafGUITabSetup.Background = $SelectedScheme[3]
            $WPFLoafGUITabInstalls.Background = $SelectedScheme[3]
            $WPFLoafGUITabPersonalization.Background = $SelectedScheme[3]
            $WPFLoafGUITabExperimental.Background = $SelectedScheme[3]

            $Buttonlist = @($WPFButtonAdminprocess,$WPFButtonBgUnlock,$WPFButtonBioscheck,$WPFButtonBiosPass,$WPFButtonBitcheck,$WPFButtonColorUnlock,$WPFButtonLockScreenUnlock,
                            $WPFButtonMSStoreLock,$WPFButtonMSStoreUnlock,$WPFButtonOracheck,$WPFButtonOraclePackage,$WPFButtonOrainstall32,$WPFButtonOrainstall64,$WPFButtonOraproperties,
                            $WPFButtonOrauninstall,$WPFButtonProgfeat,$WPFButtonRetireLocal,$WPFButtonRunhpia,$WPFButtonRunupdateassistant,$WPFButtonThemeUnlock,$WPFButtonPowerBIInstall32,$WPFButtonPowerBIInstall64,
                            $WPFButtonCiscoClient, $WPFButtonCiscoISE,$WPFButtonCiscoAMP,$WPFButtonCiscoXML,$WPFButtonNotepadPaint,$WPFButtonRunBGInfo,$WPFButtonHPDiag,$WPFButtonCiscoKiller,$WPFButtonKanye)

            $GroupBoxlist = @($WPFLoafGuiGroupBoxSetup,$WPFLoafGuiGroupBoxVerification,$WPFLoafGuiGroupBoxUninstalls,$WPFLoafGuiGroupBoxSoftware,$WPFLoafGuiGroupBoxOracle,
                                $WPFLoafGuiGroupBoxPersonalization,$WPFLoafGuiGroupBoxThemes,$WPFLoafGuiGroupBoxExperimental,$WPFLoafGUIGroupBoxCisco)

            $Loafloglist = @($WPFLoaflog1,$WPFLoaflog2,$WPFLoaflog3,$WPFLoaflog4)

            foreach($Buttonitem in $Buttonlist){
                $Buttonitem.Background = $SelectedScheme[2]
                $Buttonitem.Foreground = $SelectedScheme[1]
            }

            foreach($GroupBoxitem in $GroupBoxlist){
                $GroupBoxitem.Foreground = $SelectedScheme[1]
                $GroupBoxitem.BorderBrush = $SelectedScheme[0]
            }

            foreach($Loaflogitem in $Loafloglist){
                $Loaflogitem.Background = $SelectedScheme[0]
                $Loaflogitem.Foreground = $SelectedScheme[1]
            }
        }
    }
    catch{
        $WPFLoaflog1.Text = "Error setting theme!"
        $WPFLoaflog1.Text = "$($Error[0])"
    }
}
LoafScriptThemer

Function ChangeLoafScriptTheme{
    param (
        $ThemeName
    )
    try{
        $ThemeFile = Import-Csv "$LSRemote\themes.csv"

        #Loop through users found, set selected theme
        foreach ($ThemeUser in $ThemeFile) {
            if ($ThemeUser.User -eq $env:UserName){
                $ThemeUser.Theme = $ThemeName
                $ThemeFile | Export-Csv "$LSRemote\themes.csv"
                $WPFLoaflog3.Text = "Changed to "+$ThemeName+" theme!"
                #Refresh the script
                start-process powershell.exe -argument "& '.\LoafScript.ps1'"
                exit
            }
        }
    }
    catch{
        $WPFLoaflog1.Text = "Error setting theme!"
        $WPFLoaflog1.Text = "$($Error[0])"
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
$WPFButtonVolcanicTheme.Add_Click({
    ChangeLoafScriptTheme volcanic
})
$WPFButtonArcticTheme.Add_Click({
    ChangeLoafScriptTheme arctic
})
$WPFButtonYeezyTheme.Add_Click({
    ChangeLoafScriptTheme yeezy
})
$WPFButtonCoffeeTheme.Add_Click({
    ChangeLoafScriptTheme coffee
})

#-------------------------
#Updater Functions
#-------------------------
#Checks the LoafScript folder in \\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\ (Inside the parent LoafScript folder!)
#If the version of this script does not match, it prompts the user
Function downloadNewLoafScript{
    $WPFLoafGuiMainWindow.Title = "LoafScript " + $CurrentVersion
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
#Launch UI
#-------------------------
#write-host "To show the form, run the following" -ForegroundColor Cyan
$Form.ShowDialog() | out-null