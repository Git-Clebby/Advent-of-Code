$in = Get-Content -Path '.\input.txt'
$inArray = $in.ToCharArray()
$position = 0
$floor = 0


while ($position -lt $in.Length) {
  if ($inArray[$position] -eq '(') {
    $floor++
  }
  if ($inArray[$position] -eq ')') {
    $floor--
  }
  if ($floor -lt 0) {
    $position++
    Write-Host "Entered basement at position: $position"
    exit
  }
  $position++
}
