SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[pdxUpdateDictionary]
	-- Add the parameters for the function here
	@objecttype int, @primarykey int,
	@frenchCaption nvarchar(255), @frenchHint ntext, @frenchDescription ntext,
	@englishCaption nvarchar(255), @englishHint ntext, @englishDescription ntext,
	@spanishCaption nvarchar(255), @spanishHint ntext, @spanishDescription ntext
AS
BEGIN
	declare @sql varchar(1000);
	declare @tablename varchar(30);
	declare @keyname varchar(30);

	if @objecttype = 1
	begin
		Update dxDataSet SET
			FrenchCaption = @FrenchCaption, FrenchHint = @FrenchHint, FrenchDescription = @FrenchDescription, 
			EnglishCaption = @EnglishCaption, EnglishHint = @EnglishHint, EnglishDescription = @EnglishDescription, 
			SpanishCaption = @SpanishCaption, SpanishHint = @SpanishHint, SpanishDescription = @SpanishDescription, NewItem = 0, Original = 0
		WHERE PK_dxDataSet = @primarykey;
	end

	if @objecttype = 2
	begin
		Update dxDataSetField SET
			FrenchCaption = @FrenchCaption, FrenchHint = @FrenchHint, FrenchDescription = @FrenchDescription, 
			EnglishCaption = @EnglishCaption, EnglishHint = @EnglishHint, EnglishDescription = @EnglishDescription, 
			SpanishCaption = @SpanishCaption, SpanishHint = @SpanishHint, SpanishDescription = @SpanishDescription, NewItem = 0, Original = 0
		WHERE PK_dxDataSetField = @primarykey;
	end

	if @objecttype = 3
	begin
		Update dxAction SET
			FrenchCaption = @FrenchCaption, FrenchHint = @FrenchHint, FrenchDescription = @FrenchDescription, 
			EnglishCaption = @EnglishCaption, EnglishHint = @EnglishHint, EnglishDescription = @EnglishDescription, 
			SpanishCaption = @SpanishCaption, SpanishHint = @SpanishHint, SpanishDescription = @SpanishDescription, NewItem = 0, Original = 0
		WHERE PK_dxAction = @primarykey;
	end
	
	if @objecttype = 4
	begin
		Update dxComponent SET
			FrenchCaption = @FrenchCaption, FrenchHint = @FrenchHint, FrenchDescription = @FrenchDescription, 
			EnglishCaption = @EnglishCaption, EnglishHint = @EnglishHint, EnglishDescription = @EnglishDescription, 
			SpanishCaption = @SpanishCaption, SpanishHint = @SpanishHint, SpanishDescription = @SpanishDescription, NewItem = 0, Original = 0
		WHERE PK_dxComponent = @primarykey;
	end

	if @objecttype = 5
	begin
		Update dxForm SET
			FrenchCaption = @FrenchCaption, FrenchHint = @FrenchHint, FrenchDescription = @FrenchDescription, 
			EnglishCaption = @EnglishCaption, EnglishHint = @EnglishHint, EnglishDescription = @EnglishDescription, 
			SpanishCaption = @SpanishCaption, SpanishHint = @SpanishHint, SpanishDescription = @SpanishDescription, NewItem = 0, Original = 0
		WHERE PK_dxForm = @primarykey;
	end

	if @objecttype = 6
	begin
		Update dxMessage SET
			FrenchCaption = @FrenchCaption, FrenchHint = @FrenchHint, FrenchDescription = @FrenchDescription,
			EnglishCaption = @EnglishCaption, EnglishHint = @EnglishHint, EnglishDescription = @EnglishDescription,
			SpanishCaption = @SpanishCaption, SpanishHint = @SpanishHint, SpanishDescription = @SpanishDescription, NewItem = 0, Original = 0
		WHERE PK_dxMessage = @primarykey;
	end

	if @objecttype = 7
	begin
		Update dxReportComponent SET
			FrenchCaption = @FrenchCaption, FrenchHint = @FrenchHint, FrenchDescription = @FrenchDescription,
			EnglishCaption = @EnglishCaption, EnglishHint = @EnglishHint, EnglishDescription = @EnglishDescription,
			SpanishCaption = @SpanishCaption, SpanishHint = @SpanishHint, SpanishDescription = @SpanishDescription, NewItem = 0, Original = 0
		WHERE PK_dxReportComponent = @primarykey;
	end
END
GO
