/*
BSD 3-Clause License

Copyright (c) 2019, BI Tracks Consulting, LLC
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

CREATE DATABASE [SSIS_Data];
GO


USE [SSIS_Data]
GO
/****** Object:  UserDefinedFunction [dbo].[get_last_sync_number]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 03 Dec 2018
-- Modify date: 
--
-- Description:	Returns the last completed sync (version) number for CT tracked database
--
-- Sample Execute Command: 
/*	
PRINT [dbo].[get_last_sync_number]
	 (
	    'PC1'		-- @src_server_name 
	  , 'PC1'		-- @dst_server_name  
	  , 'landing_zone'	-- @src_database_name 
	  , 'ODS'	        -- @dst_database_name  
	 )
*/
-- ================================================================================================

CREATE FUNCTION [dbo].[get_last_sync_number]
(
	    @src_server_name NVARCHAR(128) = 'DDP_LZ_DEV'
	  , @dst_server_name NVARCHAR(128) = 'DDP_ODS_DEV'
	  , @src_database_name NVARCHAR(128) = 'DDP_LZ_DEV'
	  , @dst_database_name NVARCHAR(128) = 'DDP_ODS_DEV'
)
RETURNS BIGINT
AS
BEGIN
   
RETURN   
(  
	SELECT [last_sync_version]
	  FROM [dbo].[change_tracking_last_sync] sync
	 WHERE [src_server_name] = @src_server_name
	   AND [src_database_name] = @src_database_name
	   AND [dst_server_name] = @dst_server_name
	   AND [dst_database_name] = @dst_database_name
);  

END

GO
/****** Object:  Table [dbo].[change_tracking_last_sync]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[change_tracking_last_sync](
	[src_server_name] [nvarchar](128) NOT NULL,
	[src_database_name] [nvarchar](128) NOT NULL,
	[dst_server_name] [nvarchar](128) NOT NULL,
	[dst_database_name] [nvarchar](128) NOT NULL,
	[last_sync_version] [bigint] NOT NULL,
	[last_sync_start] [datetime] NULL,
	[last_sync_complete] [datetime] NULL,
 CONSTRAINT [PK_change_tracking_last_sync] PRIMARY KEY CLUSTERED 
(
	[src_server_name] ASC,
	[src_database_name] ASC,
	[dst_server_name] ASC,
	[dst_database_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[get_last_ct_version]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 05 Aug 2017
-- Modify date: 
-- Description:	Get Last Version
--
-- sample exec:
/*
SELECT [last_sync_version], [last_sync_start], [last_sync_complete] FROM [dbo].[get_last_ct_version] ('lyris', 'lyrisdb', 'localhost\SQLEXPRESS', 'report_data')
*/
-- ================================================================================================

CREATE FUNCTION [dbo].[get_last_ct_version] ( @src_server_name nvarchar(128), @src_database_name nvarchar(128), @dst_server_name nvarchar(128), @dst_database_name nvarchar(128) )
RETURNS TABLE  
AS  
RETURN   
(  
	SELECT [last_sync_version]
		 , [last_sync_start]
		 , [last_sync_complete]
	  FROM [dbo].[change_tracking_last_sync] sync
	 WHERE [src_server_name] = @src_server_name
	   AND [src_database_name] = @src_database_name
	   AND [dst_server_name] = @dst_server_name
	   AND [dst_database_name] = @dst_database_name
);  


