@TITLE YES RDP
@ECHO OFF

ECHO To be run if RDP is needed
PAUSE

ECHO -------------------------------------------------
ECHO Now for disabling RDP from the control panel \(+_+)\ /(+_+)/ \(+_+)\ 
PAUSE 

REM the rdp thing
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f

REM the remote assistance thing
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f


ECHO -------------------------------------------------
ECHO Now for stopping rdp services \(+_+)\ /(+_+)/ \(+_+)\ 
PAUSE

sc stop RasAuto
sc config "RasAuto" start= auto

sc start RasMan
sc config "RasMan" start= auto

sc start SessionEnv
sc config "SessionEnv" start= auto

sc start TermService
sc config "TermService" start= auto

sc start UmRdpService
sc config "UmRdpService" start= auto

sc start RpcLocator
sc config "RpcLocator" start= auto

sc start WinRM
sc config "WinRM" start= auto

ECHO -------------------------------------------------
ECHO Removing all users from rdp groups
PAUSE

for /F %%G in (%~dp0\EverythingUsers\HyperionUsers.txt) do (
	net localgroup "Remote Desktop Users" %%G /delete


for /F %%G in (%~dp0\EverythingUsers\HyperionRDPUsers.txt) do (
	net localgroup "Remote Management Users" %%G /delete
)
)
ECHO -------------------------------------------------
ECHO Adding users to rdp groups
PAUSE

for /F %%G in (%~dp0\EverythingUsers\HyperionAdmins.txt) do (
	net localgroup "Remote Desktop Users" %%G /add
)

for /F %%G in (%~dp0\EverythingUsers\HyperionRDPUsers.txt) do (
	net localgroup "Remote Management Users" %%G /add
)
ECHO -------------------------------------------------
ECHO You have gotten rid of rdp congrats
PAUSE