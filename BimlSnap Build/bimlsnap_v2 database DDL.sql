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
/****** Object:  Database [bimlsnap_v2]    Script Date: 5/3/2018 8:48:49 AM ******/
CREATE DATABASE [bimlsnap_v2];
GO
ALTER DATABASE [bimlsnap_v2] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [bimlsnap_v2].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [bimlsnap_v2] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET ARITHABORT OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [bimlsnap_v2] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [bimlsnap_v2] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET  DISABLE_BROKER 
GO
ALTER DATABASE [bimlsnap_v2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [bimlsnap_v2] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [bimlsnap_v2] SET  MULTI_USER 
GO
ALTER DATABASE [bimlsnap_v2] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [bimlsnap_v2] SET DB_CHAINING OFF 
GO
ALTER DATABASE [bimlsnap_v2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [bimlsnap_v2] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [bimlsnap_v2] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [bimlsnap_v2] SET QUERY_STORE = OFF
GO
USE [bimlsnap_v2]
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
USE [bimlsnap_v2]
GO
/****** Object:  Schema [biml]    Script Date: 5/3/2018 8:48:49 AM ******/
CREATE SCHEMA [biml]
GO
/****** Object:  Schema [etl]    Script Date: 5/3/2018 8:48:49 AM ******/
CREATE SCHEMA [etl]
GO
/****** Object:  Schema [html]    Script Date: 5/3/2018 8:48:49 AM ******/
CREATE SCHEMA [html]
GO
/****** Object:  Schema [jtts]    Script Date: 5/3/2018 8:48:49 AM ******/
CREATE SCHEMA [jtts]
GO
/****** Object:  Schema [stg]    Script Date: 5/3/2018 8:48:49 AM ******/
CREATE SCHEMA [stg]
GO
/****** Object:  UserDefinedFunction [biml].[Adonet Connect String]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 02 Apr 2017
-- Modify date: 
--
-- Description:	Returns an Ado.Net Connect String
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Adonet Connect String] ('snowflake', '')
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Adonet Connect String] ( @connection_name AS NVARCHAR(128), @environment AS NVARCHAR(32) )

RETURNS NVARCHAR(1024)
AS
BEGIN

DECLARE @ConnectionString AS NVARCHAR(1024);
DECLARE @EnvSubConnectionString AS NVARCHAR(1024);
 
SELECT @ConnectionString = [connect_string]
  FROM [biml].[adonet_connection]
 WHERE [connection_name] = @connection_name;

-- look for environment parameter substitute
SELECT @EnvSubConnectionString = ep.[parameter_value]
  FROM [biml].[environment_parameter] ep
  JOIN [biml].[adonet_connection] cn
    ON cn.[connection_name] + '_ConnectString' = ep.[parameter_name]
 WHERE ep.[environment_name] = @environment

RETURN COALESCE(@EnvSubConnectionString, @ConnectionString)

END



GO
/****** Object:  UserDefinedFunction [biml].[Adonet Provider]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 02 Apr 2017
-- Modify date: 
--
-- Description:	Returns an Ado.Net Provider
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Adonet Provider] ('snowflake', '')
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Adonet Provider] ( @connection_name AS NVARCHAR(128), @environment AS NVARCHAR(32) )

RETURNS NVARCHAR(1024)
AS
BEGIN

DECLARE @Provider AS NVARCHAR(1024);
DECLARE @EnvSubProvider AS NVARCHAR(1024);
 
SELECT @Provider = [provider]
  FROM [biml].[adonet_connection]
 WHERE [connection_name] = @connection_name;

-- look for environment parameter substitute
SELECT @EnvSubProvider = ep.[parameter_value]
  FROM [biml].[environment_parameter] ep
  JOIN [biml].[adonet_connection] cn
    ON cn.[connection_name] + '_Provider' = ep.[parameter_name]
 WHERE ep.[environment_name] = @environment

RETURN COALESCE(@EnvSubProvider, @Provider)

END




GO
/****** Object:  UserDefinedFunction [biml].[Build Dim Merge (Standard snowflake)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ==========================================================================================================
-- Author:	Jim Miller (BITracks Consulting, LLC)
-- Create Date: 24 May 2017
-- Modify Date: 17 Aug 2017 - Added SCHEMA create or replace, added TRANSIENT TABLE
-- Modify Date: 19 Aug 2017 - Changed TRANSIENT tables to TEMPORARY tables
-- Modify Date: 14 Nov 2017 - Removed comments from some snowSql statements (needed to omit row counts)
-- Modify Date: 20 Nov 2017 - Fixed case sensitive quotes
-- Modify Date: 05 Dev 2017 - Removed SCHEMA create or replace
--
-- Description:	Builds a Merge Statement for a Single Table using the SnowSql dialect
--				Metadata comes from table definitions in [etl].[dim_column]
--
-- Sample Execute Command: 
/*	

PRINT [biml].[Build Dim Merge (Standard snowflake)]
	 ( 'intricity'		-- @stg_server
	 , 'AIRLINE_STAGE'	-- @stg_database
	 , 'PUBLIC'			-- @stg_schema 
	 , 'PUBLIC'			-- @dst_schema 
	 , 'DIM_AIRLINES'	-- @stg_table 
	 , 'DIM_AIRLINES'	-- @dst_table 
	 , '@[$Project::airline_stage_snowflake_Database]' -- @stg_database_param_name 
	 , '@[$Project::airline_edw_snowflake_Database]'   -- @dst_database_param_name
	 , 3				-- @added_dim_column_names_id
	)
*/
-- ==========================================================================================================

CREATE FUNCTION [biml].[Build Dim Merge (Standard snowflake)]
(
	    @StgServer        AS NVARCHAR(128)
	  , @DatabaseName     AS NVARCHAR(128)
	  , @StgSchema        AS NVARCHAR(128)
	  , @RptSchema        AS NVARCHAR(128)
	  , @StgTable         AS NVARCHAR(128)
	  , @RptTable         AS NVARCHAR(128)
	  , @StgDatabaseParam AS NVARCHAR(128)
	  , @RptDatabaseParam AS NVARCHAR(128)
	  , @added_dim_column_names_id AS INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    
DECLARE @MergeStatement AS NVARCHAR(MAX);
  
DECLARE @StgTableFull VARCHAR(128) = '\"" +  ' + @StgDatabaseParam + ' + "\".\"' + @StgSchema + '\".\"' + @StgTable + '\"' 
	  , @RptTableFull VARCHAR(128) = '\"" +  ' + @RptDatabaseParam + ' + "\".\"' + @RptSchema + '\".\"' + @RptTable + '\"' 
	  , @SQL VARCHAR(MAX)
	  , @XML XML
      , @BusKeySelect VARCHAR(MAX)
      , @BusKeyJoin VARCHAR(MAX)
      , @BusKeyJoin_t1 VARCHAR(MAX)
      , @BusKeyJoin_t2 VARCHAR(MAX)
      , @BusKeyJoin_nc VARCHAR(MAX)
      , @BusKeyJoin_src VARCHAR(MAX)
	  , @Type1ChangeCheck VARCHAR(MAX)
	  , @Type2ChangeCheck VARCHAR(MAX)
	  , @StagingColumns VARCHAR(MAX)
  	  , @MergeUpdateSet VARCHAR(MAX)
  	  , @MergeInsertList VARCHAR(MAX)
  	  , @MergeOutputList VARCHAR(MAX);

DECLARE @row_is_current		 AS NVARCHAR(128)
      , @row_effective_date  AS NVARCHAR(128)
      , @row_expiration_date AS NVARCHAR(128)
      , @row_insert_date	 AS NVARCHAR(128)
      , @row_update_date	 AS NVARCHAR(128);


-- get custom names for supplemental dimension columns
SELECT @row_is_current = [row_is_current]
	 , @row_effective_date = [row_effective_date]
	 , @row_expiration_date = [row_expiration_date]
	 , @row_insert_date = [row_insert_date]
	 , @row_update_date = [row_update_date]
  FROM [biml].[added_dim_column_names]
 WHERE [added_dim_column_names_id] = @added_dim_column_names_id


-- Business Key (Select)
SET @XML = 
 (SELECT '             , s.\"' + [column_name] + '\"' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] = 'bk'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

--select @XML

SET @BusKeySelect = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @BusKeySelect = CHAR(10) + REPLACE(@BusKeySelect,'^^^             , s.', '               s.')
 IF @BusKeySelect IS NULL
	BEGIN
		RETURN 'No Business key(s) found'
	END

--select @BusKeySelect

-- Business Key (Join)
SET @XML = 
  (SELECT '                AND r.\"' + [column_name] + '\" = s.\"' + [column_name] + '\"' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] = 'bk'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

--select @XML

SET @BusKeyJoin = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @BusKeyJoin = CHAR(10) + REPLACE(@BusKeyJoin,'^^^                AND r.', '                    r.')
 IF @BusKeyJoin IS NULL
	BEGIN
		RETURN 'No Business key(s) found'
	END


--select @BusKeyJoin


-- Business Key (Join) variations
SET @BusKeyJoin_t1 = REPLACE(@BusKeyJoin,'r.\"', 't1.\"')
SET @BusKeyJoin_t2 = REPLACE(@BusKeyJoin,'r.\"', 't2.\"')
SET @BusKeyJoin_nc = REPLACE(@BusKeyJoin,'r.\"', 'nc.\"')
SET @BusKeyJoin_src = REPLACE(@BusKeyJoin,'r.\"', 'src.\"')
SET @BusKeyJoin_src = REPLACE(@BusKeyJoin_src,'s.\"', 'dst.\"')

--select @BusKeyJoin_src


-- type 1 Change Check
SET @XML = 
 (SELECT '                 OR IFNULL(CAST(r.\"' + [column_name] + '\" AS VARCHAR(8000)),'''') != IFNULL(CAST(s.\"' + [column_name] + '\" AS VARCHAR(8000)),'''')' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] = 't1'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

  --select @XML


SET @Type1ChangeCheck = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @Type1ChangeCheck = REPLACE(@Type1ChangeCheck,'^^^                 OR IFNULL', '                    IFNULL')
 IF @Type1ChangeCheck IS NULL
	SET @Type1ChangeCheck = '                 1=2 '



-- type 2 Change Check
SET @XML = 
 (SELECT '                 OR IFNULL(CAST(r.\"' + [column_name] + '\" AS VARCHAR(8000)),'''') != IFNULL(CAST(s.\"' + [column_name] + '\" AS VARCHAR(8000)),'''')' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] = 't2'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))


 --select @XML


SET @Type2ChangeCheck = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @Type2ChangeCheck = REPLACE(@Type2ChangeCheck,'^^^                 OR IFNULL', '                    IFNULL')
 IF @Type2ChangeCheck IS NULL
	SET @Type2ChangeCheck = '                 1=2 '


	--select @Type2ChangeCheck


-- Staging Columns
SET @XML = 
 (SELECT '             , s.\"' + [column_name] + '\"' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

  --select @XML


SET @StagingColumns = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @StagingColumns = REPLACE(@StagingColumns,'^^^             ,', '              ')
 IF @StagingColumns IS NULL
	SET @StagingColumns = ''



-- Merge Update Set
SET @XML = 
 (SELECT '                 , \"' + [column_name] + '\" = CASE ChangeType WHEN ''type 1'' THEN SRC.\"' + [column_name] + '\" ELSE DST.\"' + [column_name] + '\" END' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] NOT IN ('bk', 't0')
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

--select @XML

SET @MergeUpdateSet = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @MergeUpdateSet = REPLACE(@MergeUpdateSet,'^^^                 ,', ' SET')
 IF @MergeUpdateSet IS NULL
	SET @MergeUpdateSet = ''

    --select @XML



-- Merge Insert List
SET @XML = 
 (SELECT '                 , \"' + [column_name] + '\"' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    --AND [merge_type] <> 't0'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

SET @MergeInsertList = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @MergeInsertList = REPLACE(@MergeInsertList,'^^^                 ,', '      ')
 IF @MergeInsertList IS NULL
	SET @MergeInsertList = ''


    --select @XML

-- Merge Output List
SET @XML = 
 (SELECT '             , SRC.\"' + [column_name] + '\"' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    --AND [merge_type] <> 't0'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

SET @MergeOutputList = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @MergeOutputList = REPLACE(@MergeOutputList,'^^^             ,', '')
 IF @MergeOutputList IS NULL
	SET @MergeOutputList = ''


    --select @XML


-- main select
SELECT @SQL = '"CREATE OR REPLACE TEMPORARY TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.\"' + @StgTable + '\" AS 
SELECT CAST('''' AS VARCHAR(10)) AS merge_action_change_row_type
     , CAST('''' AS VARCHAR(10)) AS merge_action_change_dim_type
     , *
  FROM ' + @StgTableFull + ' 
  WHERE 1=2;

		CREATE OR REPLACE TEMPORARY TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.type2 AS
		(
		SELECT ' + @BusKeySelect  + '
   			 , CASE WHEN CAST(r.\"' + @row_update_date + '\" AS DATE) = CURRENT_DATE()
					THEN ''type1''
					ELSE ''type2'' 
			   END AS \"Change\"
		  FROM ' + @StgTableFull + ' s
		  JOIN ' + @RptTableFull + ' r
		    ON ' + @BusKeyJoin + '
		 WHERE r.\"' + @row_is_current + '\" = ''Y''
		   AND ( -- detect type 2 attribute changes
' +	 @Type2ChangeCheck + '			    )
		);

		CREATE OR REPLACE TEMPORARY TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.type1 AS
		(
		SELECT '
   + @BusKeySelect
   + '
   			 , ''type1'' AS \"Change\"
		  FROM ' + @StgTableFull + ' s
		  JOIN ' + @RptTableFull + ' r
		    ON ' + @BusKeyJoin + '
		 WHERE r.\"' + @row_is_current + '\" = ''Y''
		   AND ( -- detect type 2 attribute changes
' +	 @Type1ChangeCheck + '			    )
		);

		CREATE OR REPLACE TEMPORARY TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.nochg AS
		(
		SELECT '
   + @BusKeySelect
   + '
   			 , ''nochg'' AS \"Change\"
		  FROM ' + @StgTableFull + ' s
		  JOIN ' + @RptTableFull + ' r
		    ON ' + @BusKeyJoin + '
		 WHERE r.\"' + @row_is_current + '\" = ''Y''
		);

		CREATE OR REPLACE TEMPORARY TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.staging AS
		(
		SELECT 
' + @StagingColumns + '
			 , CASE WHEN t2.\"Change\" = ''type2'' THEN ''type 2''
					WHEN t2.\"Change\" = ''type1'' THEN ''type 1''
					WHEN t1.\"Change\" = ''type1'' THEN ''type 1''
					WHEN nc.\"Change\" = ''nochg'' THEN ''No Change''
					ELSE ''Insert''
			   END AS ChangeType
		  FROM ' + @StgTableFull + ' s
		  LEFT JOIN ' + @RptTableFull + ' r
		    ON ' + @BusKeyJoin + '
		  LEFT JOIN \"" +' + @StgDatabaseParam + '+ "\".MERGE.type1 t1
		    ON ' + @BusKeyJoin_t1 + '
		  LEFT JOIN \"" +' + @StgDatabaseParam + '+ "\".MERGE.type2 t2
		    ON ' + @BusKeyJoin_t2 + '
		  LEFT JOIN \"" +' + @StgDatabaseParam + '+ "\".MERGE.nochg nc
		    ON ' + @BusKeyJoin_nc + '
	     WHERE IFNULL(r.\"' + @row_is_current + '\", ''Y'') = ''Y''
		);

		-- Merge statement
		 MERGE INTO ' + @RptTableFull + ' AS DST
		 USING ( SELECT * FROM \"" +' + @StgDatabaseParam + '+ "\".MERGE.staging ) AS SRC
		    ON ' + @BusKeyJoin_src + '
		   AND SRC.ChangeType != ''No Change''
	
		WHEN MATCHED AND DST.\"' + @row_is_current + '\" = ''Y'' THEN
		-- Update dimension record, and flag as no longer active if type 2
		UPDATE'
		+ @MergeUpdateSet + '
		         , \"' + @row_is_current + '\" = CASE ChangeType WHEN ''type 1'' THEN ''Y'' ELSE ''N'' END
				 , \"' + @row_expiration_date + '\" = CASE ChangeType WHEN ''type 1'' THEN DST.\"' + @row_expiration_date + '\" ELSE CAST(DATEADD(day, -1, CURRENT_DATE()) AS DATE) END
		         , \"' + @row_update_date + '\" = CURRENT_DATE()

		  -- New records inserted (not used by type 2)
		  WHEN NOT MATCHED AND SRC.ChangeType != ''No Change'' THEN 
			INSERT ( 
			' + @MergeInsertList + '
				 , \"' + @row_is_current + '\"
				 , \"' + @row_effective_date + '\"
				 , \"' + @row_expiration_date + '\"
				 , \"' + @row_insert_date + '\"
				 , \"' + @row_update_date + '\"
				 )
			VALUES (
			' + @MergeInsertList + '
				 , ''Y''
			     , ''01/01/1900''::DATE
				 , ''12/31/9999''::DATE
			     , CURRENT_DATE()
			     , CURRENT_DATE()
				 );
		

		-- outer merge insert (used only for type 2 new rows)
		INSERT INTO ' + @RptTableFull + ' (
			' + @MergeInsertList + '
				 , \"' + @row_is_current + '\"
				 , \"' + @row_effective_date + '\"
				 , \"' + @row_expiration_date + '\"
				 , \"' + @row_insert_date + '\"
			     , \"' + @row_update_date + '\"
			 )
		SELECT 
			' + @MergeInsertList + '
			 , ''Y''
			 , CURRENT_DATE()
			 , ''12/31/9999''::DATE
			 , CURRENT_DATE()
			 , CURRENT_DATE()
		  FROM \"" +' + @StgDatabaseParam + '+ "\".MERGE.staging MRG
		 WHERE MRG.ChangeType = ''type 2'';

		DROP TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.\"' + @StgTable + '\";
		DROP TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.type1;
		DROP TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.type2;
		DROP TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.nochg;
		DROP TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.staging;
"'

SET @MergeStatement = @SQL
 
RETURN  @MergeStatement

END
GO
/****** Object:  UserDefinedFunction [biml].[Build Dim Merge (Standard snowflake) Type 1 - Base Columns]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 03 Oct 2016
-- Modify date: 
--
-- Description:	Builds a Merge Statement for a Single Table Without '@added_dim_column_names_id'
--				All 'Metadata' comes from table definitions in [etl].[dim_column]
--
-- Sample Execute Command: 
/*	
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Build Dim Merge (Standard snowflake) Type 1 - Base Columns]
(
	    @StgServer        AS NVARCHAR(128)
	  , @DatabaseName     AS NVARCHAR(128)
	  , @StgSchema        AS NVARCHAR(128)
	  , @RptSchema        AS NVARCHAR(128)
	  , @StgTable         AS NVARCHAR(128)
	  , @RptTable         AS NVARCHAR(128)
	  , @StgDatabaseParam AS NVARCHAR(128)
	  , @RptDatabaseParam AS NVARCHAR(128)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    
DECLARE @MergeStatement AS NVARCHAR(MAX);
  
DECLARE @StgTableFull VARCHAR(128) = '\"" +  ' + @StgDatabaseParam + ' + "\".\"' + @StgSchema + '\".\"' + @StgTable + '\"' 
	  , @RptTableFull VARCHAR(128) = '\"" +  ' + @RptDatabaseParam + ' + "\".\"' + @RptSchema + '\".\"' + @RptTable + '\"' 
	  , @SQL VARCHAR(MAX)
	  , @XML XML
      , @BusKeySelect VARCHAR(MAX)
      , @BusKeyJoin VARCHAR(MAX)
      , @BusKeyJoin_t1 VARCHAR(MAX)
      , @BusKeyJoin_t2 VARCHAR(MAX)
      , @BusKeyJoin_nc VARCHAR(MAX)
      , @BusKeyJoin_src VARCHAR(MAX)
	  , @Type1ChangeCheck VARCHAR(MAX)
	  , @Type2ChangeCheck VARCHAR(MAX)
	  , @StagingColumns VARCHAR(MAX)
  	  , @MergeUpdateSet VARCHAR(MAX)
  	  , @MergeInsertList VARCHAR(MAX)
  	  , @MergeOutputList VARCHAR(MAX);


-- Business Key (Select)
SET @XML = 
 (SELECT '             , s.\"' + [column_name] + '\"' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] = 'bk'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

--select @XML

SET @BusKeySelect = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @BusKeySelect = CHAR(10) + REPLACE(@BusKeySelect,'^^^             , s.', '               s.')
 IF @BusKeySelect IS NULL
	BEGIN
		RETURN 'No Business key(s) found'
	END

--select @BusKeySelect

-- Business Key (Join)
SET @XML = 
  (SELECT '                AND r.\"' + [column_name] + '\" = s.\"' + [column_name] + '\"' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] = 'bk'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

--select @XML

SET @BusKeyJoin = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @BusKeyJoin = CHAR(10) + REPLACE(@BusKeyJoin,'^^^                AND r.', '                    r.')
 IF @BusKeyJoin IS NULL
	BEGIN
		RETURN 'No Business key(s) found'
	END


--select @BusKeyJoin


-- Business Key (Join) variations
SET @BusKeyJoin_t1 = REPLACE(@BusKeyJoin,'r.\"', 't1.\"')
SET @BusKeyJoin_t2 = REPLACE(@BusKeyJoin,'r.\"', 't2.\"')
SET @BusKeyJoin_nc = REPLACE(@BusKeyJoin,'r.\"', 'nc.\"')
SET @BusKeyJoin_src = REPLACE(@BusKeyJoin,'r.\"', 'src.\"')
SET @BusKeyJoin_src = REPLACE(@BusKeyJoin_src,'s.\"', 'dst.\"')

--select @BusKeyJoin_src


-- Type 1 Change Check
SET @XML = 
 (SELECT '                 OR IFNULL(CAST(r.\"' + [column_name] + '\" AS VARCHAR(8000)),'''') != IFNULL(CAST(s.\"' + [column_name] + '\" AS VARCHAR(8000)),'''')' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] = 't1'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

  --select @XML


SET @Type1ChangeCheck = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @Type1ChangeCheck = REPLACE(@Type1ChangeCheck,'^^^                 OR IFNULL', '                    IFNULL')
 IF @Type1ChangeCheck IS NULL
	SET @Type1ChangeCheck = '                 1=2 '



-- Type 2 Change Check
SET @XML = 
 (SELECT '                 OR IFNULL(CAST(r.\"' + [column_name] + '\" AS VARCHAR(8000)),'''') != IFNULL(CAST(s.\"' + [column_name] + '\" AS VARCHAR(8000)),'''')' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] = 't2'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))


 --select @XML


SET @Type2ChangeCheck = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @Type2ChangeCheck = REPLACE(@Type2ChangeCheck,'^^^                 OR IFNULL', '                    IFNULL')
 IF @Type2ChangeCheck IS NULL
	SET @Type2ChangeCheck = '                 1=2 '


	--select @Type2ChangeCheck


-- Staging Columns
SET @XML = 
 (SELECT '             , s.\"' + [column_name] + '\"' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

  --select @XML


SET @StagingColumns = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @StagingColumns = REPLACE(@StagingColumns,'^^^             ,', '              ')
 IF @StagingColumns IS NULL
	SET @StagingColumns = ''



-- Merge Update Set
SET @XML = 
 (SELECT '                 , \"' + [column_name] + '\" = CASE ChangeType WHEN ''type 1'' THEN SRC.\"' + [column_name] + '\" ELSE DST.\"' + [column_name] + '\" END' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] NOT IN ('bk', 't0')
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

--select @XML

SET @MergeUpdateSet = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @MergeUpdateSet = REPLACE(@MergeUpdateSet,'^^^                 ,', ' SET')
 IF @MergeUpdateSet IS NULL
	SET @MergeUpdateSet = ''

    --select @XML



-- Merge Insert List
SET @XML = 
 (SELECT '                 , \"' + [column_name] + '\"' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    --AND [merge_type] <> 't0'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

SET @MergeInsertList = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @MergeInsertList = REPLACE(@MergeInsertList,'^^^                 ,', '      ')
 IF @MergeInsertList IS NULL
	SET @MergeInsertList = ''


    --select @XML

-- Merge Output List
SET @XML = 
 (SELECT '             , SRC.\"' + [column_name] + '\"' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    --AND [merge_type] <> 't0'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

SET @MergeOutputList = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @MergeOutputList = REPLACE(@MergeOutputList,'^^^             ,', '')
 IF @MergeOutputList IS NULL
	SET @MergeOutputList = ''


    --select @XML


-- main select
SELECT @SQL = '"CREATE OR REPLACE SCHEMA MERGE; 
CREATE OR REPLACE TEMPORARY TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.\"' + @StgTable + '\" AS 
SELECT CAST('''' AS VARCHAR(10)) AS merge_action_change_row_type
     , CAST('''' AS VARCHAR(10)) AS merge_action_change_dim_type
     , *
  FROM ' + @StgTableFull + ' 
  WHERE 1=2;


	    -- determine type 2 changes (intra-day changes are treated as type 1)
		CREATE OR REPLACE TEMPORARY TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.type2 AS
		(
		SELECT ' + @BusKeySelect  + '
   			 , ''type1'' AS \"Change\"
		  FROM ' + @StgTableFull + ' s
		  JOIN ' + @RptTableFull + ' r
		    ON ' + @BusKeyJoin + '
		 WHERE ( -- detect type 2 attribute changes
' +	 @Type2ChangeCheck + '			    )
		);


		-- determine type 1 changes
		CREATE OR REPLACE TEMPORARY TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.type1 AS
		(
		SELECT '
   + @BusKeySelect
   + '
   			 , ''type1'' AS \"Change\"
		  FROM ' + @StgTableFull + ' s
		  JOIN ' + @RptTableFull + ' r
		    ON ' + @BusKeyJoin + '
		 WHERE ( -- detect type 2 attribute changes
' +	 @Type1ChangeCheck + '			    )
		);


		-- determine matches with no changes (all rows not caught above will be treated as type 0 - ignored in merge statement below)
		CREATE OR REPLACE TEMPORARY TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.nochg AS
		(
		SELECT '
   + @BusKeySelect
   + '
   			 , ''nochg'' AS \"Change\"
		  FROM ' + @StgTableFull + ' s
		  JOIN ' + @RptTableFull + ' r
		    ON ' + @BusKeyJoin + '
		);


		-- combine all the above CTEs and add no-matches from source
		CREATE OR REPLACE TEMPORARY TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.staging AS
		(
		SELECT 
' + @StagingColumns + '
			 , CASE WHEN t2.\"Change\" = ''type2'' THEN ''Type 2''
					WHEN t2.\"Change\" = ''type1'' THEN ''Type 1''
					WHEN t1.\"Change\" = ''type1'' THEN ''Type 1''
					WHEN nc.\"Change\" = ''nochg'' THEN ''No Change''
					ELSE ''Insert''
			   END AS ChangeType
		  FROM ' + @StgTableFull + ' s
		  LEFT JOIN ' + @RptTableFull + ' r
		    ON ' + @BusKeyJoin + '
		  LEFT JOIN \"" +' + @StgDatabaseParam + '+ "\".MERGE.type1 t1
		    ON ' + @BusKeyJoin_t1 + '
		  LEFT JOIN \"" +' + @StgDatabaseParam + '+ "\".MERGE.type2 t2
		    ON ' + @BusKeyJoin_t2 + '
		  LEFT JOIN \"" +' + @StgDatabaseParam + '+ "\".MERGE.nochg nc
		    ON ' + @BusKeyJoin_nc + '
		);


		-- Merge statement
		 MERGE INTO ' + @RptTableFull + ' AS DST
		 USING ( SELECT * FROM \"" +' + @StgDatabaseParam + '+ "\".MERGE.staging ) AS SRC
		    ON ' + @BusKeyJoin_src + '
		   AND SRC.ChangeType != ''No Change''
	
		WHEN MATCHED THEN
		-- Update dimension record
		UPDATE'
		+ @MergeUpdateSet + '

		  -- New records inserted (not used by type 2)
		  WHEN NOT MATCHED AND SRC.ChangeType != ''No Change'' THEN 
			INSERT ( 
			' + @MergeInsertList + '
				 )
			VALUES (
			' + @MergeInsertList + '
				 );
		

		DROP TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.\"' + @StgTable + '\";
		DROP TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.type1;
		DROP TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.type2;
		DROP TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.nochg;
		DROP TABLE \"" +' + @StgDatabaseParam + '+ "\".MERGE.staging;
"'

SET @MergeStatement = @SQL
 
RETURN  @MergeStatement
 
END















GO
/****** Object:  UserDefinedFunction [biml].[Build Dim Merge (Standard)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 24 May 2016
-- Modify date: 13 Jun 2016 - Added row counts
-- Modify date: 02 Jul 2016 - Added [row_effective_date] and [row_expiration_date]
-- Modify date: 04 Jul 2016 - Changed to output an 'Expression'
-- Modify date: 07 Jul 2016 - Added reference to table [biml].[added_dim_column_names]
--							- for variable added column names
-- Modify date: 06 Apr 2017 - Added @ServerName
--
-- Description:	Builds a Merge Statement for a Single Table
--				All 'Metadata' comes from table definitions in [etl].[dim_column]
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Build Dim Merge (Standard)] 
	 (  'ETL_DM'    -- @DatabaseName
	  , 'stg'       -- @StgSchema
	  , 'dbo'       -- @RptSchema
	  , 'dim_table' -- @StgTable
      , 'dim_table' -- @RptTable
      , '@[$Project::STG_DB_Database]'    -- @StgDatabaseParam
      , '@[$Project::EDW_DB_Database]'    -- @RptDatabaseParam
	  , 1 -- @added_dim_column_names_id
	 )
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Build Dim Merge (Standard)]
(
	    @StgServer        AS NVARCHAR(128)
	  , @DatabaseName     AS NVARCHAR(128)
	  , @StgSchema        AS NVARCHAR(128)
	  , @RptSchema        AS NVARCHAR(128)
	  , @StgTable         AS NVARCHAR(128)
	  , @RptTable         AS NVARCHAR(128)
	  , @StgDatabaseParam AS NVARCHAR(128)
	  , @RptDatabaseParam AS NVARCHAR(128)
	  , @added_dim_column_names_id AS INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    
DECLARE @MergeStatement AS NVARCHAR(MAX);
  
DECLARE @StgTableFull VARCHAR(128) = '[" +  ' + @StgDatabaseParam + ' + "].[' + @StgSchema + '].[' + @StgTable + ']' 
	  , @RptTableFull VARCHAR(128) = '[" +  ' + @RptDatabaseParam + ' + "].[' + @RptSchema + '].[' + @RptTable + ']' 
	  , @SQL VARCHAR(MAX)
	  , @XML XML
      , @BusKeySelect VARCHAR(MAX)
      , @BusKeyJoin VARCHAR(MAX)
      , @BusKeyJoin_t1 VARCHAR(MAX)
      , @BusKeyJoin_t2 VARCHAR(MAX)
      , @BusKeyJoin_nc VARCHAR(MAX)
      , @BusKeyJoin_src VARCHAR(MAX)
	  , @Type1ChangeCheck VARCHAR(MAX)
	  , @Type2ChangeCheck VARCHAR(MAX)
	  , @StagingColumns VARCHAR(MAX)
  	  , @MergeUpdateSet VARCHAR(MAX)
  	  , @MergeInsertList VARCHAR(MAX)
  	  , @MergeOutputList VARCHAR(MAX);

DECLARE @row_is_current		 AS NVARCHAR(128)
      , @row_effective_date  AS NVARCHAR(128)
      , @row_expiration_date AS NVARCHAR(128)
      , @row_insert_date	 AS NVARCHAR(128)
      , @row_update_date	 AS NVARCHAR(128);


-- get custom names for supplemental dimension columns
SELECT @row_is_current = [row_is_current]
	 , @row_effective_date = [row_effective_date]
	 , @row_expiration_date = [row_expiration_date]
	 , @row_insert_date = [row_insert_date]
	 , @row_update_date = [row_update_date]
  FROM [biml].[added_dim_column_names]
 WHERE [added_dim_column_names_id] = @added_dim_column_names_id


-- Business Key (Select)
SET @XML = 
 (SELECT '             , s.[' + [column_name] + ']' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] = 'bk'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

--select @XML

SET @BusKeySelect = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @BusKeySelect = CHAR(10) + REPLACE(@BusKeySelect,'^^^             , s.', '               s.')
 IF @BusKeySelect IS NULL
	BEGIN
		RETURN 'No Business key(s) found'
	END

--select @BusKeySelect

-- Business Key (Join)
SET @XML = 
  (SELECT '                AND r.[' + [column_name] + '] = s.[' + [column_name] + ']' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] = 'bk'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

--select @XML

SET @BusKeyJoin = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @BusKeyJoin = CHAR(10) + REPLACE(@BusKeyJoin,'^^^                AND r.', '                    r.')
 IF @BusKeyJoin IS NULL
	BEGIN
		RETURN 'No Business key(s) found'
	END


--select @BusKeyJoin


-- Business Key (Join) variations
SET @BusKeyJoin_t1 = REPLACE(@BusKeyJoin,'r.[', 't1.[')
SET @BusKeyJoin_t2 = REPLACE(@BusKeyJoin,'r.[', 't2.[')
SET @BusKeyJoin_nc = REPLACE(@BusKeyJoin,'r.[', 'nc.[')
SET @BusKeyJoin_src = REPLACE(@BusKeyJoin,'r.[', 'src.[')
SET @BusKeyJoin_src = REPLACE(@BusKeyJoin_src,'s.[', 'dst.[')

--select @BusKeyJoin_src


-- Type 1 Change Check
SET @XML = 
 (SELECT '                 OR ISNULL(CAST(r.[' + [column_name] + '] AS VARCHAR(8000)),'''') != ISNULL(CAST(s.[' + [column_name] + '] AS VARCHAR(8000)),'''')' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] = 't1'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

  --select @XML


SET @Type1ChangeCheck = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @Type1ChangeCheck = REPLACE(@Type1ChangeCheck,'^^^                 OR ISNULL', '                    ISNULL')
 IF @Type1ChangeCheck IS NULL
	SET @Type1ChangeCheck = '                 1=2 '



-- Type 2 Change Check
SET @XML = 
 (SELECT '                 OR ISNULL(CAST(r.[' + [column_name] + '] AS VARCHAR(8000)),'''') != ISNULL(CAST(s.[' + [column_name] + '] AS VARCHAR(8000)),'''')' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] = 't2'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))


 --select @XML


SET @Type2ChangeCheck = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @Type2ChangeCheck = REPLACE(@Type2ChangeCheck,'^^^                 OR ISNULL', '                    ISNULL')
 IF @Type2ChangeCheck IS NULL
	SET @Type2ChangeCheck = '                 1=2 '


	--select @Type2ChangeCheck


-- Staging Columns
SET @XML = 
 (SELECT '             , s.[' + [column_name] + ']' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

  --select @XML


SET @StagingColumns = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @StagingColumns = REPLACE(@StagingColumns,'^^^             ,', '              ')
 IF @StagingColumns IS NULL
	SET @StagingColumns = ''



-- Merge Update Set
SET @XML = 
 (SELECT '                 , [' + [column_name] + '] = CASE [ChangeType] WHEN ''type 1'' THEN SRC.[' + [column_name] + '] ELSE DST.[' + [column_name] + '] END' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] NOT IN ('bk', 't0')
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

--select @XML

SET @MergeUpdateSet = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @MergeUpdateSet = REPLACE(@MergeUpdateSet,'^^^                 ,', ' SET')
 IF @MergeUpdateSet IS NULL
	SET @MergeUpdateSet = ''

    --select @XML



-- Merge Insert List
SET @XML = 
 (SELECT '                 , [' + [column_name] + ']' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    --AND [merge_type] <> 't0'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

SET @MergeInsertList = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @MergeInsertList = REPLACE(@MergeInsertList,'^^^                 ,', '      ')
 IF @MergeInsertList IS NULL
	SET @MergeInsertList = ''


    --select @XML

-- Merge Output List
SET @XML = 
 (SELECT '             , SRC.[' + [column_name] + ']' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    --AND [merge_type] <> 't0'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

SET @MergeOutputList = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @MergeOutputList = REPLACE(@MergeOutputList,'^^^             ,', '')
 IF @MergeOutputList IS NULL
	SET @MergeOutputList = ''


    --select @XML


-- main select
SELECT @SQL = '"IF OBJECT_ID( ''tempdb..#MergeChanges'') IS NOT NULL DROP TABLE #MergeChanges;
 
SELECT CAST('''' AS NVARCHAR(10)) AS [merge_action_change_row_type]
     , CAST('''' AS NVARCHAR(10)) AS [merge_action_change_dim_type]
     , *
  INTO #MergeChanges
  FROM ' + @StgTableFull + '
 WHERE 1=2

DECLARE @row_count AS INT;
	    -- determine type 2 changes (intra-day changes are treated as type 1)
		WITH type2 AS
		(
		SELECT ' + @BusKeySelect  + '
   			 , CASE WHEN CAST(r.[' + @row_update_date + '] AS DATE) = CAST(GETDATE() AS DATE)
					THEN ''type1''
					ELSE ''type2'' 
			   END AS [Change]
		  FROM ' + @StgTableFull + ' s
		  JOIN ' + @RptTableFull + ' r
		    ON ' + @BusKeyJoin + '
		 WHERE r.[' + @row_is_current + '] = ''Y''
		   AND ( -- detect type 2 attribute changes
' +	 @Type2ChangeCheck + '			    )
		)
		-- determine type 1 changes
		, type1 AS
		(
		SELECT '
   + @BusKeySelect
   + '
   			 , ''type1'' AS [Change]
		  FROM ' + @StgTableFull + ' s
		  JOIN ' + @RptTableFull + ' r
		    ON ' + @BusKeyJoin + '
		 WHERE r.[' + @row_is_current + '] = ''Y''
		   AND ( -- detect type 2 attribute changes
' +	 @Type1ChangeCheck + '			    )
		)

		-- determine matches with no changes (all rows not caught above will be treated as type 0 - ignored in merge statement below)
		, nochg AS
		(
		SELECT '
   + @BusKeySelect
   + '
   			 , ''nochg'' AS [Change]
		  FROM ' + @StgTableFull + ' s
		  JOIN ' + @RptTableFull + ' r
		    ON ' + @BusKeyJoin + '
		 WHERE r.[' + @row_is_current + '] = ''Y''
		)
		-- combine all the above CTEs and add no-matches from source
		, staging AS
		(
		SELECT 
' + @StagingColumns + '
			 , CASE WHEN t2.[Change] = ''type2'' THEN ''Type 2''
					WHEN t2.[Change] = ''type1'' THEN ''Type 1''
					WHEN t1.[Change] = ''type1'' THEN ''Type 1''
					WHEN nc.[Change] = ''nochg'' THEN ''No Change''
					ELSE ''Insert''
			   END AS [ChangeType]
		  FROM ' + @StgTableFull + ' s
		  LEFT JOIN ' + @RptTableFull + ' r
		    ON ' + @BusKeyJoin + '
		  LEFT JOIN type1 t1
		    ON ' + @BusKeyJoin_t1 + '
		  LEFT JOIN type2 t2
		    ON ' + @BusKeyJoin_t2 + '
		  LEFT JOIN nochg nc
		    ON ' + @BusKeyJoin_nc + '
	     WHERE ISNULL(r.[' + @row_is_current + '], ''Y'') = ''Y''
		)

		-- Merge statement
		 MERGE ' + @RptTableFull + ' AS DST
		 USING ( SELECT * FROM staging ) AS SRC
		    ON ' + @BusKeyJoin_src + '
		   AND SRC.[ChangeType] != ''No Change''
	
		WHEN MATCHED AND DST.[' + @row_is_current + '] = ''Y'' THEN
		-- Update dimension record, and flag as no longer active if type 2
		UPDATE'
		+ @MergeUpdateSet + '
		         , [' + @row_is_current + '] = CASE [ChangeType] WHEN ''Type 1'' THEN ''Y'' ELSE ''N'' END
				 , [' + @row_expiration_date + '] = CASE [ChangeType] WHEN ''Type 1'' THEN DST.[' + @row_expiration_date + '] ELSE CAST(GETDATE()-1 AS DATE) END
		         , [' + @row_update_date + '] = GETDATE()

		  -- New records inserted (not used by type 2)
		  WHEN NOT MATCHED AND SRC.[ChangeType] != ''No Change'' THEN 
			INSERT ( 
			' + @MergeInsertList + '
				 , [' + @row_is_current + ']
				 , [' + @row_effective_date + ']
				 , [' + @row_expiration_date + ']
				 , [' + @row_insert_date + ']
				 , [' + @row_update_date + ']
				 )
			VALUES (
			' + @MergeInsertList + '
				 , ''Y''
			     , CONVERT([date],''01/01/1900'')
			     , CONVERT([date],''12/31/9999'')
				 , CONVERT([date], GETDATE())
				 , CONVERT([date], GETDATE())
				 )
		-- output all action rows
		OUTPUT $ACTION AS [merge_action_change_row_type]
			 , SRC.[ChangeType] AS [merge_action_change_dim_type]

             ,' + @MergeOutputList + '
			 INTO #MergeChanges;
			 
		SET @row_count = @@ROWCOUNT;

		-- outer merge insert (used only for type 2 new rows)
		INSERT ' + @RptTableFull + ' (
			' + @MergeInsertList + '
				 , [' + @row_is_current + ']
				 , [' + @row_effective_date + ']
				 , [' + @row_expiration_date + ']
				 , [' + @row_insert_date + ']
			     , [' + @row_update_date + ']
			 )
		SELECT 
			' + @MergeInsertList + '
			 , ''Y''
			 , CONVERT([date], GETDATE())
			 , CONVERT([date],''12/31/9999'')
			 , GETDATE()
			 , GETDATE()
		  FROM #MergeChanges MRG
		 WHERE MRG.[merge_action_change_row_type] = ''UPDATE''
		   AND MRG.[merge_action_change_dim_type] = ''Type 2'';


	SET @row_count = @row_count + @@ROWCOUNT;
    SELECT @row_count AS [row_count];
"'

SET @MergeStatement = @SQL
 
RETURN  @MergeStatement

END















GO
/****** Object:  UserDefinedFunction [biml].[Build Dim Merge (Standard) Type 1 - Base Columns]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 24 May 2016
-- Modify date: 13 Jun 2016
-- Modify date: 03 Oct 2016 - Added @StgServer parameter
--
-- Description:	Builds a Merge Statement for a Single Table Without '@added_dim_column_names_id'
--				All 'Metadata' comes from table definitions in [etl].[dim_column]
--
-- Sample Execute Command: 
/*	
PRINT [biml].[Build Dim Merge (No Added Columns)] 
	 (  'snap_mart_FQ'    -- @DatabaseName
	  , 'etl'             -- @StgSchema
	  , 'dbo'			  -- @RptSchema
	  , 'dim_table'		  -- @StgTable
      , 'dim_table'		  -- @RptTable
      , '@[$Project::snap_mart_Database]'    -- @StgDatabaseParam
      , '@[$Project::snap_mart_Database]'    -- @RptDatabaseParam
	 )
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Build Dim Merge (Standard) Type 1 - Base Columns]
(
	    @StgServer        AS NVARCHAR(128)
	  , @DatabaseName     AS NVARCHAR(128)
	  , @StgSchema        AS NVARCHAR(128)
	  , @RptSchema        AS NVARCHAR(128)
	  , @StgTable         AS NVARCHAR(128)
	  , @RptTable         AS NVARCHAR(128)
	  , @StgDatabaseParam AS NVARCHAR(128)
	  , @RptDatabaseParam AS NVARCHAR(128)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    
DECLARE @MergeStatement AS NVARCHAR(MAX);
  
DECLARE @StgTableFull VARCHAR(128) = '[" +  ' + @StgDatabaseParam + ' + "].[' + @StgSchema + '].[' + @StgTable + ']' 
	  , @RptTableFull VARCHAR(128) = '[" +  ' + @RptDatabaseParam + ' + "].[' + @RptSchema + '].[' + @RptTable + ']' 
	  , @SQL VARCHAR(MAX)
	  , @XML XML
      , @BusKeySelect VARCHAR(MAX)
      , @BusKeyJoin VARCHAR(MAX)
      , @BusKeyJoin_t1 VARCHAR(MAX)
      , @BusKeyJoin_t2 VARCHAR(MAX)
      , @BusKeyJoin_nc VARCHAR(MAX)
      , @BusKeyJoin_src VARCHAR(MAX)
	  , @Type1ChangeCheck VARCHAR(MAX)
	  , @Type2ChangeCheck VARCHAR(MAX)
	  , @StagingColumns VARCHAR(MAX)
  	  , @MergeUpdateSet VARCHAR(MAX)
  	  , @MergeInsertList VARCHAR(MAX)
  	  , @MergeOutputList VARCHAR(MAX);


-- Business Key (Select)
SET @XML = 
 (SELECT '             , s.[' + [column_name] + ']' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] = 'bk'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

--select @XML

SET @BusKeySelect = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @BusKeySelect = CHAR(10) + REPLACE(@BusKeySelect,'^^^             , s.', '               s.')
 IF @BusKeySelect IS NULL
	BEGIN
		RETURN 'No Business key(s) found'
	END

--select @BusKeySelect

-- Business Key (Join)
SET @XML = 
  (SELECT '                AND r.[' + [column_name] + '] = s.[' + [column_name] + ']' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] = 'bk'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

--select @XML

SET @BusKeyJoin = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @BusKeyJoin = CHAR(10) + REPLACE(@BusKeyJoin,'^^^                AND r.', '                    r.')
 IF @BusKeyJoin IS NULL
	BEGIN
		RETURN 'No Business key(s) found'
	END


--select @BusKeyJoin


-- Business Key (Join) variations
SET @BusKeyJoin_t1 = REPLACE(@BusKeyJoin,'r.[', 't1.[')
SET @BusKeyJoin_t2 = REPLACE(@BusKeyJoin,'r.[', 't2.[')
SET @BusKeyJoin_nc = REPLACE(@BusKeyJoin,'r.[', 'nc.[')
SET @BusKeyJoin_src = REPLACE(@BusKeyJoin,'r.[', 'src.[')
SET @BusKeyJoin_src = REPLACE(@BusKeyJoin_src,'s.[', 'dst.[')

--select @BusKeyJoin_src


-- Type 1 Change Check
SET @XML = 
 (SELECT '                 OR ISNULL(CAST(r.[' + [column_name] + '] AS VARCHAR(8000)),'''') != ISNULL(CAST(s.[' + [column_name] + '] AS VARCHAR(8000)),'''')' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] = 't1'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

  --select @XML


SET @Type1ChangeCheck = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @Type1ChangeCheck = REPLACE(@Type1ChangeCheck,'^^^                 OR ISNULL', '                    ISNULL')
 IF @Type1ChangeCheck IS NULL
	SET @Type1ChangeCheck = '                 1=2 '



-- Type 2 Change Check
SET @XML = 
 (SELECT '                 OR ISNULL(CAST(r.[' + [column_name] + '] AS VARCHAR(8000)),'''') != ISNULL(CAST(s.[' + [column_name] + '] AS VARCHAR(8000)),'''')' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] = 't2'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))


 --select @XML


SET @Type2ChangeCheck = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @Type2ChangeCheck = REPLACE(@Type2ChangeCheck,'^^^                 OR ISNULL', '                    ISNULL')
 IF @Type2ChangeCheck IS NULL
	SET @Type2ChangeCheck = '                 1=2 '


	--select @Type2ChangeCheck


-- Staging Columns
SET @XML = 
 (SELECT '             , s.[' + [column_name] + ']' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

  --select @XML


SET @StagingColumns = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @StagingColumns = REPLACE(@StagingColumns,'^^^             ,', '              ')
 IF @StagingColumns IS NULL
	SET @StagingColumns = ''



-- Merge Update Set
SET @XML = 
 (SELECT '                 , [' + [column_name] + '] = CASE [ChangeType] WHEN ''type 1'' THEN SRC.[' + [column_name] + '] ELSE DST.[' + [column_name] + '] END' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    AND [merge_type] NOT IN ('bk', 't0')
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

--select @XML

SET @MergeUpdateSet = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @MergeUpdateSet = REPLACE(@MergeUpdateSet,'^^^                 ,', ' SET')
 IF @MergeUpdateSet IS NULL
	SET @MergeUpdateSet = ''

    --select @XML



-- Merge Insert List
SET @XML = 
 (SELECT '                 , [' + [column_name] + ']' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    --AND [merge_type] <> 't0'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

SET @MergeInsertList = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @MergeInsertList = REPLACE(@MergeInsertList,'^^^                 ,', '      ')
 IF @MergeInsertList IS NULL
	SET @MergeInsertList = ''


    --select @XML

-- Merge Output List
SET @XML = 
 (SELECT '             , SRC.[' + [column_name] + ']' + CHAR(10) 
  FROM [etl].[dim_column]
  WHERE [server_name] = @StgServer
    AND [database_name] = @DatabaseName
	AND [table_schema] = @StgSchema
	AND [table_name] = @StgTable
    --AND [merge_type] <> 't0'
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

SET @MergeOutputList = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @MergeOutputList = REPLACE(@MergeOutputList,'^^^             ,', '')
 IF @MergeOutputList IS NULL
	SET @MergeOutputList = ''


    --select @XML


-- main select
SELECT @SQL = '"IF OBJECT_ID( ''tempdb..#MergeChanges'') IS NOT NULL DROP TABLE #MergeChanges;
 
SELECT CAST('''' AS NVARCHAR(10)) AS [merge_action_change_row_type]
     , CAST('''' AS NVARCHAR(10)) AS [merge_action_change_dim_type]
     , *
  INTO #MergeChanges
  FROM ' + @StgTableFull + '
 WHERE 1=2;

	    -- determine type 2 changes (intra-day changes are treated as type 1)
		WITH type2 AS
		(
		SELECT ' + @BusKeySelect  + '
   			 , ''type1'' AS [Change]
		  FROM ' + @StgTableFull + ' s
		  JOIN ' + @RptTableFull + ' r
		    ON ' + @BusKeyJoin + '
		 WHERE ( -- detect type 2 attribute changes
' +	 @Type2ChangeCheck + '			    )
		)
		-- determine type 1 changes
		, type1 AS
		(
		SELECT '
   + @BusKeySelect
   + '
   			 , ''type1'' AS [Change]
		  FROM ' + @StgTableFull + ' s
		  JOIN ' + @RptTableFull + ' r
		    ON ' + @BusKeyJoin + '
		 WHERE ( -- detect type 2 attribute changes
' +	 @Type1ChangeCheck + '			    )
		)

		-- determine matches with no changes (all rows not caught above will be treated as type 0 - ignored in merge statement below)
		, nochg AS
		(
		SELECT '
   + @BusKeySelect
   + '
   			 , ''nochg'' AS [Change]
		  FROM ' + @StgTableFull + ' s
		  JOIN ' + @RptTableFull + ' r
		    ON ' + @BusKeyJoin + '
		)
		-- combine all the above CTEs and add no-matches from source
		, staging AS
		(
		SELECT 
' + @StagingColumns + '
			 , CASE WHEN t2.[Change] = ''type2'' THEN ''Type 2''
					WHEN t2.[Change] = ''type1'' THEN ''Type 1''
					WHEN t1.[Change] = ''type1'' THEN ''Type 1''
					WHEN nc.[Change] = ''nochg'' THEN ''No Change''
					ELSE ''Insert''
			   END AS [ChangeType]
		  FROM ' + @StgTableFull + ' s
		  LEFT JOIN ' + @RptTableFull + ' r
		    ON ' + @BusKeyJoin + '
		  LEFT JOIN type1 t1
		    ON ' + @BusKeyJoin_t1 + '
		  LEFT JOIN type2 t2
		    ON ' + @BusKeyJoin_t2 + '
		  LEFT JOIN nochg nc
		    ON ' + @BusKeyJoin_nc + '
		)

		-- Merge statement
		 MERGE ' + @RptTableFull + ' AS DST
		 USING ( SELECT * FROM staging ) AS SRC
		    ON ' + @BusKeyJoin_src + '
		   AND SRC.[ChangeType] != ''No Change''
	
		WHEN MATCHED THEN
		-- Update dimension record
		UPDATE'
		+ @MergeUpdateSet + '

		  -- New records inserted (not used by type 2)
		  WHEN NOT MATCHED AND SRC.[ChangeType] != ''No Change'' THEN 
			INSERT ( 
			' + @MergeInsertList + '
				 )
			VALUES (
			' + @MergeInsertList + '
				 );

    SELECT @@ROWCOUNT AS [row_count];
"'

SET @MergeStatement = @SQL
 
RETURN  @MergeStatement

END















GO
/****** Object:  UserDefinedFunction [biml].[Build Fact Merge (Basic)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 26 May 2016
-- Modify date: 06 Apr 2017 - Added @ServerName
--
-- Description:	Builds a basic Fact table merge
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Build Fact Merge (Basic)] 
	 (  'ETL_DM' -- @StgDatabaseName
	  , 'ETL_DM' -- @DstDatabaseName
	  , 'etl'    -- @StgSchema
	  , 'dbo'    -- @DstSchema
	  , 'v_dbo_fact_table_size' -- @StgTable
      , 'fact_table_size'       -- @DstTable
	 )
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Build Fact Merge (Basic)]
(
	    @stg_server      AS NVARCHAR(128)
	  , @StgDatabaseName AS NVARCHAR(128)
	  , @DstDatabaseName AS NVARCHAR(128)
	  , @StgSchema       AS NVARCHAR(128)
	  , @DstSchema       AS NVARCHAR(128)
	  , @StgTable        AS NVARCHAR(128)
	  , @DstTable        AS NVARCHAR(128)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    
DECLARE @MergeStatement AS NVARCHAR(MAX);
  
DECLARE @StgTableFull VARCHAR(128) = '[' + @StgDatabaseName + '].[' + @StgSchema + '].[' + @StgTable + ']'
	  , @DstTableFull VARCHAR(128) = '[' + @DstDatabaseName + '].[' + @DstSchema + '].[' + @DstTable + ']'
	  , @SQL VARCHAR(MAX)
	  , @XML XML
      , @FactDateColumn VARCHAR(64)
	  , @InsertColumns VARCHAR(MAX)

-- Fact Date
SET @FactDateColumn = 
  ( SELECT [column_name]
      FROM [etl].[dim_column]
     WHERE [server_name] = @stg_server
	   AND [database_name] = @DstDatabaseName
	   AND [table_schema] = @DstSchema
	   AND [table_name] = @DstTable
       AND [merge_type] = 'fd'
  )

 IF @FactDateColumn IS NULL
	BEGIN
		RETURN 'No {Fact Date Column} found'
	END


-- Destination Columns
SET @XML = 
 (SELECT '             , [' + [column_name] + ']' + CHAR(10) 
    FROM [etl].[dim_column]
    WHERE [server_name] = @stg_server
	AND [database_name] = @DstDatabaseName
	AND [table_schema] = @DstSchema
	AND [table_name] = @DstTable
  ORDER BY [ordinal_position]
  FOR XML PATH(''))

SET @InsertColumns = '^^^' + CONVERT(VARCHAR(MAX),@XML)
SET @InsertColumns = REPLACE(@InsertColumns,'^^^             ,', '   ')
 IF @InsertColumns IS NULL
	SET @InsertColumns = ''

-- main select
SELECT @SQL = 'DECLARE @MinFactDate AS DATE
     , @row_count AS INT;

    SELECT @MinFactDate = MIN([' + @FactDateColumn + '])
      FROM ' + @StgTableFull + ';

    DELETE ' + @DstTableFull + '
     WHERE [' + @FactDateColumn + '] >= @MinFactDate;

    SET @row_count = @@ROWCOUNT;

    INSERT ' + @DstTableFull + '
         ( ' + @InsertColumns + ' )

    SELECT ' + @InsertColumns + '
      FROM ' + @StgTableFull + ';

    SET @row_count = @row_count + @@ROWCOUNT

    SELECT @row_count AS [row_count];
'
SET @MergeStatement = @SQL
 
RETURN  @MergeStatement

END













GO
/****** Object:  UserDefinedFunction [biml].[Build Fact Partition (Standard)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 18 Jun 2016
-- Modify date: 30 Aug 2016 - Drive 'truncate' logic by incomming flag
-- Description:	Builds Fact Partition (Standard) Query
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Build Fact Partition (Standard)]
	 (  'PS_Date'  -- @partition_scheme
	  , 'PF_Date'  -- @partition_function
	  , 5		   -- @days_ahead
	  , 12		   -- @day_partitions
	  , 6		   -- @month_partitions
	  , 6	       -- @quarter_partitions
	  , 6		   -- @year_partitions
	  , 'dbo'	   -- @schema_name
	  , 'Part_Fact_Indirect_Sale_Claim_SwitchIn' -- @table_name
	  , 'Y'		   -- @truncate_switch_in
	 )
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Build Fact Partition (Standard)]
(
	    @partition_scheme   AS NVARCHAR(128)
	  , @partition_function AS NVARCHAR(128)
	  , @days_ahead         AS INT
	  , @day_partitions     AS INT
	  , @month_partitions   AS INT
	  , @quarter_partitions AS INT
	  , @year_partitions    AS INT
	  , @schema_name        AS NVARCHAR(128)
	  , @table_name         AS NVARCHAR(128)
	  , @truncate_switch_in AS NVARCHAR(1)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    
DECLARE @PartitionStatement AS NVARCHAR(MAX)
      , @DeclareStatement VARCHAR(MAX)
      , @SQL VARCHAR(MAX);

SET @DeclareStatement = 'DECLARE @partition_scheme AS NVARCHAR(128)  = ''' + @partition_scheme + '''
      , @partition_function AS NVARCHAR(128)  = ''' + @partition_function + '''
	  , @days_ahead INT = ' + CAST(@days_ahead AS NVARCHAR) + '
	  , @day_partitions INT = ' + CAST(@day_partitions AS NVARCHAR) + '
	  , @month_partitions INT = ' + CAST(@month_partitions AS NVARCHAR) + '
	  , @quarter_partitions INT = ' + CAST(@quarter_partitions AS NVARCHAR) + '
	  , @year_partitions INT = ' + CAST(@year_partitions AS NVARCHAR) + '
      , @schema_name AS NVARCHAR(128) = ''' + @schema_name + '''
      , @table_name AS NVARCHAR(128) = ''' + @table_name + '''
	  , @truncate_switch_in AS NVARCHAR(128) = ''' + @truncate_switch_in + '''
	  '

-- main select
SELECT @SQL = @DeclareStatement + '
SET NOCOUNT ON

DECLARE @SQL AS NVARCHAR(4000)
      , @date_part INT
	  , @counter INT
	  , @boundary_date AS DATE

-- get last partition date
DECLARE @boundary DATE = GETDATE() + @days_ahead

-- table variables to store partition boundries
DECLARE @partitions TABLE ([boundary_dates] DATE NOT NULL);
DECLARE @partitions_current TABLE ([boundary_dates] DATE NOT NULL);
DECLARE @partitions_action TABLE ([boundary_dates] DATE NOT NULL);


--------------------------------------------------------------------------------------------------------------------------
-- truncate tmp table to avoid unneeded data movement with subsequent partition split/merge (only with tmp schema)
--------------------------------------------------------------------------------------------------------------------------

IF @truncate_switch_in = ''Y''
	BEGIN
		SET @SQL = ''TRUNCATE TABLE ['' + @schema_name + ''].['' + @table_name + '']''
		PRINT    ''Truncated table: ['' + @schema_name + ''].['' + @table_name + '']''
		EXEC sp_executesql @SQL
	END


--------------------------------------------------------------------------------------------------------------------------
-- create partition boundries
--------------------------------------------------------------------------------------------------------------------------

-- day partitions
SET @counter = 0
WHILE @counter &lt; @day_partitions
BEGIN
	INSERT @partitions VALUES ( @boundary );
	SET @boundary = DATEADD(d, -1, @boundary)
	SET @counter = @counter + 1
END

-- month partition
SET @counter = 0
WHILE @counter &lt; @month_partitions
BEGIN
	SET @boundary = DATEADD(m, DATEDIFF(m, 0, @boundary), 0) -- returns first day of the month
	INSERT @partitions VALUES ( @boundary );
	SET @boundary = DATEADD(d, -1, @boundary)
	SET @counter = @counter + 1
END
SET @boundary = DATEADD(d, -1, @boundary) -- go back an extra day to avoid a duplicate for the next partition

-- quarter partition
SET @counter = 0
WHILE @counter &lt; @quarter_partitions
BEGIN
	SET @boundary = DATEADD(q, DATEDIFF(q, 0, @boundary), 0) -- returns first day of the quarter
	INSERT @partitions VALUES ( @boundary );
	SET @boundary = DATEADD(d, -1, @boundary)
	SET @counter = @counter + 1
END
SET @boundary = DATEADD(d, -1, @boundary) -- go back an extra day to avoid a duplicate for the next partition

-- year partition
SET @counter = 0
WHILE @counter &lt; @year_partitions
BEGIN
	SET @boundary = DATEADD(yyyy, DATEDIFF(yyyy, 0, @boundary), 0) -- returns first day of the year
	INSERT @partitions VALUES ( @boundary );
	SET @boundary = DATEADD(d, -1, @boundary)
	SET @counter = @counter + 1
END
SET @boundary = DATEADD(d, -1, @boundary) -- go back an extra day to avoid a duplicate for the next partition


--------------------------------------------------------------------------------------------------------------------------
-- get existing table partition boundries
--------------------------------------------------------------------------------------------------------------------------

INSERT @partitions_current
SELECT LEFT(CAST(prv.value AS DATE), 10) AS [boundary_value]
  FROM sys.objects AS o
  JOIN sys.schemas AS s
    ON o.[schema_id] = s.[schema_id]
  JOIN sys.partitions AS p
    ON o.[object_id] = p.[object_id]
  JOIN sys.indexes AS i
    ON p.[object_id] = i.[object_id]
   AND p.index_id = i.index_id
  JOIN sys.data_spaces AS ds
    ON i.data_space_id = ds.data_space_id
  LEFT OUTER JOIN sys.partition_schemes AS ps
    ON ds.data_space_id = ps.data_space_id
  LEFT OUTER JOIN sys.partition_functions AS pf
    ON ps.function_id = pf.function_id
  LEFT OUTER JOIN sys.partition_range_values AS prv
    ON pf.function_id = prv.function_id
   AND p.partition_number = prv.boundary_id
 WHERE s.name = @schema_name -- schema name
   AND o.name = @table_name -- table name
   AND prv.value IS NOT NULL
 ORDER BY [boundary_value];


--------------------------------------------------------------------------------------------------------------------------
-- add partition boundries
--------------------------------------------------------------------------------------------------------------------------

INSERT @partitions_action
SELECT [boundary_dates] FROM @partitions
EXCEPT
SELECT [boundary_dates] FROM @partitions_current

DECLARE [proc_cursor] CURSOR FOR  
SELECT [boundary_dates]
  FROM @partitions_action
OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @boundary_date

WHILE @@FETCH_STATUS = 0   
BEGIN 

	SET @SQL = ''ALTER PARTITION SCHEME ['' + @partition_scheme + ''] NEXT USED [PRIMARY];''
	EXEC sp_executesql @SQL

	SET @SQL = ''ALTER PARTITION FUNCTION ['' + @partition_function + '']() SPLIT RANGE ('''''' + CAST(@boundary_date AS VARCHAR) + '''''');''
	EXEC sp_executesql @SQL

	PRINT ''Added partition boundry: '' + CAST(@boundary_date AS VARCHAR)
	FETCH NEXT FROM [proc_cursor] INTO @boundary_date
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];


--------------------------------------------------------------------------------------------------------------------------
-- remove partition boundries
--------------------------------------------------------------------------------------------------------------------------
DELETE FROM @partitions_action

INSERT @partitions_action
SELECT [boundary_dates] FROM @partitions_current
EXCEPT
SELECT [boundary_dates] FROM @partitions

DECLARE [proc_cursor] CURSOR FOR  
SELECT [boundary_dates]
  FROM @partitions_action
OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @boundary_date

WHILE @@FETCH_STATUS = 0   
BEGIN 

	SET @SQL = ''ALTER PARTITION FUNCTION ['' + @partition_function + '']() MERGE RANGE ('''''' + CAST(@boundary_date AS VARCHAR) + '''''');''
	EXEC sp_executesql @SQL  

	PRINT ''Removed partition boundry: '' + CAST(@boundary_date AS VARCHAR)
	FETCH NEXT FROM [proc_cursor] INTO @boundary_date
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];

SELECT 0 AS [row_count];
'
SET @PartitionStatement = @SQL
 
RETURN  @PartitionStatement

END














GO
/****** Object:  UserDefinedFunction [biml].[Build Fact Switch (Standard)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =======================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 18 Jun 2016
-- Modify date: 30 Aug 2016 - changed Truncate 'out' logic to be first and last in bottom SWITCH commands
-- Modify date: 18 Oct 2016 - fixed bug on first SWITCH sql statement, added SWITCH options 1, 2, & 3
-- Description:	Builds Fact Switch (Standard) Query
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Build Fact Switch (Standard)]
	 (  'tmp'                -- @src_schema_name
	  , 'FactInternetSales'  -- @src_table_name
	  , 'stg'				 -- @dst_schema_name
	  , 'FactInternetSales1' -- @dst_table_name
	  , 'trnk'				 -- @out_schema_name
	  , 'FactInternetSales'  -- @out_table_name
	  , 1					 -- @switch_option
	  , 'param_name'		 -- @project_parameter
	 )
*/
-- =======================================================================================================

CREATE FUNCTION [biml].[Build Fact Switch (Standard)]
(
		@src_schema_name AS NVARCHAR(128)
      , @src_table_name AS NVARCHAR(128)
      , @dst_schema_name AS NVARCHAR(128) 
      , @dst_table_name AS NVARCHAR(128)
      , @out_schema_name AS NVARCHAR(128) 
      , @out_table_name AS NVARCHAR(128) 
	  , @switch_option AS INT
	  , @project_parameter AS NVARCHAR(128) = null

)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    
DECLARE @PartitionStatement AS NVARCHAR(MAX)
      , @DeclareOption VARCHAR(MAX)
      , @DeclareStatement VARCHAR(MAX)
      , @SQL VARCHAR(MAX);

SET @DeclareOption = CASE @switch_option
						WHEN 2 THEN '"DECLARE @start_date AS DATE =  ''" +  (DT_WSTR, 10) (DT_DBDATE) @[User::today] + "'''
						WHEN 3 THEN '"DECLARE @start_date AS DATE =  ''" +  (DT_WSTR, 10) (DT_DBDATE) @[User::yesterday] + "'''
						WHEN 4 THEN '"DECLARE @start_date AS DATE =  ''" +  (DT_WSTR, 10) (DT_DBDATE) @[$Project::' + @project_parameter + '] + "'''
						ELSE '"DECLARE @start_date AS DATE =  ''" +  (DT_WSTR, 10) (DT_DBDATE) @[$Package::start_date] + "'''
					 END

SET @DeclareStatement = @DeclareOption + '   
      , @src_schema_name AS NVARCHAR(128)   = ''' + @src_schema_name + '''
      , @src_table_name AS NVARCHAR(128)    = ''' + @src_table_name + '''
      , @dst_schema_name AS NVARCHAR(128)   = ''' + @dst_schema_name + '''
      , @dst_table_name AS NVARCHAR(128)    = ''' + @dst_table_name + '''
      , @out_schema_name AS NVARCHAR(128)   = ''' + @out_schema_name + '''
      , @out_table_name AS NVARCHAR(128)    = ''' + @out_table_name + '''
	  '

-- main select
SELECT @SQL = @DeclareStatement + '
SET NOCOUNT ON

DECLARE @partition_start AS INT
      , @partition_end AS INT
      , @partition AS INT
      , @SQL	AS NVARCHAR(MAX);

DECLARE @partitions 
  TABLE ( [partition_number] INT NOT NULL
		, [begin_date] DATE NULL
		, [end_date] DATE NULL);


--------------------------------------------------------------------------------------------------------------------------
-- get existing table partition boundries
--------------------------------------------------------------------------------------------------------------------------

INSERT @partitions
SELECT p.partition_number + 1
	 , LEFT(CAST(prv.value AS DATE), 10) AS [begin_date]
	 , null AS [end_date]
  FROM sys.objects AS o
  JOIN sys.schemas AS s
    ON o.[schema_id] = s.[schema_id]
  JOIN sys.partitions AS p
    ON o.[object_id] = p.[object_id]
  JOIN sys.indexes AS i
    ON p.[object_id] = i.[object_id]
   AND p.index_id = i.index_id
  JOIN sys.data_spaces AS ds
    ON i.data_space_id = ds.data_space_id
  LEFT OUTER JOIN sys.partition_schemes AS ps
    ON ds.data_space_id = ps.data_space_id
  LEFT OUTER JOIN sys.partition_functions AS pf
    ON ps.function_id = pf.function_id
  LEFT OUTER JOIN sys.partition_range_values AS prv
    ON pf.function_id = prv.function_id
   AND p.partition_number = prv.boundary_id
 WHERE s.name = @src_schema_name -- schema name
   AND o.name = @src_table_name -- table name
   AND prv.value IS NOT NULL
 ORDER BY [begin_date];


--------------------------------------------------------------------------------------------------------------------------
-- find starting and ending partition dates
--------------------------------------------------------------------------------------------------------------------------

INSERT @partitions VALUES (1, NULL, NULL);

WITH [table_copy] AS
( 
SELECT * FROM @partitions 
)
UPDATE @partitions
   SET [end_date] = DATEADD(d, -1, p2.begin_date)
  FROM @partitions p1
  JOIN [table_copy] p2
    ON p2.[partition_number] = p1.[partition_number] + 1


--------------------------------------------------------------------------------------------------------------------------
-- find starting and ending partition numbers
--------------------------------------------------------------------------------------------------------------------------

IF @start_date &lt; ''1980-01-01'' -- treat as FULL table refresh
	BEGIN
		SET @partition_start = 1
	END
ELSE
	BEGIN
		SELECT @partition_start = [partition_number]
		  FROM @partitions
		 WHERE [begin_date] = @start_date
		 IF @partition_start IS NULL  -- no exact match. use next partition to avoid a partial partition refresh
			BEGIN
				SELECT @partition_start = MIN([partition_number])
			      FROM @partitions
		         WHERE [begin_date] &gt; @start_date
			END
	END

IF @partition_start IS NULL
	BEGIN
		PRINT ''No Applicable Partition Number Found!''
		RETURN
	END

SELECT @partition_end = MAX([partition_number])
  FROM @partitions


--------------------------------------------------------------------------------------------------------------------------
-- execute partition switching
--------------------------------------------------------------------------------------------------------------------------

SET @partition = @partition_start

SET @SQL = ''TRUNCATE TABLE ['' + @out_schema_name + ''].['' + @out_table_name + ''];''
EXEC sp_executesql @SQL

WHILE @partition &lt;= @partition_end
BEGIN  

	SET @SQL = ''ALTER TABLE ['' + @dst_schema_name + ''].['' + @dst_table_name + ''] SWITCH PARTITION '' + CAST(@partition AS NVARCHAR) + '' TO ['' + @out_schema_name + ''].['' + @out_table_name + ''] PARTITION '' + CAST(@partition AS NVARCHAR) + ''  ;''
	EXEC sp_executesql @SQL

	SET @SQL = ''ALTER TABLE ['' + @src_schema_name + ''].['' + @src_table_name + ''] SWITCH PARTITION '' + CAST(@partition AS NVARCHAR) + '' TO ['' + @dst_schema_name + ''].['' + @dst_table_name + ''] PARTITION '' + CAST(@partition AS NVARCHAR) + ''  ;''
	EXEC sp_executesql @SQL

	SET @partition = @partition + 1

END

SET @SQL = ''TRUNCATE TABLE ['' + @out_schema_name + ''].['' + @out_table_name + ''];''
EXEC sp_executesql @SQL

SELECT 0 AS [row_count];"
'
SET @PartitionStatement = @SQL
 
RETURN  @PartitionStatement

END















GO
/****** Object:  UserDefinedFunction [biml].[Build Fact Switch (Standard) jic]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =======================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 18 Jun 2016
-- Modify date: 30 Aug 2016 - changed Truncate 'out' logic to be first and last in bottom SWITCH commands
-- Modify date: 18 Oct 2016 - fixed bug on first SWITCH sql statement, added SWITCH options 1, 2, & 3
-- Description:	Builds Fact Switch (Standard) Query
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Build Fact Switch (Standard)]
	 (  'tmp'                -- @src_schema_name
	  , 'FactInternetSales'  -- @src_table_name
	  , 'stg'				 -- @dst_schema_name
	  , 'FactInternetSales1' -- @dst_table_name
	  , 'trnk'				 -- @out_schema_name
	  , 'FactInternetSales'  -- @out_table_name
	  , 1					 -- @switch_option
	  , 'param_name'		 -- @project_parameter
	 )
*/
-- =======================================================================================================

create FUNCTION [biml].[Build Fact Switch (Standard) jic]
(
		@src_schema_name AS NVARCHAR(128)
      , @src_table_name AS NVARCHAR(128)
      , @dst_schema_name AS NVARCHAR(128) 
      , @dst_table_name AS NVARCHAR(128)
      , @out_schema_name AS NVARCHAR(128) 
      , @out_table_name AS NVARCHAR(128) 
	  , @switch_option AS INT
	  , @project_parameter AS NVARCHAR(128) = null

)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    
DECLARE @PartitionStatement AS NVARCHAR(MAX)
      , @DeclareOption VARCHAR(MAX)
      , @DeclareStatement VARCHAR(MAX)
      , @SQL VARCHAR(MAX);

SET @DeclareOption = CASE @switch_option
						WHEN 2 THEN '"DECLARE @start_date AS DATE =  ''" +  (DT_WSTR, 10) (DT_DBDATE) @[User::today] + "'
						WHEN 3 THEN '"DECLARE @start_date AS DATE =  ''" +  (DT_WSTR, 10) (DT_DBDATE) @[User::yesterday] + "'
						WHEN 4 THEN '"DECLARE @start_date AS DATE =  ''" +  (DT_WSTR, 10) (DT_DBDATE) @[$Project::''' + @project_parameter + '''] + "'
						ELSE '"DECLARE @start_date AS DATE =  ''" +  (DT_WSTR, 10) (DT_DBDATE) @[$Package::start_date] + "'
					 END

SET @DeclareStatement = '"DECLARE @start_date AS DATE =  ''" +  (DT_WSTR, 10) (DT_DBDATE) @[$Package::start_date] + "''   
      , @src_schema_name AS NVARCHAR(128)   = ''' + @src_schema_name + '''
      , @src_table_name AS NVARCHAR(128)    = ''' + @src_table_name + '''
      , @dst_schema_name AS NVARCHAR(128)   = ''' + @dst_schema_name + '''
      , @dst_table_name AS NVARCHAR(128)    = ''' + @dst_table_name + '''
      , @out_schema_name AS NVARCHAR(128)   = ''' + @out_schema_name + '''
      , @out_table_name AS NVARCHAR(128)    = ''' + @out_table_name + '''
	  '
IF @switch_option = 2
	SET @DeclareStatement = '"DECLARE @start_date AS DATE =  ''" +  (DT_WSTR, 10) (DT_DBDATE) @[User::today] + "''   
		  , @src_schema_name AS NVARCHAR(128)   = ''' + @src_schema_name + '''
		  , @src_table_name AS NVARCHAR(128)    = ''' + @src_table_name + '''
		  , @dst_schema_name AS NVARCHAR(128)   = ''' + @dst_schema_name + '''
		  , @dst_table_name AS NVARCHAR(128)    = ''' + @dst_table_name + '''
		  , @out_schema_name AS NVARCHAR(128)   = ''' + @out_schema_name + '''
		  , @out_table_name AS NVARCHAR(128)    = ''' + @out_table_name + '''
		  '
IF @switch_option = 3
	SET @DeclareStatement = '"DECLARE @start_date AS DATE =  ''" +  (DT_WSTR, 10) (DT_DBDATE) @[User::yesterday] + "''   
		  , @src_schema_name AS NVARCHAR(128)   = ''' + @src_schema_name + '''
		  , @src_table_name AS NVARCHAR(128)    = ''' + @src_table_name + '''
		  , @dst_schema_name AS NVARCHAR(128)   = ''' + @dst_schema_name + '''
		  , @dst_table_name AS NVARCHAR(128)    = ''' + @dst_table_name + '''
		  , @out_schema_name AS NVARCHAR(128)   = ''' + @out_schema_name + '''
		  , @out_table_name AS NVARCHAR(128)    = ''' + @out_table_name + '''
		  '
IF @switch_option = 4
	SET @DeclareStatement = '"DECLARE @start_date AS DATE =  ''" +  (DT_WSTR, 10) (DT_DBDATE) @[$Project::''' + @project_parameter + '''] + "''   
		  , @src_schema_name AS NVARCHAR(128)   = ''' + @src_schema_name + '''
		  , @src_table_name AS NVARCHAR(128)    = ''' + @src_table_name + '''
		  , @dst_schema_name AS NVARCHAR(128)   = ''' + @dst_schema_name + '''
		  , @dst_table_name AS NVARCHAR(128)    = ''' + @dst_table_name + '''
		  , @out_schema_name AS NVARCHAR(128)   = ''' + @out_schema_name + '''
		  , @out_table_name AS NVARCHAR(128)    = ''' + @out_table_name + '''
		  '

-- main select
SELECT @SQL = @DeclareStatement + '
SET NOCOUNT ON

DECLARE @partition_start AS INT
      , @partition_end AS INT
      , @partition AS INT
      , @SQL	AS NVARCHAR(MAX);

DECLARE @partitions 
  TABLE ( [partition_number] INT NOT NULL
		, [begin_date] DATE NULL
		, [end_date] DATE NULL);


--------------------------------------------------------------------------------------------------------------------------
-- get existing table partition boundries
--------------------------------------------------------------------------------------------------------------------------

INSERT @partitions
SELECT p.partition_number + 1
	 , LEFT(CAST(prv.value AS DATE), 10) AS [begin_date]
	 , null AS [end_date]
  FROM sys.objects AS o
  JOIN sys.schemas AS s
    ON o.[schema_id] = s.[schema_id]
  JOIN sys.partitions AS p
    ON o.[object_id] = p.[object_id]
  JOIN sys.indexes AS i
    ON p.[object_id] = i.[object_id]
   AND p.index_id = i.index_id
  JOIN sys.data_spaces AS ds
    ON i.data_space_id = ds.data_space_id
  LEFT OUTER JOIN sys.partition_schemes AS ps
    ON ds.data_space_id = ps.data_space_id
  LEFT OUTER JOIN sys.partition_functions AS pf
    ON ps.function_id = pf.function_id
  LEFT OUTER JOIN sys.partition_range_values AS prv
    ON pf.function_id = prv.function_id
   AND p.partition_number = prv.boundary_id
 WHERE s.name = @src_schema_name -- schema name
   AND o.name = @src_table_name -- table name
   AND prv.value IS NOT NULL
 ORDER BY [begin_date];


--------------------------------------------------------------------------------------------------------------------------
-- find starting and ending partition dates
--------------------------------------------------------------------------------------------------------------------------

INSERT @partitions VALUES (1, NULL, NULL);

WITH [table_copy] AS
( 
SELECT * FROM @partitions 
)
UPDATE @partitions
   SET [end_date] = DATEADD(d, -1, p2.begin_date)
  FROM @partitions p1
  JOIN [table_copy] p2
    ON p2.[partition_number] = p1.[partition_number] + 1


--------------------------------------------------------------------------------------------------------------------------
-- find starting and ending partition numbers
--------------------------------------------------------------------------------------------------------------------------

IF @start_date &lt; ''1980-01-01'' -- treat as FULL table refresh
	BEGIN
		SET @partition_start = 1
	END
ELSE
	BEGIN
		SELECT @partition_start = [partition_number]
		  FROM @partitions
		 WHERE [begin_date] = @start_date
		 IF @partition_start IS NULL  -- no exact match. use next partition to avoid a partial partition refresh
			BEGIN
				SELECT @partition_start = MIN([partition_number])
			      FROM @partitions
		         WHERE [begin_date] &gt; @start_date
			END
	END

IF @partition_start IS NULL
	BEGIN
		PRINT ''No Applicable Partition Number Found!''
		RETURN
	END

SELECT @partition_end = MAX([partition_number])
  FROM @partitions


--------------------------------------------------------------------------------------------------------------------------
-- execute partition switching
--------------------------------------------------------------------------------------------------------------------------

SET @partition = @partition_start

SET @SQL = ''TRUNCATE TABLE ['' + @out_schema_name + ''].['' + @out_table_name + ''];''
EXEC sp_executesql @SQL

WHILE @partition &lt;= @partition_end
BEGIN  

	SET @SQL = ''ALTER TABLE ['' + @dst_schema_name + ''].['' + @dst_table_name + ''] SWITCH PARTITION '' + CAST(@partition AS NVARCHAR) + '' TO ['' + @out_schema_name + ''].['' + @out_table_name + ''] PARTITION '' + CAST(@partition AS NVARCHAR) + ''  ;''
	EXEC sp_executesql @SQL

	SET @SQL = ''ALTER TABLE ['' + @src_schema_name + ''].['' + @src_table_name + ''] SWITCH PARTITION '' + CAST(@partition AS NVARCHAR) + '' TO ['' + @dst_schema_name + ''].['' + @dst_table_name + ''] PARTITION '' + CAST(@partition AS NVARCHAR) + ''  ;''
	EXEC sp_executesql @SQL

	SET @partition = @partition + 1

END

SET @SQL = ''TRUNCATE TABLE ['' + @out_schema_name + ''].['' + @out_table_name + ''];''
EXEC sp_executesql @SQL

SELECT 0 AS [row_count];"
'
SET @PartitionStatement = @SQL
 
RETURN  @PartitionStatement

END















GO
/****** Object:  UserDefinedFunction [biml].[Build Select Statement]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 01 May 2017
-- Modify date: 04 May 2017 - When the source and destination column names are the same,
-- Modify date: 04 May 2017 -   then override the 'simple match' so an 'expression' can be used
-- Modify date: 05 May 2017 - Order the 'alias match updates' (4 of them) to first run for 'scope', then for all (*)
--
-- Description:	Generate a Select statement based on metadata and column aliases
--
-- Sample Execute Command: 
/*	
PRINT [biml].[Build Select Statement]
	 (  'Appt1'            -- @match_scope
	  , 'JIM-HP'           -- @src_server
	  , 'germane'          -- @src_database
	  , 'dbo'              -- @src_schema
	  , 'AppointmentsRaw'  -- @src_table
	  , 'JIM-HP'           -- @dst_server
	  , 'germane'          -- @dst_database
	  , 'dbo'              -- @dst_schema
      , 'ZS_Appointments'  -- @dst_table
	 ) 
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Build Select Statement]
(
		@match_scope  NVARCHAR(128)
	  , @src_server   NVARCHAR(128)
	  , @src_database NVARCHAR(128)
	  , @src_schema   NVARCHAR(128)
	  , @src_table    NVARCHAR(128)
	  , @dst_server   NVARCHAR(128)
	  , @dst_database NVARCHAR(128)
	  , @dst_schema   NVARCHAR(128)
	  , @dst_table    NVARCHAR(128)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    
DECLARE @match TABLE
	(   [dst_ORDINAL_POSITION] INT NOT NULL
	  , [src_COLUMN_NAME] NVARCHAR(128) NULL
	  , [src_IS_NULLABLE] NVARCHAR(3) NULL
	  , [src_DATA_TYPE] NVARCHAR(128) NULL
	  , [src_MAXIMUM_LENGTH] INT NULL
	  , [dst_COLUMN_NAME] NVARCHAR(128) NOT NULL
	  , [dst_IS_NULLABLE] NVARCHAR(3) NOT NULL
	  , [dst_DATA_TYPE] NVARCHAR(128) NOT NULL
	  , [dst_MAXIMUM_LENGTH] INT NULL
	)

   INSERT @match
   SELECT c.[ordinal_position] AS [dst_ORDINAL_POSITION]
		, NULL AS [src_COLUMN_NAME]
		, NULL AS [src_IS_NULLABLE]
		, NULL AS [src_DATA_TYPE]
		, NULL AS [src_MAXIMUM_LENGTH]
		, c.[column_name] AS [dst_COLUMN_NAME] 
		, CAST(c.[is_nullable] AS NVARCHAR(3)) AS [dst_IS_NULLABLE]
		, c.[data_type] AS [dst_DATA_TYPE]
		, c.[char_max_length] AS [dst_MAXIMUM_LENGTH] 
	 FROM [etl].[dim_column] c
    WHERE c.[server_name]   = @dst_server
	  AND c.[database_name] = @dst_database
	  AND c.[table_schema]  = @dst_schema
	  AND c.[table_name]    = @dst_table;


DECLARE @source TABLE
	(   [src_COLUMN_NAME] NVARCHAR(128) NOT NULL
	  , [src_IS_NULLABLE] NVARCHAR(3) NOT NULL
	  , [src_DATA_TYPE] NVARCHAR(128) NOT NULL
	  , [src_MAXIMUM_LENGTH] INT NULL
	)

   INSERT @source
   SELECT c.[column_name] AS [src_COLUMN_NAME] 
		, CAST(c.[is_nullable] AS NVARCHAR(3)) AS [src_IS_NULLABLE]
		, c.[data_type] AS [src_DATA_TYPE]
		, c.[char_max_length] AS [src_MAXIMUM_LENGTH] 
	 FROM [etl].[dim_column] c
    WHERE c.[server_name]   = @src_server
	  AND c.[database_name] = @src_database
	  AND c.[table_schema]  = @src_schema
	  AND c.[table_name]    = @src_table;


-- simple match update
UPDATE @match
   SET [src_COLUMN_NAME] = '[' + s.[src_COLUMN_NAME] + ']' 
  FROM @match m
  JOIN @source s
    ON s.[src_COLUMN_NAME] = m.[dst_COLUMN_NAME]


-- alias match update (scope)
UPDATE @match
   SET [src_COLUMN_NAME] = 
		CASE WHEN RTRIM(ISNULL(a.[use_expression],'')) = '' THEN '[' + a.[alias_name] + ']'
		     ELSE REPLACE(a.[use_expression], '[]', '[' + a.[alias_name] + ']')
			 END
  FROM @source s
  JOIN [biml].[column_alias] a
    ON a.[alias_name] = s.[src_COLUMN_NAME]
 --AND ( a.[scope] = '*' OR a.[scope] = @match_scope )
   AND a.[scope] = @match_scope
  JOIN @match m
    ON m.[dst_COLUMN_NAME] = a.[schema_name]
 WHERE m.[src_COLUMN_NAME] IS NULL


-- alias match update (all)
UPDATE @match
   SET [src_COLUMN_NAME] = 
		CASE WHEN RTRIM(ISNULL(a.[use_expression],'')) = '' THEN '[' + a.[alias_name] + ']'
		     ELSE REPLACE(a.[use_expression], '[]', '[' + a.[alias_name] + ']')
			 END
  FROM @source s
  JOIN [biml].[column_alias] a
    ON a.[alias_name] = s.[src_COLUMN_NAME]
   AND a.[scope] = '*'
  JOIN @match m
    ON m.[dst_COLUMN_NAME] = a.[schema_name]
 WHERE m.[src_COLUMN_NAME] IS NULL


-- alias match update with simple match override (scope)
UPDATE @match
   SET [src_COLUMN_NAME] = 
		CASE WHEN RTRIM(ISNULL(a.[use_expression],'')) = '' THEN '[' + a.[alias_name] + ']'
		     ELSE REPLACE(a.[use_expression], '[]', '[' + a.[alias_name] + ']')
			 END
  FROM @source s
  JOIN [biml].[column_alias] a
    ON a.[alias_name] = s.[src_COLUMN_NAME]
   AND a.[scope] = @match_scope
  JOIN @match m
    ON m.[dst_COLUMN_NAME] = a.[schema_name]
 WHERE m.[src_COLUMN_NAME] = '[' + m.[dst_COLUMN_NAME] + ']' 


-- alias match update with simple match override (all)
UPDATE @match
   SET [src_COLUMN_NAME] = 
		CASE WHEN RTRIM(ISNULL(a.[use_expression],'')) = '' THEN '[' + a.[alias_name] + ']'
		     ELSE REPLACE(a.[use_expression], '[]', '[' + a.[alias_name] + ']')
			 END
  FROM @source s
  JOIN [biml].[column_alias] a
    ON a.[alias_name] = s.[src_COLUMN_NAME]
   AND a.[scope] = '*'
  JOIN @match m
    ON m.[dst_COLUMN_NAME] = a.[schema_name]
 WHERE m.[src_COLUMN_NAME] = '[' + m.[dst_COLUMN_NAME] + ']' 


-- global schema update
UPDATE @match
   SET [src_COLUMN_NAME] = 
		CASE WHEN RTRIM(ISNULL(a.[use_expression],'')) = '' THEN '!!ERROR!!'
		     ELSE a.[use_expression]
			 END
  FROM @source s
  JOIN [biml].[column_alias] a
    ON a.[alias_name] = '*'
   AND ( a.[scope] = '*' OR a.[scope] = @match_scope )
  JOIN @match m
    ON m.[dst_COLUMN_NAME] = a.[schema_name]
 WHERE m.[src_COLUMN_NAME] IS NULL


DECLARE @ColumnXML XML
	  , @ColumnSTR VARCHAR(MAX)
	  , @select_statement VARCHAR(MAX);


SELECT @ColumnXML = 
		( SELECT '    , ' + ISNULL([src_COLUMN_NAME], 'NULL') + ' AS [' + [dst_COLUMN_NAME] + ']' + CHAR(10) 
			FROM @match
		ORDER BY [dst_ORDINAL_POSITION]
		 FOR XML PATH(''));

/* remove first comma */
SET @ColumnSTR = '^^^' + CONVERT(VARCHAR(MAX), @ColumnXML)
SET @ColumnSTR = CHAR(10) + REPLACE(@ColumnSTR,'^^^    , ', '      ');

SET @select_statement = 'SELECT ' + @ColumnSTR + ' FROM ' + '[' + @src_schema + '].[' + @src_table + ']'

 
RETURN  @select_statement

END

GO
/****** Object:  UserDefinedFunction [biml].[Build Select Statement (Direct)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 28 Apr 2017
-- Modify date: 
--
-- Description:	Generate a Select statement based on direct INFORMATION_SCHEMA and column aliases
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Build Select Statement]
	 (  'Appt1'            -- @match_scope
	  , 'dbo'              -- @src_schema
	  , 'AppointmentsRaw'  -- @src_table
	  , 'dbo'              -- @dst_schema
      , 'ZS_Appointments'  -- @dst_table
	 )
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Build Select Statement (Direct)]
(
		@match_scope NVARCHAR(128) = 'Appt1'
	  , @src_schema NVARCHAR(128) = 'dbo'
	  , @src_table  NVARCHAR(128) = 'AppointmentsRaw'
	  , @dst_schema NVARCHAR(128) = 'dbo'
	  , @dst_table  NVARCHAR(128) = 'ZS_Appointments'
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    
DECLARE @match TABLE
	(   [dst_ORDINAL_POSITION] INT NOT NULL
	  , [src_COLUMN_NAME] NVARCHAR(128) NULL
	  , [src_IS_NULLABLE] NVARCHAR(3) NULL
	  , [src_DATA_TYPE] NVARCHAR(128) NULL
	  , [src_MAXIMUM_LENGTH] INT NULL
	  , [dst_COLUMN_NAME] NVARCHAR(128) NOT NULL
	  , [dst_IS_NULLABLE] NVARCHAR(3) NOT NULL
	  , [dst_DATA_TYPE] NVARCHAR(128) NOT NULL
	  , [dst_MAXIMUM_LENGTH] INT NULL
	)

   INSERT @match
   SELECT c.[ORDINAL_POSITION] AS [dst_ORDINAL_POSITION]
		, NULL AS [src_COLUMN_NAME]
		, NULL AS [src_IS_NULLABLE]
		, NULL AS [src_DATA_TYPE]
		, NULL AS [src_MAXIMUM_LENGTH]
		, c.[COLUMN_NAME] AS [dst_COLUMN_NAME] 
		, CAST(c.[IS_NULLABLE] AS NVARCHAR(3)) AS [dst_IS_NULLABLE]
		, c.[DATA_TYPE] AS [dst_DATA_TYPE]
		, c.[CHARACTER_MAXIMUM_LENGTH] AS [dst_MAXIMUM_LENGTH] 
	FROM [germane].INFORMATION_SCHEMA.COLUMNS c 
   WHERE c.[TABLE_SCHEMA] = @dst_schema
	 AND c.[TABLE_NAME] = @dst_table;


DECLARE @source TABLE
	(   [src_COLUMN_NAME] NVARCHAR(128) NOT NULL
	  , [src_IS_NULLABLE] NVARCHAR(3) NOT NULL
	  , [src_DATA_TYPE] NVARCHAR(128) NOT NULL
	  , [src_MAXIMUM_LENGTH] INT NULL
	)

   INSERT @source
   SELECT c.[COLUMN_NAME] AS [src_COLUMN_NAME] 
		, CAST(c.[IS_NULLABLE] AS NVARCHAR(3)) AS [src_IS_NULLABLE]
		, c.[DATA_TYPE] AS [src_DATA_TYPE]
		, c.[CHARACTER_MAXIMUM_LENGTH] AS [src_MAXIMUM_LENGTH] 
	FROM [germane].INFORMATION_SCHEMA.COLUMNS c 
   WHERE c.[TABLE_SCHEMA] = @src_schema
	 AND c.[TABLE_NAME] = @src_table;


-- simple match update
UPDATE @match
   SET [src_COLUMN_NAME] = '[' + s.[src_COLUMN_NAME] + ']' 
  FROM @match m
  JOIN @source s
    ON s.[src_COLUMN_NAME] = m.[dst_COLUMN_NAME]


-- alias match update
UPDATE @match
   SET [src_COLUMN_NAME] = 
		CASE WHEN RTRIM(ISNULL(a.[use_expression],'')) = '' THEN '[' + a.[alias_name] + ']'
		     ELSE REPLACE(a.[use_expression], '[]', '[' + a.[alias_name] + ']')
			 END
  FROM @source s
  JOIN [bimlsnap_v2].[biml].[column_alias] a
    ON a.[alias_name] = s.[src_COLUMN_NAME]
   AND ( a.[scope] = '*' OR a.[scope] = @match_scope )
  JOIN @match m
    ON m.[dst_COLUMN_NAME] = a.[schema_name]
 WHERE m.[src_COLUMN_NAME] IS NULL


-- global schema update
UPDATE @match
   SET [src_COLUMN_NAME] = 
		CASE WHEN RTRIM(ISNULL(a.[use_expression],'')) = '' THEN '!!ERROR!!'
		     ELSE a.[use_expression]
			 END
  FROM @source s
  JOIN [bimlsnap_v2].[biml].[column_alias] a
    ON a.[alias_name] = '*'
   AND ( a.[scope] = '*' OR a.[scope] = @match_scope )
  JOIN @match m
    ON m.[dst_COLUMN_NAME] = a.[schema_name]
 WHERE m.[src_COLUMN_NAME] IS NULL


DECLARE @ColumnXML XML
	  , @ColumnSTR VARCHAR(MAX)
	  , @select_statement VARCHAR(MAX);


SELECT @ColumnXML = 
		( SELECT '    , ' + ISNULL([src_COLUMN_NAME], 'NULL') + ' AS [' + [dst_COLUMN_NAME] + ']' + CHAR(10) 
			FROM @match
		ORDER BY [dst_ORDINAL_POSITION]
		 FOR XML PATH(''));

/* remove first comma */
SET @ColumnSTR = '^^^' + CONVERT(VARCHAR(MAX), @ColumnXML)
SET @ColumnSTR = CHAR(10) + REPLACE(@ColumnSTR,'^^^    , ', '      ');

SET @select_statement = 'SELECT ' + @ColumnSTR + ' FROM ' + '[' + @src_schema + '].[' + @src_table + ']'

 
RETURN  @select_statement

END

















GO
/****** Object:  UserDefinedFunction [biml].[Data Connect String]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 25 Aug 2016
-- Modify date: 23 Sep 2016 - bug fix (added @connection_name to each WHERE clause)
-- Modify date: 24 Sep 2016 - added logic for custom_connect_string
-- Description:	Returns a Data Connect String
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Data Connect String] ('ETL_DM', '')
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Data Connect String] ( @connection_name AS NVARCHAR(128), @environment AS NVARCHAR(32) )

RETURNS NVARCHAR(1024)
AS
BEGIN
    
DECLARE @ConnectString AS NVARCHAR(1024)
	  , @CustomConnectString AS NVARCHAR(1024);

DECLARE @UseServer   AS NVARCHAR(512)
	  , @UseDatabase AS NVARCHAR(512)
	  , @UseProvider AS NVARCHAR(512)
	  , @UseConnectString AS NVARCHAR(1024);


 -- look for environment parameter substitutes
SELECT @UseServer = ep.[parameter_value]
  FROM [biml].[environment_parameter] ep
  JOIN [biml].[connection] cn
    ON cn.[connection_name] + '_Server' = ep.[parameter_name]
 WHERE ep.[environment_name] = @environment
   AND cn.[connection_name] = @connection_name

SELECT @UseDatabase = ep.[parameter_value]
  FROM [biml].[environment_parameter] ep
  JOIN [biml].[connection] cn
    ON cn.[connection_name] + '_Database' = ep.[parameter_name]
 WHERE ep.[environment_name] = @environment
   AND cn.[connection_name] = @connection_name

SELECT @UseProvider = ep.[parameter_value]
  FROM [biml].[environment_parameter] ep
  JOIN [biml].[connection] cn
    ON cn.[connection_name] + '_Provider' = ep.[parameter_name]
 WHERE ep.[environment_name] = @environment
   AND cn.[connection_name] = @connection_name

SELECT @UseConnectString = ep.[parameter_value]
  FROM [biml].[environment_parameter] ep
  JOIN [biml].[connection] cn
    ON cn.[connection_name] + '_ConnectString' = ep.[parameter_name]
 WHERE ep.[environment_name] = @environment
   AND cn.[connection_name] = @connection_name


 -- assemble windows integrated connect string (return value cannot be null)
SELECT @ConnectString =   'Data Source='      + COALESCE(@UseServer  , [server_name]) 
						+ ';Initial Catalog=' + COALESCE(@UseDatabase, [database_name])
						+ ';Provider='        + COALESCE(@UseProvider, [provider])
						+ ';Integrated Security=SSPI;Auto Translate=False;'
  FROM [biml].[connection]
 WHERE [connection_name] = @connection_name

 -- determine custom connect string (return value cannot be null)
SELECT @CustomConnectString = [custom_connect_string]
  FROM [biml].[connection]
 WHERE [connection_name] = @connection_name

IF RTRIM(ISNULL(@UseConnectString, '')) != ''
	SET @CustomConnectString = @UseConnectString

IF RTRIM(@CustomConnectString) != ''
	SET @ConnectString = @CustomConnectString

RETURN @ConnectString

END








GO
/****** Object:  UserDefinedFunction [biml].[Flatfile FileFormat]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 11 Apr 2017
-- Modify date: 
--
-- Description:	Returns a Flat File 'File Format'
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Flatfile FileFormat] ('airlines', '')
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Flatfile FileFormat] ( @connection_name AS NVARCHAR(128), @environment AS NVARCHAR(32) )

RETURNS NVARCHAR(1024)
AS
BEGIN

DECLARE @FileFormat AS NVARCHAR(512);
DECLARE @EnvSubFileFormat AS NVARCHAR(512);
 
SELECT @FileFormat = [file_Format]
  FROM [biml].[flatfile_connection]
 WHERE [connection_name] = @connection_name;

-- look for environment parameter substitute
SELECT @EnvSubFileFormat = ep.[parameter_value]
  FROM [biml].[environment_parameter] ep
  JOIN [biml].[flatfile_connection] cn
    ON cn.[connection_name] + '_FlatFormat' = ep.[parameter_name]
 WHERE ep.[environment_name] = @environment

RETURN COALESCE(@EnvSubFileFormat, @FileFormat)

END





GO
/****** Object:  UserDefinedFunction [biml].[Flatfile FilePath]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 11 Apr 2017
-- Modify date: 
--
-- Description:	Returns a Flat File 'File Path'
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Flatfile FilePath] ('airlines', '')
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Flatfile FilePath] ( @connection_name AS NVARCHAR(128), @environment AS NVARCHAR(32) )

RETURNS NVARCHAR(1024)
AS
BEGIN

DECLARE @FilePath AS NVARCHAR(512);
DECLARE @EnvSubFilePath AS NVARCHAR(512);
 
SELECT @FilePath = [file_path]
  FROM [biml].[flatfile_connection]
 WHERE [connection_name] = @connection_name;

-- look for environment parameter substitute
SELECT @EnvSubFilePath = ep.[parameter_value]
  FROM [biml].[environment_parameter] ep
  JOIN [biml].[flatfile_connection] cn
    ON cn.[connection_name] + '_FlatPath' = ep.[parameter_name]
 WHERE ep.[environment_name] = @environment

RETURN COALESCE(@EnvSubFilePath, @FilePath)

END




GO
/****** Object:  UserDefinedFunction [biml].[get user id]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 07 Sep 2016
-- Modify date: 09 Sep 2016 - Bug fix with returning NULL user_id
-- Description:	Returns the current user name
--
-- Sample Execute Command: 
/*	
SELECT [biml].[get user id] ()
*/
-- ================================================================================================

CREATE FUNCTION [biml].[get user id] ()

RETURNS INT
AS
BEGIN

DECLARE @UserID AS INT
	  , @UserName AS NVARCHAR(64)

SET @UserName = [biml].[get user name] ()

SELECT @UserID = [user_id]
  FROM [biml].[user]
 WHERE [user_name] = @UserName

 IF @UserID IS NULL
	SET @UserID = -1

RETURN @UserID
END








GO
/****** Object:  UserDefinedFunction [biml].[get user name]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 07 Sep 2016
-- Modify date: 
-- Description:	Returns the current user name
--
-- Sample Execute Command: 
/*	
SELECT [biml].[get user name] ()
*/
-- ================================================================================================

CREATE FUNCTION [biml].[get user name] ()

RETURNS NVARCHAR(64)
AS
BEGIN
RETURN STUFF(suser_sname(), 1, CHARINDEX('\', suser_sname()), '')
END








GO
/****** Object:  UserDefinedFunction [biml].[get version]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 20 Sep 2016
-- Modify date: 24 Sep 2016 - Release 1.1.0
-- Modify date: 20 Oct 2016 - Release 1.2.0
-- Modify date: 21 Jan 2016 - Release 1.3.0
-- Description:	Returns the current user name
--
-- Sample Execute Command: 
/*	
SELECT [biml].[get version] () AS [Version]
*/
-- ================================================================================================

CREATE FUNCTION [biml].[get version] ()

RETURNS NVARCHAR(16)
AS
BEGIN

/*
Version	Comments
1.0.0	Initial Realease
1.1.0	Custom Conection Strings
1.2.0	Package Protection Build Option
1.2.0	Added tables [biml].[package_config (CT Replication)] and [biml].[query_repository]
*/

RETURN '1.3.0' -- major.minor.patch

END




GO
/****** Object:  UserDefinedFunction [biml].[is connection name used not adonet]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 06 Apr 2017
-- Modify date:
--
-- Description:	Check to see if 'connection' name is used (other than Ado.Net)
--
-- Sample Execute Command: 
/*	
SELECT [biml].[is connection name used not adonet] ('airlines') AS [count]
*/
-- ================================================================================================

CREATE FUNCTION [biml].[is connection name used not adonet] (@connection_name AS NVARCHAR(64))

RETURNS INT
AS
BEGIN

DECLARE @count AS INT

;WITH [all conn] AS
(
	SELECT [connection_name] FROM [biml].[connection]
UNION
	SELECT [connection_name] FROM [biml].[flatfile_connection]
UNION
	SELECT [connection_name] FROM [biml].[smtp_connection]
)
SELECT @count = COUNT(*) 
  FROM [all conn]
 WHERE [connection_name] = @connection_name

RETURN @count
END




GO
/****** Object:  UserDefinedFunction [biml].[is connection name used not flatfile]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 06 Apr 2017
-- Modify date:
--
-- Description:	Check to see if 'connection' name is used (other than Flat File)
--
-- Sample Execute Command: 
/*	
SELECT [biml].[is connection name used not flatfile] ('airlines') AS [count]
*/
-- ================================================================================================

CREATE FUNCTION [biml].[is connection name used not flatfile] (@connection_name AS NVARCHAR(64))

RETURNS INT
AS
BEGIN

DECLARE @count AS INT

;WITH [all conn] AS
(
	SELECT [connection_name] FROM [biml].[connection]
UNION
	SELECT [connection_name] FROM [biml].[adonet_connection]
UNION
	SELECT [connection_name] FROM [biml].[smtp_connection]
)
SELECT @count = COUNT(*) 
  FROM [all conn]
 WHERE [connection_name] = @connection_name

RETURN @count
END






GO
/****** Object:  UserDefinedFunction [biml].[is connection name used not oledb]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 06 Apr 2017
-- Modify date:
--
-- Description:	Check to see if 'connection' name is used (other than OldDb)
--
-- Sample Execute Command: 
/*	
SELECT [biml].[is connection name used not oledb] ('airlines') AS [count]
*/
-- ================================================================================================

CREATE FUNCTION [biml].[is connection name used not oledb] (@connection_name AS NVARCHAR(64))

RETURNS INT
AS
BEGIN

DECLARE @count AS INT

;WITH [all conn] AS
(
	SELECT [connection_name] FROM [biml].[adonet_connection]
UNION
	SELECT [connection_name] FROM [biml].[flatfile_connection]
UNION
	SELECT [connection_name] FROM [biml].[smtp_connection]
)
SELECT @count = COUNT(*) 
  FROM [all conn]
 WHERE [connection_name] = @connection_name

RETURN @count
END





GO
/****** Object:  UserDefinedFunction [biml].[is connection name used not smtp]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
--
-- Create date: 06 Apr 2017
-- Modify date:
--
-- Description:	Check to see if 'connection' name is used (other than Smtp)
--
-- Sample Execute Command: 
/*	
SELECT [biml].[is connection name used not smtp] ('airlines') AS [count]
*/
-- ================================================================================================

CREATE FUNCTION [biml].[is connection name used not smtp] (@connection_name AS NVARCHAR(64))

RETURNS INT
AS
BEGIN

DECLARE @count AS INT

;WITH [all conn] AS
(
	SELECT [connection_name] FROM [biml].[connection]
UNION
	SELECT [connection_name] FROM [biml].[adonet_connection]
UNION
	SELECT [connection_name] FROM [biml].[flatfile_connection]
)
SELECT @count = COUNT(*) 
  FROM [all conn]
 WHERE [connection_name] = @connection_name

RETURN @count
END







GO
/****** Object:  UserDefinedFunction [biml].[Package Template (Group No Alerts)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 10 Aug 2016
-- Modify date: 
-- Description:	Returns Package Template
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Package Template (Group No Alerts)]()
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Package Template (Group No Alerts)] ()

RETURNS XML
AS
BEGIN
    
DECLARE @PackageTemplate AS XML;
 
SET @PackageTemplate = N'
	<Package Name="ReplaceWithPackageName" ConstraintMode="Linear" ProtectionLevel="EncryptSensitiveWithUserKey" SsisVersionComments="0">
	  <Variables>
        <Variable DataType="String" IncludeInDebugDump="Include" Name="biml_project_name">{biml project name}</Variable>
	  </Variables>
	  <Events>
        <Event EventType="OnError" Name="OnError">
            <Tasks>
                <ExecuteSQL Name="Log Error" ConnectionName="SSIS_Data">
                    <DirectInput>EXEC [dbo].[Log Error] ?, ?, ?, ?, ?, ?</DirectInput>
                    <Parameters>
                        <Parameter Name="0" VariableName="System.VersionComments" DataType="Int64" Length="-1" />
                        <Parameter Name="1" VariableName="System.PackageName" DataType="String" Length="128" />
                        <Parameter Name="2" VariableName="System.ErrorCode" DataType="Int64" Length="-1" />
                        <Parameter Name="3" VariableName="System.ErrorDescription" DataType="String" Length="4000" />
                        <Parameter Name="4" VariableName="System.PackageID" DataType="String" Length="128" />
                        <Parameter Name="5" VariableName="System.ExecutionInstanceGUID" DataType="String" Length="128" />
					</Parameters>
				</ExecuteSQL>
			</Tasks>
        </Event>
	  </Events>
	<Tasks>
		<Container Name="Sequence Container" ConstraintMode="Parallel">
			<ReplaceWithPrimaryContainerContents/>
        </Container>
	  </Tasks>
	</Package>'

RETURN  @PackageTemplate

END












GO
/****** Object:  UserDefinedFunction [biml].[Package Template (Group No Framework)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 10 Aug 2016
-- Modify date: 
-- Description:	Returns Package Template
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Package Template (Group No Framework)]()
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Package Template (Group No Framework)] ()

RETURNS XML
AS
BEGIN
    
DECLARE @PackageTemplate AS XML;
 
SET @PackageTemplate = N'
	<Package Name="ReplaceWithPackageName" ConstraintMode="Linear" ProtectionLevel="EncryptSensitiveWithUserKey" SsisVersionComments="0">
	  <Variables>
        <Variable DataType="String" IncludeInDebugDump="Include" Name="biml_project_name">{biml project name}</Variable>
	  </Variables>
	  <Tasks>
		<Container Name="Sequence Container" ConstraintMode="Parallel">
			<ReplaceWithPrimaryContainerContents/>
        </Container>
	  </Tasks>
	</Package>'

RETURN  @PackageTemplate

END













GO
/****** Object:  UserDefinedFunction [biml].[Package Template (Group)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 10 Aug 2016
-- Modify date: 24 Mar 2017 - Change: "ToLine">@[$Project::Admin_Error_Sendmail_To]
-- Description:	Returns Package Template
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Package Template (Group)]()
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Package Template (Group)] ()

RETURNS XML
AS
BEGIN
    
DECLARE @PackageTemplate AS XML;
 
SET @PackageTemplate = N'
	<Package Name="ReplaceWithPackageName" ConstraintMode="Linear" ProtectionLevel="EncryptSensitiveWithUserKey" SsisVersionComments="0">
	  <Variables>
        <Variable DataType="String" IncludeInDebugDump="Include" Name="biml_project_name">{biml project name}</Variable>
	  </Variables>
	  <Events>
        <Event EventType="OnError" Name="OnError">
            <Tasks>
                <ExecuteSQL Name="Log Error" ConnectionName="SSIS_Data">
                    <DirectInput>EXEC [dbo].[Log Error] ?, ?, ?, ?, ?, ?</DirectInput>
                    <Parameters>
                        <Parameter Name="0" VariableName="System.VersionComments" DataType="Int64" Length="-1" />
                        <Parameter Name="1" VariableName="System.PackageName" DataType="String" Length="128" />
                        <Parameter Name="2" VariableName="System.ErrorCode" DataType="Int64" Length="-1" />
                        <Parameter Name="3" VariableName="System.ErrorDescription" DataType="String" Length="4000" />
                        <Parameter Name="4" VariableName="System.PackageID" DataType="String" Length="128" />
                        <Parameter Name="5" VariableName="System.ExecutionInstanceGUID" DataType="String" Length="128" />
					</Parameters>
				</ExecuteSQL>
				<SendMail Name="Send Mail Task" FromLine="jmiller@intricity.com" ToLine="jmiller@bitracks.com" Subject="SSIS Package Failure - Project: EDW Refresh Hist" ConnectionName="SMTP_Connection">
					<DirectInput>A package has unexpectedly failed!</DirectInput>
					<Expressions>
						<Expression ExternalProperty="FromLine">@[$Project::Admin_Sendmail_From]</Expression>
						<Expression ExternalProperty="MessageSource">"Package name: " + @[System::PackageName]  + ", Error #  "  + (DT_WSTR,30)@[System::ErrorCode]  + ", Description: " + @[System::ErrorDescription]</Expression>
						<Expression ExternalProperty="Subject">"SSIS Package Failure - Project: " +  @[User::biml_project_name]</Expression>
						<Expression ExternalProperty="ToLine">@[$Project::Admin_Error_Sendmail_To]</Expression>
					</Expressions>
				</SendMail>
			</Tasks>
        </Event>
	  </Events>
	<Tasks>
		<Container Name="Sequence Container" ConstraintMode="Parallel">
			<ReplaceWithPrimaryContainerContents/>
        </Container>
	  </Tasks>
	</Package>'

RETURN  @PackageTemplate

END


GO
/****** Object:  UserDefinedFunction [biml].[Package Template (Run All No Alerts)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 09 Aug 2016
-- Modify date: 
-- Description:	Returns Package Template
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Package Template (Run All No Alerts)]()
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Package Template (Run All No Alerts)] ()

RETURNS XML
AS
BEGIN
    
DECLARE @PackageTemplate AS XML;
 
SET @PackageTemplate = N'
	<Package Name="ReplaceWithPackageName" ConstraintMode="Linear" ProtectionLevel="EncryptSensitiveWithUserKey" SsisVersionComments="0">
	  <Variables>
        <Variable DataType="Boolean" IncludeInDebugDump="Include" Name="execute_package">True</Variable>
        <Variable DataType="Int32" IncludeInDebugDump="Include" Name="row_count">0</Variable>
        <Variable DataType="String" IncludeInDebugDump="Include" Name="biml_project_name">{biml project name}</Variable>
	  </Variables>
	  <Events>
        <Event EventType="OnError" Name="OnError">
            <Tasks>
                <ExecuteSQL Name="Log Error" ConnectionName="SSIS_Data">
                    <DirectInput>EXEC [dbo].[Log Error] ?, ?, ?, ?, ?, ?</DirectInput>
                    <Parameters>
                        <Parameter Name="0" VariableName="System.VersionComments" DataType="Int64" Length="-1" />
                        <Parameter Name="1" VariableName="System.PackageName" DataType="String" Length="128" />
                        <Parameter Name="2" VariableName="System.ErrorCode" DataType="Int64" Length="-1" />
                        <Parameter Name="3" VariableName="System.ErrorDescription" DataType="String" Length="4000" />
                        <Parameter Name="4" VariableName="System.PackageID" DataType="String" Length="128" />
                        <Parameter Name="5" VariableName="System.ExecutionInstanceGUID" DataType="String" Length="128" />
					</Parameters>
				</ExecuteSQL>
			</Tasks>
        </Event>
	  </Events>
	<Tasks>
		<Container Name="Sequence Container" ConstraintMode="Linear">
			<ReplaceWithPrimaryContainerContents/>
        </Container>
		<ExecuteSQL Name="Log Project Complete" ConnectionName="SSIS_Data">
          <DirectInput>EXEC [dbo].[Log Project Complete] ''ReplaceWithProjectName''
		  </DirectInput>
        </ExecuteSQL>
	  </Tasks>
	</Package>'

RETURN  @PackageTemplate

END











GO
/****** Object:  UserDefinedFunction [biml].[Package Template (Run All No Framework)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 09 Aug 2016
-- Modify date: 
-- Description:	Returns Package Template
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Package Template (Run All No Framework)]()
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Package Template (Run All No Framework)] ()

RETURNS XML
AS
BEGIN
    
DECLARE @PackageTemplate AS XML;
 
SET @PackageTemplate = N'
	<Package Name="ReplaceWithPackageName" ConstraintMode="Linear" ProtectionLevel="EncryptSensitiveWithUserKey" SsisVersionComments="0">
	  <Variables>
        <Variable DataType="Int32" IncludeInDebugDump="Include" Name="row_count">0</Variable>
        <Variable DataType="String" IncludeInDebugDump="Include" Name="biml_project_name">{biml project name}</Variable>
	  </Variables>
	  <Tasks>
		<Container Name="Sequence Container" ConstraintMode="Linear">
			<ReplaceWithPrimaryContainerContents/>
        </Container>
	  </Tasks>
	</Package>'

RETURN  @PackageTemplate

END












GO
/****** Object:  UserDefinedFunction [biml].[Package Template (Run All)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =========================================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 09 Aug 2016
-- Modify date: 24 Mar 2017 - Change: "ToLine">@[$Project::Admin_Error_Sendmail_To] (only for: SSIS Package Failure)
-- Description:	Returns Package Template
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Package Template (Run All)]()
*/
-- =========================================================================================================================

CREATE FUNCTION [biml].[Package Template (Run All)] ()

RETURNS XML
AS
BEGIN
    
DECLARE @PackageTemplate AS XML;
 
SET @PackageTemplate = N'
	<Package Name="ReplaceWithPackageName" ConstraintMode="Linear" ProtectionLevel="EncryptSensitiveWithUserKey" SsisVersionComments="0">
	  <Variables>
        <Variable DataType="Boolean" IncludeInDebugDump="Include" Name="execute_package">True</Variable>
        <Variable DataType="Int32" IncludeInDebugDump="Include" Name="row_count">0</Variable>
        <Variable DataType="String" IncludeInDebugDump="Include" Name="biml_project_name">{biml project name}</Variable>
	  </Variables>
	  <Events>
        <Event EventType="OnError" Name="OnError">
            <Tasks>
                <ExecuteSQL Name="Log Error" ConnectionName="SSIS_Data">
                    <DirectInput>EXEC [dbo].[Log Error] ?, ?, ?, ?, ?, ?</DirectInput>
                    <Parameters>
                        <Parameter Name="0" VariableName="System.VersionComments" DataType="Int64" Length="-1" />
                        <Parameter Name="1" VariableName="System.PackageName" DataType="String" Length="128" />
                        <Parameter Name="2" VariableName="System.ErrorCode" DataType="Int64" Length="-1" />
                        <Parameter Name="3" VariableName="System.ErrorDescription" DataType="String" Length="4000" />
                        <Parameter Name="4" VariableName="System.PackageID" DataType="String" Length="128" />
                        <Parameter Name="5" VariableName="System.ExecutionInstanceGUID" DataType="String" Length="128" />
					</Parameters>
				</ExecuteSQL>
				<SendMail Name="Send Mail Task" FromLine="jmiller@intricity.com" ToLine="jmiller@bitracks.com" Subject="SSIS Package Failure - Project: EDW Refresh Hist" ConnectionName="SMTP_Connection">
					<DirectInput>A package has unexpectedly failed!</DirectInput>
					<Expressions>
						<Expression ExternalProperty="FromLine">@[$Project::Admin_Sendmail_From]</Expression>
						<Expression ExternalProperty="MessageSource">"Package name: " + @[System::PackageName]  + ", Error #  "  + (DT_WSTR,30)@[System::ErrorCode]  + ", Description: " + @[System::ErrorDescription]</Expression>
						<Expression ExternalProperty="Subject">"SSIS Package Failure - Project: " +  @[User::biml_project_name]</Expression>
						<Expression ExternalProperty="ToLine">@[$Project::Admin_Error_Sendmail_To]</Expression>
					</Expressions>
				</SendMail>
			</Tasks>
        </Event>
	  </Events>
	<Tasks>
	  <SendMail Name="Send Mail Start" FromLine="jmiller@intricity.com" ToLine="jmiller@bitracks.com" Subject="SSIS Project Started" ConnectionName="SMTP_Connection">
		<DirectInput>Project Run Stated</DirectInput>
		<Expressions>
			<Expression ExternalProperty="FromLine">@[$Project::Admin_Sendmail_From]</Expression>
			<Expression ExternalProperty="MessageSource">"Project Started"</Expression>
			<Expression ExternalProperty="Subject">"SSIS Project Started: " +  @[User::biml_project_name]</Expression>
			<Expression ExternalProperty="ToLine">@[$Project::Admin_Sendmail_To]</Expression>
		</Expressions>
	  </SendMail>

		<Container Name="Sequence Container" ConstraintMode="Linear">
			<ReplaceWithPrimaryContainerContents/>
        </Container>

		<ExecuteSQL Name="Log Project Complete" ConnectionName="SSIS_Data">
          <DirectInput>EXEC [dbo].[Log Project Complete] ''ReplaceWithProjectName''
		  </DirectInput>
        </ExecuteSQL>
		<SendMail Name="Send Mail Success" FromLine="jmiller@intricity.com" ToLine="jmiller@bitracks.com" Subject="SSIS Project Success" ConnectionName="SMTP_Connection">
			<DirectInput>Project Run Success</DirectInput>
			<Expressions>
				<Expression ExternalProperty="FromLine">@[$Project::Admin_Sendmail_From]</Expression>
				<Expression ExternalProperty="MessageSource">"Project Success"</Expression>
				<Expression ExternalProperty="Subject">"SSIS Project Success: " +  @[User::biml_project_name]</Expression>
				<Expression ExternalProperty="ToLine">@[$Project::Admin_Sendmail_To]</Expression>
			</Expressions>
		</SendMail>
	  </Tasks>
	</Package>'

RETURN  @PackageTemplate

END


GO
/****** Object:  UserDefinedFunction [biml].[Package Template (Standard No Alerts)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 08 Aug 2016
-- Description:	Returns Package Template without Alerts and Notifications
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Package Template (Standard No Alerts)]()
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Package Template (Standard No Alerts)] ()

RETURNS XML
AS
BEGIN
    
DECLARE @PackageTemplate AS XML;
  
SET @PackageTemplate = N'
	<Package Name="ReplaceWithPackageName" ProtectionLevel="EncryptSensitiveWithUserKey" SsisVersionComments="0">
	  <Variables>
        <Variable DataType="Boolean" IncludeInDebugDump="Include" Name="execute_package">True</Variable>
        <Variable DataType="Int32" IncludeInDebugDump="Include" Name="row_count">0</Variable>
        <Variable DataType="String" IncludeInDebugDump="Include" Name="biml_project_name">{biml project name}</Variable>
		<Variable DataType="DateTime" IncludeInDebugDump="Include" Name="today" EvaluateAsExpression="true" >(DT_DATE)(DT_DBDATE)GETDATE()</Variable>
		<Variable DataType="DateTime" IncludeInDebugDump="Include" Name="yesterday" EvaluateAsExpression="true" >(DT_DATE)(DT_DBDATE)DATEADD("Day",-1,GETDATE())</Variable>
	  </Variables>
	  <Events>
        <Event EventType="OnError" Name="OnError">
            <Tasks>
                <ExecuteSQL Name="Log Error" ConnectionName="SSIS_Data">
                    <DirectInput>EXEC [dbo].[Log Error] ?, ?, ?, ?, ?, ?</DirectInput>
                    <Parameters>
                        <Parameter Name="0" VariableName="System.VersionComments" DataType="Int64" Length="-1" />
                        <Parameter Name="1" VariableName="System.PackageName" DataType="String" Length="128" />
                        <Parameter Name="2" VariableName="System.ErrorCode" DataType="Int64" Length="-1" />
                        <Parameter Name="3" VariableName="System.ErrorDescription" DataType="String" Length="4000" />
                        <Parameter Name="4" VariableName="System.PackageID" DataType="String" Length="128" />
                        <Parameter Name="5" VariableName="System.ExecutionInstanceGUID" DataType="String" Length="128" />
					</Parameters>
				</ExecuteSQL>
			</Tasks>
        </Event>
	  </Events>
	  <Tasks>
	  	 <ExecuteSQL Name="Package Begin" ConnectionName="SSIS_Data" ResultSet="SingleRow">
            <DirectInput>EXEC [dbo].[Run Package Check] ?, ?, ?</DirectInput>
            <Results>
                <Result Name="execute_package" VariableName="User.execute_package" />
            </Results>
            <Parameters>
                <Parameter Name="0" VariableName="User.biml_project_name" DataType="String" Length="128" />
                <Parameter Name="1" VariableName="System.VersionComments" DataType="String" Length="128" />
                <Parameter Name="2" VariableName="System.PackageName" DataType="String" Length="128" />
            </Parameters>
        </ExecuteSQL>

		<Container Name="Sequence Container" ConstraintMode="Linear">
			<ReplaceWithPrimaryContainerContents/>
        	<PrecedenceConstraints>
        		<Inputs>
        			<Input OutputPathName="Package Begin.Output" EvaluationOperation="ExpressionAndConstraint" Expression="@[User::execute_package] == true || @[$Project::Force_Run_All] == true" />
        		</Inputs>
        	</PrecedenceConstraints>
        </Container>

		<ExecuteSQL Name="Package End" ConnectionName="SSIS_Data">
            <DirectInput>EXEC [dbo].[Log Package Complete] ?, ?, ?, ?, ?, ?</DirectInput>
            <Parameters>
                <Parameter Name="0" VariableName="User.biml_project_name" DataType="String" Length="128" />
                <Parameter Name="1" VariableName="System.VersionComments" DataType="String" Length="128" />
                <Parameter Name="2" VariableName="System.PackageName" DataType="String" Length="128" />
                <Parameter Name="3" VariableName="System.StartTime" DataType="Date" Length="-1" />
                <Parameter Name="4" VariableName="User.row_count" DataType="Int64" Length="-1" />
                <Parameter Name="5" VariableName="System.ExecutionInstanceGUID" DataType="String" Length="128" />
            </Parameters>
        	<PrecedenceConstraints>
        		<Inputs>
        			<Input OutputPathName="Sequence Container.Output" />
        		</Inputs>
        	</PrecedenceConstraints>
        </ExecuteSQL>

	  </Tasks>
	</Package>'

RETURN  @PackageTemplate

END










GO
/****** Object:  UserDefinedFunction [biml].[Package Template (Standard No Framework)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 08 Aug 2016
-- Description:	Returns Package Template without Alerts and Notifications
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Package Template (Standard No Framework)]()
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Package Template (Standard No Framework)] ()

RETURNS XML
AS
BEGIN
    
DECLARE @PackageTemplate AS XML;
  
SET @PackageTemplate = N'
	<Package Name="ReplaceWithPackageName" ProtectionLevel="EncryptSensitiveWithUserKey" SsisVersionComments="0">
	  <Variables>
        <Variable DataType="Int32" IncludeInDebugDump="Include" Name="row_count">0</Variable>
        <Variable DataType="String" IncludeInDebugDump="Include" Name="biml_project_name">{biml project name}</Variable>
		<Variable DataType="DateTime" IncludeInDebugDump="Include" Name="today" EvaluateAsExpression="true" >(DT_DATE)(DT_DBDATE)GETDATE()</Variable>
		<Variable DataType="DateTime" IncludeInDebugDump="Include" Name="yesterday" EvaluateAsExpression="true" >(DT_DATE)(DT_DBDATE)DATEADD("Day",-1,GETDATE())</Variable>
	  </Variables>
	  <Tasks>
		<Container Name="Sequence Container" ConstraintMode="Linear">
			<ReplaceWithPrimaryContainerContents/>
        </Container>
	  </Tasks>
	</Package>'

RETURN  @PackageTemplate

END








GO
/****** Object:  UserDefinedFunction [biml].[Package Template (Standard)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =======================================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 11 Jun 2016
-- Modify date: 03 Aug 2016 - Added error e-mail notification
-- Modify date: 04 Aug 2016 - Changed workflow to now populate a 'template' table
-- Modify date: 24 Mar 2017 - Change: "ToLine">@[$Project::Admin_Error_Sendmail_To] 
--
-- Description:	Returns Package Template 'A'
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Package Template (Standard)]()
*/
-- =======================================================================================================================

CREATE FUNCTION [biml].[Package Template (Standard)] ()

RETURNS XML
AS
BEGIN
    
DECLARE @PackageTemplate AS XML;
  
SET @PackageTemplate = N'
	<Package Name="ReplaceWithPackageName" ProtectionLevel="EncryptSensitiveWithUserKey" SsisVersionComments="0">
	  <Variables>
        <Variable DataType="Boolean" IncludeInDebugDump="Include" Name="execute_package">True</Variable>
        <Variable DataType="Int32" IncludeInDebugDump="Include" Name="row_count">0</Variable>
        <Variable DataType="String" IncludeInDebugDump="Include" Name="biml_project_name">{biml project name}</Variable>
		<Variable DataType="DateTime" IncludeInDebugDump="Include" Name="today" EvaluateAsExpression="true" >(DT_DATE)(DT_DBDATE)GETDATE()</Variable>
		<Variable DataType="DateTime" IncludeInDebugDump="Include" Name="yesterday" EvaluateAsExpression="true" >(DT_DATE)(DT_DBDATE)DATEADD("Day",-1,GETDATE())</Variable>
	  </Variables>
	  <Events>
        <Event EventType="OnError" Name="OnError">
            <Tasks>
                <ExecuteSQL Name="Log Error" ConnectionName="SSIS_Data">
                    <DirectInput>EXEC [dbo].[Log Error] ?, ?, ?, ?, ?, ?</DirectInput>
                    <Parameters>
                        <Parameter Name="0" VariableName="System.VersionComments" DataType="Int64" Length="-1" />
                        <Parameter Name="1" VariableName="System.PackageName" DataType="String" Length="128" />
                        <Parameter Name="2" VariableName="System.ErrorCode" DataType="Int64" Length="-1" />
                        <Parameter Name="3" VariableName="System.ErrorDescription" DataType="String" Length="4000" />
                        <Parameter Name="4" VariableName="System.PackageID" DataType="String" Length="128" />
                        <Parameter Name="5" VariableName="System.ExecutionInstanceGUID" DataType="String" Length="128" />
					</Parameters>
				</ExecuteSQL>
				<SendMail Name="Send Mail Task" FromLine="jmiller@intricity.com" ToLine="jmiller@bitracks.com" Subject="SSIS Package Failure - Project: EDW Refresh Hist" ConnectionName="SMTP_Connection">
					<DirectInput>A package has unexpectedly failed!</DirectInput>
					<Expressions>
						<Expression ExternalProperty="FromLine">@[$Project::Admin_Sendmail_From]</Expression>
						<Expression ExternalProperty="MessageSource">"Package name: " + @[System::PackageName]  + ", Error #  "  + (DT_WSTR,30)@[System::ErrorCode]  + ", Description: " + @[System::ErrorDescription]</Expression>
						<Expression ExternalProperty="Subject">"SSIS Package Failure - Project: " +  @[User::biml_project_name]</Expression>
						<Expression ExternalProperty="ToLine">@[$Project::Admin_Error_Sendmail_To]</Expression>
					</Expressions>
				</SendMail>
			</Tasks>
        </Event>
	  </Events>
	  <Tasks>
	  	 <ExecuteSQL Name="Package Begin" ConnectionName="SSIS_Data" ResultSet="SingleRow">
            <DirectInput>EXEC [dbo].[Run Package Check] ?, ?, ?</DirectInput>
            <Results>
                <Result Name="execute_package" VariableName="User.execute_package" />
            </Results>
            <Parameters>
                <Parameter Name="0" VariableName="User.biml_project_name" DataType="String" Length="128" />
                <Parameter Name="1" VariableName="System.VersionComments" DataType="String" Length="128" />
                <Parameter Name="2" VariableName="System.PackageName" DataType="String" Length="128" />
            </Parameters>
        </ExecuteSQL>

		<Container Name="Sequence Container" ConstraintMode="Linear">
			<ReplaceWithPrimaryContainerContents/>
        	<PrecedenceConstraints>
        		<Inputs>
        			<Input OutputPathName="Package Begin.Output" EvaluationOperation="ExpressionAndConstraint" Expression="@[User::execute_package] == true || @[$Project::Force_Run_All] == true" />
        		</Inputs>
        	</PrecedenceConstraints>
        </Container>

		<ExecuteSQL Name="Package End" ConnectionName="SSIS_Data">
            <DirectInput>EXEC [dbo].[Log Package Complete] ?, ?, ?, ?, ?, ?</DirectInput>
            <Parameters>
                <Parameter Name="0" VariableName="User.biml_project_name" DataType="String" Length="128" />
                <Parameter Name="1" VariableName="System.VersionComments" DataType="String" Length="128" />
                <Parameter Name="2" VariableName="System.PackageName" DataType="String" Length="128" />
                <Parameter Name="3" VariableName="System.StartTime" DataType="Date" Length="-1" />
                <Parameter Name="4" VariableName="User.row_count" DataType="Int64" Length="-1" />
                <Parameter Name="5" VariableName="System.ExecutionInstanceGUID" DataType="String" Length="128" />
            </Parameters>
        	<PrecedenceConstraints>
        		<Inputs>
        			<Input OutputPathName="Sequence Container.Output" />
        		</Inputs>
        	</PrecedenceConstraints>
        </ExecuteSQL>

	  </Tasks>
	</Package>'

RETURN  @PackageTemplate

END


GO
/****** Object:  UserDefinedFunction [biml].[Smtp Connect String]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 25 Aug 2016
-- Modify date: 
-- Description:	Returns a Smtp Connect String
--
-- Sample Execute Command: 
/*	
SELECT [biml].[Smtp Connect String] ('smtp.twc.com', '')
*/
-- ================================================================================================

CREATE FUNCTION [biml].[Smtp Connect String] ( @connection_name AS NVARCHAR(128), @environment AS NVARCHAR(32) )

RETURNS NVARCHAR(1024)
AS
BEGIN

DECLARE @ServerName AS NVARCHAR(256);
DECLARE @EnvSubServerName AS NVARCHAR(256);
 
SELECT @ServerName = [server_name]
  FROM [biml].[smtp_connection]
 WHERE [connection_name] = @connection_name;

-- look for environment parameter substitute
SELECT @EnvSubServerName = ep.[parameter_value]
  FROM [biml].[environment_parameter] ep
  JOIN [biml].[smtp_connection] cn
    ON cn.[connection_name] + '_Server' = ep.[parameter_name]
 WHERE ep.[environment_name] = @environment

RETURN COALESCE(@EnvSubServerName, @ServerName)

END









GO
/****** Object:  UserDefinedFunction [dbo].[DistinctHeader]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 27 Apr 2016
-- Modify date: 01 May 2016 - Bug fix on delimiter returned
-- Modify date: 29 Jul 2016 - Added CHAR(9) {tab} as @InDelim parameter 'T' 
--
-- Description:	Returns a unique 'comma separated' CSV Headerlist
--
-- Sample Execute Command: 
/*
SELECT dbo.DistinctHeader('CSN,MRN,PatientName,DOB,ContactDate,DischDatetime,SAME_DAY_YN,ContactDate,CheckIn', ',') AS [Distinct Header]
*/
-- ================================================================================================

CREATE FUNCTION [dbo].[DistinctHeader]
(
@InList VARCHAR(MAX),
@InDelim CHAR(1)
)
RETURNS
VARCHAR(MAX)
AS
BEGIN

	IF @InDelim = 'T'
		SET @InDelim = CHAR(9)

	DECLARE @SplitList TABLE
	(
		seq INT IDENTITY(1,1),
		item VARCHAR(128)
	)
	INSERT @SplitList
	SELECT LTRIM(RTRIM(value))
	  FROM STRING_SPLIT(@InList, @InDelim)  
	 WHERE LTRIM(RTRIM(value)) <> '';

	DECLARE @DupList TABLE
	(
		cnt INT,
		item VARCHAR(128)
	)
	INSERT @DupList
	SELECT COUNT(item)
		 , item
	  FROM @SplitList
     GROUP BY item
	HAVING COUNT(*) > 1
	
	-- cursor for each row in dup list
	DECLARE @cnt AS INT
		  , @item AS VARCHAR(128)
		  , @loopCnt AS INT
		  , @seq AS INT

	DECLARE [proc_cursor] CURSOR FOR  
	SELECT [cnt]
		 , [item]
	  FROM @DupList

	OPEN [proc_cursor]   
	FETCH NEXT FROM [proc_cursor] INTO @cnt, @item

	WHILE @@FETCH_STATUS = 0   
	BEGIN 
		-- loop through @cnt and update corresponding item in splitlist
		  SET @loopCnt = 0
		WHILE @loopCnt < @cnt 
		BEGIN  
			SET @loopCnt = @loopCnt + 1
			SELECT @seq = MIN([seq]) FROM @SplitList WHERE [item] = @item
			UPDATE @SplitList SET [item] = [item] + '_' + CAST(@loopCnt AS VARCHAR) WHERE [SEQ] = @seq
		END  
		FETCH NEXT FROM [proc_cursor] INTO @cnt, @item
	END;  

	CLOSE [proc_cursor]; 
	DEALLOCATE [proc_cursor];

	DECLARE @OutList VARCHAR(MAX);
	 SELECT @OutList = COALESCE(@OutList + @InDelim, '') + [item] FROM @SplitList ORDER BY seq;

	RETURN @OutList
END

GO
/****** Object:  UserDefinedFunction [dbo].[Table DDL from CSV Header]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 15 May 2017
-- Modify date: 17 May 2017 - Added [ ] column name delimiters (LAU)
-- Modify date: 29 Jul 2016 - Added CHAR(9) {tab} as @InDelim parameter 'T' 
--
-- Description:	Create Table (DDL) from Header
--
-- Sample Execute Command: 
/*
SELECT [dbo].[Table DDL from CSV Header]('CSN abc,MRN,PatientName,DOB,ContactDate,DischDatetime,SAME_DAY_YN,ContactDate2,CheckIn', ',') AS [Distinct Header]
*/
-- ================================================================================================

CREATE FUNCTION [dbo].[Table DDL from CSV Header]
(
@InList VARCHAR(MAX),
@InDelim CHAR(1)
)
RETURNS
VARCHAR(MAX)
AS
BEGIN

	IF @InDelim = 'T'
		SET @InDelim = CHAR(9)

	DECLARE @ddl_out VARCHAR(MAX)
	SET @ddl_out = REPLACE(@InList, @InDelim, '] [varchar](4000) NULL
	, [')
	SET @ddl_out = 'CREATE TABLE [dbo].[tablename]	(
	  ' + '[' + @ddl_out + ']' + ' [varchar](4000) NULL
	) ON [PRIMARY]'

	RETURN @ddl_out
END




GO
/****** Object:  Table [biml].[package_config (Data Flow)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[package_config (Data Flow)](
	[src_connection] [nvarchar](64) NOT NULL,
	[src_query] [nvarchar](max) NOT NULL,
	[is_expression] [nvarchar](1) NOT NULL,
	[src_query_direct] [nvarchar](max) NULL,
	[package_qualifier] [nvarchar](64) NOT NULL,
	[dst_connection] [nvarchar](64) NOT NULL,
	[dst_schema] [nvarchar](128) NOT NULL,
	[dst_table] [nvarchar](128) NOT NULL,
	[dst_truncate] [nvarchar](1) NOT NULL,
	[keep_identity] [nvarchar](1) NOT NULL,
	[package_name]  AS (('Data Flow - '+[package_qualifier])+case when [dst_table]='' then '' else ((' - '+[dst_schema])+'.')+[dst_table] end),
 CONSTRAINT [PK_package_config (Data Flow)] PRIMARY KEY CLUSTERED 
(
	[package_qualifier] ASC,
	[dst_schema] ASC,
	[dst_table] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [biml].[package_config (Execute SQL)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[package_config (Execute SQL)](
	[connection_manager] [nvarchar](64) NOT NULL,
	[package_qualifier] [nvarchar](64) NOT NULL,
	[query] [nvarchar](max) NOT NULL,
	[is_expression] [nvarchar](1) NOT NULL,
	[return_row_count] [nvarchar](1) NOT NULL,
	[package_name]  AS ('Execute SQL - '+[package_qualifier]),
 CONSTRAINT [PK_package_config (Execute SQL)] PRIMARY KEY CLUSTERED 
(
	[package_qualifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [biml].[vw_package_query]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [biml].[vw_package_query] AS

	SELECT [package_name] AS [Package]
		 , 'Source: ' + [src_connection] + ' - Destination: ' + [dst_connection]  + ' - Table: [' + [dst_schema] + '].[' + [dst_table] + ']' AS [Connection]
		 , [src_query] AS [Query]
	  FROM [biml].[package_config (Data Flow)]

UNION ALL

	SELECT [package_name] AS [Package]
		 , 'Execute on Connection: ' + [connection_manager]  AS [Connection]
		  ,[query] AS [Query]
	  FROM [biml].[package_config (Execute SQL)]




GO
/****** Object:  Table [biml].[connection]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[connection](
	[connection_name] [nvarchar](64) NOT NULL,
	[server_name] [nvarchar](128) NOT NULL,
	[database_name] [nvarchar](128) NOT NULL,
	[provider] [nvarchar](64) NOT NULL,
	[custom_connect_string] [nvarchar](1024) NOT NULL,
	[connection_expression]  AS (case when rtrim([custom_connect_string])='' then ((((('"Data Source=" + @[$Project::'+[connection_name])+'_Server] + ";Initial Catalog=" + @[$Project::')+[connection_name])+'_Database] + ";Provider=" + @[$Project::')+[connection_name])+'_Provider]  + ";Integrated Security=SSPI;Auto Translate=False;"' else ('@[$Project::'+[connection_name])+'_ConnectString]' end),
 CONSTRAINT [PK_biml_connection] PRIMARY KEY CLUSTERED 
(
	[connection_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[project_connection]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[project_connection](
	[project_id] [int] NOT NULL,
	[connection_name] [nvarchar](64) NOT NULL,
 CONSTRAINT [PK_project_connection] PRIMARY KEY CLUSTERED 
(
	[project_id] ASC,
	[connection_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [biml].[get data connections in project]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 07 Jan 2017
-- Modify date: 
-- Description:	Get a list of data connections in a project
--
-- sample exec:
/*
SELECT * FROM [biml].[get data connections in project] (10)
*/
-- ================================================================================================

CREATE FUNCTION [biml].[get data connections in project] (@project_id int)  
RETURNS TABLE  
AS  
RETURN   
(  
SELECT * 
  FROM [biml].[connection] 
 WHERE [connection_name] IN 
     ( SELECT [connection_name] 
	     FROM [biml].[project_connection] 
		WHERE [project_id] = @project_id 
	 )
);









GO
/****** Object:  Table [biml].[project_environment]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[project_environment](
	[project_id] [int] NOT NULL,
	[environment_name] [nvarchar](32) NOT NULL,
	[project_xml] [xml] NULL,
	[parameter_xml] [xml] NULL,
	[build_datetime] [smalldatetime] NULL,
	[build_template_group] [nvarchar](32) NULL,
 CONSTRAINT [PK_project_environment] PRIMARY KEY CLUSTERED 
(
	[project_id] ASC,
	[environment_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [biml].[project]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[project](
	[project_id] [int] IDENTITY(1,1) NOT NULL,
	[project_name] [nvarchar](128) NOT NULL,
	[project_xml] [xml] NULL,
	[parameter_xml] [xml] NULL,
	[build_datetime] [smalldatetime] NULL,
	[build_template_group] [nvarchar](32) NULL,
 CONSTRAINT [PK_project] PRIMARY KEY CLUSTERED 
(
	[project_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UNIQUE_project_name] UNIQUE NONCLUSTERED 
(
	[project_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [biml].[vw_project_biml]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [biml].[vw_project_biml] AS

	SELECT '' AS [environment_name]
		 , [project_name]
		 , [project_xml]
		 , [parameter_xml]
		 , '<?xml version="1.0"?>' [parameter_xml script top]
		 , [build_datetime]
		 , [build_template_group]
	  FROM [biml].[project]

UNION ALL

	SELECT pe.[environment_name]
		 , pr.[project_name]
		 , pe.[project_xml]
		 , pe.[parameter_xml]
		 , '<?xml version="1.0"?>' [parameter_xml script top]
		 , pe.[build_datetime]
		 , pe.[build_template_group]
	  FROM [biml].[project_environment] pe
	  JOIN [biml].[project] pr
		ON pr.[project_id] = pe.[project_id]














GO
/****** Object:  Table [biml].[project_adonet_connection]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[project_adonet_connection](
	[project_id] [int] NOT NULL,
	[connection_name] [nvarchar](64) NOT NULL,
 CONSTRAINT [PK_project_adonet_connection] PRIMARY KEY CLUSTERED 
(
	[project_id] ASC,
	[connection_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[adonet_connection]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[adonet_connection](
	[connection_name] [nvarchar](64) NOT NULL,
	[provider] [nvarchar](512) NOT NULL,
	[connect_string] [nvarchar](1024) NOT NULL,
	[database_name] [nvarchar](128) NULL,
	[provider_expression]  AS (('@[$Project::'+[connection_name])+'_Provider]'),
	[connect_string_expression]  AS (('@[$Project::'+[connection_name])+'_ConnectString]'),
 CONSTRAINT [PK_biml_adonet_connection] PRIMARY KEY CLUSTERED 
(
	[connection_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[project_flatfile_connection]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[project_flatfile_connection](
	[project_id] [int] NOT NULL,
	[connection_name] [nvarchar](64) NOT NULL,
 CONSTRAINT [PK_project_flatfile_connection] PRIMARY KEY CLUSTERED 
(
	[project_id] ASC,
	[connection_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[flatfile_connection]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[flatfile_connection](
	[connection_name] [nvarchar](64) NOT NULL,
	[file_path] [nvarchar](512) NOT NULL,
	[file_format] [nvarchar](128) NOT NULL,
	[file_path_expression]  AS (('@[$Project::'+[connection_name])+'_FilePath]'),
	[file_format_expression]  AS (('@[$Project::'+[connection_name])+'_FileFormat]'),
 CONSTRAINT [PK_biml_flatfile_connection] PRIMARY KEY CLUSTERED 
(
	[connection_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[project_smtp_connection]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[project_smtp_connection](
	[project_id] [int] NOT NULL,
	[connection_name] [nvarchar](64) NOT NULL,
 CONSTRAINT [PK_project_smtp_connection] PRIMARY KEY CLUSTERED 
(
	[project_id] ASC,
	[connection_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[smtp_connection]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[smtp_connection](
	[connection_name] [nvarchar](64) NOT NULL,
	[server_name] [nvarchar](128) NOT NULL,
	[server_name_expression]  AS (('@[$Project::'+[connection_name])+'_Server]'),
 CONSTRAINT [PK_biml_smtp_connection] PRIMARY KEY CLUSTERED 
(
	[connection_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [biml].[vw_project_connection]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [biml].[vw_project_connection] AS

SELECT pc.[project_id]
	 , pc.[connection_name]
	 , 'OleDb' AS [connection_type]
  FROM [biml].[connection] c
  JOIN [biml].[project_connection] pc
    ON pc.[connection_name] = c.[connection_name]

 UNION

SELECT pc.[project_id]
	 , pc.[connection_name]
	 , 'AdoNet' AS [connection_type]
  FROM [biml].[adonet_connection] c
  JOIN [biml].[project_adonet_connection] pc
    ON pc.[connection_name] = c.[connection_name]

 UNION

SELECT pc.[project_id]
	 , pc.[connection_name]
	 , 'Smtp' AS [connection_type]
  FROM [biml].[smtp_connection] c
  JOIN [biml].[project_smtp_connection] pc
    ON pc.[connection_name] = c.[connection_name]

 UNION

SELECT pc.[project_id]
	 , pc.[connection_name]
	 , 'FlatFile' AS [connection_type]
  FROM [biml].[flatfile_connection] c
  JOIN [biml].[project_flatfile_connection] pc
    ON pc.[connection_name] = c.[connection_name]











GO
/****** Object:  Table [biml].[parameter]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[parameter](
	[parameter_name] [nvarchar](128) NOT NULL,
	[parameter_datatype] [nvarchar](32) NOT NULL,
	[parameter_value] [nvarchar](512) NOT NULL,
	[parameter_reference]  AS (('@[$Project::'+[parameter_name])+']'),
 CONSTRAINT [PK_parameter] PRIMARY KEY CLUSTERED 
(
	[parameter_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[project_parameter]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[project_parameter](
	[project_id] [int] NOT NULL,
	[parameter_name] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_project_parameter] PRIMARY KEY CLUSTERED 
(
	[project_id] ASC,
	[parameter_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [biml].[get parameters in project]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 07 Jan 2017
-- Modify date: 
-- Description:	Get a list of parameters in a project
--
-- sample exec:
/*
SELECT * FROM [biml].[get parameters in project] (10)
*/
-- ================================================================================================

CREATE FUNCTION [biml].[get parameters in project] (@project_id int)  
RETURNS TABLE  
AS  
RETURN   
(  
SELECT * 
  FROM [biml].[parameter]
 WHERE [parameter_name] IN 
	 ( SELECT [parameter_name] 
	     FROM [biml].[project_parameter] 
		WHERE [project_id] = @project_id )
);










GO
/****** Object:  UserDefinedFunction [biml].[get data connections not in project]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 20 Aug 2016
-- Modify date: 
-- Description:	Get a list of data connections not in project
--
-- sample exec:
/*
SELECT * FROM [biml].[get data connections not in project] (1)
*/
-- ================================================================================================

CREATE FUNCTION [biml].[get data connections not in project] (@project_id int)  
RETURNS TABLE  
AS  
RETURN   
(  
	SELECT c.[connection_name]
	  FROM [biml].[connection] c
	  LEFT JOIN [biml].[project_connection] pc
		ON pc.[connection_name] = c.[connection_name]
	   AND pc.[project_id] = @project_id
	 WHERE pc.[connection_name] IS NULL
);  







GO
/****** Object:  Table [biml].[environment]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[environment](
	[environment_name] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_biml_environment] PRIMARY KEY CLUSTERED 
(
	[environment_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [biml].[get environments not in project]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 25 Aug 2016
-- Modify date: 
-- Description:	Get a list of parameters not in a project
--
-- sample exec:
/*
SELECT * FROM [biml].[get environments not in project] (1)
*/
-- ================================================================================================

CREATE FUNCTION [biml].[get environments not in project] (@project_id int)  
RETURNS TABLE  
AS  
RETURN   
(  
	SELECT e.[environment_name]
	  FROM [biml].[environment] e
	  LEFT JOIN [biml].[project_environment] pe
		ON pe.[environment_name] = e.[environment_name]
	   AND pe.[project_id] = @project_id
	 WHERE pe.[environment_name] IS NULL
);  








GO
/****** Object:  Table [biml].[project_package]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[project_package](
	[project_id] [int] NOT NULL,
	[sequence_number] [int] NOT NULL,
	[package_name] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_project_package] PRIMARY KEY CLUSTERED 
(
	[project_id] ASC,
	[package_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[package]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[package](
	[package_name] [nvarchar](128) NOT NULL,
	[pattern_name] [nvarchar](32) NOT NULL,
	[package_text] [nvarchar](max) NOT NULL,
	[package_xml] [xml] NOT NULL,
	[build_datetime] [smalldatetime] NOT NULL,
	[build_template] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_package] PRIMARY KEY CLUSTERED 
(
	[package_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [biml].[pattern]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[pattern](
	[pattern_name] [nvarchar](32) NOT NULL,
	[has_config_table] [nvarchar](1) NOT NULL,
	[author_id] [int] NOT NULL,
	[description] [nvarchar](4000) NULL,
 CONSTRAINT [PK_pattern] PRIMARY KEY CLUSTERED 
(
	[pattern_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [biml].[get packages]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 22 Aug 2016
-- Modify date: 
-- Description:	Get list of packages
--
-- sample exec:
/*
SELECT [package_name] FROM [biml].[get packages] ('ETL_DM Refresh', '')
*/
-- ================================================================================================

CREATE FUNCTION [biml].[get packages] (@project_name nvarchar(128), @pattern_name nvarchar(32))
RETURNS TABLE  
AS  
RETURN   
(  
	WITH [base] AS
	(
		SELECT pk.[package_name]
		  FROM [biml].[pattern] pt
		  JOIN [biml].[package] pk
			ON pk.[pattern_name] = pt.[pattern_name]
		  LEFT JOIN [biml].[project_package] pp
			ON pp.[package_name] = pk.[package_name]
		  LEFT JOIN [biml].[project] pr
			ON pr.[project_id] = pp.[project_id]
		 WHERE pt.[has_config_table] = 'Y'
		   AND (    pt.[pattern_name] = @pattern_name
				 OR @pattern_name = ''
			   )
		   AND (    pr.[project_name] = @project_name
				 OR @project_name = ''
			   )
	)
	SELECT TOP 10000
		   [package_name]
	  FROM [base]
     ORDER BY [package_name]
);  








GO
/****** Object:  UserDefinedFunction [biml].[get packages not in any project]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 20 Aug 2016
-- Modify date: 
-- Description:	Get a list of packages not in any project
--
-- sample exec:
/*
SELECT * FROM [biml].[get packages not in any project] ()
*/
-- ================================================================================================

CREATE FUNCTION [biml].[get packages not in any project] ()
RETURNS TABLE  
AS  
RETURN   
(  
	SELECT p.[package_name]
	  FROM [biml].[package] p
	  LEFT JOIN [biml].[project_package] pp
		ON pp.[package_name] = p.[package_name]
	 WHERE pp.[package_name] IS NULL
);  









GO
/****** Object:  UserDefinedFunction [biml].[get packages not in project]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 20 Aug 2016
-- Modify date: 
-- Description:	Get a list of packages not in a project
--
-- sample exec:
/*
SELECT * FROM [biml].[get packages not in project] (1)
*/
-- ================================================================================================

CREATE FUNCTION [biml].[get packages not in project] (@project_id int)  
RETURNS TABLE  
AS  
RETURN   
(  
	SELECT p.[package_name]
	  FROM [biml].[package] p
	  LEFT JOIN [biml].[project_package] pp
		ON pp.[package_name] = p.[package_name]
	   AND pp.[project_id] = @project_id
	 WHERE pp.[package_name] IS NULL
);  








GO
/****** Object:  UserDefinedFunction [biml].[get parameters not in project]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 18 Aug 2016
-- Modify date: 
-- Description:	Get a list of parameters not in a project
--
-- sample exec:
/*
SELECT * FROM [biml].[get parameters not in project] (1)
*/
-- ================================================================================================

CREATE FUNCTION [biml].[get parameters not in project] (@project_id int)  
RETURNS TABLE  
AS  
RETURN   
(  
	SELECT p.[parameter_name]
	  FROM [biml].[parameter] p
	  LEFT JOIN [biml].[project_parameter] pp
		ON pp.[parameter_name] = p.[parameter_name]
	   AND pp.[project_id] = @project_id
	 WHERE pp.[parameter_name] IS NULL
);  







GO
/****** Object:  UserDefinedFunction [biml].[get adonet connections not in project]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 20 Aug 2016
-- Modify date: 
-- Description:	Get a list of smtp connections not in project
--
-- sample exec:
/*
SELECT * FROM [biml].[get ado.net connections not in project] (1)
*/
-- ================================================================================================

CREATE FUNCTION [biml].[get adonet connections not in project] (@project_id int)  
RETURNS TABLE  
AS  
RETURN   
(  
	SELECT c.[connection_name]
	  FROM [biml].[adonet_connection] c
	  LEFT JOIN [biml].[project_adonet_connection] pc
		ON pc.[connection_name] = c.[connection_name]
	   AND pc.[project_id] = @project_id
	 WHERE pc.[connection_name] IS NULL
);  









GO
/****** Object:  UserDefinedFunction [biml].[get flatfile connections not in project]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 20 Aug 2016
-- Modify date: 
-- Description:	Get a list of smtp connections not in project
--
-- sample exec:
/*
SELECT * FROM [biml].[get flat file connections not in project] (1)
*/
-- ================================================================================================

CREATE FUNCTION [biml].[get flatfile connections not in project] (@project_id int)  
RETURNS TABLE  
AS  
RETURN   
(  
	SELECT c.[connection_name]
	  FROM [biml].[flatfile_connection] c
	  LEFT JOIN [biml].[project_flatfile_connection] pc
		ON pc.[connection_name] = c.[connection_name]
	   AND pc.[project_id] = @project_id
	 WHERE pc.[connection_name] IS NULL
);  









GO
/****** Object:  Table [biml].[package_config (Execute Process)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[package_config (Execute Process)](
	[package_qualifier] [nvarchar](64) NOT NULL,
	[executable_expr] [nvarchar](1024) NOT NULL,
	[arguments_expr] [nvarchar](max) NOT NULL,
	[working_directory] [nvarchar](2048) NOT NULL,
	[place_values_in_SSIS_Data] [nvarchar](1) NOT NULL,
	[package_name]  AS ('Execute Process - '+[package_qualifier]),
 CONSTRAINT [PK_package_config (Execute Process)] PRIMARY KEY CLUSTERED 
(
	[package_qualifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [biml].[fact_table_partition_config (Standard)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[fact_table_partition_config (Standard)](
	[partition_scheme] [nvarchar](128) NOT NULL,
	[partition_function] [nvarchar](128) NOT NULL,
	[days_ahead] [int] NOT NULL,
	[day_partitions] [int] NOT NULL,
	[month_partitions] [int] NOT NULL,
	[quarter_partitions] [int] NOT NULL,
	[year_partitions] [int] NOT NULL,
	[switch_in_schema_name] [nvarchar](128) NOT NULL,
	[switch_in_table_name] [nvarchar](128) NOT NULL,
	[truncate_switch_in_table] [nvarchar](1) NOT NULL,
	[package_qualifier] [nvarchar](64) NOT NULL,
 CONSTRAINT [PK_fact_table_partition_config (Standard)] PRIMARY KEY CLUSTERED 
(
	[partition_scheme] ASC,
	[partition_function] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UNIQUE_fact_table_partition_config (Standard)_package_qualifier] UNIQUE NONCLUSTERED 
(
	[package_qualifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[fact_table_switch_config (Standard)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[fact_table_switch_config (Standard)](
	[src_schema_name] [nvarchar](128) NOT NULL,
	[src_table_name] [nvarchar](128) NOT NULL,
	[dst_schema_name] [nvarchar](128) NOT NULL,
	[dst_table_name] [nvarchar](128) NOT NULL,
	[out_schema_name] [nvarchar](128) NOT NULL,
	[out_table_name] [nvarchar](128) NOT NULL,
	[package_qualifier] [nvarchar](64) NOT NULL,
	[switch_option] [int] NOT NULL,
	[project_parameter] [nvarchar](128) NULL,
 CONSTRAINT [PK_fact_table_switch_config (Standard)] PRIMARY KEY CLUSTERED 
(
	[src_schema_name] ASC,
	[src_table_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UNIQUE_fact_table_switch_config (Standard)_package_qualifier] UNIQUE NONCLUSTERED 
(
	[package_qualifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[dim_table_merge_config (Standard)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[dim_table_merge_config (Standard)](
	[stg_server] [nvarchar](128) NOT NULL,
	[stg_database] [nvarchar](128) NOT NULL,
	[stg_schema] [nvarchar](128) NOT NULL,
	[dst_schema] [nvarchar](128) NOT NULL,
	[stg_table] [nvarchar](128) NOT NULL,
	[dst_table] [nvarchar](128) NOT NULL,
	[stg_database_param_name] [nvarchar](128) NOT NULL,
	[dst_database_param_name] [nvarchar](128) NOT NULL,
	[package_qualifier] [nvarchar](64) NOT NULL,
	[added_dim_column_names_id] [int] NOT NULL,
 CONSTRAINT [PK_dim_table_merge_config (Standard)] PRIMARY KEY CLUSTERED 
(
	[package_qualifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[fact_table_merge_config (Basic)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[fact_table_merge_config (Basic)](
	[stg_server] [nvarchar](128) NOT NULL,
	[stg_database] [nvarchar](128) NOT NULL,
	[dst_database] [nvarchar](128) NOT NULL,
	[stg_schema] [nvarchar](128) NOT NULL,
	[dst_schema] [nvarchar](128) NOT NULL,
	[stg_table] [nvarchar](128) NOT NULL,
	[dst_table] [nvarchar](128) NOT NULL,
	[package_qualifier] [nvarchar](64) NOT NULL,
 CONSTRAINT [PK_fact_table_merge_config (Basic)] PRIMARY KEY CLUSTERED 
(
	[package_qualifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [biml].[get config tables for packages]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 01 Sep 2016
-- Modify date: 16 Sep 2017 - Added Exec Process
--
-- Description:	Get config tables for packages (if exists)
--
-- sample exec:
/*
SELECT * FROM [biml].[get config tables for packages] ()
*/
-- ================================================================================================

CREATE FUNCTION [biml].[get config tables for packages] ()
RETURNS TABLE  
AS  
RETURN   
(  
WITH [SQL Expr base] AS
(
SELECT se.[package_qualifier]
     , se.[package_name]
	 , CASE
		  WHEN ms.[package_qualifier] IS NOT NULL THEN 'dim_table_merge_config (Standard)'
		  WHEN fc.[package_qualifier] IS NOT NULL THEN 'fact_table_switch_config (Standard)'
		  ELSE 'n/a'
	   END AS [config_table]
  FROM [biml].[package_config (Execute SQL)] se
  LEFT JOIN [biml].[dim_table_merge_config (Standard)] ms
    ON ms.[package_qualifier] = se.[package_qualifier]
  LEFT JOIN [biml].[fact_table_switch_config (Standard)] fc
    ON fc.[package_qualifier] = se.[package_qualifier]
)
, [SQL Query base] AS
(
SELECT es.[package_qualifier]
     , es.[package_name]
	 , CASE
		  WHEN mb.[package_qualifier] IS NOT NULL THEN 'fact_table_merge_config (Basic)'
		  WHEN fp.[package_qualifier] IS NOT NULL THEN 'fact_table_partition_config (Standard)'
		  ELSE 'n/a'
	   END AS [config_table]
  FROM [biml].[package_config (Execute SQL)] es
  LEFT JOIN [biml].[fact_table_merge_config (Basic)] mb
    ON mb.[package_qualifier] = es.[package_qualifier]
  LEFT JOIN [biml].[fact_table_partition_config (Standard)] fp
    ON fp.[package_qualifier] = es.[package_qualifier]
)
, [Exec Process base] AS
(
SELECT ep.[package_qualifier]
     , ep.[package_name]
	 , CASE
		  WHEN ms.[package_qualifier] IS NOT NULL THEN 'dim_table_merge_config (Standard)'
		  ELSE 'n/a'
	   END AS [config_table]
  FROM [biml].[package_config (Execute Process)] ep
  LEFT JOIN [biml].[dim_table_merge_config (Standard)] ms
    ON ms.[package_qualifier] = ep.[package_qualifier]
)

, [union all base] AS
(
	SELECT [package_qualifier]
		 , [package_name]
		 , [config_table]
	  FROM [SQL Expr base]
	 WHERE [config_table] <> 'n/a'
 UNION ALL
	SELECT [package_qualifier]
		 , [package_name]
		 , [config_table]
	  FROM [SQL Query base]
	 WHERE [config_table] <> 'n/a'
 UNION ALL
	SELECT [package_qualifier]
		 , [package_name]
		 , [config_table]
	  FROM [Exec Process base]
	 WHERE [config_table] <> 'n/a'
 )
 SELECT [package_qualifier]
	  , [package_name]
	  , [config_table]
   FROM [union all base]
);  







GO
/****** Object:  UserDefinedFunction [biml].[get smtp connections not in project]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 20 Aug 2016
-- Modify date: 
-- Description:	Get a list of smtp connections not in project
--
-- sample exec:
/*
SELECT * FROM [biml].[get smtp connections not in project] (1)
*/
-- ================================================================================================

CREATE FUNCTION [biml].[get smtp connections not in project] (@project_id int)  
RETURNS TABLE  
AS  
RETURN   
(  
	SELECT c.[connection_name]
	  FROM [biml].[smtp_connection] c
	  LEFT JOIN [biml].[project_smtp_connection] pc
		ON pc.[connection_name] = c.[connection_name]
	   AND pc.[project_id] = @project_id
	 WHERE pc.[connection_name] IS NULL
);  








GO
/****** Object:  UserDefinedFunction [biml].[get packages in project]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 06 Jan 2017
-- Modify date: 
-- Description:	Get a list of packages in a project
--
-- sample exec:
/*
SELECT * FROM [biml].[get packages in project] (10)
*/
-- ================================================================================================

CREATE FUNCTION [biml].[get packages in project] (@project_id int)  
RETURNS TABLE  
AS  
RETURN   
(  
	SELECT prj.[sequence_number]
		 , pkg.[package_name]
		 , pkg.[pattern_name]
		 , pkg.[build_datetime]
		 , pkg.[build_template]
	  FROM [biml].[package] pkg 
	  JOIN [biml].[project_package] prj
		ON prj.[package_name] = pkg.[package_name]
	  WHERE prj.[sequence_number] != -1
		AND prj.[package_name] IN 
		  ( SELECT [package_name] FROM [biml].[project_package] WHERE [project_id] = @project_id )
);




GO
/****** Object:  View [biml].[vw_package_biml]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [biml].[vw_package_biml] AS

SELECT p.[project_name]
	 , pp.[sequence_number]
	 , pp.[package_name]
	 , pk.[package_xml]
	 , pk.[build_datetime]
	 , pk.[build_template]
  FROM [biml].[project_package] pp
  JOIN [biml].[project] p
    ON p.[project_id] = pp.[project_id]
  JOIN [biml].[package] pk
    ON pk.[package_name] = pp.[package_name]











GO
/****** Object:  Table [biml].[added_dim_column_names]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[added_dim_column_names](
	[added_dim_column_names_id] [int] IDENTITY(1,1) NOT NULL,
	[added_dim_column_names_tag] [nvarchar](16) NOT NULL,
	[row_is_current] [nvarchar](128) NOT NULL,
	[row_effective_date] [nvarchar](128) NOT NULL,
	[row_expiration_date] [nvarchar](128) NOT NULL,
	[row_insert_date] [nvarchar](128) NOT NULL,
	[row_update_date] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_added_dim_column_names] PRIMARY KEY CLUSTERED 
(
	[added_dim_column_names_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UNIQUE_added_dim_column_names_tag] UNIQUE NONCLUSTERED 
(
	[added_dim_column_names_tag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[application_config]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[application_config](
	[setting] [nvarchar](255) NOT NULL,
	[use_value] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_biml_application_config] PRIMARY KEY CLUSTERED 
(
	[setting] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[build_log]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[build_log](
	[build_id] [int] IDENTITY(1,1) NOT NULL,
	[event_datetime] [datetime2](0) NOT NULL,
	[event_group] [nvarchar](256) NOT NULL,
	[event_component] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_biml_build_log] PRIMARY KEY CLUSTERED 
(
	[build_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[column_alias]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[column_alias](
	[scope] [nvarchar](128) NOT NULL,
	[schema_name] [nvarchar](128) NOT NULL,
	[alias_name] [nvarchar](128) NOT NULL,
	[use_expression] [nvarchar](512) NULL,
 CONSTRAINT [PK_stg_dim_column] PRIMARY KEY CLUSTERED 
(
	[scope] ASC,
	[schema_name] ASC,
	[alias_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[environment_parameter]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[environment_parameter](
	[environment_name] [nvarchar](32) NOT NULL,
	[parameter_name] [nvarchar](128) NOT NULL,
	[parameter_value] [nvarchar](512) NOT NULL,
 CONSTRAINT [PK_environment_parameter] PRIMARY KEY CLUSTERED 
(
	[environment_name] ASC,
	[parameter_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[flatfile_format]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[flatfile_format](
	[file_format] [nvarchar](128) NOT NULL,
	[code_page] [nvarchar](64) NOT NULL,
	[column_delimiter] [nvarchar](64) NOT NULL,
	[row_delimiter] [nvarchar](64) NOT NULL,
	[text_qualifer] [nvarchar](64) NOT NULL,
	[ColumnNamesInFirstDataRow] [nvarchar](5) NOT NULL,
	[IsUnicode] [nvarchar](5) NOT NULL,
	[metadata_server] [nvarchar](128) NOT NULL,
	[metadata_database] [nvarchar](128) NOT NULL,
	[metadata_schema] [nvarchar](128) NOT NULL,
	[metadata_table] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_biml_flatfile_format] PRIMARY KEY CLUSTERED 
(
	[file_format] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[package_config (CT Replication)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[package_config (CT Replication)](
	[package_qualifier] [nvarchar](64) NOT NULL,
	[src_connection] [nvarchar](64) NOT NULL,
	[src_deletes_query_expr] [nvarchar](max) NOT NULL,
	[src_inserts_query_expr] [nvarchar](max) NOT NULL,
	[dst_connection] [nvarchar](64) NOT NULL,
	[dst_sync_query] [nvarchar](max) NOT NULL,
	[sync_schema] [nvarchar](128) NOT NULL,
	[target_table] [nvarchar](128) NOT NULL,
	[use_identity_insert] [nvarchar](1) NOT NULL,
	[package_name]  AS ((('CT Replication - '+[package_qualifier])+' - ')+[target_table]),
 CONSTRAINT [PK_package_config (CT Replication)] PRIMARY KEY CLUSTERED 
(
	[package_qualifier] ASC,
	[target_table] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [biml].[package_config (Execute Process) variable]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[package_config (Execute Process) variable](
	[package_qualifier] [nvarchar](64) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[DataType] [nvarchar](32) NOT NULL,
	[EvaluateAsExpression] [nvarchar](5) NOT NULL,
	[variable_value] [nvarchar](max) NOT NULL,
	[variable_reference]  AS (('@[User::'+[Name])+']'),
 CONSTRAINT [PK_package_config (Execute Process) variable] PRIMARY KEY CLUSTERED 
(
	[package_qualifier] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [biml].[package_config (Execute Script)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[package_config (Execute Script)](
	[connection_manager] [nvarchar](64) NOT NULL,
	[script_name] [nvarchar](128) NOT NULL,
	[package_qualifier] [nvarchar](64) NOT NULL,
	[return_row_count] [nvarchar](1) NOT NULL,
	[package_name]  AS ('Execute Script - '+[package_qualifier]),
 CONSTRAINT [PK_package_config (Execute Script)] PRIMARY KEY CLUSTERED 
(
	[package_qualifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[package_config (Execute Script) variable]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[package_config (Execute Script) variable](
	[package_qualifier] [nvarchar](64) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[DataType] [nvarchar](32) NOT NULL,
	[EvaluateAsExpression] [nvarchar](5) NOT NULL,
	[variable_value] [nvarchar](max) NOT NULL,
	[variable_reference]  AS (('@[User::'+[Name])+']'),
 CONSTRAINT [PK_package_config (Execute Script) variable] PRIMARY KEY CLUSTERED 
(
	[package_qualifier] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [biml].[package_config (Foreach Data Flow)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[package_config (Foreach Data Flow)](
	[foreach_connection] [nvarchar](64) NOT NULL,
	[foreach_query_expr] [nvarchar](max) NOT NULL,
	[foreach_item_datatype] [nvarchar](32) NOT NULL,
	[foreach_item_build_value] [nvarchar](512) NOT NULL,
	[src_connection] [nvarchar](64) NOT NULL,
	[src_query_expr] [nvarchar](max) NOT NULL,
	[src_query_direct] [nvarchar](max) NULL,
	[package_qualifier] [nvarchar](64) NOT NULL,
	[dst_connection] [nvarchar](64) NOT NULL,
	[dst_schema] [nvarchar](128) NOT NULL,
	[dst_table] [nvarchar](128) NOT NULL,
	[dst_truncate] [nvarchar](1) NOT NULL,
	[keep_identity] [nvarchar](1) NOT NULL,
	[package_name]  AS ((('Foreach Data Flow - '+[package_qualifier])+' - ')+[dst_table]),
 CONSTRAINT [PK_package_config (Foreach Data Flow)] PRIMARY KEY CLUSTERED 
(
	[package_qualifier] ASC,
	[dst_table] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [biml].[package_config (Foreach Execute SQL)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[package_config (Foreach Execute SQL)](
	[package_qualifier] [nvarchar](64) NOT NULL,
	[foreach_connection] [nvarchar](64) NOT NULL,
	[foreach_query_expr] [nvarchar](max) NOT NULL,
	[foreach_item_datatype] [nvarchar](32) NOT NULL,
	[foreach_item_build_value] [nvarchar](512) NOT NULL,
	[query_connection] [nvarchar](64) NOT NULL,
	[query] [nvarchar](max) NOT NULL,
	[is_expression] [nvarchar](1) NOT NULL,
	[return_row_count] [nvarchar](1) NOT NULL,
	[package_name]  AS ('Foreach Execute SQL - '+[package_qualifier]),
 CONSTRAINT [PK package_config (Foreach Execute SQL)] PRIMARY KEY CLUSTERED 
(
	[package_qualifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [biml].[package_config (Manual)]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[package_config (Manual)](
	[package_qualifier] [nvarchar](64) NOT NULL,
	[package_name]  AS ('Manual - '+[package_qualifier]),
 CONSTRAINT [PK_package_config (Manual)] PRIMARY KEY CLUSTERED 
(
	[package_qualifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[project_package_group]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[project_package_group](
	[project_id] [int] NOT NULL,
	[sequence_number] [int] NOT NULL,
	[package_name] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_project_package_group] PRIMARY KEY CLUSTERED 
(
	[project_id] ASC,
	[package_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[project_script_task]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[project_script_task](
	[project_id] [int] NOT NULL,
	[script_name] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_project_script_task] PRIMARY KEY CLUSTERED 
(
	[project_id] ASC,
	[script_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[query_history]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[query_history](
	[query_history_id] [int] IDENTITY(1,1) NOT NULL,
	[package_config_table] [nvarchar](512) NOT NULL,
	[query_tag] [nvarchar](128) NOT NULL,
	[query] [nvarchar](max) NOT NULL,
	[insert_datetime] [datetime2](0) NOT NULL,
	[project_id] [int] NULL,
	[package_name] [nchar](500) NULL,
 CONSTRAINT [PK_query_history] PRIMARY KEY CLUSTERED 
(
	[query_history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [biml].[query_repository]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[query_repository](
	[query_repository_id] [int] IDENTITY(1,1) NOT NULL,
	[query_notes] [nvarchar](3000) NOT NULL,
	[query] [nvarchar](max) NOT NULL,
	[insert_datetime] [datetime2](0) NOT NULL,
 CONSTRAINT [PK_query_repository] PRIMARY KEY CLUSTERED 
(
	[query_repository_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [biml].[script_task]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[script_task](
	[script_name] [nvarchar](128) NOT NULL,
	[script_text] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_biml_script_task] PRIMARY KEY CLUSTERED 
(
	[script_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [biml].[sensitive_data]    Script Date: 5/3/2018 8:48:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[sensitive_data](
	[place_holder] [nvarchar](64) NOT NULL,
	[actual_value] [nvarchar](512) NOT NULL,
 CONSTRAINT [PK sensitive_data] PRIMARY KEY CLUSTERED 
(
	[place_holder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[template]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[template](
	[template_name] [nvarchar](32) NOT NULL,
	[template_type] [nvarchar](32) NOT NULL,
	[template_group] [nvarchar](32) NOT NULL,
	[display_order] [int] NOT NULL,
	[author_id] [int] NOT NULL,
	[description] [nvarchar](4000) NULL,
	[template_xml] [xml] NOT NULL,
 CONSTRAINT [PK_template] PRIMARY KEY CLUSTERED 
(
	[template_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [biml].[user]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[user](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[user_name] [nvarchar](64) NOT NULL,
 CONSTRAINT [PK_biml_user] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UNIQUE_user_user_name] UNIQUE NONCLUSTERED 
(
	[user_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [biml].[user_activity]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [biml].[user_activity](
	[activity_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[author_id] [int] NOT NULL,
	[activity_datetime] [datetime2](0) NOT NULL,
	[activity_name] [nvarchar](64) NOT NULL,
	[build_component] [nvarchar](128) NOT NULL,
	[activity_count] [int] NOT NULL,
 CONSTRAINT [PK_biml_user_activity] PRIMARY KEY CLUSTERED 
(
	[activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [etl].[dim_column]    Script Date: 5/3/2018 8:48:50 AM ******/
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
/****** Object:  Table [etl].[dim_database]    Script Date: 5/3/2018 8:48:50 AM ******/
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
/****** Object:  Table [etl].[dim_server]    Script Date: 5/3/2018 8:48:50 AM ******/
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
/****** Object:  Table [etl].[dim_table]    Script Date: 5/3/2018 8:48:50 AM ******/
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
ALTER TABLE [biml].[column_alias] ADD  CONSTRAINT [DF biml column_alias scope]  DEFAULT ('*') FOR [scope]
GO
ALTER TABLE [biml].[connection] ADD  CONSTRAINT [DF biml connection custom_connect_string]  DEFAULT ('') FOR [custom_connect_string]
GO
ALTER TABLE [biml].[flatfile_format] ADD  CONSTRAINT [DF biml flatfile_format code_page]  DEFAULT ('1252') FOR [code_page]
GO
ALTER TABLE [biml].[flatfile_format] ADD  CONSTRAINT [DF biml flatfile_format row_delimiter]  DEFAULT ('CRLF') FOR [row_delimiter]
GO
ALTER TABLE [biml].[flatfile_format] ADD  CONSTRAINT [DF biml flatfile_format text_qualifer]  DEFAULT ('_x0022_') FOR [text_qualifer]
GO
ALTER TABLE [biml].[flatfile_format] ADD  CONSTRAINT [DF biml flatfile_format ColumnNamesInFirstDataRow]  DEFAULT ('false') FOR [ColumnNamesInFirstDataRow]
GO
ALTER TABLE [biml].[flatfile_format] ADD  CONSTRAINT [DF biml flatfile_format IsUnicode]  DEFAULT ('false') FOR [IsUnicode]
GO
ALTER TABLE [biml].[package] ADD  CONSTRAINT [DF biml package package_text]  DEFAULT ('<blank />') FOR [package_text]
GO
ALTER TABLE [biml].[package_config (CT Replication)] ADD  CONSTRAINT [DF biml package_config (CT Replication) use_identity_insert]  DEFAULT ('N') FOR [use_identity_insert]
GO
ALTER TABLE [biml].[package_config (Data Flow)] ADD  CONSTRAINT [DF biml package_config (Data Flow) src_query]  DEFAULT ('') FOR [src_query]
GO
ALTER TABLE [biml].[package_config (Data Flow)] ADD  CONSTRAINT [DF biml package_config (Data Flow) is_expression]  DEFAULT ('N') FOR [is_expression]
GO
ALTER TABLE [biml].[package_config (Data Flow)] ADD  CONSTRAINT [DF biml package_config (Data Flow) dst_schema]  DEFAULT ('') FOR [dst_schema]
GO
ALTER TABLE [biml].[package_config (Data Flow)] ADD  CONSTRAINT [DF biml package_config (Data Flow) dst_table]  DEFAULT ('') FOR [dst_table]
GO
ALTER TABLE [biml].[package_config (Data Flow)] ADD  CONSTRAINT [DF biml package_config (Data Flow) dst_truncate]  DEFAULT ('Y') FOR [dst_truncate]
GO
ALTER TABLE [biml].[package_config (Data Flow)] ADD  CONSTRAINT [DF biml package_config (Data Flow) keep_identity]  DEFAULT ('N') FOR [keep_identity]
GO
ALTER TABLE [biml].[package_config (Execute Process)] ADD  CONSTRAINT [DF biml package_config (Execute Process) arguments_expr]  DEFAULT ('') FOR [arguments_expr]
GO
ALTER TABLE [biml].[package_config (Execute Process)] ADD  CONSTRAINT [DF biml package_config (Execute Process) working_directory]  DEFAULT ('') FOR [working_directory]
GO
ALTER TABLE [biml].[package_config (Execute Process)] ADD  CONSTRAINT [DF biml package_config (Execute Process) place_values_in_SSIS_Data]  DEFAULT ('Y') FOR [place_values_in_SSIS_Data]
GO
ALTER TABLE [biml].[package_config (Execute Script)] ADD  CONSTRAINT [DF biml package_config (Execute Script) return_row_count]  DEFAULT ('Y') FOR [return_row_count]
GO
ALTER TABLE [biml].[package_config (Execute SQL)] ADD  CONSTRAINT [DF biml package_config (Execute SQL) is_expression]  DEFAULT ('N') FOR [is_expression]
GO
ALTER TABLE [biml].[package_config (Execute SQL)] ADD  CONSTRAINT [DF biml package_config (Execute SQL) return_row_count]  DEFAULT ('Y') FOR [return_row_count]
GO
ALTER TABLE [biml].[package_config (Foreach Data Flow)] ADD  CONSTRAINT [DF biml package_config (Foreach Data Flow) foreach_item_datatype]  DEFAULT ('String') FOR [foreach_item_datatype]
GO
ALTER TABLE [biml].[package_config (Foreach Data Flow)] ADD  CONSTRAINT [DF biml package_config (Foreach Data Flow) foreach_item_build_value]  DEFAULT ('') FOR [foreach_item_build_value]
GO
ALTER TABLE [biml].[package_config (Foreach Data Flow)] ADD  CONSTRAINT [DF biml package_config (Foreach Data Flow) dst_truncate]  DEFAULT ('Y') FOR [dst_truncate]
GO
ALTER TABLE [biml].[package_config (Foreach Data Flow)] ADD  CONSTRAINT [DF biml package_config (Foreach Data Flow) keep_identity]  DEFAULT ('N') FOR [keep_identity]
GO
ALTER TABLE [biml].[package_config (Foreach Execute SQL)] ADD  CONSTRAINT [DF biml package_config (Foreach Execute SQL) foreach_item_datatype]  DEFAULT ('String') FOR [foreach_item_datatype]
GO
ALTER TABLE [biml].[package_config (Foreach Execute SQL)] ADD  CONSTRAINT [DF biml package_config (Foreach Execute SQL) foreach_item_build_value]  DEFAULT ('') FOR [foreach_item_build_value]
GO
ALTER TABLE [biml].[package_config (Foreach Execute SQL)] ADD  CONSTRAINT [DF biml package_config (Foreach Execute SQL) is_expression]  DEFAULT ('Y') FOR [is_expression]
GO
ALTER TABLE [biml].[project_package] ADD  DEFAULT ((-1)) FOR [sequence_number]
GO
ALTER TABLE [biml].[query_history] ADD  DEFAULT (getdate()) FOR [insert_datetime]
GO
ALTER TABLE [biml].[query_repository] ADD  DEFAULT (getdate()) FOR [insert_datetime]
GO
ALTER TABLE [etl].[dim_column] ADD  CONSTRAINT [DF__dim_column__merge_type]  DEFAULT ('t1') FOR [merge_type]
GO
ALTER TABLE [biml].[fact_table_partition_config (Standard)]  WITH CHECK ADD  CONSTRAINT [CC_truncate_switch_in_table] CHECK  (([truncate_switch_in_table]='Y' OR [truncate_switch_in_table]='N'))
GO
ALTER TABLE [biml].[fact_table_partition_config (Standard)] CHECK CONSTRAINT [CC_truncate_switch_in_table]
GO
ALTER TABLE [biml].[flatfile_format]  WITH CHECK ADD  CONSTRAINT [CC flatfile_format column_delimiter] CHECK  (([column_delimiter]='Comma' OR [column_delimiter]='Tab' OR [column_delimiter]='|'))
GO
ALTER TABLE [biml].[flatfile_format] CHECK CONSTRAINT [CC flatfile_format column_delimiter]
GO
ALTER TABLE [biml].[flatfile_format]  WITH CHECK ADD  CONSTRAINT [CC flatfile_format ColumnNamesInFirstDataRow] CHECK  (([ColumnNamesInFirstDataRow]='true' OR [ColumnNamesInFirstDataRow]='false'))
GO
ALTER TABLE [biml].[flatfile_format] CHECK CONSTRAINT [CC flatfile_format ColumnNamesInFirstDataRow]
GO
ALTER TABLE [biml].[flatfile_format]  WITH CHECK ADD  CONSTRAINT [CC flatfile_format IsUnicode] CHECK  (([IsUnicode]='true' OR [IsUnicode]='false'))
GO
ALTER TABLE [biml].[flatfile_format] CHECK CONSTRAINT [CC flatfile_format IsUnicode]
GO
ALTER TABLE [biml].[package_config (CT Replication)]  WITH CHECK ADD  CONSTRAINT [CC_package_config (CT Replication) use_identity_insert] CHECK  (([use_identity_insert]='Y' OR [use_identity_insert]='N'))
GO
ALTER TABLE [biml].[package_config (CT Replication)] CHECK CONSTRAINT [CC_package_config (CT Replication) use_identity_insert]
GO
ALTER TABLE [biml].[package_config (Data Flow)]  WITH CHECK ADD  CONSTRAINT [CC biml package_config (Data Flow) is_expression] CHECK  (([is_expression]='Y' OR [is_expression]='N'))
GO
ALTER TABLE [biml].[package_config (Data Flow)] CHECK CONSTRAINT [CC biml package_config (Data Flow) is_expression]
GO
ALTER TABLE [biml].[package_config (Data Flow)]  WITH CHECK ADD  CONSTRAINT [CC_package_config (Data Flow) dst_truncate] CHECK  (([dst_truncate]='Y' OR [dst_truncate]='N'))
GO
ALTER TABLE [biml].[package_config (Data Flow)] CHECK CONSTRAINT [CC_package_config (Data Flow) dst_truncate]
GO
ALTER TABLE [biml].[package_config (Data Flow)]  WITH CHECK ADD  CONSTRAINT [CC_package_config (Data Flow) keep_identity] CHECK  (([keep_identity]='Y' OR [keep_identity]='N'))
GO
ALTER TABLE [biml].[package_config (Data Flow)] CHECK CONSTRAINT [CC_package_config (Data Flow) keep_identity]
GO
ALTER TABLE [biml].[package_config (Execute Process)]  WITH CHECK ADD  CONSTRAINT [CC_package_config (Execute Process) place_values_in_SSIS_Data] CHECK  (([place_values_in_SSIS_Data]='Y' OR [place_values_in_SSIS_Data]='N'))
GO
ALTER TABLE [biml].[package_config (Execute Process)] CHECK CONSTRAINT [CC_package_config (Execute Process) place_values_in_SSIS_Data]
GO
ALTER TABLE [biml].[package_config (Execute Process) variable]  WITH CHECK ADD  CONSTRAINT [CC package_config (Execute Process) variable EvaluateAsExpression] CHECK  (([EvaluateAsExpression]='true' OR [EvaluateAsExpression]='false'))
GO
ALTER TABLE [biml].[package_config (Execute Process) variable] CHECK CONSTRAINT [CC package_config (Execute Process) variable EvaluateAsExpression]
GO
ALTER TABLE [biml].[package_config (Execute Script)]  WITH CHECK ADD  CONSTRAINT [CC_package_config (Execute Script) return_row_count] CHECK  (([return_row_count]='Y' OR [return_row_count]='N'))
GO
ALTER TABLE [biml].[package_config (Execute Script)] CHECK CONSTRAINT [CC_package_config (Execute Script) return_row_count]
GO
ALTER TABLE [biml].[package_config (Execute Script) variable]  WITH CHECK ADD  CONSTRAINT [CC package_config (Execute Script) variable EvaluateAsExpression] CHECK  (([EvaluateAsExpression]='true' OR [EvaluateAsExpression]='false'))
GO
ALTER TABLE [biml].[package_config (Execute Script) variable] CHECK CONSTRAINT [CC package_config (Execute Script) variable EvaluateAsExpression]
GO
ALTER TABLE [biml].[package_config (Execute SQL)]  WITH CHECK ADD  CONSTRAINT [CC biml package_config (Execute SQL) is_expression] CHECK  (([is_expression]='Y' OR [is_expression]='N'))
GO
ALTER TABLE [biml].[package_config (Execute SQL)] CHECK CONSTRAINT [CC biml package_config (Execute SQL) is_expression]
GO
ALTER TABLE [biml].[package_config (Execute SQL)]  WITH CHECK ADD  CONSTRAINT [CC_package_config (Execute SQL) return_row_count] CHECK  (([return_row_count]='Y' OR [return_row_count]='N'))
GO
ALTER TABLE [biml].[package_config (Execute SQL)] CHECK CONSTRAINT [CC_package_config (Execute SQL) return_row_count]
GO
ALTER TABLE [biml].[package_config (Foreach Data Flow)]  WITH CHECK ADD  CONSTRAINT [CC_package_config (Foreach Data Flow) dst_truncate] CHECK  (([dst_truncate]='Y' OR [dst_truncate]='N'))
GO
ALTER TABLE [biml].[package_config (Foreach Data Flow)] CHECK CONSTRAINT [CC_package_config (Foreach Data Flow) dst_truncate]
GO
ALTER TABLE [biml].[package_config (Foreach Data Flow)]  WITH CHECK ADD  CONSTRAINT [CC_package_config (Foreach Data Flow) keep_identity] CHECK  (([keep_identity]='Y' OR [keep_identity]='N'))
GO
ALTER TABLE [biml].[package_config (Foreach Data Flow)] CHECK CONSTRAINT [CC_package_config (Foreach Data Flow) keep_identity]
GO
ALTER TABLE [biml].[package_config (Foreach Execute SQL)]  WITH CHECK ADD  CONSTRAINT [CC biml package_config (Foreach Execute SQL) is_expression] CHECK  (([is_expression]='Y' OR [is_expression]='N'))
GO
ALTER TABLE [biml].[package_config (Foreach Execute SQL)] CHECK CONSTRAINT [CC biml package_config (Foreach Execute SQL) is_expression]
GO
ALTER TABLE [biml].[pattern]  WITH CHECK ADD  CONSTRAINT [CC_pattern has_config_table] CHECK  (([has_config_table]='Y' OR [has_config_table]='N'))
GO
ALTER TABLE [biml].[pattern] CHECK CONSTRAINT [CC_pattern has_config_table]
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
/****** Object:  StoredProcedure [biml].[Auto Save Query History]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 02 Nov 2017
-- Modify date: 27 Feb 2018 - add query_tag column to the where statement
-- Description:	Auto Save Query History on all forms
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Auto Save Query History] '@package_config_table', 'select...', 'package qualifier'
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Auto Save Query History]
(
	@package_config_table nvarchar(512),
	@src_query nvarchar(max),
    @package_qualifier nvarchar(64),
	@primary_key_update nvarchar(1) = '0',
	@package_name nvarchar(128) = '',
	@old_package_name nvarchar(128) = '',
	@project_id INT = 0
)
AS 
BEGIN
	-- check if PK is updated or not. If result is 0 than PK wasn't change and we need to update or insert value only in query history table table
	IF(@primary_key_update = '0')
		BEGIN
			--chek if query is changed. If yes add new row, if not do nothing.
			IF ((SELECT COUNT([query_history_id]) FROM [biml].[query_history] WHERE [package_config_table] = @package_config_table AND [package_name] = @package_name AND [project_id] = @project_id AND [query_tag] = @package_qualifier AND [query] = @src_query) = 0)
				BEGIN
					INSERT INTO [biml].[query_history]
						([package_config_table]
						,[query_tag]
						,[query]
						,[insert_datetime]
						,[project_id]
						,[package_name])
					VALUES
						(@package_config_table
						,@package_qualifier
						,@src_query
						,GETDATE()
						,@project_id
						,@package_name)
				END
		END
	ELSE
		BEGIN
		--update query history table
		BEGIN
			--chek if query is changed. If yes add new row, if not do nothing.
			IF ((SELECT COUNT([query_history_id]) FROM [biml].[query_history] WHERE [package_config_table] = @package_config_table AND [project_id] = @project_id AND [query] = @src_query AND [query_tag] = @package_qualifier AND [package_name] = @old_package_name) = 0)
				BEGIN
					INSERT INTO [biml].[query_history]
						([package_config_table]
						,[query_tag]
						,[query]
						,[insert_datetime]
						,[project_id]
						,[package_name])
					VALUES
						(@package_config_table
						,@package_qualifier
						,@src_query
						,GETDATE()
						,@project_id
						,@package_name)
				END

				--update package name for all existing rows
					UPDATE [biml].[query_history]
					SET	[package_name] = @package_name
					WHERE [package_name] = @old_package_name AND [package_config_table] = @package_config_table
				END
		END
END
GO
/****** Object:  StoredProcedure [biml].[Build All Packages]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 24 May 2016
-- Modify date: 11 Jun 2016 - Added truncate option
-- Modify date: 08 Aug 2016 - Added template option
-- Modify date: 07 Sep 2016 - Added package log
-- Modify date: 12 Sep 2016 - Added keep_identity
-- Modify date: 19 Jan 2017 - Added CT Replication Pattern
-- Modify date: 27 Feb 2017 - Fix for renamed columns
-- Modify date: 03 Apr 2017 - Added @foreach_connection
-- Modify date: 04 Apr 2017 - Added 'direct' queries for Ado.Net
-- Modify date: 05 Apr 2017 - Added 'row_count' parameter
-- Modify date: 10 Apr 2017 - Added Data Flow flat file parameters
-- Modify date: 13 Apr 2017 - Added Execute Process Pattern
-- Modify date: 14 Apr 2017 - Added Script Task Pattern
-- Modify date: 17 Apr 2017 - Removed 'Data Flow Expr' and 'Execute SQL Expr'
-- Modify date: 27 Apr 2017 - Added foreach data flow columns: 'datatype' and 'build value'
-- Modify date: 13 May 2017 - Added 'place values' option to Execute Process Pattern
-- Modify date: 20 Jun 2017 - Added pattern: package_config (Foreach Execute SQL)
-- Modify date: 04 Aug 2017 - Added pattern: package_config (Manual)
--
-- Description:	Builds All BIML Packages
--
-- Sample Execute Command: 
/*
EXEC [biml].[Build All Packages] @BaseTemplateName = 'Standard'           , @RunAllTemplateName = 'Run All'           , @GroupTemplateName = 'Group';
EXEC [biml].[Build All Packages] @BaseTemplateName = 'Standard No Alerts' , @RunAllTemplateName = 'Run All No Alerts' , @GroupTemplateName = 'Group No Alerts';
*/
--
-- ================================================================================================

CREATE PROCEDURE [biml].[Build All Packages]
	  @BaseTemplateName AS NVARCHAR(32) 
	, @RunAllTemplateName AS NVARCHAR(32) 
	, @GroupTemplateName AS NVARCHAR(32) 
AS


DECLARE @connection_manager NVARCHAR(64)
	  , @package_qualifier NVARCHAR(64)
	  , @query NVARCHAR(MAX)
	  , @query_expression NVARCHAR(MAX);

DECLARE @src_connection NVARCHAR(64)
      , @foreach_query NVARCHAR(MAX)
      , @src_query NVARCHAR(MAX)
      , @src_query_expression NVARCHAR(MAX)
      , @foreach_connection NVARCHAR(64)
      , @dst_connection NVARCHAR(64)
      , @dst_schema NVARCHAR(128)
      , @dst_table NVARCHAR(128)
      , @dst_truncate NVARCHAR(1)
      , @keep_identity NVARCHAR(1)
      , @use_identity_insert NVARCHAR(1)
	  , @src_deletes_query_exp NVARCHAR(MAX)
	  , @src_inserts_query_exp NVARCHAR(MAX)
	  , @dst_sync_query NVARCHAR(MAX)
	  , @sync_schema NVARCHAR(128)
	  , @target_table NVARCHAR(128)
	  , @FilePath NVARCHAR(512)
	  , @FileFormat NVARCHAR(64)
	  , @return_row_count AS NVARCHAR(1)
	  , @executable NVARCHAR(1024)
	  , @arguments NVARCHAR(MAX)
	  , @working_dir NVARCHAR(2048)
	  , @script_name NVARCHAR(128)
	  , @is_expression NVARCHAR(1)
      , @src_query_direct NVARCHAR(MAX)
	  , @foreach_item_datatype NVARCHAR(32)
	  , @foreach_item_build_value NVARCHAR(512)
	  , @place_values_in_SSIS_Data NVARCHAR(1)
	  , @query_connection NVARCHAR(64);


DECLARE @project_name NVARCHAR(64)
	  , @package_count INT = 0

DELETE [biml].[package];


---------------------------------------------
-- Using (CT Replication)
---------------------------------------------
SET @package_count = 0

DECLARE [proc_cursor] CURSOR FOR  
SELECT [package_qualifier]
     , [src_connection]
     , [src_deletes_query_expr]
     , [src_inserts_query_expr]
     , [dst_connection]
     , [dst_sync_query]
     , [sync_schema]
     , [target_table]
  FROM [biml].[package_config (CT Replication)]

OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @package_qualifier, @src_connection, @src_deletes_query_exp, @src_inserts_query_exp, @dst_connection, @dst_sync_query, @sync_schema, @target_table

WHILE @@FETCH_STATUS = 0   
BEGIN 
	EXEC [biml].[Build Packages (CT Replication)] @package_qualifier, @src_connection, @src_deletes_query_exp, @src_inserts_query_exp, @dst_connection, @dst_sync_query, @sync_schema, @target_table, @BaseTemplateName
	SET @package_count = @package_count + 1

	FETCH NEXT FROM [proc_cursor] INTO @package_qualifier, @src_connection, @src_deletes_query_exp, @src_inserts_query_exp, @dst_connection, @dst_sync_query, @sync_schema, @target_table
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];

-- log activity
IF @package_count != 0
	BEGIN
		INSERT [biml].[user_activity]
			 ( [user_id]
			 , [author_id]
			 , [activity_datetime]
			 , [activity_name]
			 , [build_component]
			 , [activity_count]
			 )
		SELECT [biml].[get user id] ()
			 , 1 -- BI Tracks (author)
			 , GETDATE()
			 , 'pattern use'
			 , 'CT Replication'
			 , @package_count

		INSERT [biml].[user_activity]
			 ( [user_id]
			 , [author_id]
			 , [activity_datetime]
			 , [activity_name]
			 , [build_component]
			 , [activity_count]
			 )
		SELECT [biml].[get user id] ()
			 , 1 -- BI Tracks (author)
			 , GETDATE()
			 , 'template use'
			 , @BaseTemplateName
			 , @package_count
	END


---------------------------------------------
-- Using (Data Flow)
---------------------------------------------
SET @package_count = 0

DECLARE [proc_cursor] CURSOR FOR  
SELECT [src_connection]
     , [src_query]
	 , [is_expression]
	 , [src_query_direct]
     , [package_qualifier]
     , [dst_connection]
     , [dst_schema]
     , [dst_table]
     , [dst_truncate]
	 , [keep_identity]
  FROM [biml].[package_config (Data Flow)]


OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @src_connection, @src_query, @is_expression, @src_query_direct, @package_qualifier, @dst_connection, @dst_schema, @dst_table, @dst_truncate, @keep_identity

WHILE @@FETCH_STATUS = 0   
BEGIN 
	EXEC [biml].[Build Packages (Data Flow)] @src_connection, @src_query, @is_expression, @src_query_direct, @package_qualifier, @dst_connection, @dst_schema, @dst_table, @dst_truncate, @keep_identity, @BaseTemplateName
	SET @package_count = @package_count + 1

	FETCH NEXT FROM [proc_cursor] INTO @src_connection, @src_query, @is_expression, @src_query_direct, @package_qualifier, @dst_connection, @dst_schema, @dst_table, @dst_truncate, @keep_identity
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];

-- log activity
IF @package_count != 0
	BEGIN
		INSERT [biml].[user_activity]
			 ( [user_id]
			 , [author_id]
			 , [activity_datetime]
			 , [activity_name]
			 , [build_component]
			 , [activity_count]
			 )
		SELECT [biml].[get user id] ()
			 , 1 -- BI Tracks (author)
			 , GETDATE()
			 , 'pattern use'
			 , 'Data Flow'
			 , @package_count

		INSERT [biml].[user_activity]
			 ( [user_id]
			 , [author_id]
			 , [activity_datetime]
			 , [activity_name]
			 , [build_component]
			 , [activity_count]
			 )
		SELECT [biml].[get user id] ()
			 , 1 -- BI Tracks (author)
			 , GETDATE()
			 , 'template use'
			 , @BaseTemplateName
			 , @package_count
	END


---------------------------------------------
-- Using (Execute Process)
---------------------------------------------
SET @package_count = 0

DECLARE [proc_cursor] CURSOR FOR  
SELECT [package_qualifier]
	 , [executable_expr]
	 , [arguments_expr]
	 , [working_directory]
	 , [place_values_in_SSIS_Data]
  FROM [biml].[package_config (Execute Process)]

OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @package_qualifier, @executable, @arguments, @working_dir, @place_values_in_SSIS_Data

WHILE @@FETCH_STATUS = 0   
BEGIN 
	EXEC [biml].[Build Packages (Execute Process)] @package_qualifier, @executable, @arguments, @working_dir, @place_values_in_SSIS_Data, @BaseTemplateName
	SET @package_count = @package_count + 1

	FETCH NEXT FROM [proc_cursor] INTO @package_qualifier, @executable, @arguments, @working_dir, @place_values_in_SSIS_Data
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];

-- log activity
IF @package_count != 0
	BEGIN
		INSERT [biml].[user_activity]
			 ( [user_id]
			 , [author_id]
			 , [activity_datetime]
			 , [activity_name]
			 , [build_component]
			 , [activity_count]
			 )
		SELECT [biml].[get user id] ()
			 , 1 -- BI Tracks (author)
			 , GETDATE()
			 , 'pattern use'
			 , 'Execute Process'
			 , @package_count

		INSERT [biml].[user_activity]
			 ( [user_id]
			 , [author_id]
			 , [activity_datetime]
			 , [activity_name]
			 , [build_component]
			 , [activity_count]
			 )
		SELECT [biml].[get user id] ()
			 , 1 -- BI Tracks (author)
			 , GETDATE()
			 , 'template use'
			 , @BaseTemplateName
			 , @package_count
	END


---------------------------------------------
-- Using (Execute Script)
---------------------------------------------
SET @package_count = 0

DECLARE [proc_cursor] CURSOR FOR  
SELECT [connection_manager]
	 , [script_name]
     , [package_qualifier]
	 , [return_row_count]
  FROM [biml].[package_config (Execute Script)]

OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @connection_manager, @script_name, @package_qualifier, @return_row_count

WHILE @@FETCH_STATUS = 0   
BEGIN 
	EXEC [biml].[Build Packages (Execute Script)] @connection_manager, @script_name, @package_qualifier, @return_row_count, @BaseTemplateName
	SET @package_count = @package_count + 1

	FETCH NEXT FROM [proc_cursor] INTO @connection_manager, @script_name, @package_qualifier, @return_row_count
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];

-- log activity
IF @package_count != 0
	BEGIN
		INSERT [biml].[user_activity]
			 ( [user_id]
			 , [author_id]
			 , [activity_datetime]
			 , [activity_name]
			 , [build_component]
			 , [activity_count]
			 )
		SELECT [biml].[get user id] ()
			 , 1 -- BI Tracks (author)
			 , GETDATE()
			 , 'pattern use'
			 , 'Execute Script'
			 , @package_count

		INSERT [biml].[user_activity]
			 ( [user_id]
			 , [author_id]
			 , [activity_datetime]
			 , [activity_name]
			 , [build_component]
			 , [activity_count]
			 )
		SELECT [biml].[get user id] ()
			 , 1 -- BI Tracks (author)
			 , GETDATE()
			 , 'template use'
			 , @BaseTemplateName
			 , @package_count
	END


---------------------------------------------
-- Using (Execute SQL)
---------------------------------------------
SET @package_count = 0

DECLARE [proc_cursor] CURSOR FOR  
SELECT [connection_manager]
     , [package_qualifier]
	 , [query]
	 , [is_expression]
	 , [return_row_count]
  FROM [biml].[package_config (Execute SQL)]

OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @connection_manager, @package_qualifier, @query, @is_expression, @return_row_count

WHILE @@FETCH_STATUS = 0   
BEGIN 
	EXEC [biml].[Build Packages (Execute SQL)] @connection_manager, @package_qualifier, @query, @is_expression, @return_row_count, @BaseTemplateName
	SET @package_count = @package_count + 1

	FETCH NEXT FROM [proc_cursor] INTO @connection_manager, @package_qualifier, @query, @is_expression, @return_row_count
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];

-- log activity
IF @package_count != 0
	BEGIN
		INSERT [biml].[user_activity]
			 ( [user_id]
			 , [author_id]
			 , [activity_datetime]
			 , [activity_name]
			 , [build_component]
			 , [activity_count]
			 )
		SELECT [biml].[get user id] ()
			 , 1 -- BI Tracks (author)
			 , GETDATE()
			 , 'pattern use'
			 , 'Execute SQL'
			 , @package_count

		INSERT [biml].[user_activity]
			 ( [user_id]
			 , [author_id]
			 , [activity_datetime]
			 , [activity_name]
			 , [build_component]
			 , [activity_count]
			 )
		SELECT [biml].[get user id] ()
			 , 1 -- BI Tracks (author)
			 , GETDATE()
			 , 'template use'
			 , @BaseTemplateName
			 , @package_count
	END


---------------------------------------------
-- Using (Foreach Data Flow)
---------------------------------------------
SET @package_count = 0

DECLARE [proc_cursor] CURSOR FOR  
SELECT [foreach_connection]
	 , [src_connection]
     , [foreach_query_expr]
	 , [foreach_item_datatype]
	 , [foreach_item_build_value]
     , [src_query_expr]
	 , [src_query_direct]
     , [package_qualifier]
     , [dst_connection]
     , [dst_schema]
     , [dst_table]
     , [dst_truncate]
	 , [keep_identity]
  FROM [biml].[package_config (Foreach Data Flow)]

OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @foreach_connection, @src_connection, @foreach_query, @foreach_item_datatype, @foreach_item_build_value, @src_query, @src_query_direct, @package_qualifier, @dst_connection, @dst_schema, @dst_table, @dst_truncate, @keep_identity

WHILE @@FETCH_STATUS = 0   
BEGIN 
	EXEC [biml].[Build Packages (Foreach Data Flow)] @foreach_connection, @src_connection, @foreach_query, @foreach_item_datatype, @foreach_item_build_value, @src_query, @src_query_direct, @package_qualifier, @dst_connection, @dst_schema, @dst_table, @dst_truncate, @keep_identity, @BaseTemplateName
	SET @package_count = @package_count + 1

	FETCH NEXT FROM [proc_cursor] INTO @foreach_connection, @src_connection, @foreach_query, @foreach_item_datatype, @foreach_item_build_value, @src_query, @src_query_direct, @package_qualifier, @dst_connection, @dst_schema, @dst_table, @dst_truncate, @keep_identity
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];

-- log activity
IF @package_count != 0
	BEGIN
		INSERT [biml].[user_activity]
			 ( [user_id]
			 , [author_id]
			 , [activity_datetime]
			 , [activity_name]
			 , [build_component]
			 , [activity_count]
			 )
		SELECT [biml].[get user id] ()
			 , 1 -- BI Tracks (author)
			 , GETDATE()
			 , 'pattern use'
			 , 'Foreach Data Flow'
			 , @package_count

		INSERT [biml].[user_activity]
			 ( [user_id]
			 , [author_id]
			 , [activity_datetime]
			 , [activity_name]
			 , [build_component]
			 , [activity_count]
			 )
		SELECT [biml].[get user id] ()
			 , 1 -- BI Tracks (author)
			 , GETDATE()
			 , 'template use'
			 , @BaseTemplateName
			 , @package_count
	END



---------------------------------------------
-- Using (Foreach Execute SQL)
---------------------------------------------
SET @package_count = 0

DECLARE [proc_cursor] CURSOR FOR  
SELECT [package_qualifier]
	 , [foreach_connection]
     , [foreach_query_expr]
	 , [foreach_item_datatype]
	 , [foreach_item_build_value]
     , [query_connection]
	 , [query]
	 , [is_expression]
	 , [return_row_count]
  FROM [biml].[package_config (Foreach Execute SQL)]

OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @package_qualifier, @foreach_connection, @foreach_query, @foreach_item_datatype, @foreach_item_build_value, @query_connection, @query, @is_expression, @return_row_count

WHILE @@FETCH_STATUS = 0   
BEGIN 
	EXEC [biml].[Build Packages (Foreach Execute SQL)] @package_qualifier, @foreach_connection, @foreach_query, @foreach_item_datatype, @foreach_item_build_value, @query_connection, @query, @is_expression, @return_row_count, @BaseTemplateName
	SET @package_count = @package_count + 1

	FETCH NEXT FROM [proc_cursor] INTO @package_qualifier, @foreach_connection, @foreach_query, @foreach_item_datatype, @foreach_item_build_value, @query_connection, @query, @is_expression, @return_row_count
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];

-- log activity
IF @package_count != 0
	BEGIN
		INSERT [biml].[user_activity]
			 ( [user_id]
			 , [author_id]
			 , [activity_datetime]
			 , [activity_name]
			 , [build_component]
			 , [activity_count]
			 )
		SELECT [biml].[get user id] ()
			 , 1 -- BI Tracks (author)
			 , GETDATE()
			 , 'pattern use'
			 , 'Foreach Execute SQL'
			 , @package_count

		INSERT [biml].[user_activity]
			 ( [user_id]
			 , [author_id]
			 , [activity_datetime]
			 , [activity_name]
			 , [build_component]
			 , [activity_count]
			 )
		SELECT [biml].[get user id] ()
			 , 1 -- BI Tracks (author)
			 , GETDATE()
			 , 'template use'
			 , @BaseTemplateName
			 , @package_count
	END

---------------------------------------------
-- Using (Manual)
---------------------------------------------
SET @package_count = 0

DECLARE [proc_cursor] CURSOR FOR  
SELECT [package_qualifier]
  FROM [biml].[package_config (Manual)]

OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @package_qualifier

WHILE @@FETCH_STATUS = 0   
BEGIN 
	EXEC [biml].[Build Packages (Manual)] @package_qualifier, 'N/A'
	SET @package_count = @package_count + 1

	FETCH NEXT FROM [proc_cursor] INTO @package_qualifier
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];

-- log activity
IF @package_count != 0
	BEGIN
		INSERT [biml].[user_activity]
			 ( [user_id]
			 , [author_id]
			 , [activity_datetime]
			 , [activity_name]
			 , [build_component]
			 , [activity_count]
			 )
		SELECT [biml].[get user id] ()
			 , 1 -- BI Tracks (author)
			 , GETDATE()
			 , 'pattern use'
			 , 'Manual'
			 , @package_count

		INSERT [biml].[user_activity]
			 ( [user_id]
			 , [author_id]
			 , [activity_datetime]
			 , [activity_name]
			 , [build_component]
			 , [activity_count]
			 )
		SELECT [biml].[get user id] ()
			 , 1 -- BI Tracks (author)
			 , GETDATE()
			 , 'template use'
			 , 'N/A'
			 , @package_count
	END



---------------------------------------------
-- Using (Run All Package)
---------------------------------------------
SET @package_count = 0

DECLARE [proc_cursor] CURSOR FOR  
SELECT [project_name]
  FROM [biml].[project]

OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @project_name

WHILE @@FETCH_STATUS = 0   
BEGIN 
	EXEC [biml].[Build Group and Run All Packages] @BasePackageName   = 'Run All'
												 , @ProjectName       = @project_name
												 , @UseTemplateRunAll = @RunAllTemplateName
												 , @UseTemplateGroup  = @GroupTemplateName
	SET @package_count = @package_count + 1

	FETCH NEXT FROM [proc_cursor] INTO @project_name
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];

-- log activity
IF @package_count != 0
	BEGIN
		INSERT [biml].[user_activity]
			 ( [user_id]
			 , [author_id]
			 , [activity_datetime]
			 , [activity_name]
			 , [build_component]
			 , [activity_count]
			 )
		SELECT [biml].[get user id] ()
			 , 1 -- BI Tracks (author)
			 , GETDATE()
			 , 'pattern use'
			 , 'Run All Package'
			 , @package_count

		INSERT [biml].[user_activity]
			 ( [user_id]
			 , [author_id]
			 , [activity_datetime]
			 , [activity_name]
			 , [build_component]
			 , [activity_count]
			 )
		SELECT [biml].[get user id] ()
			 , 1 -- BI Tracks (author)
			 , GETDATE()
			 , 'template use'
			 , @RunAllTemplateName
			 , @package_count
	END





GO
/****** Object:  StoredProcedure [biml].[Build All Projects]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 26 Aug 2016
-- Modify date: 27 Aug 2016 - added 'template group'
-- Modify date: 22 Oct 2016 - Added package protection option
-- Modify date: 02 Mar 2017 - Added logging to [biml].[build_log]
-- Modify date: 14 Dec 2017 - Remove template group update on build (Maja Kozar)
-- Modify date: 18 Dec 2017 - Added 'Register User'
-- Modify date: 29 Jan 2018 - Do not update environment template group on build (Maja Kozar)
-- Description:	Updates All Project, and Project Environment Biml
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Build All Projects]  'No Framework', 'EncryptSensitiveWithUserKey';
*/
-- ================================================================================================

CREATE PROCEDURE [biml].[Build All Projects] ( @template_group NVARCHAR(32), @PackageProtectionOption  NVARCHAR(32) )
AS

EXEC [biml].[Register User];

DECLARE @project_id		 INT
	  , @project_name    NVARCHAR(128)
	  , @environmentName NVARCHAR(32);

DECLARE @biml_project AS XML
	  , @biml_param   AS XML;


---------------------------------------------
-- Update All Projects
---------------------------------------------
DECLARE [proc_cursor_project] CURSOR FOR  
 SELECT [project_name]
   FROM [biml].[project]
    
OPEN [proc_cursor_project]   
FETCH NEXT FROM [proc_cursor_project] INTO @project_name

WHILE @@FETCH_STATUS = 0   
BEGIN 

	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build All Projects - Project Biml'
		 , '@project_name: ' + @project_name);

	-- Get Project Biml
	EXEC [biml].[Build Project Full] @project_name, '', @PackageProtectionOption = @PackageProtectionOption, @Biml = @biml_project OUTPUT


	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build All Projects - Parameter Biml'
		 , '@project_name: ' + @project_name);

	-- Get Parameter Biml
	EXEC [biml].[Build Project Parameters] @project_name, '', @Biml = @biml_param OUTPUT

	UPDATE [biml].[project]
	   SET [project_xml]   = @biml_project
		 , [parameter_xml] = @biml_param
		 , [build_datetime] = GETDATE()
	 WHERE [project_name] = @project_name

	FETCH NEXT FROM [proc_cursor_project] INTO @project_name

END;  

CLOSE [proc_cursor_project]; 
DEALLOCATE [proc_cursor_project];



---------------------------------------------
-- Update All Project Environments
---------------------------------------------
DECLARE [proc_cursor_param] CURSOR FOR  
 SELECT pr.[project_id]
	  , pr.[project_name]
      , pe.[environment_name]
   FROM [biml].[project_environment] pe
   JOIN [biml].[project] pr
     ON pr.[project_id] = pe.[project_id]
	    
OPEN [proc_cursor_param]   
FETCH NEXT FROM [proc_cursor_param] INTO @project_id, @project_name, @environmentName

WHILE @@FETCH_STATUS = 0   
BEGIN 

	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build All Projects - Project Biml'
		 , '@project_name: ' + @project_name + ', @environmentName: ' + @environmentName);

	-- Get Project Biml
	EXEC [biml].[Build Project Full] @project_name, @environmentName, @PackageProtectionOption = @PackageProtectionOption, @Biml = @biml_project OUTPUT


	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build All Projects - Parameter Biml'
		 , '@project_name: ' + @project_name + ', @environmentName: ' + @environmentName);

	-- Get Parameter Biml
	EXEC [biml].[Build Project Parameters] @project_name, @environmentName, @Biml = @biml_param OUTPUT

	UPDATE [biml].[project_environment]
	   SET [project_xml]   = @biml_project
		 , [parameter_xml] = @biml_param
		 , [build_datetime] = GETDATE()
	 WHERE [project_id] = @project_id
	   AND [environment_name] = @environmentName

	FETCH NEXT FROM [proc_cursor_param] INTO @project_id, @project_name, @environmentName

END;  

CLOSE [proc_cursor_param]; 
DEALLOCATE [proc_cursor_param];


---------------------------------------------
-- Save all new queries built or referenced during this full build
---------------------------------------------

EXEC [biml].[Save Query History]
GO
/****** Object:  StoredProcedure [biml].[Build BIML Utility]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 27 May 2016
-- Modify date: 07 Jun 2016 - Added Project.params
-- Modify date: 05 Aug 2016 - Added Base Templates
-- Modify date: 09 Aug 2016 - Added Run All Templates
-- Modify date: 10 Aug 2016 - Added Group Templates
-- Modify date: 26 Aug 2016 - Changed for new Project/parameter build
-- Modify date: 01 Mar 2017 - Added parameters for 'Template Group' and 'Protection Level'
-- Description:	Builds the full BIML for a SSDT Project
--
-- Sample Execute Commands: 
/*
EXEC [biml].[Build BIML Utility] 'Standard', 'EncryptSensitiveWithUserKey'
EXEC [biml].[Build BIML Utility] 'No Alerts', 'EncryptSensitiveWithUserKey'
EXEC [biml].[Build BIML Utility] 'No Framework', 'EncryptSensitiveWithUserKey'
EXEC [biml].[Build BIML Utility] 'Standard', 'DontSaveSensitive'
EXEC [biml].[Build BIML Utility] 'No Alerts', 'DontSaveSensitive'
EXEC [biml].[Build BIML Utility] 'No Framework', 'DontSaveSensitive'
*/
-- ================================================================================================

CREATE PROCEDURE [biml].[Build BIML Utility]
(
	    @template_group   AS NVARCHAR(32)
	  , @protection_level AS NVARCHAR(32)
)
AS
SET NOCOUNT ON;

DECLARE @SQL AS NVARCHAR(4000);

/* return values with initial settings */
DECLARE	@return_code AS INT = 1 /* error setting */
	  , @error_message AS NVARCHAR(2000) = '<not set>';

IF NOT EXISTS ( SELECT 1 FROM [biml].[template] WHERE [template_group] = @template_group )
	BEGIN
		SET @error_message = 'Invalid Template Group Provided'
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

IF @protection_level NOT IN ('EncryptSensitiveWithUserKey', 'DontSaveSensitive') -- hardcoded
	BEGIN
		SET @error_message = 'Invalid Protection Level Provided'
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

DELETE [biml].[build_log];

INSERT [biml].[build_log]
     ( [event_datetime]
     , [event_group]
     , [event_component] )
VALUES
     ( GETDATE()
	 , 'Build Start'
	 , 'Parameters - @template_group: ' + @template_group + ' -  @protection_level: ' + @protection_level);

EXEC [biml].[Build Parameters for Connections]  -- needed if a new 'connection' was added
EXEC [biml].[Update Merge Statements]
EXEC [biml].[Update Partition Statements]
EXEC [biml].[Update Switch Statements]


-- Build All Packages
SET @SQL = CASE @template_group
	WHEN 'Standard'  THEN 'EXEC [biml].[Build All Packages] @BaseTemplateName = ''Standard'', @RunAllTemplateName = ''Run All'', @GroupTemplateName = ''Group'';'
	WHEN 'No Alerts' THEN 'EXEC [biml].[Build All Packages] @BaseTemplateName = ''Standard No Alerts'', @RunAllTemplateName = ''Run All No Alerts'', @GroupTemplateName = ''Group No Alerts'';'
					 ELSE 'EXEC [biml].[Build All Packages] @BaseTemplateName = ''Standard No Framework'', @RunAllTemplateName = ''Run All No Framework'', @GroupTemplateName = ''Group No Framework'';'
	END;
EXEC sp_executesql @SQL


-- Build All Projects
SET @SQL = 'EXEC [biml].[Build All Projects] @template_group = ''' + @template_group + ''', @PackageProtectionOption = ''' + @protection_level + ''';'
EXEC sp_executesql @SQL

INSERT [biml].[build_log]
     ( [event_datetime]
     , [event_group]
     , [event_component] )
VALUES
     ( GETDATE()
	 , 'Build Finish'
	 , 'Success');

SET @return_code = 0
SET @error_message = ''

PRINT 'Build Complete!'

SELECT @return_code AS [return code], @error_message AS [error message]


GO
/****** Object:  StoredProcedure [biml].[Build Group and Run All Packages]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 25 May 2016
-- Modify date: 11 Jun 2016 - added 'log project complete' step
-- Modify date: 05 Aug 2016 - added new template logic
-- Modify date: 10 Aug 2016 - added new template logic - phase II
-- Modify date: 21 Aug 2016 - added pattern_name
-- Modify date: 27 Aug 2016 - added last build date and template
-- Modify date: 02 Mar 2017 - Added logging to [biml].[build_log]
-- Modify date: 31 May 2017 - Bug Fix - Appended 'project name' to Projecy Package Groups
-- Modify date: 03 Aug 2017 - Bug Fix - Appended 'project name' to Projecy Package Groups #2
--
-- Description:	Build Run All SSIS Package
-- ================================================================================================

CREATE PROCEDURE [biml].[Build Group and Run All Packages]
(
	    @BasePackageName AS NVARCHAR(128)
	  , @ProjectName AS NVARCHAR(128)
	  , @UseTemplateRunAll AS NVARCHAR(32) = 'Run All'
	  , @UseTemplateGroup AS NVARCHAR(32) = 'Group'
)
AS
BEGIN

	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build Group and Run All Packages'
		 , 'Start');

    DECLARE @PackageName AS NVARCHAR(128)
		  , @ProjectID AS INT
		  , @ExecutePackage AS NVARCHAR(MAX)
		  , @ExecutePackage_XML AS XML
		  , @Package AS NVARCHAR(MAX)
		  , @Package_XML AS XML
		  , @SequenceNumber INT
		  , @RowTest INT;


	SELECT @ProjectID = [project_id]
	  FROM [biml].[project]
	 WHERE [project_name] = @ProjectName


---------------------------------------------------------------------
-- insert duplicate sequence_numbers into table project_package_group
---------------------------------------------------------------------

DELETE [biml].[project_package_group]

INSERT INTO [biml].[project_package_group]
           ([project_id]
           ,[sequence_number]
           ,[package_name])

 SELECT @ProjectID
	  , pp.[sequence_number]
	  , LEFT('Package Group ' + CAST(pp.[sequence_number] AS NVARCHAR) + ' for ' + @ProjectName, 128)
   FROM [biml].[package] p
   JOIN [biml].[project_package] pp
     ON pp.[package_name] = p.[package_name]
  WHERE pp.[project_id] = @ProjectID
    AND pp.[sequence_number] > -1
  GROUP BY pp.[sequence_number]
 HAVING COUNT(*) > 1


-----------------------------------------------------------
-- create package group for each duplicate sequence_number
-----------------------------------------------------------
DECLARE [pkg_cursor] CURSOR FOR  
SELECT [sequence_number]
	 , [package_name]
  FROM [biml].[project_package_group]

OPEN [pkg_cursor]   
FETCH NEXT FROM [pkg_cursor] INTO @SequenceNumber, @PackageName

WHILE @@FETCH_STATUS = 0   
BEGIN 

INSERT [biml].[build_log]
		( [event_datetime]
		, [event_group]
		, [event_component] )
VALUES
		( GETDATE()
		, 'Build Group and Run All Packages - From table: [biml].[project_package_group]'
		, '@PackageName: ' + @PackageName);

SET @ExecutePackage_XML = 
  ( SELECT 'Run ' + p.[package_name] AS '@Name'
		 , p.[package_name] + '.dtsx' AS 'ExternalProjectPackage/@Package'
      FROM [biml].[package] p
	  JOIN [biml].[project_package] pp
        ON pp.[package_name] = p.[package_name]
     WHERE pp.[project_id] = @ProjectID
	   AND pp.[sequence_number] = @SequenceNumber
  ORDER BY pp.[sequence_number]
   FOR XML PATH ('ExecutePackage'), root ('Tasks'), type )
  
	-- get template
	SELECT @Package_XML = [template_xml] FROM [biml].[template] WHERE [template_name] = @UseTemplateGroup
	SET @Package = CAST(@Package_XML AS NVARCHAR(MAX))
	SET @Package = REPLACE(@Package, 'ReplaceWithPackageName', @PackageName)
	SET @Package = REPLACE(@Package, 'ReplaceWithProjectName', @ProjectName)

	-- add ExecutePackageXML
	SET @ExecutePackage = CAST(@ExecutePackage_XML AS NVARCHAR(MAX))
	SET @Package = REPLACE(@Package, '<ReplaceWithPrimaryContainerContents/>', @ExecutePackage)


	INSERT [biml].[package]
         ( [package_name]
		 , [pattern_name]
         , [package_text]
         , [package_xml] 
         , [build_datetime] 
         , [build_template] 
		 )
	VALUES
		( @PackageName
		, 'Package Group'
		, @Package
		, @Package
		, GETDATE()
		, @UseTemplateGroup
		) ;

	FETCH NEXT FROM [pkg_cursor] INTO @SequenceNumber, @PackageName
END;  

CLOSE [pkg_cursor]; 
DEALLOCATE [pkg_cursor];


-----------------------------------------------------------
-- create 'Run All' package 
-----------------------------------------------------------
SET @PackageName = @BasePackageName + ' - ' + @ProjectName;


INSERT [biml].[build_log]
		( [event_datetime]
		, [event_group]
		, [event_component] )
VALUES
		( GETDATE()
		, 'Build Group and Run All Packages - Create Run All package'
		, '@PackageName: ' + @PackageName);

-- union project package groups
DECLARE @ProjectPackageGroup TABLE (
	[project_id] [int] NOT NULL,
	[sequence_number] [int] NOT NULL,
	[package_name] [nvarchar](128) NOT NULL)

INSERT @ProjectPackageGroup
SELECT pp.[project_id]
     , pp.[sequence_number]
     , pp.[package_name]
  FROM [biml].[package] p
  JOIN [biml].[project_package] pp
    ON pp.[package_name] = p.[package_name]
  LEFT JOIN [biml].[project_package_group] pg
	ON pg.[sequence_number] = pp.[sequence_number]
 WHERE pp.[project_id] = @ProjectID
   AND pp.[sequence_number] > -1
   AND pg.[sequence_number] IS NULL
 UNION
SELECT @ProjectID
	 , [sequence_number]
	  , LEFT('Package Group ' + CAST([sequence_number] AS NVARCHAR) + ' for ' + @ProjectName, 128)
  FROM [biml].[project_package_group]


--------------------------------------------------------------------------------------------------------------
SELECT @RowTest = COUNT(*) from @ProjectPackageGroup
IF @RowTest = 0
	BEGIN
		PRINT 'Warning: Skipped creating RUN ALL package for a project since no [biml].[project_package] rows are sequenced for Project#: ' + CAST(@ProjectID AS NVARCHAR)

		INSERT [biml].[build_log]
			( [event_datetime]
			, [event_group]
			, [event_component] )
		VALUES
			( GETDATE()
			, 'Build Group and Run All Packages - Create Run All package'
			, 'Warning: Skipped creating RUN ALL package for a project since no [biml].[project_package] rows are sequenced for Project#: ' + CAST(@ProjectID AS NVARCHAR))

		RETURN
	END
--------------------------------------------------------------------------------------------------------------


	SET @ExecutePackage_XML = 
	  ( SELECT 'Run ' + pp.[package_name] AS '@Name'
			 , pp.[package_name] + '.dtsx' AS 'ExternalProjectPackage/@Package'
		  FROM @ProjectPackageGroup pp
		 WHERE pp.[project_id] = @ProjectID
	  ORDER BY pp.[sequence_number]
	   FOR XML PATH ('ExecutePackage'), root ('Tasks'), type )

	-- get template
	SELECT @Package_XML = [template_xml] FROM [biml].[template] WHERE [template_name] = @UseTemplateRunAll
	SET @Package = CAST(@Package_XML AS NVARCHAR(MAX))
	SET @Package = REPLACE(@Package, 'ReplaceWithPackageName', @PackageName)
	SET @Package = REPLACE(@Package, 'ReplaceWithProjectName', @ProjectName)


	-- add ExecutePackageXML
	SET @ExecutePackage = CAST(@ExecutePackage_XML AS NVARCHAR(MAX))
	SET @Package = REPLACE(@Package, '<ReplaceWithPrimaryContainerContents/>', @ExecutePackage)

	INSERT [biml].[package]
         ( [package_name]
		 , [pattern_name]
         , [package_text]
         , [package_xml] 
         , [build_datetime] 
         , [build_template] 
		 )
	VALUES
		( @PackageName
		, 'Run All'
		, @Package
		, @Package
		, GETDATE()
		, @UseTemplateRunAll
		) ;

	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build Group and Run All Packages'
		 , 'Finish');

END


GO
/****** Object:  StoredProcedure [biml].[Build Packages (CT Replication)]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 18 Jan 2017
-- Modify date: 02 Mar 2017 - Added logging to [biml].[build_log]
-- Modify date: 20 Apr 2017 - Added 'Incomplete Build' option on package insert
-- Modify date: 07 Aug 2017 - Change CT Version to 'User' variables set to 'project parameters'
-- Modify date: 15 Aug 2017 - Bug fix for [last_sync_version]
--
-- Description:	Build Change Tracking (CT) Replication
--
-- ================================================================================================

CREATE PROCEDURE [biml].[Build Packages (CT Replication)]
(
	    @package_qualifier   AS NVARCHAR(64)
	  , @SrcConnection       AS NVARCHAR(64)
	  , @SrcDeletesQueryExp  AS NVARCHAR(MAX)
	  , @SrcInsertsQueryExp  AS NVARCHAR(MAX)
	  , @DstConnection       AS NVARCHAR(64)
	  , @DstSyncQuery        AS NVARCHAR(MAX)
	  , @SyncSchema          AS NVARCHAR(128)
	  , @TargetTable         AS NVARCHAR(128)
	  , @UseTemplate	     AS NVARCHAR(32) = 'No Framework'
)
AS
BEGIN

	DECLARE @PatternName AS NVARCHAR(32)  = 'CT Replication'
    DECLARE @PackageName AS NVARCHAR(256) = @PatternName + ' - ' + @package_qualifier + ' - ' + @TargetTable; 

	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build Packages (CT Replication)'
		 , '@PackageName: ' + @PackageName);
   
	DECLARE @Package AS NVARCHAR(MAX)
		  , @Package_XML AS XML
          , @Container AS NVARCHAR(MAX)
          , @PackageParameters AS NVARCHAR(MAX)
          , @CustomVariables AS NVARCHAR(MAX);
	
	SET @CustomVariables = N'
			<Variables>
				<Variable DataType="Int64" IncludeInDebugDump="Exclude" Name="CT_StartFromTableVersion">0</Variable>
				<Variable EvaluateAsExpression="true" DataType="String" IncludeInDebugDump="Exclude" Name="CT_Repl_Src_Server">@[$Project::CT_Replication_SRC_Server]</Variable>
				<Variable EvaluateAsExpression="true" DataType="String" IncludeInDebugDump="Exclude" Name="CT_Repl_Src_Database">@[$Project::CT_Replication_SRC_Database]</Variable>
				<Variable EvaluateAsExpression="true" DataType="String" IncludeInDebugDump="Exclude" Name="CT_Repl_Dst_Server">@[$Project::CT_Replication_DST_Server]</Variable>
				<Variable EvaluateAsExpression="true" DataType="String" IncludeInDebugDump="Exclude" Name="CT_Repl_Dst_Database">@[$Project::CT_Replication_DST_Database]</Variable>
				<Variable EvaluateAsExpression="true" DataType="String" IncludeInDebugDump="Exclude" Name="DELETES_Select_SQL">' + @SrcDeletesQueryExp + '</Variable>
				<Variable EvaluateAsExpression="true" DataType="String" IncludeInDebugDump="Exclude" Name="INSERTS_Select_SQL">' + @SrcInsertsQueryExp + '</Variable>'

	-- get template
	SELECT @Package_XML = [template_xml] FROM [biml].[template] WHERE [template_name] = @UseTemplate
	SET @Package = CAST(@Package_XML AS NVARCHAR(MAX))
	SET @Package = REPLACE(@Package, 'ReplaceWithPackageName', @PackageName)
	SET @Package = REPLACE(@Package, '<Container Name="Sequence Container" ConstraintMode="Linear">', '<Container Name="Sequence Container" ConstraintMode="Parallel">')


	-- Container Name="Sequence Container" ConstraintMode="Linear"

	SET @Container = N'
			<Tasks>
				<ExecuteSQL Name="Get Starting CT Version" ConnectionName="SSIS_Data_CT" ResultSet="SingleRow">
					<DirectInput>
							WITH [base] AS
							(	 
								  SELECT [last_sync_version]
									FROM [dbo].[change_tracking_last_sync] sync
								   WHERE [src_server_name] = ?
									 AND [src_database_name] = ?
									 AND [dst_server_name] = ?
									 AND [dst_database_name] = ?
							UNION
								SELECT 0 AS [last_sync_version]  
							)
							SELECT MAX([last_sync_version]) AS [last_sync_version]
							 FROM [base]					
					</DirectInput>
					<Results>
						<Result Name="last_sync_version" VariableName="User.CT_StartFromTableVersion" />
					</Results>
					<Parameters>
						<Parameter Name="0" VariableName="User.CT_Repl_Src_Server"   DataType="String" Length="128" />
						<Parameter Name="1" VariableName="User.CT_Repl_Src_Database" DataType="String" Length="128" />
						<Parameter Name="2" VariableName="User.CT_Repl_Dst_Server"   DataType="String" Length="128" />
						<Parameter Name="3" VariableName="User.CT_Repl_Dst_Database" DataType="String" Length="128" />
					</Parameters>
					<PrecedenceConstraints>
						<Inputs>
							<Input OutputPathName="TRUNCATE Sync Tables.Output" />
						</Inputs>
					</PrecedenceConstraints>
				</ExecuteSQL>
				<Dataflow Name="Data Flow DELETES">
					<Transformations>
						<OleDbDestination Name="OLE DB Destination" ConnectionName="' + @DstConnection + '">
							<InputPath OutputPathName="OLE DB Source.Output" />
							<ExternalTableOutput Table="[' + @SyncSchema + '].[' + @TargetTable + '_DELETE]" />
						</OleDbDestination>
						<OleDbSource Name="OLE DB Source" ConnectionName="' + @SrcConnection + '">
							<VariableInput VariableName="User.DELETES_Select_SQL" />
						</OleDbSource>
					</Transformations>
					<PrecedenceConstraints>
						<Inputs>
							<Input OutputPathName="Get Starting CT Version.Output" />
						</Inputs>
					</PrecedenceConstraints>
				</Dataflow>
				<Dataflow Name="Data Flow INSERTS">
					<Transformations>
						<OleDbDestination Name="OLE DB Destination" ConnectionName="' + @DstConnection + '">
							<InputPath OutputPathName="OLE DB Source.Output" />
							<ExternalTableOutput Table="[' + @SyncSchema + '].[' + @TargetTable + '_INSERT]" />
						</OleDbDestination>
						<OleDbSource Name="OLE DB Source" ConnectionName="' + @SrcConnection + '">
							<VariableInput VariableName="User.INSERTS_Select_SQL" />
						</OleDbSource>
					</Transformations>
					<PrecedenceConstraints>
						<Inputs>
							<Input OutputPathName="Data Flow DELETES.Output" />
						</Inputs>
					</PrecedenceConstraints>
				</Dataflow>
				<ExecuteSQL Name="SYNC Target Table" ConnectionName="' + @DstConnection + '" ResultSet="SingleRow">
					<DirectInput>'
					+ @DstSyncQuery +
					'
					</DirectInput>
					<Results>
						<Result Name="row_count" VariableName="User.row_count" />
					</Results>
					<PrecedenceConstraints>
						<Inputs>
							<Input OutputPathName="Data Flow INSERTS.Output" />
						</Inputs>
					</PrecedenceConstraints>
				</ExecuteSQL>
				<ExecuteSQL Name="TRUNCATE Sync Tables" ConnectionName="' + @DstConnection + '">
					<DirectInput>
						TRUNCATE TABLE [' + @SyncSchema + '].[' + @TargetTable + '_DELETE];
						TRUNCATE TABLE [' + @SyncSchema + '].[' + @TargetTable + '_INSERT];
					</DirectInput>
				</ExecuteSQL>
			</Tasks>'

	-- add custom variables
	SET @Package = REPLACE(@Package, '<Variables>', @CustomVariables)

	-- add container contents
	SET @Package = REPLACE(@Package, '<ReplaceWithPrimaryContainerContents/>', @Container)

	SET @Package_XML = @Package

	
	-- delete in case package already exists
	DELETE [biml].[package]
	 WHERE [package_name] = @PackageName

	-- insert package 	
	INSERT [biml].[package]
         ( [package_name]
		 , [pattern_name]
         , [package_text]
         , [package_xml] 
         , [build_datetime] 
         , [build_template] 
		 )
    VALUES
         ( @PackageName
		 , @PatternName
		 , ISNULL(@Package, 'Incomplete Build')
		 , ISNULL(@Package_XML,'<Err><IncompleteBuild/></Err>')
		 , GETDATE()
		 , @UseTemplate
		 );

END



GO
/****** Object:  StoredProcedure [biml].[Build Packages (Data Flow)]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 23 May 2016
-- Modify date: 11 Jun 2016 - added truncate and sequence container
-- Modify date: 08 Aug 2016 - added template parameter
-- Modify date: 21 Aug 2016 - added pattern_name
-- Modify date: 27 Aug 2016 - added last build date and template
-- Modify date: 12 Sep 2016 - added KeepIdentity option
-- Modify date: 02 Mar 2017 - Added logging to [biml].[build_log]
-- Modify date: 03 Apr 2017 - Added Ado.Net connection logic
-- Modify date: 10 Apr 2017 - Added Flat File connection logic
-- Modify date: 17 Apr 2017 - Added @IsExpression
-- Modify date: 20 Apr 2017 - Added 'Incomplete Build' option on package insert
-- Modify date: 06 May 2017 - ado.net 'expression option' bug fix
-- Modify date: 27 May 2017 - ado.net 'expression option' bug fix 2
-- Modify date: 02 Nov 2017 - 'KeepIdentity' attribute removed if 'false' (can't use attribute for AdoNetDestination)
-- Modify date: 02 Nov 2017 - Changed SQL embedded into BIML to use " or &quot; (double quotes) instead of [] (brackets)
--
-- Description:	Build standard Data Flow package, with optional Truncate
--
-- Sample Execute Command: 
/*
DECLARE @RC int;
EXEC @RC = [biml].[Build Packages (Data Flow)] 
     @SrcConnection = ''
   , @SrcQuery = ''
   , @IsExpression = ''
   , @SrcQueryDirect  = ''
   , @package_qualifier  = ''
   , @DstConnection  = ''
   , @DstSchema  = ''
   , @DstTable  = ''
   , @DstTruncate  = ''
   , @KeepIdentity  = '';
SELECT @RC AS [return_code];
*/
-- ============================================================================================================================

CREATE PROCEDURE [biml].[Build Packages (Data Flow)]
(
	    @SrcConnection     AS NVARCHAR(64)
	  , @SrcQuery          AS NVARCHAR(MAX)
	  , @IsExpression	   AS NVARCHAR(1)
	  , @SrcQueryDirect    AS NVARCHAR(MAX)
	  , @package_qualifier AS NVARCHAR(64)
	  , @DstConnection     AS NVARCHAR(64)
	  , @DstSchema         AS NVARCHAR(128)
	  , @DstTable          AS NVARCHAR(128)
	  , @DstTruncate       AS NVARCHAR(1)
	  , @KeepIdentity      AS NVARCHAR(1)
	  , @UseTemplate	   AS NVARCHAR(32) = 'No Framework'
)
AS
BEGIN

	DECLARE @PatternName AS NVARCHAR(32)  = 'Data Flow'
    DECLARE @PackageName AS NVARCHAR(256) 
	SET @PackageName = (('Data Flow - '+@package_qualifier)+case when @DstTable='' then '' else ((' - '+@DstSchema)+'.')+@DstTable end)



	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build Packages (Data Flow)'
		 , '@PackageName: ' + @PackageName);


	-- is destination flat file connection?
	DECLARE @DstConnType AS NVARCHAR(32) = 'database'
	IF EXISTS (SELECT 1 FROM [biml].[flatfile_connection] WHERE [connection_name] = @DstConnection)
		BEGIN
			SET @DstConnType = 'flat file'
			SET @PackageName = @PatternName + ' - ' + @package_qualifier;
		END

		    
   	DECLARE @IdentityInsertAttribute AS NVARCHAR(30) = ''
	IF @KeepIdentity = 'Y' AND @DstConnType = 'database'
		SET @IdentityInsertAttribute = 'KeepIdentity="true"'

	DECLARE @Package AS NVARCHAR(MAX)
		  , @Package_XML AS XML
          , @Container AS NVARCHAR(MAX);

	DECLARE @OptionalTruncateTask AS NVARCHAR(MAX);

	IF @DstTruncate = 'Y' AND @DstConnType = 'database'
		SET @OptionalTruncateTask = '
		    <ExecuteSQL Name="Truncate" ConnectionName="' + @DstConnection + '">
               <DirectInput>TRUNCATE TABLE "' + @DstSchema + '"."' + @DstTable + '"</DirectInput>
            </ExecuteSQL>'
	ELSE
		SET @OptionalTruncateTask = ''

	-- Dataflow Input logic
	DECLARE @CustomVariables AS NVARCHAR(MAX) = '<Variables>';

	DECLARE @DataflowInput AS NVARCHAR(MAX)
	      , @OptionalAdoNetSourceExpr AS NVARCHAR(MAX) = '';

	SET @DataflowInput = '<DirectInput>' + @SrcQuery + '</DirectInput>'

	DECLARE @connection_type AS NVARCHAR(32)
	SET @connection_type = (SELECT TOP 1 [connection_type] FROM [biml].[vw_project_connection] WHERE [connection_name] = @SrcConnection)

	IF @IsExpression = 'Y' AND @connection_type = 'AdoNet'
		BEGIN
			SET @OptionalAdoNetSourceExpr = '
				<Expressions>
					<Expression ExternalProperty="[Source].[SqlCommand]">@[User::source_select]</Expression>
				</Expressions>'
			SET @DataflowInput = '<DirectInput>' + @SrcQueryDirect + '</DirectInput>'
		END
	ELSE
		BEGIN
			IF @IsExpression = 'Y'
				SET @DataflowInput = '<VariableInput VariableName="User.source_select" />'
		END

	IF @IsExpression = 'Y'
		SET @CustomVariables = N'
			<Variables>
				<Variable EvaluateAsExpression="true" DataType="String" IncludeInDebugDump="Exclude" Name="source_select">' + @SrcQuery + '</Variable>'


	-- get template
	SELECT @Package_XML = [template_xml] FROM [biml].[template] WHERE [template_name] = @UseTemplate
	SET @Package = CAST(@Package_XML AS NVARCHAR(MAX))
	SET @Package = REPLACE(@Package, 'ReplaceWithPackageName', @PackageName)

--print @PackageName

  IF @DstConnType = 'database'
	SET @Container = N'
		  <Tasks>
			' + @OptionalTruncateTask + '
			<Dataflow Name="Populate Table">' + @OptionalAdoNetSourceExpr + '
				<Transformations>
					<OleDbSource Name="Source" ConnectionName="' + @SrcConnection + '">' + @DataflowInput + '
					</OleDbSource>
					<RowCount Name="Row Count" VariableName="User.row_count">
                        <InputPath OutputPathName="Source.Output" />
					</RowCount>
					<OleDbDestination Name="Destination" ConnectionName="' + @DstConnection + '" ' + @IdentityInsertAttribute + '>
						<InputPath OutputPathName="Row Count.Output" SsisName="Destination Input" />
						<ExternalTableOutput Table="&quot;' + @DstSchema + '&quot;.&quot;' + @DstTable + '&quot;" />
					</OleDbDestination>
				</Transformations>
			</Dataflow>
		    </Tasks>'

  IF @DstConnType = 'flat file'
	SET @Container = N'
		  <Tasks>
			' + @OptionalTruncateTask + '
			<Dataflow Name="Populate Table">' + @OptionalAdoNetSourceExpr + '
				<Transformations>
					<OleDbSource Name="Source" ConnectionName="' + @SrcConnection + '">' + @DataflowInput + '
					</OleDbSource>
					<RowCount Name="Row Count" VariableName="User.row_count">
                        <InputPath OutputPathName="Source.Output" />
					</RowCount>
					<FlatFileDestination Name="Flat File Destination" LocaleId="None" ConnectionName="' + @DstConnection + '">
						<InputPath OutputPathName="Row Count.Output" SsisName="Destination Input" />
						<Header></Header>
					</FlatFileDestination>
				</Transformations>
			</Dataflow>
		    </Tasks>'


	-- in the event of a flat file source
	SET @Container = REPLACE(@Container, '<DirectInput></DirectInput>', '')

	-- replace source connection type if necesary
	IF @connection_type != 'OleDb'
		BEGIN
			SET @Container = REPLACE(@Container, 'OleDbSource', @connection_type + 'Source')
		END

	-- replace destination connection type if necesary
	SET @connection_type = (SELECT TOP 1 [connection_type] FROM [biml].[vw_project_connection] WHERE [connection_name] = @DstConnection)
	IF @connection_type != 'OleDb'
		BEGIN
			SET @Container = REPLACE(@Container, 'OleDbDestination', @connection_type + 'Destination')
		END

	-- add custom variables
	SET @Package = REPLACE(@Package, '<Variables>', @CustomVariables)

	-- add container contents
	SET @Package = REPLACE(@Package, '<ReplaceWithPrimaryContainerContents/>', @Container)

	SET @Package_XML = @Package
	

	-- delete in case package already exists
	DELETE [biml].[package]
	 WHERE [package_name] = @PackageName

	-- insert package 	
	INSERT [biml].[package]
         ( [package_name]
		 , [pattern_name]
         , [package_text]
         , [package_xml] 
         , [build_datetime] 
         , [build_template] 
		 )
    VALUES
         ( @PackageName
		 , @PatternName
		 , ISNULL(@Package, 'Incomplete Build')
		 , ISNULL(@Package_XML,'<Err><IncompleteBuild/></Err>')
		 , GETDATE()
		 , @UseTemplate
		 );
END

GO
/****** Object:  StoredProcedure [biml].[Build Packages (Data Flow) AS400]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 23 May 2016
-- Modify date: 11 Jun 2016 - added truncate and sequence container
-- Modify date: 08 Aug 2016 - added template parameter
-- Modify date: 21 Aug 2016 - added pattern_name
-- Modify date: 27 Aug 2016 - added last build date and template
-- Modify date: 12 Sep 2016 - added KeepIdentity option
-- Modify date: 02 Mar 2017 - Added logging to [biml].[build_log]
-- Modify date: 03 Apr 2017 - Added Ado.Net connection logic
-- Modify date: 10 Apr 2017 - Added Flat File connection logic
-- Modify date: 17 Apr 2017 - Added @IsExpression
-- Modify date: 20 Apr 2017 - Added 'Incomplete Build' option on package insert
-- Modify date: 06 May 2017 - ado.net 'expression option' bug fix
-- Modify date: 27 May 2017 - ado.net 'expression option' bug fix 2
-- Modify date: 02 Nov 2017 - 'KeepIdentity' attribute removed if 'false' (can't use attribute for AdoNetDestination)
-- Modify date: 02 Nov 2017 - Changed SQL embedded into BIML to use " or &quot; (double quotes) instead of [] (brackets)
-- Modify date: 12 Mar 2018 - For AS400 (Belcan) - added: <ErrorHandling ErrorRowDisposition="FailComponent" TruncationRowDisposition="IgnoreFailure" />
--
-- Description:	Build standard Data Flow package, with optional Truncate
--
-- Sample Execute Command: 
/*
DECLARE @RC int;
EXEC @RC = [biml].[Build Packages (Data Flow)] 
     @SrcConnection = ''
   , @SrcQuery = ''
   , @IsExpression = ''
   , @SrcQueryDirect  = ''
   , @package_qualifier  = ''
   , @DstConnection  = ''
   , @DstSchema  = ''
   , @DstTable  = ''
   , @DstTruncate  = ''
   , @KeepIdentity  = '';
SELECT @RC AS [return_code];
*/
-- ============================================================================================================================

CREATE PROCEDURE [biml].[Build Packages (Data Flow) AS400]
(
	    @SrcConnection     AS NVARCHAR(64)
	  , @SrcQuery          AS NVARCHAR(MAX)
	  , @IsExpression	   AS NVARCHAR(1)
	  , @SrcQueryDirect    AS NVARCHAR(MAX)
	  , @package_qualifier AS NVARCHAR(64)
	  , @DstConnection     AS NVARCHAR(64)
	  , @DstSchema         AS NVARCHAR(128)
	  , @DstTable          AS NVARCHAR(128)
	  , @DstTruncate       AS NVARCHAR(1)
	  , @KeepIdentity      AS NVARCHAR(1)
	  , @UseTemplate	   AS NVARCHAR(32) = 'No Framework'
)
AS
BEGIN

	DECLARE @PatternName AS NVARCHAR(32)  = 'Data Flow'
    DECLARE @PackageName AS NVARCHAR(256) 
	SET @PackageName = (('Data Flow - '+@package_qualifier)+case when @DstTable='' then '' else ((' - '+@DstSchema)+'.')+@DstTable end)



	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build Packages (Data Flow)'
		 , '@PackageName: ' + @PackageName);


	-- is destination flat file connection?
	DECLARE @DstConnType AS NVARCHAR(32) = 'database'
	IF EXISTS (SELECT 1 FROM [biml].[flatfile_connection] WHERE [connection_name] = @DstConnection)
		BEGIN
			SET @DstConnType = 'flat file'
			SET @PackageName = @PatternName + ' - ' + @package_qualifier;
		END

		    
   	DECLARE @IdentityInsertAttribute AS NVARCHAR(30) = ''
	IF @KeepIdentity = 'Y' AND @DstConnType = 'database'
		SET @IdentityInsertAttribute = 'KeepIdentity="true"'

	DECLARE @Package AS NVARCHAR(MAX)
		  , @Package_XML AS XML
          , @Container AS NVARCHAR(MAX);

	DECLARE @OptionalTruncateTask AS NVARCHAR(MAX);

	IF @DstTruncate = 'Y' AND @DstConnType = 'database'
		SET @OptionalTruncateTask = '
		    <ExecuteSQL Name="Truncate" ConnectionName="' + @DstConnection + '">
               <DirectInput>TRUNCATE TABLE "' + @DstSchema + '"."' + @DstTable + '"</DirectInput>
            </ExecuteSQL>'
	ELSE
		SET @OptionalTruncateTask = ''

	-- Dataflow Input logic
	DECLARE @CustomVariables AS NVARCHAR(MAX) = '<Variables>';

	DECLARE @DataflowInput AS NVARCHAR(MAX)
	      , @OptionalAdoNetSourceExpr AS NVARCHAR(MAX) = '';


	-- PATCH for AS400
	DECLARE @ErrorHandling NVARCHAR(4000) = ''
	IF @SrcConnection = 'AS400_JDE'
		SET @ErrorHandling = '
			<ErrorHandling ErrorRowDisposition="FailComponent" TruncationRowDisposition="IgnoreFailure" />'


	SET @DataflowInput = '<DirectInput>' + @SrcQuery + '</DirectInput>' + @ErrorHandling

	DECLARE @connection_type AS NVARCHAR(32)
	SET @connection_type = (SELECT TOP 1 [connection_type] FROM [biml].[vw_project_connection] WHERE [connection_name] = @SrcConnection)

	IF @IsExpression = 'Y' AND @connection_type = 'AdoNet'
		BEGIN
			SET @OptionalAdoNetSourceExpr = '
				<Expressions>
					<Expression ExternalProperty="[Source].[SqlCommand]">@[User::source_select]</Expression>
				</Expressions>'
			SET @DataflowInput = '<DirectInput>' + @SrcQueryDirect + '</DirectInput>' + @ErrorHandling -- 12 Mar
		END
	ELSE
		BEGIN
			IF @IsExpression = 'Y'
				SET @DataflowInput = '<VariableInput VariableName="User.source_select" />' + @ErrorHandling -- 12 Mar
		END

	IF @IsExpression = 'Y'
		SET @CustomVariables = N'
			<Variables>
				<Variable EvaluateAsExpression="true" DataType="String" IncludeInDebugDump="Exclude" Name="source_select">' + @SrcQuery + '</Variable>'


	-- get template
	SELECT @Package_XML = [template_xml] FROM [biml].[template] WHERE [template_name] = @UseTemplate
	SET @Package = CAST(@Package_XML AS NVARCHAR(MAX))
	SET @Package = REPLACE(@Package, 'ReplaceWithPackageName', @PackageName)

--print @PackageName

  IF @DstConnType = 'database'
	SET @Container = N'
		  <Tasks>
			' + @OptionalTruncateTask + '
			<Dataflow Name="Populate Table">' + @OptionalAdoNetSourceExpr + '
				<Transformations>
					<OleDbSource Name="Source" ConnectionName="' + @SrcConnection + '">' + @DataflowInput + '
					</OleDbSource>
					<RowCount Name="Row Count" VariableName="User.row_count">
                        <InputPath OutputPathName="Source.Output" />
					</RowCount>
					<OleDbDestination Name="Destination" ConnectionName="' + @DstConnection + '" ' + @IdentityInsertAttribute + '>
						<InputPath OutputPathName="Row Count.Output" SsisName="Destination Input" />
						<ExternalTableOutput Table="&quot;' + @DstSchema + '&quot;.&quot;' + @DstTable + '&quot;" />
					</OleDbDestination>
				</Transformations>
			</Dataflow>
		    </Tasks>'

  IF @DstConnType = 'flat file'
	SET @Container = N'
		  <Tasks>
			' + @OptionalTruncateTask + '
			<Dataflow Name="Populate Table">' + @OptionalAdoNetSourceExpr + '
				<Transformations>
					<OleDbSource Name="Source" ConnectionName="' + @SrcConnection + '">' + @DataflowInput + '
					</OleDbSource>
					<RowCount Name="Row Count" VariableName="User.row_count">
                        <InputPath OutputPathName="Source.Output" />
					</RowCount>
					<FlatFileDestination Name="Flat File Destination" LocaleId="None" ConnectionName="' + @DstConnection + '">
						<InputPath OutputPathName="Row Count.Output" SsisName="Destination Input" />
						<Header></Header>
					</FlatFileDestination>
				</Transformations>
			</Dataflow>
		    </Tasks>'


	-- in the event of a flat file source
	SET @Container = REPLACE(@Container, '<DirectInput></DirectInput>', '')

	-- replace source connection type if necesary
	IF @connection_type != 'OleDb'
		BEGIN
			SET @Container = REPLACE(@Container, 'OleDbSource', @connection_type + 'Source')
		END

	-- replace destination connection type if necesary
	SET @connection_type = (SELECT TOP 1 [connection_type] FROM [biml].[vw_project_connection] WHERE [connection_name] = @DstConnection)
	IF @connection_type != 'OleDb'
		BEGIN
			SET @Container = REPLACE(@Container, 'OleDbDestination', @connection_type + 'Destination')
		END

	-- add custom variables
	SET @Package = REPLACE(@Package, '<Variables>', @CustomVariables)

	-- add container contents
	SET @Package = REPLACE(@Package, '<ReplaceWithPrimaryContainerContents/>', @Container)

	SET @Package_XML = @Package
	

	-- delete in case package already exists
	DELETE [biml].[package]
	 WHERE [package_name] = @PackageName

	-- insert package 	
	INSERT [biml].[package]
         ( [package_name]
		 , [pattern_name]
         , [package_text]
         , [package_xml] 
         , [build_datetime] 
         , [build_template] 
		 )
    VALUES
         ( @PackageName
		 , @PatternName
		 , ISNULL(@Package, 'Incomplete Build')
		 , ISNULL(@Package_XML,'<Err><IncompleteBuild/></Err>')
		 , GETDATE()
		 , @UseTemplate
		 );
END

GO
/****** Object:  StoredProcedure [biml].[Build Packages (Execute Process)]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =======================================================================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
--
-- Create date: 13 Apr 2017
-- Modify date: 20 Apr 2017 - Added 'Incomplete Build' option on package insert
-- Modify date: 13 May 2017 - Changed @CustomVariables to be table driven and optionally stored in SSIS_Data
-- Modify date: 14 May 2017 - Bug Fix: @CustomVariables 
-- Modify date: 15 May 2017 - Restricted SSIS_Data placed @CustomVariables to 'String'
-- Modify date: 17 Aug 2017 - Changed Parameter 1 to -1 length
--
-- Description:	Execute Process Package
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Build Packages (Execute Process)] 'Upload airlines CSV', '"snowsql.exe"', '"-f C:\\snow_scripts\\airlines.txt"', '"-f C:\\snow_scripts"', 'Y'
*/
-- =======================================================================================================================================================

CREATE PROCEDURE [biml].[Build Packages (Execute Process)]
(
	    @package_qualifier  AS NVARCHAR(64)
	  , @executable			AS NVARCHAR(1024)
	  , @arguments			AS NVARCHAR(MAX)
	  , @working_dir		AS NVARCHAR(2048)
	  , @place_values_in_SSIS_Data AS NVARCHAR(1)
	  , @UseTemplate	    AS NVARCHAR(32) = 'Standard No Framework'
)
AS
BEGIN

	DECLARE @PatternName AS NVARCHAR(32)  = 'Execute Process'
    DECLARE @PackageName AS NVARCHAR(256) = @PatternName + ' - ' + @package_qualifier; 

	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build Packages (Execute Process)'
		 , '@PackageName: ' + @PackageName);

	DECLARE @Package AS NVARCHAR(MAX)
		  , @Package_XML AS XML
          , @Container AS NVARCHAR(MAX)
		  , @CustomVariables_XML AS XML
          , @CustomVariables AS NVARCHAR(MAX);


WITH [all_var] AS
(
		SELECT [EvaluateAsExpression] AS 'Variable/@EvaluateAsExpression'
			 , [DataType] AS 'Variable/@DataType'
			 , 'Exclude' AS 'Variable/@IncludeInDebugDump'
			 , [Name] AS 'Variable/@Name'
			 , [variable_value] AS 'Variable'
		  FROM [biml].[package_config (Execute Process) variable]
		 WHERE [package_qualifier] = @package_qualifier
	  UNION
		SELECT 'true' AS 'Variable/@EvaluateAsExpression'
			 , 'String' AS 'Variable/@DataType'
			 , 'Exclude' AS 'Variable/@IncludeInDebugDump'
			 , 'arguments' AS 'Variable/@Name'
			 , @arguments AS 'Variable'
	  UNION
		SELECT 'true' AS 'Variable/@EvaluateAsExpression'
			 , 'String' AS 'Variable/@DataType'
			 , 'Exclude' AS 'Variable/@IncludeInDebugDump'
			 , 'executable' AS 'Variable/@Name'
			 , @executable AS 'Variable'
	  UNION
		SELECT 'true' AS 'Variable/@EvaluateAsExpression'
			 , 'String' AS 'Variable/@DataType'
			 , 'Exclude' AS 'Variable/@IncludeInDebugDump'
			 , 'working_dir' AS 'Variable/@Name'
			 , @working_dir AS 'Variable'
)
	SELECT @CustomVariables_XML = 
	  (
	    SELECT * FROM [all_var]
	   FOR XML PATH (''), root ('Variables'), type
	  );

	SET @CustomVariables = CAST(@CustomVariables_XML AS NVARCHAR(MAX))
	SET @CustomVariables = REPLACE(@CustomVariables, '</Variables>', '')


	----------------------------------------------------------------------
	-- build 'Place Values' in SSIS_Data Tasks (in case it's needed)
	----------------------------------------------------------------------
	DECLARE @OptionalPlaceValuesTasks AS NVARCHAR(MAX) = ''
	      , @PlaceValuesTask AS NVARCHAR(MAX)
	      , @PlaceValuesVariableTemplate AS NVARCHAR(MAX);

		SET @PlaceValuesVariableTemplate = '
		    <ExecuteSQL Name="Place Variable ' + '<ReplaceWithValueKey/>' + ' in SSIS_Data" ConnectionName="SSIS_Data">
                <DirectInput>EXEC [dbo].[Put Value] ?, ''@[User::' + '<ReplaceWithValueKey/>' + ']'', ?</DirectInput>
                <Parameters>
                    <Parameter Name="0" VariableName="System.ExecutionInstanceGUID" DataType="String" Length="128" />
                    <Parameter Name="1" VariableName="User.' + '<ReplaceWithValueKey/>' + '" DataType="String" Length="-1" />
				</Parameters>
            </ExecuteSQL>'


	DECLARE @VariableName AS NVARCHAR(128)
	DECLARE [proc_cursor_var] CURSOR FOR  
	SELECT [Name]
	  FROM [biml].[package_config (Execute Process) variable]
	 WHERE [DataType] = 'String'
	   AND [package_qualifier] = @package_qualifier

	OPEN [proc_cursor_var]   
	FETCH NEXT FROM [proc_cursor_var] INTO @VariableName

	WHILE @@FETCH_STATUS = 0   
	BEGIN 
		SET @PlaceValuesTask = REPLACE(@PlaceValuesVariableTemplate, '<ReplaceWithValueKey/>', @VariableName)
		SET @OptionalPlaceValuesTasks = @OptionalPlaceValuesTasks + @PlaceValuesTask

		FETCH NEXT FROM [proc_cursor_var] INTO @VariableName
	END;  

	CLOSE [proc_cursor_var]; 
	DEALLOCATE [proc_cursor_var];

	SET @OptionalPlaceValuesTasks = @OptionalPlaceValuesTasks + '<ReplaceParameterPlaceValuesHere/>'

	IF @place_values_in_SSIS_Data = 'N'
		SET @OptionalPlaceValuesTasks = ''


	-- get template
	SELECT @Package_XML = [template_xml] FROM [biml].[template] WHERE [template_name] = @UseTemplate

	SET @Package = CAST(@Package_XML AS NVARCHAR(MAX))
	SET @Package = REPLACE(@Package, 'ReplaceWithPackageName', @PackageName)


	SET @Container = N'
		  <Tasks>' + @OptionalPlaceValuesTasks + '
			<ExecuteProcess Name="Execute Process" Arguments="" Executable="">
				<Expressions>
					<Expression ExternalProperty="Arguments">@[User::arguments]</Expression>
                    <Expression ExternalProperty="Executable">@[User::executable]</Expression>
                    <Expression ExternalProperty="WorkingDirectory">@[User::working_dir]</Expression>
				</Expressions>
			</ExecuteProcess>
		  </Tasks>'

	-- add custom variables
	SET @Package = REPLACE(@Package, '<Variables>', @CustomVariables)

	-- add container contents
	SET @Package = REPLACE(@Package, '<ReplaceWithPrimaryContainerContents/>', @Container)
	SET @Package_XML = @Package


	-- delete in case package already exists
	DELETE [biml].[package]
	 WHERE [package_name] = @PackageName

	-- insert package 	
	INSERT [biml].[package]
         ( [package_name]
		 , [pattern_name]
         , [package_text]
         , [package_xml] 
         , [build_datetime] 
         , [build_template] 
		 )
    VALUES
         ( @PackageName
		 , @PatternName
		 , ISNULL(@Package, 'Incomplete Build')
		 , ISNULL(@Package_XML,'<Err><IncompleteBuild/></Err>')
		 , GETDATE()
		 , @UseTemplate
		 );

END



GO
/****** Object:  StoredProcedure [biml].[Build Packages (Execute Script)]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 14 Apr 2017
-- Modify date: 20 Apr 2017 - Added 'Incomplete Build' option on package insert
-- Modify date: 05 May 2017 - Changed @CustomVariables to be table driven
-- Modify date: 17 Aug 2017 - Fixed bug with duplicate @CustomVariables
--
-- Description:	Execute Script Task
--
-- Sample Execute Command: 
/*	
*/
-- ================================================================================================

CREATE PROCEDURE [biml].[Build Packages (Execute Script)]
(
	    @connection_manager AS NVARCHAR(64)
	  , @script_name		AS NVARCHAR(128)
	  , @package_qualifier  AS NVARCHAR(64)
	  , @return_row_count   AS NVARCHAR(1)
	  , @UseTemplate	    AS NVARCHAR(32) = 'No Framework'
)
AS
BEGIN

	DECLARE @PatternName AS NVARCHAR(32)  = 'Execute Script'
    DECLARE @PackageName AS NVARCHAR(256) = @PatternName + ' - ' + @package_qualifier; 

	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build Packages (Execute Script)'
		 , '@PackageName: ' + @PackageName);

	DECLARE @Package AS NVARCHAR(MAX)
		  , @Package_XML AS XML
          , @Container AS NVARCHAR(MAX)
          , @PackageParameters AS NVARCHAR(MAX)
		  , @CustomVariables_XML AS XML
          , @CustomVariables AS NVARCHAR(MAX);

	
	--SET @CustomVariables = N'
	--		<Variables>
	--			<Variable EvaluateAsExpression="true" DataType="String" IncludeInDebugDump="Exclude" Name="execute_sql">' + '--- WiP ---' + '</Variable>'


	SET @CustomVariables_XML = 
	  (
		SELECT [EvaluateAsExpression] AS 'Variable/@EvaluateAsExpression'
			 , [DataType] AS 'Variable/@DataType'
			 , 'Exclude' AS 'Variable/@IncludeInDebugDump'
			 , [Name] AS 'Variable/@Name'
			 , [variable_value] AS 'Variable'
		  FROM [biml].[package_config (Execute Script) variable]
		 WHERE [package_qualifier] = @package_qualifier
	   FOR XML PATH (''), root ('Variables'), type
	  );

	SET @CustomVariables = CAST(@CustomVariables_XML AS NVARCHAR(MAX))

	IF @CustomVariables IS NULL
		SET @CustomVariables = '<Variables>'
	ELSE
		SET @CustomVariables = REPLACE(@CustomVariables, '</Variables>', '')


	-- get template
	SELECT @Package_XML = [template_xml] FROM [biml].[template] WHERE [template_name] = @UseTemplate
	SET @Package = CAST(@Package_XML AS NVARCHAR(MAX))
	SET @Package = REPLACE(@Package, 'ReplaceWithPackageName', @PackageName)


  IF @return_row_count = 'N'
	SET @Container = N'
			<Tasks>
				<Script ProjectCoreName="' + @script_name + '" Name="Script Task">
					<ScriptTaskProjectReference ScriptTaskProjectName="' + @script_name + '" />
				</Script>
			</Tasks>'

	------ add package parameters
	----SET @Package = REPLACE(@Package, '<Variables>', @PackageParameters)

	-- add custom variables
	SET @Package = REPLACE(@Package, '<Variables>', @CustomVariables)

	-- add container contents
	SET @Package = REPLACE(@Package, '<ReplaceWithPrimaryContainerContents/>', @Container)

	SET @Package_XML = @Package
	
	-- delete in case package already exists
	DELETE [biml].[package]
	 WHERE [package_name] = @PackageName

	-- insert package 	
	INSERT [biml].[package]
         ( [package_name]
		 , [pattern_name]
         , [package_text]
         , [package_xml] 
         , [build_datetime] 
         , [build_template] 
		 )
    VALUES
         ( @PackageName
		 , @PatternName
		 , ISNULL(@Package, 'Incomplete Build')
		 , ISNULL(@Package_XML,'<Err><IncompleteBuild/></Err>')
		 , GETDATE()
		 , @UseTemplate
		 );

END



GO
/****** Object:  StoredProcedure [biml].[Build Packages (Execute SQL)]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 23 May 2016
-- Modify date: 11 Jun 2016 - Added template logic
-- Modify date: 08 Aug 2016 - added template parameter
-- Modify date: 21 Aug 2016 - added pattern_name
-- Modify date: 27 Aug 2016 - added last build date and template
-- Modify date: 02 Mar 2017 - Added logging to [biml].[build_log]
-- Modify date: 05 Apr 2017 - Changed 'row_count' logic to optional
-- Modify date: 17 Apr 2017 - Added @IsExpression
-- Modify date: 20 Apr 2017 - Added 'Incomplete Build' option on package insert
-- Modify date: 22 Apr 2017 - Integrated expression logic
--
-- Description:	SQL Execute Package
--
-- Sample Execute Command: 
/*	
*/
-- ================================================================================================

CREATE PROCEDURE [biml].[Build Packages (Execute SQL)]
(
	    @connection_manager AS NVARCHAR(64)
	  , @package_qualifier  AS NVARCHAR(64)
	  , @query				AS NVARCHAR(MAX)
	  , @IsExpression	    AS NVARCHAR(1) 
	  , @return_row_count   AS NVARCHAR(1)
	  , @UseTemplate	    AS NVARCHAR(32) = 'No Framework'
)
AS
BEGIN

	DECLARE @PatternName AS NVARCHAR(32)  = 'Execute SQL'
    DECLARE @PackageName AS NVARCHAR(256) = @PatternName + ' - ' + @package_qualifier; 

	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build Packages (Execute SQL)'
		 , '@PackageName: ' + @PackageName);

	DECLARE @Package AS NVARCHAR(MAX)
		  , @Package_XML AS XML
          , @Container AS NVARCHAR(MAX)
          , @PackageParameters AS NVARCHAR(MAX)
          , @CustomVariables AS NVARCHAR(MAX);

	SET @PackageParameters = N'
	<Parameters>
        <Parameter DataType="DateTime" Name="start_date">1900-01-01</Parameter>
    </Parameters>
	<Variables>'
	
	SET @CustomVariables = N'
			<Variables>
				<Variable EvaluateAsExpression="true" DataType="String" IncludeInDebugDump="Exclude" Name="execute_sql">' + @query + '</Variable>'


	-- get template
	SELECT @Package_XML = [template_xml] FROM [biml].[template] WHERE [template_name] = @UseTemplate
	SET @Package = CAST(@Package_XML AS NVARCHAR(MAX))
	SET @Package = REPLACE(@Package, 'ReplaceWithPackageName', @PackageName)

  IF @IsExpression = 'N' and  @return_row_count = 'Y'
	SET @Container = N'
		  <Tasks>
			<ExecuteSQL Name="Execute SQL" ConnectionName="' + @connection_manager + '" ResultSet="SingleRow">
				<DirectInput>' + @query + '</DirectInput>
				<Results>
                   <Result Name="row_count" VariableName="User.row_count" />
                </Results>
			</ExecuteSQL>
		  </Tasks>'

  IF @IsExpression = 'N' and  @return_row_count = 'N'
	SET @Container = N'
		  <Tasks>
			<ExecuteSQL Name="Execute SQL" ConnectionName="' + @connection_manager + '" ResultSet="None">
				<DirectInput>' + @query + '</DirectInput>
			</ExecuteSQL>
		  </Tasks>'


  IF @IsExpression = 'Y' and  @return_row_count = 'Y'
	SET @Container = N'
		  <Tasks>
			<ExecuteSQL Name="Execute SQL" ConnectionName="' + @connection_manager + '" ResultSet="SingleRow">
				<VariableInput VariableName="User.execute_sql" />
				<Results>
                   <Result Name="row_count" VariableName="User.row_count" />
                </Results>
			</ExecuteSQL>
		  </Tasks>'

  IF @IsExpression = 'Y' and  @return_row_count = 'N'
	SET @Container = N'
		  <Tasks>
			<ExecuteSQL Name="Execute SQL" ConnectionName="' + @connection_manager + '" ResultSet="None">
				<VariableInput VariableName="User.execute_sql" />
			</ExecuteSQL>
		  </Tasks>'

IF @IsExpression = 'Y'
	BEGIN
		-- add package parameters
		SET @Package = REPLACE(@Package, '<Variables>', @PackageParameters)

		-- add custom variables
		SET @Package = REPLACE(@Package, '<Variables>', @CustomVariables)
	END


	-- add container contents
	SET @Package = REPLACE(@Package, '<ReplaceWithPrimaryContainerContents/>', @Container)

	SET @Package_XML = @Package
	

	-- delete in case package already exists
	DELETE [biml].[package]
	 WHERE [package_name] = @PackageName

	-- insert package 	
	INSERT [biml].[package]
         ( [package_name]
		 , [pattern_name]
         , [package_text]
         , [package_xml] 
         , [build_datetime] 
         , [build_template] 
		 )
    VALUES
         ( @PackageName
		 , @PatternName
		 , ISNULL(@Package, 'Incomplete Build')
		 , ISNULL(@Package_XML,'<Err><IncompleteBuild/></Err>')
		 , GETDATE()
		 , @UseTemplate
		 );

END


GO
/****** Object:  StoredProcedure [biml].[Build Packages (Foreach Data Flow)]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 02 Jun 2016
-- Modify date: 11 Jun 2016 - Added template logic
-- Modify date: 08 Aug 2016 - added template parameter
-- Modify date: 21 Aug 2016 - added pattern_name
-- Modify date: 27 Aug 2016 - added last build date and template
-- Modify date: 09 Sep 2016 - removed hardcoded ETL_DM references
-- Modify date: 10 Sep 2016 - changed foreach query to an expression
-- Modify date: 12 Sep 2016 - added KeepIdentity option
-- Modify date: 02 Mar 2017 - Added logging to [biml].[build_log]
-- Modify date: 03 Apr 2017 - Added 'for each' connection
-- Modify date: 04 Apr 2017 - Added Ado.Net connection logic
-- Modify date: 20 Apr 2017 - Added 'Incomplete Build' option on package insert
-- Modify date: 27 Apr 2017 - Added columns: 'datatype' and 'build value'
--
-- Description:	Build Package using ADO Foreach Loop 
--
-- ================================================================================================

CREATE PROCEDURE [biml].[Build Packages (Foreach Data Flow)]
(
	    @ForeachConnection AS NVARCHAR(64)
	  , @SrcConnection     AS NVARCHAR(64)
	  , @ForeachQuery      AS NVARCHAR(MAX)
	  , @foreach_item_datatype    NVARCHAR(32)
	  , @foreach_item_build_value NVARCHAR(512)
	  , @SrcQuery          AS NVARCHAR(MAX)
	  , @SrcQueryDirect    AS NVARCHAR(MAX)
	  , @package_qualifier AS NVARCHAR(64)
	  , @DstConnection     AS NVARCHAR(64)
	  , @DstSchema         AS NVARCHAR(128)
	  , @DstTable          AS NVARCHAR(128)
	  , @DstTruncate       AS NVARCHAR(1)
	  , @KeepIdentity      AS NVARCHAR(1)
	  , @UseTemplate	   AS NVARCHAR(32) = 'No Framework'
)
AS
BEGIN

	DECLARE @PatternName AS NVARCHAR(32)  = 'Foreach Data Flow'
    DECLARE @PackageName AS NVARCHAR(256) = @PatternName + ' - ' + @package_qualifier + ' - ' + @DstTable; 

	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build Packages (Foreach Data Flow)'
		 , '@PackageName: ' + @PackageName);

	DECLARE @IdentityInsert AS NVARCHAR(5) = 'false'
	IF @KeepIdentity = 'Y'
		SET @IdentityInsert = 'true'

	DECLARE @Package AS NVARCHAR(MAX)
		  , @Package_XML AS XML
          , @Container AS NVARCHAR(MAX)
          , @CustomVariables AS NVARCHAR(MAX);

	DECLARE @OptionalTruncateTask AS NVARCHAR(MAX);

	IF @DstTruncate = 'Y'
		SET @OptionalTruncateTask = '
		    <ExecuteSQL Name="Truncate" ConnectionName="' + @DstConnection + '">
               <DirectInput>TRUNCATE TABLE [' + @DstSchema + '].[' + @DstTable + ']</DirectInput>
            </ExecuteSQL>'
	ELSE
		SET @OptionalTruncateTask = ''

	SET @CustomVariables = N'
			<Variables>
				<Variable DataType="' + @foreach_item_datatype + '" IncludeInDebugDump="Exclude" Name="Item">' + @foreach_item_build_value + '</Variable>
				<Variable DataType="Object" IncludeInDebugDump="Exclude" Name="Items" />
				<Variable EvaluateAsExpression="true" DataType="String" IncludeInDebugDump="Exclude" Name="SourceQuery">' + @SrcQuery + '</Variable>
				<Variable EvaluateAsExpression="true" DataType="String" IncludeInDebugDump="Exclude" Name="ForeachQuery">' + @ForeachQuery + '</Variable>'

	-- get template
	SELECT @Package_XML = [template_xml] FROM [biml].[template] WHERE [template_name] = @UseTemplate
	SET @Package = CAST(@Package_XML AS NVARCHAR(MAX))
	SET @Package = REPLACE(@Package, 'ReplaceWithPackageName', @PackageName)

	
	-- set @Container based on dataflow source connection type
	DECLARE @connection_type AS NVARCHAR(32)
	SET @connection_type = (SELECT TOP 1 [connection_type] FROM [biml].[vw_project_connection] WHERE [connection_name] = @SrcConnection)
	IF @connection_type = 'AdoNet'
		BEGIN
		SET @Container = N'
		  <Tasks>
			' + @OptionalTruncateTask + '
				<ExecuteSQL Name="Get Foreach Collection Object" ConnectionName="' + @ForeachConnection + '" ResultSet="Full">
					<VariableInput VariableName="User.ForeachQuery" />
					<Results>
						<Result Name="0" VariableName="User.Items" />
					</Results>
				</ExecuteSQL>
				<ForEachAdoLoop Name="Foreach Loop Container - For Each Server" SourceVariableName="User.Items">
					<Variables>
						<Variable DataType="String" IncludeInDebugDump="Exclude" Name="Environment"></Variable>
					</Variables>
					<Tasks>
						<Dataflow Name="Collection">
							<Expressions>
                                <Expression ExternalProperty="[ADO NET Source].[SqlCommand]">@[User::SourceQuery]</Expression>
    						</Expressions>
							<Transformations>
								<AdoNetSource Name="ADO NET Source" ConnectionName="' + @SrcConnection + '">
									<DirectInput>' + @SrcQueryDirect + '
									</DirectInput>
        						</AdoNetSource>
								<RowCount Name="Row Count" VariableName="User.row_count">
									<InputPath OutputPathName="ADO NET Source.Output" />
								</RowCount>
								<OleDbDestination Name="Destination" ConnectionName="' + @DstConnection + '" KeepIdentity="' + @IdentityInsert + '">
									<InputPath OutputPathName="Row Count.Output" />
									<ExternalTableOutput Table="' + @DstSchema + '.' + @DstTable + '" />
								</OleDbDestination>
							</Transformations>
						</Dataflow>
					</Tasks>
					<VariableMappings>
						<VariableMapping Name="0" VariableName="User.Item" />
					</VariableMappings>
				</ForEachAdoLoop>
		    </Tasks>'
		END
	ELSE
		-- 'OleDb'
		BEGIN	
		SET @Container = N'
		  <Tasks>
			' + @OptionalTruncateTask + '
				<ExecuteSQL Name="Get Foreach Collection Object" ConnectionName="' + @ForeachConnection + '" ResultSet="Full">
					<VariableInput VariableName="User.ForeachQuery" />
					<Results>
						<Result Name="0" VariableName="User.Items" />
					</Results>
				</ExecuteSQL>
				<ForEachAdoLoop Name="Foreach Loop Container - For Each Server" SourceVariableName="User.Items">
					<Variables>
						<Variable DataType="String" IncludeInDebugDump="Exclude" Name="Environment"></Variable>
					</Variables>
					<Tasks>
						<Dataflow Name="Collection">
							<Transformations>
								<OleDbSource Name="Source" ConnectionName="' + @SrcConnection + '">
									<VariableInput VariableName="User.SourceQuery" />
								</OleDbSource>
								<RowCount Name="Row Count" VariableName="User.row_count">
									<InputPath OutputPathName="Source.Output" />
								</RowCount>
								<OleDbDestination Name="Destination" ConnectionName="' + @DstConnection + '" KeepIdentity="' + @IdentityInsert + '">
									<InputPath OutputPathName="Row Count.Output" />
									<ExternalTableOutput Table="' + @DstSchema + '.' + @DstTable + '" />
								</OleDbDestination>
							</Transformations>
						</Dataflow>
					</Tasks>
					<VariableMappings>
						<VariableMapping Name="0" VariableName="User.Item" />
					</VariableMappings>
				</ForEachAdoLoop>
		    </Tasks>'
		END

	-- replace destination connection type if necesary
	SET @connection_type = (SELECT TOP 1 [connection_type] FROM [biml].[vw_project_connection] WHERE [connection_name] = @DstConnection)
	IF @connection_type != 'OleDb'
		BEGIN
			SET @Container = REPLACE(@Container, 'OleDbDestination', @connection_type + 'Destination')
		END

	-- add custom variables
	SET @Package = REPLACE(@Package, '<Variables>', @CustomVariables)

	-- add container contents
	SET @Package = REPLACE(@Package, '<ReplaceWithPrimaryContainerContents/>', @Container)

	SET @Package_XML = @Package
	
	-- delete in case package already exists
	DELETE [biml].[package]
	 WHERE [package_name] = @PackageName

	-- insert package 	
	INSERT [biml].[package]
         ( [package_name]
		 , [pattern_name]
         , [package_text]
         , [package_xml] 
         , [build_datetime] 
         , [build_template] 
		 )
    VALUES
         ( @PackageName
		 , @PatternName
		 , ISNULL(@Package, 'Incomplete Build')
		 , ISNULL(@Package_XML,'<Err><IncompleteBuild/></Err>')
		 , GETDATE()
		 , @UseTemplate
		 );

END


GO
/****** Object:  StoredProcedure [biml].[Build Packages (Foreach Execute SQL)]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 02 Jun 2016
-- Modify date: 11 Jun 2016 - Added template logic
-- Modify date: 08 Aug 2016 - added template parameter
-- Modify date: 21 Aug 2016 - added pattern_name
-- Modify date: 27 Aug 2016 - added last build date and template
-- Modify date: 09 Sep 2016 - removed hardcoded ETL_DM references
-- Modify date: 10 Sep 2016 - changed foreach query to an expression
-- Modify date: 12 Sep 2016 - added KeepIdentity option
-- Modify date: 02 Mar 2017 - Added logging to [biml].[build_log]
-- Modify date: 03 Apr 2017 - Added 'for each' connection
-- Modify date: 04 Apr 2017 - Added Ado.Net connection logic
-- Modify date: 20 Apr 2017 - Added 'Incomplete Build' option on package insert
-- Modify date: 27 Apr 2017 - Added columns: 'datatype' and 'build value'
-- Modify date: 20 Jun 2017 - Added pattern: package_config (Foreach Execute SQL)
--
-- Description:	Build Package using pattern: Foreach Execute SQL
--
-- ================================================================================================

CREATE PROCEDURE [biml].[Build Packages (Foreach Execute SQL)]
(
	    @package_qualifier  AS NVARCHAR(64)
	  , @foreach_connection AS NVARCHAR(64)
	  , @foreach_query      AS NVARCHAR(MAX)
	  , @foreach_item_datatype    NVARCHAR(32)
	  , @foreach_item_build_value NVARCHAR(512)
	  , @query_connection   AS NVARCHAR(64)
	  , @query              AS NVARCHAR(MAX)
	  , @is_expression      AS NVARCHAR(1)
	  , @return_row_count   AS NVARCHAR(1)
	  , @UseTemplate	    AS NVARCHAR(32) = 'No Framework'
)
AS
BEGIN

	DECLARE @PatternName AS NVARCHAR(32)  = 'Foreach Execute SQL'
    DECLARE @PackageName AS NVARCHAR(256) = @PatternName + ' - ' + @package_qualifier; 

	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build Packages (Foreach Execute SQL)'
		 , '@PackageName: ' + @PackageName);

	DECLARE @Package AS NVARCHAR(MAX)
		  , @Package_XML AS XML
          , @Container AS NVARCHAR(MAX)
          , @CustomVariables AS NVARCHAR(MAX);

	SET @CustomVariables = N'
			<Variables>
				<Variable DataType="' + @foreach_item_datatype + '" IncludeInDebugDump="Exclude" Name="Item">' + @foreach_item_build_value + '</Variable>
				<Variable DataType="Object" IncludeInDebugDump="Exclude" Name="Items" />
				<Variable EvaluateAsExpression="true" DataType="String" IncludeInDebugDump="Exclude" Name="ForeachQuery">' + @foreach_query + '</Variable>
				<Variable EvaluateAsExpression="true" DataType="String" IncludeInDebugDump="Exclude" Name="execute_sql">' + @query + '</Variable>'


-- set-up Execute SQL task
DECLARE  @execute_sql_task AS NVARCHAR(MAX)

 IF @is_expression = 'N' and  @return_row_count = 'Y'
	SET @execute_sql_task = N'
		  <Tasks>
			<ExecuteSQL Name="Execute SQL" ConnectionName="' + @query_connection + '" ResultSet="SingleRow">
				<DirectInput>' + @query + '</DirectInput>
				<Results>
                   <Result Name="row_count" VariableName="User.row_count" />
                </Results>
			</ExecuteSQL>
		  </Tasks>'

  IF @is_expression = 'N' and  @return_row_count = 'N'
	SET @execute_sql_task = N'
		  <Tasks>
			<ExecuteSQL Name="Execute SQL" ConnectionName="' + @query_connection + '" ResultSet="None">
				<DirectInput>' + @query + '</DirectInput>
			</ExecuteSQL>
		  </Tasks>'


  IF @is_expression = 'Y' and  @return_row_count = 'Y'
	SET @execute_sql_task = N'
		  <Tasks>
			<ExecuteSQL Name="Execute SQL" ConnectionName="' + @query_connection + '" ResultSet="SingleRow">
				<VariableInput VariableName="User.execute_sql" />
				<Results>
                   <Result Name="row_count" VariableName="User.row_count" />
                </Results>
			</ExecuteSQL>
		  </Tasks>'

  IF @is_expression = 'Y' and  @return_row_count = 'N'
	SET @execute_sql_task = N'
		  <Tasks>
			<ExecuteSQL Name="Execute SQL" ConnectionName="' + @query_connection + '" ResultSet="None">
				<VariableInput VariableName="User.execute_sql" />
			</ExecuteSQL>
		  </Tasks>'


	-- get template
	SELECT @Package_XML = [template_xml] FROM [biml].[template] WHERE [template_name] = @UseTemplate
	SET @Package = CAST(@Package_XML AS NVARCHAR(MAX))
	SET @Package = REPLACE(@Package, 'ReplaceWithPackageName', @PackageName)

	
		SET @Container = N'
		  <Tasks>
				<ExecuteSQL Name="Get Foreach Collection Object" ConnectionName="' + @foreach_connection + '" ResultSet="Full">
					<VariableInput VariableName="User.ForeachQuery" />
					<Results>
						<Result Name="0" VariableName="User.Items" />
					</Results>
				</ExecuteSQL>
				<ForEachAdoLoop Name="Foreach Loop Container - For Each Server" SourceVariableName="User.Items">
					<Variables>
						<Variable DataType="String" IncludeInDebugDump="Exclude" Name="Environment"></Variable>
					</Variables> 
					' + @execute_sql_task + '
					<VariableMappings>
						<VariableMapping Name="0" VariableName="User.Item" />
					</VariableMappings>
				</ForEachAdoLoop>
		    </Tasks>'


	-- add custom variables

	------IF @is_expression = 'Y'
	------BEGIN
	------	------ add package parameters
	------	----SET @Package = REPLACE(@Package, '<Variables>', @PackageParameters)

	------	-- add custom variables
	------	SET @Package = REPLACE(@Package, '<Variables>', @CustomVariables)
	------END

	SET @Package = REPLACE(@Package, '<Variables>', @CustomVariables)


	-- add container contents
	SET @Package = REPLACE(@Package, '<ReplaceWithPrimaryContainerContents/>', @Container)

	SET @Package_XML = @Package
	
	-- delete in case package already exists
	DELETE [biml].[package]
	 WHERE [package_name] = @PackageName

	-- insert package 	
	INSERT [biml].[package]
         ( [package_name]
		 , [pattern_name]
         , [package_text]
         , [package_xml] 
         , [build_datetime] 
         , [build_template] 
		 )
    VALUES
         ( @PackageName
		 , @PatternName
		 , ISNULL(@Package, 'Incomplete Build')
		 , ISNULL(@Package_XML,'<Err><IncompleteBuild/></Err>')
		 , GETDATE()
		 , @UseTemplate
		 );

END



GO
/****** Object:  StoredProcedure [biml].[Build Packages (Manual)]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 04 Aug 2017
-- Modify date: 
--
-- Description:	Manual package creation (Created in Visual Studio - not included in package node output)
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Build Packages (Manual)] 'CT UPDATE - set next sync'
*/
-- ================================================================================================================

CREATE PROCEDURE [biml].[Build Packages (Manual)]
(
	    @package_qualifier  AS NVARCHAR(64)
	  , @UseTemplate	    AS NVARCHAR(32) = 'N/A'
)
AS
BEGIN

	DECLARE @PatternName AS NVARCHAR(32)  = 'Manual'
    DECLARE @PackageName AS NVARCHAR(256) = @PatternName + ' - ' + @package_qualifier; 

	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build Packages (Manual)'
		 , '@PackageName: ' + @PackageName);

	DECLARE @Package AS NVARCHAR(MAX)
		  , @Package_XML AS XML

	SET @Package = N'
		<Package Name="' + @PackageName + '" ProtectionLevel="EncryptSensitiveWithUserKey" SsisVersionComments="0">
		  <Variables>
			<Variable DataType="String" IncludeInDebugDump="Include" Name="biml_project_name">{biml project name}</Variable>
		  </Variables>
		</Package>'

	SET @Package_XML = @Package

	-- delete in case package already exists
	DELETE [biml].[package]
	 WHERE [package_name] = @PackageName

	-- insert package 	
	INSERT [biml].[package]
         ( [package_name]
		 , [pattern_name]
         , [package_text]
         , [package_xml] 
         , [build_datetime] 
         , [build_template] 
		 )
    VALUES
         ( @PackageName
		 , @PatternName
		 , @Package
		 , @Package_XML
		 , GETDATE()
		 , @UseTemplate
		 );

END



GO
/****** Object:  StoredProcedure [biml].[Build Parameters for Connections]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:  Jim Miller (BITracks Consulting, LLC)
-- Create date: 31 May 2016
-- Modify date: 03 Aug 2016 - Added SMTP Connection
-- Modify date: 24 Aug 2016 - Added Data Connection "ConnectString"
-- Modify date: 01 Mar 2017 - Added logging to [biml].[build_log]
-- Modify date: 25 Mar 2017 - Added Utility Parameters
-- Modify date: 31 Mar 2017 - Added Ado.Net Database Connections
-- Modify date: 10 Apr 2017 - Added Flat File Connections
-- Modify date: 13 Sep 2017 - Added optional project_id for auto-insert of newly created parameters into [biml].[project_parameter]
-- Modify date: 06 Dec 2017 - Remove Data Connection "ConnectString" and Ado.Net Connection "ConnectString"
--
-- Description: Insert/Updates parameter rows needed to support connection string expressions
--
-- Sample Execute Command: 
/* 
EXEC [biml].[Build Parameters for Connections] 
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Build Parameters for Connections]
( 
   @project_id INT = 0
)
AS

INSERT [biml].[build_log]
     ( [event_datetime]
     , [event_group]
     , [event_component] )
VALUES
     ( GETDATE()
  , 'Build Parameters for Connections'
  , 'Start');

WITH [base_param] AS
(
-- for OleDb Database Connections
 SELECT [connection_name] + '_Server' AS [parameter_name]
   , 'String' AS [parameter_datatype]
   , [server_name] AS [parameter_value]
   FROM [biml].[connection]
  WHERE RTRIM([custom_connect_string]) = ''
UNION
 SELECT [connection_name] + '_Database' AS [parameter_name]
   , 'String' AS [parameter_datatype]
   , [database_name] AS [parameter_value]
   FROM [biml].[connection]
  WHERE RTRIM([custom_connect_string]) = ''
UNION
 SELECT [connection_name] + '_Provider' AS [parameter_name]
   , 'String' AS [parameter_datatype]
   , [provider] AS [parameter_value]
   FROM [biml].[connection]
  WHERE RTRIM([custom_connect_string]) = ''
--UNION
-- SELECT [connection_name] + '_ConnectString' AS [parameter_name]
--   , 'String' AS [parameter_datatype]
--   , [custom_connect_string] AS [parameter_value]
--   FROM [biml].[connection]
--  WHERE RTRIM([custom_connect_string]) != ''

-- for Ado.Net Database Connections
UNION
 SELECT [connection_name] + '_Provider' AS [parameter_name]
   , 'String' AS [parameter_datatype]
   , [provider] AS [parameter_value]
   FROM [biml].[adonet_connection]
--UNION
-- SELECT [connection_name] + '_ConnectString' AS [parameter_name]
--   , 'String' AS [parameter_datatype]
--   , [connect_string] AS [parameter_value]
--   FROM [biml].[adonet_connection]
UNION
 SELECT [connection_name] + '_Database' AS [parameter_name]
   , 'String' AS [parameter_datatype]
   , ISNULL([database_name], '') AS [parameter_value]
   FROM [biml].[adonet_connection]

-- for Flat File Database Connections
UNION
 SELECT [connection_name] + '_FilePath' AS [parameter_name]
   , 'String' AS [parameter_datatype]
   , [file_path] AS [parameter_value]
   FROM [biml].[flatfile_connection]
UNION
 SELECT [connection_name] + '_FileFormat' AS [parameter_name]
   , 'String' AS [parameter_datatype]
   , [file_format] AS [parameter_value]
   FROM [biml].[flatfile_connection]

-- for SMTP Connection
UNION
 SELECT [connection_name] + '_Server' AS [parameter_name]
   , 'String' AS [parameter_datatype]
   , [server_name] AS [parameter_value]
   FROM [biml].[smtp_connection]
)
 MERGE [biml].[parameter] AS TARGET
 USING [base_param] AS SOURCE 
    ON (TARGET.[parameter_name] = SOURCE.[parameter_name]) 
  WHEN MATCHED THEN 
UPDATE SET 
    TARGET.[parameter_datatype] = SOURCE.[parameter_datatype]
  , TARGET.[parameter_value] = SOURCE.[parameter_value] 
  WHEN NOT MATCHED BY TARGET THEN 
INSERT ( [parameter_name]
       , [parameter_datatype]
    , [parameter_value] ) 
VALUES ( SOURCE.[parameter_name]
    , SOURCE.[parameter_datatype]
    , SOURCE.[parameter_value]);

INSERT [biml].[build_log]
     ( [event_datetime]
     , [event_group]
     , [event_component] )
VALUES
     ( GETDATE()
  , 'Build Parameters for Connections'
  , 'Finish');


-- Utility Parameters

INSERT [biml].[build_log]
     ( [event_datetime]
     , [event_group]
     , [event_component] )
VALUES
     ( GETDATE()
  , 'Build Utility Parameters'
  , 'Start');

WITH [base_param] AS
(
 SELECT 'Force_Run_All' [parameter_name], 'Boolean' [parameter_datatype], '0' [parameter_value]
)
 MERGE [biml].[parameter] AS TARGET
 USING [base_param] AS SOURCE 
    ON (TARGET.[parameter_name] = SOURCE.[parameter_name]) 
  WHEN MATCHED THEN 
UPDATE SET 
    TARGET.[parameter_datatype] = SOURCE.[parameter_datatype]
  WHEN NOT MATCHED BY TARGET THEN 
INSERT ( [parameter_name]
       , [parameter_datatype]
    , [parameter_value] ) 
VALUES ( SOURCE.[parameter_name]
    , SOURCE.[parameter_datatype]
    , SOURCE.[parameter_value]);


INSERT [biml].[build_log]
     ( [event_datetime]
     , [event_group]
     , [event_component] )
VALUES
     ( GETDATE()
  , 'Build Utility Parameters'
  , 'Finish');
  -----------------------------------------------------------------------------------
-- auto create project parameters
-----------------------------------------------------------------------------------
IF ISNULL(@project_id, 0) = 0
 RETURN;

WITH [all_params] AS
(
-- for Database Connections
 SELECT [project_id]
   , [connection_name] + '_Server' AS [parameter_name]
   FROM [biml].[project_connection]
  WHERE [project_id] = @project_id
UNION
 SELECT [project_id]
   , [connection_name] + '_Database' AS [parameter_name]
   FROM [biml].[project_connection]
  WHERE [project_id] = @project_id
UNION
 SELECT [project_id]
   , [connection_name] + '_Provider' AS [parameter_name]
   FROM [biml].[project_connection]
  WHERE [project_id] = @project_id
--UNION
-- SELECT [project_id]
--   , [connection_name] + '_ConnectString' AS [parameter_name]
--   FROM [biml].[project_connection]
--  WHERE [project_id] = @project_id

-- for SMTP Connection
UNION
 SELECT [project_id]
   , [connection_name] + '_Server' AS [parameter_name]
   FROM [biml].[project_smtp_connection]
  WHERE [project_id] = @project_id

-- for Ado.Net Database Connections
UNION
 SELECT [project_id]
   , [connection_name] + '_Provider' AS [parameter_name]
   FROM [biml].[project_adonet_connection]
  WHERE [project_id] = @project_id
--UNION
-- SELECT [project_id]
--   , [connection_name] + '_ConnectString' AS [parameter_name]
--   FROM [biml].[project_adonet_connection]
--  WHERE [project_id] = @project_id
UNION
 SELECT [project_id]
   , [connection_name] + '_Database' AS [parameter_name]
   FROM [biml].[project_adonet_connection]
  WHERE [project_id] = @project_id

-- for Flat File Database Connections
UNION
 SELECT [project_id]
   , [connection_name] + '_FilePath' AS [parameter_name]
   FROM [biml].[project_flatfile_connection]
  WHERE [project_id] = @project_id
UNION
 SELECT [project_id]
   , [connection_name] + '_FileFormat' AS [parameter_name]
   FROM [biml].[project_flatfile_connection]
  WHERE [project_id] = @project_id

-- misc parameters
UNION
 SELECT @project_id AS [project_id], 'Force_Run_All' AS [parameter_name]

)INSERT [biml].[project_parameter]
     ( [project_id]
     , [parameter_name])

  SELECT * 
    FROM [all_params]
 EXCEPT
  SELECT [project_id]
     ,[parameter_name]
    FROM [biml].[project_parameter]
   WHERE [project_id] = @project_id


INSERT [biml].[build_log]
     ( [event_datetime]
     , [event_group]
     , [event_component] )
VALUES
     ( GETDATE()
  , 'Auto-create Project Parameters'
  , 'Finish');
GO
/****** Object:  StoredProcedure [biml].[Build Project Full]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 16 May 2016
-- Modify date: 03 Aug 2016 - Added SMTP Server Connections
-- Modify date: 25 Aug 2016 - Added Environment Substitutions
-- Modify date: 07 Sep 2016 - Added project log
-- Modify date: 22 Oct 2016 - Added package protection option
-- Modify date: 02 Apr 2017 - Added adonet connections
-- Modify date: 05 Apr 2017 - Bug Fix with adonet connection expressions
-- Modify date: 11 Apr 2017 - Added flatflie connections
-- Modify date: 14 Apr 2017 - Added script tasks
-- Modify date: 27 Apr 2017 - Added @IsUnicode and @ColumnNamesInFirstDataRow attribute to Flat File Format
-- Modify date: 01 May 2017 - Added column delimiter for Flat File Format
-- Modify date: 03 May 2017 - Bug Fix - changed Flat File Format 'Name' from c.[connection_name] to f.[file_format]
-- Modify date: 13 May 2017 - Add logic to 'Replace Parameter Place Values'
-- Modify date: 15 May 2017 - Restricted SSIS_Data placed Project Parameters to 'String'
-- Modify date: 31 May 2017 - Bug Fix with repeating Flat File Formats
-- Modify date: 06 Jun 2017 - renamed CURSOR: [proc_cursor_param] to [proc_cursor_param_2] due to conflict
--
-- Description:	Builds BIML Project
--
-- Sample Execute Command: 
/*	
DECLARE @biml_project AS XML; EXEC [biml].[Build Project Full] 'Appointments', '', @PackageProtectionOption = 'EncryptSensitiveWithUserKey',   @biml = @Biml_project OUTPUT; SELECT @Biml_project AS [biml]
*/
-- ================================================================================================

CREATE PROCEDURE [biml].[Build Project Full]
	  @ProjectName AS NVARCHAR(128)
	, @EnvironmentName AS NVARCHAR(32) = ''
	, @PackageProtectionOption AS NVARCHAR(64) = 'EncryptSensitiveWithUserKey'
	, @Biml AS XML OUTPUT
AS

SET NOCOUNT ON

-- Declare internal procedure variables
DECLARE @Connections_db_XML AS XML
DECLARE @Connections_db AS NVARCHAR(MAX)
DECLARE @Connections_adonet_XML AS XML
DECLARE @Connections_adonet AS NVARCHAR(MAX)
DECLARE @Connections_flatfile_XML AS XML
DECLARE @Connections_flatfile AS NVARCHAR(MAX)
DECLARE @Connections_smtp_XML AS XML
DECLARE @Connections_smtp AS NVARCHAR(MAX)
DECLARE @ProjectID AS INT
DECLARE @ProjectFileFormatsXML AS XML
DECLARE @ProjectFileFormats AS NVARCHAR(MAX)
DECLARE @ProjectScriptTasks AS NVARCHAR(MAX)
DECLARE @ProjectConnectionsXML AS XML
DECLARE @ProjectParametersXML AS XML
DECLARE @ProjectPackagesXML AS XML
DECLARE @ProjectPackages AS NVARCHAR(MAX)
DECLARE @Packages AS NVARCHAR(MAX)


-- Get Project ID
SELECT @ProjectID = [project_id]
  FROM [biml].[project]
 WHERE [project_name] = @ProjectName

------------------------------------------------------------------------------
-- script tasks
------------------------------------------------------------------------------
DECLARE @ScriptTask AS NVARCHAR(MAX)

SET @ProjectScriptTasks = '<ScriptProjects>'

DECLARE [script_cursor] CURSOR FOR  
SELECT st.[script_text]
  FROM [biml].[project_script_task] ps
  JOIN [biml].[script_task] st
    ON st.[script_name] = ps.[script_name]
 WHERE ps.[project_id] = @ProjectID
      
OPEN [script_cursor]   
FETCH NEXT FROM [script_cursor] INTO @ScriptTask

WHILE @@FETCH_STATUS = 0   
BEGIN 
	SET @ProjectScriptTasks = @ProjectScriptTasks + @ScriptTask
	FETCH NEXT FROM [script_cursor] INTO @ScriptTask
END;  

CLOSE [script_cursor]; 
DEALLOCATE [script_cursor];

SET @ProjectScriptTasks = @ProjectScriptTasks + '</ScriptProjects>'

IF @ProjectScriptTasks = '<ScriptProjects></ScriptProjects>'
	SET @ProjectScriptTasks = ''


------------------------------------------------------------------------------
-- CSV File Formats
------------------------------------------------------------------------------
 SET @ProjectFileFormatsXML = 
  (
	SELECT f.[file_format] AS '@Name'
		 , f.[code_page] AS '@CodePage'
		 , f.[row_delimiter] AS '@RowDelimiter'
		 , f.[text_qualifer] AS '@TextQualifer'
		 , f.[IsUnicode] AS '@IsUnicode'
		 , f.[ColumnNamesInFirstDataRow] AS '@ColumnNamesInFirstDataRow'
		 --, [biml].[Data Connect String] (c.[connection_name], @EnvironmentName) AS '@ConnectionString'
		 , ( SELECT e.[column_name] AS 'Column/@Name'
				  , 'AnsiString' AS 'Column/@DataType'
				  , ISNULL(e.[char_max_length], 255) AS 'Column/@Length'
				  , ISNULL(e.[char_max_length], 255) AS 'Column/@MaximumWidth'
				  , f.[column_delimiter] AS 'Column/@Delimiter'
			   FROM [etl].[dim_column] e
			  WHERE e.[server_name] = f.[metadata_server]
			    AND e.[database_name] = f.[metadata_database]
			    AND e.[table_schema] = f.[metadata_schema]
			    AND e.[table_name] = f.[metadata_table]
				order by [ordinal_position]
		    FOR XML PATH (''), root ('Columns'), type )
      FROM (
	  		SELECT DISTINCT pffc.[project_id]
				 , ffc.[file_format]
			  FROM [biml].[project_flatfile_connection] pffc
			  JOIN [biml].[flatfile_connection] ffc
				ON ffc.[connection_name] = pffc.[connection_name]
		   ) c
	  JOIN [biml].[flatfile_format] f
	    ON f.[file_format] = c.[file_format]
     WHERE c.[project_id] = @ProjectID
   FOR XML PATH ('FlatFileFormat'), root ('FileFormats'), type
  );

SET @ProjectFileFormats = CAST(@ProjectFileFormatsXML AS NVARCHAR(MAX))
SET @ProjectFileFormats = REPLACE(@ProjectFileFormats, 'Delimiter="Comma"/></Columns>' , 'Delimiter="CRLF"/></Columns>')

IF @ProjectFileFormats IS NULL
	SET @ProjectFileFormats = ''

------------------------------------------------------------------------------
-- Connections for OleDb
------------------------------------------------------------------------------
SET @Connections_db_XML = 
  (
	SELECT c.[connection_name] AS '@Name'
--		 , c.[connection_string] AS '@ConnectionString'
		 , [biml].[Data Connect String] (c.[connection_name], @EnvironmentName) AS '@ConnectionString'
		 , 'true' AS '@CreateInProject'
		 , 'false' AS '@CreatePackageConfiguration'
		 , ( SELECT 'ConnectionString' AS 'Expression/@ExternalProperty'
				  , e.[connection_expression] AS 'Expression'
			   FROM [biml].[connection] e
			  WHERE e.[connection_name] = c.[connection_name]
		    FOR XML PATH (''), root ('Expressions'), type )
      FROM [biml].[connection] c
	  JOIN [biml].[project_connection] pc
        ON pc.[connection_name] = c.[connection_name]
     WHERE pc.[project_id] = @ProjectID
   FOR XML PATH ('Connection'), root ('Connections'), type
  );
 
------------------------------------------------------------------------------
-- Connections for Ado.Net
------------------------------------------------------------------------------
WITH [expressions] AS
(
	SELECT a.[connection_name]
		 , 'Provider' AS 'Expression/@ExternalProperty'
	     , a.[provider_expression] AS 'Expression'
	  FROM [biml].[adonet_connection] a

UNION

	SELECT a.[connection_name]
		 , 'ConnectionString' AS 'Expression/@ExternalProperty'
	     , a.[connect_string_expression] AS 'Expression'
	  FROM [biml].[adonet_connection] a
)
SELECT @Connections_adonet_XML = 
  (
	SELECT c.[connection_name] AS '@Name'
		 , [biml].[Adonet Provider] ( c.[connection_name], '' ) AS '@Provider' 
		 , [biml].[Adonet Connect String] ( c.[connection_name], '' ) AS '@ConnectionString' 
		 , 'true' AS '@CreateInProject'
		 , 'false' AS '@CreatePackageConfiguration'
		 , ( 
			SELECT [Expression/@ExternalProperty]
				 , [Expression]
			  FROM [expressions] e
			 WHERE e.[connection_name] = c.[connection_name]
		    FOR XML PATH (''), root ('Expressions'), type 
			)
      FROM [biml].[adonet_connection] c
	  JOIN [biml].[project_adonet_connection] pc
        ON pc.[connection_name] = c.[connection_name]
     WHERE pc.[project_id] = @ProjectID
   FOR XML PATH ('AdoNetConnection'), root ('Connections'), type
  );


------------------------------------------------------------------------------
-- Connections for flat files
------------------------------------------------------------------------------
WITH [expressions] AS
(
	SELECT a.[connection_name]
		 , 'FilePath' AS 'Expression/@ExternalProperty'
	     , a.[file_path_expression] AS 'Expression'
	  FROM [biml].[flatfile_connection] a

--UNION

--	SELECT a.[connection_name]
--		 , 'FileFormat' AS 'Expression/@ExternalProperty'
--	     , a.[file_format_expression] AS 'Expression'
--	  FROM [biml].[flatfile_connection] a
)
SELECT @Connections_flatfile_XML = 
  (
	SELECT c.[connection_name] AS '@Name'
		 , [biml].[Flatfile FilePath] ( c.[connection_name], '' ) AS '@FilePath' 
		 , [biml].[Flatfile FileFormat] ( c.[connection_name], '' ) AS '@FileFormat' 
		 , 'true' AS '@CreateInProject'
		 , 'false' AS '@CreatePackageConfiguration'
		 , ( 
			SELECT [Expression/@ExternalProperty]
				 , [Expression]
			  FROM [expressions] e
			 WHERE e.[connection_name] = c.[connection_name]
		    FOR XML PATH (''), root ('Expressions'), type 
			)
      FROM [biml].[flatfile_connection] c
	  JOIN [biml].[project_flatfile_connection] pc
        ON pc.[connection_name] = c.[connection_name]
     WHERE pc.[project_id] = @ProjectID
   FOR XML PATH ('FlatFileConnection'), root ('Connections'), type
  );


------------------------------------------------------------------------------
-- Connections for smtp
------------------------------------------------------------------------------
SET @Connections_smtp_XML = 
  (
	SELECT c.[connection_name] AS '@Name'
		 , [biml].[Smtp Connect String] ( c.[connection_name], @EnvironmentName ) AS '@SmtpServer' 
		 , 'true' AS '@CreateInProject'
		 , 'false' AS '@CreatePackageConfiguration'
		 , ( SELECT 'SmtpServer' AS 'Expression/@ExternalProperty'
				  , e.[server_name_expression] AS 'Expression'
			   FROM [biml].[smtp_connection] e
			  WHERE e.[connection_name] = c.[connection_name]
		    FOR XML PATH (''), root ('Expressions'), type )
      FROM [biml].[smtp_connection] c
	  JOIN [biml].[project_smtp_connection] pc
        ON pc.[connection_name] = c.[connection_name]
     WHERE pc.[project_id] = @ProjectID
   FOR XML PATH ('SmtpConnection'), root ('Connections'), type
  );

 --select @Connections_smtp_XML as [smtp connection]
------------------------------------------------------------------------------
-- Combine Connections
------------------------------------------------------------------------------

SET @Connections_db   =  CAST(@Connections_db_XML AS NVARCHAR(MAX));

IF @Connections_adonet_XML IS NOT NULL
	BEGIN
		SET @Connections_adonet =  CAST(@Connections_adonet_XML AS NVARCHAR(MAX))
		SET @Connections_adonet = REPLACE(@Connections_adonet, '<Connections>' , '')
		SET @Connections_db   = REPLACE(@Connections_db  , '</Connections>', @Connections_adonet)
	END;

IF @Connections_flatfile_XML IS NOT NULL
	BEGIN
		SET @Connections_flatfile =  CAST(@Connections_flatfile_XML AS NVARCHAR(MAX))
		SET @Connections_flatfile = REPLACE(@Connections_flatfile, '<Connections>' , '')
		SET @Connections_db   = REPLACE(@Connections_db  , '</Connections>', @Connections_flatfile)
	END;

IF @Connections_smtp_XML IS NOT NULL
	BEGIN
		SET @Connections_smtp =  CAST(@Connections_smtp_XML AS NVARCHAR(MAX))
		SET @Connections_smtp = REPLACE(@Connections_smtp, '<Connections>' , '')
		SET @Connections_db   = REPLACE(@Connections_db  , '</Connections>', @Connections_smtp)
	END;

------------------------------------------------------------------------------
-- Project Connections
------------------------------------------------------------------------------
SET @ProjectConnectionsXML = 
  ( 
	SELECT [connection_name] AS '@ConnectionName'
	  FROM [biml].[vw_project_connection]
  	 WHERE [project_id] = @ProjectID
   FOR XML PATH ('Connection'), root ('Connections'), type 
   )


------------------------------------------------------------------------------
-- Project Parameters with Environment Substitutions
------------------------------------------------------------------------------

SET @ProjectParametersXML = 
  ( SELECT p.[parameter_name] AS 'Parameter/@Name'
		 , p.[parameter_datatype] AS 'Parameter/@DataType'
		 , COALESCE(ep.[parameter_value] ,p.[parameter_value]) AS 'Parameter'
      FROM [biml].[parameter] p
	  JOIN [biml].[project_parameter] pp
        ON pp.[parameter_name] = p.[parameter_name]
	  LEFT JOIN [biml].[environment_parameter] ep
	    ON ep.[environment_name] = @EnvironmentName
	   AND ep.[parameter_name] = p.[parameter_name]
     WHERE pp.[project_id] = @ProjectID
   FOR XML PATH (''), root ('Parameters'), type )



------------------------------------------------------------------------------
-- Project Packages
------------------------------------------------------------------------------
SET @ProjectPackagesXML = 
  ( SELECT p.[package_name] AS '@PackageName'
      FROM [biml].[package] p
	  JOIN [biml].[project_package] pp
        ON pp.[package_name] = p.[package_name]
     WHERE pp.[project_id] = @ProjectID
  ORDER BY pp.[sequence_number]
   FOR XML PATH ('Package'), root ('Packages'), type )

SET @ProjectPackages = CAST(@ProjectPackagesXML  AS NVARCHAR(MAX))


------------------------------------------------------------------------------
-- Package Node
------------------------------------------------------------------------------
SELECT @Packages = COALESCE(@Packages, '') + REPLACE(p.[package_text], 'SsisVersionComments="0"', 'SsisVersionComments="' + CAST(pp.[sequence_number] AS VARCHAR) + '"')
  FROM [biml].[package] p
  JOIN [biml].[project_package] pp
    ON pp.[package_name] = p.[package_name]
 WHERE pp.[project_id] = @ProjectID

SET @Packages = REPLACE(@Packages, '{biml project name}', @ProjectName)

IF @PackageProtectionOption = 'DontSaveSensitive'
	SET @Packages = REPLACE(@Packages, 'ProtectionLevel="EncryptSensitiveWithUserKey"', 'ProtectionLevel="DontSaveSensitive"')

	----------------------------------------------------------------------
	-- build 'Place Values' in SSIS_Data Tasks (in case it's needed)
	----------------------------------------------------------------------
	DECLARE @OptionalPlaceValuesTasks AS NVARCHAR(MAX) = ''
	      , @PlaceValuesTask AS NVARCHAR(MAX)
	      , @PlaceValuesVariableTemplate AS NVARCHAR(MAX);

		SET @PlaceValuesVariableTemplate = '
		    <ExecuteSQL Name="Place Parameter ' + '<ReplaceWithValueKey/>' + ' in SSIS_Data" ConnectionName="SSIS_Data">
                <DirectInput>EXEC [dbo].[Put Value] ?, ''@[$Project::' + '<ReplaceWithValueKey/>' + ']'', ?</DirectInput>
                <Parameters>
                    <Parameter Name="0" VariableName="System.ExecutionInstanceGUID" DataType="String" Length="128" />
                    <Parameter Name="1" VariableName="{project name}.' + '<ReplaceWithValueKey/>' + '" DataType="String" Length="8000" />
				</Parameters>
            </ExecuteSQL>'


	DECLARE @ParameterName AS NVARCHAR(128)
	DECLARE [proc_cursor_param_2] CURSOR FOR  
	 SELECT pp.[parameter_name]
	   FROM [biml].[project_parameter] pp
	   JOIN [biml].[parameter] pr
	     ON pr.[parameter_name] = pp.[parameter_name]
	  WHERE pp.[project_id] = @ProjectID
	  	AND pr.[parameter_datatype] = 'String'

	   OPEN [proc_cursor_param_2]   
	  FETCH NEXT FROM [proc_cursor_param_2] INTO @ParameterName

	WHILE @@FETCH_STATUS = 0   
	BEGIN 
		SET @PlaceValuesTask = REPLACE(@PlaceValuesVariableTemplate, '<ReplaceWithValueKey/>', @ParameterName)
		SET @PlaceValuesTask = REPLACE(@PlaceValuesTask, '{project name}', @ProjectName)
		SET @OptionalPlaceValuesTasks = @OptionalPlaceValuesTasks + @PlaceValuesTask

		FETCH NEXT FROM [proc_cursor_param_2] INTO @ParameterName
	END;  

	CLOSE [proc_cursor_param_2]; 
	DEALLOCATE [proc_cursor_param_2];


SET @Packages = REPLACE(@Packages, '<ReplaceParameterPlaceValuesHere/>', @OptionalPlaceValuesTasks)

/* debug code
IF @Packages IS NULL
	SET @Packages = 'ERROR!' 

SELECT @Packages AS [Packages]
SELECT @ProjectScriptTasks AS [ProjectScriptTasks]
SELECT @ProjectFileFormats AS [ProjectFileFormats]
SELECT @Connections_db AS [Connections_db]
*/


------------------------------------------------------------------------------
-- Script Assembly
------------------------------------------------------------------------------
SET @Biml =
  '<Biml xmlns="http://schemas.varigence.com/biml.xsd">'
+ @ProjectScriptTasks
+ @ProjectFileFormats
+ @Connections_db
+ '<Projects>'
+ '<PackageProject ProtectionLevel="' + @PackageProtectionOption + '" Name="' + @ProjectName + '">'
+ CAST(@ProjectConnectionsXML AS NVARCHAR(MAX))
+ CAST(@ProjectParametersXML  AS NVARCHAR(MAX))
+ @ProjectPackages
+ '</PackageProject>'
+ '</Projects>'
+ '<Packages>'
+ @Packages
+ '</Packages>'
+ '</Biml>'

print @Connections_db
print @Packages

IF @EnvironmentName = ''
	SET @EnvironmentName = 'n/a'

IF ISNULL(CAST(@Biml AS NVARCHAR(MAX)), '') = ''
	BEGIN
		INSERT [biml].[build_log]
				( [event_datetime]
				, [event_group]
				, [event_component] )
		VALUES
				( GETDATE()
				, 'Build Project Full'
				, 'Error - Failed to Build Project: ' + @ProjectName);
		PRINT 'Project Build Failed!'
		RETURN
	END


-- log activity
INSERT [biml].[user_activity]
     ( [user_id]
     , [author_id]
     , [activity_datetime]
     , [activity_name]
	 , [build_component]
	 , [activity_count]
	 )
SELECT [biml].[get user id] ()
	 , 1 -- BI Tracks (author)
	 , GETDATE()
	 , 'project build'
	 , 'Project: ' + @ProjectName + '  - Environment: ' + @EnvironmentName
	 , 1



--SET @Connections_adonet_XML = 
--  (
--	SELECT c.[connection_name] AS '@Name'
--		 , [biml].[Adonet Provider] ( c.[connection_name], '' ) AS '@Provider' 
--		 , [biml].[Adonet Connect String] ( c.[connection_name], '' ) AS '@ConnectionString' 
--		 , 'true' AS '@CreateInProject'
--		 , 'false' AS '@CreatePackageConfiguration'
--		 , ( SELECT 'Provider' AS 'Expression/@ExternalProperty'
--				  , a.[provider_expression] AS 'Expression'
--			   FROM [biml].[adonet_connection] a
--			  WHERE a.[connection_name] = c.[connection_name]
--		    FOR XML PATH (''), root ('Expressions'), type )
--      FROM [biml].[adonet_connection] c
--	  JOIN [biml].[project_adonet_connection] pc
--        ON pc.[connection_name] = c.[connection_name]
--     WHERE pc.[project_id] = @ProjectID
--   FOR XML PATH ('AdoNetConnection'), root ('Connections'), type
--  )






GO
/****** Object:  StoredProcedure [biml].[Build Project Parameters]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 07 Jun 2016
-- Modify date: 25 Aug 2016 - Added Environment Parameter Substitution
-- Description:	Builds BIML Project Parameters
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Build Project Parameters] 'EDW Refresh Hist', '', @biml_project = @Biml OUTPUT
*/
-- ================================================================================================

CREATE PROCEDURE [biml].[Build Project Parameters]
	  @ProjectName AS NVARCHAR(128)
	, @EnvironmentName AS NVARCHAR(32) = ''
	, @Biml AS XML OUTPUT
AS

SET NOCOUNT ON

-- Declare internal procedure variables
DECLARE @ProjectID AS INT
DECLARE @Params AS NVARCHAR(MAX)
DECLARE @BaseTags AS NVARCHAR(4000)
DECLARE @WorkTags AS NVARCHAR(4000)

DECLARE @parameter_name AS NVARCHAR(128)
      , @parameter_datatype AS NVARCHAR(32)
	  , @parameter_value AS NVARCHAR(512)

DECLARE @use_datatype AS NVARCHAR(16)

SET @BaseTags = '
<SSIS:Parameter SSIS:Name="{param}">
    <SSIS:Properties>
      <SSIS:Property SSIS:Name="ID">{{guid}}</SSIS:Property>
      <SSIS:Property SSIS:Name="CreationName"></SSIS:Property>
      <SSIS:Property SSIS:Name="Description"></SSIS:Property>
      <SSIS:Property SSIS:Name="IncludeInDebugDump">0</SSIS:Property>
      <SSIS:Property SSIS:Name="Required">0</SSIS:Property>
      <SSIS:Property SSIS:Name="Sensitive">0</SSIS:Property>
      <SSIS:Property SSIS:Name="Value">{value}</SSIS:Property>
      <SSIS:Property SSIS:Name="DataType">{type}</SSIS:Property>
    </SSIS:Properties>
  </SSIS:Parameter>'

-- Get Project ID
SELECT @ProjectID = [project_id]
  FROM [biml].[project]
 WHERE [project_name] = @ProjectName

 SET @Params = '<SSIS:Parameters xmlns:SSIS="www.microsoft.com/SqlServer/SSIS">'

---------------------------------------------
-- Project Parameters with Environment Parameter Substitution
---------------------------------------------
DECLARE [proc_cursor] CURSOR FOR  
  SELECT p.[parameter_name]
	   , p.[parameter_datatype]
	   , COALESCE(ep.[parameter_value], p.[parameter_value]) AS [parameter_value]
    FROM [biml].[parameter] p
	JOIN [biml].[project_parameter] pp
      ON pp.[parameter_name] = p.[parameter_name]
	LEFT JOIN [biml].[environment_parameter] ep
	  ON ep.[environment_name] = @EnvironmentName
	 AND ep.[parameter_name] = p.[parameter_name]
   WHERE pp.[project_id] = @ProjectID

OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @parameter_name, @parameter_datatype, @parameter_value

WHILE @@FETCH_STATUS = 0   
BEGIN 

	SELECT @use_datatype = 
		CASE @parameter_datatype
			WHEN 'Boolean' THEN '3'
			WHEN 'SByte' THEN '5'
			WHEN 'Byte' THEN '6'
			WHEN 'Int16' THEN '7'
			WHEN 'Int32' THEN '9'
			WHEN 'UInt32' THEN '10'
			WHEN 'Int64' THEN '11'
			WHEN 'UInt64' THEN '12'
			WHEN 'Single' THEN '13'
			WHEN 'Double' THEN '14'
			WHEN 'Decimal' THEN '15'
			WHEN 'Datetime' THEN '16'
			WHEN 'String' THEN '18'
			ELSE ''
		END

	SET @WorkTags = @BaseTags
	SET @WorkTags = REPLACE(@WorkTags, '{param}', @parameter_name)
	SET @WorkTags = REPLACE(@WorkTags, '{guid}', LOWER(NEWID()))
	SET @WorkTags = REPLACE(@WorkTags, '{value}', @parameter_value)
	SET @WorkTags = REPLACE(@WorkTags, '{type}', @use_datatype)

	SET @Params = @Params + @WorkTags

	FETCH NEXT FROM [proc_cursor] INTO @parameter_name, @parameter_datatype, @parameter_value
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];

SET @Params = '<?xml version="1.0"?>' + @Params + '</SSIS:Parameters>'

SET @Biml = CAST(@Params AS XML)







GO
/****** Object:  StoredProcedure [biml].[Build Single Project]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 14 Dec 2017
-- Modify date: 18 Dec 2017 - Added 'Register User' (JMM)
-- Modify date: 02 Feb 2018 - Do not update build template group on project build (Maja Kozar)
-- Description:	Build a single BIML Project
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Build Single Project]  'No Framework', 'EncryptSensitiveWithUserKey', 1;
*/
-- ================================================================================================

CREATE PROCEDURE [biml].[Build Single Project] ( 
	@template_group NVARCHAR(32), 
	@PackageProtectionOption  NVARCHAR(32), 
	@project_id AS INT )
AS

EXEC [biml].[Register User];

DECLARE @project_name    NVARCHAR(128)
	  , @environmentName NVARCHAR(32);

DECLARE @biml_project AS XML
	  , @biml_param   AS XML;


---------------------------------------------
-- Update All Projects
---------------------------------------------
DECLARE [proc_cursor_project] CURSOR FOR  
 SELECT [project_name]
   FROM [biml].[project]
   WHERE @project_id = [project_id]
	      OR @project_id = 0;
    
OPEN [proc_cursor_project]   
FETCH NEXT FROM [proc_cursor_project] INTO @project_name

WHILE @@FETCH_STATUS = 0   
BEGIN 

	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build All Projects - Project Biml'
		 , '@project_name: ' + @project_name);

	-- Get Project Biml
	EXEC [biml].[Build Project Full] @project_name, '', @PackageProtectionOption = @PackageProtectionOption, @Biml = @biml_project OUTPUT


	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build All Projects - Parameter Biml'
		 , '@project_name: ' + @project_name);

	-- Get Parameter Biml
	EXEC [biml].[Build Project Parameters] @project_name, '', @Biml = @biml_param OUTPUT

	UPDATE [biml].[project]
	   SET [project_xml]   = @biml_project
		 , [parameter_xml] = @biml_param
		 , [build_datetime] = GETDATE()
		-- , [build_template_group] = @template_group
	 WHERE [project_name] = @project_name

	FETCH NEXT FROM [proc_cursor_project] INTO @project_name

END;  

CLOSE [proc_cursor_project]; 
DEALLOCATE [proc_cursor_project];



---------------------------------------------
-- Update All Project Environments
---------------------------------------------
DECLARE [proc_cursor_param] CURSOR FOR  
 SELECT pr.[project_id]
	  , pr.[project_name]
      , pe.[environment_name]
   FROM [biml].[project_environment] pe
   JOIN [biml].[project] pr
     ON pr.[project_id] = pe.[project_id]
	WHERE @project_id = pr.[project_id] OR @project_id = 0;
	    
OPEN [proc_cursor_param]   
FETCH NEXT FROM [proc_cursor_param] INTO @project_id, @project_name, @environmentName

WHILE @@FETCH_STATUS = 0   
BEGIN 

	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build All Projects - Project Biml'
		 , '@project_name: ' + @project_name + ', @environmentName: ' + @environmentName);

	-- Get Project Biml
	EXEC [biml].[Build Project Full] @project_name, @environmentName, @PackageProtectionOption = @PackageProtectionOption, @Biml = @biml_project OUTPUT


	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Build All Projects - Parameter Biml'
		 , '@project_name: ' + @project_name + ', @environmentName: ' + @environmentName);

	-- Get Parameter Biml
	EXEC [biml].[Build Project Parameters] @project_name, @environmentName, @Biml = @biml_param OUTPUT

	UPDATE [biml].[project_environment]
	   SET [project_xml]   = @biml_project
		 , [parameter_xml] = @biml_param
		 , [build_datetime] = GETDATE()
		 --, [build_template_group] = @template_group
	 WHERE [project_id] = @project_id
	   AND [environment_name] = @environmentName

	FETCH NEXT FROM [proc_cursor_param] INTO @project_id, @project_name, @environmentName

END;  

CLOSE [proc_cursor_param]; 
DEALLOCATE [proc_cursor_param];


---------------------------------------------
-- Save all new queries built or referenced during this full build
---------------------------------------------

EXEC [biml].[Save Query History]
GO
/****** Object:  StoredProcedure [biml].[Build Templates]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 05 Aug 2016
-- Modify date: 09 Aug 2016 - Added No Alerts templates
-- Modify date: 27 Aug 2016 - Added No Framework templates
-- Modify date: 06 Sep 2016 - Added Author
-- Description:	Builds BIML Project Templates
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Build Templates]
*/
-- ================================================================================================

CREATE PROCEDURE [biml].[Build Templates]
AS

SET NOCOUNT ON

DELETE [biml].[template];

------------------------------------------------------------------------------
------- template_type: Standard
------------------------------------------------------------------------------

INSERT INTO [biml].[template]
           ([template_name]
		   ,[template_type]
		   ,[template_group]
		   ,[display_order]
		   ,[author_id]
		   ,[description]
           ,[template_xml])
     VALUES
           ( 'Standard'
		   , 'Standard'
		   , 'Standard'
		   , 100
		   , 1
		   , null
		   , [biml].[Package Template (Standard)]()
		   )

INSERT INTO [biml].[template]
           ([template_name]
		   ,[template_type]
		   ,[template_group]
		   ,[display_order]
		   ,[author_id]
		   ,[description]
           ,[template_xml])
     VALUES
           ( 'Standard No Alerts'
		   , 'Standard'
		   , 'No Alerts'
		   , 200
		   , 1
		   , null
		   , [biml].[Package Template (Standard No Alerts)]()
		   )

INSERT INTO [biml].[template]
           ([template_name]
		   ,[template_type]
		   ,[template_group]
		   ,[display_order]
		   ,[author_id]
		   ,[description]
           ,[template_xml])
     VALUES
           ( 'Standard No Framework'
		   , 'Standard'
		   , 'No Framework'
		   , 300
		   , 1
		   , null
		   , [biml].[Package Template (Standard No Framework)]()
		   )


------------------------------------------------------------------------------
------- template_type: Run All
------------------------------------------------------------------------------

INSERT INTO [biml].[template]
           ([template_name]
		   ,[template_type]
		   ,[template_group]
		   ,[display_order]
		   ,[author_id]
		   ,[description]
           ,[template_xml])
     VALUES
           ( 'Run All'
		   , 'Run All'
		   , 'Standard'
		   , 100
		   , 1
		   , null
		   , [biml].[Package Template (Run All)]()
		   )

INSERT INTO [biml].[template]
           ([template_name]
		   ,[template_type]
		   ,[template_group]
		   ,[display_order]
		   ,[author_id]
		   ,[description]
           ,[template_xml])
     VALUES
           ( 'Run All No Alerts'
		   , 'Run All'
		   , 'No Alerts'
		   , 200
		   , 1
		   , null
		   , [biml].[Package Template (Run All No Alerts)]()
		   )

INSERT INTO [biml].[template]
           ([template_name]
		   ,[template_type]
		   ,[template_group]
		   ,[display_order]
		   ,[author_id]
		   ,[description]
           ,[template_xml])
     VALUES
           ( 'Run All No Framework'
		   , 'Run All'
		   , 'No Framework'
		   , 300
		   , 1
		   , null
		   , [biml].[Package Template (Run All No Framework)]()
		   )


------------------------------------------------------------------------------
------- template_type: Group
------------------------------------------------------------------------------

INSERT INTO [biml].[template]
           ([template_name]
		   ,[template_type]
		   ,[template_group]
		   ,[display_order]
		   ,[author_id]
		   ,[description]
           ,[template_xml])
     VALUES
           ( 'Group'
		   , 'Group'
		   , 'Standard'
		   , 100
		   , 1
		   , null
		   , [biml].[Package Template (Group)]()
		   )

INSERT INTO [biml].[template]
           ([template_name]
		   ,[template_type]
		   ,[template_group]
		   ,[display_order]
		   ,[author_id]
		   ,[description]
           ,[template_xml])
     VALUES
           ( 'Group No Alerts'
		   , 'Group'
		   , 'No Alerts'
		   , 200
		   , 1
		   , null
		   , [biml].[Package Template (Group No Alerts)]()
		   )

INSERT INTO [biml].[template]
           ([template_name]
		   ,[template_type]
		   ,[template_group]
		   ,[display_order]
		   ,[author_id]
		   ,[description]
           ,[template_xml])
     VALUES
           ( 'Group No Framework'
		   , 'Group'
		   , 'No Framework'
		   , 300
		   , 1
		   , null
		   , [biml].[Package Template (Group No Framework)]()
		   )








GO
/****** Object:  StoredProcedure [biml].[Check Connection Name]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 18 Apr 2017
-- Modify date: 
-- Description:	Check if connection name is unique or not
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Check Connection Name] 'connection name'
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Check Connection Name]
(
	@connection_name nvarchar(64)
)
AS 

BEGIN

DECLARE @data_connection int, @ado_connection int, @smtp_connection int, @flat_connection int;

SET @data_connection = (SELECT COUNT([connection_name]) FROM [biml].[connection] WHERE [connection_name] = @connection_name);
SET @ado_connection = (SELECT COUNT([connection_name]) FROM [biml].[adonet_connection] WHERE [connection_name] = @connection_name);
SET @smtp_connection = (SELECT COUNT([connection_name]) FROM [biml].[smtp_connection] WHERE [connection_name] = @connection_name);
SET @flat_connection = (SELECT COUNT([connection_name]) FROM [biml].[flatfile_connection] WHERE [connection_name] = @connection_name);

SELECT @data_connection + @ado_connection + @smtp_connection + @flat_connection

END
GO
/****** Object:  StoredProcedure [biml].[Clone Execute Process Package]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 17 Nov 2017
-- Modify date: 
-- Description:	Clone Execute Process package
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Clone Execute Process Package] 
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Clone Execute Process Package]
(
	@package_qualifier nvarchar(64),
	@executable_expr nvarchar(1024),
	@arguments_expr nvarchar(max),
	@working_directory nvarchar(2048),
	@place_values_in_SSIS_Data nvarchar(1),	
	@old_package_qualifier nvarchar(64) = '',
	@old_package_name nvarchar(128) = '',
	@project_id INT = 0,
	@package_name nvarchar(128) = ''
)
AS 
BEGIN
	INSERT INTO [biml].[package_config (Execute Process)]
		([package_qualifier]
		,[executable_expr]
		,[arguments_expr]
		,[working_directory]
		,[place_values_in_SSIS_Data])
	VALUES
		(@package_qualifier
		,@executable_expr
		,@arguments_expr
		,@working_directory
		,@place_values_in_SSIS_Data)

	--check if "Dim Table Merge" generator is used
	IF ((SELECT COUNT([package_qualifier]) FROM [biml].[dim_table_merge_config (Standard)] WHERE [package_qualifier] = @old_package_qualifier) > 0)
		BEGIN
			INSERT INTO [biml].[dim_table_merge_config (Standard)]
				([stg_server]
				,[stg_database]
				,[stg_schema]
				,[dst_schema]
				,[stg_table]
				,[dst_table]
				,[stg_database_param_name]
				,[dst_database_param_name]
				,[package_qualifier]
				,[added_dim_column_names_id])
			SELECT [stg_server]
				,[stg_database]
				,[stg_schema]
				,[dst_schema]
				,[stg_table]
				,[dst_table]
				,[stg_database_param_name]
				,[dst_database_param_name]
				,@package_qualifier
				,[added_dim_column_names_id]
			FROM [biml].[dim_table_merge_config (Standard)]
			WHERE [package_qualifier] = @old_package_qualifier
		END

	--check if execute process variables
	IF ((SELECT COUNT([package_qualifier]) FROM [biml].[package_config (Execute Process) variable] WHERE [package_qualifier] = @old_package_qualifier) > 0)
		BEGIN
			INSERT INTO [biml].[package_config (Execute Process) variable]
				([package_qualifier]
				,[Name]
				,[DataType]
				,[EvaluateAsExpression]
				,[variable_value])
			SELECT @package_qualifier
				,[Name]
				,[DataType]
				,[EvaluateAsExpression]
				,[variable_value]
			FROM [biml].[package_config (Execute Process) variable]
			WHERE [package_qualifier] = @old_package_qualifier
		END

	--check if old package is added to the project or not. If yes new package needs to be added as well
	IF ((SELECT COUNT([project_id]) FROM [biml].[project_package] WHERE [package_name] = @old_package_name) > 0)
		BEGIN
			INSERT INTO [biml].[project_package]
				([project_id]
				,[sequence_number]
				,[package_name])
			VALUES
			   (@project_id
			   ,0
			   ,@package_name)
		END
END
GO
/****** Object:  StoredProcedure [biml].[Clone Execute Script Package]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 17 Nov 2017
-- Modify date: 
-- Description:	Clone Execute Script package
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Clone Execute Script Package] 1, 'connection', 'query', 'package qualifier'
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Clone Execute Script Package]
(
	@connection_manager nvarchar(64),
	@script_name nvarchar(64),
    @package_qualifier nvarchar(64),
	@return_row_count nvarchar(1),
	@old_package_qualifier nvarchar(64) = '',
	@package_name nvarchar(128) = '',
	@old_package_name nvarchar(128) = '',
	@project_id INT = 0
)
AS 
BEGIN
	INSERT INTO [biml].[package_config (Execute Script)]
		([connection_manager]
		,[script_name]
		,[package_qualifier]
		,[return_row_count])
	VALUES
		(@connection_manager
		,@script_name
		,@package_qualifier
		,@return_row_count)	

	--check execute script variable
	IF ((SELECT COUNT([package_qualifier]) FROM [biml].[package_config (Execute Script) variable] WHERE [package_qualifier] = @old_package_qualifier) > 0)
		BEGIN
			INSERT INTO [biml].[package_config (Execute Script) variable]
				([package_qualifier]
				,[Name]
				,[DataType]
				,[EvaluateAsExpression]
				,[variable_value])
			SELECT @package_qualifier
				,[Name]
				,[DataType]
				,[EvaluateAsExpression]
				,[variable_value]
			FROM [biml].[package_config (Execute Script) variable]
			WHERE [package_qualifier] = @old_package_qualifier
		END
	
	--check if old package is added to the project or not. If yes new package needs to be added as well
	IF ((SELECT COUNT([project_id]) FROM [biml].[project_package] WHERE [package_name] = @old_package_name) > 0)
		BEGIN
			INSERT INTO [biml].[project_package]
				([project_id]
				,[sequence_number]
				,[package_name])
			VALUES
			   (@project_id
			   ,0
			   ,@package_name)
		END
END
GO
/****** Object:  StoredProcedure [biml].[Clone Execute SQL Package]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 16 Nov 2017
-- Modify date: 10 Apr 2018 - change clone logic. Leave schema name unchanges, change table name with text 'enter table'
-- Description:	Clone Execute SQL package
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Clone Execute SQL Package] 1, 'connection', 'query', 'package qualifier'
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Clone Execute SQL Package]
(
	@connection_manager nvarchar(64),
	@query_expression nvarchar(max),
    @package_qualifier nvarchar(64),	
	@old_package_qualifier nvarchar(64) = '',
	@old_package_name nvarchar(128) = '',
	@project_id INT = 0,
	@package_name nvarchar(128) = '',
	@is_expression nvarchar(1),
	@return_row_count nvarchar(1)
)
AS 
BEGIN
	INSERT INTO [biml].[package_config (Execute SQL)]
		([connection_manager]
		,[package_qualifier]
		,[query]
		,[is_expression]
		,[return_row_count])
	VALUES
		(@connection_manager
		,@package_qualifier
		,@query_expression
		,@is_expression
		,@return_row_count)	

	--check if "Dim Table Merge" generator is used
	IF ((SELECT COUNT([package_qualifier]) FROM [biml].[dim_table_merge_config (Standard)] WHERE [package_qualifier] = @old_package_qualifier) > 0)
		BEGIN
			INSERT INTO [biml].[dim_table_merge_config (Standard)]
				([stg_server]
				,[stg_database]
				,[stg_schema]
				,[dst_schema]
				,[stg_table]
				,[dst_table]
				,[stg_database_param_name]
				,[dst_database_param_name]
				,[package_qualifier]
				,[added_dim_column_names_id])
			SELECT [stg_server]
				,[stg_database]
				,[stg_schema]
				,[dst_schema]
				,[stg_table]
				,[dst_table]
				,[stg_database_param_name]
				,[dst_database_param_name]
				,@package_qualifier
				,[added_dim_column_names_id]
			FROM [biml].[dim_table_merge_config (Standard)]
			WHERE [package_qualifier] = @old_package_qualifier
		END

	--check if "Fact Table Partition" generator is used
	IF ((SELECT COUNT([package_qualifier]) FROM [biml].[fact_table_partition_config (Standard)] WHERE [package_qualifier] = @old_package_qualifier) > 0)
		BEGIN
			DECLARE @id INT = (SELECT COUNT([package_qualifier]) FROM [biml].[fact_table_partition_config (Standard)] WHERE [package_qualifier] = @old_package_qualifier) + 1
			INSERT INTO [biml].[fact_table_partition_config (Standard)]
				([partition_scheme]
				,[partition_function]
				,[days_ahead]
				,[day_partitions]
				,[month_partitions]
				,[quarter_partitions]
				,[year_partitions]
				,[switch_in_schema_name]
				,[switch_in_table_name]
				,[truncate_switch_in_table]
				,[package_qualifier])
			SELECT [partition_scheme]
				,CONCAT( 'enter table', ' ', @id) 
				,[days_ahead]
				,[day_partitions]
				,[month_partitions]
				,[quarter_partitions]
				,[year_partitions]
				,[switch_in_schema_name]
				,[switch_in_table_name]
				,[truncate_switch_in_table]
				,@package_qualifier
			FROM [biml].[fact_table_partition_config (Standard)]
			WHERE [package_qualifier] = @old_package_qualifier
		END

	--check if "Fact Table Merge" generator is used
	IF ((SELECT COUNT([package_qualifier]) FROM [biml].[fact_table_merge_config (Basic)] WHERE [package_qualifier] = @old_package_qualifier) > 0)
		BEGIN
			INSERT INTO [biml].[fact_table_merge_config (Basic)]
				([stg_server]
				,[stg_database]
				,[dst_database]
				,[stg_schema]
				,[dst_schema]
				,[stg_table]
				,[dst_table]
				,[package_qualifier])
			SELECT [stg_server]
				,[stg_database]
				,[dst_database]
				,[stg_schema]
				,[dst_schema]
				,[stg_table]
				,[dst_table]
				,@package_qualifier
			FROM [biml].[fact_table_merge_config (Basic)]
			WHERE [package_qualifier] = @old_package_qualifier
		END

	--check if "Fact Table Switch" generator is used
	IF ((SELECT COUNT([package_qualifier]) FROM [biml].[fact_table_switch_config (Standard)] WHERE [package_qualifier] = @old_package_qualifier) > 0)
		BEGIN
			DECLARE @id1 INT = (SELECT COUNT([package_qualifier]) FROM [biml].[fact_table_switch_config (Standard)] WHERE [package_qualifier] = @old_package_qualifier) + 1
			INSERT INTO [biml].[fact_table_switch_config (Standard)]
				([src_schema_name]
				,[src_table_name]
				,[dst_schema_name]
				,[dst_table_name]
				,[out_schema_name]
				,[out_table_name]
				,[package_qualifier]
				,[switch_option]
				,[project_parameter])
			SELECT [src_schema_name]
				,CONCAT( 'enter table', ' ', @id1)
				,[dst_schema_name]
				,[dst_table_name]
				,[out_schema_name]
				,[out_table_name]
				,@package_qualifier
				,[switch_option]
				,[project_parameter]
			FROM [biml].[fact_table_switch_config (Standard)]
			WHERE [package_qualifier] = @old_package_qualifier
		END
			 
	--check if old package is added to the project or not. If yes new package needs to be added as well
	IF ((SELECT COUNT([project_id]) FROM [biml].[project_package] WHERE [package_name] = @old_package_name) > 0)
		BEGIN
			INSERT INTO [biml].[project_package]
				([project_id]
				,[sequence_number]
				,[package_name])
			VALUES
			   (@project_id
			   ,0
			   ,@package_name)
		END
END
GO
/****** Object:  StoredProcedure [biml].[Clone Project]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---- ================================================================================================
---- Author:		Maja Kozar (Software Developer)
---- Create date: 25 Dec 2017
---- Modify date: 
---- Description:	Clone project
----
---- Sample Execute Command: 
--/*	
--EXEC [biml].[Clone Project] 1, 'test@test.com', '314521E9-1D48-4060-8DAD-4B11C59C7A81' -- @tenant_id, @email_address, @subscription_key
--*/
---- ================================================================================================
CREATE PROCEDURE [biml].[Clone Project]
(
	@project_id int,
	@project_name nvarchar(128)
)
AS
BEGIN
	--copy project and sent new project it to the newly created value
	DECLARE @new_project_id INT;

	INSERT INTO [biml].[project]
           ([project_name]
           ,[project_xml]
           ,[parameter_xml]
           ,[build_datetime]
		   ,[build_template_group])
	SELECT  @project_name
           ,[project_xml]
           ,[parameter_xml]
           ,[build_datetime]
		   ,[build_template_group]
	FROM [biml].[project]
	WHERE [project_id] = @project_id;

	SET @new_project_id = SCOPE_IDENTITY();

	--clone Ado.Net connection
	INSERT INTO [biml].[project_adonet_connection] ([project_id],[connection_name])
	SELECT @new_project_id, [connection_name]
	FROM [biml].[project_adonet_connection]
	WHERE [project_id] = @project_id;

	--clone data connection
	INSERT INTO [biml].[project_connection] ([project_id],[connection_name])
	SELECT @new_project_id, [connection_name]
	FROM [biml].[project_connection]
	WHERE [project_id] = @project_id;

	--clone smtp connection
	INSERT INTO [biml].[project_smtp_connection] ([project_id],[connection_name])
	SELECT @new_project_id, [connection_name]
	FROM [biml].[project_smtp_connection]
	WHERE [project_id] = @project_id;

	--clone flat file cnnection
	INSERT INTO [biml].[project_flatfile_connection] ([project_id],[connection_name])
	SELECT @new_project_id, [connection_name]
	FROM [biml].[project_flatfile_connection]
	WHERE [project_id] = @project_id;

	--clone environemnts
	INSERT INTO [biml].[project_environment] 
		([project_id]
		,[environment_name]
        ,[project_xml]
        ,[parameter_xml]
        ,[build_datetime]
		,[build_template_group])
	SELECT	@new_project_id
			,[environment_name]
			,[project_xml]
			,[parameter_xml]
			,[build_datetime]
			,[build_template_group]
	FROM [biml].[project_environment]
	WHERE [project_id] = @project_id;

	--clone parameters
	INSERT INTO[biml].[project_parameter]  ([project_id], [parameter_name])
	SELECT @new_project_id, [parameter_name]
	FROM [biml].[project_parameter]
	WHERE [project_id] = @project_id;

	--clone package
	INSERT INTO [biml].[project_package] 
		([project_id]
		,[sequence_number]
        ,[package_name])
	SELECT	@new_project_id
			,[sequence_number]
			,[package_name]
	FROM [biml].[project_package]
	WHERE [project_id] = @project_id AND [sequence_number] <> -1;

	--clone package groupe
	INSERT INTO  [biml].[project_package_group]
		([project_id]
		,[sequence_number]
        ,[package_name])
	SELECT	@new_project_id
			,[sequence_number]
			,[package_name]
	FROM [biml].[project_package_group]
	WHERE [project_id] = @project_id;
	
	--clone script tasks
	INSERT INTO [biml].[project_script_task] ([project_id],[script_name])
	SELECT @new_project_id, [script_name]
	FROM [biml].[project_script_task]
	WHERE [project_id] = @project_id;

END
GO
/****** Object:  StoredProcedure [biml].[Delete Project]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 21 Nov 2017
-- Modify date: 
-- Description:	Delete project and all project connection items 
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Delete Project] 'project name'
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Delete Project]
(
	@project_name nvarchar(128)
)
AS 
BEGIN
	--get project Id for selected project
	DECLARE @projec_id INT = (SELECT [project_id] FROM [biml].[project] WHERE [project_name] = @project_name);

	-- delete record from [biml].[project] table
	DELETE FROM [biml].[project] WHERE [project_name] = @project_name;

	--delete record from [biml].[project_adonet_connection]
	DELETE FROM [biml].[project_adonet_connection] WHERE [project_id] = @projec_id;

	--delete record from [biml].[project_connection]
	DELETE FROM [biml].[project_connection] WHERE [project_id] = @projec_id;

	--delete record from [biml].[project_environment]
	DELETE FROM [biml].[project_environment] WHERE [project_id] = @projec_id;

	--delete record from [biml].[project_flatfile_connection]
	DELETE FROM [biml].[project_flatfile_connection] WHERE [project_id] = @projec_id;

	--delete record from [biml].[project_package]
	DELETE FROM [biml].[project_package] WHERE [project_id] = @projec_id;

	--delete record from [biml].[project_package_group]
	DELETE FROM [biml].[project_package_group] WHERE [project_id] = @projec_id;

	--delete record from [biml].[project_parameter]
	DELETE FROM [biml].[project_parameter] WHERE [project_id] = @projec_id;

	--delete record from [biml].[project_script_task]
	DELETE FROM [biml].[project_script_task] WHERE [project_id] = @projec_id;

	--delete record from [biml].[project_smtp_connection]
	DELETE FROM [biml].[project_smtp_connection] WHERE [project_id] = @projec_id;
END
GO
/****** Object:  StoredProcedure [biml].[Deleted Projects Clean Up]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 06 Dec 2016
-- Modify date: 
-- Description:	Will clean-up related tables (orphaned rows) when a project ID has been Deleted
--
-- Sample Execute Command: 
/*	
[biml].[Deleted Projects Clean Up]
*/
-- ================================================================================================

CREATE PROCEDURE [biml].[Deleted Projects Clean Up]
AS


DELETE [biml].[project_connection]
  FROM [biml].[project_connection] pb
  LEFT JOIN [biml].[project] pr
    ON pr.[project_id] = pb.[project_id]
 WHERE pr.[project_id] IS NULL

DELETE [biml].[project_environment]
  FROM [biml].[project_environment] pb
  LEFT JOIN [biml].[project] pr
    ON pr.[project_id] = pb.[project_id]
 WHERE pr.[project_id] IS NULL

DELETE [biml].[project_package]
  FROM [biml].[project_package] pb
  LEFT JOIN [biml].[project] pr
    ON pr.[project_id] = pb.[project_id]
 WHERE pr.[project_id] IS NULL

DELETE [biml].[project_package_group]
  FROM [biml].[project_package_group] pb
  LEFT JOIN [biml].[project] pr
    ON pr.[project_id] = pb.[project_id]
 WHERE pr.[project_id] IS NULL

DELETE [biml].[project_parameter]
  FROM [biml].[project_parameter] pb
  LEFT JOIN [biml].[project] pr
    ON pr.[project_id] = pb.[project_id]
 WHERE pr.[project_id] IS NULL

DELETE [biml].[project_smtp_connection]
  FROM [biml].[project_smtp_connection] pb
  LEFT JOIN [biml].[project] pr
    ON pr.[project_id] = pb.[project_id]
 WHERE pr.[project_id] IS NULL






GO
/****** Object:  StoredProcedure [biml].[Insert Dim Table Merge Config]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 12 Oct 2017
-- Modify date: 
-- Description:	Insert or Upate Dim Table Merge Config table row
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Insert Dim Table Merge Config] 
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Insert Dim Table Merge Config]
( 
	@stg_server nvarchar(128),
	@stg_database nvarchar(128),
	@stg_schema nvarchar(128),
	@dst_schema nvarchar(128),
	@stg_table nvarchar(128),
	@dst_table nvarchar(128),
	@stg_database_param_name nvarchar(128),
	@dst_database_param_name nvarchar(128),
	@package_qualifier nvarchar(64),
	@added_dim_column_names_id int
)
AS 
BEGIN
	-- check if row exists in table. If yes update existing row, if not create new
	IF((SELECT COUNT([package_qualifier]) FROM [biml].[dim_table_merge_config (Standard)] WHERE [package_qualifier] = @package_qualifier) > 0)
		BEGIN
			UPDATE [biml].[dim_table_merge_config (Standard)]
			SET [stg_server] = @stg_server
				,[stg_database] = @stg_database
				,[stg_schema] = @stg_schema
				,[dst_schema] = @dst_schema
				,[stg_table] = @stg_table
				,[dst_table] = @dst_table
				,[stg_database_param_name] = @stg_database_param_name
				,[dst_database_param_name] = @dst_database_param_name
				,[added_dim_column_names_id] = @added_dim_column_names_id
			WHERE [package_qualifier] = @package_qualifier
		END
	ELSE
		BEGIN
			INSERT INTO [biml].[dim_table_merge_config (Standard)]
				   ([stg_server]
				   ,[stg_database]
				   ,[stg_schema]
				   ,[dst_schema]
				   ,[stg_table]
				   ,[dst_table]
				   ,[stg_database_param_name]
				   ,[dst_database_param_name]
				   ,[package_qualifier]
				   ,[added_dim_column_names_id])
			 VALUES
				   (@stg_server
				   ,@stg_database
				   ,@stg_schema
				   ,@dst_schema
				   ,@stg_table
				   ,@dst_table
				   ,@stg_database_param_name
				   ,@dst_database_param_name
				   ,@package_qualifier
				   ,@added_dim_column_names_id)
		END
END

/****** Object:  StoredProcedure [biml].[Insert Dim Table Merge Config]    Script Date: 10/12/2017 4:10:49 AM ******/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [biml].[Insert Environment]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Ena Jukic (Software Developer)
-- Create date: 08 Apr 2017
-- Modify date: 7 Sep 2017 Modified for usage of desktop application
-- Description:	Insert Environment
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Insert Environment] 'environment name test'
-- @environment_name
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Insert Environment]
(
	@environment_name nvarchar(128)
)
AS 
BEGIN
INSERT INTO [biml].[environment]
    ([environment_name])
VALUES
    (@environment_name)		
END
GO
/****** Object:  StoredProcedure [biml].[Insert Execute Process Variable]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 23 Oct 2017
-- Modify date: 
-- Description:	Insert or Update Execute Process Variable table row
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Insert Execute Process Variable] 
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Insert Execute Process Variable]
( 
	@package_qualifier nvarchar(64),
	@Name nvarchar(128),
	@DataType nvarchar(32),
	@EvaluateAsExpression nvarchar(5),
	@variable_value nvarchar(max)
)
AS 
BEGIN
	-- check if row exists in table. If yes update existing row, if not create new
	IF((SELECT COUNT([package_qualifier]) FROM [biml].[package_config (Execute Process) variable] WHERE [package_qualifier] = @package_qualifier AND [Name] = @Name) > 0)
		BEGIN
			UPDATE [biml].[package_config (Execute Process) variable]
			SET [DataType] = @DataType
				,[EvaluateAsExpression] = @EvaluateAsExpression
				,[variable_value] = @variable_value
			WHERE [package_qualifier] = @package_qualifier AND [Name] = @Name
		END
	ELSE
		BEGIN
			INSERT INTO [biml].[package_config (Execute Process) variable]
				   ([package_qualifier]
				   ,[Name]
				   ,[DataType]
				   ,[EvaluateAsExpression]
				   ,[variable_value])
			 VALUES
				   (@package_qualifier
				   ,@Name
				   ,@DataType
				   ,@EvaluateAsExpression
				   ,@variable_value)
		END
END
GO
/****** Object:  StoredProcedure [biml].[Insert Fact Table Merge Basic]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 12 Oct 2017
-- Modify date: 
-- Description:	Insert or Upate Fact Table Merge Basic table row
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Insert Fact Table Merge Basic] 
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Insert Fact Table Merge Basic]
( 
	@stg_server nvarchar(128),
	@stg_database nvarchar(128),
	@stg_schema nvarchar(128),
	@dst_schema nvarchar(128),
	@stg_table nvarchar(128),
	@dst_table nvarchar(128),
	@dst_database nvarchar(128),
	@package_qualifier nvarchar(64)
)
AS 
BEGIN
	-- check if row exists in table. If yes update existing row, if not create new
	IF((SELECT COUNT([package_qualifier]) FROM [biml].[fact_table_merge_config (Basic)] WHERE [package_qualifier] = @package_qualifier) > 0)
		BEGIN
			UPDATE [biml].[fact_table_merge_config (Basic)]
			SET [stg_server] = @stg_server
				,[stg_database] = @stg_database
				,[dst_database] = @dst_database
				,[stg_schema] = @stg_schema
				,[dst_schema] = @dst_schema
				,[stg_table] = @stg_table
				,[dst_table] = @dst_table
			WHERE [package_qualifier] = @package_qualifier
		END
	ELSE
		BEGIN
			INSERT INTO [biml].[fact_table_merge_config (Basic)]
				   ([stg_server]
				   ,[stg_database]
				   ,[dst_database]
				   ,[stg_schema]
				   ,[dst_schema]
				   ,[stg_table]
				   ,[dst_table]
				   ,[package_qualifier])
			 VALUES
				   (@stg_server
				   ,@stg_database
				   ,@dst_database
				   ,@stg_schema
				   ,@dst_schema
				   ,@stg_table
				   ,@dst_table
				   ,@package_qualifier)
		END
END
GO
/****** Object:  StoredProcedure [biml].[Insert Fact Table Partition Standard]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 12 Oct 2017
-- Modify date: 
-- Description:	Insert or Update Fact Table Partition Standard table row
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Insert Fact Table Partition Standard] 
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Insert Fact Table Partition Standard]
( 
	@partition_scheme nvarchar(128),
	@partition_function nvarchar(128),
	@days_ahead int,
	@day_partitions int,
	@month_partitions int,
	@quarter_partitions int,
	@year_partitions int,
	@switch_in_schema_name nvarchar(128),
	@switch_in_table_name nvarchar(128),
	@truncate_switch_in_table nvarchar(1),
	@package_qualifier nvarchar(64)
)
AS 
BEGIN
	-- check if row exists in table. If yes update existing row, if not create new
	IF((SELECT COUNT([package_qualifier]) FROM [biml].[fact_table_partition_config (Standard)] WHERE [package_qualifier] = @package_qualifier) > 0)
		BEGIN
			UPDATE [biml].[fact_table_partition_config (Standard)]
			SET [partition_scheme] = @partition_scheme
				,[partition_function] = @partition_function
				,[days_ahead] = @days_ahead
				,[day_partitions] = @day_partitions
				,[month_partitions] = @month_partitions
				,[quarter_partitions] = @quarter_partitions
				,[year_partitions] = @year_partitions
				,[switch_in_schema_name] = @switch_in_schema_name
				,[switch_in_table_name] = @switch_in_table_name
				,[truncate_switch_in_table] = @truncate_switch_in_table
			WHERE [package_qualifier] = @package_qualifier
		END
	ELSE
		BEGIN
			INSERT INTO [biml].[fact_table_partition_config (Standard)]
				   ([partition_scheme]
				   ,[partition_function]
				   ,[days_ahead]
				   ,[day_partitions]
				   ,[month_partitions]
				   ,[quarter_partitions]
				   ,[year_partitions]
				   ,[switch_in_schema_name]
				   ,[switch_in_table_name]
				   ,[truncate_switch_in_table]
				   ,[package_qualifier])
			 VALUES
				   (@partition_scheme
				   ,@partition_function
				   ,@days_ahead
				   ,@day_partitions
				   ,@month_partitions
				   ,@quarter_partitions
				   ,@year_partitions
				   ,@switch_in_schema_name
				   ,@switch_in_table_name
				   ,@truncate_switch_in_table
				   ,@package_qualifier)
		END
END

/****** Object:  StoredProcedure [biml].[Insert Fact Table Partition Standard]    Script Date: 10/12/2017 4:10:49 AM ******/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [biml].[Insert Fact Table Switch Standard]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 12 Oct 2017
-- Modify date: 
-- Description:	Insert or Update Fact Table Switch Standard table row
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Insert Fact Table Switch Standard] 
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Insert Fact Table Switch Standard]
( 
	@src_schema_name nvarchar(128),
	@src_table_name nvarchar(128),
	@dst_schema_name nvarchar(128),
	@dst_table_name nvarchar(128),
	@out_schema_name nvarchar(128),
	@out_table_name nvarchar(128),
	@package_qualifier nvarchar(64),
	@switch_option int,
	@project_parameter nvarchar(128)
)
AS 
BEGIN
	-- check if row exists in table. If yes update existing row, if not create new
	IF((SELECT COUNT([package_qualifier]) FROM [biml].[fact_table_switch_config (Standard)] WHERE [package_qualifier] = @package_qualifier) > 0)
		BEGIN
			UPDATE [biml].[fact_table_switch_config (Standard)]
			SET [src_schema_name] = @src_schema_name
				,[src_table_name] = @src_table_name
				,[dst_schema_name] = @dst_schema_name
				,[dst_table_name] = @dst_table_name
				,[out_schema_name] = @out_schema_name
				,[out_table_name] = @out_table_name
				,[switch_option] = @switch_option
				,[project_parameter] = @project_parameter
			WHERE [package_qualifier] = @package_qualifier
		END
	ELSE
		BEGIN
			INSERT INTO [biml].[fact_table_switch_config (Standard)]
				   ([src_schema_name]
				   ,[src_table_name]
				   ,[dst_schema_name]
				   ,[dst_table_name]
				   ,[out_schema_name]
				   ,[out_table_name]
				   ,[package_qualifier]
				   ,[switch_option]
				   ,[project_parameter])
			 VALUES
				   (@src_schema_name
				   ,@src_table_name
				   ,@dst_schema_name
				   ,@dst_table_name
				   ,@out_schema_name
				   ,@out_table_name
				   ,@package_qualifier
				   ,@switch_option
				   ,@project_parameter)
		END
END
GO
/****** Object:  StoredProcedure [biml].[Insert or Update (Execute Script) Variable]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Ena Jukic (Software Developer)
-- Create date: 10/23/2017
-- Modify date: 
-- Description:	Insert or Update (Execute Script) Variable
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Insert or Update (Execute Script) Variable] 'Test qualifier', 'Test Name', 'Byte', 'false', 'SELECT * FROM '
--@package_qualifier, @var_name ,@datatype ,@evaluate_as_expression ,@var_value
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Insert or Update (Execute Script) Variable]
( 
    @package_qualifier nvarchar(64),
	@var_name nvarchar(128),
	@datatype nvarchar(32),
	@evaluate_as_expression nvarchar(5),
	@var_value nvarchar(max)	
)
AS 
BEGIN
	IF ((SELECT COUNT([Name]) FROM [biml].[package_config (Execute Script) variable] WHERE [Name] = @var_name AND [package_qualifier] = @package_qualifier) > 0)
	BEGIN
	UPDATE [biml].[package_config (Execute Script) variable]
	SET [DataType] = @datatype
		,[EvaluateAsExpression] = @evaluate_as_expression
		,[variable_value] = @var_value
	WHERE [Name] = @var_name AND [package_qualifier] = @package_qualifier
	END
ELSE
	BEGIN
	INSERT INTO [biml].[package_config (Execute Script) variable]
           ([package_qualifier]
			,[Name]
			,[DataType]
			,[EvaluateAsExpression]
			,[variable_value])
     VALUES
           (@package_qualifier
		   ,@var_name
           ,@datatype
           ,@evaluate_as_expression
           ,@var_value)
	END
END
GO
/****** Object:  StoredProcedure [biml].[Insert or Update AdoNet Connection]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Ena Jukic (Software Developer)
-- Create date: 08 Sep 2017
-- Modify date: 
--				
-- Description:	Insert or Update AdoNet Connection
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Insert or Update AdoNet Connection] ('test connection', 'server name' )
-- @connection_name, @server_name
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Insert or Update AdoNet Connection]
(
	@connection_name nvarchar(64),
	@provider_name nvarchar(512),
	@connect_string nvarchar(1024),
	@database_name nvarchar(128),
	@project_id int = 0
)
AS 
BEGIN
IF ((SELECT COUNT([connection_name]) FROM [biml].[adonet_connection] WHERE [connection_name] = @connection_name) > 0)
	BEGIN
	UPDATE [biml].[adonet_connection]
	SET 
		[connection_name] = @connection_name,
		[provider] = @provider_name,
		[connect_string] = @connect_string,
		[database_name] = @database_name
	WHERE [connection_name] = @connection_name
	END
ELSE
	BEGIN
		INSERT INTO [biml].[adonet_connection]
			   ([connection_name]
			   ,[provider]
			   ,[connect_string]
			   ,[database_name])
		 VALUES
			   (@connection_name
			   ,@provider_name
			   ,@connect_string
			   ,@database_name)

		-- place new connection into [biml].[project_adonet_connection] if a project_id was provided
		IF ISNULL(@project_id, 0) <> 0
			BEGIN
				IF NOT EXISTS (SELECT 1 FROM [biml].[project_adonet_connection] WHERE [project_id] = @project_id AND [connection_name] = @connection_name)
					BEGIN
						INSERT [biml].[project_adonet_connection]
								( [project_id]
								, [connection_name]
								)
						VALUES
								( @project_id
								, @connection_name
								)
					END
			END
	END
END
GO
/****** Object:  StoredProcedure [biml].[Insert or Update Connection]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 04 Apr 2017
-- Modify date: 11 May 2017 (JMM) Added auto-insert into [biml].[project_connection]
--				07 Sep 2017 (Ena) Modified for usage of desktop application
-- Description:	Insert or Update Connection
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Insert or Update Connection] 'test connection', 'server name', 'DB Name', 'provider', 'connection string'
-- @connection_name, @server_name, @database_name, @provider, @custom_connect_string
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Insert or Update Connection]
(
	@connection_name nvarchar(64),
	@server_name nvarchar(128),
    @database_name nvarchar(128),
    @provider nvarchar(64),
    @custom_connect_string nvarchar(1024),
	@project_id int = 0
)
AS 

BEGIN

IF ((SELECT COUNT([connection_name]) FROM [biml].[connection] WHERE [connection_name] = @connection_name) > 0)
	BEGIN
	UPDATE [biml].[connection]
	SET 
		[server_name] = @server_name, 
		[database_name] = @database_name, 
		[provider] = @provider,
		[custom_connect_string] = @custom_connect_string
	WHERE [connection_name] = @connection_name
	END
ELSE
	BEGIN
		INSERT INTO [biml].[connection]
			   ([connection_name]
			   ,[server_name]
			   ,[database_name]
			   ,[provider]
			   ,[custom_connect_string])
		 VALUES
			   (@connection_name
			   ,@server_name
			   ,@database_name
			   ,@provider
			   ,@custom_connect_string)

		-- place new connection into [biml].[project_connection] if a project_id was provided
		IF ISNULL(@project_id, 0) <> 0
			BEGIN
				IF NOT EXISTS (SELECT 1 FROM [biml].[project_connection] WHERE [project_id] = @project_id AND [connection_name] = @connection_name)
					BEGIN
						INSERT [biml].[project_connection]
								( [project_id]
								, [connection_name]
								)
						VALUES
								( @project_id
								, @connection_name
								)
					END
			END

	END
END
GO
/****** Object:  StoredProcedure [biml].[Insert or Update Environment Parameter]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Ena Jukic (Software Developer)
-- Create date: 29 Sep 2017
-- Modify date: 
-- Description:	Insert or Update Environment Parameter
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Insert or Update Environment Parameter] 'Env Param Test', 'parameter name', 'test value UPDATE'
-- @environment_name, @parameter_name, @parameter_value
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Insert or Update Environment Parameter]
(
	@environment_name nvarchar(128),
	@parameter_name nvarchar(128),
	@parameter_value nvarchar(128)
)
AS 
BEGIN

IF ((SELECT COUNT([environment_name]) FROM [biml].[environment_parameter] WHERE [environment_name] = @environment_name) > 0)
	BEGIN
	UPDATE [biml].[environment_parameter]
	SET 
		[parameter_value] = @parameter_value
	WHERE [environment_name] = @environment_name
	END
ELSE
	BEGIN
	INSERT INTO [biml].[environment_parameter]
		([environment_name]
		,[parameter_name]
		,[parameter_value])
	VALUES
		(@environment_name
		,@parameter_name
		,@parameter_value)		
	END
END
GO
/****** Object:  StoredProcedure [biml].[Insert or Update Flat Connection]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Ena Jukic (Software Developer)
-- Create date: 08 Sep 2017
-- Modify date: 
--				
-- Description:	Insert or Update Flat  Connection
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Insert or Update Flat Connection] ('test connection', 'file path', 'file format' )
-- @connection_name, @file_path, @file_format
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Insert or Update Flat Connection]
(
	@connection_name nvarchar(64),
	@file_path nvarchar(512),
	@file_format nvarchar(128),
	@project_id int = 0
)
AS 
BEGIN
IF ((SELECT COUNT([connection_name]) FROM [biml].[flatfile_connection] WHERE [connection_name] = @connection_name) > 0)
	BEGIN
	UPDATE [biml].[flatfile_connection]
	SET 
		[connection_name] = @connection_name,
		[file_path] = @file_path,
		[file_format] = @file_format
	WHERE [connection_name] = @connection_name
	END
ELSE
	BEGIN
		INSERT INTO [biml].[flatfile_connection]
			   ([connection_name]
			   ,[file_path]
			   ,[file_format])
		 VALUES
			   (@connection_name
			   ,@file_path
			   ,@file_format)

		-- place new connection into [biml].[project_flatfile_connection] if a project_id was provided
		IF ISNULL(@project_id, 0) <> 0
			BEGIN
				IF NOT EXISTS (SELECT 1 FROM [biml].[project_flatfile_connection] WHERE [project_id] = @project_id AND [connection_name] = @connection_name)
					BEGIN
						INSERT [biml].[project_flatfile_connection]
								( [project_id]
								, [connection_name]
								)
						VALUES
								( @project_id
								, @connection_name
								)
					END
			END
	END
END
GO
/****** Object:  StoredProcedure [biml].[Insert or Update Flat File Column Alias]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Ena Jukic (Software Developer)
-- Create date: 29 Sep 2017
-- Modify date: 30 Nov 2017 - Maja Kozar - Fix bug fix. SP throws an error on update
-- Description:	Insert or Update Flat File Column Alias
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Insert or Update Flat File Column Alias] 'SCOPE', 'schema name', 'scp', 'use expr UPDATE'
-- @scope, @schema_name, @alias_name, @use_expression
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Insert or Update Flat File Column Alias]
(
	@scope nvarchar(128),
	@schema_name nvarchar(128),
	@alias_name nvarchar(128),
	@use_expression nvarchar(128)
)
AS 
BEGIN

IF ((SELECT COUNT([scope]) FROM [biml].[column_alias] WHERE [scope] = @scope AND [schema_name] = @schema_name AND [alias_name] = @alias_name) > 0)
	BEGIN
	UPDATE [biml].[column_alias]
	SET 
		[use_expression] = @use_expression
	WHERE [scope] = @scope AND [schema_name] = @schema_name AND [alias_name] = @alias_name
	END
ELSE
	BEGIN
	INSERT INTO [biml].[column_alias]
		([scope]
		,[schema_name]
		,[alias_name]
		,[use_expression])
	VALUES
		(@scope
		,@schema_name
		,@alias_name
		,@use_expression)		
	END
END
GO
/****** Object:  StoredProcedure [biml].[Insert or Update Flat File Format]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Ena Jukic (Software Developer)
-- Create date: 29 Sep 2017
-- Modify date: 
-- Description:	Insert or Update Flat File Format
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Insert or Update Flat File Format] 'XXXX test', '1252', 'Comma', 'CRLF', '_x0022_', 'false', 'false', 'EnaPC UPDATE', 'test 1', 'test 2', 'test 3'
-- @file_name, @code_page, @column_delimiter, @row_delimiter, @text_qualifier, @col_name_first_row, @is_unicode,
-- @metadata_server_name, @metadata_db_name, @metadata_schema_name, @metadata_table_name
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Insert or Update Flat File Format]
(
	@file_name nvarchar(128),
	@code_page nvarchar(128),
	@column_delimiter nvarchar(128),
	@row_delimiter nvarchar(128),
	@text_qualifier nvarchar(128),
	@col_name_first_row nvarchar(128),
	@is_unicode nvarchar(128),
	@metadata_server_name nvarchar(128),
	@metadata_db_name nvarchar(128),
	@metadata_schema_name nvarchar(128),
	@metadata_table_name nvarchar(128)
)
AS 
BEGIN

IF ((SELECT COUNT([file_format]) FROM [biml].[flatfile_format] WHERE [file_format] = @file_name) > 0)
	BEGIN
	UPDATE [biml].[flatfile_format]
	SET 
		[code_page] = @code_page,
		[column_delimiter] = @column_delimiter,
		[row_delimiter] = @row_delimiter,
		[text_qualifer] = @text_qualifier,
		[ColumnNamesInFirstDataRow] = @col_name_first_row,
		[IsUnicode] = @is_unicode,
		[metadata_server] = @metadata_server_name,
		[metadata_database] = @metadata_db_name,
		[metadata_schema] = @metadata_schema_name,
		[metadata_table] = @metadata_table_name
	WHERE [file_format] = @file_name
	END
ELSE
	BEGIN
	INSERT INTO [biml].[flatfile_format]
		([file_format]
		,[code_page]
		,[column_delimiter]
		,[row_delimiter]
		,[text_qualifer]
		,[ColumnNamesInFirstDataRow]
		,[IsUnicode]
		,[metadata_server]
		,[metadata_database]
		,[metadata_schema]
		,[metadata_table])
	VALUES
		(@file_name
		,@code_page
		,@column_delimiter
		,@row_delimiter
		,@text_qualifier
		,@col_name_first_row
		,@is_unicode
		,@metadata_server_name
		,@metadata_db_name
		,@metadata_schema_name
		,@metadata_table_name)		
	END
END
GO
/****** Object:  StoredProcedure [biml].[Insert or Update Parameter]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Ena Jukic (Software Developer)
-- Create date: 05 Apr 2017
-- Modify date: 29 Sep 2017 Modified for usage of desktop application
-- Description:	Insert or Update Parameter
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Insert or Update Parameter] 'KKKKKK', 'Datatype', 'Value',  1
-- @project_id, @parameter_name, @parameter_datatype, @parameter_value
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Insert or Update Parameter]
(
	@parameter_name varchar(128),
	@parameter_datatype varchar(32),
    @parameter_value varchar(512),
	@project_id int = 0
)
AS 
BEGIN
IF((SELECT COUNT([parameter_name]) FROM [biml].[parameter] WHERE [parameter_name] = @parameter_name) > 0)
	BEGIN
		UPDATE [biml].[parameter] 
		SET 
			[parameter_datatype] = @parameter_datatype, 
			[parameter_value] = @parameter_value
		WHERE [parameter_name] = @parameter_name
	END
ELSE
	BEGIN
		INSERT INTO [biml].[parameter]
			   ([parameter_name]
			   ,[parameter_datatype]
			   ,[parameter_value])
		 VALUES
			   (@parameter_name
			   ,@parameter_datatype
			   ,@parameter_value)

		-- place new parameter into [biml].[project_parameter] if a project_id was provided
		IF ISNULL(@project_id, 0) <> 0
			BEGIN
				IF NOT EXISTS (SELECT 1 FROM [biml].[project_parameter] WHERE [project_id] = @project_id AND [parameter_name] = @parameter_name)
					BEGIN
						INSERT [biml].[project_parameter]
								( [project_id]
								, [parameter_name]
								)
						VALUES
								( @project_id
								, @parameter_name
								)
					END
			END
	END
END
GO
/****** Object:  StoredProcedure [biml].[Insert or Update SMTP Connection]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 05 Apr 2017
-- Modify date: 11 May 2017 (JMM) Added auto-insert into [biml].[project_smtp_connection]
--				07 Sep 2017 (Ena) Modified for usage of desktop application
-- Description:	Insert or Update SMTP Connection
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Insert or Update SMTP Connection] ('test connection', 'server name' )
-- @connection_name, @server_name
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Insert or Update SMTP Connection]
(
	@connection_name nvarchar(64),
	@server_name nvarchar(128),
	@project_id int = 0
)
AS 
BEGIN
IF ((SELECT COUNT([connection_name]) FROM [biml].[smtp_connection] WHERE [connection_name] = @connection_name) > 0)
	BEGIN
	UPDATE [biml].[smtp_connection]
	SET 
		[server_name] = @server_name
	WHERE [connection_name] = @connection_name
	END
ELSE
	BEGIN
		INSERT INTO [biml].[smtp_connection]
			   ([connection_name]
			   ,[server_name])
		 VALUES
			   (@connection_name
			   ,@server_name)

		-- check if 'Admin_Sendmail_From' parameter existi if not create it
		IF NOT EXISTS (SELECT 1 FROM [biml].[parameter] WHERE [parameter_name] = 'Admin_Sendmail_From')
			BEGIN
				INSERT INTO [biml].[parameter]
					([parameter_name]
					,[parameter_datatype]
					,[parameter_value])
				VALUES
					('Admin_Sendmail_From'
					,'String'
					,'email@here.com')
			END

		-- check if 'Admin_Error_Sendmail_To' parameter existi if not create it
		IF NOT EXISTS (SELECT 1 FROM [biml].[parameter] WHERE [parameter_name] = 'Admin_Error_Sendmail_To')
			BEGIN
				INSERT INTO [biml].[parameter]
					([parameter_name]
					,[parameter_datatype]
					,[parameter_value])
				VALUES
					('Admin_Error_Sendmail_To'
					,'String'
					,'email@here.com')
			END

		-- check if 'Admin_Sendmail_To' parameter existi if not create it
		IF NOT EXISTS (SELECT 1 FROM [biml].[parameter] WHERE [parameter_name] = 'Admin_Sendmail_To')
			BEGIN
				INSERT INTO [biml].[parameter]
					([parameter_name]
					,[parameter_datatype]
					,[parameter_value])
				VALUES
					('Admin_Sendmail_To'
					,'String'
					,'email@here.com')
			END
		
		-- place new connection into [biml].[project_smtp_connection] if a project_id was provided
		IF ISNULL(@project_id, 0) <> 0
			BEGIN
				-- add connection to the project
				IF NOT EXISTS (SELECT 1 FROM [biml].[project_smtp_connection] WHERE [project_id] = @project_id AND [connection_name] = @connection_name)
					BEGIN
						INSERT [biml].[project_smtp_connection]
								( [project_id]
								, [connection_name]
								)
						VALUES
								( @project_id
								, @connection_name
								)
					END

				-- add Admin_Sendmail_From paraameter to the project
				IF NOT EXISTS (SELECT 1 from [biml].[project_parameter] WHERE [project_id] = @project_id AND [parameter_name] = 'Admin_Sendmail_From')
					BEGIN
						INSERT INTO [biml].[project_parameter]
							([project_id]
							,[parameter_name])
						VALUES
							(@project_id
							,'Admin_Sendmail_From')
					END

				-- add Admin_Error_Sendmail_To paraameter to the project
				IF NOT EXISTS (SELECT 1 from [biml].[project_parameter] WHERE [project_id] = @project_id AND [parameter_name] = 'Admin_Error_Sendmail_To')
					BEGIN
						INSERT INTO [biml].[project_parameter]
							([project_id]
							,[parameter_name])
						VALUES
							(@project_id
							,'Admin_Error_Sendmail_To')
					END

				-- add Admin_Sendmail_To paraameter to the project
				IF NOT EXISTS (SELECT 1 from [biml].[project_parameter] WHERE [project_id] = @project_id AND [parameter_name] = 'Admin_Sendmail_To')
					BEGIN
						INSERT INTO [biml].[project_parameter]
							([project_id]
							,[parameter_name])
						VALUES
							(@project_id
							,'Admin_Sendmail_To')
					END
			END
	END
END
GO
/****** Object:  StoredProcedure [biml].[Insert Project Package Rows]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 23 May 2016
-- Modify date: 
-- Description:	Insert missing project package rows
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Insert Project Package Rows] 1 -- @project_id
*/
-- ================================================================================================

CREATE PROCEDURE [biml].[Insert Project Package Rows]
(
	    @project_id AS INT = -1
)
AS
BEGIN

IF @project_id = -1
	BEGIN
		PRINT 'Must provide a project_id'
		RETURN
	END


-- remove biml.project_package rows without cooresponding package in biml.package
DELETE [biml].[project_package]
  FROM [biml].[project_package] AS m
  JOIN 
		(
		SELECT [package_name]
		  FROM [biml].[project_package]

		EXCEPT

		SELECT [package_name]
		  FROM [biml].[package]
		) AS d
    ON d.[package_name] = m.[package_name]


-- insert new package rows into biml.project_package
INSERT [biml].[project_package]
     ( [project_id]
     , [package_name]
	 )
SELECT @project_id
	 , [package_name]
  FROM [biml].[package]

EXCEPT

SELECT @project_id
	 , [package_name]
  FROM [biml].[project_package]




END











GO
/****** Object:  StoredProcedure [biml].[Primary Key Update (Data Flow)]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 04 Oct 2017
-- Modify date: 
-- Description:	Update Data Flow package
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Primary Key Update (Data Flow)] 1, ' test', 'test', 'package name', 'pattern name', 'text', 'test', Getdate(), 'test'
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Primary Key Update (Data Flow)]
(
	@src_connection nvarchar(64),
	@src_query nvarchar(max),
    @package_qualifier nvarchar(64),
    @dst_connection nvarchar(64),
    @dst_schema nvarchar(128),
	@dst_table nvarchar(128),
	@dst_truncate nvarchar(1),
	@keep_identity nvarchar(1),
	@primary_key_update nvarchar(1) = '0',
	@old_package_qualifier nvarchar(64) = '',
	@old_dst_table nvarchar(128) = '',
	@package_name nvarchar(128) = '',
	@old_package_name nvarchar(128) = '',
	@project_id INT = 0,
	@is_expression nvarchar(1),
	@src_query_direct nvarchar(max),
	@old_dst_schema nvarchar(128) = ''
)
AS 
BEGIN
	-- check if PK is updated or not. If result is 0 than PK wasn't change and we need to update or insert value only in package_config (Data Flow) table
	IF(@primary_key_update = '0')
		BEGIN
			--check if package with the same PK exist in table. If yes update existing row, if not create new
			IF ((SELECT COUNT([package_name]) FROM [biml].[package_config (Data Flow)] WHERE [package_qualifier] = @package_qualifier AND [dst_table] = @dst_table AND [dst_schema] = @dst_schema) > 0  )
				BEGIN
					UPDATE [biml].[package_config (Data Flow)]
					SET [src_connection] = @src_connection
						,[src_query] = @src_query
						,[dst_connection] = @dst_connection
						,[dst_truncate] = @dst_truncate
						,[keep_identity] = @keep_identity
						,[is_expression] = @is_expression
						,[src_query_direct] = @src_query_direct
				 WHERE [package_qualifier] = @package_qualifier AND [dst_table] = @dst_table AND [dst_schema] = @dst_schema
				END
			ELSE
				BEGIN
					INSERT INTO [biml].[package_config (Data Flow)]
						   ([src_connection]
						   ,[src_query]
						   ,[is_expression]
						   ,[src_query_direct]
						   ,[package_qualifier]
						   ,[dst_connection]
						   ,[dst_schema]
						   ,[dst_table]
						   ,[dst_truncate]
						   ,[keep_identity])
					 VALUES
						   (@src_connection
						   ,@src_query
						   ,@is_expression
						   ,@src_query_direct
						   ,@package_qualifier
						   ,@dst_connection
						   ,@dst_schema
						   ,@dst_table
						   ,@dst_truncate
						   ,@keep_identity)		
				END
		END
	ELSE
		BEGIN
		--update package_config (Data Flow) table
		UPDATE [biml].[package_config (Data Flow)]
					SET [src_connection] = @src_connection
						,[src_query] = @src_query
						,[package_qualifier] = @package_qualifier
						,[dst_connection] = @dst_connection
						,[dst_schema] = @dst_schema
						,[dst_table] = @dst_table
						,[dst_truncate] = @dst_truncate
						,[keep_identity] = @keep_identity
						,[is_expression] = @is_expression
						,[src_query_direct] = @src_query_direct
				 WHERE [package_qualifier] = @old_package_qualifier AND [dst_table] = @old_dst_table AND [dst_schema] = @old_dst_schema

		--update project_package table
		UPDATE [biml].[project_package]
		SET	[package_name] = @package_name
		WHERE [project_id] = @project_id AND [package_name] = @old_package_name

		--delete old row from package table
		DELETE FROM [biml].[package]
		WHERE [package_name] = @old_package_name
		END
END
GO
/****** Object:  StoredProcedure [biml].[Primary Key Update (Execute Process)]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 19 Oct 2017
-- Modify date: 
-- Description:	Update Execute Process package
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Primary Key Update (Execute Process)] 
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Primary Key Update (Execute Process)]
( 
	@package_qualifier nvarchar(64),
	@executable_expr nvarchar(1024),
	@arguments_expr nvarchar(max),
	@working_directory nvarchar(2048),
	@place_values_in_SSIS_Data nvarchar(1),
	@primary_key_update nvarchar(1) = '0',	
	@old_package_qualifier nvarchar(64) = '',
	@old_package_name nvarchar(128) = '',
	@project_id INT = 0,
	@package_name nvarchar(128) = ''
)
AS 
BEGIN
	-- check if PK is updated or not. If result is 0 than PK wasn't change and we need to update or insert value only in package_config (Execute SQL) table
	IF(@primary_key_update = '0')
		BEGIN
			--check if package with the same PK exist in table. If yes update existing row, if not create new
			IF ((SELECT COUNT([package_name]) FROM [biml].[package_config (Execute Process)] WHERE [package_qualifier] = @package_qualifier) > 0)
				BEGIN
					UPDATE [biml].[package_config (Execute Process)]
					SET [executable_expr] = @executable_expr
						,[arguments_expr] = @arguments_expr
						,[working_directory] = @working_directory
						,[place_values_in_SSIS_Data] = @place_values_in_SSIS_Data
					WHERE [package_qualifier] = @package_qualifier
				END
			ELSE
				BEGIN
					INSERT INTO [biml].[package_config (Execute Process)]
						   ([package_qualifier]
						   ,[executable_expr]
						   ,[arguments_expr]
						   ,[working_directory]
						   ,[place_values_in_SSIS_Data])
					 VALUES
						   (@package_qualifier
						   ,@executable_expr
						   ,@arguments_expr
						   ,@working_directory
						   ,@place_values_in_SSIS_Data)
				END
		END
	ELSE
		BEGIN
			--update "package_config (Execute SQL)" table
			UPDATE [biml].[package_config (Execute Process)]
			SET [executable_expr] = @executable_expr
				,[arguments_expr] = @arguments_expr
				,[working_directory] = @working_directory
				,[place_values_in_SSIS_Data] = @place_values_in_SSIS_Data
				,[package_qualifier] = @package_qualifier
			WHERE [package_qualifier] = @old_package_qualifier

			--update project_package table
			UPDATE [biml].[project_package]
			SET	[package_name] = @package_name
			WHERE [project_id] = @project_id AND [package_name] = @old_package_name

			--delete old row from package table
			DELETE FROM [biml].[package]
			WHERE [package_name] = @old_package_name
			
			--check code generator "Dim Table Merge (Standard)"
			IF ((SELECT COUNT([package_qualifier]) FROM [biml].[dim_table_merge_config (Standard)] WHERE [package_qualifier] = @old_package_qualifier) > 0)
				BEGIN
					UPDATE [biml].[dim_table_merge_config (Standard)]
					SET [package_qualifier] = @package_qualifier
					WHERE [package_qualifier] = @old_package_qualifier
				END

			-- check if execute process variables are used for selected package
			IF ((SELECT COUNT([package_qualifier]) FROM [biml].[package_config (Execute Process) variable] WHERE [package_qualifier] = @old_package_qualifier) > 0)
				BEGIN
					UPDATE [biml].[package_config (Execute Process) variable]
					SET [package_qualifier] = @package_qualifier
					WHERE [package_qualifier] = @old_package_qualifier
				END
		END
END

/****** Object:  StoredProcedure [biml].[Primary Key Update (Execute Process)]    Script Date: 10/19/2017 4:10:49 AM ******/
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [biml].[Primary Key Update (Execute Script)]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Ena Jukic (Software Developer)
-- Create date: 17 Oct 2017
-- Modify date: 
-- Description:	Insert or Update Primary Key Execute Script Package
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Primary Key Update (Execute Script)] 
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Primary Key Update (Execute Script)]
( 
	@connection_manager nvarchar(64),
	@script_name nvarchar(64),
    @package_qualifier nvarchar(64),
	@return_row_count nvarchar(1),
	@primary_key_update nvarchar(1) = '0',	
	@old_package_qualifier nvarchar(64) = '',
	@package_name nvarchar(128) = '',
	@old_package_name nvarchar(128) = '',
	@project_id INT = 0
)
AS 
BEGIN
	-- check if PK is updated or not. If result is 0 than PK wasn't change and we need to update or insert value only in [package_config (Execute Script)] table
	IF(@primary_key_update = '0')
		BEGIN
			--check if package with the same PK exist in table. If yes update existing row, if not create new
			IF ((SELECT COUNT([package_name]) FROM [biml].[package_config (Execute Script)] WHERE [package_qualifier] = @package_qualifier) > 0  )
				BEGIN
					UPDATE [biml].[package_config (Execute Script)]
					SET [connection_manager] = @connection_manager
						,[script_name] = @script_name
						,[return_row_count] = @return_row_count
					WHERE [package_qualifier] = @package_qualifier
				END
			ELSE
				BEGIN
					INSERT INTO [biml].[package_config (Execute Script)]
						   ([connection_manager]
						   ,[script_name]
						   ,[package_qualifier]
						   ,[return_row_count])
					 VALUES
						   (@connection_manager
							,@script_name
							,@package_qualifier
							,@return_row_count)	
				END
		END
	ELSE
		BEGIN
			--update [package_config (Execute Script)] table
			UPDATE [biml].[package_config (Execute Script)]
						SET [connection_manager] = @connection_manager
								,[script_name] = @script_name
								,[package_qualifier] = @package_qualifier
								,[return_row_count] = @return_row_count
						 WHERE [package_qualifier] = @old_package_qualifier

			--update project_package table
			UPDATE [biml].[project_package]
			SET	[package_name] = @package_name
			WHERE [project_id] = @project_id AND [package_name] = @old_package_name

			--delete old row from package table
			DELETE FROM [biml].[package]
			WHERE [package_name] = @old_package_name

			-- check if execute process variables are used for selected package
			IF ((SELECT COUNT([package_qualifier]) FROM [biml].[package_config (Execute Script) variable] WHERE [package_qualifier] = @old_package_qualifier) > 0)
				BEGIN
					UPDATE [biml].[package_config (Execute Script) variable]
					SET [package_qualifier] = @package_qualifier
					WHERE [package_qualifier] = @old_package_qualifier
				END
		END
END
GO
/****** Object:  StoredProcedure [biml].[Primary Key Update (Execute SQL)]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 11 Oct 2017
-- Modify date: 
-- Description:	Update Execute SQL package
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Primary Key Update (Execute SQL)] 
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Primary Key Update (Execute SQL)]
( 
	@connection_manager nvarchar(64),
	@query_expression nvarchar(max),
    @package_qualifier nvarchar(64),
	@primary_key_update nvarchar(1) = '0',	
	@old_package_qualifier nvarchar(64) = '',
	@old_package_name nvarchar(128) = '',
	@project_id INT = 0,
	@package_name nvarchar(128) = '',
	@is_expression nvarchar(1),
	@return_row_count nvarchar(1)
)
AS 
BEGIN
	-- check if PK is updated or not. If result is 0 than PK wasn't change and we need to update or insert value only in package_config (Execute SQL) table
	IF(@primary_key_update = '0')
		BEGIN
			--check if package with the same PK exist in table. If yes update existing row, if not create new
			IF ((SELECT COUNT([package_name]) FROM [biml].[package_config (Execute SQL)] WHERE [package_qualifier] = @package_qualifier) > 0)
				BEGIN
					UPDATE [biml].[package_config (Execute SQL)]
					SET [connection_manager] = @connection_manager
						,[query] = @query_expression
						,[is_expression] = @is_expression
						,[return_row_count] = @return_row_count
					WHERE [package_qualifier] = @package_qualifier
				END
			ELSE
				BEGIN
					INSERT INTO [biml].[package_config (Execute SQL)]
						([connection_manager]
						,[package_qualifier]
						,[query]
						,[is_expression]
						,[return_row_count])
					VALUES
						(@connection_manager
						,@package_qualifier
						,@query_expression
						,@is_expression
						,@return_row_count)	
				END
		END
	ELSE
		BEGIN
			--update "package_config (Execute SQL)" table
			UPDATE [biml].[package_config (Execute SQL)]
						SET [connection_manager] = @connection_manager
							,[package_qualifier] = @package_qualifier
							,[query] = @query_expression
							,[is_expression] = @is_expression
							,[return_row_count] = @return_row_count
					 WHERE [package_qualifier] = @old_package_qualifier

			--update project_package table
			UPDATE [biml].[project_package]
			SET	[package_name] = @package_name
			WHERE [project_id] = @project_id AND [package_name] = @old_package_name

			--delete old row from package table
			DELETE FROM [biml].[package]
			WHERE [package_name] = @old_package_name
			
			/********************************************           CHECK CODE GENERATORS           ********************************************/
			--check code generator "Dim Table Merge (Standard)"
			IF ((SELECT COUNT([package_qualifier]) FROM [biml].[dim_table_merge_config (Standard)] WHERE [package_qualifier] = @old_package_qualifier) > 0)
				BEGIN
					UPDATE [biml].[dim_table_merge_config (Standard)]
					SET [package_qualifier] = @package_qualifier
					WHERE [package_qualifier] = @old_package_qualifier
				END

			--check code generator "Fact Table Merge (Basic)" 
			IF ((SELECT COUNT([package_qualifier]) FROM [biml].[fact_table_merge_config (Basic)] WHERE [package_qualifier] = @old_package_qualifier) > 0)
				BEGIN
					UPDATE [biml].[fact_table_merge_config (Basic)]
					SET [package_qualifier] = @package_qualifier
					WHERE [package_qualifier] = @old_package_qualifier
				END

			--check code generator "Fact Table Partition (Standard)"
			IF ((SELECT COUNT([package_qualifier]) FROM [biml].[fact_table_partition_config (Standard)] WHERE [package_qualifier] = @old_package_qualifier) > 0)
				BEGIN
					UPDATE [biml].[fact_table_partition_config (Standard)]
					SET [package_qualifier] = @package_qualifier
					WHERE [package_qualifier] = @old_package_qualifier
				END

			--check code generator "Fact Table Switch (Standard)" 
			IF ((SELECT COUNT([package_qualifier]) FROM [biml].[fact_table_switch_config (Standard)] WHERE [package_qualifier] = @old_package_qualifier) > 0)
				BEGIN
					UPDATE [biml].[fact_table_switch_config (Standard)]
					SET [package_qualifier] = @package_qualifier
					WHERE [package_qualifier] = @old_package_qualifier
				END
		END
END
GO
/****** Object:  StoredProcedure [biml].[Primary Key Update (Foreach Data Flow)]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Ena Jukic (Software Developer)
-- Create date: 17 Oct 2017
-- Modify date: 
-- Description:	Insert or Update Primary Key Foreach Data Flow Package
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Primary Key Update (Foreach Data Flow)] 
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Primary Key Update (Foreach Data Flow)]
(
	@foreach_connection nvarchar(64),
	@src_connection nvarchar(64),
	@foreach_query nvarchar(max),
	@foreach_item_datatype nvarchar(64),
	@foreach_item_build_value nvarchar(64),
	@src_query nvarchar(max),
	@src_query_direct nvarchar(64),
    @package_qualifier nvarchar(64),
    @dst_connection nvarchar(64),
    @dst_schema nvarchar(128),
	@dst_table nvarchar(128),
	@dst_truncate nvarchar(1),
	@keep_identity nvarchar(1),
	@primary_key_update nvarchar(1) = '0',
	@old_package_qualifier nvarchar(64) = '',
	@old_dst_table nvarchar(128) = '',
	@package_name nvarchar(128) = '',
	@old_package_name nvarchar(128) = '',
	@project_id INT = 0
)
AS 
BEGIN
	-- check if PK is updated or not. If result is 0 than PK wasn't change and we need to update or insert value only in package_config (Data Flow) table
	IF(@primary_key_update = '0')
		BEGIN
			--check if package with the same PK exist in table. If yes update existing row, if not create new
			IF ((SELECT COUNT([package_name]) FROM [biml].[package_config (Foreach Data Flow)] WHERE [package_qualifier] = @package_qualifier AND [dst_table] = @dst_table) > 0  )
				BEGIN
					UPDATE [biml].[package_config (Foreach Data Flow)]
					SET [foreach_connection] = @foreach_connection,
						[foreach_query_expr] = @foreach_query,
						[foreach_item_datatype] = @foreach_item_datatype,
						[foreach_item_build_value] = @foreach_item_build_value,
						[src_connection] = @src_connection,
						[src_query_expr] = @src_query,
						[src_query_direct] = @src_query_direct,
						[dst_connection] = @dst_connection,
						[dst_schema] = @dst_schema,
						[dst_truncate] = @dst_truncate,
						[keep_identity] = @keep_identity
				 WHERE [package_qualifier] = @package_qualifier AND [dst_table] = @dst_table
				END
			ELSE
				BEGIN
					INSERT INTO [biml].[package_config (Foreach Data Flow)]
						   ([foreach_connection]
						   ,[foreach_query_expr]
						   ,[foreach_item_datatype]
						   ,[foreach_item_build_value]
						   ,[src_connection]
						   ,[src_query_expr]
						   ,[src_query_direct]
						   ,[package_qualifier]
						   ,[dst_connection]
						   ,[dst_schema]
						   ,[dst_table]
						   ,[dst_truncate]
						   ,[keep_identity])
					 VALUES
						   (@foreach_connection
						   ,@foreach_query
						   ,@foreach_item_datatype
						   ,@foreach_item_build_value
						   ,@src_connection
						   ,@src_query
						   ,@src_query_direct
						   ,@package_qualifier
						   ,@dst_connection
						   ,@dst_schema
						   ,@dst_table
						   ,@dst_truncate
						   ,@keep_identity)		
				END
		END
	ELSE
		BEGIN
		--update package_config (Foreach Data Flow) table
		UPDATE [biml].[package_config (Foreach Data Flow)]
					SET [foreach_connection] = @foreach_connection,
						[foreach_query_expr] = @foreach_query,
						[foreach_item_datatype] = @foreach_item_datatype,
						[foreach_item_build_value] = @foreach_item_build_value,
						[src_connection] = @src_connection,
						[src_query_expr] = @src_query,
						[src_query_direct] = @src_query_direct,
						[package_qualifier] = @package_qualifier,
						[dst_connection] = @dst_connection,
						[dst_schema] = @dst_schema,
						[dst_table] = @dst_table,
						[dst_truncate] = @dst_truncate,
						[keep_identity] = @keep_identity
				 WHERE [package_qualifier] = @old_package_qualifier AND [dst_table] = @old_dst_table

		--update project_package table
		UPDATE [biml].[project_package]
		SET	[package_name] = @package_name
		WHERE [project_id] = @project_id AND [package_name] = @old_package_name

		--delete old row from package table
		DELETE FROM [biml].[package]
		WHERE [package_name] = @old_package_name
		END
END
GO
/****** Object:  StoredProcedure [biml].[Primary Key Update (Foreach Execute SQL)]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 17 Oct 2017
-- Modify date: 
-- Description:	Insert or Update Primary Key Foreach Execute SQL Package
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Primary Key Update (Foreach Execute SQL)] 
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Primary Key Update (Foreach Execute SQL)]
(
	@foreach_connection nvarchar(64),
	@src_connection nvarchar(64),
	@foreach_query nvarchar(max),
	@foreach_item_datatype nvarchar(64),
	@foreach_item_build_value nvarchar(64),
	@src_query nvarchar(max),
    @package_qualifier nvarchar(64),
	@is_expression nvarchar(1) = 'Y',
	@return_row_count nvarchar(1),
	@primary_key_update nvarchar(1) = '0',
	@old_package_qualifier nvarchar(64) = '',
	@old_package_name nvarchar(128) = '',
	@package_name nvarchar(128) = '',
	@project_id INT = 0
)
AS 
BEGIN
	-- check if PK is updated or not. If result is 0 than PK wasn't change and we need to update or insert value only in package_config (Data Flow) table
	IF(@primary_key_update = '0')
		BEGIN
			--check if package with the same PK exist in table. If yes update existing row, if not create new
			IF ((SELECT COUNT([package_name]) FROM [biml].[package_config (Foreach Execute SQL)] WHERE [package_qualifier] = @package_qualifier) > 0  )
				BEGIN
					UPDATE [biml].[package_config (Foreach Execute SQL)]
					SET [foreach_connection] = @foreach_connection,
						[foreach_query_expr] = @foreach_query,
						[foreach_item_datatype] = @foreach_item_datatype,
						[foreach_item_build_value] = @foreach_item_build_value,
						[query_connection] = @src_connection,
						[query] = @src_query,
						[return_row_count] = @return_row_count
				 WHERE [package_qualifier] = @package_qualifier
				END
			ELSE
				BEGIN
					INSERT INTO [biml].[package_config (Foreach Execute SQL)]
						   ([package_qualifier]
						   ,[foreach_connection]
						   ,[foreach_query_expr]
						   ,[foreach_item_datatype]
						   ,[foreach_item_build_value]
						   ,[query_connection]
						   ,[query]
						   ,[is_expression]
						   ,[return_row_count])
					 VALUES
						   (@package_qualifier
						   ,@foreach_connection
						   ,@foreach_query
						   ,@foreach_item_datatype
						   ,@foreach_item_build_value
						   ,@src_connection
						   ,@src_query
						   ,@is_expression
						   ,@return_row_count)		
				END
		END
	ELSE
		BEGIN
			--update package_config (Foreach Data Flow) table
			UPDATE [biml].[package_config (Foreach Execute SQL)]
			SET [foreach_connection] = @foreach_connection,
				[foreach_query_expr] = @foreach_query,
				[foreach_item_datatype] = @foreach_item_datatype,
				[foreach_item_build_value] = @foreach_item_build_value,
				[query_connection] = @src_connection,
				[query] = @src_query,
				[return_row_count] = @return_row_count,
				[package_qualifier] = @package_qualifier
			WHERE [package_qualifier] = @old_package_qualifier

			--update project_package table
			UPDATE [biml].[project_package]
			SET	[package_name] = @package_name
			WHERE [project_id] = @project_id AND [package_name] = @old_package_name

			--delete old row from package table
			DELETE FROM [biml].[package]
			WHERE [package_name] = @old_package_name
		END
END
GO
/****** Object:  StoredProcedure [biml].[Register User]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 18 Dec 2017
-- Modify date: 
-- Description:	Register User name
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Register User]
*/
-- ================================================================================================
CREATE PROCEDURE [biml].[Register User]
AS 
BEGIN

DECLARE @UserID AS INT
	  , @UserName AS NVARCHAR(64)

SET @UserName = [biml].[get user name] ()

SELECT @UserID = [user_id]
  FROM [biml].[user]
 WHERE [user_name] = @UserName

 IF @UserID IS NULL
 INSERT INTO [biml].[user]
           ([user_name])
     VALUES
           (@UserName)

END
GO
/****** Object:  StoredProcedure [biml].[Save Query History]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 26 Aug 2016
-- Modify date: 27 Feb 2017 - Fix for renamed columns-- Description:	Saves Query History from Package Config Tables
-- Modify date: 20 Jun 2017 - Added pattern: package_config (Foreach Execute SQL)
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Save Query History]
*/
-- ================================================================================================

CREATE PROCEDURE [biml].[Save Query History]
AS

-----------------------------------------------------------------------------------------
-- package_config (Data Flow)
-- src_query
-----------------------------------------------------------------------------------------

INSERT [biml].[query_history]
     ( [package_config_table]
     , [query_tag]
     , [query]
	 )

SELECT 'package_config (Data Flow)' AS [package_config_table]
	 , 'src_query' AS [query_tag]
	 , [src_query] AS [query]
  FROM [biml].[package_config (Data Flow)]

EXCEPT 

SELECT 'package_config (Data Flow)' AS [package_config_table]
	 , 'src_query' AS [query_tag]
	 , [query] AS [query]
  FROM [biml].[query_history]



-----------------------------------------------------------------------------------------
-- package_config (Execute SQL)
-- query
-----------------------------------------------------------------------------------------

INSERT [biml].[query_history]
     ( [package_config_table]
     , [query_tag]
     , [query]
	 )

SELECT 'package_config (Execute SQL)' AS [package_config_table]
	 , 'query' AS [query_tag]
	 , [query] AS [query]
  FROM [biml].[package_config (Execute SQL)]

EXCEPT 

SELECT 'package_config (Execute SQL)' AS [package_config_table]
	 , 'query' AS [query_tag]
	 , [query] AS [query]
  FROM [biml].[query_history]



-----------------------------------------------------------------------------------------
-- package_config (Foreach Data Flow)
-- foreach_query
-----------------------------------------------------------------------------------------

INSERT [biml].[query_history]
     ( [package_config_table]
     , [query_tag]
     , [query]
	 )

SELECT 'package_config (Foreach Data Flow)' AS [package_config_table]
	 , 'foreach_query' AS [query_tag]
	 , [foreach_query_expr] AS [query]
  FROM [biml].[package_config (Foreach Data Flow)]

EXCEPT 

SELECT 'package_config (Foreach Data Flow)' AS [package_config_table]
	 , 'foreach_query' AS [query_tag]
	 , [query] AS [query]
  FROM [biml].[query_history]



-----------------------------------------------------------------------------------------
-- package_config (Foreach Data Flow)
-- src_query
-----------------------------------------------------------------------------------------

INSERT [biml].[query_history]
     ( [package_config_table]
     , [query_tag]
     , [query]
	 )

SELECT 'package_config (Foreach Data Flow)' AS [package_config_table]
	 , 'src_query' AS [query_tag]
	 , [src_query_expr] AS [query]
  FROM [biml].[package_config (Foreach Data Flow)]

EXCEPT 

SELECT 'package_config (Foreach Data Flow)' AS [package_config_table]
	 , 'src_query' AS [query_tag]
	 , [query] AS [query]
  FROM [biml].[query_history]


-----------------------------------------------------------------------------------------
-- package_config (Foreach Execute SQL)
-- src_query
-----------------------------------------------------------------------------------------

INSERT [biml].[query_history]
     ( [package_config_table]
     , [query_tag]
     , [query]
	 )

SELECT 'package_config (Foreach Execute SQL)' AS [package_config_table]
	 , 'src_query' AS [query_tag]
	 , [query] AS [query]
  FROM [biml].[package_config (Foreach Execute SQL)]

EXCEPT 

SELECT 'package_config (Foreach Execute SQL)' AS [package_config_table]
	 , 'src_query' AS [query_tag]
	 , [query] AS [query]
  FROM [biml].[query_history]







GO
/****** Object:  StoredProcedure [biml].[Update Merge Statements]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 27 May 2016
-- Modify date: 02 Jul 2016 - Updated Standard Merge to an Expression
-- Modify date: 07 Jul 2016 - Change to enable custom added dimension columns
-- Modify date: 07 Jul 2016 - Removed @connection_manager predicate in UPDATE statements
-- Modify date: 02 Mar 2017 - Added logging to [biml].[build_log]
-- Modify date: 06 Apr 2017 - Added @stg_server parameter to qualify metadata
-- Modify date: 14 Apr 2017 - Added 'snowflake' merge statement
-- Modify date: 30 Apr 2017 - temp removed: 'snowflake' merge statement (2 places)
-- Modify date: 03 May 2017 - restored: 'snowflake' merge statement (2 places)
-- Modify date: 17 Aug 2017 - changed 'snowflake' merge to an (Execute Process) Task
-- Modify date: 03 Oct 2017 - added merge option for no added columns (type 1 only)
--
-- Description:	Builds Merge Statements
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Update Merge Statements]
*/
-- ================================================================================================

CREATE PROCEDURE [biml].[Update Merge Statements]
AS

INSERT [biml].[build_log]
     ( [event_datetime]
     , [event_group]
     , [event_component] )
VALUES
     ( GETDATE()
	 , 'Update Merge Statements'
	 , 'Start');


DECLARE @stg_database_param_name NVARCHAR(128)
      , @dst_database_param_name NVARCHAR(128)
	  , @stg_server NVARCHAR(128)
	  , @stg_database NVARCHAR(128)
      , @dst_database NVARCHAR(128)
      , @stg_schema NVARCHAR(128)
      , @dst_schema NVARCHAR(128)
      , @stg_table NVARCHAR(128)
      , @dst_table NVARCHAR(128)
	  , @package_qualifier NVARCHAR(64)
	  , @added_dim_column_names_id INT;

DECLARE @server_type AS NVARCHAR(64)
	  , @row_count AS INT;

SELECT [package_qualifier]
	 , [query]
  INTO #temp
  FROM [biml].[package_config (Execute SQL)]
 WHERE 1=2;


---------------------------------------------
-- Dim Merge (Standard)
---------------------------------------------
DECLARE [proc_cursor] CURSOR FOR  
SELECT [stg_server]
	 , [stg_database]
     , [stg_schema]
     , [dst_schema]
     , [stg_table]
     , [dst_table]
	 , [stg_database_param_name]
     , [dst_database_param_name]
     , [package_qualifier]
	 , [added_dim_column_names_id]
  FROM [biml].[dim_table_merge_config (Standard)]
OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @stg_server, @stg_database, @stg_schema, @dst_schema, @stg_table, @dst_table, @stg_database_param_name, @dst_database_param_name, --@connection_manager, 
								   @package_qualifier, @added_dim_column_names_id

WHILE @@FETCH_STATUS = 0   
BEGIN 

	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Update Merge Statements - From table: [biml].[dim_table_merge_config (Standard)]'
		 , '@package_qualifier: ' + @package_qualifier);

	SET @row_count = 0

	SELECT @server_type = [server_type]
	  FROM [etl].[dim_server]
	 WHERE [server_name] = @stg_server 

	-- Update Dim Merge (SQL Server)
	IF @server_type = 'SQL Server'
		BEGIN

			IF @added_dim_column_names_id = 0

				UPDATE [biml].[package_config (Execute SQL)]
				   SET [query] = [biml].[Build Dim Merge (Standard) Type 1 - Base Columns]
								 (  @stg_server
								  , @stg_database
								  , @stg_schema 
								  , @dst_schema 
								  , @stg_table 
								  , @dst_table 
								  , @stg_database_param_name 
								  , @dst_database_param_name
								 )
				 WHERE [package_qualifier] = @package_qualifier;

			ELSE

				UPDATE [biml].[package_config (Execute SQL)]
				   SET [query] = [biml].[Build Dim Merge (Standard)]
								 (  @stg_server
								  , @stg_database
								  , @stg_schema 
								  , @dst_schema 
								  , @stg_table 
								  , @dst_table 
								  , @stg_database_param_name 
								  , @dst_database_param_name
								  , @added_dim_column_names_id
								 )
				 WHERE [package_qualifier] = @package_qualifier;

			 SET @row_count = @@ROWCOUNT;
		END 


	-- Update Dim Merge (snowflake)
	IF @server_type = 'snowflake'
		BEGIN

			DELETE 
			  FROM [biml].[package_config (Execute Process) variable]
			 WHERE [package_qualifier] = @package_qualifier
			   AND [Name] = 'execute_sql';

			INSERT [biml].[package_config (Execute Process) variable]
				 ( [package_qualifier]
				 , [Name]
				 , [DataType]
				 , [EvaluateAsExpression]
				 , [variable_value] )
			VALUES
				 ( @package_qualifier
				 , 'execute_sql'
				 , 'String'
				 , 'true'
				 , 'stub' );


			IF @added_dim_column_names_id = 0

				UPDATE [biml].[package_config (Execute Process) variable]
				   SET [variable_value] = [biml].[Build Dim Merge (Standard snowflake) Type 1 - Base Columns]
								 (  @stg_server
								  , @stg_database
								  , @stg_schema 
								  , @dst_schema 
								  , @stg_table 
								  , @dst_table 
								  , @stg_database_param_name 
								  , @dst_database_param_name
								 )
				 WHERE [package_qualifier] = @package_qualifier
				   AND [Name] = 'execute_sql';

			ELSE

				UPDATE [biml].[package_config (Execute Process) variable]
				   SET [variable_value] = [biml].[Build Dim Merge (Standard snowflake)]
								 (  @stg_server
								  , @stg_database
								  , @stg_schema 
								  , @dst_schema 
								  , @stg_table 
								  , @dst_table 
								  , @stg_database_param_name 
								  , @dst_database_param_name
								  , @added_dim_column_names_id
								 )
				 WHERE [package_qualifier] = @package_qualifier
				   AND [Name] = 'execute_sql';

			 SET @row_count = @@ROWCOUNT;
		END 


	IF @row_count = 0
		BEGIN
			PRINT 'Warning - Did not find row to update in: [biml].[package_config (Execute SQL Expr)] or [biml].[package_config (Execute Process)]' + ' - ' + @package_qualifier

			INSERT [biml].[build_log]
					( [event_datetime]
					, [event_group]
					, [event_component] )
			VALUES
					( GETDATE()
					, 'Update Merge Statements - From table: [biml].[dim_table_merge_config (Standard)]'
					, 'Warning - Did not find row to update in: [biml].[package_config (Execute SQL Expr)] or [biml].[package_config (Execute Process)]' + ' - ' + @package_qualifier);
		END;

	 DELETE #temp;
	 INSERT #temp
		SELECT [package_qualifier], [query] FROM [biml].[package_config (Execute SQL)]
	  UNION
		SELECT [package_qualifier], [variable_value] AS [query] FROM [biml].[package_config (Execute Process) variable];

	IF EXISTS ( SELECT 1 FROM #temp WHERE [package_qualifier] = @package_qualifier AND [query] = 'No Business key(s) found' )
		BEGIN
			PRINT 'Warning - No Business key(s) found. Refer to: [biml].[dim_table_merge_config (Standard)]' + ' - ' + @package_qualifier

			INSERT [biml].[build_log]
					( [event_datetime]
					, [event_group]
					, [event_component] )
			VALUES
					( GETDATE()
					, 'Update Merge Statements - Defined in table: [biml].[dim_table_merge_config (Standard)]'
					, 'Warning - No Business key(s) found. Recorded in: [biml].[package_config (Execute SQL Expr)] or [biml].[package_config (Execute Process)] variable' + ' - ' + @package_qualifier);
		END


	FETCH NEXT FROM [proc_cursor] INTO @stg_server, @stg_database, @stg_schema, @dst_schema, @stg_table, @dst_table, @stg_database_param_name, @dst_database_param_name, --@connection_manager, 
									   @package_qualifier, @added_dim_column_names_id
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];


---------------------------------------------
-- Fact Merge (Basic)
---------------------------------------------
DECLARE [proc_cursor] CURSOR FOR  
SELECT [stg_server]
	 , [stg_database]
     , [dst_database]
     , [stg_schema]
     , [dst_schema]
     , [stg_table]
     , [dst_table]
     , [package_qualifier]
  FROM [biml].[fact_table_merge_config (Basic)]
OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @stg_server, @stg_database, @dst_database, @stg_schema, @dst_schema, @stg_table, @dst_table, @package_qualifier

WHILE @@FETCH_STATUS = 0   
BEGIN 

	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Update Merge Statements - From table: [biml].[fact_table_merge_config (Basic)]'
		 , '@package_qualifier: ' + @package_qualifier);


	-- Update Basic Merge
	UPDATE [biml].[package_config (Execute SQL)]
	   SET [query] = [biml].[Build Fact Merge (Basic)] 
					 (  @stg_server
					  , @stg_database 
					  , @dst_database 
					  , @stg_schema 
					  , @dst_schema 
					  , @stg_table 
					  , @dst_table 
					 )
	 WHERE [package_qualifier] = @package_qualifier
	   --AND [connection_manager] = @connection_manager


	IF @@ROWCOUNT = 0
		BEGIN
			PRINT 'Warning - Did not find row to update in: [biml].[package_config (Execute SQL)]' + ' - ' + @package_qualifier

			INSERT [biml].[build_log]
					( [event_datetime]
					, [event_group]
					, [event_component] )
			VALUES
					( GETDATE()
					, 'Update Merge Statements - From table: [biml].[fact_table_merge_config (Basic)]'
					, 'Warning - Did not find row to update in: [biml].[package_config (Execute SQL)]' + ' - ' + @package_qualifier);
		END


	IF EXISTS ( SELECT 1 FROM [package_config (Execute SQL)] WHERE [package_qualifier] = @package_qualifier AND [query] = 'No {Fact Date Column} found' )
		BEGIN
			PRINT 'Warning - No {Fact Date Column} found. Recorded in: [package_config (Execute SQL)]' + ' - ' + @package_qualifier

			INSERT [biml].[build_log]
					( [event_datetime]
					, [event_group]
					, [event_component] )
			VALUES
					( GETDATE()
					, 'Update Merge Statements - From table: [biml].[fact_table_merge_config (Basic)]'
					, 'Warning - No {Fact Date Column} found. Recorded in: [package_config (Execute SQL)]' + ' - ' + @package_qualifier);
		END


	FETCH NEXT FROM [proc_cursor] INTO @stg_server, @stg_database, @dst_database, @stg_schema, @dst_schema, @stg_table, @dst_table, @package_qualifier
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];


INSERT [biml].[build_log]
     ( [event_datetime]
     , [event_group]
     , [event_component] )
VALUES
     ( GETDATE()
	 , 'Update Merge Statements'
	 , 'Finish');


GO
/****** Object:  StoredProcedure [biml].[Update Partition Statements]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 18 Jun 2016
-- Modify date: 20 Aug 2016 - added truncate_switch_in_table logic
-- Modify date: 30 Aug 2016 - removed 'connection_manager' parameter
-- Modify date: 02 Mar 2017 - Added logging to [biml].[build_log]
-- Description:	Updates Partition Statements
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Update Partition Statements]
*/
-- ================================================================================================

CREATE PROCEDURE [biml].[Update Partition Statements]
AS

INSERT [biml].[build_log]
     ( [event_datetime]
     , [event_group]
     , [event_component] )
VALUES
     ( GETDATE()
	 , 'Update Partition Statements'
	 , 'Start');

DECLARE @partition_scheme   AS NVARCHAR(128)
	  , @partition_function AS NVARCHAR(128)
	  , @days_ahead         AS INT
	  , @day_partitions     AS INT
	  , @month_partitions   AS INT
	  , @quarter_partitions AS INT
	  , @year_partitions    AS INT
	  , @schema_name        AS NVARCHAR(128)
	  , @table_name         AS NVARCHAR(128)
	  , @truncate_switch_in_table AS NVARCHAR(1)

	  , @package_qualifier NVARCHAR(64);

---------------------------------------------
-- Fact Partition (Standard)
---------------------------------------------
DECLARE [proc_cursor] CURSOR FOR  
SELECT [partition_scheme]
     , [partition_function]
     , [days_ahead]
     , [day_partitions]
     , [month_partitions]
     , [quarter_partitions]
     , [year_partitions]
     , [switch_in_schema_name]
     , [switch_in_table_name]
	 , [truncate_switch_in_table]
     , [package_qualifier]
  FROM [biml].[fact_table_partition_config (Standard)]
  
  OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @partition_scheme, @partition_function, @days_ahead, @day_partitions, @month_partitions, @quarter_partitions, @year_partitions, @schema_name, @table_name, @truncate_switch_in_table, @package_qualifier

WHILE @@FETCH_STATUS = 0   
BEGIN 

	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Update Partition Statements - From table: [fact_table_partition_config (Standard)]'
		 , '@package_qualifier: ' + @package_qualifier);

-- Update Partition Statement
UPDATE [biml].[package_config (Execute SQL)]
   SET [query] = [biml].[Build Fact Partition (Standard)]
				 (  @partition_scheme
				  , @partition_function 
				  , @days_ahead         
				  , @day_partitions     
				  , @month_partitions   
				  , @quarter_partitions 
				  , @year_partitions    
				  , @schema_name        
				  , @table_name
				  , @truncate_switch_in_table         
				 )
 WHERE [package_qualifier] = @package_qualifier;

IF @@ROWCOUNT = 0
	BEGIN
		PRINT 'Warning - Did not find row to update in: [biml].[package_config (Execute SQL)]' + ' - ' + @package_qualifier
		INSERT [biml].[build_log]
			 ( [event_datetime]
			 , [event_group]
			 , [event_component] )
	    VALUES
			 ( GETDATE()
			 , 'Update Partition Statements - From table: [fact_table_partition_config (Standard)]'
			 , 'Warning - Did not find row to update in: [biml].[package_config (Execute SQL)]' + ' - ' + @package_qualifier);
	END

	FETCH NEXT FROM [proc_cursor] INTO @partition_scheme, @partition_function, @days_ahead, @day_partitions, @month_partitions, @quarter_partitions, @year_partitions, @schema_name, @table_name, @truncate_switch_in_table, @package_qualifier
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];


INSERT [biml].[build_log]
     ( [event_datetime]
     , [event_group]
     , [event_component] )
VALUES
     ( GETDATE()
	 , 'Update Partition Statements'
	 , 'Finish');


GO
/****** Object:  StoredProcedure [biml].[Update Sensitive Data Placeholders]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 25 May 2017
-- Modify date:
--
-- Description:	Updates Sensitive Data Placeholders with Actual data
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Update Sensitive Data Placeholders]
*/
-- ================================================================================================

CREATE PROCEDURE [biml].[Update Sensitive Data Placeholders]
AS

INSERT [biml].[build_log]
     ( [event_datetime]
     , [event_group]
     , [event_component] )
VALUES
     ( GETDATE()
	 , 'Update Sensitive Data Placeholders'
	 , 'Start');

DECLARE @project_id AS INT
      , @project_xml AS XML
      , @parameter_xml AS XML
      , @project_text AS NVARCHAR(MAX)
      , @parameter_text AS NVARCHAR(MAX)
	  , @place_holder AS NVARCHAR(64)
	  , @actual_value AS NVARCHAR(512);



--------------------------------------------------------------------
-- Update Sensitive Data Placeholders in biml.project
--------------------------------------------------------------------
DECLARE [proc_cursor] CURSOR FOR  
 SELECT [project_id]
      , [project_xml]
      , [parameter_xml]
   FROM [biml].[project]
    
OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @project_id, @project_xml, @parameter_xml

WHILE @@FETCH_STATUS = 0   
BEGIN 

	SET @project_text   = CAST(@project_xml   AS NVARCHAR(MAX))
	SET @parameter_text = CAST(@parameter_xml AS NVARCHAR(MAX))



			DECLARE [proc_cursor2] CURSOR FOR  
			 SELECT [place_holder]
				  , [actual_value]
			  FROM [biml].[sensitive_data]
    
			OPEN [proc_cursor2]   
			FETCH NEXT FROM [proc_cursor2] INTO @place_holder, @actual_value

			WHILE @@FETCH_STATUS = 0   
			BEGIN 

				SET @project_text   = REPLACE(@project_text  , @place_holder, @actual_value)
				SET @parameter_text = REPLACE(@parameter_text, @place_holder, @actual_value)

				FETCH NEXT FROM [proc_cursor2] INTO @place_holder, @actual_value
			END;  

			CLOSE [proc_cursor2]; 
			DEALLOCATE [proc_cursor2];


	SET @project_xml   = @project_text
	SET @parameter_xml = @parameter_text

	UPDATE [biml].[project]
	   SET [project_xml] = @project_xml
		 , [parameter_xml] = @parameter_xml
	 WHERE [project_id] = @project_id

	FETCH NEXT FROM [proc_cursor] INTO @project_id, @project_xml, @parameter_xml
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];




--------------------------------------------------------------------
-- Update Sensitive Data Placeholders in biml.project_environment
--------------------------------------------------------------------
DECLARE [proc_cursor] CURSOR FOR  
 SELECT [project_id]
      , [project_xml]
      , [parameter_xml]
   FROM [biml].[project_environment]
    
OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @project_id, @project_xml, @parameter_xml

WHILE @@FETCH_STATUS = 0   
BEGIN 

	SET @project_text   = CAST(@project_xml   AS NVARCHAR(MAX))
	SET @parameter_text = CAST(@parameter_xml AS NVARCHAR(MAX))



			DECLARE [proc_cursor2] CURSOR FOR  
			 SELECT [place_holder]
				  , [actual_value]
			  FROM [biml].[sensitive_data]
    
			OPEN [proc_cursor2]   
			FETCH NEXT FROM [proc_cursor2] INTO @place_holder, @actual_value

			WHILE @@FETCH_STATUS = 0   
			BEGIN 

				SET @project_text   = REPLACE(@project_text  , @place_holder, @actual_value)
				SET @parameter_text = REPLACE(@parameter_text, @place_holder, @actual_value)

				FETCH NEXT FROM [proc_cursor2] INTO @place_holder, @actual_value
			END;  

			CLOSE [proc_cursor2]; 
			DEALLOCATE [proc_cursor2];


	SET @project_xml   = @project_text
	SET @parameter_xml = @parameter_text

	UPDATE [biml].[project_environment]
	   SET [project_xml] = @project_xml
		 , [parameter_xml] = @parameter_xml
	 WHERE [project_id] = @project_id

	FETCH NEXT FROM [proc_cursor] INTO @project_id, @project_xml, @parameter_xml
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];




INSERT [biml].[build_log]
     ( [event_datetime]
     , [event_group]
     , [event_component] )
VALUES
     ( GETDATE()
	 , 'Update Sensitive Data Placeholders'
	 , 'Finish');



GO
/****** Object:  StoredProcedure [biml].[Update Switch Statements]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 18 Jun 2016
-- Modify date: 20 Aug 2016 - change parameter names (from 'trun' to 'out')
-- Modify date: 30 Aug 2016 - removed 'connection_manager' parameter
-- Modify date: 02 Mar 2017 - Added logging to [biml].[build_log]
-- Description:	Updates Partition Statements
--
-- Sample Execute Command: 
/*	
EXEC [biml].[Update Switch Statements]
*/
-- ================================================================================================

CREATE PROCEDURE [biml].[Update Switch Statements]
AS

INSERT [biml].[build_log]
     ( [event_datetime]
     , [event_group]
     , [event_component] )
VALUES
     ( GETDATE()
	 , 'Update Switch Statements'
	 , 'Start');

DECLARE @src_schema_name  AS NVARCHAR(128)
      , @src_table_name   AS NVARCHAR(128)
      , @dst_schema_name  AS NVARCHAR(128) 
      , @dst_table_name   AS NVARCHAR(128)
      , @out_schema_name AS NVARCHAR(128) 
      , @out_table_name  AS NVARCHAR(128) 
	  , @switch_option AS INT
	  , @project_parameter AS NVARCHAR(128)

	  , @package_qualifier  AS NVARCHAR(64);

---------------------------------------------
-- Fact Switch (Standard)
---------------------------------------------
DECLARE [proc_cursor] CURSOR FOR  
SELECT [src_schema_name]
     , [src_table_name]
     , [dst_schema_name]
     , [dst_table_name]
     , [out_schema_name]
     , [out_table_name]
	 , [switch_option]
	 , [project_parameter]
     , [package_qualifier]
  FROM [biml].[fact_table_switch_config (Standard)]  
  
OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @src_schema_name, @src_table_name, @dst_schema_name, @dst_table_name, @out_schema_name, @out_table_name, @switch_option, @project_parameter, @package_qualifier

WHILE @@FETCH_STATUS = 0   
BEGIN 

	INSERT [biml].[build_log]
		 ( [event_datetime]
		 , [event_group]
		 , [event_component] )
	VALUES
		 ( GETDATE()
		 , 'Update Switch Statements - From table: [biml].[fact_table_switch_config (Standard)]'
		 , '@package_qualifier: ' + @package_qualifier);


-- Update Partition Statement
UPDATE [biml].[package_config (Execute SQL)]
   SET [query] = [biml].[Build Fact Switch (Standard)]
				 (  @src_schema_name
				  , @src_table_name 
				  , @dst_schema_name 
				  , @dst_table_name
				  , @out_schema_name 
				  , @out_table_name
				  , @switch_option
				  , @project_parameter
				 )
 WHERE [package_qualifier] = @package_qualifier

IF @@ROWCOUNT = 0
	BEGIN
		PRINT 'Warning - Did not find row to update in: [biml].[package_config (Execute SQL)]' + ' - ' + @package_qualifier
		INSERT [biml].[build_log]
			 ( [event_datetime]
			 , [event_group]
			 , [event_component] )
	    VALUES
			 ( GETDATE()
			 , 'Update Partition Statements - From table: [fact_table_switch_config (Standard)]'
			 , 'Warning - Did not find row to update in: [biml].[package_config (Execute SQL)]' + ' - ' + @package_qualifier);
	END

	FETCH NEXT FROM [proc_cursor] INTO @src_schema_name, @src_table_name, @dst_schema_name, @dst_table_name, @out_schema_name, @out_table_name, @switch_option, @project_parameter, @package_qualifier
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];

INSERT [biml].[build_log]
     ( [event_datetime]
     , [event_group]
     , [event_component] )
VALUES
     ( GETDATE()
	 , 'Update Switch Statements'
	 , 'Finish');


GO
/****** Object:  StoredProcedure [etl].[Delete Server Metadata]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ========================================================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 27 May 2017
-- Modify date:
--
-- Description:	Delete Server Metadata v2
--
-- Sample Execute Command: 
/*
EXEC [etl].[Delete Server Metadata] 'server name here'
*/
-- ========================================================================================================================================

CREATE PROCEDURE [etl].[Delete Server Metadata]
(
	@metadata_server_name NVARCHAR(128)
)
AS

BEGIN

--------------------------------------------------------------------------------------------------------------------
---- Step 1 - TRUNCATE [bimlsnap_v2] 'etl' Tables
--------------------------------------------------------------------------------------------------------------------

DELETE [etl].[dim_server]   WHERE [server_name] = @metadata_server_name;
DELETE [etl].[dim_database] WHERE [server_name] = @metadata_server_name;
DELETE [etl].[dim_table]    WHERE [server_name] = @metadata_server_name;
DELETE [etl].[dim_column]   WHERE [server_name] = @metadata_server_name;


PRINT 'Metadata Delete Complete for Server: ' + @metadata_server_name

END


GO
/****** Object:  StoredProcedure [html].[Output Package Query File]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 14 Feb 2017
-- Modify date: 17 Feb 2017 - Added Published Date
-- Modify date: 27 Feb 2017 - Fix for renamed columns
-- Modify date: 20 Jun 2017 - Added pattern: package_config (Foreach Execute SQL)
-- Modify date: 04 Oct 2017 - Added pattern: package_config (Foreach Execute SQL)
--
-- Description:	Output HTML Project File

-- Sample Execute Command: 
/*
EXEC [html].[Output Package Query File] 'Enterprise Data Warehouse'
*/
--
-- ================================================================================================

CREATE PROCEDURE [html].[Output Package Query File]
(
		  @solution_name AS NVARCHAR(255) = ''
)
AS

/* return values */
DECLARE	@return_code AS INT = 1 /* error setting */
	  , @error_message AS NVARCHAR(2000) = '<not set>';

IF ISNULL(@solution_name, '') = ''
	BEGIN
		SET @error_message = 'Must provide a Client/Solution name'
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

SET NOCOUNT ON;

DECLARE @Html AS NVARCHAR(MAX)
	  , @content AS NVARCHAR(MAX)
	  , @Query AS NVARCHAR(MAX)
	  , @orderBy nvarchar(max)
	  , @border int

DECLARE @project_id INT
	  , @project_name NVARCHAR(128)
	  , @package_name NVARCHAR(128)
	  , @execute_connection NVARCHAR(64)
	  , @destination_connection NVARCHAR(64)
	  , @package_query NVARCHAR(MAX);

DECLARE @ParmDefinition NVARCHAR(4000)
	  , @ReturnCode INT
	  , @SQLString NVARCHAR(MAX);


 -- start
SET @Html = '
	   <!DOCTYPE html>
	   <html lang="en">
		  <head>
			 <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
			 <title>' + @solution_name + '</title>
		 '
-- css
SET @Html = @Html + '
             <style type="text/css">
			html {
				margin: 10;
				padding: 10;
				}
			body { 
				font: 75% ''Trebuchet MS'',Trebuchet, sans-serif;
				line-height: 1.88889;
				color: #555753; 
				margin-top: 50px;
				margin-bottom: 50px;
				margin-right: 50px;
				margin-left: 50px;	
				padding: 10;
				}
			th, td {
					padding: 8px;
					text-align: left;
				}
			th { 
				font-family: ''Trebuchet MS'',Trebuchet, sans-serif;
				color:#333333;
				font-size:16px;
				margin-top: 0; 
				text-align: justify;
				}
			tr:nth-child(even) {
				background-color: #f2f2f2
				}
			p { 
				padding: 10;
				text-align: justify;
				}
			 h2 {
				font-family: ''Trebuchet MS'',Trebuchet, sans-serif;
				font-size:18px;
				color:#333333;
				}
			h3 { 
				font: italic normal 1.4em ''Trebuchet MS'',Trebuchet, sans-serif;
				letter-spacing: 1px; 
				margin-bottom: 0; 
				color: #7D775C;
				}
			a:link { 
				font-weight: bold; 
				text-decoration: none; 
				color: #2E2EFE;
				}
			a:visited { 
				font-weight: bold; 
				text-decoration: none; 
				color: #2E2EFE;
				}
			a:hover, a:focus, a:active { 
				text-decoration: underline; 
				color: #9685BA;
				}
		 table {
				margin: 1em 0;
				border: 1px solid #666;
				border-collapse: collapse;
				}
             table.gridtable {
                 font-family: ''Trebuchet MS'',Trebuchet, sans-serif;
                 font-size:11px;
                 color:#333333;
                 border-width: 1px;
                 border-color: #666666;
                 border-collapse: collapse;
             }

             table.gridtable th {
                 border-width: 1px;
                 padding: 4px;
                 border-style: solid;
                 border-color: #666666;
                 background-color: #dedede;
             }

            table.gridtable td {
                 border-width: 1px;
                 padding: 4px;
                 border-style: solid;
                 border-color: #666666;
                 background-color: #ffffff;
             }
             </style>
			 '
-- body
SET @Html = @Html + '
     </head>
  <body>
    <h2>' + @solution_name + ' - SSIS Package Queries</h2>
	<p>Published On: ' + CONVERT(VARCHAR(10), GETDATE(), 101) + '</p>'

-----------------------------------------------------------------------------------------------
-- Project Links
-----------------------------------------------------------------------------------------------

----SET @selectStmt = '
----SELECT [sequence_number]
----     , [package_name] 
----  FROM [biml].[get packages in project] (' + CAST(@project_id AS VARCHAR) + ')'

EXEC [html].[Output Query as Table] 'SELECT ''<a href="#Project-'' + [project_name] + ''">'' + [project_name] + ''</a>'' AS [Project Name] FROM [biml].[project] WHERE [project_name] NOT IN (''snap_mart Refresh'',''snap_build Populate'',''Snap Sync'',''snap_build Replication'')', 'ORDER BY [Project Name]', 1, @content OUTPUT

SET @Html = @Html + @content

-----------------------------------------------------------------------------------------------
-- Project Packages
-----------------------------------------------------------------------------------------------

DECLARE [proc_cursor] CURSOR FOR
SELECT [project_id]
	 , [project_name]
  FROM [biml].[project] 
 WHERE [project_name] NOT IN ('snap_mart Refresh','snap_build Populate','Snap Sync','snap_build Replication')
 ORDER BY [project_name]

OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @project_id, @project_name

WHILE @@FETCH_STATUS = 0   
BEGIN 

	SET @query = 'SELECT p.[project_name] AS [Project Name]
				 , prj.[sequence_number] AS [Sequence Number]
				 , ''<a href="#Package-'' + pkg.[package_name] + ''">'' + pkg.[package_name] + ''</a>'' AS [Package Name]
			  FROM [biml].[package] pkg 
			  JOIN [biml].[project_package] prj
				ON prj.[package_name] = pkg.[package_name]
			  JOIN [biml].[project] p
				ON p.[project_id] = prj.[project_id]
			 WHERE prj.[sequence_number] != -1
			   AND prj.[package_name] IN 
				 ( SELECT [package_name] FROM [biml].[project_package] WHERE [project_id] = ' + CAST(@project_id AS VARCHAR)  + ' )'

	SET @orderBy = 'ORDER BY [Sequence Number]'
	SET @border = 1

	EXECUTE [html].[Output Query as Table] 
	   @query
	  ,@orderBy
	  ,@border
	  ,@content OUTPUT

	SET @Html = @Html + '<br><h2 id="Project-' + @project_name + '">Project Name: ' + @project_name + '</h2>'

	SET @Html = @Html + @content

		--SELECT ''<a href="#Project-'' + [project_name] + ''">'' + [project_name] + ''</a>'' AS [Project Name] 
		--  FROM [biml].[project] WHERE [project_name] NOT IN (''snap_mart Refresh'',''snap_build Populate'',''Snap Sync'',''snap_build Replication'')'


	FETCH NEXT FROM [proc_cursor] INTO @project_id, @project_name
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];


-----------------------------------------------------------------------------------------------
-- Packages
-----------------------------------------------------------------------------------------------

DECLARE [proc_cursor] CURSOR FOR
SELECT pk.[package_name] AS [Package Name]
	 , COALESCE(ctr.[src_connection], df.[src_connection], escr.[connection_manager], es.[connection_manager], fedf.[src_connection], fees.[query_connection], 'n/a') AS [Execute Connection]
	 , COALESCE(ctr.[dst_connection], df.[dst_connection], fedf.[dst_connection], 'n/a') AS [Destination Connection]
	 , COALESCE(ctr.[dst_sync_query], df.[src_query], 'Executable: ' + ep.[executable_expr] 
	   + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + 'Arguments: ' + ep.[arguments_expr] 
	   + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + 'Working Directory: ' + ep.[working_directory], 'Script Name: ' + escr.[script_name] , es.[query], fedf.[src_query_expr], fees.[query]) AS [Package Query]
  FROM [biml].[pattern] pt
  JOIN [biml].[package] pk
	ON pk.[pattern_name] = pt.[pattern_name]
  JOIN [biml].[project_package] pp
	ON pp.[package_name] = pk.[package_name]
  JOIN [biml].[project] pr
	ON pr.[project_id] = pp.[project_id]
  LEFT JOIN [biml].[package_config (CT Replication)] ctr
    ON ctr.[package_name] = pk.[package_name]
  LEFT JOIN [biml].[package_config (Data Flow)] df
    ON df.[package_name] = pk.[package_name]

  LEFT JOIN [biml].[package_config (Execute Process)] ep
    ON ep.[package_name] = pk.[package_name]
  LEFT JOIN [biml].[package_config (Execute Script)] escr
    ON escr.[package_name] = pk.[package_name]

  LEFT JOIN [biml].[package_config (Execute SQL)] es
    ON es.[package_name] = pk.[package_name]
  LEFT JOIN [biml].[package_config (Foreach Data Flow)] fedf
    ON fedf.[package_name] = pk.[package_name]
  LEFT JOIN [biml].[package_config (Foreach Execute SQL)] fees
    ON fees.[package_name] = pk.[package_name]
 WHERE pp.[sequence_number] > -1
 --AND pr.[project_name] NOT IN ('snap_mart Refresh','snap_build Populate','Snap Sync','snap_build Replication')
 ORDER BY [Package Name]

OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @package_name, @execute_connection, @destination_connection, @package_query

WHILE @@FETCH_STATUS = 0   
BEGIN 

	SET @Html = @Html + '<br><br><br><br><h2 id="Package-' + @package_name + '">Package Name: ' + @package_name + '</h2>'
	SET @Html = @Html + '<p>Execute Connection: ' + @execute_connection
	SET @Html = @Html + '<br>Destination Connection: ' + @destination_connection
	SET @Html = @Html + '<br>Query or Executable:</p>'
	SET @Html = @Html + '<textarea rows="20" cols="120">' + @package_query + '</textarea>'

	--SET @Html = @Html + @content

		--SELECT ''<a href="#Project-'' + [project_name] + ''">'' + [project_name] + ''</a>'' AS [Project Name] 
		--  FROM [biml].[project] WHERE [project_name] NOT IN (''snap_mart Refresh'',''snap_build Populate'',''Snap Sync'',''snap_build Replication'')'

	FETCH NEXT FROM [proc_cursor] INTO @package_name, @execute_connection, @destination_connection, @package_query
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];


-----------------------------------------------------------------------------------------------
-- Close HTML
-----------------------------------------------------------------------------------------------

SET @Html = @Html + '
  </body>
</html>
'

-----------------------------------------------------------------------------------------------
-- insert html file table
-----------------------------------------------------------------------------------------------

BEGIN TRY
	DELETE [FileTableDB].[dbo].[HTML_Out] WHERE [name] = @solution_name + '.html'
	INSERT INTO [FileTableDB].[dbo].[HTML_Out] ( name, file_stream ) 
	SELECT @solution_name + '.html', CAST(@Html AS VARBINARY(MAX));
END TRY
BEGIN CATCH
	SET @error_message = 'insert html file: ' + ERROR_MESSAGE()
	SELECT @return_code AS [return code], @error_message AS [error message]
	RETURN
END CATCH

SET @return_code = 0

PRINT 'HTML Output Complete!'
PRINT 'Results are located in FileTable: ..\FileTableDB\HTML_Out_Dir\' + @solution_name + '.html'

SELECT @return_code AS [return code], @solution_name + '.html' AS [html file]




GO
/****** Object:  StoredProcedure [html].[Output Package Query File v2]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Maja Kozar (Software Developer)
-- Create date: 22 Nov 2017
-- Modified:	14 Dec 2017 (Ena Jukic) - execute_sql variable value 
-- Modified:	23 Dec 2017 (JMM) - Bug Fix with dups (added project_id predicate) 
-- Modified:    17 Jan 2018 (Maja Kozar) - Fix issue with project xml -if project XML is null, the HTML value vas null as well.
-- Description:	Output HTML Project File

-- Sample Execute Command: 
/*
EXEC [html].[Output Package Query File v2] 'Enterprise Data Warehouse'
*/
--
-- ================================================================================================

CREATE PROCEDURE [html].[Output Package Query File v2]
(
		  @solution_name AS NVARCHAR(255) = ''
)
AS

/* return values */
DECLARE	@return_code AS INT = 1 /* error setting */
	  , @error_message AS NVARCHAR(2000) = '<not set>';

IF ISNULL(@solution_name, '') = ''
	BEGIN
		SET @error_message = 'Must provide a Client/Solution name'
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

SET NOCOUNT ON;

DECLARE @Html AS NVARCHAR(MAX)
	  , @content AS NVARCHAR(MAX)
	  , @Query AS NVARCHAR(MAX)
	  , @orderBy nvarchar(max)
	  , @border int

DECLARE @project_id INT
	  , @project_name NVARCHAR(128)
	  , @package_name NVARCHAR(128)
	  , @execute_connection NVARCHAR(64)
	  , @destination_connection NVARCHAR(64)
	  , @package_query NVARCHAR(MAX);

DECLARE @ParmDefinition NVARCHAR(4000)
	  , @ReturnCode INT
	  , @SQLString NVARCHAR(MAX);


 -- start
SET @Html = '
	   <!DOCTYPE html>
	   <html lang="en">
		  <head>
			 <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
			 <title>' + @solution_name + '</title>
		 '
-- css
SET @Html = @Html + '
             <style type="text/css">
			html {
				margin: 10;
				padding: 10;
				}
			body { 
				font: 75% ''Trebuchet MS'',Trebuchet, sans-serif;
				line-height: 1.88889;
				color: #555753; 
				margin-top: 50px;
				margin-bottom: 50px;
				margin-right: 50px;
				margin-left: 50px;	
				padding: 10;
				}
			th, td {
					padding: 8px;
					text-align: left;
				}
			th { 
				font-family: ''Trebuchet MS'',Trebuchet, sans-serif;
				color:#333333;
				font-size:16px;
				margin-top: 0; 
				text-align: justify;
				}
			tr:nth-child(even) {
				background-color: #f2f2f2
				}
			p { 
				padding: 10;
				text-align: justify;
				}
			 h2 {
				font-family: ''Trebuchet MS'',Trebuchet, sans-serif;
				font-size:18px;
				color:#333333;
				}
			h3 { 
				font: italic normal 1.4em ''Trebuchet MS'',Trebuchet, sans-serif;
				letter-spacing: 1px; 
				margin-bottom: 0; 
				color: #7D775C;
				}
			a:link { 
				font-weight: bold; 
				text-decoration: none; 
				color: #2E2EFE;
				}
			a:visited { 
				font-weight: bold; 
				text-decoration: none; 
				color: #2E2EFE;
				}
			a:hover, a:focus, a:active { 
				text-decoration: underline; 
				color: #9685BA;
				}
		 table {
				margin: 1em 0;
				border: 1px solid #666;
				border-collapse: collapse;
				}
             table.gridtable {
                 font-family: ''Trebuchet MS'',Trebuchet, sans-serif;
                 font-size:11px;
                 color:#333333;
                 border-width: 1px;
                 border-color: #666666;
                 border-collapse: collapse;
             }

             table.gridtable th {
                 border-width: 1px;
                 padding: 4px;
                 border-style: solid;
                 border-color: #666666;
                 background-color: #dedede;
             }

            table.gridtable td {
                 border-width: 1px;
                 padding: 4px;
                 border-style: solid;
                 border-color: #666666;
                 background-color: #ffffff;
             }
             </style>
			 '
-- body
SET @Html = @Html + '
     </head>
  <body>
    <h2>' + @solution_name + ' - SSIS Package Queries</h2>
	<p>Published On: ' + CONVERT(VARCHAR(10), GETDATE(), 101) + '</p>'

-----------------------------------------------------------------------------------------------
-- Project Links
-----------------------------------------------------------------------------------------------

----SET @selectStmt = '
----SELECT [sequence_number]
----     , [package_name] 
----  FROM [biml].[get packages in project] (' + CAST(@project_id AS VARCHAR) + ')'

EXEC [html].[Output Query as Table] 'SELECT ''<a href="#Project-'' + [project_name] + ''">'' + [project_name] + ''</a>'' AS [Project Name] FROM [biml].[project] WHERE [project_name] NOT IN (''snap_mart Refresh'',''snap_build Populate'',''Snap Sync'',''snap_build Replication'')', 'ORDER BY [Project Name]', 1, @content OUTPUT

SET @Html = @Html + @content

-----------------------------------------------------------------------------------------------
-- Project Packages
-----------------------------------------------------------------------------------------------

DECLARE [proc_cursor] CURSOR FOR
SELECT [project_id]
	 , [project_name]
  FROM [biml].[project] 
 WHERE [project_name] NOT IN ('snap_mart Refresh','snap_build Populate','Snap Sync','snap_build Replication')
 ORDER BY [project_name]

OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @project_id, @project_name

WHILE @@FETCH_STATUS = 0   
BEGIN 

	SET @query = 'SELECT p.[project_name] AS [Project Name]
				 , prj.[sequence_number] AS [Sequence Number]
				 , ''<a href="#Package-'' + pkg.[package_name] + ''">'' + pkg.[package_name] + ''</a>'' AS [Package Name]
			  FROM [biml].[package] pkg 
			  JOIN [biml].[project_package] prj
				ON prj.[package_name] = pkg.[package_name]
			  JOIN [biml].[project] p
				ON p.[project_id] = prj.[project_id]
			 WHERE prj.[sequence_number] != -1
			   AND prj.[project_id] = ' + CAST(@project_id AS VARCHAR)  + '
			   AND prj.[package_name] IN 
				 ( SELECT [package_name] FROM [biml].[project_package] WHERE [project_id] = ' + CAST(@project_id AS VARCHAR)  + ' )'

	SET @orderBy = 'ORDER BY [Sequence Number]'
	SET @border = 1

	EXECUTE [html].[Output Query as Table] 
	   @query
	  ,@orderBy
	  ,@border
	  ,@content OUTPUT

	SET @Html = @Html + '<br><h2 id="Project-' + @project_name + '">Project Name: ' + @project_name + '</h2>'

	IF @content IS NOT NULL
		SET @Html = @Html + @content

		--SELECT ''<a href="#Project-'' + [project_name] + ''">'' + [project_name] + ''</a>'' AS [Project Name] 
		--  FROM [biml].[project] WHERE [project_name] NOT IN (''snap_mart Refresh'',''snap_build Populate'',''Snap Sync'',''snap_build Replication'')'


	FETCH NEXT FROM [proc_cursor] INTO @project_id, @project_name
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];


-----------------------------------------------------------------------------------------------
-- Packages
-----------------------------------------------------------------------------------------------

DECLARE [proc_cursor] CURSOR FOR
SELECT DISTINCT pk.[package_name] AS [Package Name]
	 , COALESCE(ctr.[src_connection], df.[src_connection], escr.[connection_manager], es.[connection_manager], fedf.[src_connection], fees.[query_connection], 'n/a') AS [Execute Connection]
	 , COALESCE(ctr.[dst_connection], df.[dst_connection], fedf.[dst_connection], 'n/a') AS [Destination Connection]
	 , COALESCE(ctr.[dst_sync_query], df.[src_query], 'Executable: ' + ep.[executable_expr] 
	   + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + 'Arguments: ' + ep.[arguments_expr] 
	   + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + 'Working Directory: ' + ep.[working_directory], 'Script Name: ' + escr.[script_name] , es.[query], fedf.[src_query_expr], fees.[query]) AS [Package Query]
  FROM [biml].[pattern] pt
  JOIN [biml].[package] pk
	ON pk.[pattern_name] = pt.[pattern_name]
  JOIN [biml].[project_package] pp
	ON pp.[package_name] = pk.[package_name]
  JOIN [biml].[project] pr
	ON pr.[project_id] = pp.[project_id]
  LEFT JOIN [biml].[package_config (CT Replication)] ctr
    ON ctr.[package_name] = pk.[package_name]
  LEFT JOIN [biml].[package_config (Data Flow)] df
    ON df.[package_name] = pk.[package_name]

  LEFT JOIN [biml].[package_config (Execute Process)] ep
    ON ep.[package_name] = pk.[package_name]
  LEFT JOIN [biml].[package_config (Execute Script)] escr
    ON escr.[package_name] = pk.[package_name]

  LEFT JOIN [biml].[package_config (Execute SQL)] es
    ON es.[package_name] = pk.[package_name]
  LEFT JOIN [biml].[package_config (Foreach Data Flow)] fedf
    ON fedf.[package_name] = pk.[package_name]
  LEFT JOIN [biml].[package_config (Foreach Execute SQL)] fees
    ON fees.[package_name] = pk.[package_name]
 WHERE pp.[sequence_number] > -1
 --AND pr.[project_name] NOT IN ('snap_mart Refresh','snap_build Populate','Snap Sync','snap_build Replication')
 ORDER BY [Package Name]

OPEN [proc_cursor]   
FETCH NEXT FROM [proc_cursor] INTO @package_name, @execute_connection, @destination_connection, @package_query

WHILE @@FETCH_STATUS = 0   
BEGIN 

	--Check if there is a Execute Process - execute SQL variable value
	IF((SELECT COUNT([variable_value]) FROM [biml].[package_config (Execute Process) variable] WHERE 'Execute Process - ' + [package_qualifier] = @package_name) > 0)
		BEGIN
			SET @Html = @Html + '<br><br><br><br><h2 id="Package-' + @package_name + '">Package Name: ' + @package_name + '</h2>'
			SET @Html = @Html + '<p>Execute Connection: ' + @execute_connection
			SET @Html = @Html + '<br>Destination Connection: ' + @destination_connection
			SET @Html = @Html + '<br>Query or Executable:</p>'
			SET @Html = @Html + '<textarea rows="20" cols="120">' + @package_query + '</textarea><br>'

			DECLARE @variable_name AS NVARCHAR(MAX);
			SET @variable_name = (SELECT TOP 1 [variable_value] FROM [biml].[package_config (Execute Process) variable] WHERE 'Execute Process - ' + [package_qualifier] LIKE @package_name)
	
			SET @Html = @Html + '<br>execute_SQL variable value:</p>'
			SET @Html = @Html + '<textarea rows="20" cols="120">' + @variable_name + '</textarea>'
		END
	ELSE
		BEGIN
			SET @Html = @Html + '<br><br><br><br><h2 id="Package-' + @package_name + '">Package Name: ' + @package_name + '</h2>'
			SET @Html = @Html + '<p>Execute Connection: ' + @execute_connection
			SET @Html = @Html + '<br>Destination Connection: ' + @destination_connection
			SET @Html = @Html + '<br>Query or Executable:</p>'
			SET @Html = @Html + '<textarea rows="20" cols="120">' + @package_query + '</textarea>'
		END

	--SET @Html = @Html + @content

		--SELECT ''<a href="#Project-'' + [project_name] + ''">'' + [project_name] + ''</a>'' AS [Project Name] 
		--  FROM [biml].[project] WHERE [project_name] NOT IN (''snap_mart Refresh'',''snap_build Populate'',''Snap Sync'',''snap_build Replication'')'

	FETCH NEXT FROM [proc_cursor] INTO @package_name, @execute_connection, @destination_connection, @package_query
END;  

CLOSE [proc_cursor]; 
DEALLOCATE [proc_cursor];


-----------------------------------------------------------------------------------------------
-- Close HTML
-----------------------------------------------------------------------------------------------

SET @Html = @Html + '
  </body>
</html>
'

-----------------------------------------------------------------------------------------------
-- return html 
-----------------------------------------------------------------------------------------------
IF ISNULL(@Html,'') = ''
	SET @Html = 'Incomplete Project'
SELECT @Html;
GO
/****** Object:  StoredProcedure [html].[Output Query as Table]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		MgSam (posting)
-- Create date: 14 Feb 2017
-- Modify date:
-- Description:	Output Query as HTML Table
-- Sample Execute Command: 
/*
DECLARE @html NVARCHAR(MAX); EXEC [html].[Output Query as Table] 'SELECT [project_id],[project_name] FROM [biml].[project]', 'ORDER BY [project_name]', 1,  @html OUTPUT; PRINT @html
*/
--
-- ================================================================================================

CREATE PROCEDURE [html].[Output Query as Table]
(
    @query nvarchar(MAX)
  , @orderBy nvarchar(MAX)
  , @border INT
  , @html nvarchar(MAX) = NULL OUTPUT
)
AS
SET NOCOUNT ON

BEGIN   
  SET NOCOUNT ON;

  IF @orderBy IS NULL BEGIN
    SET @orderBy = ''  
  END

  SET @orderBy = REPLACE(@orderBy, '''', '''''');

  DECLARE @realQuery nvarchar(MAX) = '
    DECLARE @headerRow nvarchar(MAX);
    DECLARE @cols nvarchar(MAX);    

    SELECT * INTO #dynSql FROM (' + @query + ') sub;

    SELECT @cols = COALESCE(@cols + '', '''''''', '', '''') + ''['' + name + ''] AS ''''td''''''
    FROM tempdb.sys.columns 
    WHERE object_id = object_id(''tempdb..#dynSql'')
    ORDER BY column_id;

    SET @cols = ''SET @html = CAST(( SELECT '' + @cols + '' FROM #dynSql ' + @orderBy + ' FOR XML PATH(''''tr''''), ELEMENTS XSINIL) AS nvarchar(max))''    

    EXEC sys.sp_executesql @cols, N''@html nvarchar(MAX) OUTPUT'', @html=@html OUTPUT

    SELECT @headerRow = COALESCE(@headerRow + '''', '''') + ''<th>'' + name + ''</th>'' 
    FROM tempdb.sys.columns 
    WHERE object_id = object_id(''tempdb..#dynSql'')
    ORDER BY column_id;

    SET @headerRow = ''<tr>'' + @headerRow + ''</tr>'';

    SET @html = ''<table border="' + CAST(@border AS VARCHAR) + '">'' + @headerRow + @html + ''</table>'';    
    ';

  EXEC sys.sp_executesql @realQuery, N'@html nvarchar(MAX) OUTPUT', @html=@html OUTPUT
  SET @html = REPLACE(@html,' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"','')
  SET @html = REPLACE(@html,'&lt;','<')
  SET @html = REPLACE(@html,'&gt;','>')
  
END




GO
/****** Object:  StoredProcedure [jtts].[Json Select Export]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ========================================================================================================================================
-- Author:		Jim Miller, BITracks Consulting
-- Create date: 08 Mar 2017
-- Modify date: 15 Mar 2017 - Added SQL Platform and Product Version
-- Modify date: 28 Mar 2017 - Fix to handle single quotes
-- 
-- Description:	Export Single Select Statement to Json File
/*
EXEC [jtts].[Json Select Export] 'SELECT * FROM [biml].[added_dim_column_names]'
EXEC [jtts].[Json Select Export] 'SELECT * FROM [biml].[added_dim_column_names] WHERE [added_dim_column_names_tag] = ''Standard'''
*/
-- ========================================================================================================================================

CREATE PROCEDURE [jtts].[Json Select Export] 
(
		  @SQLString NVARCHAR(MAX)
 )
AS

/* return values with initial settings */
DECLARE	@return_code AS INT = 1 /* error setting */
	  , @error_message AS NVARCHAR(2000) = '<not set>';

IF ( RTRIM(COALESCE( @SQLString, '' )) = '' )
	BEGIN
		SET @error_message = 'Must provide Select Statement'
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END


DECLARE @ParmDefinition NVARCHAR(4000)
	  , @ReturnCode INT
	  , @UserName NVARCHAR(255)
	  , @BegTime DATETIME
	  , @EndTime DATETIME
	  , @ResultSet NVARCHAR(MAX)
	  , @ErrorMessage NVARCHAR(4000)
	  , @SchemaResultSetSelect NVARCHAR(4000)
	  , @SchemaResultSet NVARCHAR(4000)
	  , @ResultSetSelect NVARCHAR(MAX)
	  , @Json NVARCHAR(MAX)
	  , @FileName NVARCHAR(255);


SET @BegTime = GETDATE()
SET @UserName = SUSER_NAME()
SET @ErrorMessage = ''

SET @SchemaResultSetSelect =
	'SELECT is_hidden, column_ordinal, [name], is_nullable, system_type_id, system_type_name, max_length, [precision], scale, is_identity_column, is_computed_column
		FROM sys.dm_exec_describe_first_result_set ( ''' + REPLACE(@SQLString, '''', '''''') + ''', N'''', 0 ) '

SET @SchemaResultSetSelect = N'SET @Result_Set_OUT = ( ' + @SchemaResultSetSelect + ' FOR JSON AUTO )';

SET @ResultSetSelect = N'SET @Result_Set_OUT = ( ' + @SQLString + ' FOR JSON AUTO )';
SET @ParmDefinition = N'@Result_Set_OUT NVARCHAR(MAX) OUTPUT';


-- get schema for result set
BEGIN TRY
	EXECUTE @ReturnCode = sp_executesql
			@SchemaResultSetSelect
		  , @ParmDefinition
		  , @Result_Set_OUT = @SchemaResultSet OUTPUT;
END TRY
BEGIN CATCH
	SET @ErrorMessage = 'Schema: ' + ERROR_MESSAGE()
	SELECT @return_code AS [return code], @ErrorMessage AS [error message]
	RETURN
END CATCH


-- get result set
BEGIN TRY
	EXECUTE @ReturnCode = sp_executesql
			@ResultSetSelect
		  , @ParmDefinition
		  , @Result_Set_OUT = @ResultSet OUTPUT;
END TRY
BEGIN CATCH
	SET @ErrorMessage = 'Result: ' + ERROR_MESSAGE()
	SELECT @return_code AS [return code], @ErrorMessage AS [error message]
	RETURN
END CATCH


SET @EndTime = GETDATE()


BEGIN TRY
SET @Json =
(
SELECT @@SERVERNAME AS [server_name]
	 , DB_NAME() AS [database_name]
	 , N'SQL Server' AS [sql_platform]
	 , CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(64)) AS [product_version]
	 , @BegTime AS [start_time]
	 , @EndTime AS [end_time]
	 , @SchemaResultSet AS [select_schema]
	 , @ResultSet AS [result_set]
FOR JSON PATH, INCLUDE_NULL_VALUES  ---- , WITHOUT_ARRAY_WRAPPER
);
END TRY
BEGIN CATCH
	SET @ErrorMessage = 'Set Json: ' + ERROR_MESSAGE()
	SELECT @return_code AS [return code], @ErrorMessage AS [error message]
	RETURN
END CATCH

--PRINT @Json

SET @FileName = 'F-' + REPLACE(REPLACE(CONVERT(VARCHAR, GETDATE(), 126), ':', '-'), '.', '-') + '-SRV-' + REPLACE(@@SERVERNAME, '\', '~') + '_' + LEFT(CONVERT(varchar(255), NEWID()),8) + '.json'

BEGIN TRY
	INSERT INTO [FileTableDB].[dbo].[JTTS_Out] ( name, file_stream ) 
	SELECT @FileName, CAST(@Json AS VARBINARY(MAX));
END TRY
BEGIN CATCH
	SET @ErrorMessage = 'Insert: ' + ERROR_MESSAGE()
	SELECT @return_code AS [return code], @ErrorMessage AS [error message]
	RETURN
END CATCH


SET @return_code = 0
SET @error_message = ''

PRINT 'Export Complete!'

SELECT @return_code AS [return code], @FileName AS [json file]


GO
/****** Object:  StoredProcedure [jtts].[Json Select Import]    Script Date: 5/3/2018 8:48:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================================================================
-- Author:		Jim Miller, BITracks Consulting
-- Create date: 08 Mar 2017
-- Modify date: 09 Mar 2017 - Added check for aligned Json file
-- Modify date: 15 Mar 2017 - Added SQL Platform and Product Version Check
--
-- Description:	Load Json Table Transfer Object into Table
/*
EXEC [jtts].[Json Select Import] 'F-2017-03-08T16-07-00-470-SRV-JIMYOGA~SQL2016DEV_BCB91CF4.json', 'biml', 'added_dim_column_names', 'Y', 'Y', 'Y'
*/
-- ================================================================================================================================================
CREATE PROCEDURE [jtts].[Json Select Import] 
(
	    @FileName NVARCHAR(255)
	  , @DstSchema NVARCHAR(255)
	  , @DstTable NVARCHAR(255)
	  , @TruncateDstTable NVARCHAR(1)
      , @IsIdentityInsert NVARCHAR(1)
	  , @Use_JTTS_Out_Directory NVARCHAR(1) = N'N'

)
AS

SET NOCOUNT ON;

/* return values with initial settings */
DECLARE	@return_code AS INT = 1 /* error setting */
	  , @error_message AS NVARCHAR(2000) = '<not set>';

IF ( RTRIM(COALESCE( @FileName, '' )) = '' )
	BEGIN
		SET @error_message = 'Must provide a Json File Name'
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

IF ( RTRIM(COALESCE( @DstSchema, '' )) = '' )
	BEGIN
		SET @error_message = 'Must provide a Destination Schema Name'
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

IF ( RTRIM(COALESCE( @DstTable, '' )) = '' )
	BEGIN
		SET @error_message = 'Must provide a Destination Table Name'
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

IF ( RTRIM(COALESCE( @TruncateDstTable, '' )) NOT IN ('Y', 'N') )
	BEGIN
		SET @error_message = 'Must specify ''Y'' or ''N'' for the Truncate Table option'
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

IF ( RTRIM(COALESCE( @IsIdentityInsert, '' )) NOT IN ('Y', 'N') )
	BEGIN
		SET @error_message = 'Must specify ''Y'' or ''N'' for the Identity Insert option'
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

IF ( RTRIM(COALESCE( @Use_JTTS_Out_Directory, '' )) NOT IN ('Y', 'N') )
	BEGIN
		SET @error_message = 'Must specify ''Y'' or ''N'' for the ''Use JTTS Out Directory'' option'
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END

IF CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(64)) < '13.0.4001.0'
	BEGIN
		SET @error_message = 'Must use destination SQL Server version of 13.0.4001.0 or greater. Running on version: ' + CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(64))
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END


DECLARE @SchemaResultSetSelect NVARCHAR(4000)
	  , @SchemaResultSet NVARCHAR(4000)
	  , @SQLString NVARCHAR(4000)
	  , @RowCountSelect NVARCHAR(4000)
	  , @RowJson NVARCHAR(MAX)
	  , @SchemaJson NVARCHAR(MAX)
	  , @Json NVARCHAR(MAX)
	  , @sql_platform NVARCHAR(64)
	  , @product_version NVARCHAR(64)
	  , @ColumnXML XML
	  , @ColumnSTR VARCHAR(MAX)
	  , @WithXML XML
      , @WithSTR VARCHAR(MAX)
	  , @sql NVARCHAR(MAX)
	  , @ReturnCode INT
	  , @ResultSet NVARCHAR(MAX);


BEGIN TRY

	IF @Use_JTTS_Out_Directory = 'Y'
		SELECT @RowJson = CAST([file_stream] AS NVARCHAR(MAX)) FROM [FileTableDB].[dbo].[JTTS_Out] WHERE [name] = @FileName
	ELSE
		SELECT @RowJson = CAST([file_stream] AS NVARCHAR(MAX)) FROM [FileTableDB].[dbo].[JTTS_In] WHERE [name] = @FileName;

	SELECT @sql_platform = [sql_platform]
		 , @product_version = [product_version]
		 , @SchemaJson = [select_schema]
		 , @Json = [result_set]
      FROM OPENJSON(@RowJson) 
      WITH (   [sql_platform] [nvarchar](64)
			 , [product_version] [nvarchar](64)
			 , [select_schema] [nvarchar](max)
		     , [result_set] [nvarchar](max)
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
		SET @error_message = 'Json [result_set] is null'
		SELECT @return_code AS [return code], @error_message AS [error message]
		RETURN
	END


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

	WITH [result schema] AS
	(
	SELECT * FROM  
	OPENJSON(@SchemaJson)  
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
			SELECT @return_code AS [return code], 'No Column(s) found' AS [error message]
			RETURN
		END

	/* place results in temp table */
	SELECT @Json AS [result_set] INTO #import_table


	/* build insert statement */
	SET @sql = '
	DECLARE @RowJson NVARCHAR(MAX)
		  , @SchemaJson NVARCHAR(MAX)
		  , @Json NVARCHAR(MAX); '

	IF @TruncateDstTable = 'Y'
		SET @sql = @sql + '
	TRUNCATE TABLE [' + @DstSchema + '].[' + @DstTable + '];'

	IF @IsIdentityInsert = 'Y'
		SET @sql = @sql + '
	SET IDENTITY_INSERT [' + @DstSchema + '].[' + @DstTable + '] ON;'
	SET @sql = @sql + '
	SELECT @Json = [result_set] FROM #import_table;

	INSERT [' + @DstSchema + '].[' + @DstTable + ']
	( ' + @ColumnSTR + '
	)
	SELECT * FROM  OPENJSON ( @json ) WITH (' + @WithSTR + '       ) rc ;'

	IF @IsIdentityInsert = 'Y'
		SET @sql = @sql + '
	SET IDENTITY_INSERT [' + @DstSchema + '].[' + @DstTable + '] OFF;'

	SET NOCOUNT OFF;

	--print @sql
	EXECUTE @ReturnCode = sp_executesql
			@sql

	SET @return_code = @ReturnCode
	SET @error_message = ''
	PRINT 'Import Complete!'
	SELECT @return_code AS [return code], @error_message AS [error message]
	RETURN

END TRY
BEGIN CATCH
	SELECT @return_code AS [return code], 'Import Failed!' AS [error message]
END CATCH


GO
/****** Object:  StoredProcedure [jtts].[Json Table Export]    Script Date: 5/3/2018 8:48:50 AM ******/
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
EXEC [jtts].[Json Table Export] 'FQ-v1', 'include', 'biml.package_config (CT Replication),biml.query_repository'
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
/****** Object:  StoredProcedure [jtts].[Json Table Import]    Script Date: 5/3/2018 8:48:50 AM ******/
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


---------------- table inserts

SET IDENTITY_INSERT [biml].[added_dim_column_names] ON 
GO
INSERT [biml].[added_dim_column_names] ([added_dim_column_names_id], [added_dim_column_names_tag], [row_is_current], [row_effective_date], [row_expiration_date], [row_insert_date], [row_update_date]) VALUES (1, N'Standard', N'row_is_current', N'row_effective_date', N'row_expiration_date', N'row_insert_date', N'row_update_date')
GO
INSERT [biml].[added_dim_column_names] ([added_dim_column_names_id], [added_dim_column_names_tag], [row_is_current], [row_effective_date], [row_expiration_date], [row_insert_date], [row_update_date]) VALUES (2, N'Custom 1', N'ETL_Is_Current', N'ETL_Effective_Date', N'ETL_Expiration_Date', N'ETL_Insert_Date', N'ETL_Update_Date')
GO
INSERT [biml].[added_dim_column_names] ([added_dim_column_names_id], [added_dim_column_names_tag], [row_is_current], [row_effective_date], [row_expiration_date], [row_insert_date], [row_update_date]) VALUES (3, N'Standard UC', N'ROW_IS_CURRENT', N'ROW_EFFECTIVE_DATE', N'ROW_EXPIRATION_DATE', N'ROW_INSERT_DATE', N'ROW_UPDATE_DATE')
GO
SET IDENTITY_INSERT [biml].[added_dim_column_names] OFF
GO
INSERT [biml].[pattern] ([pattern_name], [has_config_table], [author_id], [description]) VALUES (N'Data Flow', N'Y', 1, NULL)
GO
INSERT [biml].[pattern] ([pattern_name], [has_config_table], [author_id], [description]) VALUES (N'Execute Process', N'Y', 1, NULL)
GO
INSERT [biml].[pattern] ([pattern_name], [has_config_table], [author_id], [description]) VALUES (N'Execute Script', N'Y', 1, NULL)
GO
INSERT [biml].[pattern] ([pattern_name], [has_config_table], [author_id], [description]) VALUES (N'Execute SQL', N'Y', 1, NULL)
GO
INSERT [biml].[pattern] ([pattern_name], [has_config_table], [author_id], [description]) VALUES (N'Foreach Data Flow', N'Y', 1, NULL)
GO
INSERT [biml].[pattern] ([pattern_name], [has_config_table], [author_id], [description]) VALUES (N'Foreach Execute SQL', N'Y', 1, NULL)
GO
INSERT [biml].[pattern] ([pattern_name], [has_config_table], [author_id], [description]) VALUES (N'Package Group', N'N', 1, NULL)
GO
INSERT [biml].[pattern] ([pattern_name], [has_config_table], [author_id], [description]) VALUES (N'Run All', N'N', 1, NULL)
GO



EXEC [biml].[Build Templates];
GO