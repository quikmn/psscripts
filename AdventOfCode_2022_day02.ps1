$input = get-content -path .\input.txt

$mypointsarray  = [System.Collections.ArrayList]@()
$mypointsarray2 = [System.Collections.ArrayList]@()

# converts my move from XYZ to ABC
function ConvertMyMove {
    param (
        [Parameter(Mandatory=$true)]
        [string]$param1
    )
    switch ($param1) {
        "X" {return "A"} # Rock
        "Y" {return "B"} # Paper
        "Z" {return "C"} # Scissors
    }
}

# takes $Op, oponents selection as input and...
function FindWinningMove {
    param (
        [Parameter(Mandatory=$true)]
        [string]$param1
    )
    $winningmove = @{
        A = "B" # rock - winning move is     B - paper
        B = "C" # paper - winning move is    C - scissors
        C = "A" # scissors - winning move is A - rock
    }
    $output = $winningmove[$param1]
    return $output
}
# FindWinningMove -param1 $op

# takes $Op, oponents selection as input and..
function FindLosingMove {
    param (
        [Parameter(Mandatory=$true)]
        [string]$param1
    )
    $losingmove = @{
        A = "C" # rock     - losing move is C - scissors
        B = "A" # paper    - losing move is A - rock
        C = "B" # scissors - losing move is B - paper
    }
    $output = $losingmove[$param1]
    return $output
}
# FindLosingMove -param1 $op

# takes $me, my selection as input and input from gamestate function and...
function FindMyScore {
    param (
        [Parameter(Mandatory=$true)]
        [string]$param1,
        [Parameter(Mandatory=$true)]
        [string]$param2
    )
    $fms = @{
        A = "1" # rock     - 1p
        B = "2" # paper    - 2p
        C = "3" # scissors - 3p
    }
    $tgs = @{
        W = '6'
        D = '3'
        L = '0'
    }
    $choiceScore = [int]$fms[$param1]
    $gameStateScore = [int]$tgs[$param2]

    $output = $choiceScore + $gameStateScore
    return $output
}
# $result = FindGameState -param1 $op -param2 $me
# FindMyScore -param1 $me -param2 $result

# takes $op and $me, selection as input and...
function FindGameState {
    param (
        [Parameter(Mandatory=$true)]
        [string]$param1,
        [Parameter(Mandatory=$true)]
        [string]$param2
    )
    $fgs = @{
    "B-A" = "L"    # Op Paper,    me rock     - Loss
    "C-A" = "W"    # Op Scissors, me Rock     - Win
    "A-B" = "W"    # Op Rock,     me Paper    - Win
    "C-B" = "L"    # Op Scissors, me Paper    - Loss
    "A-C" = "L"    # Op Rock,     me Scissors - Loss
    "B-C" = "W"    # Op Paper,    me Scissors - Win
    "A-A" = "D"    # Both A                   - Draw
    "B-B" = "D"    # Both B                   - Draw
    "C-C" = "D"    # Both C                   - Draw
}
    $key = "$param1-$param2"
    $output = $fgs[$key]
    return $output
}
# FindGameState -param1 $op -param2 $me

foreach ($line in $input) {
    $op     = $line.substring(0,1)
    $meraw  = $line.Substring(2,1)
    $me     = ConvertMyMove -param1 $meraw

    $result = FindGameState -param1 $op -param2 $me
    $mypoints = FindMyScore -param1 $me -param2 $result
    $null = $mypointsarray.add($mypoints)
}

# part 1 answer
$sum = ($mypointsarray | Measure-Object -Sum).Sum
$sum

# find answer to part 2
foreach ($line in $input) {
    $op         = $line.substring(0,1)
    $myinstrux  = $line.Substring(2,1)

    switch ($myinstrux) {
        "X" {
                # instrux lose
                $mymove = FindLosingMove -param1 $op
                $result = FindGameState -param1 $op -param2 $mymove
                $mypoints = FindMyScore -param1 $mymove -param2 $result
                $null = $mypointsarray2.add($mypoints)
            } 
        "Y" {
                # instrux draw
                $mymove = $op
                $result = FindGameState -param1 $op -param2 $mymove
                $mypoints = FindMyScore -param1 $mymove -param2 $result
                $null = $mypointsarray2.add($mypoints)
            }
        "Z" {
                # instrux win
                $mymove = FindWinningMove -param1 $op
                $result = FindGameState -param1 $op -param2 $mymove
                $mypoints = FindMyScore -param1 $mymove -param2 $result
                $null = $mypointsarray2.add($mypoints)
            }
    }
}

# part 2 answer
$sum2 = ($mypointsarray2 | Measure-Object -Sum).Sum
$sum2
