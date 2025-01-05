$string = 'abcdef609043'

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

$out = find-hash-beginning -in $string