GO
/****** Object:  Table [dbo].[change_tracking_sync_log]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[change_tracking_sync_log](
	[sync_log_id] [int] IDENTITY(1,1) NOT NULL,
	[src_server_name] [nvarchar](128) NOT NULL,
	[src_database_name] [nvarchar](128) NOT NULL,
	[dst_server_name] [nvarchar](128) NOT NULL,
	[dst_database_name] [nvarchar](128) NOT NULL,
	[next_sync_version] [bigint] NOT NULL,
	[next_sync_start] [datetime] NOT NULL,
 CONSTRAINT [PK change_tracking_sync_log] PRIMARY KEY CLUSTERED 
(
	[src_server_name] ASC,
	[src_database_name] ASC,
	[dst_server_name] ASC,
	[dst_database_name] ASC,
	[sync_log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[get_next_ct_version]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 05 Aug 2017
-- Modify date: 
-- Description:	Get Next Version
--
-- sample exec:
/*
SELECT [next_sync_version], [next_sync_start] FROM [dbo].[get_next_ct_version] ('lyris', 'lyrisdb', 'localhost\SQLEXPRESS', 'report_data')
*/
-- ================================================================================================

CREATE FUNCTION [dbo].[get_next_ct_version] ( @src_server_name nvarchar(128), @src_database_name nvarchar(128), @dst_server_name nvarchar(128), @dst_database_name nvarchar(128) )
RETURNS TABLE  
AS  
RETURN   
(  
	WITH [max_id] AS
	(
		SELECT MAX([sync_log_id]) AS [max_log_id]
		  FROM [dbo].[change_tracking_sync_log]
		 WHERE [src_server_name] = @src_server_name
		   AND [src_database_name] = @src_database_name
		   AND [dst_server_name] = @dst_server_name
		   AND [dst_database_name] = @dst_database_name
	)
	SELECT [next_sync_version]
		 , [next_sync_start]
	  FROM [dbo].[change_tracking_sync_log] sl
	  JOIN [max_id] mx
	    ON mx.[max_log_id] = sl.[sync_log_id]
);  


GO
/****** Object:  Table [dbo].[SSIS_batch_log]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SSIS_batch_log](
	[batch_id] [int] IDENTITY(1,1) NOT NULL,
	[project_name] [nvarchar](128) NOT NULL,
	[start_time] [datetime2](0) NOT NULL,
	[end_time] [datetime2](0) NOT NULL,
	[package_count] [int] NOT NULL,
	[row_count] [bigint] NULL,
	[run_status] [nvarchar](24) NOT NULL,
 CONSTRAINT [PK_batch_log] PRIMARY KEY CLUSTERED 
(
	[batch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SSIS_error_log]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SSIS_error_log](
	[error_log_id] [int] IDENTITY(1,1) NOT NULL,
	[log_time] [datetime2](0) NOT NULL,
	[sequence_number] [int] NOT NULL,
	[package_name] [nvarchar](128) NOT NULL,
	[error_number] [int] NULL,
	[error_description] [nvarchar](4000) NULL,
	[package_id] [nvarchar](128) NOT NULL,
	[server_execution_id] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_error_log_id] PRIMARY KEY CLUSTERED 
(
	[error_log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SSIS_execution_log]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SSIS_execution_log](
	[execution_log_id] [int] IDENTITY(1,1) NOT NULL,
	[project_name] [nvarchar](128) NOT NULL,
	[sequence_number] [int] NOT NULL,
	[package_name] [nvarchar](128) NOT NULL,
	[start_time] [datetime2](0) NOT NULL,
	[end_time] [datetime2](0) NOT NULL,
	[row_count] [bigint] NOT NULL,
	[server_execution_id] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_SSIS_execution_log] PRIMARY KEY CLUSTERED 
(
	[project_name] ASC,
	[sequence_number] ASC,
	[package_name] ASC,
	[server_execution_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SSIS_execution_log_history]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SSIS_execution_log_history](
	[execution_log_id] [int] IDENTITY(1,1) NOT NULL,
	[batch_id] [int] NOT NULL,
	[project_name] [nvarchar](128) NOT NULL,
	[sequence_number] [int] NOT NULL,
	[package_name] [nvarchar](128) NOT NULL,
	[start_time] [datetime2](0) NOT NULL,
	[end_time] [datetime2](0) NOT NULL,
	[row_count] [bigint] NOT NULL,
	[server_execution_id] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_SSIS_execution_log_history] PRIMARY KEY CLUSTERED 
(
	[execution_log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SSIS_runtime_values]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SSIS_runtime_values](
	[runtime_value_id] [int] IDENTITY(1,1) NOT NULL,
	[server_execution_id] [nvarchar](128) NOT NULL,
	[runtime_key] [nvarchar](256) NOT NULL,
	[runtime_value] [nvarchar](max) NULL,
	[return_value] [nvarchar](max) NULL,
	[row_insert] [datetime] NOT NULL,
 CONSTRAINT [PK_SSIS_runtime_values] PRIMARY KEY CLUSTERED 
(
	[server_execution_id] ASC,
	[runtime_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[change_tracking_sync_log] ADD  CONSTRAINT [DF - change_tracking_sync_log - next_sync_start]  DEFAULT (getdate()) FOR [next_sync_start]
GO
/****** Object:  StoredProcedure [dbo].[BimlSnap - Metadata Refresh v2]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ================================================================================================
-- Author:		Jim Miller (BITracks Consulting, LLC)
-- Create date: 28 Apr 2018
-- Modify date: 
--
-- Sample Execute Command: 
/*	
EXEC [dbo].[BimlSnap - Metadata Refresh v2]
*/
-- ================================================================================================

