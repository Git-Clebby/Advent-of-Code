$in = @(Get-Content -Path '.\input.txt')

function check-repeat {
  param(
    [string]$string
  )
  for ($i = 0; $i -lt $string.Length - 1; $i++) {
    if ($string[$i] -eq $string[$i + 2]) {
      return $true
    }
  }
  return $false
}

function check-twice {
  param(
    [string]$string
  )

  for ($i = 0; $i -lt $string.Length - 1; $i++) {
    $substring = $string.Substring($i, 2)
    $restOfString = $string.Substring($i + 2)
    if ($restOfString.Contains($substring)) {
      return $true
    }
  }
  return $false

}


function naughty-or-nice {
  param(
    [string]$lineIn
  )

  $validTwice = check-twice -string $lineIn
  $validRepeat = check-repeat -string $lineIn

  if ($validTwice -and $validRepeat) {
    return $true
  }
  return $false
}

$niceCount = 0

foreach ($line in $in) {
  $lineStatus = naughty-or-nice -lineIn $line
  if ($lineStatus) {
    $niceCount++
  }
}

Write-Host $niceCount
