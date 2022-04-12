@echo off

set /p newpass="Enter new password: "

for /F %%G in (%~dp0\m@@tU$eR$.txt) do (
	net user %%G %newpass%
pause
)
echo Done
pause