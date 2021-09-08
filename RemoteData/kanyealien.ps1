$tempo = 400
$i = 0

do {Write-Host $i; $i++
    [console]::beep(293,$tempo) ##D
    [console]::beep(392,$tempo) ##G
    [console]::beep(466.1,$tempo) ##A#
    [console]::beep(349.2,$tempo) ##F
    [console]::beep(392,$tempo) ##G
    [console]::beep(311.1,$tempo) ##D#
    [console]::beep(293,$tempo) ##D
    [console]::beep(261.6,$tempo) ##C
}
until($i -eq 200)