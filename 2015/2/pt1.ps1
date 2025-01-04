$in = Get-Content -Path '.\input.txt'
$area, $extra, $total = 0, 0, 0

function Find-Area {
  param(
    [string[]]$Data
  )
  $order = 0
  $Data | ForEach-Object {
    [int[]]$nums = $_.Split("x")
    $length = $nums[0]
    $width = $nums[1]
    $height = $nums[2]
    $area = ((2 * $length * $width) + (2 * $width * $height) + (2 * $height * $length))
    $order += $area
  }
  return $order
}

function Find-Extra {
  param(
    [string[]]$Data
  )
  $smallest = 0
  $Data | ForEach-Object {
    [int[]]$nums = $_.Split("x")
    $nums = $nums | Sort-Object
    $smallest += ($nums[0] * $nums[1])

  }
  return $smallest
}

$area = Find-Area -Data $in
$extra = Find-Extra -Data $in
$total += $area
$total += $extra

Write-Host "Order $total"
