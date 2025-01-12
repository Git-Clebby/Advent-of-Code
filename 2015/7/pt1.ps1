$in = @(Get-Content -Path '.\input.txt')
$instructionList = New-Object System.Collections.ArrayList

function read-wires {
  param(
    [string[]]$list
  )
  $wireTable = @{}
  foreach($wire in $list) {
    $wireTable["$wire"] = $null
  }
  
  return $wireTable
}

function read-instructions {
  param(
    [string[]]$in
  )
  $rightList = @()
  foreach($line in $in) {
    $leftSide, $rightSide = $line -split " -> "
    $isReady = $false
    $operation = ''
        
    if ($leftSide -match "NOT ") {
      $notWire = ($leftSide -split 'NOT ')[1].Trim()
      $operation = 'NOT'
      $inputs = $notWire

    } elseif ($leftSide -match " AND ") {
      $andWire = $leftSide -split " AND "
      $operation = 'AND'
      $inputs = @($andWire[0],$andWire[1])

    } elseif ($leftSide -match " OR ") {
      $orWire = $leftSide -split " OR "
      $operation = 'OR'
      $inputs = @($orWire[0],$orWire[1])

    } elseif ($leftSide -match " LSHIFT ") {
      $lShiftWire = $leftSide -split " LSHIFT "
      $operation = 'LSHIFT'
      $inputs = @($lShiftWire[0],$lShiftWire[1])

    } elseif ($leftSide -match " RSHIFT ") {
      $rShiftWire = $leftSide -split " RSHIFT "
      $operation = 'RSHIFT'
      $inputs = @($rShiftWire[0],$rShiftWire[1])

    } else {
      $isReady = $true
    }
    $instruction = [PSCustomObject]@{
      Operation = $operation
      Inputs = $inputs -join ','
      Outputs = $rightSide
      IsReady = $isReady
    }

    $rightList += $rightSide
    $instructionList.Add($instruction) | Out-Null
  }
  return $instructionList
}

function process-instructions {
  param(
    $instructions,
    $wireValues = @{}
  )
    
  # Process any direct assignments first (where IsReady is true)
  foreach($instruction in $instructions) {
    if($instruction.IsReady) {
      # This means it's a direct value assignment
      $wireValues[$instruction.Outputs] = [int]$instruction.Inputs
    }
  }

  while(-not $wireValues.ContainsKey('a')) {
    foreach($instruction in $instructions) {
      if(-not $instruction.IsReady) {
        $inputWires = $instruction.Inputs -split ','
        switch ($instruction.Operation) {
          'AND' {
            $inputs = $instruction.Inputs -split ','
            $val1 = if ([int]::TryParse($inputs[0], [ref]$null)) {
              [int]$inputs[0] 
            } else {
              $wireValues[$inputs[0]] 
            }
            $val2 = if ([int]::TryParse($inputs[1], [ref]$null)) {
              [int]$inputs[1] 
            } else {
              $wireValues[$inputs[1]] 
            }
            $wireValues[$($instruction.Outputs)] = $val1 -band $val2
          }
          'OR' {
            $inputs = $instruction.Inputs -split ','
            $val1 = if ([int]::TryParse($inputs[0], [ref]$null)) {
              [int]$inputs[0] 
            } else {
              $wireValues[$inputs[0]] 
            }
            $val2 = if ([int]::TryParse($inputs[1], [ref]$null)) {
              [int]$inputs[1] 
            } else {
              $wireValues[$inputs[1]] 
            }
            $wireValues[$($instruction.Outputs)] = $val1 -bor $val2
          }
          'NOT' {
            $wireValues[$($instruction.Outputs)] = -bnot $wireValues[$instruction.Inputs]
          }
          'LSHIFT' {
            $inputs = $instruction.Inputs -split ','
            $wireValues[$($instruction.Outputs)] = $wireValues[$inputs[0]] -shl [int]$inputs[1]
          }
          'RSHIFT' {
            $inputs = $instruction.Inputs -split ','
            $wireValues[$($instruction.Outputs)] = $wireValues[$inputs[0]] -shr [int]$inputs[1]
          }
        }
      }
    }
  }
    
  return $wireValues['a']
}

$instructions = read-instructions -list $in
$result = process-instructions -instructions $instructions

Write-Host $result
