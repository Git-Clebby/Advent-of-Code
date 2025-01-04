$in = Get-Content -Path '.\input.txt'

function Find-Bow {
  param(
    [string[]]$Data
  )
  $bow = 0
  $Data | ForEach-Object {
    [int[]]$nums = $_.Split("x")
    $area = $nums[0] * $nums[1] * $nums[2]
    $bow += $area
  }
  return $bow
}

function Find-Length {
  param(
    [string[]]$Data
  )
  $length = 0
  $Data | ForEach-Object {
    [int[]]$nums = $_.Split("x")
    $nums = $nums | Sort-Object
    $j = $nums[0]
    $k = $nums[1]
    $length += (($j * 2) + ($k * 2))
  }
  return $length
}

$rib = Find-Length -Data $in
$bow = Find-Bow -Data $in
$total = $rib + $bow
Write-Host $total
