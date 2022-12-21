@TITLE SERVICES_START/STOP Script
@ECHO OFF

ECHO --------------------------------------------------
ECHO This script must be run as Administrator (SYSTEM32).
ECHO Please ensure that the script is running as SYSTEM32.
ECHO --------------------------------------------------

ECHO --------------------------------------------------

ECHO Make sure to run this first. OK?
PAUSE

sc stop AxInstSV
sc stop SensrSvc
sc start AdobeARMservice
sc start AeLookupSvc
sc stop AppIDSvc
sc start Appinfo
sc stop ALG
sc stop AppMgmt
sc start BITS
sc start BFE
sc start BDESVC
sc stop wbengine
sc stop bthserv
sc stop PeerDistSvc
sc stop CertPropSvc
sc stop KeyIso
sc start EventSystem
sc start ComSysApp
sc stop Browser
sc stop VaultSvc
sc start CryptSvc
sc start Dhcp
sc start DPS
sc start WdiServiceHost
sc start WdiSystemHost
sc stop TrkWks
sc start MSDTC
sc start Dnscache
sc start EFS
sc stop EapHost
sc stop WPCSvc
sc stop Fax
sc stop fhsvc
sc stop DcomLaunch
sc stop fdPHost
sc stop FDResPub
sc start gupdate
sc start gupdatem
sc start gpsvc
sc stop hkmsvc
sc stop HomeGroupListener
sc stop HomeGroupProvider
sc stop hidserv
sc stop vmicrdv
sc start vmicshutdown
sc stop vmicguestinterface
sc stop IKEEXT
sc stop UI0Detect
sc stop SharedAccess
sc start iphlpsvc
sc stop PolicyAgent
sc stop KtmRm
sc stop lltdsvc
sc stop wlidsvc
sc stop FTPSVC
sc stop MSiSCSI
sc stop swprv
sc stop smphost
sc start MMCSS
sc stop NetTcpPortSharing
sc stop Netlogon
sc stop napagent
sc stop NcdAutoSetup
sc start Netman
sc start netprofm
sc start NlaSvc
sc start nsi
sc stop CscService
sc start defragsvc
sc stop PNRPsvc
sc stop p2psvc
sc stop p2pimsvc
sc stop pla
sc stop PlugPlay
sc stop PNRPAutoReg
sc start WPDBusEnum
sc start Power
sc stop Spooler
sc stop PrintNotify
sc stop wercplsupport
sc stop PcaSvc
sc stop QWAVE
sc stop RpcSs
sc stop RpcLocator
sc stop RemoteRegistry
sc stop RemoteAccess
sc stop RpcEptMapper
sc stop seclogon
sc stop SstpSvc
sc start SamSs
sc start wscsvc
sc stop SensrSvc
sc start LanmanServer
sc start ShellHWDetection
sc stop simptcp
sc stop SCardSvr
sc stop ScDeviceEnum
sc stop ScPolicySvc
sc stop SNMP
sc stop SNMPTRAP
sc start sppsvc
sc start SSDPSRV
sc stop StorSvc
sc start SysMain
sc start SENS
sc start Schedule
sc start lmhosts
sc stop TapiSrv
sc stop TlntSvr
sc start Themes
sc stop THREADORDER
sc stop TPAutoConnSvc
sc stop TPVCGateway
sc stop upnphost
sc start ProfSvc
sc stop vds
sc stop WebClient
sc start Audiosrv
sc start AudioEndpointBuilder
sc stop WbioSrvc
sc stop WcsPlugInService
sc stop wcncsvc
sc stop Wcmsvc
sc start WdNisSvc
sc start WinDefend
sc start wudfsvc
sc start WEPHOSTSVC
sc start WerSvc
sc start Wecsvc
sc start EventLog
sc start MpsSvc
sc start FontCache
sc stop StiSvc
sc stop msiserver
sc stop Ifsvc
sc start winmgmt
sc stop WMPNetworkSvc 
sc start TrustedInstaller
sc stop WinRM
sc start WSearch
sc stop WSService
sc start wuauserv
sc stop WinHttpAutoProxySvc
sc stop dot3svc
sc stop wmiApSrv
sc stop workfolderssvc
sc start LanmanWorkstation
sc stop W3SVC
sc stop WwanSvc

ECHO --------------------------------------------------
ECHO Now run the second script. (=_=|||
PAUSE