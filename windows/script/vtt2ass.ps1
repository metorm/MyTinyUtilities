$sourceExt='.vtt'
$targetExt='.ass'

$fileList = Get-ChildItem

Foreach($file in $fileList)
{
	if($file.name.EndsWith($sourceExt))
	{
		Write-Host Converting: $file
		$targetFileName =$file.name.Substring(1,$file.name.Length-($sourceExt.Length+1))+$targetExt
		ffmpeg -i $file $targetFileName
		
	}
}