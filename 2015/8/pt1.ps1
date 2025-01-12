$inputFile = Get-Content -Path '.\input.txt'
$rawTotal = 0
$regTotal = 0
$inputFile | ForEach-Object {
  $rawLength =  $_.Length
  $regValue = $_.Trim('"')
  $regValue = $regValue.Replace('\\','\')
  $regValue = $regValue.Replace('\"','"')
  $regValue = $regValue -replace '\\x[0-9a-fA-F]{2}', '"'
  $regLength = $regValue.Length
  $rawTotal += $rawLength
  $regTotal += $regLength
  # Uncomment for debug output
  # Write-Host "Line raw: $rawLength, reg: $regLength"
}
Write-Host "Result: $($rawTotal -  $regTotal)"
