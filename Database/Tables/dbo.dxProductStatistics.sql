CREATE TABLE [dbo].[dxProductStatistics]
(
[PK_dxProductStatistics] [int] NOT NULL IDENTITY(1, 1),
[LastPurchaseCost] [float] NOT NULL CONSTRAINT [DF_dxProductStatistics_LastPurchaseCost] DEFAULT ((0.0)),
[LastStandardCost] [float] NOT NULL CONSTRAINT [DF_dxProductStatistics_LastStandardCost] DEFAULT ((0.0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProductStatistics.trAuditDelete] ON [dbo].[dxProductStatistics]
FOR DELETE
AS
 SET NOCOUNT ON
 Declare @audittype char(1)
 select @audittype = 'D'

 Declare @tablename  varchar (50)
 set @tablename = 'dxProductStatistics'

 Declare @pkdataaudit int
 Declare @auditdate datetime
 Declare @username varchar(128)
 Declare @fk_dxuser varchar(128);
 select @username = system_user ,
	@auditdate = getdate()

 select @fk_dxuser = dbo.fdxGetContextInfo('User')

 Declare pk_cursordxProductStatistics CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProductStatistics, LastPurchaseCost, LastStandardCost from deleted
 Declare @PK_dxProductStatistics int, @LastPurchaseCost Float, @LastStandardCost Float

 OPEN pk_cursordxProductStatistics
 FETCH NEXT FROM pk_cursordxProductStatistics INTO @PK_dxProductStatistics, @LastPurchaseCost, @LastStandardCost
 WHILE @@FETCH_STATUS = 0
 BEGIN
    insert into dxDataAudit( AuditType, PrimaryKeyValue, TableName, AuditDate, UserName, FK_dxUser ) 
        select @audittype, @PK_dxProductStatistics, @tablename, @auditdate, @username, @fk_dxuser
    select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'LastPurchaseCost', @LastPurchaseCost
/*--------------------------------------------------------------------------------------------------------------*/
    insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'LastStandardCost', @LastStandardCost
FETCH NEXT FROM pk_cursordxProductStatistics INTO @PK_dxProductStatistics, @LastPurchaseCost, @LastStandardCost
 END

 CLOSE pk_cursordxProductStatistics 
 DEALLOCATE pk_cursordxProductStatistics
 SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[dxProductStatistics.trAuditInsUpd] ON [dbo].[dxProductStatistics] 
FOR UPDATE, INSERT 
AS

 Declare @tablename  varchar (50);
 Declare @keyvalue int ;
 Declare @audittype char(1) ;
 Declare @auditdate datetime ;
 Declare @username varchar(128) ;
 Declare @pkdataaudit int;
 Declare @fk_dxuser varchar(128);

 Declare pk_cursordxProductStatistics CURSOR LOCAL FAST_FORWARD for SELECT PK_dxProductStatistics from inserted;
 set @tablename = 'dxProductStatistics' ;

 if exists (select 1 from inserted)
	if exists (select 1 from deleted)
			select @audittype = 'U'
		else
			select @audittype = 'I'

 -- date and user
 select @username = system_user ,
	@auditdate = getdate(),
        @fk_dxuser = dbo.fdxGetContextInfo('User')

 OPEN pk_cursordxProductStatistics
 FETCH NEXT FROM pk_cursordxProductStatistics INTO @keyvalue
 WHILE @@FETCH_STATUS = 0
 BEGIN     
     insert into dxDataAudit( AuditType, AuditDate, PrimaryKeyValue, TableName, UserName, FK_dxUser ) 
      select @audittype, @auditdate, @keyvalue, @tablename, @username, @fk_dxuser
     select @pkdataaudit = SCOPE_IDENTITY()
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LastPurchaseCost )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'LastPurchaseCost', LastPurchaseCost from dxProductStatistics where PK_dxProductStatistics = @keyvalue
     end ;
/*--------------------------------------------------------------------------------------------------------------*/
     if Update( LastStandardCost )
     begin
        insert into dxDataAuditDetail( FK_dxDataAudit, FieldName, ValueAsFloat ) 
        select @pkdataaudit, 'LastStandardCost', LastStandardCost from dxProductStatistics where PK_dxProductStatistics = @keyvalue
     end ;
FETCH NEXT FROM pk_cursordxProductStatistics INTO @keyvalue
 END

 CLOSE pk_cursordxProductStatistics 
 DEALLOCATE pk_cursordxProductStatistics
GO
ALTER TABLE [dbo].[dxProductStatistics] ADD CONSTRAINT [PK_dxProductStatistics] PRIMARY KEY CLUSTERED  ([PK_dxProductStatistics]) ON [PRIMARY]
GO
