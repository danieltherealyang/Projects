@ECHO off

ECHO Remember to put all the usernames in users.txt
PAUSE

ECHO Okay let's change the passwords

set /p newpass="Enter new password: "

for /F %%G in (%~dp0\users.txt) do (
	net user %%G %newpass%
)
ECHO Changed users' passwords to %newpass%

ECHO ------------------------------------------------------------

ECHO Now to enable all the users
PAUSE

@ECHO off

for /F %%G in (%~dp0\users.txt) do (
	net user %%G /active:yes
)
ECHO Done.
PAUSE

