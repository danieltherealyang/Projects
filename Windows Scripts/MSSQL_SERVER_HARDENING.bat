—————————————————————————————————————————————————————
— Script created on Jun 30 2014 11:15AM —
— Version 1.1 —
— Purpose :: To create a one shot script to remediate the vulnerabilities and manage the hardening of SQL Server —
—————————————————————————————————————————————————————

— Find out the Version Details —

select @@servername as ServerName,
SERVERPROPERTY(‘ProductLevel’) as ServicePack,
SERVERPROPERTY(‘ProductVersion’) as BuildVersion,
SERVERPROPERTY(‘Edition’) as Edition,
CONVERT(varchar(500),@@VERSION) as Version

———- Start MSSQL Server port check ————–
— SQL Server 2008 and above —

print ‘———- Start MSSQL Server port check ————–‘
DECLARE @portNumber varchar(20), @key varchar(100)
if charindex(‘\’,@@servername,0) <>0
begin
set @key = ‘SOFTWARE\MICROSOFT\Microsoft SQL Server\’ +@@servicename+’\MSSQLServer\Supersocketnetlib\TCP’
end
else
begin
set @key = ‘SOFTWARE\MICROSOFT\MSSQLServer\MSSQLServer\Supersocketnetlib\TCP’
end

EXEC master..xp_regread @rootkey=’HKEY_LOCAL_MACHINE’, @key=@key, @value_name=’Tcpport’, @value=@portNumber OUTPUT

SELECT ‘Server Name: ‘+@@servername + ‘ Port Number:’+convert(varchar(10),@portNumber)
print ‘———- End MSSQL Server port check ————–‘
Print ”

———- End MSSQL Server port check ————–

Print ‘– Note ::: Please ensure to configure SQL Server with a fixed customized port –‘
Print ”
Print ‘– Note ::: Apply latest Service Pack if applicable –‘
— Checking the MSSQL Server Service account.
print ‘ ‘
print ‘———- Start MSSQL Server Service Account check ————–‘
print ‘ ‘
SET NOCOUNT ON
GO
select “ServerName” = @@servername
go

declare @srvacct varchar(45), @instance varchar(45), @REGKEY varchar(128)
—
— For MSSQLServer service
—
select @instance=convert(varchar(45),SERVERPROPERTY(‘InstanceName’))
if (@instance is null) SET @instance = ‘MSSQLSERVER’ else SET @instance = ‘MSSQL$’+@instance
SET @REGKEY = ‘SYSTEM\CurrentControlSet\Services\’+@instance
execute master..xp_regread ‘HKEY_LOCAL_MACHINE’,@REGKEY,’ObjectName’,@srvacct output
select (case @instance when null then ‘SQLSERVERAGENT’ else @instance end) as ‘Service / Instance’, @srvacct as ‘Service account’

—
— For MSSQLServer agent
—
select @instance=convert(varchar(45),SERVERPROPERTY(‘InstanceName’))
if (@instance is null) SET @instance = ‘SQLSERVERAGENT’ else SET @instance = ‘SQLAgent$’+@instance
SET @REGKEY = ‘SYSTEM\CurrentControlSet\Services\’+@instance
execute master..xp_regread ‘HKEY_LOCAL_MACHINE’,@REGKEY,’ObjectName’,@srvacct output
select (case @instance when null then ‘MSSQLSERVER’ else @instance end) as ‘Service / Instance’, @srvacct as ‘Service account’
print ‘ ‘

print ‘———- End MSSQL Server Service Account check ————–‘
Print ”
print ‘— List of all members existing in local administrator group. Add SQL Server service account to it, if its not there —‘
Print ”
EXEC master..xp_cmdshell ‘net localgroup administrators’
GO
print ‘— End checking members existing in local administrator group. —‘
Print ”
print ‘– Start checking the groups added in SQL Server –‘
Print ”

SELECT [name] as PrincipalName, type as PrincipalType, type_desc as TypeDescription, create_date as CreationDate,
modify_date as ModificationDate
FROM sys.server_principals
WHERE type_desc IN (‘WINDOWS_GROUP’)
ORDER BY type_desc
print ‘– End checking the groups added in SQL Server –‘
Print ”
print ‘– Start renaming sa to eis_sa –‘
Print ”

ALTER LOGIN sa DISABLE;
ALTER LOGIN sa WITH NAME = changed_sa;
ALTER LOGIN changed_sa ENABLE;

print ‘– End renaming sa to changed_sa. changed_sa is now in enabled state –‘
Print ”

