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

    [void] Reset() {
        $this.cache.Clear()
    }

    [void] OverrideWire($wire, $value) {
        $this.instructions[$wire] = $value.ToString()
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
        }
        elseif ($operation -match 'NOT (.+)') {
            $input = $matches[1]
            $signal = $this.Normalize(-bnot $this.GetSignal($input))
        }
        elseif ($operation -match '(.+) AND (.+)') {
            $left = $matches[1]
            $right = $matches[2]
            $signal = $this.Normalize($this.GetSignal($left) -band $this.GetSignal($right))
        }
        elseif ($operation -match '(.+) OR (.+)') {
            $left = $matches[1]
            $right = $matches[2]
            $signal = $this.Normalize($this.GetSignal($left) -bor $this.GetSignal($right))
        }
        elseif ($operation -match '(.+) LSHIFT (\d+)') {
            $input = $matches[1]
            $shift = [int]$matches[2]
            $signal = $this.Normalize($this.GetSignal($input) -shl $shift)
        }
        elseif ($operation -match '(.+) RSHIFT (\d+)') {
            $input = $matches[1]
            $shift = [int]$matches[2]
            $signal = $this.Normalize($this.GetSignal($input) -shr $shift)
        }
        else {
            # Direct wire connection
            $signal = $this.GetSignal($operation)
        }

        # Cache the result
        $this.cache[$wire] = $signal
        return $signal
    }
}

# Create new circuit
$circuit = [Circuit]::new()

# Read input from file
Get-Content 'input.txt' | ForEach-Object {
    if ($_ -match '\S') {  # Skip empty lines
        $circuit.AddInstruction($_)
    }
}

# Part 1: Get initial signal on wire 'a'
$part1Signal = $circuit.GetSignal('a')
Write-Host "Part 1 - Signal on wire 'a': $part1Signal"

# Part 2: Override wire 'b' with part 1 signal and reset all wires
$circuit.Reset()
$circuit.OverrideWire('b', $part1Signal)

# Get new signal on wire 'a'
$part2Signal = $circuit.GetSignal('a')
Write-Host "Part 2 - Signal on wire 'a': $part2Signal"
