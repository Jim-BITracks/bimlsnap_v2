/*
BSD 3-Clause License

Copyright (c) 2018, BI Tracks Consulting, LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

USE [master]
GO
CREATE DATABASE [bimlsnap_mart_v2];
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [bimlsnap_mart_v2].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [bimlsnap_mart_v2] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET ARITHABORT OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET  DISABLE_BROKER 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET  MULTI_USER 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [bimlsnap_mart_v2] SET DB_CHAINING OFF 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [bimlsnap_mart_v2] SET QUERY_STORE = OFF
GO
USE [bimlsnap_mart_v2]
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [bimlsnap_mart_v2]
GO
/****** Object:  Schema [biml]    Script Date: 4/28/2018 1:39:16 PM ******/
CREATE SCHEMA [biml]
GO
/****** Object:  Schema [etl]    Script Date: 4/28/2018 1:39:16 PM ******/
CREATE SCHEMA [etl]
GO
/****** Object:  Schema [html]    Script Date: 4/28/2018 1:39:16 PM ******/
CREATE SCHEMA [html]
GO
/****** Object:  Schema [jtts]    Script Date: 4/28/2018 1:39:16 PM ******/
CREATE SCHEMA [jtts]
GO
/****** Object:  Schema [stg]    Script Date: 4/28/2018 1:39:16 PM ******/
CREATE SCHEMA [stg]
GO
/****** Object:  Table [etl].[dim_table]    Script Date: 4/28/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [etl].[dim_table](
	[server_name] [nvarchar](128) NOT NULL,
	[database_name] [nvarchar](128) NOT NULL,
	[table_schema] [nvarchar](128) NOT NULL,
	[table_name] [nvarchar](128) NOT NULL,
	[table_type] [nvarchar](32) NOT NULL,
	[has_identity] [nvarchar](1) NOT NULL,
	[has_primary_key] [nvarchar](1) NOT NULL,
	[enable_change_tracking] [nvarchar](1) NOT NULL,
 CONSTRAINT [PK_etl_dim_table] PRIMARY KEY CLUSTERED 
(
	[server_name] ASC,
	[database_name] ASC,
	[table_schema] ASC,
	[table_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dim_table]    Script Date: 4/28/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [CIX dbo dim_table]    Script Date: 4/28/2018 1:39:16 PM ******/
