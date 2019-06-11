#loafscript built by Vlad Franco and Jag Singh


$inputXML = @"
<Window x:Class="LoafGui.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:LoafGui"
        mc:Ignorable="d"
        Title="MainWindow" Height="450" Width="800">
    <Grid>
        <Image HorizontalAlignment="Left" Height="65" Margin="10,10,0,0" VerticalAlignment="Top" Width="65" Source="H:\LoafGui\LoafIcon.png"/>
        <TextBlock HorizontalAlignment="Left" Margin="43,85,0,0" TextWrapping="Wrap" Text="Install Oracle" VerticalAlignment="Top"/>
        <TextBlock HorizontalAlignment="Left" Margin="42,106,0,0" TextWrapping="Wrap" Text="Check Oracle" VerticalAlignment="Top"/>
        <TextBlock HorizontalAlignment="Left" Margin="30,127,0,0" TextWrapping="Wrap" Text="Check Bitlocker" VerticalAlignment="Top"/>
        <TextBlock HorizontalAlignment="Left" Margin="12,148,0,0" TextWrapping="Wrap" Text="Check Bios Version" VerticalAlignment="Top"/>
        <TextBlock HorizontalAlignment="Left" Margin="9,169,0,0" TextWrapping="Wrap" Text="Run Office Updater" VerticalAlignment="Top"/>
        <TextBlock HorizontalAlignment="Left" Margin="61,190,0,0" TextWrapping="Wrap" Text="Run HIPA" VerticalAlignment="Top"/>
        <Button x:Name="Orainstall32" Content="32" HorizontalAlignment="Left" Height="16" Margin="116,85,0,0" VerticalAlignment="Top" Width="20"/>
        <Button x:Name="Orainstall64" Content="64" HorizontalAlignment="Left" Height="16" Margin="141,85,0,0" VerticalAlignment="Top" Width="20"/>
        <Button x:Name="Oracheck" Content="" HorizontalAlignment="Left" Height="16" Margin="116,106,0,0" VerticalAlignment="Top" Width="20"/>
        <Button x:Name="Bitcheck" Content="" HorizontalAlignment="Left" Height="16" Margin="116,127,0,0" VerticalAlignment="Top" Width="20"/>
        <Button x:Name="Bioscheck" Content="" HorizontalAlignment="Left" Height="16" Margin="116,148,0,0" VerticalAlignment="Top" Width="20"/>
        <Button x:Name="Oupdate32" Content="32" HorizontalAlignment="Left" Height="16" Margin="116,169,0,0" VerticalAlignment="Top" Width="20"/>
        <Button x:Name="Oupdate64" Content="64" HorizontalAlignment="Left" Height="16" Margin="141,169,0,0" VerticalAlignment="Top" Width="20"/>
        <Button x:Name="Runhipa" Content="" HorizontalAlignment="Left" Height="16" Margin="116,190,0,0" VerticalAlignment="Top" Width="20"/>
        <TextBox x:Name="loaflog" HorizontalAlignment="Left" Height="363" Margin="183,21,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="547"/>
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
 
#===========================================================================
# Load XAML Objects In PowerShell
#===========================================================================
  
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

#Reference 
 
#Adding items to a dropdown/combo box
    #$vmpicklistView.items.Add([pscustomobject]@{'VMName'=($_).Name;Status=$_.Status;Other="Yes"})
     
#Setting the text of a text box to the current PC name    
    #$WPFtextBox.Text = $env:COMPUTERNAME


#Oracle Installers
Function installOra32{
start powershell ((Split-Path $MyInvocation.InvocationName) + ".\oracleinstaller32.ps1")}
$WPFOrainstall32.Add_Click({ 
$WPFloaflog.Text = "Installing Oracle 32"
})
Function installOra64{
start powershell ((Split-Path $MyInvocation.InvocationName) + ".\oracleinstaller64.ps1")}
$WPFOrainstall64.Add_Click({ 
$WPFloaflog.Text = "Installing Oracle 64"
})


#Check Oracle
Function chkOra{
tnsping}
$WPFOracheck.Add_Click({ 
$WPFloaflog.Text = chkOra 
})


#Bitlocker Check
Function chkBit{
manage-bde c: -protectors -get}
$WPFBitcheck.Add_Click({ 
$WPFloaflog.Text = chkBit
})


#Bios Check
Function chkBios{
Write-Host "Bios Version"
wmic bios get smbiosbiosversion
wmic bios get serialnumber}
$WPFBioscheck.Add_Click({ 
$WPFloaflog.Text = chkBios 
})


#Office Updaters
Function uoff32{
$ScriptPath = Split-Path $MyInvocation.InvocationName
& ".\Data\Update Office to Semi Annual Channel.bat"
}
$WPFOupdate32.Add_Click({ 
$WPFloaflog.Text = uoff32
})
Function uoff64{
$ScriptPath = Split-Path $MyInvocation.InvocationName
& ".\Data\Update Office to Semi Annual Channel - 64bit.bat"
}
$WPFOupdate64.Add_Click({ 
$WPFloaflog.Text = uoff32
})


#Run HIPA
Function HipaExe{
$ScriptPath = Split-Path $MyInvocation.InvocationName
& "\\nacorpcl\NOC_Install_Files\NOC\CDS\Client\_Post Image\W10\2.Drivers\sp94976.exe"}
$WPFRunhipa.Add_Click({ 
$WPFloaflog.Text = "Running Hipa"
HipaExe
})

#-------------------------
#Launch Form
#-------------------------
write-host "To show the form, run the following" -ForegroundColor Cyan
$Form.ShowDialog() | out-null