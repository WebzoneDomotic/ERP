SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-01-21
-- Description:	Number to word - French.
-- --------------------------------------------------------------------------------------------
Create FUNCTION [dbo].[fdxNumberToWordFR](@n bigint )
--Returns the number as words - French.
RETURNS varchar(250)
AS
BEGIN
  DECLARE @lettres varchar(200)
  DECLARE @diviseur int
  DECLARE @centaine int
  DECLARE @dizaine int
  DECLARE @unite int
  DECLARE @reste int
  DECLARE @courant int
  DECLARE @dix bit
  DECLARE @et bit
  DECLARE @ajout varchar(200)
  SET @lettres = ''
  SET @diviseur = 1000000
  SET @dix = 0
  SET @reste = @n
  IF @n > 999999999
  RETURN 'Un milliard ou plus'
  WHILE @diviseur >= 1
  BEGIN
  SELECT @courant = @reste / @diviseur
  IF @courant <> 0
  BEGIN
  SELECT @centaine = @courant / 100
  SELECT @dizaine = (@courant - @centaine * 100) / 10
  SELECT @unite = @courant - (@centaine * 100) - (@dizaine * 10)
  SELECT @ajout = ''
  SELECT @ajout = @ajout +
  CASE @centaine
  WHEN 1 THEN 'cent '
  WHEN 2 THEN
  CASE WHEN @dizaine = 0 AND @unite = 0 THEN 'deux cents ' ELSE 'deux cent ' END
  WHEN 3 THEN
  CASE WHEN @dizaine = 0 AND @unite = 0 THEN 'trois cents ' ELSE 'trois cent ' END
  WHEN 4 THEN
  CASE WHEN @dizaine = 0 AND @unite = 0 THEN 'quatre cents ' ELSE 'quatre cent ' END
  WHEN 5 THEN
  CASE WHEN @dizaine = 0 AND @unite = 0 THEN 'cinq cents ' ELSE 'cinq cent ' END
  WHEN 6 THEN
  CASE WHEN @dizaine = 0 AND @unite = 0 THEN 'six cents ' ELSE 'six cent ' END
  WHEN 7 THEN
  CASE WHEN @dizaine = 0 AND @unite = 0 THEN 'sept cents ' ELSE 'sept cent ' END
  WHEN 8 THEN
  CASE WHEN @dizaine = 0 AND @unite = 0 THEN 'huit cents ' ELSE 'huit cent ' END
  WHEN 9 THEN
  CASE WHEN @dizaine = 0 AND @unite = 0 THEN 'neuf cents ' ELSE 'neuf cent ' END
  ELSE ''
  END
  SELECT @ajout = @ajout +
  CASE @dizaine
  WHEN 2 THEN 'vingt '
  WHEN 3 THEN 'trente '
  WHEN 4 THEN 'quarante '
  WHEN 5 THEN 'cinquante '
  WHEN 6 THEN 'soixante '
  WHEN 7 THEN 'soixante '
  WHEN 8 THEN 'quatre vingt '
  WHEN 9 THEN 'quatre vingt '
  ELSE ''
  END
  SELECT @dix = CASE @dizaine
  WHEN 1 THEN 1
  WHEN 7 THEN 1
  WHEN 9 THEN 1
  ELSE 0
  END
  SELECT @et = CASE @dizaine
  WHEN 0 THEN 0
  WHEN 1 THEN 0
  WHEN 2 THEN 1
  WHEN 3 THEN 1
  WHEN 4 THEN 1
  WHEN 5 THEN 1
  WHEN 6 THEN 1
  WHEN 7 THEN 1
  WHEN 8 THEN 0
  WHEN 9 THEN 0
  ELSE 0
  END
  SELECT @ajout = @ajout +
  CASE @unite
  WHEN 0 THEN
  CASE @dix WHEN 1 THEN 'dix ' ELSE '' END
  WHEN 1 THEN
  CASE @et WHEN 1 THEN 'et ' ELSE '' END +
  CASE @dix WHEN 1 THEN 'onze ' ELSE 'un ' END
  WHEN 2 THEN
  CASE @dix WHEN 1 THEN 'douze ' ELSE 'deux ' END
  WHEN 3 THEN
  CASE @dix WHEN 1 THEN 'treize ' ELSE 'trois ' END
  WHEN 4 THEN
  CASE @dix WHEN 1 THEN 'quatorze ' ELSE 'quatre ' END
  WHEN 5 THEN
  CASE @dix WHEN 1 THEN 'quinze ' ELSE 'cinq ' END
  WHEN 6 THEN
  CASE @dix WHEN 1 THEN 'seize ' ELSE 'six ' END
  WHEN 7 THEN
  CASE @dix WHEN 1 THEN 'dix sept ' ELSE 'sept ' END
  WHEN 8 THEN
  CASE @dix WHEN 1 THEN 'dix huit ' ELSE 'huit ' END
  WHEN 9 THEN
  CASE @dix WHEN 1 THEN 'dix neuf ' ELSE 'neuf ' END
  ELSE ''
  END
  SELECT @lettres = @lettres +
  CASE @diviseur
  WHEN 1000000 THEN
  CASE
  WHEN @courant = 1 THEN 'un million '
  WHEN @courant > 1 THEN @ajout + 'millions '
  END
  WHEN 1000 THEN
  CASE WHEN @courant > 1 THEN @ajout ELSE '' END + 'mille '
  ELSE @ajout
  END
  SELECT @reste = @reste - @courant * @diviseur
  END
  SELECT @diviseur = @diviseur / 1000
  END
  IF @lettres = '' SELECT @lettres = 'zéro'
  RETURN RTRIM(@lettres)
END
GO