CREATE PROCEDURE [dbo].[BimlSnap - Metadata Refresh v2]
AS
Declare @execution_id bigint
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Run All - Metadata Refresh v2.dtsx', @execution_id=@execution_id OUTPUT, @folder_name=N'BimlSnap', @project_name=N'Metadata Refresh v2', @use32bitruntime=False, @reference_id=Null
Select @execution_id
DECLARE @var0 bit = 0
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=20, @parameter_name=N'Force_Run_All', @parameter_value=@var0

DECLARE @var1 sql_variant = N'localhost'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=20, @parameter_name=N'Metadata_Server_Name', @parameter_value=@var1

DECLARE @var2 sql_variant = N'master'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=20, @parameter_name=N'SQL_Server_Database', @parameter_value=@var2

DECLARE @var3 sql_variant = N'SQLNCLI11'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=20, @parameter_name=N'SQL_Server_Provider', @parameter_value=@var3

DECLARE @var4 sql_variant = N'localhost'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=20, @parameter_name=N'SQL_Server_Server', @parameter_value=@var4

DECLARE @var5 sql_variant = N'SSIS_Data'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=20, @parameter_name=N'SSIS_Data_Database', @parameter_value=@var5

DECLARE @var6 sql_variant = N'SQLNCLI11'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=20, @parameter_name=N'SSIS_Data_Provider', @parameter_value=@var6

DECLARE @var7 sql_variant = N'localhost'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=20, @parameter_name=N'SSIS_Data_Server', @parameter_value=@var7

DECLARE @var8 sql_variant = N'bimlsnap_mart_v2'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=20, @parameter_name=N'bimlsnap_mart_v2_Database', @parameter_value=@var8

DECLARE @var9 sql_variant = N'SQLNCLI11'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=20, @parameter_name=N'bimlsnap_mart_v2_Provider', @parameter_value=@var9

DECLARE @var10 sql_variant = N'localhost'
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=20, @parameter_name=N'bimlsnap_mart_v2_Server', @parameter_value=@var10

DECLARE @var11 smallint = 1
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=@var11

EXEC [SSISDB].[catalog].[start_execution] @execution_id

GO
/****** Object:  StoredProcedure [dbo].[Job Complete Wait Routine]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Job Complete Wait Routine] 
	  @max_wait_minutes INT
	, @job_name VARCHAR(50)
AS
-- ================================================================================================
-- Author:		Jim Miller
-- Create date: 26 Sep 2016
-- Modify date: 
-- Description:	Wait routine for job to complete
--
--
/* examples
EXEC [dbo].[Job Complete Wait Routine] 240, 'Run All - snap_build Replication.dtsx'
*/

-- ================================================================================================

DECLARE @routine_start DATETIME
    SET @routine_start = GETDATE()

