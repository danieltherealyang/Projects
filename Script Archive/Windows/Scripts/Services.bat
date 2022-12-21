@TITLE M360_SERVICESSTART/STOP Script
@ECHO OFF

ECHO THIS SCRIPT IS THE PROPERTY OF M360

ECHO --------------------------------------------------
ECHO M360_SERVICESSTART/STOP Script
ECHO This script must be run as Administrator (SYSTEM32).
ECHO Please ensure that the script is running as SYSTEM32.
PAUSE
ECHO --------------------------------------------------
ECHO The script will attempt to disable and enable certain services.
ECHO Please check the status of the services after this script has run.
ECHO --------------------------------------------------

sc config "AxInstSV" start= demand
sc config "AeLookupSvc" start= demand
sc config "AppIDSvc" start= demand
sc config "Appinfo" start= demand
sc config "ALG" start= demand
sc config "AppMgmt" start= demand
sc config "BITS" start= demand
sc config "BrokerInfrastructure" start= demand
sc config "BFE" start= auto
sc config "BDESVC" start= auto
sc config "wbengine" start= demand
sc config "bthserv" start= disabled
sc config "PeerDistSvc" start= demand
sc config "CertPropSvc" start= disabled
sc config "KeyIso" start= demand
sc config "EventSystem" start= auto
sc config "COMSysApp" start= demand
sc config "Browser" start= demand
sc config "VaultSvc" start= demand
sc config "CryptSvc" start= auto
sc config "Dhcp" start= auto
sc config "DPS" start= auto
sc config "WdiServiceHost" start= demand
sc config "WdiSystemHost" start= demand
sc config "TrkWks" start= demand
sc config "MSDTC" start= demand
sc config "Dnscache" start= auto
sc config "EFS" start= auto
sc config "EapHost" start= demand
sc config "WPCSvc" start= disabled
sc config "Fax" start= disabled
sc config "fhsvc" start= disabled
sc config "DcomLaunch" start= disabled
sc config "fdPHost" start= demand
sc config "FDResPub" start= demand
sc config "gupdate" start= auto
sc config "gupdatem" start= auto
sc config "gpsvc" start= auto
sc config "hkmsvc" start= demand
sc config "HomeGroupListener" start= disabled
sc config "HomeGroupProvider" start= demand
sc config "hidserv" start= demand
sc config "vmicrdv" start= disabled
sc config "vmicshutdown" start= auto
sc config "vmicguestinterface" start= disabled
sc config "vmickvpexchange" start= demand
sc config "vmicheartbeat" start= demand
sc config "IKEEXT" start= demand
sc config "UI0Detect" start= demand
sc config "SharedAccess" start= disabled
sc config "PolicyAgent" start= demand
sc config "KtmRm" start= demand
sc config "lltdsvc" start= demand
sc config "wlidsvc" start= disabled
sc config "FTPSVC" start= disabled
sc config "MSiSCSI" start= disabled
sc config "swprv" start= demand
sc config "smphost" start= disabled
sc config "MMCSS" start= auto
sc config "NetTcpPortSharing" start= disabled
sc config "Netlogon" start= disabled
sc config "napagent" start= demand
sc config "NcdAutoSetup" start= demand
sc config "NcbService" start= demand
sc config "Netman" start= demand
sc config "NcaSvc" start= demand
sc config "netprofm" start= demand
sc config "NlaSvc" start= auto
sc config "nsi" start= auto
sc config "CscService" start= disabled
sc config "defragsvc" start= auto
sc config "PNRPsvc" start= demand
sc config "p2psvc" start= demand
sc config "p2pimsvc" start= demand
sc config "pla" start= demand
sc config "PlugPlay" start= disabled
sc config "PNRPAutoReg" start= demand
sc config "WPDBusEnum" start= demand
sc config "Power" start= auto
sc config "Spooler" start= disabled
sc config "PrintNotify" start= disabled
sc config "wercplsupport" start= demand
sc config "PcaSvc" start= demand
sc config "QWAVE" start= disabled
sc config "RpcSs" start= disabled
sc config "RpcLocator" start= disabled
sc config "RemoteRegistry" start= disabled
sc config "RemoteAccess" start= disabled
sc config "RpcEptMapper" start= disabled
sc config "seclogon" start= disabled
sc config "SstpSvc" start= demand
sc config "SamSs" start= auto
sc config "wscsvc" start= auto
sc config "SensrSvc" start= disabled
sc config "LanmanServer" start= auto
sc config "ShellHWDetection" start= auto
sc config "simptcp" start= disabled
sc config "SCardSvr" start= disabled
sc config "ScDeviceEnum" start= disabled
sc config "SCPolicySvc" start= disabled
sc config "SNMP" start= disabled
sc config "SNMPTRAP" start= disabled
sc config "sppsvc" start= auto
sc config "SSDPSRV" start= demand
sc config "StorSvc" start= demand
sc config "SysMain" start= auto
sc config "SENS" start= auto
sc config "Schedule" start= auto
sc config "lmhosts" start= auto
sc config "TapiSrv" start= disabled
sc config "TlntSvr" start= disabled
sc config "Themes" start= auto
sc config "THREADORDER" start= demand
sc config "TPAutoConnSvc" start= demand
sc config "TPVCGateway" start= demand
sc config "upnphost" start= demand
sc config "ProfSvc" start= auto
sc config "vds" start= demand
sc config "WebClient" start= disabled
sc config "Audiosrv" start= auto
sc config "AudioEndpointBuilder" start= auto
sc config "WbioSrvc" start= disabled
sc config "WcsPlugInService" start= demand
sc config "wcncsvc" start= disabled
sc config "Wcmsvc" start= disabled
sc config "WdNisSvc" start= auto
sc config "WinDefend" start= auto
sc config "wudfsvc" start= auto
sc config "WEPHOSTSVC" start= auto
sc config "WerSvc" start= auto
sc config "Wecsvc" start= demand
sc config "EventLog" start= auto
sc config "MpsSvc" start= auto
sc config "FontCache" start= auto
sc config "StiSvc" start= demand
sc config "msiserver" start= demand
sc config "lfsvc" start= disabled
sc config "winmgmt" start= auto
sc config "WMPNetworkSvc" start= disabled
sc config "TrustedInstaller" start= demand
sc config "WinRM" start= disabled
sc config "WSearch" start= auto
sc config "WSService" start= disabled
sc config "wuauserv" start= auto
sc config "WinHttpAutoProxySvc" start= demand
sc config "dot3svc" start= demand
sc config "wmiApSrv" start= demand
sc config "workfolderssvc" start= disabled
sc config "LanmanWorkstation" start= auto
sc config "W3SVC" start= disabled
sc config "WwanSvc" start= demand

ECHO --------------------------------------------------
ECHO The script has finished executing. Please check for any possible errors now.
PAUSE