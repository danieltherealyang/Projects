@echo off

set /p newpass="Enter new password: "

for /F %%G in (%~dp0\users.txt) do (
	net user %%G %newpass%
pause
)
echo Done
pause