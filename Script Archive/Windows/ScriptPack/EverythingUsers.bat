@TITLE Users
@ECHO off

ECHO Remember to put all the usernames in HyperionUsers.txt !! 
ECHO It won't work otherwise :O
PAUSE

@TITLE Users: Passwors
ECHO ------------------------------------------------------------
ECHO Okay let's change the passwords \(^_^)/

set /p newpass="Enter new password: "

for /F %%G in (%~dp0\EverythingUsers\HyperionUsers.txt) do (
	net user %%G %newpass%
)
ECHO Changed users' passwords to %newpass%
PAUSE

@TITLE Users: Accounts
ECHO ------------------------------------------------------------
ECHO Making users group whole and happy.
ECHO Make sure all users, even those mentioned later in ReadMe are in Hyperionusers.txt
PAUSE

@ECHO off

for /F %%G in (%~dp0\EverythingUsers\HyperionUsers.txt) do (
	net user %%G CyberPatriot1! /ADD 
)

ECHO ------------------------------------------------------------

ECHO Now to disable all authorized users /(0_0)/

@ECHO off

for /F %%G in (%~dp0\EverythingUsers\HyperionUsers.txt) do (
	net user %%G /active:yes
)

PAUSE

@ECHO off

for /F %%G in (%~dp0\EverythingUsers\HyperionUsers.txt) do (
	net user %%G /active:no
)

ECHO ------------------------------------------------------------
ECHO NOW GO MANUALLY DELETE UNAUTHORIZED USERS :D
PAUSE
ECHO DID YOU DO IT? :O
PAUSE
ECHO ARE YOU SURE?  D:
PAUSE 
ECHO ok. O.o

ECHO ------------------------------------------------------------
ECHO Now to enable all the users
PAUSE

@ECHO off

for /F %%G in (%~dp0\EverythingUsers\HyperionUsers.txt) do (
	net user %%G /active:yes
)


ECHO --------------------------------------------------
ECHO Disabling Guest + Administrator accounts :3
PAUSE

net user Guest /active:no
net user Administrator /active:no

@TITLE Users: Checkbox Stuff
ECHO --------------------------------------------------
ECHO Turn on 'Change passwd next login' /(0_0)/
PAUSE

@ECHO off

for /F %%G in (%~dp0\EverythingUsers\HyperionUsers.txt) do (
	net user %%G /logonpasswordchg:yes
)
ECHO --------------------------------------------------
ECHO Require users to have password
PAUSE

@ECHO off

for /F %%G in (%~dp0\EverythingUsers\HyperionUsers.txt) do (
	net user %%G /passwordreq:yes
)

ECHO --------------------------------------------------
ECHO Users' passwords never expire
PAUSE

for /F %%G in (%~dp0\EverythingUsers\HyperionUsers.txt) do (
WMIC USERACCOUNT WHERE Name='%%G' SET PasswordExpires=TRUE
)

@TITLE Users: Groups
ECHO ------------------------------------------------------------
ECHO Making the Admin group happy
PAUSE

ECHO Deleting all users
for /F %%G in (%~dp0\EverythingUsers\HyperionUsers.txt) do (
	net localgroup administrators %%G /delete
)

ECHO Adding good ones back
for /F %%G in (%~dp0\EverythingUsers\HyperionAdmins.txt) do (
	net localgroup Administrators %%G /add
)

@TITLE Users: Final touches
ECHO --------------------------------------------------
ECHO Add Users Manually

set choice=
set /p choice=Type 1 to complete adding users. Type 0 to add another user: 
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='0' goto start
if '%choice%'=='1' goto next

:start
set /p newuser="Enter new user: "
net user %newuser% Pa$$w0rd /add

ECHO %newuser% >> %~dp0\EverythingUsers\Hyperion_Users.txt

:next

ECHO Done. !!
PAUSE

