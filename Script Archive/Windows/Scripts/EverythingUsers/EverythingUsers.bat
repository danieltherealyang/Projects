@TITLE Users
@ECHO off

ECHO Remember to put all the usernames in HyperionUsers.txt !! 
ECHO It won't work otherwise :O
PAUSE

ECHO ------------------------------------------------------------
ECHO Okay let's change the passwords \(^_^)/

set /p newpass="Enter new password: "

for /F %%G in (%~dp0\HyperionUsers.txt) do (
	net user %%G %newpass%
)
ECHO Changed users' passwords to %newpass%
PAUSE

ECHO ------------------------------------------------------------
ECHO Now to disabled all authorized users /(0_0)/
PAUSE

@ECHO off

for /F %%G in (%~dp0\HyperionUsers.txt) do (
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

for /F %%G in (%~dp0\HyperionUsers.txt) do (
	net user %%G /active:yes
)


ECHO --------------------------------------------------
ECHO Disabling Guest + Administrator accounts :3
PAUSE

net user Guest /active:no
net user Administrator /active:no


ECHO --------------------------------------------------
ECHO Turn on 'Change passwd next login' /(0_0)/
PAUSE

@ECHO off

for /F %%G in (%~dp0\HyperionUsers.txt) do (
	net user %%G /logonpasswordchg:yes
)
ECHO --------------------------------------------------
ECHO Require users to have password
PAUSE

@ECHO off

for /F %%G in (%~dp0\HyperionUsers.txt) do (
	net user %%G /passwordreq:yes
)
ECHO --------------------------------------------------

ECHO Done. !!
PAUSE

