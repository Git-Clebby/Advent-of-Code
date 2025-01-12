# Define a class to represent the circuit
class Circuit {
  $wires = @{}
  $instructions = @{}
  $cache = @{}

  [void] AddInstruction($instruction) {
    $parts = $instruction -split ' -> '
    $target = $parts[1].Trim()
    $operation = $parts[0].Trim()
    $this.instructions[$target] = $operation
  }

  # Helper function to ensure 16-bit unsigned integer
  [UInt16] Normalize($value) {
    return [UInt16]($value -band 0xFFFF)
  }

  [UInt16] GetSignal($wire) {
    # Check cache first
    if ($this.cache.ContainsKey($wire)) {
      return $this.cache[$wire]
    }

    # If wire is a number, return it
    if ($wire -match '^\d+$') {
      return $this.Normalize([int]$wire)
    }

    $operation = $this.instructions[$wire]
    $signal = 0

    if ($operation -match '^\d+$') {
      $signal = $this.Normalize([int]$operation)

    } elseif ($operation -match 'NOT (.+)') {
      $input = $matches[1]
      $signal = $this.Normalize(-bnot $this.GetSignal($input))

    } elseif ($operation -match '(.+) AND (.+)') {
      $left = $matches[1]
      $right = $matches[2]
      $signal = $this.Normalize($this.GetSignal($left) -band $this.GetSignal($right))

    } elseif ($operation -match '(.+) OR (.+)') {
      $left = $matches[1]
      $right = $matches[2]
      $signal = $this.Normalize($this.GetSignal($left) -bor $this.GetSignal($right))

    } elseif ($operation -match '(.+) LSHIFT (\d+)') {
      $input = $matches[1]
      $shift = [int]$matches[2]
      $signal = $this.Normalize($this.GetSignal($input) -shl $shift)

    } elseif ($operation -match '(.+) RSHIFT (\d+)') {
      $input = $matches[1]
      $shift = [int]$matches[2]
      $signal = $this.Normalize($this.GetSignal($input) -shr $shift)
    } else {

      $signal = $this.GetSignal($operation)
    }

    # Cache the result
    $this.cache[$wire] = $signal
    return $signal
  }
}

# Construct new 'circuit' class object
$circuit = [Circuit]::new()

# Read input from file
Get-Content 'input.txt' | ForEach-Object {
  $circuit.AddInstruction($_)
}

$signal = $circuit.GetSignal('a')
Write-Host "Signal on wire 'a': $signal"
