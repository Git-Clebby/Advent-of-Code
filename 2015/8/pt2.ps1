$inputFile = Get-Content -Path '.\input.txt'
$rawTotal = 0
$regTotal = 0
$inputFile | ForEach-Object {
    $rawLength = $_.Length
    $regValue = $_.Replace('\', '\\')
    $regValue = $regValue.Replace('"', '\"')
    $regValue = '"' + $regValue + '"'
    $regLength = $regValue.Length
    $rawTotal += $rawLength
    $regTotal += $regLength
}
Write-Host "Result: $($regTotal - $rawTotal)"
