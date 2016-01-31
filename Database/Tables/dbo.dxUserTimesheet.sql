CREATE TABLE [dbo].[dxUserTimesheet]
(
[PK_dxUserTimesheet] [int] NOT NULL IDENTITY(1, 1),
[ID] [varchar] (50) COLLATE French_CI_AS NOT NULL,
[StartDate] [datetime] NOT NULL CONSTRAINT [DF_dxUserTimesheet_StartDate] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[EndDate] [datetime] NOT NULL CONSTRAINT [DF_dxUserTimesheet_EndDate] DEFAULT (CONVERT([datetime],CONVERT([int],getdate(),(0)),(0))),
[WeekNumber] [int] NOT NULL,
[FK_dxUser] [int] NOT NULL,
[Day1Hours] [float] NOT NULL CONSTRAINT [DF_dxUserTimesheet_Day1Hours] DEFAULT ((0.0)),
[Day2Hours] [float] NOT NULL CONSTRAINT [DF_dxUserTimesheet_Day2Hours] DEFAULT ((0.0)),
[Day3Hours] [float] NOT NULL CONSTRAINT [DF_dxUserTimesheet_Day3Hours] DEFAULT ((0.0)),
[Day4Hours] [float] NOT NULL CONSTRAINT [DF_dxUserTimesheet_Day4Hours] DEFAULT ((0.0)),
[Day5Hours] [float] NOT NULL CONSTRAINT [DF_dxUserTimesheet_Day5Hours] DEFAULT ((0.0)),
[Day6Hours] [float] NOT NULL CONSTRAINT [DF_dxUserTimesheet_Day6Hours] DEFAULT ((0.0)),
[Day7Hours] [float] NOT NULL CONSTRAINT [DF_dxUserTimesheet_Day7Hours] DEFAULT ((0.0)),
[TotalHours] [float] NOT NULL CONSTRAINT [DF_dxUserTimesheet_TotalHours] DEFAULT ((0.0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxUserTimesheet] ADD CONSTRAINT [PK_dxWeek] PRIMARY KEY CLUSTERED  ([PK_dxUserTimesheet]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxUserTimesheet_FK_dxUser] ON [dbo].[dxUserTimesheet] ([FK_dxUser]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxUserTimesheet] ADD CONSTRAINT [dxConstraint_FK_dxUser_dxUserTimesheet] FOREIGN KEY ([FK_dxUser]) REFERENCES [dbo].[dxUser] ([PK_dxUser])
GO
