SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		François Baillargé
-- Create date: 2010-05-12
-- Description:	Import des données du dictionnaire à partir de dxMessageCaption
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxImportDictionaryFromMessageCaption] 
AS
BEGIN
	Declare @pkObjectDescription int
	Declare @id varchar(255), @objectType varchar(50)
	Declare	@frenchCaption varchar(255), @englishCaption varchar(255), @spanishCaption varchar(255)
	Declare @frenchHint varchar(2000), @englishHint varchar(2000), @spanishHint varchar(2000)
	Declare @doNotUpdate bit, @newItem bit
	Declare @pk int
	Declare @count int

	Declare cMessageCaption CURSOR FAST_FORWARD for
		SELECT [ID],[ObjectType],[EnglishCaption],[EnglishHint], 
			[FrenchCaption],[FrenchHint],[SpanishCaption],[SpanishHint],
			[DoNotUpdate],[NewItem]
		FROM [dbo].[dxMessageCaption]
		ORDER BY [ObjectType], [ID]

	
	-- SET NOCOUNT ON added to prevent ext0ra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 set @count = 0;

 BEGIN TRANSACTION
 OPEN cMessageCaption
 FETCH NEXT FROM cMessageCaption INTO 
	@id, @objectType, @englishCaption, @englishHint, @frenchCaption, @frenchHint, @spanishCaption, 
	@spanishHint, @doNotUpdate, @newItem
 WHILE @@FETCH_STATUS = 0
 BEGIN
	if @objectType = 'TMSTable'
	begin
		set @pkObjectDescription = (select Tab.PK_dxDataSet from [dbo].[dxDataSet] Tab where 'T' + Upper(Tab.TableName) = @id and Tab.Original = 1)
		if @pkObjectDescription is not null
		begin
			update [dbo].[dxDataSet] set FrenchCaption = @frenchCaption, FrenchHint = @frenchHint,
				EnglishCaption = @englishCaption, EnglishHint = @englishHint, SpanishCaption = @spanishCaption,
				SpanishHint = @spanishHint, Original = 1, NewItem = 1
			where PK_dxDataSet = @pkObjectDescription
		end
	end
	
	if @objectType = 'TField'
	begin
		-- Tous les champs portant le même nom vont avoir les mêmes descriptions... on ne sait pas à quelle table le champ est rattaché
		update [dbo].[dxDataSetField] set FrenchCaption = @frenchCaption, FrenchHint = @frenchHint,
			EnglishCaption = @englishCaption, EnglishHint = @englishHint, SpanishCaption = @spanishCaption,
			SpanishHint = @spanishHint, Original = 1, NewItem = 1
		where PK_dxDataSetField in 
			(select Col.PK_dxDataSetField from [dbo].[dxDataSetField] Col, 
				[dbo].[dxDataSet] Tab where 
				Tab.PK_dxDataSet = Col.FK_dxDataSet and Col.Original = 1 and
				( ('FIELD.' + Upper(Col.ColumnName) = @id) Or ('FIELD.' + Upper(Col.ColumnName) + '.T' + Upper(Tab.TableName) = @id) ))
	end
	
	if @objectType = 'TString'
	begin
		-- S'il s'agit d'une action
		if @id LIKE 'AL%' or @id LIKE 'ACTION.AL%'
		begin
			set @pk = (select PK_dxAction from [dbo].[dxAction] where ActionName = @id and Original = 1)
			if @pk is null
			begin
				insert into [dbo].[dxAction](
					[ActionName]
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
					,[Original])
				  select 
				  @id
				  ,@frenchCaption
				  ,@frenchHint
				  ,@id
				  ,@englishCaption
				  ,@englishHint
				  ,@id
				  ,@spanishCaption
				  ,@spanishHint
				  ,@id
				  ,1
				  ,1;
				set @pk = SCOPE_IDENTITY();
				set @count = @count + 1;
			end
			else
				update [dbo].[dxAction] set FrenchCaption = @frenchCaption, FrenchHint = @frenchHint,
					EnglishCaption = @englishCaption, EnglishHint = @englishHint, SpanishCaption = @spanishCaption,
					SpanishHint = @spanishHint, Original = 1, NewItem = 1
				where PK_dxAction = @pk

		end
		else
			-- Les Toolbuttons, les onglets... se retrouvent dans les composants
			if @id LIKE 'TB%' or @id LIKE 'TAB%' or @id LIKE 'BUTTON.%' or @id LIKE 'GROUPBOX.%' or @id LIKE 'LABEL.%'
			begin
				set @pk = (select PK_dxComponent from [dbo].[dxComponent] where ComponentName = @id and original = 1)
				if @pk is null
				begin
					insert into [dbo].[dxComponent](
					[ComponentName]
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
					,[Original])
					select 
					@id
					,@frenchCaption
					,@frenchHint
					,@id
					,@englishCaption
					,@englishHint
					,@id
					,@spanishCaption
					,@spanishHint
					,@id
					,1
					,1;
					set @pk = SCOPE_IDENTITY();
					set @count = @count + 1;
				end
				else
					update [dbo].[dxComponent] set FrenchCaption = @frenchCaption, FrenchHint = @frenchHint,
						EnglishCaption = @englishCaption, EnglishHint = @englishHint, SpanishCaption = @spanishCaption,
						SpanishHint = @spanishHint, Original = 1, NewItem = 1
					where PK_dxComponent = @pk
			end
			else
			begin
				-- Rendu ici on va considérer qu'il s'agit d'un message
				set @pk = (select PK_dxMessage from [dbo].[dxMessage] where MessageName = @id and original = 1)
				if @pk is null
				begin
					insert into [dbo].[dxMessage](
					[MessageName]
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
					,[Original])
					select 
					@id
					,@frenchCaption
					,@frenchHint
					,@id
					,@englishCaption
					,@englishHint
					,@id
					,@spanishCaption
					,@spanishHint
					,@id
					,1
					,1;
					set @pk = SCOPE_IDENTITY();
					set @count = @count + 1;
				end
				else
					update [dbo].[dxMessage] set FrenchCaption = @frenchCaption, FrenchHint = @frenchHint,
						EnglishCaption = @englishCaption, EnglishHint = @englishHint, SpanishCaption = @spanishCaption,
						SpanishHint = @spanishHint, Original = 1, NewItem = 1
					where PK_dxMessage = @pk
			end
	end

 FETCH NEXT FROM cMessageCaption INTO 
	@id, @objectType, @englishCaption, @englishHint, @frenchCaption, @frenchHint, @spanishCaption, 
	@spanishHint, @doNotUpdate, @newItem
 END

 CLOSE cMessageCaption
 DEALLOCATE cMessageCaption
 COMMIT

 RETURN @count
END
GO
