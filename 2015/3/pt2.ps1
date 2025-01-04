$in = Get-Content -Path '.\input.txt'

function find-houses {
  [CmdletBinding()]
  param (
    [Parameter(ValueFromPipeline = $true, Mandatory = $true)][string]$data,
    $visited = @(),
    $coord = @{x=0; y=0},
    $roboCoord = @{x=0; y=0}
  )

  $visited += "0,0"
  $dirPerson = $true
  foreach($dir in $in.ToCharArray()) {
    # dirPerson will be true for Santa, and false for RoboSanta
    $currentSanta = if($dirPerson) { $coord } else { $roboCoord }
    switch ($dir) {
      '^' { $currentSanta.y += 1 }
      '>' { $currentSanta.x += 1 }
      '<' { $currentSanta.x -= 1 }
      'v' { $currentSanta.y -= 1 }
    }
    $visited += "$($currentSanta.x),$($currentSanta.y)"
    $dirPerson = !$dirPerson
  }
  $unique = ($visited | Select-Object -Unique).Count
  return $unique
}

$houses = find-houses -data $in
Write-Host $houses