print ‘– Start setting Auditing to failed login attempts only –‘
USE [master]
GO
EXEC xp_instance_regwrite N’HKEY_LOCAL_MACHINE’, N’Software\Microsoft\MSSQLServer\MSSQLServer’, N’AuditLevel’, REG_DWORD, 2
GO
Print ‘Auditing setup now completed’
print ‘– End setting Auditing to failed login attempts only –‘
Print ”
Print ‘– Start revoking execute permissions on SP to Public user –‘

REVOKE EXECUTE ON xp_availablemedia TO PUBLIC;
REVOKE EXECUTE ON xp_enumgroups to PUBLIC;
REVOKE EXECUTE ON xp_fixeddrives TO PUBLIC
REVOKE EXECUTE ON xp_servicecontrol TO PUBLIC;
REVOKE EXECUTE ON xp_subdirs TO PUBLIC;
REVOKE EXECUTE ON xp_regaddmultistring TO PUBLIC;
REVOKE EXECUTE ON xp_regdeletekey TO PUBLIC;
REVOKE EXECUTE ON xp_regdeletevalue TO PUBLIC;
REVOKE EXECUTE ON xp_regenumvalues TO PUBLIC;
REVOKE EXECUTE ON xp_regremovemultistring TO PUBLIC;
REVOKE EXECUTE ON xp_regwrite TO PUBLIC;
REVOKE EXECUTE ON xp_regread TO PUBLIC;
Print ‘Revoking permissions is now completed’
Print ‘– Revoking of execute permissions on SP to Public user is completed –‘

— Revoke CONNECT permissions on the guest user within all SQL Server databases excluding the master, msdb and tempdb —
— REVOKE CONNECT FROM guest;
— Disable TRUSTWORTHY
Print ‘———- Start helpuser guest ————–‘
Print ‘ ‘
SET NOCOUNT ON
GO
DECLARE AllDatabases CURSOR FOR
SELECT name FROM master.dbo.sysdatabases
OPEN AllDatabases
DECLARE @DBNameVar NVARCHAR(128)
DECLARE @Statement NVARCHAR(300)
DECLARE @time_interval INT
DECLARE @table_creation INT
DECLARE @database VARCHAR(50)
declare @is_25k int
declare @hv char(1)
select @hv=substring(convert(char(30),serverproperty(‘productversion’)),1,1)
FETCH NEXT FROM AllDatabases INTO @DBNameVar
WHILE (@@FETCH_STATUS = 0)
BEGIN
PRINT N’CHECKING DATABASE ‘ + @DBNameVar
if (@hv=’9' or @hv=’1')
select @is_25k=count(1) FROM sys.databases
WHERE name = @DBNameVar and state_desc=’ONLINE’
else
set @is_25k=1
— if (@is_25k=0)
— begin
— SET @Statement = N’USE [‘ + @DBNameVar + ‘]’ + CHAR(13)
— + N’exec sp_helpuser guest’ + char(13)
— end
— else
begin
— SET @Statement = N’select * from ‘+@DBNameVar+’.sys.database_permissions where grantee_principal_id = 2 and permission_name=”CONNECT” ‘

SET @Statement = N’select substring(name,1,20) name,status,hasdbaccess,issqluser from [‘+@DBNameVar+’]..sysusers WHERE hasdbaccess = 1 and issqluser =1 and name = ”guest” ‘

end

if @is_25k=1
EXEC sp_executesql @Statement
else
print ‘DB is not in online’
PRINT CHAR(13) + CHAR(13)
FETCH NEXT FROM AllDatabases INTO @DBNameVar
END

CLOSE AllDatabases
DEALLOCATE AllDatabases
GO
Print ‘ ‘
Print ‘———- End Helpuser guest —————-‘
Print ‘ ‘
Print ‘———- Revoking CONNECT permissions on the guest user from these databases except master, msdb and tempdb —————-‘

DECLARE @database_id int, @database_name nvarchar(100);

DECLARE database_cursor CURSOR FOR
SELECT name
FROM [master].sys.databases
WHERE name NOT IN (‘master’, ‘tempdb’, ‘msdb’)
AND state = 0

OPEN database_cursor

FETCH NEXT FROM database_cursor
INTO @database_name

while (@@FETCH_STATUS <> -1)
BEGIN
Print @database_name
EXEC(‘USE [‘ + @database_name + ‘];’+

‘REVOKE CONNECT FROM GUEST;’

);

FETCH NEXT FROM database_cursor
INTO @database_name
END

CLOSE database_cursor
DEALLOCATE database_cursor

