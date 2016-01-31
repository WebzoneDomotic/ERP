CREATE TABLE [dbo].[dxGL]
(
[PK_dxGL] [int] NOT NULL IDENTITY(1, 1),
[FK_dxAccount] [int] NOT NULL,
[FK_dxPeriod] [int] NOT NULL,
[StartingPeriodAmount] [float] NOT NULL CONSTRAINT [DF_dxGL_StartingPeriodAmount] DEFAULT ((0.0)),
[PeriodAmount] [float] NOT NULL CONSTRAINT [DF_dxGL_PeriodAmount] DEFAULT ((0.0)),
[EndingPeriodAmount] [float] NOT NULL CONSTRAINT [DF_dxGL_EndingPeriodAmount] DEFAULT ((0.0)),
[StartingPeriodBudgetAmount] [float] NOT NULL CONSTRAINT [DF_dxGL_StartingPeriodBudgetAmount] DEFAULT ((0.0)),
[PeriodBudgetAmount] [float] NOT NULL CONSTRAINT [DF_dxGL_PeriodBudgetAmount] DEFAULT ((0.0)),
[EndingPeriodBudgetAmount] [float] NOT NULL CONSTRAINT [DF_dxGL_EndingPeriodBudgetAmount] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxGL.trGLEntryAfterUpdate] ON [dbo].[dxGL]
AFTER UPDATE
AS
BEGIN
  Declare  @Account int, @Period int
  Declare CR_GLTrIns Cursor LOCAL FAST_FORWARD for Select FK_dxAccount, FK_dxPeriod from inserted

  --------------------------------Update GL Entry Sum of PeriodBudgetAmount -------------------------
  SET NOCOUNT ON
  if Update( PeriodBudgetAmount )
  begin
    Open CR_GLTrIns
    Fetch Next FROM CR_GLTrIns INTO @Account , @Period
    -- For each line of the document we recalculate the amount
    While @@FETCH_STATUS = 0
    Begin
       Execute [dbo].[pdxGLEntryUpdate] @FK_dxAccount = @Account, @FK_dxPeriod = @Period
       Fetch Next FROM CR_GLTrIns INTO @Account , @Period
    end
    -- Close cursor and free ressource
    CLOSE CR_GLTrIns
    DEALLOCATE CR_GLTrIns
  end
  SET NOCOUNT OFF
END
GO
ALTER TABLE [dbo].[dxGL] ADD CONSTRAINT [PK_dxGL] PRIMARY KEY CLUSTERED  ([PK_dxGL]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxGL_FK_dxAccount] ON [dbo].[dxGL] ([FK_dxAccount]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IxDB_dxGL] ON [dbo].[dxGL] ([FK_dxAccount], [FK_dxPeriod]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IxFK_dxGL_FK_dxPeriod] ON [dbo].[dxGL] ([FK_dxPeriod]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dxGL] ADD CONSTRAINT [dxConstraint_FK_dxAccount_dxGL] FOREIGN KEY ([FK_dxAccount]) REFERENCES [dbo].[dxAccount] ([PK_dxAccount])
GO
ALTER TABLE [dbo].[dxGL] ADD CONSTRAINT [dxConstraint_FK_dxPeriod_dxGL] FOREIGN KEY ([FK_dxPeriod]) REFERENCES [dbo].[dxPeriod] ([PK_dxPeriod])
GO
