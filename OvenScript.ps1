$CurrentVersion = "1.0.0"
#OvenScript built by Vlad Franco
#This script is designed to bundle the new version of LoafScript for easy upgrading.

#----------------------
#XAML User Interface file found in LocalData folder
#----------------------

#-------------------------
# Load XAML UI File From LocalData
#-------------------------
$xamlFile = ".\LocalData\OvenScriptUI.xaml"
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

#Retire Old LoafScript Version
Function Sunset{
    $HostName=$env:UserName

    Try{
        $RetireLoaf = Get-ChildItem -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\LoafScript*"

        Move-Item $RetireLoaf "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\LoafBackups"
    }
    Catch{
        $WPFOvenlog1.Text = "Error: No existing LoafScript release found in Intern Refresh\LoafScript"
    }
    
}

Function MkDir{
    $WPFOvenlog1.Text = "Creating new LoafScript directory"

    Try{
        $DirName = "LoafScript "+ $DetectedDevelopment
        New-Item -ItemType Directory -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\$DirName\"
        New-Item -ItemType Directory -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\$DirName\LocalData\"

        $WPFOvenLoader.Width=97
    }
    Catch{
        $WPFOvenlog1.Text = "Error: Could not create directory for new LoafScript version"
    }
}

Function FileCopy{
    $WPFOvenlog1.Text = "Copying files"

    Try{
        $DirName = "LoafScript "+ $DetectedDevelopment

        Copy-Item ".\LoafScript.ps1" -Destination "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\$DirName" -Recurse -ErrorAction Stop
        $WPFOvenLoader.Width=136
        Copy-Item ".\LocalData\LoafScriptUI.xaml" -Destination "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\$DirName\LocalData" -Recurse -ErrorAction Stop
        $WPFOvenLoader.Width=175
        Copy-Item ".\README.md" -Destination "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\$DirName" -Recurse -ErrorAction Stop
        $WPFOvenLoader.Width=214
        Copy-Item ".\README.md" -Destination "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript" -Recurse -ErrorAction Stop
        $WPFOvenLoader.Width=253
        Rename-Item -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\README.md" -NewName "README.txt"
    }
    Catch{
        $WPFOvenlog1.Text = "Error: Could not copy LoafScript files to new NOC folder"
    }
}

Function Bake{
    try{
        Sunset
        MkDir
        FileCopy

        $WPFOvenlog1.Text = "New Loaf Baked!"
        $WPFOvenLoader.Width=292
    }
    catch{
    
    }
    

}
$WPFButtonBake.Add_Click({
    Bake
})

$DetectedDevelopment = Get-Content -Path .\LoafScript.ps1 -TotalCount 1
$DetectedDevelopment = $DetectedDevelopment.substring(0, $DetectedDevelopment.Length-1)
$DetectedDevelopment = $DetectedDevelopment.substring(19)

$WPFDetectedDevelopment.Text = "LoafScript " + $DetectedDevelopment + " detected in LoafScriptMaster."

$DetectedReleased = Get-ChildItem -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\LoafScript*"
$CompareVersion = $DetectedReleased.ToString()
$CompareVersion = $CompareVersion.substring(81)

$WPFDetectedReleased.Text = "LoafScript " + $CompareVersion + " detected in NOC."

if ([version]$DetectedDevelopment -gt [version]$CompareVersion -or [version]$DetectedDevelopment -eq [version]$CompareVersion){
    $WPFButtonBake.IsEnabled="true"
}

#-------------------------
#Launch UI
#-------------------------
#write-host "To show the form, run the following" -ForegroundColor Cyan
$Form.ShowDialog() | out-null