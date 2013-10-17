CREATE TABLE [dbo].[tbl_temp_ad]
(
[Name] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Department] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LoginId] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mail] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CountryCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
