$in = Get-Content -Path '.\input.txt'
$position = 0
$upCount = $in.ToCharArray().Where({ $_ -eq '(' }).Count
$downCount = $in.ToCharArray().Where({ $_ -eq ')' }).Count

$position = $position + $upCount
$position = $position - $downCount
Write-Host $position