Print ‘———- Revoking CONNECT permissions on the guest user completed ——-‘
Print ”
Print ‘———- Disable Trustworthy Asset Start ——-‘
Print ”

Declare @DBName varchar(100),@trust varchar(200),@guest varchar(200)
declare trustworthy cursor local fast_forward for
select name from sys.databases
where name not in (‘Master’,’Model’,’MSDB’,’Tempdb’)

open trustworthy
fetch next from trustworthy into @DBName ;
while @@FETCH_STATUS = 0
begin

Set @trust =’ALTER DATABASE ‘ + @DBName + ‘ SET trustworthy Off’

exec (@trust)

fetch next from trustworthy into @DBName;

end;
close trustworthy;
deallocate trustworthy;

Print ‘———- Disable Trustworthy Asset completed ——-‘
Print ”

Print ‘—— Start setting up SQL Server Error Log Files to 12 —–‘

USE master;
GO
EXEC xp_instance_regwrite N’HKEY_LOCAL_MACHINE’, N’Software\Microsoft\MSSQLServer\MSSQLServer’, N’NumErrorLogs’, REG_DWORD, 12
GO

Print ‘—— End : SQL Server Error Logs increased to 12 —–‘
GO
Print ”

— List of Orphaned Users in the server —
— Step 1: Create Stored Procedure in master DB —

Print ‘———- Start verifying Orphaned User ————–‘
GO

CREATE PROC [dbo].[usp_ShowOrphanUsers]
AS

— EXEC usp_ShowOrphanUsers (Will give the list of Orphan users in instance level but you have to EXEC this SP in DATABASE where SP created)

BEGIN
CREATE TABLE #Results
([Database Name] sysname COLLATE Latin1_General_CI_AS,
[Orphaned User] sysname COLLATE Latin1_General_CI_AS,
[Type User] sysname COLLATE Latin1_General_CI_AS)

SET NOCOUNT ON

DECLARE @DBName sysname, @Qry NVARCHAR(4000)

SET @Qry = ”
SET @DBName = ”

WHILE @DBName IS NOT NULL
BEGIN
SET @DBName =
(
SELECT MIN(name)
FROM master..sysdatabases
WHERE name NOT IN
(‘master’, ‘model’, ‘tempdb’, ‘msdb’, ‘distribution’)
AND DATABASEPROPERTY(name, ‘IsOffline’) = 0
AND DATABASEPROPERTY(name, ‘IsSuspect’) = 0
–AND STATE = 0
AND name > @DBName
)

IF @DBName IS NULL BREAK

SET @Qry = ‘ SELECT ”’ + @DBName + ”’ AS [Database Name],
CAST(name AS sysname) COLLATE Latin1_General_CI_AS AS [Orphaned User],
[Type User] =
CASE isntuser
WHEN ”0” THEN ”SQL User”
WHEN ”1” THEN ”NT User”
ELSE ”Not Available”
END
FROM ‘ + QUOTENAME(@DBName) + ‘..sysusers su
WHERE su.islogin = 1
AND su.name NOT IN (”INFORMATION_SCHEMA”, ”sys”, ”guest”, ”dbo”, ”system_function_schema”)
AND NOT EXISTS (SELECT 1 FROM master..syslogins sl WHERE su.sid = sl.sid)’
INSERT INTO #Results
EXEC master..sp_executesql @Qry
END
SELECT *
FROM #Results
ORDER BY [Database Name], [Orphaned User]
IF @@ROWCOUNT = 0
PRINT ‘No orphaned users exist in this server.’
END
go

— Step 2: Execute SP to get the list of orphaned users across all DB’s —

use master;
exec usp_ShowOrphanUsers

Print ”
Print ‘———- End Orphaned User ————–‘
Print ”

Print ‘———- Start verifying CLR Assembly Files Permissions ————–‘
Print ”
— Setting CLR Assembly Permission Sets to SAFE_ACCESS —
— ALTER ASSEMBLY microsoft.sqlserver.types.dll WITH PERMISSION_SET = SAFE;

use master;
select * from sys.assembly_files

Print ‘———- End verifying CLR Assembly Files Permissions ————–‘
Print ”
Print ‘———- NOTE:::: PLEASE ALTER THE ASSEMBLY PERMISSION SETS TO SAFE ACCESS ———-‘
Print ‘———- USE THIS SYNTAX –> ALTER ASSEMBLY assembly name WITH PERMISSION_SET = SAFE ————-‘
Print ”
Print ”
Print ‘———- Physical Memory available on the server ————–‘

exec master..xp_msver ‘PhysicalMemory’

–Print ‘———- Designate max memory to SQL Server, as per the requirement and available physical memory on the server ————–‘

