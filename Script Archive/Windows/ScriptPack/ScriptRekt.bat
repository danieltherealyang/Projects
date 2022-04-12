@TITLE Firewall, auto-update, UAC, host file, AutoPlay, Folder Options
@ECHO OFF
ECHO --------------------------------------------------
ECHO This script must be run as Administrator (SYSTEM32) !!
ECHO Please ensure that the script is running as SYSTEM32 !!

ECHO --------------------------------------------------
ECHO Turning firewall on... :thinking:
PAUSE

NetSh Advfirewall set allprofiles state on

ECHO --------------------------------------------------
ECHO Turning on automatic updates... ( O~O)¤Ä--+
PAUSE

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v IncludeRecommendedUpdates /d 1 /f

ECHO --------------------------------------------------
ECHO Configuring UAC \(u W u)/
PAUSE

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 2 /f 
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorUser /t REG_DWORD /d 3 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableInstallerDetection /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableVirtualization /t REG_DWORD /d 1 /f 
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ValidateAdminCodeSignatures /t REG_DWORD /d 0 /f 

ECHO --------------------------------------------------
ECHO Fixing hosts file...  :P
PAUSE

@echo off
@echo # Copyright (c) 1993-2006 Microsoft Corp.> C:\Windows\System32\Drivers\etc\hosts
@echo #>> C:\Windows\System32\Drivers\etc\hosts
@echo # This is a sample HOSTS file used by Microsoft TCP/IP for Windows.>> C:\Windows\System32\Drivers\etc\hosts
@echo #>> C:\Windows\System32\Drivers\etc\hosts
@echo # This file contains the mappings of IP addresses to host names. Each>> C:\Windows\System32\Drivers\etc\hosts
@echo # entry should be kept on an individual line. The IP address should>> C:\Windows\System32\Drivers\etc\hosts
@echo # be placed in the first column followed by the corresponding host name.>> C:\Windows\System32\Drivers\etc\hosts
@echo # The IP address and the host name should be separated by at least one>> C:\Windows\System32\Drivers\etc\hosts
@echo # space.>> C:\Windows\System32\Drivers\etc\hosts
@echo # >> C:\Windows\System32\Drivers\etc\hosts
@echo # Additionally, comments (such as these) may be inserted on individual>> C:\Windows\System32\Drivers\etc\hosts
@echo # lines or following the machine name denoted by a '#' symbol.>> C:\Windows\System32\Drivers\etc\hosts
@echo #>> C:\Windows\System32\Drivers\etc\hosts
@echo # For example:>> C:\Windows\System32\Drivers\etc\hosts
@echo #>> C:\Windows\System32\Drivers\etc\hosts
@echo #      102.54.94.97     rhino.acme.com          # source server>> C:\Windows\System32\Drivers\etc\hosts
@echo #       38.25.63.10     x.acme.com              # x client host>> C:\Windows\System32\Drivers\etc\hosts
echo.>> C:\Windows\System32\Drivers\etc\hosts
@echo # localhost name resolution is handle within DNS itself.>> C:\Windows\System32\Drivers\etc\hosts
@echo #       127.0.0.1       localhost >> C:\Windows\System32\Drivers\etc\hosts
@echo #       ::1             localhost >> C:\Windows\System32\Drivers\etc\hosts

ECHO Done. REEEE
PAUSE

ECHO --------------------------------------------------
ECHO Getting rid of Autoplay~
PAUSE

reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers /v "DisableAutoPlay" /t REG_DWORD /d 1 /f

ECHO --------------------------------------------------
ECHO Folder Option stuff
PAUSE


reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v "HideFileExt" /t REG_DWORD /d 0 /f
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v "ShowSuperHidden" /t REG_DWORD /d 0x1 /f
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v "Hidden" /t REG_DWORD /d 0x1 /f
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState /v "FullPath" /t REG_DWORD /d 0 /f

ECHO To kill and restart explorer
PAUSE
taskkill /f /im explorer.exe
start explorer.exe

ECHO --------------------------------------------------
ECHO The script has finished executing. Please check for any possible errors now. |(^ _ ^)|
PAUSE