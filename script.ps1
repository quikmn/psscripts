# fishing for any .msi versions, uninstalls if find any.
$array0 = $Null

$theappname = @(
  "*Microsoft*"
  "*Power*"
  "*BI*"
  "*Desktop*"
)

$paths=@(
  'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\',
  'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'
)
foreach($path in $paths){
  Get-ChildItem -Path $path |
    Get-ItemProperty | where {$_.displayname -like $theappname} |
      Select DisplayName, pschildname | foreach-object {$array0 += $_.pschildname}
}

if ($array0 -ne $Null) {

$arglist0 = @(
  "/uninstall"
  "placeholder"
  "/qn"
  "/norestart"
)

foreach ($i in $array0) {
  $arglist0[2] = $i
  $arglist0}
    start-process -wait -nonewwindow -filepath msiexec.exe -argumentlist $argslist0
  }
}

# finds any versions (.exe-based installs) and uninstalls them
$UninstPath = "12monkeys"
$UninstPath = Get-ChildItem -Path "C:\ProgramData\Package Cache\*" -Include "PBIDesktopSetup*.exe" -Recurse -ErrorAction SilentlyContinue

$array1 = @()
$UninstPath | foreach-object {$array1 += $_.fullname}

If ($UninstPath -ne "12monkeys") {
      foreach ($entry in $array1) {
          start-process -wait -FilePath "$entry" -ArgumentList "/uninstall /quiet /norestart" -WindowStyle Hidden
        }
}

# actual installation begins here
$argumentlist1 = @(
  "-quiet"
  "-norestart"
  '-log "c:\windows\Temp\PowerBI-Install_v2.104.702.0.log"'
  "ACCEPT_EULA=1"
  "ENABLECXP=0"
  "DISABLE_UPDATE_NOTIFICATION=1"
)

start-sleep 30
start-process -wait -NoNewWindow -FilePath ".\PBIDesktopSetup_x64.exe" -Argumentlist $argumentlist1
