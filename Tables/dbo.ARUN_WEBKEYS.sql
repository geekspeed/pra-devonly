CREATE TABLE [dbo].[ARUN_WEBKEYS]
(
[TYPE] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PREFIX] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[KEYLENGTH] [int] NOT NULL,
[SEED] [int] NOT NULL,
[INCREMENT] [int] NOT NULL,
[CURVAL] [int] NOT NULL,
[COMMENTS] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PADDING] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ARUN_WEBKEYS] ADD CONSTRAINT [PK_TYPE] PRIMARY KEY CLUSTERED  ([TYPE]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ARUN_WEBKEYS] ADD CONSTRAINT [UQ__ARUN_WEB__80334AA14460231C] UNIQUE NONCLUSTERED  ([TYPE]) ON [PRIMARY]
GO