DECLARE @row_count INT = -1

WHILE 1=1
BEGIN
	SELECT @row_count=COUNT(*) 
	  FROM SSISDB.catalog.executions 
	 WHERE STATUS = 2 -- running
	   AND [package_name] = @job_name

	IF @row_count = 0
		BREAK

	IF GETDATE() > DATEADD(MINUTE, @max_wait_minutes, @routine_start)
		BREAK

	WAITFOR DELAY '00:00:10';
END

IF @row_count != 0

	INSERT [dbo].[SSIS_error_log]
		 ( [log_time]
		 , [sequence_number]
		 , [package_name]
		 , [error_number]
		 , [error_description]
		 , [package_id]
		 , [server_execution_id])
		 VALUES
		( GETDATE()
		, 0
		, 'SP: [dbo].[Job Complete Wait Routine]'
		, 0
		, 'Timeout waiting for Job to complete: ' + @job_name
		, 'n/a'
		, 'n/a'
		)


GO
/****** Object:  StoredProcedure [dbo].[Log Error]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Log Error] 
	  @sequence_number INT
	, @package_name NVARCHAR(128)
	, @error_number INT
	, @error_description NVARCHAR(4000)
	, @package_id NVARCHAR(128)
	, @server_execution_id NVARCHAR(128)
AS
-- ================================================================================================
-- Author:		Jim Miller 
-- Create date: 27 Jun 2016
-- Modify date: 
-- Description:	Record a completed project run
--
-- ================================================================================================

DECLARE @log_time DATETIME2(0)
    SET @log_time = GETDATE()

SET @package_id = UPPER(REPLACE(REPLACE(@package_id, '{', ''), '}', ''))
SET @server_execution_id = UPPER(REPLACE(REPLACE(@server_execution_id, '{', ''), '}', ''))

INSERT [dbo].[SSIS_error_log]
     ( [log_time]
     , [sequence_number]
     , [package_name]
     , [error_number]
     , [error_description]
     , [package_id]
     , [server_execution_id])
     VALUES
	( @log_time
	, @sequence_number
	, @package_name
	, @error_number
	, @error_description
	, @package_id
	, @server_execution_id
	)





GO
/****** Object:  StoredProcedure [dbo].[Log Package Complete]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller
-- Create date: 17 Jun 2016
-- Modify date: 24 Jun 2016 - Added insert to batch table
-- Modify date: 07 Nov 2017 - Pull row_count from [SSIS_runtime_values] if exists
--
-- Description:	Insert log row for package complete
--
-- ================================================================================================

CREATE PROCEDURE [dbo].[Log Package Complete] 
	  @project_name NVARCHAR(128)
	, @sequence_number NVARCHAR(128)
	, @package_name NVARCHAR(128)
	, @start_time DATETIME2
	, @row_count INT
	, @server_execution_id NVARCHAR(128)
AS
DECLARE @end_time DATETIME2
    SET @end_time = GETDATE()

SET @server_execution_id = UPPER(REPLACE(REPLACE(@server_execution_id, '{', ''), '}', ''))

IF RTRIM(@server_execution_id) = ''
	SET @server_execution_id = 'Not Available'

-- check to see if row_count is in [SSIS_runtime_values]
DECLARE @row_count_from_log INT
SELECT @row_count_from_log = CAST([runtime_value] AS INT)
  FROM [dbo].[SSIS_runtime_values]
 WHERE [server_execution_id] = @server_execution_id
   AND [runtime_key] = 'Result::row_count'

SET @row_count = COALESCE(@row_count_from_log, @row_count, 0)

IF EXISTS 
	(	SELECT 1 
		FROM [dbo].[SSIS_execution_log]
		WHERE [project_name] = @project_name
		AND [sequence_number] = CAST(@sequence_number AS INT)
		AND [package_name] = @package_name
		AND [server_execution_id] = @server_execution_id
	)
	BEGIN -- forced re-run from Visual Studio
		UPDATE [dbo].[SSIS_execution_log]
		   SET [start_time] = @start_time
			 , [end_time] = @end_time
			 , [row_count] = @row_count
		 WHERE [project_name] = @project_name
		   AND [sequence_number] = CAST(@sequence_number AS INT)
		   AND [package_name] = @package_name
		   AND [server_execution_id] = @server_execution_id
	END
ELSE
	BEGIN
		INSERT [dbo].[SSIS_execution_log]
			 ( [project_name]
			 , [sequence_number]
			 , [package_name]
			 , [start_time]
			 , [end_time]
			 , [row_count]
			 , [server_execution_id])
		VALUES
			( @project_name
			, CAST(@sequence_number AS INT)
			, @package_name
			, @start_time
			, @end_time
			, @row_count
			, @server_execution_id
			)
	END;



GO
/****** Object:  StoredProcedure [dbo].[Log Project Complete]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =======================================================================================================
-- Author:		Jim Miller 
-- Create date: 17 Jun 2016
-- Modify date: 24 Jun 2016 - Added insert to batch table
-- Modify date: 26 Jun 2016 - Changed [SSIS_execution_log_history] INSERT to exclude [execution_log_id]
-- Modify date: 23 Dec 2017 - Changed @row_count to BIGINT
-- Description:	Record a completed project run
--
-- =======================================================================================================

CREATE PROCEDURE [dbo].[Log Project Complete] 
	@project_name NVARCHAR(128)
AS

DECLARE @start_time [datetime2](0)
	  , @end_time [datetime2](0)
	  , @package_count INT
	  , @row_count BIGINT
	  , @scope_id INT

SELECT @package_count = COUNT(*)
  FROM [dbo].[SSIS_execution_log]
 WHERE [project_name] = @project_name

 -- exit procedure if no rows are found
IF @package_count = 0
	BEGIN
		PRINT 'No package execution rows found!'
		RETURN
	END

SELECT @start_time = MIN([start_time])
  FROM [dbo].[SSIS_execution_log]
 WHERE [project_name] = @project_name

SELECT @end_time = MAX([end_time])
  FROM [dbo].[SSIS_execution_log]
 WHERE [project_name] = @project_name

 SELECT @row_count = SUM([row_count])
  FROM [dbo].[SSIS_execution_log]
 WHERE [project_name] = @project_name


-- insert batch log row
INSERT INTO [dbo].[SSIS_batch_log]
           ([project_name]
           ,[start_time]
           ,[end_time]
           ,[package_count]
           ,[row_count]
           ,[run_status])

 SELECT @project_name AS [project_name]
	  , @start_time AS [start_time]
	  , @end_time AS [end_time]
	  , @package_count AS [package_count]
	  , @row_count AS [row_count]
	  , 'Completed' AS [run_status]


-- get the id of the above insert
SET @scope_id = SCOPE_IDENTITY() 


-- move rows to execution history table
INSERT [dbo].[SSIS_execution_log_history]
     ( [batch_id]
     , [project_name]
     , [sequence_number]
     , [package_name]
     , [start_time]
     , [end_time]
     , [row_count]
     , [server_execution_id]
	 )
SELECT @scope_id
	 , [project_name]
     , [sequence_number]
     , [package_name]
     , [start_time]
     , [end_time]
     , [row_count]
     , [server_execution_id]
  FROM [dbo].[SSIS_execution_log]
 WHERE [project_name] = @project_name
 
DELETE [dbo].[SSIS_execution_log]
 WHERE [project_name] = @project_name








GO
/****** Object:  StoredProcedure [dbo].[Prior Run Cleanup]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller 
-- Create date: 27 Jun 2016
-- Modify date: 07 Nov 2016 - Bug Fix with [batch_id] insert
-- Description:	Check for prior incomplete run of project
--
-- Sample Execute Command:
/*	
EXEC [dbo].[Prior Run Cleanup] 'EDW Refresh'
EXEC [dbo].[Prior Run Cleanup] 'EDW Refresh Hist'
*/
-- ================================================================================================

