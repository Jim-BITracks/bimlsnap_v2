USE [bimlsnap_v2]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[dim_column]    Script Date: 8/15/2018 3:28:49 AM ******/
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[dim_column]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[dim_column](
		[column_sk] [int] IDENTITY(1,1) NOT NULL,
		[server_name] [nvarchar](128) NOT NULL,
		[database_name] [nvarchar](128) NOT NULL,
		[table_schema] [nvarchar](128) NOT NULL,
		[table_name] [nvarchar](128) NOT NULL,
		[column_name] [nvarchar](128) NOT NULL,
		[ordinal_position] [int] NOT NULL,
		[is_nullable] [nvarchar](3) NULL,
		[data_type] [nvarchar](128) NULL,
		[char_max_length] [int] NULL,
		[primary_key] [nvarchar](3) NOT NULL,
		[row_data_source] [nvarchar](16) NOT NULL,
		[row_is_current] [nchar](1) NOT NULL,
		[row_effective_date] [date] NOT NULL,
		[row_expiration_date] [date] NOT NULL,
		[row_insert_date] [date] NOT NULL,
		[row_update_date] [date] NOT NULL,
	 CONSTRAINT [PK dbo dim_column] PRIMARY KEY NONCLUSTERED 
	(
		[column_sk] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[dim_table]    Script Date: 8/15/2018 3:34:59 AM ******/
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[dim_table]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[dim_table](
		[table_sk] [int] IDENTITY(1,1) NOT NULL,
		[server_name] [nvarchar](128) NOT NULL,
		[database_name] [nvarchar](128) NOT NULL,
		[table_schema] [nvarchar](128) NOT NULL,
		[table_name] [nvarchar](128) NOT NULL,
		[table_type] [nvarchar](32) NOT NULL,
		[has_identity] [nvarchar](1) NOT NULL,
		[has_primary_key] [nvarchar](1) NOT NULL,
		[row_data_source] [nvarchar](16) NOT NULL,
		[row_is_current] [nchar](1) NOT NULL,
		[row_effective_date] [date] NOT NULL,
		[row_expiration_date] [date] NOT NULL,
		[row_insert_date] [date] NOT NULL,
		[row_update_date] [date] NOT NULL,
	 CONSTRAINT [PK dbo dim_table] PRIMARY KEY NONCLUSTERED 
	(
		[table_sk] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

/****** Object:  Table [stg].[dim_column]    Script Date: 8/15/2018 3:35:35 AM ******/
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[stg].[dim_column]') AND type in (N'U'))
BEGIN
	CREATE TABLE [stg].[dim_column](
		[server_name] [nvarchar](128) NOT NULL,
		[database_name] [nvarchar](128) NOT NULL,
		[table_schema] [nvarchar](128) NOT NULL,
		[table_name] [nvarchar](128) NOT NULL,
		[column_name] [nvarchar](128) NOT NULL,
		[ordinal_position] [int] NOT NULL,
		[is_nullable] [nvarchar](3) NULL,
		[data_type] [nvarchar](128) NULL,
		[char_max_length] [int] NULL,
		[primary_key] [nvarchar](3) NOT NULL,
		[row_data_source] [nvarchar](16) NOT NULL,
	 CONSTRAINT [PK_stg_dim_column] PRIMARY KEY CLUSTERED 
	(
		[server_name] ASC,
		[database_name] ASC,
		[table_schema] ASC,
		[table_name] ASC,
		[column_name] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

/****** Object:  Table [stg].[dim_database]    Script Date: 8/15/2018 3:36:13 AM ******/
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[stg].[dim_database]') AND type in (N'U'))
BEGIN
	CREATE TABLE [stg].[dim_database](
		[server_name] [nvarchar](128) NOT NULL,
		[database_name] [nvarchar](128) NOT NULL,
		[database_create_date] [date] NOT NULL,
		[change_tracking_enabled] [nvarchar](1) NOT NULL,
		[row_data_source] [nvarchar](16) NOT NULL,
	 CONSTRAINT [PK_stg_dim_database] PRIMARY KEY CLUSTERED 
	(
		[server_name] ASC,
		[database_name] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

/****** Object:  Table [stg].[dim_table]    Script Date: 8/15/2018 3:36:43 AM ******/
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[stg].[dim_table]') AND type in (N'U'))
BEGIN
	CREATE TABLE [stg].[dim_table](
		[server_name] [nvarchar](128) NOT NULL,
		[database_name] [nvarchar](128) NOT NULL,
		[table_schema] [nvarchar](128) NOT NULL,
		[table_name] [nvarchar](128) NOT NULL,
		[table_type] [nvarchar](32) NOT NULL,
		[has_identity] [nvarchar](1) NOT NULL,
		[has_primary_key] [nvarchar](1) NOT NULL,
		[row_data_source] [nvarchar](16) NOT NULL,
	 CONSTRAINT [PK_stg_dim_table] PRIMARY KEY CLUSTERED 
	(
		[server_name] ASC,
		[database_name] ASC,
		[table_schema] ASC,
		[table_name] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO





/****** Object:  StoredProcedure [dbo].[Delete Server Metadata]    Script Date: 8/15/2018 3:38:50 AM ******/
IF EXISTS(SELECT 1 FROM sysobjects WHERE type = 'P' and name = 'Delete Server Metadata')
BEGIN
   DROP PROCEDURE [dbo].[Delete Server Metadata]
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 07 Oct 2017
-- Modify date: 27 Oct 2017 - added 'dbo' schema tables
--
-- Description:	Deletes all metadata (in the etl and stg schemas) for a provided server name
--
-- Sample Execute Command: 
/*	
EXEC [dbo].[Delete Server Metadata]  'put server name here';
*/
-- ================================================================================================
CREATE PROCEDURE [dbo].[Delete Server Metadata] ( @server_name  NVARCHAR(128) )
AS

DECLARE @rows AS INT = 0;

DELETE FROM [etl].[dim_column]   WHERE [server_name] = @server_name;
SET @rows = @rows + @@ROWCOUNT;

DELETE FROM [etl].[dim_table]    WHERE [server_name] = @server_name;
SET @rows = @rows + @@ROWCOUNT;

DELETE FROM [etl].[dim_database] WHERE [server_name] = @server_name;
SET @rows = @rows + @@ROWCOUNT;

DELETE FROM [etl].[dim_server] WHERE [server_name] = @server_name;
SET @rows = @rows + @@ROWCOUNT;

------------------------------------------------------------------------------------------

DELETE FROM [stg].[dim_column]   WHERE [server_name] = @server_name;
SET @rows = @rows + @@ROWCOUNT;

DELETE FROM [stg].[dim_table]    WHERE [server_name] = @server_name;
SET @rows = @rows + @@ROWCOUNT;

DELETE FROM [stg].[dim_database] WHERE [server_name] = @server_name;
SET @rows = @rows + @@ROWCOUNT;

------------------------------------------------------------------------------------------

DELETE FROM [dbo].[dim_column]   WHERE [server_name] = @server_name;
SET @rows = @rows + @@ROWCOUNT;

DELETE FROM [dbo].[dim_table]    WHERE [server_name] = @server_name;
SET @rows = @rows + @@ROWCOUNT;


SELECT @rows AS [row_count];
GO

/****** Object:  StoredProcedure [dbo].[Change Server Name in Metadata]    Script Date: 8/15/2018 3:38:10 AM ******/
IF EXISTS(SELECT 1 FROM sysobjects WHERE type = 'P' and name = 'Change Server Name in Metadata')
BEGIN
   DROP PROCEDURE [dbo].[Change Server Name in Metadata]
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 08 Oct 2017
-- Modify date: 27 Oct 2017 - Delete 'replace_server_name' metadata rows first
-- 
-- Description:	Deletes all metadata (in the etl and stg schemas) for a provided server name
--
-- Sample Execute Command: 
/*	
EXEC [dbo].[Change Server Name in Metadata]  'find_server_name', 'replace_server_name';
*/
-- ================================================================================================
CREATE PROCEDURE [dbo].[Change Server Name in Metadata] 
( 
	   @find_server_name  NVARCHAR(128)
	 , @replace_server_name  NVARCHAR(128) 
)
AS

EXEC [dbo].[Delete Server Metadata] @replace_server_name

DECLARE @rows AS INT = 0;

UPDATE [etl].[dim_column]
   SET [server_name] = @replace_server_name
 WHERE [server_name] = @find_server_name;

SET @rows = @rows + @@ROWCOUNT;

UPDATE [etl].[dim_database]
   SET [server_name] = @replace_server_name
 WHERE [server_name] = @find_server_name;

SET @rows = @rows + @@ROWCOUNT;

UPDATE [etl].[dim_server]
   SET [server_name] = @replace_server_name
 WHERE [server_name] = @find_server_name;

SET @rows = @rows + @@ROWCOUNT;

UPDATE [etl].[dim_table]
   SET [server_name] = @replace_server_name
 WHERE [server_name] = @find_server_name;

SET @rows = @rows + @@ROWCOUNT;

SELECT @rows AS [row_count];
GO

/****** Object:  StoredProcedure [dbo].[Reset BimlSnap Mart Metadata]    Script Date: 8/15/2018 3:40:02 AM ******/
IF EXISTS(SELECT 1 FROM sysobjects WHERE type = 'P' and name = 'Reset BimlSnap Mart Metadata')
BEGIN
   DROP PROCEDURE [dbo].[Reset BimlSnap Mart Metadata]
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 05 Jun 2017
-- Modify date: 10 Jun 2017 - change for stg.dim_table
--
-- Description:	Resets merge_type columns for the 'bimlsnap_mart_v2' (or currrent) database
--
-- Sample Execute Commands: 
/*
EXEC [dbo].[Reset BimlSnap Mart Metadata]
*/
-- ================================================================================================
CREATE PROCEDURE [dbo].[Reset BimlSnap Mart Metadata]

AS
SET NOCOUNT ON;

DECLARE @snap_mart_db NVARCHAR(128) = DB_NAME()

UPDATE [etl].[dim_database] SET [extract_metadata] = 'Y', [staging_database] = 'Y' WHERE [database_name] = DB_NAME()

UPDATE [etl].[dim_column] SET [merge_type] = 'bk' WHERE [database_name] = @snap_mart_db AND [table_schema] = 'stg' AND [table_name] = 'dim_database' AND [column_name] = 'server_name'
UPDATE [etl].[dim_column] SET [merge_type] = 'bk' WHERE [database_name] = @snap_mart_db AND [table_schema] = 'stg' AND [table_name] = 'dim_database' AND [column_name] = 'database_name'

UPDATE [etl].[dim_column] SET [merge_type] = 'bk' WHERE [database_name] = @snap_mart_db AND [table_schema] = 'stg' AND [table_name] = 'dim_table'    AND [column_name] = 'server_name'
UPDATE [etl].[dim_column] SET [merge_type] = 'bk' WHERE [database_name] = @snap_mart_db AND [table_schema] = 'stg' AND [table_name] = 'dim_table'    AND [column_name] = 'database_name'
UPDATE [etl].[dim_column] SET [merge_type] = 'bk' WHERE [database_name] = @snap_mart_db AND [table_schema] = 'stg' AND [table_name] = 'dim_table'    AND [column_name] = 'table_schema'
UPDATE [etl].[dim_column] SET [merge_type] = 'bk' WHERE [database_name] = @snap_mart_db AND [table_schema] = 'stg' AND [table_name] = 'dim_table'    AND [column_name] = 'table_name'
UPDATE [etl].[dim_column] SET [merge_type] = 't2' WHERE [database_name] = @snap_mart_db AND [table_schema] = 'stg' AND [table_name] = 'dim_table'    AND [column_name] = 'table_type'
UPDATE [etl].[dim_column] SET [merge_type] = 't2' WHERE [database_name] = @snap_mart_db AND [table_schema] = 'stg' AND [table_name] = 'dim_table'    AND [column_name] = 'change_tracking'

UPDATE [etl].[dim_column] SET [merge_type] = 'bk' WHERE [database_name] = @snap_mart_db AND [table_schema] = 'stg' AND [table_name] = 'dim_column'   AND [column_name] = 'server_name'
UPDATE [etl].[dim_column] SET [merge_type] = 'bk' WHERE [database_name] = @snap_mart_db AND [table_schema] = 'stg' AND [table_name] = 'dim_column'   AND [column_name] = 'database_name'
UPDATE [etl].[dim_column] SET [merge_type] = 'bk' WHERE [database_name] = @snap_mart_db AND [table_schema] = 'stg' AND [table_name] = 'dim_column'   AND [column_name] = 'table_schema'
UPDATE [etl].[dim_column] SET [merge_type] = 'bk' WHERE [database_name] = @snap_mart_db AND [table_schema] = 'stg' AND [table_name] = 'dim_column'   AND [column_name] = 'table_name'
UPDATE [etl].[dim_column] SET [merge_type] = 'bk' WHERE [database_name] = @snap_mart_db AND [table_schema] = 'stg' AND [table_name] = 'dim_column'   AND [column_name] = 'column_name'
UPDATE [etl].[dim_column] SET [merge_type] = 't2' WHERE [database_name] = @snap_mart_db AND [table_schema] = 'stg' AND [table_name] = 'dim_column'   AND [column_name] = 'char_max_length'
UPDATE [etl].[dim_column] SET [merge_type] = 't2' WHERE [database_name] = @snap_mart_db AND [table_schema] = 'stg' AND [table_name] = 'dim_column'   AND [column_name] = 'data_type'
UPDATE [etl].[dim_column] SET [merge_type] = 't2' WHERE [database_name] = @snap_mart_db AND [table_schema] = 'stg' AND [table_name] = 'dim_column'   AND [column_name] = 'is_nullable'


SELECT *
  FROM [etl].[dim_database]
 WHERE [database_name] = @snap_mart_db;

SELECT *
  FROM [etl].[dim_column]
 WHERE [database_name] = @snap_mart_db
   AND [merge_type] <> 't1'
 ORDER BY [table_schema]
		, [table_name];
GO





/****** Object:  UserDefinedFunction [dbo].[get all column changes]    Script Date: 8/15/2018 3:42:43 AM ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[get all column changes]')
                    AND type IN (N'FN', N'IF', N'TF', N'FS', N'FT') ) 
    DROP FUNCTION [dbo].[get all column changes]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 10 Dec 2016
-- Modify date: 
-- Description:	Get all metadata column changes
--
-- sample exec:
/*
SELECT * FROM [dbo].[get all column changes] ()
*/
-- ================================================================================================
CREATE FUNCTION [dbo].[get all column changes] ()  
RETURNS TABLE  
AS  
RETURN   
(  
SELECT 'Added' AS [event]
	 , d.*
  FROM [dbo].[dim_column] d
  JOIN [etl].[dim_column] e
    ON e.[database_name] = d.[database_name]
   AND e.[table_schema]  = d.[table_schema]
   AND e.[table_name]    = d.[table_name]
   AND e.[column_name]   = d.[column_name]
 WHERE d.[row_insert_date] = d.[row_update_date]

UNION
		
SELECT 'Changed' AS [event]
	 , d.*
  FROM [dbo].[dim_column] d
  JOIN [etl].[dim_column] e
    ON e.[database_name] = d.[database_name]
   AND e.[table_schema]  = d.[table_schema]
   AND e.[table_name]    = d.[table_name]
   AND e.[column_name]   = d.[column_name]
 WHERE d.[row_insert_date] <> d.[row_update_date]
		
UNION

SELECT 'Deleted' AS [event]
	 , d.*
  FROM [dbo].[dim_column] d
  LEFT JOIN [etl].[dim_column] e
    ON e.[database_name] = d.[database_name]
   AND e.[table_schema]  = d.[table_schema]
   AND e.[table_name]    = d.[table_name]
   AND e.[column_name]   = d.[column_name]
 WHERE e.[database_name] IS NULL
);  
GO

/****** Object:  UserDefinedFunction [dbo].[get all insert and update dates]    Script Date: 8/15/2018 3:43:19 AM ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[get all insert and update dates]')
                    AND type IN (N'FN', N'IF', N'TF', N'FS', N'FT') ) 
    DROP FUNCTION [dbo].[get all insert and update dates]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 10 Dec 2016
-- Modify date: 
-- Description:	Get all dimension insert and update dates
--
-- sample exec:
/*
SELECT * FROM [dbo].[get all insert and update dates] ()
*/
-- ================================================================================================
CREATE FUNCTION [dbo].[get all insert and update dates] ()  
RETURNS TABLE  
AS  
RETURN   
(  
	SELECT DISTINCT [row_insert_date] AS [pick_date]
	  FROM [dbo].[dim_table]
	UNION 
	SELECT DISTINCT [row_update_date] AS [pick_date]
	  FROM [dbo].[dim_table]
	UNION
	SELECT DISTINCT [row_insert_date] AS [pick_date]
	  FROM [dbo].[dim_column]
	UNION 
	SELECT DISTINCT [row_update_date] AS [pick_date]
	  FROM [dbo].[dim_column]
);  
GO

/****** Object:  UserDefinedFunction [dbo].[get all table changes]    Script Date: 8/15/2018 3:43:42 AM ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[get all table changes]')
                    AND type IN (N'FN', N'IF', N'TF', N'FS', N'FT') ) 
    DROP FUNCTION [dbo].[get all table changes]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 10 Dec 2016
-- Modify date: 
-- Description:	Get all metadata table changes
--
-- sample exec:
/*
SELECT * FROM [dbo].[get all table changes] ()
*/
-- ================================================================================================
CREATE FUNCTION [dbo].[get all table changes] ()  
RETURNS TABLE  
AS  
RETURN   
(  
SELECT 'Added' AS [event]
	 , d.*
  FROM [dbo].[dim_table] d
  JOIN [etl].[dim_table] e
    ON e.[database_name] = d.[database_name]
   AND e.[table_schema]  = d.[table_schema]
   AND e.[table_name]    = d.[table_name]
 WHERE d.[row_insert_date] = d.[row_update_date]

UNION
		
SELECT 'Changed' AS [event]
	 , d.*
  FROM [dbo].[dim_table] d
  JOIN [etl].[dim_table] e
    ON e.[database_name] = d.[database_name]
   AND e.[table_schema]  = d.[table_schema]
   AND e.[table_name]    = d.[table_name]
 WHERE d.[row_insert_date] <> d.[row_update_date]
		
UNION

SELECT 'Deleted' AS [event]
	 , d.*
  FROM [dbo].[dim_table] d
  LEFT JOIN [etl].[dim_table] e
    ON e.[database_name] = d.[database_name]
   AND e.[table_schema]  = d.[table_schema]
   AND e.[table_name]    = d.[table_name]
 WHERE e.[database_name] IS NULL
);  
GO