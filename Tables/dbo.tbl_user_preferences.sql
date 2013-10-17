CREATE TABLE [dbo].[tbl_user_preferences]
(
[userid] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[preference_attribute] [varchar] (43) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[recipients] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[active] [bit] NOT NULL,
[created_date] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
