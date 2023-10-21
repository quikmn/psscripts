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

$Top3 = $Results | Sort-Object -Descending | Select-Object -First 3

$Str = ""
$Top3 | Foreach-Object {
    $Str = $Str + "$_ + "
    $Tr = $Str -replace ".{2}$"
}
$Res = Invoke-Expression $Tr

# Result Part 1
$Results | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum

# Result Part 2
$Res