CREATE PROCEDURE [dbo].[Prior Run Cleanup] 
	@project_name NVARCHAR(128)
AS

DECLARE @start_time [datetime2](0)
	  , @end_time [datetime2](0)
	  , @package_count INT
	  , @row_count INT
	  , @scope_id INT

SELECT @package_count = COUNT(*)
  FROM [dbo].[SSIS_execution_log]
 WHERE [project_name] = @project_name

 -- exit procedure if no rows are found
IF @package_count = 0
	BEGIN
		PRINT 'No clean-up needed'
		RETURN
	END

SELECT @start_time = MIN([start_time])
  FROM [dbo].[SSIS_execution_log]
 WHERE [project_name] = @project_name

SELECT @end_time = MAX([end_time])
  FROM [dbo].[SSIS_execution_log]
 WHERE [project_name] = @project_name

 SELECT @row_count = SUM([row_count])
  FROM [dbo].[SSIS_execution_log]
 WHERE [project_name] = @project_name


-- insert batch log row
INSERT INTO [dbo].[SSIS_batch_log]
           ([project_name]
           ,[start_time]
           ,[end_time]
           ,[package_count]
           ,[row_count]
           ,[run_status])

 SELECT @project_name AS [project_name]
	  , @start_time AS [start_time]
	  , @end_time AS [end_time]
	  , @package_count AS [package_count]
	  , @row_count AS [row_count]
	  , 'Incomplete Run' AS [run_status]