CREATE CLUSTERED INDEX [CIX dbo dim_table] ON [dbo].[dim_table]
(
	[server_name] ASC,
	[database_name] ASC,
	[table_schema] ASC,
	[table_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[get all table changes]    Script Date: 4/28/2018 1:39:16 PM ******/
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
/****** Object:  Table [dbo].[dim_column]    Script Date: 4/28/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [CIX dbo dim_column]    Script Date: 4/28/2018 1:39:17 PM ******/
CREATE CLUSTERED INDEX [CIX dbo dim_column] ON [dbo].[dim_column]
(
	[server_name] ASC,
	[database_name] ASC,
	[table_schema] ASC,
	[table_name] ASC,
	[column_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[get all insert and update dates]    Script Date: 4/28/2018 1:39:17 PM ******/
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
/****** Object:  Table [etl].[dim_column]    Script Date: 4/28/2018 1:39:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [etl].[dim_column](
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
	[merge_type] [nvarchar](2) NOT NULL,
 CONSTRAINT [PK_etl_dim_column] PRIMARY KEY CLUSTERED 
(
	[server_name] ASC,
	[database_name] ASC,
	[table_schema] ASC,
	[table_name] ASC,
	[column_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[get all column changes]    Script Date: 4/28/2018 1:39:17 PM ******/
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
/****** Object:  Table [etl].[dim_database]    Script Date: 4/28/2018 1:39:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [etl].[dim_database](
	[server_name] [nvarchar](128) NOT NULL,
	[database_name] [nvarchar](128) NOT NULL,
	[database_create_date] [date] NOT NULL,
	[change_tracking_enabled] [nvarchar](1) NOT NULL,
	[extract_metadata] [nvarchar](1) NOT NULL,
	[staging_database] [nvarchar](1) NOT NULL,
 CONSTRAINT [PK_dbo_dim_database] PRIMARY KEY CLUSTERED 
(
	[server_name] ASC,
	[database_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [etl].[dim_server]    Script Date: 4/28/2018 1:39:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [etl].[dim_server](
	[server_name] [nvarchar](128) NOT NULL,
	[server_type] [nvarchar](64) NOT NULL,
	[comments] [nvarchar](2000) NULL,
 CONSTRAINT [PK_etl_dim_server] PRIMARY KEY CLUSTERED 
(
	[server_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [stg].[dim_column]    Script Date: 4/28/2018 1:39:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [stg].[dim_database]    Script Date: 4/28/2018 1:39:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  Table [stg].[dim_table]    Script Date: 4/28/2018 1:39:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
ALTER TABLE [etl].[dim_column] ADD  CONSTRAINT [DF__dim_column__merge_type]  DEFAULT ('t1') FOR [merge_type]
GO
ALTER TABLE [etl].[dim_server] ADD  CONSTRAINT [DF etl dim_server src_query]  DEFAULT ('SQL Server') FOR [server_type]
GO
ALTER TABLE [etl].[dim_column]  WITH CHECK ADD  CONSTRAINT [CC etl_dim_column primary_key] CHECK  (([primary_key]='Y' OR [primary_key]='N'))
GO
ALTER TABLE [etl].[dim_column] CHECK CONSTRAINT [CC etl_dim_column primary_key]
GO
ALTER TABLE [etl].[dim_database]  WITH CHECK ADD  CONSTRAINT [CC_etl_dim_database change_tracking_enabled] CHECK  (([change_tracking_enabled]='Y' OR [change_tracking_enabled]='N'))
GO
ALTER TABLE [etl].[dim_database] CHECK CONSTRAINT [CC_etl_dim_database change_tracking_enabled]
GO
ALTER TABLE [etl].[dim_database]  WITH CHECK ADD  CONSTRAINT [CC_etl_dim_database extract_metadata] CHECK  (([extract_metadata]='Y' OR [extract_metadata]='N'))
GO
ALTER TABLE [etl].[dim_database] CHECK CONSTRAINT [CC_etl_dim_database extract_metadata]
GO
ALTER TABLE [etl].[dim_database]  WITH CHECK ADD  CONSTRAINT [CC_etl_dim_database staging_database] CHECK  (([staging_database]='Y' OR [staging_database]='N'))
GO
ALTER TABLE [etl].[dim_database] CHECK CONSTRAINT [CC_etl_dim_database staging_database]
GO
ALTER TABLE [etl].[dim_table]  WITH CHECK ADD  CONSTRAINT [CC etl dim_table enable_change_tracking] CHECK  (([enable_change_tracking]='Y' OR [enable_change_tracking]='N'))
GO
ALTER TABLE [etl].[dim_table] CHECK CONSTRAINT [CC etl dim_table enable_change_tracking]
GO
ALTER TABLE [etl].[dim_table]  WITH CHECK ADD  CONSTRAINT [CC etl dim_table has_identity] CHECK  (([has_identity]='Y' OR [has_identity]='N'))
GO
ALTER TABLE [etl].[dim_table] CHECK CONSTRAINT [CC etl dim_table has_identity]
GO
ALTER TABLE [etl].[dim_table]  WITH CHECK ADD  CONSTRAINT [CC etl dim_table has_primary_key] CHECK  (([has_primary_key]='Y' OR [has_primary_key]='N'))
GO
ALTER TABLE [etl].[dim_table] CHECK CONSTRAINT [CC etl dim_table has_primary_key]
GO
/****** Object:  StoredProcedure [dbo].[Change Server Name in Metadata]    Script Date: 4/28/2018 1:39:17 PM ******/
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
/****** Object:  StoredProcedure [dbo].[Delete Server Metadata]    Script Date: 4/28/2018 1:39:17 PM ******/
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
/****** Object:  StoredProcedure [dbo].[Reset BimlSnap Mart Metadata]    Script Date: 4/28/2018 1:39:17 PM ******/
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
/****** Object:  StoredProcedure [dbo].[Sync All Server Metadata]    Script Date: 4/28/2018 1:39:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 08 Oct 2017
-- Modify date: 
-- Description:	Sync all metadata (NOTE: database names are hardcoded!)
--
-- Sample Execute Command: 
/*	
EXEC [dbo].[Sync All Server Metadata];
*/
-- ================================================================================================

CREATE PROCEDURE [dbo].[Sync All Server Metadata]
AS


DECLARE @rows AS INT = 0;

TRUNCATE TABLE [bimlsnap_v2].[etl].[dim_column];
TRUNCATE TABLE [bimlsnap_v2].[etl].[dim_table];
TRUNCATE TABLE [bimlsnap_v2].[etl].[dim_database];
TRUNCATE TABLE [bimlsnap_v2].[etl].[dim_server];


INSERT [bimlsnap_v2].[etl].[dim_server]
SELECT *
  FROM [bimlsnap_mart_v2].[etl].[dim_server];

  SET @rows = @rows + @@ROWCOUNT;


INSERT [bimlsnap_v2].[etl].[dim_database]
SELECT *
  FROM [bimlsnap_mart_v2].[etl].[dim_database];

  SET @rows = @rows + @@ROWCOUNT;


INSERT [bimlsnap_v2].[etl].[dim_table]
SELECT *
  FROM [bimlsnap_mart_v2].[etl].[dim_table];

  SET @rows = @rows + @@ROWCOUNT;


INSERT [bimlsnap_v2].[etl].[dim_column]
SELECT *
  FROM [bimlsnap_mart_v2].[etl].[dim_column];

  SET @rows = @rows + @@ROWCOUNT;


SELECT @rows AS [row_count];

GO
/****** Object:  StoredProcedure [jtts].[Json Table Export]    Script Date: 4/28/2018 1:39:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ========================================================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 01 Feb 2017
-- Modify date: 01 Feb 2017 - Added Snapshot Label
-- Modify date: 18 Feb 2017 - Added explicit table name(s) parameter - Comma separated (NOTE: will not work with extraneous whitespace!)
--																	 - Table schema defaults to 'dbo.' if none provided
-- Modify date: 04 Mar 2017 - Added @action parameter
-- Modify date: 07 Mar 2017 - Changed to use temp table: #export_table
-- Modify date: 15 Mar 2017 - Added SQL Platform and Product Version
-- Modify date: 20 Mar 2017 - Changed @label to be optional paramater (replaced by partial guid) 
--
-- Description:	Json Export of Database Tables
--
-- Sample Execute Commands: 
/*
EXEC [jtts].[Json Table Export] 'Exp_Test', 'all'
EXEC [jtts].[Json Table Export] 'metadata', 'include', 'etl.dim_column,etl.dim_database,etl.dim_server,etl.dim_table'
EXEC [jtts].[Json Table Export] 'FQ-v1', 'exclude', 'biml.application_config'
*/
--
-- ========================================================================================================================================

CREATE PROCEDURE [jtts].[Json Table Export]
(
	 @label NVARCHAR(8)
   , @action NVARCHAR(8)
   , @tables NVARCHAR(MAX) = ''
)
AS

/* return values with initial settings */
DECLARE	@return_code AS INT = 1 /* error setting */
	  , @error_message AS NVARCHAR(2000) = '<not set>';

IF ( RTRIM(COALESCE( @label, '' )) = '' )
	BEGIN
		SET @label = LEFT(CONVERT(VARCHAR(64), NEWID()),8)
	END

IF @action NOT IN ('all', 'include', 'exclude')
	BEGIN
		SET @error_message = '@action parameter must be either ''all'', ''include'', or ''exclude'''
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

IF @action = 'all' AND RTRIM(ISNULL(@tables, '')) != ''
	BEGIN
		SET @error_message = 'Cannot combine a list of tables with the @action parameter of ''all'''
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

IF @action IN ('include', 'exclude') AND RTRIM(ISNULL(@tables, '')) = ''
	BEGIN
		SET @error_message = 'Must provide an explicit list of tables when using the @action parameter of ''include'', or ''exclude'''
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

IF CHARINDEX('[', @tables) + CHARINDEX(']', @tables) > 0
	BEGIN
		SET @error_message = 'Must remove [ and ] delimiters'
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END


/* 
	Determine list of tables to include in Export 
*/
DECLARE @include_tables AS TABLE([TABLE_SCHEMA] NVARCHAR(255), [TABLE_NAME] NVARCHAR(255));
DECLARE @table_list AS TABLE([TABLE] NVARCHAR(255));
DECLARE @table_not_found AS TABLE([TABLE] NVARCHAR(255));

DECLARE @table_not_found_count AS INT
	  , @table_not_found_item AS NVARCHAR(255);

/* get list of potential database tables to replicate */
INSERT @include_tables
SELECT [TABLE_SCHEMA], [TABLE_NAME]
FROM INFORMATION_SCHEMA.TABLES
WHERE [TABLE_TYPE] = 'BASE TABLE';

/* revise full @include_tables list based on @action and list in @tables parameter */
IF NOT RTRIM(ISNULL(@tables, '')) = ''
BEGIN
	INSERT @table_list
	SELECT value
	FROM STRING_SPLIT(@tables, ',')  
	WHERE RTRIM(value) <> '';  

	/* add 'dbo' schema name if not provided */
	UPDATE @table_list
	   SET [TABLE] = 'dbo.' + [TABLE]
	 WHERE CHARINDEX('.', [TABLE]) = 0


	/* check for table not found */
	INSERT @table_not_found
	SELECT tl.[TABLE]
		FROM @table_list tl
		LEFT JOIN @include_tables pt
		ON pt.[TABLE_SCHEMA] + '.' + pt.[TABLE_NAME] = tl.[TABLE]
		WHERE pt.[TABLE_NAME] IS NULL

	SELECT @table_not_found_count = COUNT(*) 
	  FROM @table_not_found

	IF @table_not_found_count != 0
		BEGIN
			SELECT TOP 1 @table_not_found_item = [TABLE] FROM @table_not_found
			SET @error_message = 'Table Not Found: ''' + @table_not_found_item + ''''
			SELECT @return_code AS [return code], @error_message AS [error message]
			RETURN
		END


	IF @action = 'include'
		DELETE @include_tables
		  FROM @include_tables pt
		  LEFT JOIN @table_list tl
			ON tl.[TABLE] = pt.[TABLE_SCHEMA] + '.' + pt.[TABLE_NAME]
		 WHERE tl.[TABLE] IS NULL

	IF @action = 'exclude'
		DELETE @include_tables
		  FROM @include_tables pt
		  JOIN @table_list tl
			ON tl.[TABLE] = pt.[TABLE_SCHEMA] + '.' + pt.[TABLE_NAME]

END


/* 
	Json Export Code
*/

DECLARE @ParmDefinition NVARCHAR(4000)
	  , @ReturnCode INT
	  , @ResultSet NVARCHAR(MAX)
	  , @SchemaResultSetSelect NVARCHAR(4000)
	  , @SchemaResultSet NVARCHAR(4000)
	  , @SQLString NVARCHAR(4000)
	  , @RowCountSelect NVARCHAR(4000)
	  , @Json NVARCHAR(MAX)
	  , @FileName NVARCHAR(255);

DECLARE @SchemaName NVARCHAR(255)
	  , @TableName NVARCHAR(255)
	  , @sql NVARCHAR(4000)
	  , @xml XML
	  , @BegTime DATETIME
	  , @EndTime DATETIME;

SET @BegTime = GETDATE()


CREATE TABLE #export_table(
	[schema_name] [nvarchar](255) NOT NULL,
	[table_name] [nvarchar](255) NOT NULL,
	[schema_result_set] [nvarchar](max) NOT NULL,
	[result_set] [nvarchar](max) NULL,
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


DECLARE MY_CURSOR CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY
    FOR 
 SELECT [TABLE_SCHEMA], [TABLE_NAME]
   FROM @include_tables
   OPEN MY_CURSOR
  FETCH NEXT FROM MY_CURSOR INTO @SchemaName, @TableName
  WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Processing Table: [' + @SchemaName + '].[' + @TableName + ']'

		/* convert schema/table into a SELECT statement */
		SET @SQLString = 'SELECT * FROM [' + @SchemaName + '].[' + @TableName + ']'

		SET @SchemaResultSetSelect =
			'SELECT is_hidden, column_ordinal, [name], is_nullable, system_type_id, system_type_name, max_length, [precision], scale, is_identity_column, is_computed_column
				FROM sys.dm_exec_describe_first_result_set ( ''' + @SQLString + ''', N'''', 0 ) '

		SET @SchemaResultSetSelect = N'SET @Result_Set_OUT = ( ' + @SchemaResultSetSelect + ' FOR JSON AUTO )';

		SET @SQLString = N'SET @Result_Set_OUT = ( ' + @SQLString + ' FOR JSON AUTO )';
		SET @ParmDefinition = N'@Result_Set_OUT NVARCHAR(MAX) OUTPUT';

		/* get schema */
		BEGIN TRY
			EXECUTE @ReturnCode = sp_executesql
					@SchemaResultSetSelect
				  , @ParmDefinition
				  , @Result_Set_OUT = @SchemaResultSet OUTPUT;
		END TRY
		BEGIN CATCH
			SET @error_message = 'get schema: ' + ERROR_MESSAGE()
			SELECT @return_code AS [return code], @error_message AS [error message]
			RETURN
		END CATCH

		/* get result set */
		BEGIN TRY
			EXECUTE @ReturnCode = sp_executesql
					@SQLString
				  , @ParmDefinition
				  , @Result_Set_OUT = @ResultSet OUTPUT;
		END TRY
		BEGIN CATCH
			SET @error_message = 'get result set: ' + ERROR_MESSAGE()
			PRINT @error_message
			RETURN
		END CATCH

		/* #export_table insert */
		BEGIN TRY

			INSERT #export_table
			SELECT @SchemaName AS [schema_name]
				 , @TableName AS [table_name]
				 , @SchemaResultSet AS [schema_result_set]
				 , @ResultSet AS [result_set];
		END TRY
		BEGIN CATCH
			SET @error_message = '#export_table insert: ' + ERROR_MESSAGE()
			SELECT @return_code AS [return code], @error_message AS [error message]
			RETURN
		END CATCH

	FETCH NEXT FROM MY_CURSOR INTO @SchemaName, @TableName
  END
CLOSE MY_CURSOR
DEALLOCATE MY_CURSOR


/* ---------------------------------- 
        Combined Json Export 
------------------------------------- */

/* convert schema/table into a SELECT statement */
SET @SQLString = 'SELECT * FROM #export_table'

SET @SchemaResultSetSelect =
	'SELECT is_hidden, column_ordinal, [name], is_nullable, system_type_id, system_type_name, max_length, [precision], scale, is_identity_column, is_computed_column
		FROM tempdb.sys.dm_exec_describe_first_result_set ( ''' + @SQLString + ''', N'''', 0 ) '

SET @SchemaResultSetSelect = N'SET @Result_Set_OUT = ( ' + @SchemaResultSetSelect + ' FOR JSON AUTO )';

SET @SQLString = N'SET @Result_Set_OUT = ( ' + @SQLString + ' FOR JSON AUTO )';
SET @ParmDefinition = N'@Result_Set_OUT NVARCHAR(MAX) OUTPUT';

/* get combined schema */
BEGIN TRY
--print @SchemaResultSetSelect
	EXECUTE @ReturnCode = sp_executesql
			@SchemaResultSetSelect
		  , @ParmDefinition
		  , @Result_Set_OUT = @SchemaResultSet OUTPUT;
END TRY
BEGIN CATCH
	SET @error_message = 'get combined schema: ' + ERROR_MESSAGE()
	SELECT @return_code AS [return code], @error_message AS [error message]
	RETURN
END CATCH

/* get combined result set */
BEGIN TRY
	EXECUTE @ReturnCode = sp_executesql
			@SQLString
		  , @ParmDefinition
		  , @Result_Set_OUT = @ResultSet OUTPUT;
END TRY
BEGIN CATCH
	SET @error_message = 'get combined result set: ' + ERROR_MESSAGE()
	SELECT @return_code AS [return code], @error_message AS [error message]
	RETURN
END CATCH

SET @EndTime = GETDATE()

SET @Json =
(
SELECT @@SERVERNAME AS [server_name]
	 , DB_NAME() AS [database_name]
	 , N'SQL Server' AS [sql_platform]
	 , CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(64)) AS [product_version]
	 , @BegTime AS [start_time]
	 , @EndTime AS [end_time]
	 , @SchemaResultSet AS [combined_select_schema]
	 , @ResultSet AS [combined_result_set]
FOR JSON PATH, INCLUDE_NULL_VALUES
);


SET @FileName = 'JTTS_Exp_' + REPLACE(REPLACE(CONVERT(VARCHAR, GETDATE(), 126), ':', '-'), '.', '-') + '_Label-' + @label + '.json'

/* insert json file table */
BEGIN TRY
	INSERT INTO [FileTableDB].[dbo].[JTTS_Out] ( name, file_stream ) 
	SELECT @FileName, CAST(@Json AS VARBINARY(MAX));
END TRY
BEGIN CATCH
	SET @error_message = 'insert json file table: ' + ERROR_MESSAGE()
	SELECT @return_code AS [return code], @error_message AS [error message]
	RETURN
END CATCH

/* json #export_table clean-up */
DROP TABLE #export_table

SET @return_code = 0
SET @error_message = ''

PRINT 'Export Complete!'

SELECT @return_code AS [return code], @FileName AS [json file]


GO
/****** Object:  StoredProcedure [jtts].[Json Table Import]    Script Date: 4/28/2018 1:39:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 01 Feb 2017
-- Modify date: 04 Feb 2017 - Check for import file existance
-- Modify date: 05 Feb 2017 - Added 'Database Name Override Option'
-- Modify date: 18 Feb 2017 - Added 'destination table' exists check
-- Modify date: 23 Feb 2017 - Added @Use_JTTS_Out_Directory option
-- Modify date: 23 Feb 2017 - Added explicit table name(s) parameter - Comma separated (NOTE: will not work with extraneous whitespace!)
--																	 - Table schema defaults to 'dbo.' if none provided
-- Modify date: 06 Mar 2017 - Changed to use temp table: #import_table
-- Modify date: 09 Mar 2017 - Added check for aligned Json file
-- Modify date: 15 Mar 2017 - Added SQL Platform and Product Version Check
-- Modify date: 12 Jul 2017 - Changed 'Identity Insert' option to be determined by the 'destination' table definition
--
-- Description:	Json Import of Database Table Set
-- Sample Execute Command: 
/*
EXEC [jtts].[Json Table Import] 'JTTS_Exp_2017-03-09T10-37-41-540_Label-Exp_Test.json', 'N', 'N', 'Y'
EXEC [jtts].[Json Table Import] 'JTTS_Exp_2017-02-23T11-17-27-247_Label-Metadata.json', 'N', 'N', 'Y', 'dbo.dim_column,dbo.dim_table,etl.dim_column,etl.dim_database,etl.dim_table,stg.dim_column,stg.dim_database'
*/
-- ================================================================================================

CREATE PROCEDURE [jtts].[Json Table Import]
	(
		 @FileName NVARCHAR(255)
	   , @DatabaseNameOverrideOption NVARCHAR(1) = N'N'
	   , @IgnoreMissingDestinationTables NVARCHAR(1) = N'N'
	   , @Use_JTTS_Out_Directory NVARCHAR(1) = N'N'
	   , @tables NVARCHAR(MAX) = N''
	)
AS

/* return values */
DECLARE	@return_code AS INT = 1 /* error setting */
	  , @error_message AS NVARCHAR(2000) = '<not set>';

IF ( COALESCE( @FileName, '' ) = '' )
	BEGIN
		SET @error_message = 'Must provide filename to Import.'
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

IF NOT EXISTS ( SELECT 1 FROM [FileTableDB].[dbo].[JTTS_In] WHERE [name] = @FileName ) AND @Use_JTTS_Out_Directory != 'Y'
	BEGIN
		SET @error_message = 'Import File Not Found in ''JTTS_In_Dir'' Folder: ' + @FileName
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

IF NOT EXISTS ( SELECT 1 FROM [FileTableDB].[dbo].[JTTS_Out] WHERE [name] = @FileName ) AND @Use_JTTS_Out_Directory = 'Y'
	BEGIN
		SET @error_message = 'Import File Not Found in ''JTTS_Out_Dir'' Folder: ' + @FileName
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

IF CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(64)) < '13.0.4001.0'
	BEGIN
		SET @error_message = 'Must use destination SQL Server version of 13.0.4001.0 or greater. Running on version: ' + CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(64))
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

/* 
	Determine list of tables to include in Import 
*/
DECLARE @include_tables AS TABLE([TABLE_SCHEMA] NVARCHAR(255), [TABLE_NAME] NVARCHAR(255));
DECLARE @table_list AS TABLE([TABLE] NVARCHAR(255));
DECLARE @table_not_found AS TABLE([TABLE] NVARCHAR(255));

DECLARE @table_not_found_count AS INT
	  , @table_not_found_item AS NVARCHAR(255);

/* get list of potential database tables to replicate */
INSERT @include_tables
SELECT [TABLE_SCHEMA], [TABLE_NAME]
FROM INFORMATION_SCHEMA.TABLES
WHERE [TABLE_TYPE] = 'BASE TABLE';

/* revise full @include_tables list based on explicit list in @tables parameter */
IF NOT RTRIM(ISNULL(@tables, '')) = ''
BEGIN
	INSERT @table_list
	SELECT value
	FROM STRING_SPLIT(@tables, ',')  
	WHERE RTRIM(value) <> '';  

	/* add 'dbo' schema name if not provided */
	UPDATE @table_list
	   SET [TABLE] = 'dbo.' + [TABLE]
	 WHERE CHARINDEX('.', [TABLE]) = 0

	DELETE @include_tables
	  FROM @include_tables pt
	  LEFT JOIN @table_list tl
	    ON tl.[TABLE] = pt.[TABLE_SCHEMA] + '.' + pt.[TABLE_NAME]
	 WHERE tl.[TABLE] IS NULL

	/* check for table not found */
	INSERT @table_not_found
	SELECT tl.[TABLE]
	  FROM @table_list tl
	  LEFT JOIN @include_tables pt
	    ON pt.[TABLE_SCHEMA] + '.' + pt.[TABLE_NAME] = tl.[TABLE]
	 WHERE pt.[TABLE_NAME] IS NULL

	SELECT @table_not_found_count = COUNT(*) 
	  FROM @table_not_found

	IF @table_not_found_count != 0 AND @IgnoreMissingDestinationTables = 'N'
		BEGIN
			SELECT TOP 1 @table_not_found_item = [TABLE] FROM @table_not_found
			SET @error_message = 'Destination Table Not Found: ''' + @table_not_found_item + ''''
			SELECT @return_code AS [return code], @error_message AS [error message]
			RETURN
		END

	IF @table_not_found_count != 0
		BEGIN
			PRINT 'Warning: One or more destination files not found! @IgnoreMissingDestinationTables option is set to ''Y'''
		END
END

--select * from @include_tables

DECLARE @SchemaResultSetSelect NVARCHAR(4000)
	  , @SchemaResultSet NVARCHAR(4000)
	  , @SQLString NVARCHAR(4000)
	  , @ParmDefinition NVARCHAR(4000)
	  , @SchemaName NVARCHAR(255)
	  , @TableName NVARCHAR(255)
	  , @RowCountSelect NVARCHAR(4000)
	  , @RowJson NVARCHAR(MAX)
	  , @SchemaJson NVARCHAR(MAX)
	  , @ColumnXML XML
	  , @ColumnSTR VARCHAR(MAX)
	  , @WithXML XML
      , @WithSTR VARCHAR(MAX)
	  , @sql NVARCHAR(MAX)
	  , @Json NVARCHAR(MAX)
	  , @sql_platform NVARCHAR(64)
	  , @product_version NVARCHAR(64)
	  , @ReturnCode INT
	  , @ResultSet NVARCHAR(MAX)
	  , @IdentityInsertColumnSum INT
	  , @IsIdentityInsert NVARCHAR(1);

DECLARE @ServerName NVARCHAR(255)
	  , @DatabaseName NVARCHAR(255)
	  , @BegTime DATETIME
	  , @EndTime DATETIME;

IF @Use_JTTS_Out_Directory = 'Y'
	SELECT @RowJson = CAST([file_stream] AS NVARCHAR(MAX)) FROM [FileTableDB].[dbo].[JTTS_Out] WHERE [name] = @FileName
ELSE
	SELECT @RowJson = CAST([file_stream] AS NVARCHAR(MAX)) FROM [FileTableDB].[dbo].[JTTS_In] WHERE [name] = @FileName;

SELECT @sql_platform = [sql_platform]
	 , @product_version = [product_version]
	 , @ServerName = [server_name]
	 , @DatabaseName = [database_name]
	 , @BegTime = [start_time]
	 , @EndTime = [end_time]
	 , @SchemaJson = [combined_select_schema]
	 , @Json = [combined_result_set]
  FROM OPENJSON(@RowJson) 
  WITH (   [sql_platform] [nvarchar](64)
		 , [product_version] [nvarchar](64)
		 , [server_name] [nvarchar](255)  
		 , [database_name] [nvarchar](255)
		 , [bimlsnap_version] [nvarchar](16)
		 , [start_time] [nvarchar](255)
		 , [end_time] [nvarchar](255)
		 , [combined_select_schema] [nvarchar](max)
		 , [combined_result_set] [nvarchar](max)
		 ) rc;

IF @sql_platform != N'SQL Server'
	BEGIN
		SET @error_message = 'This Import does not support the Originating SQL Platform of: ' + @sql_platform
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

IF @product_version < '13.0.4001.0'
	BEGIN
		SET @error_message = 'The Originating SQL Product Version is: ' + @product_version + '. This import requires a minimum Originating version of 13.0.4001.0'
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

IF @Json IS NULL
	BEGIN
		SET @error_message = 'Json [combined_result_set] is null'
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END


/* Database Name check */
IF @DatabaseName <> DB_NAME() AND @DatabaseNameOverrideOption <> N'Y'
	BEGIN
		SET @error_message = 'Database names are Different. Attempting to Import into Database: ' + DB_NAME() + ', with an Export from Database: ' + @DatabaseName + '. Must use the Database Override Parameter for this Import action.'
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END


/* 
	Json Import Set-up
*/

/* Populate #import_table */
SELECT [schema_name]
	 , [table_name]
	 , [schema_result_set]
	 , [result_set] 
  INTO #import_table
  FROM OPENJSON(@Json) 
  WITH ( [schema_name] nvarchar(255)
       , [table_name] nvarchar(255)
       , [schema_result_set] nvarchar(max)
       , [result_set] nvarchar(max) )

  DECLARE @tableMetadata TABLE
		( [is_hidden] BIT
		, [column_ordinal] INT
		, [name] NVARCHAR(256)
		, [is_nullable] [bit]
		, [system_type_id] [int]
		, [system_type_name] [nvarchar](128)
		, [max_length] [smallint]
		, [precision] [tinyint]
		, [scale] [tinyint]
		, [is_identity_column] [bit]
		, [is_computed_column] [bit] );

/*
	json file VALIDATION
*/
DELETE @table_not_found;

IF NOT RTRIM(ISNULL(@tables, '')) = ''
	BEGIN
		/* Logic driven by: explicit list of tables provided -- verify all @include table names exist in json file */
		INSERT @table_not_found
		SELECT [TABLE_SCHEMA] + '.' + [TABLE_NAME] AS [TABLE]
		  FROM @include_tables
	   EXCEPT
		SELECT [schema_name] + '.' + [table_name] AS [TABLE]
		  FROM #import_table

		SELECT @table_not_found_count = COUNT(*) 
		  FROM @table_not_found

		IF @table_not_found_count != 0
			BEGIN
				SELECT TOP 1 @table_not_found_item = [TABLE] FROM @table_not_found
				SET @error_message = 'Table Not Found in JSON file: ''' + @table_not_found_item + ''''
				SELECT @return_code AS [return code], @error_message AS [error message]
				RETURN
			END
	END
ELSE
	BEGIN
		/* Logic driven by: JSON file -- verify all JSON based tables also exist as a destination table (note: includes Ignore option) */
		INSERT @table_not_found
		SELECT [schema_name] + '.' + [table_name] AS [TABLE]
		  FROM #import_table
	   EXCEPT
		SELECT [TABLE_SCHEMA] + '.' + [TABLE_NAME] AS [TABLE]
		  FROM @include_tables -- in this case would have all potential destination tables

		SELECT @table_not_found_count = COUNT(*) 
		  FROM @table_not_found

		IF @table_not_found_count != 0 AND @IgnoreMissingDestinationTables = 'N'
			BEGIN
				SELECT TOP 1 @table_not_found_item = [TABLE] FROM @table_not_found
				SET @error_message = 'Destination Table Not Found: ''' + @table_not_found_item + ''''
				SELECT @return_code AS [return code], @error_message AS [error message]
				RETURN
			END

		IF @table_not_found_count != 0
			BEGIN
				PRINT 'Warning: One or more destination files not found! @IgnoreMissingDestinationTables option is set to ''Y'''
			END
	END


/* 
	Json IMPORT Code - Iterate through import_table, truncate and populate for each table row 
*/
DECLARE MY_CURSOR CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY
    FOR 
 SELECT t.[schema_name], t.[table_name], t.[schema_result_set]
   FROM #import_table t
   JOIN @include_tables i
     ON i.[TABLE_SCHEMA] = t.[schema_name]
	AND i.[TABLE_NAME] = t.[table_name]
   OPEN MY_CURSOR
  FETCH NEXT FROM MY_CURSOR INTO @SchemaName, @TableName, @SchemaResultSet
  WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Processing Table: [' + @SchemaName + '].[' + @TableName + ']'

	BEGIN TRY

		SET NOCOUNT ON;

		DELETE @tableMetadata;

		WITH [result schema] AS
		(
		SELECT * FROM  
		OPENJSON(@SchemaResultSet)  
		WITH ( [is_hidden] BIT
			 , [column_ordinal] INT
			 , [name] NVARCHAR(256)
			 , [is_nullable] [bit]
			 , [system_type_id] [int]
			 , [system_type_name] [nvarchar](128)
			 , [max_length] [smallint]
			 , [precision] [tinyint]
			 , [scale] [tinyint]
			 , [is_identity_column] [bit]
			 , [is_computed_column] [bit]
			 )  
		)
		INSERT @tableMetadata
		SELECT * 
		  FROM [result schema];

	/* determine if identity insert is needed */
	--SELECT @IdentityInsertColumnSum = SUM(CAST([is_identity_column] AS INT)) FROM @tableMetadata

	SET @sql = 'SELECT @Result_Set_OUT = SUM(CAST([is_identity_column] AS INT)) FROM sys.dm_exec_describe_first_result_set ( ''SELECT * FROM [' + @SchemaName + '].[' + @TableName + ']'', N'''', 0 )'
	SET @ParmDefinition = N'@Result_Set_OUT NVARCHAR(MAX) OUTPUT';

	EXECUTE @ReturnCode = sp_executesql
			@sql
		  , @ParmDefinition
		  , @Result_Set_OUT = @IdentityInsertColumnSum OUTPUT;

	--PRINT @IdentityInsertColumnSum 

	SET @IsIdentityInsert = 'N'
	IF @IdentityInsertColumnSum > 0
		SET @IsIdentityInsert = 'Y'

		/* get column list */
		SELECT @ColumnXML = 
			 ( SELECT '    , [' + [name] + ']' + CHAR(10) 
				 FROM @tableMetadata
				WHERE [is_computed_column] <> 1
				ORDER BY [column_ordinal]
				  FOR XML PATH(''));
		   /* remove first comma */
		   SET @ColumnSTR = '^^^' + CONVERT(VARCHAR(MAX), @ColumnXML)
		   SET @ColumnSTR = CHAR(10) + REPLACE(@ColumnSTR,'^^^    , ', '         ');

		/* get column list with datatypes - may need to extend for certain other datatypes! */
		WITH [extended metadata] AS
		(
		SELECT *
			 , CASE [system_type_name]
				WHEN 'VARCHAR'  THEN [system_type_name] + '(' + CAST([max_length] AS NVARCHAR) + ')'
				WHEN 'NVARCHAR' THEN [system_type_name] + '(' + CAST([max_length] AS NVARCHAR) + ')'
				WHEN 'text' THEN 'varchar(max)'
				WHEN 'ntext' THEN 'nvarchar(max)'
				ELSE [system_type_name]
			   END [column_definition]
		  FROM @tableMetadata
		)
		SELECT @WithXML = 
		  (SELECT '     , [' + [name] + '] ' +  [column_definition]  + CHAR(10)
		  FROM [extended metadata]
		  WHERE [is_computed_column] <> 1
		  ORDER BY [column_ordinal]
		  FOR XML PATH(''))

		SET @WithSTR = '^^^' + CONVERT(VARCHAR(MAX), @WithXML)
		SET @WithSTR = CHAR(10) + REPLACE(@WithSTR,'^^^     , ', '         ')
		 IF @WithSTR IS NULL
			BEGIN
				SET @error_message = 'get column list with datatypes: No Column(s) found' 
				SELECT @return_code AS [return code], @error_message AS [error message]
				RETURN
			END

		/* build insert statement */
		SET @sql = '
		DECLARE @SchemaJson NVARCHAR(MAX)
			  , @Json NVARCHAR(MAX); 

		TRUNCATE TABLE [' + @SchemaName + '].[' + @TableName + '];'

		IF @IsIdentityInsert = 'Y'
			SET @sql = @sql + '
		SET IDENTITY_INSERT [' + @SchemaName + '].[' + @TableName + '] ON;'
		SET @sql = @sql + '
		SELECT @Json = [result_set] FROM #import_table WHERE [schema_name] = ''' + @SchemaName + ''' AND [table_name] = ''' + @TableName + ''';

		INSERT [' + @SchemaName + '].[' + @TableName + ']
		( ' + @ColumnSTR + '
		)
		SELECT * FROM  OPENJSON ( @json ) WITH (' + @WithSTR + '       ) rc ;'

		IF @IsIdentityInsert = 'Y'
			SET @sql = @sql + '
		SET IDENTITY_INSERT [' + @SchemaName + '].[' + @TableName + '] OFF;'

		SET NOCOUNT OFF;

		--print @sql
		EXECUTE @ReturnCode = sp_executesql
				@sql

	END TRY
	BEGIN CATCH
		SET @error_message = 'Import Failed: ' + ERROR_MESSAGE()
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END CATCH

	FETCH NEXT FROM MY_CURSOR INTO @SchemaName, @TableName, @SchemaResultSet
  END
CLOSE MY_CURSOR
DEALLOCATE MY_CURSOR

SET @return_code = 0
SET @error_message = ''

/* json #import_table clean-up */
DROP TABLE #import_table;

PRINT 'Import Complete!'

SELECT @return_code AS [return code], @error_message AS [error message]
GO
USE [master]
GO
ALTER DATABASE [bimlsnap_mart_v2] SET  READ_WRITE 
GO
