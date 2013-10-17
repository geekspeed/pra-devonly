CREATE TABLE [dbo].[tbl_User_Country]
(
[UserId] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CountryCode] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CountryName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
