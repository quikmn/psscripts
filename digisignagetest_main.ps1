$mappedshare = "Q:\bilder" #Mapped shared folder in which you place your mediafiles
$locmediafoldr = "C:\SimplePSSignage\localmedia" #local folder on digital signage device with images to display

#check if localmedia folder is empty, and if empty, copy media from the mapped network share to the localmedia folder on media/player computer
$directoryInfo = Get-ChildItem "$locmediafoldr" | Measure-Object
$directoryInfo.count

If ($directoryInfo.count -eq 0) {
	
		robocopy "$mappedshare" "$locmediafoldr" /MIR /MT /XF *.m3u
}

$mappedshare_2 = Get-ChildItem -Recurse -path Q:\bilder
$locmediafoldr_2 = Get-ChildItem -Recurse -path C:\SimplePSSignage\localmedia

$Diff = Compare-Object -ReferenceObject $mappedshare_2 -DifferenceObject $locmediafoldr_2

if ($Diff -notlike  $Null) {

		$ContentInlocmediafoldrChanged = $True
}

#om $ContentInlocmediafoldrChanged = 'true' then there was a change in the locmediafoldr och
#then vlc.exe gets closed; playlist.m3u is removed, playlist.m3u is created again with new content and vlc.exe is started with new playlist.m3u

$PlaylistExistsQuestion = Get-ChildItem $locmediafoldr -recurse | where-object {$_.Extension -like '*m3u'}
$PlaylistExistsAnswer = $PlaylistExistsQuestion | select-object -property Name | ft -HideTableHeaders
$PlaylistExists = ($PlaylistExistsAnswer | out-string).trim()

if ($PlaylistExists -notlike 'playlist.m3u' -or $ContentInlocmediafoldrChanged -eq $True) {
		
		$VLCPID = (get-Process | where { $_.Name -eq "vlc" } | select -property Id | ft -HideTableHeaders | out-string).trim()
		Stop-Process -ID $VLCPID -Force -ErrorAction SilentlyContinue
		
		Remove-Item $locmediafoldr\playlist.m3u -ErrorAction Ignore | out-null
			
		start-process -wait robocopy.exe -argumentlist "$mappedshare $locmediafoldr /MIR /MT /XF *.m3u"
					
		(get-childitem $locmediafoldr -recurse | where-object {$_.Extension -notlike '*m3u'}) | foreach-object {echo "#EXTINF:20,$_" >> $locmediafoldr\playlist.m3u; echo "$_" >> $locmediafoldr\playlist.m3u}
			
		start-process -filepath "C:\Program Files\VideoLAN\VLC\vlc.exe" -argumentlist "--fullscreen --loop C:\SimplePSSignage\localmedia\playlist.m3u"
} else {
	#do nothing
}
