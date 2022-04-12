@TITLE M360_KeepRDP_FirewallAndBadSrvc Script
@ECHO OFF

ECHO THIS SCRIPT IS THE PROPERTY OF M360

ECHO --------------------------------------------------
ECHO M360_KeepRDP_FirewallAndBadSrvc Script
ECHO This script must be run as Administrator (SYSTEM32).
ECHO Please ensure that the script is running as SYSTEM32.
PAUSE
ECHO --------------------------------------------------
ECHO The script will attempt to block the following ports for both protocols (TCP/UDP) and for both INBOUND and OUTBOUND connections:
ECHO 20, 21, 22, 23, 24, 25, 135, 389, 411, 412
ECHO This script will also [attempt to] disable: Telnet, Microsoft FTP, Telephony, Remote Access, Remote Procedure Call (RPC), RIP Listener, SNMP, and some related services.
ECHO --------------------------------------------------

:: Port 20 ::
ECHO Attempting to block port 20 (TCP/UDP ; IN/OUT)...
netsh advfirewall firewall add rule name="Block 20 TCP IN" protocol=TCP dir=IN localport=20 action=BLOCK
netsh advfirewall firewall add rule name="Block 20 UDP IN" protocol=UDP dir=IN localport=20 action=BLOCK
netsh advfirewall firewall add rule name="Block 20 TCP OUT" protocol=TCP dir=OUT localport=20 action=BLOCK
netsh advfirewall firewall add rule name="Block 20 UDP OUT" protocol=UDP dir=OUT localport=20 action=BLOCK
ECHO Finished attempt at blocking 20 (TCP/UDP ; IN/OUT).

:: Port 21 ::
ECHO Attempting to block port 21 (TCP/UDP ; IN/OUT)...
netsh advfirewall firewall add rule name="Block 21 TCP IN" protocol=TCP dir=IN localport=21 action=BLOCK
netsh advfirewall firewall add rule name="Block 21 UDP IN" protocol=UDP dir=IN localport=21 action=BLOCK
netsh advfirewall firewall add rule name="Block 21 TCP OUT" protocol=TCP dir=OUT localport=21 action=BLOCK
netsh advfirewall firewall add rule name="Block 21 UDP OUT" protocol=UDP dir=OUT localport=21 action=BLOCK
ECHO Finished attempt at blocking 21 (TCP/UDP ; IN/OUT).

:: Port 22 ::
ECHO Attempting to block port 22 (TCP/UDP ; IN/OUT)...
netsh advfirewall firewall add rule name="Block 22 TCP IN" protocol=TCP dir=IN localport=22 action=BLOCK
netsh advfirewall firewall add rule name="Block 22 UDP IN" protocol=UDP dir=IN localport=22 action=BLOCK
netsh advfirewall firewall add rule name="Block 22 TCP OUT" protocol=TCP dir=OUT localport=22 action=BLOCK
netsh advfirewall firewall add rule name="Block 22 UDP OUT" protocol=UDP dir=OUT localport=22 action=BLOCK
ECHO Finished attempt at blocking 22 (TCP/UDP ; IN/OUT).

:: Port 23 ::
ECHO Attempting to block port 23 (TCP/UDP ; IN/OUT)...
netsh advfirewall firewall add rule name="Block 23 TCP IN" protocol=TCP dir=IN localport=23 action=BLOCK
netsh advfirewall firewall add rule name="Block 23 UDP IN" protocol=UDP dir=IN localport=23 action=BLOCK
netsh advfirewall firewall add rule name="Block 23 TCP OUT" protocol=TCP dir=OUT localport=23 action=BLOCK
netsh advfirewall firewall add rule name="Block 23 UDP OUT" protocol=UDP dir=OUT localport=23 action=BLOCK
ECHO Finished attempt at blocking 23 (TCP/UDP ; IN/OUT).

:: Port 24 ::
ECHO Attempting to block port 24 (TCP/UDP ; IN/OUT)...
netsh advfirewall firewall add rule name="Block 24 TCP IN" protocol=TCP dir=IN localport=24 action=BLOCK
netsh advfirewall firewall add rule name="Block 24 UDP IN" protocol=UDP dir=IN localport=24 action=BLOCK
netsh advfirewall firewall add rule name="Block 24 TCP OUT" protocol=TCP dir=OUT localport=24 action=BLOCK
netsh advfirewall firewall add rule name="Block 24 UDP OUT" protocol=UDP dir=OUT localport=24 action=BLOCK
ECHO Finished attempt at blocking 24 (TCP/UDP ; IN/OUT).

:: Port 25 ::
ECHO Attempting to block port 25 (TCP/UDP ; IN/OUT)...
netsh advfirewall firewall add rule name="Block 25 TCP IN" protocol=TCP dir=IN localport=25 action=BLOCK
netsh advfirewall firewall add rule name="Block 25 UDP IN" protocol=UDP dir=IN localport=25 action=BLOCK
netsh advfirewall firewall add rule name="Block 25 TCP OUT" protocol=TCP dir=OUT localport=25 action=BLOCK
netsh advfirewall firewall add rule name="Block 25 UDP OUT" protocol=UDP dir=OUT localport=25 action=BLOCK
ECHO Finished attempt at blocking 25 (TCP/UDP ; IN/OUT).

