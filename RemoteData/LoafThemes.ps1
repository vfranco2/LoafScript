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

#Color Schem
$SchemeDark = $Jet, '#FFFFFF', $Charcoal, $Steel
$SchemeCobalt = $Deep, '#FFFFFF', $Sea, $Sea
$SchemeNature = $Champagne, '#000000', $Greenery, $Greenery
$SchemeVolcanic  = $Sand, '#000000', $Lava, $Rock
$SchemeArctic = $Snow, '#000000', $Ice, $Rock
$SchemeYeezy = $YeezyAsh, '#000000', $YeezyTan, $YeezyBlue

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
                        $WPFButtonCiscoClient, $WPFButtonCiscoISE,$WPFButtonCiscoAMP,$WPFButtonCiscoXML,$WPFButtonNotepadPaint,$WPFButtonRunBGInfo,$WPFButtonHPDiag,$WPFButtonCiscoKiller)

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
    #$WPFLoaflog1.Text = "$($Error[0])"
}