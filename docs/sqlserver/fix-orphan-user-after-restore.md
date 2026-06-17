# Fix SQL Server Orphan User After Database Restore

## Situation

After restoring a SQL Server database from another server or environment, the application cannot connect using the expected database user.

Common example:

```txt
Login failed for user 'o24wfo'.
```

This usually happens after restoring databases such as:

```txt
o24wfo
o24cth
o24cms
o24dts
o24cbg
o24
nch
o24logger
o24stl
o24act
o24dwh
```

## Error

```txt
Login failed for user '<database_user>'.
```

Example:

```txt
Login failed for user 'o24wfo'.
```

## Root cause

SQL Server has two different security objects:

1. **Server login** in `[master]`
2. **Database user** inside each restored database

When a database is restored from another SQL Server instance, the database user may still exist but its SID no longer matches the server login SID on the new server.

This is called an **orphan user**.

Deleting and recreating the database user manually works, but the correct repeatable fix is:

```sql
ALTER USER [user_name] WITH LOGIN = [login_name];
```

## Fix script

> Do not store real production passwords in this file. Replace `<CHANGE_ME>` before running the script.

This script creates or enables the login, resets the password, maps the database user back to the login, and grants `db_owner`.

```sql
USE [master];
GO

DECLARE @DefaultPassword NVARCHAR(256) = N'<CHANGE_ME>';

DECLARE @Accounts TABLE
(
    DbName SYSNAME,
    LoginName SYSNAME,
    UserName SYSNAME
);

INSERT INTO @Accounts (DbName, LoginName, UserName)
VALUES
    (N'o24wfo',    N'o24wfo',    N'o24wfo'),
    (N'o24cth',    N'o24cth',    N'o24cth'),
    (N'o24cms',    N'o24cms',    N'o24cms'),
    (N'o24dts',    N'o24dts',    N'o24dts'),
    (N'o24cbg',    N'o24cbg',    N'o24cbg'),
    (N'o24',       N'o24',       N'o24'),
    (N'nch',       N'nch',       N'nch'),
    (N'o24logger', N'o24logger', N'o24logger'),
    (N'o24stl',    N'o24stl',    N'o24stl'),
    (N'o24act',    N'o24act',    N'o24act'),
    (N'o24dwh',    N'o24dwh',    N'o24dwh');

DECLARE
    @DbName SYSNAME,
    @LoginName SYSNAME,
    @UserName SYSNAME,
    @Sql NVARCHAR(MAX);

DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
SELECT DbName, LoginName, UserName
FROM @Accounts;

OPEN cur;

FETCH NEXT FROM cur INTO @DbName, @LoginName, @UserName;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '========================================';
    PRINT 'Processing: ' + @DbName;

    IF DB_ID(@DbName) IS NULL
    BEGIN
        PRINT 'SKIP - Database not found: ' + @DbName;
    END
    ELSE
    BEGIN
        SET @Sql = N'
USE [master];

IF NOT EXISTS (
    SELECT 1
    FROM sys.sql_logins
    WHERE name = N''' + REPLACE(@LoginName, '''', '''''') + N'''
)
BEGIN
    CREATE LOGIN ' + QUOTENAME(@LoginName) + N'
    WITH PASSWORD = N''' + REPLACE(@DefaultPassword, '''', '''''') + N''',
         CHECK_POLICY = OFF,
         CHECK_EXPIRATION = OFF;
END
ELSE
BEGIN
    ALTER LOGIN ' + QUOTENAME(@LoginName) + N' ENABLE;

    ALTER LOGIN ' + QUOTENAME(@LoginName) + N'
    WITH PASSWORD = N''' + REPLACE(@DefaultPassword, '''', '''''') + N''',
         CHECK_POLICY = OFF,
         CHECK_EXPIRATION = OFF;
END;
';
        EXEC sp_executesql @Sql;

        SET @Sql = N'
USE ' + QUOTENAME(@DbName) + N';

IF EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = N''' + REPLACE(@UserName, '''', '''''') + N'''
)
BEGIN
    ALTER USER ' + QUOTENAME(@UserName) + N'
    WITH LOGIN = ' + QUOTENAME(@LoginName) + N';
END
ELSE
BEGIN
    CREATE USER ' + QUOTENAME(@UserName) + N'
    FOR LOGIN ' + QUOTENAME(@LoginName) + N';
END;

IF IS_ROLEMEMBER(N''db_owner'', N''' + REPLACE(@UserName, '''', '''''') + N''') <> 1
BEGIN
    ALTER ROLE [db_owner] ADD MEMBER ' + QUOTENAME(@UserName) + N';
END;
';
        EXEC sp_executesql @Sql;

        PRINT 'DONE - ' + @DbName;
    END

    FETCH NEXT FROM cur INTO @DbName, @LoginName, @UserName;
END

CLOSE cur;
DEALLOCATE cur;
GO
```

## Single database example

Use this when only one database needs to be fixed.

```sql
USE [master];
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.sql_logins
    WHERE name = N'o24wfo'
)
BEGIN
    CREATE LOGIN [o24wfo]
    WITH PASSWORD = N'<CHANGE_ME>',
         CHECK_POLICY = OFF,
         CHECK_EXPIRATION = OFF;
END
ELSE
BEGIN
    ALTER LOGIN [o24wfo] ENABLE;

    ALTER LOGIN [o24wfo]
    WITH PASSWORD = N'<CHANGE_ME>',
         CHECK_POLICY = OFF,
         CHECK_EXPIRATION = OFF;
END
GO

USE [o24wfo];
GO

IF EXISTS (
    SELECT 1
    FROM sys.database_principals
    WHERE name = N'o24wfo'
)
BEGIN
    ALTER USER [o24wfo] WITH LOGIN = [o24wfo];
END
ELSE
BEGIN
    CREATE USER [o24wfo] FOR LOGIN [o24wfo];
END
GO

ALTER ROLE [db_owner] ADD MEMBER [o24wfo];
GO
```

## Verification commands

Check login exists:

```sql
USE [master];
GO

SELECT name, is_disabled, create_date, modify_date
FROM sys.sql_logins
WHERE name IN (
    N'o24wfo',
    N'o24cth',
    N'o24cms',
    N'o24dts',
    N'o24cbg',
    N'o24',
    N'nch',
    N'o24logger',
    N'o24stl',
    N'o24act',
    N'o24dwh'
);
GO
```

Check database user mapping:

```sql
USE [o24wfo];
GO

SELECT
    dp.name AS database_user,
    sp.name AS server_login,
    dp.type_desc,
    dp.authentication_type_desc
FROM sys.database_principals dp
LEFT JOIN sys.server_principals sp
    ON dp.sid = sp.sid
WHERE dp.name = N'o24wfo';
GO
```

Expected result:

```txt
database_user = o24wfo
server_login  = o24wfo
```

## Notes

If the real Notification Hub database is `o24nch` instead of `nch`, change this line:

```sql
(N'nch', N'nch', N'nch')
```

To:

```sql
(N'o24nch', N'o24nch', N'o24nch')
```

For production environments, prefer strong passwords and keep them in a password manager or deployment secret store. Do not commit real passwords, access tokens, private keys, or production secrets into the runbook.

## Tags

`sqlserver`, `restore`, `orphan-user`, `login-failed`, `database`, `db-owner`
