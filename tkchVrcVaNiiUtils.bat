cd /d %~dp0
powershell -command ^
	"Set-Executionpolicy remotesigned -s process -f;"^
	"./autoChangeTail.ps1 "^
	" -path (Join-Path $Home AppData/LocalLow/VRChat/vrchat -Resolve) "^
	" -filter output_log_*.txt"|^
powershell -command ^
	"Set-Executionpolicy remotesigned -s process -f;"^
	"./lineFilter.ps1 -quiet"|^
powershell -command ^
	"Set-Executionpolicy remotesigned -s process -f;"^
	"./oscLineSender.ps1"
