# metormWindowsToolkit
My windows script toolkit

## vtt2ass
Usually youtube.com provides subtitle in \*.vtt format. Some of these \*.vtt subtitles contain extra timeline or format information. Therefore these subtitles cannot be handled correct by players such as Pot player or KMP. The following is an example among these subtitles:

>00:00:02.960 --> 00:00:04.080 align:start position:0%

><c.colorCCCCCC>what's</c><00:00:03.159><c> going</c><c.colorCCCCCC><00:00:03.250><c> on</c></c><c.colorE5E5E5><00:00:03.570><c> very</c></c><00:00:03.730><c> welcome</c><00:00:04.080><c> to</c>

>00:00:04.080 --> 00:00:04.240 align:start position:0%

><c.colorCCCCCC>what's</c> going<c.colorCCCCCC> on</c><c.colorE5E5E5> very</c> welcome to

ffmpeg can convert this to \*.ass or \*.srt correctly. This vtt2ass.ps1 powershell script run ```ffmpeg -i xxx.vtt xxx.ass``` on all \*.vtt files under current directory, and convert them to \*.ass subtitle. By simply editing the first two lines of the script, other formats all also supported.