:: Port 135 ::
ECHO Attempting to block port 135 (TCP/UDP ; IN/OUT)...
netsh advfirewall firewall add rule name="Block 135 TCP IN" protocol=TCP dir=IN localport=135 action=BLOCK
netsh advfirewall firewall add rule name="Block 135 UDP IN" protocol=UDP dir=IN localport=135 action=BLOCK
netsh advfirewall firewall add rule name="Block 135 TCP OUT" protocol=TCP dir=OUT localport=135 action=BLOCK
netsh advfirewall firewall add rule name="Block 135 UDP OUT" protocol=UDP dir=OUT localport=135 action=BLOCK
ECHO Finished attempt at blocking 135 (TCP/UDP ; IN/OUT).

:: Port 389 ::
ECHO Attempting to block port 389 (TCP/UDP ; IN/OUT)...
netsh advfirewall firewall add rule name="Block 389 TCP IN" protocol=TCP dir=IN localport=389 action=BLOCK
netsh advfirewall firewall add rule name="Block 389 UDP IN" protocol=UDP dir=IN localport=389 action=BLOCK
netsh advfirewall firewall add rule name="Block 389 TCP OUT" protocol=TCP dir=OUT localport=389 action=BLOCK
netsh advfirewall firewall add rule name="Block 389 UDP OUT" protocol=UDP dir=OUT localport=389 action=BLOCK
ECHO Finished attempt at blocking 389 (TCP/UDP ; IN/OUT).

:: Port 411 ::
ECHO Attempting to block port 411 (TCP/UDP ; IN/OUT)...
netsh advfirewall firewall add rule name="Block 411 TCP IN" protocol=TCP dir=IN localport=411 action=BLOCK
netsh advfirewall firewall add rule name="Block 411 UDP IN" protocol=UDP dir=IN localport=411 action=BLOCK
netsh advfirewall firewall add rule name="Block 411 TCP OUT" protocol=TCP dir=OUT localport=411 action=BLOCK
netsh advfirewall firewall add rule name="Block 411 UDP OUT" protocol=UDP dir=OUT localport=411 action=BLOCK
ECHO Finished attempt at blocking 411 (TCP/UDP ; IN/OUT).

:: Port 412 ::
ECHO Attempting to block port 412 (TCP/UDP ; IN/OUT)...
netsh advfirewall firewall add rule name="Block 412 TCP IN" protocol=TCP dir=IN localport=412 action=BLOCK
netsh advfirewall firewall add rule name="Block 412 UDP IN" protocol=UDP dir=IN localport=412 action=BLOCK
netsh advfirewall firewall add rule name="Block 412 TCP OUT" protocol=TCP dir=OUT localport=412 action=BLOCK
netsh advfirewall firewall add rule name="Block 412 UDP OUT" protocol=UDP dir=OUT localport=412 action=BLOCK
ECHO Finished attempt at blocking 412 (TCP/UDP ; IN/OUT).

:: Telnet ::
ECHO Attempting to disable Telnet...
sc stop "TLNTSVR"
sc config "TLNTSRV" start= disabled
ECHO Finished attempt at disabling Telnet.

:: Microsoft File Transfer Protocol Service (FTP) ::
ECHO Attempting to disable Microsoft File Transfer Protocol Service (FTP)...
sc stop "MSFTPSVC"
sc config "MSFTPSVC" start= disabled
ECHO Finished attempt at disabling Microsoft File Transfer Protocol Service (FTP).

:: Telephony ::
ECHO Attempting to disable Telephony...
sc stop "TAPISRV"
sc config "TAPISRV" start= disabled
ECHO Finished attempt at disabling Telephony

:: RIP Listener ::
ECHO Attempting to disable RIP Listener...
sc stop "IPRIP"
sc config "IPRIP" start= disabled
ECHO Finished attempt at disabling RIP Listener

:: Remote Access Auto Connection Manager ::
ECHO Attempting to disable Remote Access Auto Connection Manager...
sc stop "RASAUTO"
sc config "RASAUTO" start= disabled
ECHO Finished attempt at disabling Remote Access Auto Connection Manager

:: Remote Access Connection Manager ::
ECHO Attempting to disable Remote Access Connection Manager...
sc stop "RASMAN"
sc config "RASMAN" start= disabled
ECHO Finished attempt at disabling Remote Access Connection Manager

:: Remote Procedure Call (RPC) ::
ECHO Attempting to disable Remote Procedure Call (RPC)...
sc stop "RPCSS"
sc config "RPCSS" start= disabled
ECHO Finished attempt at disabling Remote Procedure Call (RPC)

:: Remote Procedure Call Locator ::
ECHO Attempting to disable Remote Procedure Call Locator...
sc stop "RPCLOCATOR"
sc config "RPCLOCATOR" start= disabled
ECHO Finished attempt at disabling Remote Procedure Call Locator

:: SNMP Trap ::
ECHO Attempting to disable SNMP Trap...
sc stop "SNMPTRAP"
sc config "SNMPTRAP" start= disabled
ECHO Finished attempt at disabling SNMP Trap

:: SSDP Discovery ::
ECHO Attempting to disable SSDP Discovery...
sc stop "SSDPSRV"
sc config "SSDPSRV" start= disabled
ECHO Finished attempt at disabling SSDP Discovery

:: Internet Conection Service (ICS) ::
ECHO Attempting to disable Internet Conection Service (ICS)...
sc stop "SHAREDACCESS"
sc config "SHAREDACCESS" start= disabled
ECHO Finished attempt at disabling Internet Conection Service (ICS)

:: UPnP Device Host ::
ECHO Attempting to disable UPnP Device Host...
sc stop "UPNPHOST"
sc config "UPNPHOST" start= disabled
ECHO Finished attempt at disabling UPnP Device Host

ECHO --------------------------------------------------
ECHO The script has finished executing. Please check for any possible errors now.
PAUSE