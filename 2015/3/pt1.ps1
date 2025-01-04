$in = Get-Content -Path '.\input.txt'

function find-houses {
  [CmdletBinding()]
  param (
    [Parameter(ValueFromPipeline = $true, Mandatory = $true)][string]$data,
    $visited = @(),
    $coord = @{x=0; y=0}
  )
  # Starting Point
  $visited += "0,0"
  foreach($dir in $in.ToCharArray()) {
    switch ($dir) {
      '^' { $coord.y += 1 }
      '>' { $coord.x += 1 }
      '<' { $coord.x -= 1 }
      'v' { $coord.y -= 1 }
    }
    $visited += "$($coord.x),$($coord.y)"
  }
  $unique = ($visited | Select-Object -Unique ).Count
  return $unique
}

$houses = find-houses -data $in
Write-Host $houses
