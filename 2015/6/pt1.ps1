$in = Get-Content -Path '.\input.txt'

function Create-Grid {
  $lightGrid = New-Object System.Collections.ArrayList
  $count = 0
    
  for ($x = 0; $x -le 999; $x++) {
    for ($y = 0; $y -le 999; $y++) {
      [void]$lightGrid.Add([PSCustomObject]@{
          x = $x
          y = $y
          state = $false
        })
      $count++
    }
  }
  Write-Host "Created $count lights on grid"
  return $lightGrid
}

function do-instruction {
  param(
    [string]$method,
    [int]$xStart,
    [int]$yStart,
    [int]$xEnd,
    [int]$yEnd,
    [System.Collections.ArrayList]$grid
  )

  foreach ($light in $grid) {
    if ($light.x -ge $xStart -and $light.x -le $xEnd -and $light.y -ge $yStart -and $light.y -le $yEnd) {
      switch ($method) {
        'toggle ' { $light.State = !$light.State }
        'turn on' { $light.State = $true }
        'turn of' { $light.State = $false }
      }
    }
  }
  return $grid

}

function process-line {
  param(
    [string]$in
  )
  $insList = New-Object System.Collections.ArrayList

  $in | ForEach-Object {
    $line = $_
    $instruction = $_.Substring(0,7)

    switch ($instruction) {
      'toggle ' {
        $coords = $line.Substring(7).Trim()
      }
      'turn on' {
        $coords = $line.Substring(7).Trim()
      }
      'turn of' {
        $coords = $line.Substring(8).Trim()
      }
    }
    $xycoords = $coords -split ' through ',2
    $beginning = $xycoords[0] -split ',',2
    $end = $xycoords[1] -split ',',2
    $xBeg = $beginning[0]
    $yBeg = $beginning[1]
    $xEnd = $end[0]
    $yEnd = $end[1]
    $ins = [PSCustomObject]@{
      method = $instruction
      xBeg = $xBeg
      xEnd = $xEnd
      yBeg = $yBeg
      yEnd = $yEnd
    }
    $insList.Add($ins) | Out-Null
  }

  return $insList
}

function find-on {
  param(
    [System.Collections.ArrayList]$in
  )
  $count = 0

  foreach ($light in $in) {
    if ($light.State -eq $true) {
      $count++
    }
  }
  return $count
}


$grid = create-grid
$instructionList = $in | ForEach-Object { process-line -in $_ }
Write-Host "Number of instructions: $($instructionList.Count)"  # Debug count of instructions

$gridInstruction = $instructionList | ForEach-Object { 
  do-instruction -grid $grid -method $_.method -xStart $_.xBeg -xEnd $_.xEnd -yStart $_.yBeg -yEnd $_.yEnd 
}
$solution = find-on -in $grid
Write-Host $solution
