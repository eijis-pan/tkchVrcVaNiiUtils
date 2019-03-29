cd /d %~dp0
powershell -command "Set-Executionpolicy remotesigned -s process -f;.\oscLineSender.ps1"