-- get the id of the above insert
SET @scope_id = SCOPE_IDENTITY()

-- move rows to execution history table
INSERT [dbo].[SSIS_execution_log_history]
     ( [batch_id]
     , [project_name]
     , [sequence_number]
     , [package_name]
     , [start_time]
     , [end_time]
     , [row_count]
     , [server_execution_id]
	 )
SELECT @scope_id
	 , [project_name]
     , [sequence_number]
     , [package_name]
     , [start_time]
     , [end_time]
     , [row_count]
     , [server_execution_id]
  FROM [dbo].[SSIS_execution_log]
 WHERE [project_name] = @project_name
 
DELETE [dbo].[SSIS_execution_log]
 WHERE [project_name] = @project_name





GO
/****** Object:  StoredProcedure [dbo].[Put Value]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Jim Miller 
-- Create date: 13 May 2017
-- Modify date: 17 Aug 2017 - Changed @runtime_value to NVARCHAR(MAX)
--
-- Description:	Place runtime value into SSIS_Data database
-- ================================================================================================

CREATE PROCEDURE [dbo].[Put Value] 
	  @server_execution_id NVARCHAR(128)
	, @runtime_key NVARCHAR(128)
	, @runtime_value NVARCHAR(MAX)
AS

DECLARE @log_time DATETIME;
    SET @log_time = GETDATE();

SET @server_execution_id = UPPER(REPLACE(REPLACE(@server_execution_id, '{', ''), '}', ''));

INSERT [dbo].[SSIS_runtime_values]
     ( [server_execution_id]
     , [runtime_key]
     , [runtime_value]
     , [row_insert])
VALUES
     ( @server_execution_id
     , @runtime_key
     , @runtime_value
     , @log_time
	 );


GO
/****** Object:  StoredProcedure [dbo].[Run Package Check]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Jim Miller
-- Create date: 10 Jun 2016
-- Modify date: 01 Aug 2016 - Added clean-up logic for previous incomplete runs
-- Description:	Checks to see if package has already sucessfully run
--
-- Sample Execute Command: 
/*	
EXEC [dbo].[Run Package Check] 'EDW Refresh', '200', 'Execute SQL - INSERT - Dimension Unknown Member'
*/
-- ================================================================================================


CREATE PROCEDURE [dbo].[Run Package Check] 
	  @project_name NVARCHAR(128)
	, @sequence_number NVARCHAR(128)
	, @package_name NVARCHAR(128)
