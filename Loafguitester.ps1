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
        <TextBox HorizontalAlignment="Left" Height="363" Margin="183,21,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="547"/>
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


#===========================================================================
# Use this space to add code to the various form elements in your GUI
#===========================================================================
                                                                    
     
#Reference 
 
#Adding items to a dropdown/combo box
    #$vmpicklistView.items.Add([pscustomobject]@{'VMName'=($_).Name;Status=$_.Status;Other="Yes"})
     
#Setting the text of a text box to the current PC name    
    #$WPFtextBox.Text = $env:COMPUTERNAME
     
#Adding code to a button, so that when clicked, it pings a system
# $WPFbutton.Add_Click({ Test-connection -count 1 -ComputerName $WPFtextBox.Text
# })
#===========================================================================
# Shows the form
#===========================================================================
write-host "To show the form, run the following" -ForegroundColor Cyan
$Form.ShowDialog() | out-null