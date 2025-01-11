$in = @(Get-Content -Path '.\input.txt')

function check-vowel {
  param(
    [string]$string
  )
  $vowelCount = ([regex]::Matches($string, '[aeiou]')).Count
  return $vowelCount -ge 3
}

function check-twice {
  param(
    [string]$string
  )
  for ($i = 0; $i -lt $string.Length - 1; $i++) {
    if ($string[$i] -eq $string[$i + 1]) {
      return $true
    }
  }
  return $false
}

function check-special {
  param(
    [string]$string
  )

  $specialList= @('ab', 'cd', 'pq', 'xy')

  foreach ($duo in $specialList) {
    if ($string.Contains($duo)) {
      return $false
    }
  }
  return $true 
}

function naughty-or-nice {
  param(
    [string]$lineIn
  )

  $validVowel = check-vowel -string $lineIn
  $validTwice = check-twice -string $lineIn
  $validSpecial = check-special -string $lineIn

  if ($validVowel -and $validTwice -and $validSpecial) {
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
