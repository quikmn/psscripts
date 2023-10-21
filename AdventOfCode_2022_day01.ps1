# Advent Of Code 2022 Day 01
$Input = get-content -path .\input.txt

$ArrList = [System.Collections.ArrayList]@()
$List = @()
$Results = @()

foreach ($Line in $Input) {
    if (!($Line -eq "")) {
        $List += $Line
    }
     else {
        $null = $ArrList.add($List)
        $List = @()
    }
}

foreach ($Item in $ArrList) {
    $Asd = ""
    $Item | foreach-object{
        $Asd = $Asd + "$_ + "
        $Trimmed = $asd -replace ".{2}$"
        $Result = Invoke-Expression $Trimmed
        $Results += $Result
    }
}

$Results | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
