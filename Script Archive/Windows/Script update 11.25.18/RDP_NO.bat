@TITLE NO RDP
@ECHO OFF

ECHO To be run if RDP is not allowed
PAUSE

ECHO -------------------------------------------------
ECHO Now for disabling RDP from the control panel \(+_+)\ /(+_+)/ \(+_+)\ 
PAUSE 

REM the rdp thing
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f

REM the remote assistance thing
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f


ECHO -------------------------------------------------
ECHO Now for stopping rdp services \(+_+)\ /(+_+)/ \(+_+)\ 
PAUSE

sc stop RasAuto
sc config "RasAuto" start= disabled

sc stop RasMan
sc config "RasMan" start= disabled

sc stop SessionEnv
sc config "SessionEnv" start= disabled

sc stop TermService
sc config "TermService" start= disabled

sc stop UmRdpService
sc config "UmRdpService" start= disabled

sc stop RpcLocator
sc config "RpcLocator" start= disabled

sc stop WinRM
sc config "WinRM" start= disabled

ECHO -------------------------------------------------
ECHO You have gotten rid of rdp congrats
PAUSE