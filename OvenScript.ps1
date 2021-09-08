$CurrentVersion = "1.1.1"
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
$WPFOvenIcon.Source = '\\nacorpcl/NOC_Install_Files/NOC/CDS/Client/Intern Refresh/LoafScript/RemoteData/LoafIcons/LoafIconOven.png'

#Get existing LoafScript version, compare to LSMaster version
$DetectedDevelopment = Get-Content -Path .\LoafScript.ps1 -TotalCount 1
$DetectedDevelopment = $DetectedDevelopment.substring(0, $DetectedDevelopment.Length-1)
$DetectedDevelopment = $DetectedDevelopment.substring(19)

$WPFDetectedDevelopment.Text = "LoafScript " + $DetectedDevelopment + " detected in LoafScriptMaster."

$DetectedReleased = Get-ChildItem -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\LoafScript*"
$CompareVersion = $DetectedReleased.ToString()
$CompareVersion = $CompareVersion.substring(81)

$WPFDetectedReleased.Text = "LoafScript " + $CompareVersion + " detected in NOC."

if ([version]$DetectedDevelopment -gt [version]$CompareVersion){
    $WPFButtonBake.IsEnabled="true"
}

Function Bake{
    $HostName=$env:UserName
    $DirName = "LoafScript "+ $DetectedDevelopment
    try{
    
        #Move existing LoafScript release to LoafBackups
        Try{
            $WPFOvenlog1.Text = "Moving existing LoafScript to LoafBackups"
            $RetireLoaf = Get-ChildItem -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\LoafScript*"
            Move-Item $RetireLoaf "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\LoafBackups"
        }
        Catch{
            $WPFOvenlog1.Text = "Error: No existing LoafScript release found in Intern Refresh\LoafScript"
        }

        #Create directories for new LoafScript release
        Try{
            $WPFOvenlog1.Text = "Creating new LoafScript directory"
            New-Item -ItemType Directory -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\$DirName\"
            New-Item -ItemType Directory -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\$DirName\LocalData\"
        }
        Catch{
            $WPFOvenlog1.Text = "Error: Could not create directory for new LoafScript version"
        }

        #Copy files from LSMaster to new LoafScript directories
        Try{
            $WPFOvenlog1.Text = "Copying files"
            Remove-Item -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\README.txt" -Recurse -ErrorAction Stop
            Copy-Item ".\LoafScript.ps1" -Destination "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\$DirName" -Recurse -ErrorAction Stop
            Copy-Item ".\LocalData\LoafScriptUI.xaml" -Destination "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\$DirName\LocalData" -Recurse -ErrorAction Stop
            Copy-Item ".\README.md" -Destination "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\$DirName" -Recurse -ErrorAction Stop
            Copy-Item ".\README.md" -Destination "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript" -Recurse -ErrorAction Stop
            Rename-Item -Path "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\LoafScript\README.md" -NewName "README.txt"
        }
        Catch{
            $WPFOvenlog1.Text = "Error: Could not copy LoafScript files to new NOC folder"
        }
        
        $WPFOvenIcon.Source = '\\nacorpcl/NOC_Install_Files/NOC/CDS/Client/Intern Refresh/LoafScript/RemoteData/LoafIcons/LoafIconOvenBaked.png'
        $WPFOvenlog1.Text = "New Loaf Baked!"
    }
    catch{
        $WPFOvenlog1.Text = "Error Baking Loaf!"
    }
}
$WPFButtonBake.Add_Click({
    Bake
})

#-------------------------
#Launch UI
#-------------------------
#write-host "To show the form, run the following" -ForegroundColor Cyan
$Form.ShowDialog() | out-null