#loafscript built by Vlad Franco and Jag Singh


$inputXML = @"
<Window x:Class="LoafGui.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:LoafGui"
        mc:Ignorable="d"
        Title="MainWindow" Height="450" Width="400">
    <Grid>
        <Image HorizontalAlignment="Left" Height="65" Margin="10,10,0,0" VerticalAlignment="Top" Width="65" Source="\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\Intern Refresh\Loafscript\Data\LoafIcon.png"/>
        <TextBlock HorizontalAlignment="Left" Margin="43,85,0,0" TextWrapping="Wrap" Text="Install Oracle" VerticalAlignment="Top"/>
        <TextBlock HorizontalAlignment="Left" Margin="42,106,0,0" TextWrapping="Wrap" Text="Check Oracle" VerticalAlignment="Top"/>
        <TextBlock HorizontalAlignment="Left" Margin="30,127,0,0" TextWrapping="Wrap" Text="Check Bitlocker" VerticalAlignment="Top"/>
        <TextBlock HorizontalAlignment="Left" Margin="12,148,0,0" TextWrapping="Wrap" Text="Check Bios Version" VerticalAlignment="Top"/>
        <TextBlock HorizontalAlignment="Left" Margin="9,169,0,0" TextWrapping="Wrap" Text="Run Office Updater" VerticalAlignment="Top"/>
        <TextBlock HorizontalAlignment="Left" Margin="61,190,0,0" TextWrapping="Wrap" Text="Run HIPA" VerticalAlignment="Top"/>
        <TextBlock HorizontalAlignment="Left" Margin="22,295,0,0" TextWrapping="Wrap" Text="Uninstall Oracle" VerticalAlignment="Top" Width="88"/>
        <TextBlock HorizontalAlignment="Left" Margin="22,316,0,0" TextWrapping="Wrap" Text="Uninstall Office" VerticalAlignment="Top" Width="88"/>
        <Button x:Name="Orainstall32" Content="32" HorizontalAlignment="Left" Height="16" Margin="116,85,0,0" VerticalAlignment="Top" Width="20"/>
        <Button x:Name="Orainstall64" Content="64" HorizontalAlignment="Left" Height="16" Margin="141,85,0,0" VerticalAlignment="Top" Width="20"/>
        <Button x:Name="Oracheck" Content="" HorizontalAlignment="Left" Height="16" Margin="116,106,0,0" VerticalAlignment="Top" Width="20"/>
        <Button x:Name="Bitcheck" Content="" HorizontalAlignment="Left" Height="16" Margin="116,127,0,0" VerticalAlignment="Top" Width="20"/>
        <Button x:Name="Bioscheck" Content="" HorizontalAlignment="Left" Height="16" Margin="116,148,0,0" VerticalAlignment="Top" Width="20"/>
        <Button x:Name="Oupdate32" Content="32" HorizontalAlignment="Left" Height="16" Margin="116,169,0,0" VerticalAlignment="Top" Width="20"/>
        <Button x:Name="Oupdate64" Content="64" HorizontalAlignment="Left" Height="16" Margin="141,169,0,0" VerticalAlignment="Top" Width="20"/>
        <Button x:Name="Runhipa" Content="" HorizontalAlignment="Left" Height="16" Margin="116,190,0,0" VerticalAlignment="Top" Width="20"/>
        <Button x:Name="Orauninstall" Content="" HorizontalAlignment="Left" Height="16" Margin="116,295,0,0" VerticalAlignment="Top" Width="20"/>
        <Button x:Name="Officeuninstall" Content="" HorizontalAlignment="Left" Height="16" Margin="116,316,0,0" VerticalAlignment="Top" Width="20"/>
        <TextBox x:Name="Loaflog" HorizontalAlignment="Left" Height="363" Margin="183,21,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="198"/>
    </Grid>
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

#Oracle Installers
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


#Bios Check
Function chkBios{
wmic bios get smbiosbiosversion
wmic bios get serialnumber}
$WPFBioscheck.Add_Click({ 
$WPFLoaflog.Text = chkBios 
})


#Office Updaters
Function uoff32{
$ScriptPath = Split-Path $MyInvocation.InvocationName
& ".\Data\Update Office to Semi Annual Channel.bat"
}
$WPFOupdate32.Add_Click({ 
$WPFLoaflog.Text = uoff32
})
Function uoff64{
$ScriptPath = Split-Path $MyInvocation.InvocationName
& ".\Data\Update Office to Semi Annual Channel - 64bit.bat"
}
$WPFOupdate64.Add_Click({ 
$WPFLoaflog.Text = uoff32
})


#Run HIPA
Function HipaExe{
$ScriptPath = Split-Path $MyInvocation.InvocationName
& "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\2.Drivers\sp94976.exe"}
$WPFRunhipa.Add_Click({ 
$WPFLoaflog.Text = "Running Hipa"
HipaExe
})

#Uninstall Oracle
Function UnOra{
start powershell ((Split-Path $MyInvocation.InvocationName) + ".\Data\loafuninoracle.ps1")}
$WPFOrauninstall.Add_Click({ 
$WPFLoaflog.Text = "Uninstalling Oracle"
UnOra
})

#Uninstall Office
Function UnOffice{}
$WPFOrauninstall.Add_Click({ 
$WPFLoaflog.Text = "Running Hipa"
UnOffice
})


#-------------------------
#Launch Form
#-------------------------

#write-host "To show the form, run the following" -ForegroundColor Cyan
$Form.ShowDialog() | out-null