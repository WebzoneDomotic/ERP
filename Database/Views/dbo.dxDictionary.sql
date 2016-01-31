SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create view [dbo].[dxDictionary] as
SELECT [PK_dxDataSet] PrimaryKey
	  ,'1' ObjectType
	  ,'Table' ObjectTypeName
      ,[TableName] Name
      ,[FrenchCaption]
      ,[FrenchHint]
      ,[FrenchDescription]
      ,[EnglishCaption]
      ,[EnglishHint]
      ,[EnglishDescription]
      ,[SpanishCaption]
      ,[SpanishHint]
      ,[SpanishDescription]
      ,[NewItem]
      ,[Original]
      ,[LastModified]
FROM [dbo].[dxDataSet]
UNION ALL
SELECT [PK_dxDataSetField] PrimaryKey
	  ,'2' ObjectType
      ,'Column' ObjectTypeName
	  ,[ColumnName] Name
      ,[FrenchCaption]
      ,[FrenchHint]
      ,[FrenchDescription]
      ,[EnglishCaption]
      ,[EnglishHint]
      ,[EnglishDescription]
      ,[SpanishCaption]
      ,[SpanishHint]
      ,[SpanishDescription]
      ,[NewItem]
      ,[Original]
      ,[LastModified]
FROM [dbo].[dxDataSetField]
UNION ALL
SELECT [PK_dxAction] PrimaryKey
      ,'3' ObjectType
	  ,'Action' ObjectTypeName
      ,[ActionName] Name
      ,[FrenchCaption]
      ,[FrenchHint]
      ,[FrenchDescription]
      ,[EnglishCaption]
      ,[EnglishHint]
      ,[EnglishDescription]
      ,[SpanishCaption]
      ,[SpanishHint]
      ,[SpanishDescription]
      ,[NewItem]
      ,[Original]
      ,[LastModified]
  FROM [dbo].[dxAction]
UNION ALL
SELECT [PK_dxComponent] PrimaryKey
	  ,'4' ObjectType
	  ,'Component' ObjectTypeName
      ,[ComponentName] Name
      ,[FrenchCaption]
      ,[FrenchHint]
      ,[FrenchDescription]
      ,[EnglishCaption]
      ,[EnglishHint]
      ,[EnglishDescription]
      ,[SpanishCaption]
      ,[SpanishHint]
      ,[SpanishDescription]
      ,[NewItem]
      ,[Original]
      ,[LastModified]
  FROM [dbo].[dxComponent]
UNION ALL
SELECT [PK_dxForm] PrimaryKey
	  ,'5' ObjectType
	  ,'Form' ObjectTypeName
      ,[FormName] Name
      ,[FrenchCaption]
      ,[FrenchHint]
      ,[FrenchDescription]
      ,[EnglishCaption]
      ,[EnglishHint]
      ,[EnglishDescription]
      ,[SpanishCaption]
      ,[SpanishHint]
      ,[SpanishDescription]
      ,[NewItem]
      ,[Original]
      ,[LastModified]
  FROM [dbo].[dxForm]
UNION ALL
SELECT [PK_dxMessage] PrimaryKey
	  ,'6' ObjectType
	  ,'Message' ObjectTypeName
      ,[MessageName] Name
      ,[FrenchCaption]
      ,[FrenchHint]
      ,[FrenchDescription]
      ,[EnglishCaption]
      ,[EnglishHint]
      ,[EnglishDescription]
      ,[SpanishCaption]
      ,[SpanishHint]
      ,[SpanishDescription]
      ,[NewItem]
      ,[Original]
      ,[LastModified]
  FROM [dbo].[dxMessage]
UNION ALL
SELECT [PK_dxReportComponent] PrimaryKey
	  ,'7' ObjectType
	  ,'Report Component' ObjectTypeName
      ,[ComponentName] Name
      ,[FrenchCaption]
      ,[FrenchHint]
      ,[FrenchDescription]
      ,[EnglishCaption]
      ,[EnglishHint]
      ,[EnglishDescription]
      ,[SpanishCaption]
      ,[SpanishHint]
      ,[SpanishDescription]
      ,[NewItem]
      ,[Original]
      ,[LastModified]
  FROM [dbo].[dxReportComponent]
GO
