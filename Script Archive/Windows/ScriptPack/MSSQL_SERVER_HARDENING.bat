覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�
� Script created on Jun 30 2014 11:15AM �
� Version 1.1 �
� Purpose :: To create a one shot script to remediate the vulnerabilities and manage the hardening of SQL Server �
覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧�

� Find out the Version Details �

select @@servername as ServerName,
SERVERPROPERTY(善roductLevel�) as ServicePack,
SERVERPROPERTY(善roductVersion�) as BuildVersion,
SERVERPROPERTY(薦dition�) as Edition,
CONVERT(varchar(500),@@VERSION) as Version

覧�- Start MSSQL Server port check 覧覧�
� SQL Server 2008 and above �

print 送覧- Start MSSQL Server port check 覧覧桝
DECLARE @portNumber varchar(20), @key varchar(100)
if charindex(曾�,@@servername,0) <>0
begin
set @key = 全OFTWARE\MICROSOFT\Microsoft SQL Server\� +@@servicename+箪MSSQLServer\Supersocketnetlib\TCP�
end
else
begin
set @key = 全OFTWARE\MICROSOFT\MSSQLServer\MSSQLServer\Supersocketnetlib\TCP�
end

EXEC master..xp_regread @rootkey=辿KEY_LOCAL_MACHINE�, @key=@key, @value_name=探cpport�, @value=@portNumber OUTPUT

SELECT 全erver Name: �+@@servername + � Port Number:�+convert(varchar(10),@portNumber)
print 送覧- End MSSQL Server port check 覧覧桝
Print �

覧�- End MSSQL Server port check 覧覧�

Print 走 Note ::: Please ensure to configure SQL Server with a fixed customized port 桝
Print �
Print 走 Note ::: Apply latest Service Pack if applicable 桝
� Checking the MSSQL Server Service account.
print � �
print 送覧- Start MSSQL Server Service Account check 覧覧桝
print � �
SET NOCOUNT ON
GO
select 鉄erverName� = @@servername
go

declare @srvacct varchar(45), @instance varchar(45), @REGKEY varchar(128)
�
� For MSSQLServer service
�
select @instance=convert(varchar(45),SERVERPROPERTY(選nstanceName�))
if (@instance is null) SET @instance = 閃SSQLSERVER� else SET @instance = 閃SSQL$�+@instance
SET @REGKEY = 全YSTEM\CurrentControlSet\Services\�+@instance
execute master..xp_regread 践KEY_LOCAL_MACHINE�,@REGKEY,丹bjectName�,@srvacct output
select (case @instance when null then 全QLSERVERAGENT� else @instance end) as 全ervice / Instance�, @srvacct as 全ervice account�

�
� For MSSQLServer agent
�
select @instance=convert(varchar(45),SERVERPROPERTY(選nstanceName�))
if (@instance is null) SET @instance = 全QLSERVERAGENT� else SET @instance = 全QLAgent$�+@instance
SET @REGKEY = 全YSTEM\CurrentControlSet\Services\�+@instance
execute master..xp_regread 践KEY_LOCAL_MACHINE�,@REGKEY,丹bjectName�,@srvacct output
select (case @instance when null then 閃SSQLSERVER� else @instance end) as 全ervice / Instance�, @srvacct as 全ervice account�
print � �

print 送覧- End MSSQL Server Service Account check 覧覧桝
Print �
print 送 List of all members existing in local administrator group. Add SQL Server service account to it, if its not there 卵
Print �
EXEC master..xp_cmdshell 創et localgroup administrators�
GO
print 送 End checking members existing in local administrator group. 卵
Print �
print 走 Start checking the groups added in SQL Server 桝
Print �

SELECT [name] as PrincipalName, type as PrincipalType, type_desc as TypeDescription, create_date as CreationDate,
modify_date as ModificationDate
FROM sys.server_principals
WHERE type_desc IN (糎INDOWS_GROUP�)
ORDER BY type_desc
print 走 End checking the groups added in SQL Server 桝
Print �
print 走 Start renaming sa to eis_sa 桝
Print �

ALTER LOGIN sa DISABLE;
ALTER LOGIN sa WITH NAME = changed_sa;
ALTER LOGIN changed_sa ENABLE;