EXECUTE sp_configure ‘show advanced options’, 1;
RECONFIGURE;
EXEC sys.sp_configure N’max server memory (MB)’, N’8192'
GO
RECONFIGURE WITH OVERRIDE
GO
Print ”
Print ‘— Max memory for SQL Server has been set to 8GB, as default. PLEASE CHANGE THIS VALUE AS PER THE REQUIREMENT AND AVAILABLE PHYSICAL MEMORY ON THE SERVER —‘

— Verify whether password policy is enabled
— a. Password expiration is set
— b. Max failed login attempts
— c. Alphanumeric password
— d. Minmum password length

Print ‘———- Start Password policy check ————–‘

print ‘MSSQL 2008 and above Password policy is enabled at windows level’
select name as Loginname,is_policy_checked, is_expiration_checked, is_disabled from master.sys.sql_logins
–where is_policy_checked =1
–end
—-To enforce password policy
–USE [master]
–GO

–DECLARE @user varchar(100)
–DECLARE @policy varchar(100)

–DECLARE user_cursor CURSOR FOR
–select name from sys.sql_logins
–where is_expiration_checked=0
–and is_disabled=0
–and name not in (‘SA’,’changed_sa’)
–and type_desc=’SQL_LOGIN’

–OPEN user_cursor;
–FETCH NEXT FROM user_cursor into @user;

–WHILE @@FETCH_STATUS = 0
–BEGIN

— Set @policy = ‘ALTER LOGIN ‘ + @user + ‘ WITH CHECK_EXPIRATION=ON, CHECK_POLICY=ON ‘

— exec (@policy)

— FETCH NEXT FROM user_cursor into @user;
–END;

–CLOSE user_cursor;
–DEALLOCATE user_cursor;

Print ‘ ‘
Print ‘———- End Password policy check —————-‘

Print ‘ ‘
Print ‘———- Start enabling/disabling server level configuration parameters —————-‘

— This part will disable Ad Hoc Distributed Queries Server Configuration Option —

EXECUTE sp_configure ‘show advanced options’, 1;
RECONFIGURE;
EXECUTE sp_configure ‘Ad Hoc Distributed Queries’, 0;
RECONFIGURE;
GO
–EXECUTE sp_configure ‘show advanced options’, 0;
–RECONFIGURE;

— Disable CLR enabled —

EXECUTE sp_configure ‘clr enabled’, 0;
RECONFIGURE;

— Disable Cross DB ownership chaining —

EXECUTE sp_configure ‘Cross db ownership chaining’, 0;
RECONFIGURE;
GO

— Disable DB Mail —

–EXECUTE sp_configure ‘show advanced options’, 1;
–RECONFIGURE;
EXECUTE sp_configure ‘Database Mail XPs’, 0;
RECONFIGURE;
GO
–EXECUTE sp_configure ‘show advanced options’, 0;
–RECONFIGURE;

— Disable Ole Automation Procedures —

–EXECUTE sp_configure ‘show advanced options’, 1;
–RECONFIGURE;
EXECUTE sp_configure ‘Ole Automation Procedures’, 0;
RECONFIGURE;
GO
–EXECUTE sp_configure ‘show advanced options’, 0;
–RECONFIGURE;

— Enable Remote Admin Connections —

–EXECUTE sp_configure ‘show advanced options’, 1;
–RECONFIGURE;
EXECUTE sp_configure ‘Remote admin connections’, 1;
RECONFIGURE;
GO
–EXECUTE sp_configure ‘show advanced options’, 0;
–RECONFIGURE;

— Disable scan for startup procedures —

–EXECUTE sp_configure ‘show advanced options’, 1;
–RECONFIGURE;
EXECUTE sp_configure ‘Scan for startup procs’, 0;
RECONFIGURE;
GO
— Enable Default trace for audit purpose —

–EXECUTE sp_configure ‘show advanced options’, 1;
–RECONFIGURE;
EXECUTE sp_configure ‘Default trace enabled’, 1;
RECONFIGURE;
GO
–EXECUTE sp_configure ‘show advanced options’, 0;
–RECONFIGURE;
— Disable xp_cmdshell —
–EXECUTE sp_configure ‘show advanced options’, 1;
–RECONFIGURE;
EXECUTE sp_configure ‘Xp_cmdshell’, 0;
RECONFIGURE WITH OVERRIDE;
GO
EXECUTE sp_configure ‘show advanced options’, 0;
RECONFIGURE;

Print ‘———- End enabling/disabling server level configuration parameters —————-‘
Print ”