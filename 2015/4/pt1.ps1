$nums = @(1..1000000)
$string = 'iwrupvqb'

function find-hash-beginning {
  param(
    [string]$in
  )

  $md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
  $utf8 = New-Object -TypeName System.Text.UTF8Encoding
  $hash = [System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($in)))
  $hashSansDash = $hash -replace "-",""
  $hashBeg = $hashSansDash.Substring(0,5)

  return $hashBeg
}

foreach($number in $nums) {
  $loopString = $string+$($number.ToString())
  $result = find-hash-beginning -in $loopString
  Write-Host $result
  if($result -eq '00000') {
    Write-Host $loopString
    exit
  }
}
