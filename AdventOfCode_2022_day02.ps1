$input = get-content -path .\input.txt

$mypointsarray = [System.Collections.ArrayList]@()

$gameStates = @{
    "B-A" = "L"    # Op Paper,    me rock       - Loss
    "C-A" = "W"    # Op Scissors, me Rock       - Win
    "A-B" = "W"    # Op Rock,     me Paper      - Win
    "C-B" = "L"    # Op Scissors, me Paper      - Loss
    "A-C" = "L"    # Op Rock,     me Scissors   - Loss
    "B-C" = "W"    # Op Paper,    me Scissors   - Win
    "A-A" = "D"    # Both A                     - Draw
    "B-B" = "D"    # Both B                     - Draw
    "C-C" = "D"    # Both C                     - Draw
}

$RemapPoints = @{
    A = '1'
    B = '2'
    C = '3'
}

$RemapMySel = @{
    X = 'A'
    Y = 'B'
    Z = 'C'
}

foreach ($line in $input) {
    # get first char
    $op = $line.substring(0,1)

    # get third char
    $me = $line.substring(2,1)
    $me = $RemapMySel[$me]

    # find gamestate
    $result = $gameStates["$op-$me"]

    switch ($result) {
    "L" {
            # Loss - Count value of selection + 0p
            $me = $RemapPoints[$me]
            $MyPoints = $([int]$me + 0)
            $null = $mypointsarray.add($MyPoints)
        }
    "W" {
            # Win - Count value of selection + 6p
            $me = $RemapPoints[$me]
            $MyPoints = $([int]$me + 6)
            $null = $mypointsarray.add($MyPoints)
        }
    "D" {
            # Draw - Count value of selection + 3p
            $me = $RemapPoints[$me]
            $MyPoints = $([int]$me + 3)
            $null = $mypointsarray.add($MyPoints)
        }
    }
}

# part 1 answer
$sum = ($mypointsarray | Measure-Object -Sum).Sum
$sum