AS


DECLARE @package_count INT = 0
	  , @sql_command NVARCHAR(4000)


-----------------------------------------------------------
-- clean-up logic for previous incomplete run of project --
-----------------------------------------------------------

SELECT @package_count = COUNT(*)
  FROM [dbo].[SSIS_execution_log]
 WHERE [project_name] = @project_name
   AND DATEDIFF(hh, [start_time], GETDATE()) > 18 --<-- NOTE: the number '18' is hardcoded. This value would not apply for projects running longer than 18 hours.

-- run clean-up procedure if any rows are found
IF @package_count > 0
       BEGIN
              PRINT 'Clean-up needed'
              SET @sql_command = '[dbo].[Prior Run Cleanup] ''' + @project_name + ''''
              EXEC sp_executesql @sql_command
       END


-----------------------------------------------
-- Check for previous successful package run --
-----------------------------------------------

IF EXISTS 
	(	SELECT 1 
		FROM [dbo].[SSIS_execution_log]
		WHERE [project_name] = @project_name
		AND [sequence_number] = CAST(@sequence_number AS INT)
		AND [package_name] = @package_name
	)
	BEGIN
		SELECT CAST(0 as BIT) AS [execute_package] -- skip task 
	END
ELSE
	BEGIN
		SELECT CAST(1 as BIT) AS [execute_package] -- run task
	END



GO
/****** Object:  StoredProcedure [dbo].[Update Change Tracking Last Sync]    Script Date: 5/11/2019 10:12:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:  Jim Miller (BI Tracks Consulting, LLC)
-- Create date: 30 Nov 2018
-- Modify date: 
--
-- Description:	Update (or insert to initialize) the Change Tracking Last Sync
--
-- Sample Execute Command: 
/* 
EXEC [dbo].[Update Change Tracking Last Sync] 'src_server', 'src_database', 'dst_server', 'dst_database'
*/
-- ================================================================================================

CREATE PROCEDURE [dbo].[Update Change Tracking Last Sync] 
	   @src_server_name NVARCHAR(128)
	 , @src_database_name NVARCHAR(128)
	 , @dst_server_name NVARCHAR(128)
	 , @dst_database_name NVARCHAR(128)

AS

DECLARE @next_sync_version BIGINT
      , @next_sync_start DATETIME
      , @row_count INT;
 
 SELECT @next_sync_version = [next_sync_version] 
   , @next_sync_start = [next_sync_start]
   FROM [dbo].[get_next_ct_version] (@src_server_name, @src_database_name, @dst_server_name, @dst_database_name)

 UPDATE [dbo].[change_tracking_last_sync]
 SET [last_sync_version]  = @next_sync_version
   , [last_sync_start]    = @next_sync_start
   , [last_sync_complete] = GETDATE()
  WHERE [src_server_name]   = @src_server_name
 AND [src_database_name] = @src_database_name
 AND [dst_server_name]   = @dst_server_name
 AND [dst_database_name] = @dst_database_name

 SET @row_count = @@ROWCOUNT

 IF @row_count = 0
 BEGIN
  INSERT [dbo].[change_tracking_last_sync]
    ( [src_server_name]
    , [src_database_name]
    , [dst_server_name]
    , [dst_database_name]
    , [last_sync_version]
    , [last_sync_start]
    , [last_sync_complete] )
  VALUES 
    ( @src_server_name
    , @src_database_name
    , @dst_server_name
    , @dst_database_name
    , @next_sync_version
    , @next_sync_start
    , GETDATE()
    );
  SET @row_count = @@ROWCOUNT;
 END

-- auto clean-up
DELETE [dbo].[change_tracking_sync_log]
 WHERE CAST([next_sync_start] AS DATE) < GETDATE()-7; 

SET @row_count = @row_count + @@ROWCOUNT;

SELECT @row_count AS [row_count]
GO

