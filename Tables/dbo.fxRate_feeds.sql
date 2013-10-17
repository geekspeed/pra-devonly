CREATE TABLE [dbo].[fxRate_feeds]
(
[fxrate_id] [int] NOT NULL IDENTITY(1, 1),
[fxdate] [datetime] NOT NULL,
[from_name] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[from_symbol] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[to_name] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[to_symbol] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[frate] [float] NOT NULL,
[crate] [float] NOT NULL,
[text] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[type] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[active] [bit] NOT NULL,
[created_date] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[fxRate_feeds] ADD CONSTRAINT [PK_fxRate_feeds] PRIMARY KEY CLUSTERED  ([fxrate_id]) ON [PRIMARY]
GO
