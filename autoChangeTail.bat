cd /d %~dp0
powershell -command ^
	"Set-Executionpolicy remotesigned -s process -f;"^
	"./autoChangeTail.ps1"