print 走 End renaming sa to changed_sa. changed_sa is now in enabled state 桝
Print �

print 走 Start setting Auditing to failed login attempts only 桝
USE [master]
GO
EXEC xp_instance_regwrite N辿KEY_LOCAL_MACHINE�, N担oftware\Microsoft\MSSQLServer\MSSQLServer�, N但uditLevel�, REG_DWORD, 2
GO
Print 羨uditing setup now completed�
print 走 End setting Auditing to failed login attempts only 桝
Print �
Print 走 Start revoking execute permissions on SP to Public user 桝

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
Print 然evoking permissions is now completed�
Print 走 Revoking of execute permissions on SP to Public user is completed 桝

� Revoke CONNECT permissions on the guest user within all SQL Server databases excluding the master, msdb and tempdb �
� REVOKE CONNECT FROM guest;
� Disable TRUSTWORTHY
Print 送覧- Start helpuser guest 覧覧桝
Print � �
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
select @hv=substring(convert(char(30),serverproperty(叢roductversion�)),1,1)
FETCH NEXT FROM AllDatabases INTO @DBNameVar
WHILE (@@FETCH_STATUS = 0)
BEGIN
PRINT N辰HECKING DATABASE � + @DBNameVar
if (@hv=�9' or @hv=�1')
select @is_25k=count(1) FROM sys.databases
WHERE name = @DBNameVar and state_desc=丹NLINE�
else
set @is_25k=1
� if (@is_25k=0)
� begin
� SET @Statement = N旦SE [� + @DBNameVar + 曽� + CHAR(13)
� + N弾xec sp_helpuser guest� + char(13)
� end
� else
begin
� SET @Statement = N痴elect * from �+@DBNameVar+�.sys.database_permissions where grantee_principal_id = 2 and permission_name=任ONNECT� �

SET @Statement = N痴elect substring(name,1,20) name,status,hasdbaccess,issqluser from [�+@DBNameVar+綻..sysusers WHERE hasdbaccess = 1 and issqluser =1 and name = 波uest� �

end

if @is_25k=1
EXEC sp_executesql @Statement
else
print 船B is not in online�
PRINT CHAR(13) + CHAR(13)
FETCH NEXT FROM AllDatabases INTO @DBNameVar
END

CLOSE AllDatabases
DEALLOCATE AllDatabases
GO
Print � �
Print 送覧- End Helpuser guest 覧覧�-�
Print � �
Print 送覧- Revoking CONNECT permissions on the guest user from these databases except master, msdb and tempdb 覧覧�-�

DECLARE @database_id int, @database_name nvarchar(100);

DECLARE database_cursor CURSOR FOR
SELECT name
FROM [master].sys.databases
WHERE name NOT IN (僧aster�, 奏empdb�, 僧sdb�)
AND state = 0

OPEN database_cursor

FETCH NEXT FROM database_cursor
INTO @database_name

while (@@FETCH_STATUS <> -1)
BEGIN
Print @database_name
EXEC(繕SE [� + @database_name + 曽;�+

然EVOKE CONNECT FROM GUEST;�

);

FETCH NEXT FROM database_cursor
INTO @database_name
END

CLOSE database_cursor
DEALLOCATE database_cursor

Print 送覧- Revoking CONNECT permissions on the guest user completed 覧-�
Print �
Print 送覧- Disable Trustworthy Asset Start 覧-�
Print �

Declare @DBName varchar(100),@trust varchar(200),@guest varchar(200)
declare trustworthy cursor local fast_forward for
select name from sys.databases
where name not in (閃aster�,樽odel�,樽SDB�,探empdb�)

open trustworthy
fetch next from trustworthy into @DBName ;
while @@FETCH_STATUS = 0
begin

Set @trust =但LTER DATABASE � + @DBName + � SET trustworthy Off�

exec (@trust)

fetch next from trustworthy into @DBName;

end;
close trustworthy;
deallocate trustworthy;

Print 送覧- Disable Trustworthy Asset completed 覧-�
Print �

Print 送� Start setting up SQL Server Error Log Files to 12 蘭�

USE master;
GO
EXEC xp_instance_regwrite N辿KEY_LOCAL_MACHINE�, N担oftware\Microsoft\MSSQLServer\MSSQLServer�, N誰umErrorLogs�, REG_DWORD, 12
GO

Print 送� End : SQL Server Error Logs increased to 12 蘭�
GO
Print �

� List of Orphaned Users in the server �
� Step 1: Create Stored Procedure in master DB �

Print 送覧- Start verifying Orphaned User 覧覧桝
GO

CREATE PROC [dbo].[usp_ShowOrphanUsers]
AS

� EXEC usp_ShowOrphanUsers (Will give the list of Orphan users in instance level but you have to EXEC this SP in DATABASE where SP created)

BEGIN
CREATE TABLE #Results
([Database Name] sysname COLLATE Latin1_General_CI_AS,
[Orphaned User] sysname COLLATE Latin1_General_CI_AS,
[Type User] sysname COLLATE Latin1_General_CI_AS)

SET NOCOUNT ON

DECLARE @DBName sysname, @Qry NVARCHAR(4000)

SET @Qry = �
SET @DBName = �

WHILE @DBName IS NOT NULL
BEGIN
SET @DBName =
(
SELECT MIN(name)
FROM master..sysdatabases
WHERE name NOT IN
(僧aster�, 僧odel�, 奏empdb�, 僧sdb�, 租istribution�)
AND DATABASEPROPERTY(name, 選sOffline�) = 0
AND DATABASEPROPERTY(name, 選sSuspect�) = 0
泡ND STATE = 0
AND name > @DBName
)

IF @DBName IS NULL BREAK

SET @Qry = � SELECT 白 + @DBName + 白 AS [Database Name],
CAST(name AS sysname) COLLATE Latin1_General_CI_AS AS [Orphaned User],
[Type User] =
CASE isntuser
WHEN �0� THEN 粘QL User�
WHEN �1� THEN 年T User�
ELSE 年ot Available�
END
FROM � + QUOTENAME(@DBName) + �..sysusers su
WHERE su.islogin = 1
AND su.name NOT IN (祢NFORMATION_SCHEMA�, 敗ys�, 波uest�, 播bo�, 敗ystem_function_schema�)
AND NOT EXISTS (SELECT 1 FROM master..syslogins sl WHERE su.sid = sl.sid)�
INSERT INTO #Results
EXEC master..sp_executesql @Qry
END
SELECT *
FROM #Results
ORDER BY [Database Name], [Orphaned User]
IF @@ROWCOUNT = 0
PRINT 鮮o orphaned users exist in this server.�
END
go

� Step 2: Execute SP to get the list of orphaned users across all DB痴 �

use master;
exec usp_ShowOrphanUsers

Print �
Print 送覧- End Orphaned User 覧覧桝
Print �

Print 送覧- Start verifying CLR Assembly Files Permissions 覧覧桝
Print �
� Setting CLR Assembly Permission Sets to SAFE_ACCESS �
� ALTER ASSEMBLY microsoft.sqlserver.types.dll WITH PERMISSION_SET = SAFE;

use master;
select * from sys.assembly_files

Print 送覧- End verifying CLR Assembly Files Permissions 覧覧桝
Print �
Print 送覧- NOTE:::: PLEASE ALTER THE ASSEMBLY PERMISSION SETS TO SAFE ACCESS 覧�-�
Print 送覧- USE THIS SYNTAX �> ALTER ASSEMBLY assembly name WITH PERMISSION_SET = SAFE 覧覧-�
Print �
Print �
Print 送覧- Physical Memory available on the server 覧覧桝

exec master..xp_msver 善hysicalMemory�

鳳rint 送覧- Designate max memory to SQL Server, as per the requirement and available physical memory on the server 覧覧桝

EXECUTE sp_configure 壮how advanced options�, 1;
RECONFIGURE;
EXEC sys.sp_configure N知ax server memory (MB)�, N�8192'
GO
RECONFIGURE WITH OVERRIDE
GO
Print �
Print 送 Max memory for SQL Server has been set to 8GB, as default. PLEASE CHANGE THIS VALUE AS PER THE REQUIREMENT AND AVAILABLE PHYSICAL MEMORY ON THE SERVER 卵

� Verify whether password policy is enabled
� a. Password expiration is set
� b. Max failed login attempts
� c. Alphanumeric password
� d. Minmum password length

Print 送覧- Start Password policy check 覧覧桝

print 閃SSQL 2008 and above Password policy is enabled at windows level�
select name as Loginname,is_policy_checked, is_expiration_checked, is_disabled from master.sys.sql_logins
殆here is_policy_checked =1
貌nd
�-To enforce password policy
剖SE [master]
萌O

縫ECLARE @user varchar(100)
縫ECLARE @policy varchar(100)

縫ECLARE user_cursor CURSOR FOR
穆elect name from sys.sql_logins
殆here is_expiration_checked=0
紡nd is_disabled=0
紡nd name not in (全A�,団hanged_sa�)
紡nd type_desc=担QL_LOGIN�

飽PEN user_cursor;
芳ETCH NEXT FROM user_cursor into @user;

妨HILE @@FETCH_STATUS = 0
烹EGIN

� Set @policy = 羨LTER LOGIN � + @user + � WITH CHECK_EXPIRATION=ON, CHECK_POLICY=ON �

� exec (@policy)

� FETCH NEXT FROM user_cursor into @user;
胞ND;

砲LOSE user_cursor;
縫EALLOCATE user_cursor;

Print � �
Print 送覧- End Password policy check 覧覧�-�

Print � �
Print 送覧- Start enabling/disabling server level configuration parameters 覧覧�-�

� This part will disable Ad Hoc Distributed Queries Server Configuration Option �

EXECUTE sp_configure 壮how advanced options�, 1;
RECONFIGURE;
EXECUTE sp_configure 羨d Hoc Distributed Queries�, 0;
RECONFIGURE;
GO
胞XECUTE sp_configure 壮how advanced options�, 0;
乏ECONFIGURE;

� Disable CLR enabled �

EXECUTE sp_configure 祖lr enabled�, 0;
RECONFIGURE;

� Disable Cross DB ownership chaining �

EXECUTE sp_configure 舛ross db ownership chaining�, 0;
RECONFIGURE;
GO

� Disable DB Mail �

胞XECUTE sp_configure 壮how advanced options�, 1;
乏ECONFIGURE;
EXECUTE sp_configure 船atabase Mail XPs�, 0;
RECONFIGURE;
GO
胞XECUTE sp_configure 壮how advanced options�, 0;
乏ECONFIGURE;

� Disable Ole Automation Procedures �

胞XECUTE sp_configure 壮how advanced options�, 1;
乏ECONFIGURE;
EXECUTE sp_configure 前le Automation Procedures�, 0;
RECONFIGURE;
GO
胞XECUTE sp_configure 壮how advanced options�, 0;
乏ECONFIGURE;

� Enable Remote Admin Connections �

胞XECUTE sp_configure 壮how advanced options�, 1;
乏ECONFIGURE;
EXECUTE sp_configure 然emote admin connections�, 1;
RECONFIGURE;
GO
胞XECUTE sp_configure 壮how advanced options�, 0;
乏ECONFIGURE;

� Disable scan for startup procedures �

胞XECUTE sp_configure 壮how advanced options�, 1;
乏ECONFIGURE;
EXECUTE sp_configure 全can for startup procs�, 0;
RECONFIGURE;
GO
� Enable Default trace for audit purpose �

胞XECUTE sp_configure 壮how advanced options�, 1;
乏ECONFIGURE;
EXECUTE sp_configure 船efault trace enabled�, 1;
RECONFIGURE;
GO
胞XECUTE sp_configure 壮how advanced options�, 0;
乏ECONFIGURE;
� Disable xp_cmdshell �
胞XECUTE sp_configure 壮how advanced options�, 1;
乏ECONFIGURE;
EXECUTE sp_configure 噌p_cmdshell�, 0;
RECONFIGURE WITH OVERRIDE;
GO
EXECUTE sp_configure 壮how advanced options�, 0;
RECONFIGURE;

Print 送覧- End enabling/disabling server level configuration parameters 覧覧�-�
Print �