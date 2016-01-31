SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-01-21
-- Description:	Number to word - English.
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxNumberToWordEN](@n bigint )
--Returns the number as words - English.
returns VARCHAR(250)
as
BEGIN
  DECLARE @i int, @temp char(1),  @s VARCHAR(20), @result VARCHAR(255)
  SELECT @s=convert(varchar(20), @n)
  SELECT @i=LEN(@s)
  SELECT @result=''
  WHILE (@i>0)
  BEGIN
  SELECT @temp=(SUBSTRING(@s,@i,1))
  IF ((LEN(@s)-@i) % 3)=1
  IF @temp='1'
  SELECT @result=CASE (SUBSTRING(@s,@i+1,1))
    WHEN '0' THEN 'ten'
    WHEN '1' THEN 'eleven'
    WHEN '2' THEN 'twelve'
    WHEN '3' THEN 'thirteen'
    WHEN '4' THEN 'fourteen'
    WHEN '5' THEN 'fifteen'
    WHEN '6' THEN 'sixteen'
    WHEN '7' THEN 'seventeen'
    WHEN '8' THEN 'eighteen'
    WHEN '9' THEN 'nineteen'
    END+' '+CASE
        WHEN ((LEN(@s)-@i)=4) THEN 'thousand '
        WHEN ((LEN(@s)-@i)=7) THEN 'million '
        WHEN ((LEN(@s)-@i)=10) THEN 'billion '
        WHEN ((LEN(@s)-@i)=13) THEN 'trillion '
        WHEN ((LEN(@s)-@i)=16) THEN 'quadrillion '
        WHEN ((LEN(@s)-@i)=19) THEN 'quintillion '
        WHEN ((LEN(@s)-@i)=22) THEN 'sextillion '
        WHEN ((LEN(@s)-@i)=25) THEN 'septillion '
        WHEN ((LEN(@s)-@i)=28) THEN 'octillion '
        WHEN ((LEN(@s)-@i)=31) THEN 'nonillion '
        WHEN ((LEN(@s)-@i)=34) THEN 'decillion '
        WHEN ((LEN(@s)-@i)=37) THEN 'undecillion '
        WHEN ((LEN(@s)-@i)=40) THEN 'duodecillion '
        WHEN ((LEN(@s)-@i)=43) THEN 'tredecillion '
        WHEN ((LEN(@s)-@i)=46) THEN 'quattuordecillion '
        WHEN ((LEN(@s)-@i)=49) THEN 'quindecillion '
        WHEN ((LEN(@s)-@i)=52) THEN 'sexdecillion '
        WHEN ((LEN(@s)-@i)=55) THEN 'septendecillion '
        WHEN ((LEN(@s)-@i)=58) THEN 'octodecillion '
        WHEN ((LEN(@s)-@i)=61) THEN 'novemdecillion '
        ELSE ''
        END+@result
  ELSE
  BEGIN
    SELECT @result=CASE (SUBSTRING(@s,@i+1,1))
      WHEN '0' THEN ''
      WHEN '1' THEN 'one'
      WHEN '2' THEN 'two'
      WHEN '3' THEN 'three'
      WHEN '4' THEN 'four'
      WHEN '5' THEN 'five'
      WHEN '6' THEN 'six'
      WHEN '7' THEN 'seven'
      WHEN '8' THEN 'eight'
      WHEN '9' THEN 'nine'
      END+' '+ CASE
        WHEN ((LEN(@s)-@i)=4) THEN 'thousand '
        WHEN ((LEN(@s)-@i)=7) THEN 'million '
        WHEN ((LEN(@s)-@i)=10) THEN 'billion '
        WHEN ((LEN(@s)-@i)=13) THEN 'trillion '
        WHEN ((LEN(@s)-@i)=16) THEN 'quadrillion '
        WHEN ((LEN(@s)-@i)=19) THEN 'quintillion '
        WHEN ((LEN(@s)-@i)=22) THEN 'sextillion '
        WHEN ((LEN(@s)-@i)=25) THEN 'septillion '
        WHEN ((LEN(@s)-@i)=28) THEN 'octillion '
        WHEN ((LEN(@s)-@i)=31) THEN 'nonillion '
        WHEN ((LEN(@s)-@i)=34) THEN 'decillion '
        WHEN ((LEN(@s)-@i)=37) THEN 'undecillion '
        WHEN ((LEN(@s)-@i)=40) THEN 'duodecillion '
        WHEN ((LEN(@s)-@i)=43) THEN 'tredecillion '
        WHEN ((LEN(@s)-@i)=46) THEN 'quattuordecillion '
        WHEN ((LEN(@s)-@i)=49) THEN 'quindecillion '
        WHEN ((LEN(@s)-@i)=52) THEN 'sexdecillion '
        WHEN ((LEN(@s)-@i)=55) THEN 'septendecillion '
        WHEN ((LEN(@s)-@i)=58) THEN 'octodecillion '
        WHEN ((LEN(@s)-@i)=61) THEN 'novemdecillion '
        ELSE ''
        END+@result
    SELECT @result=CASE @temp
      WHEN '0' THEN ''
      WHEN '1' THEN 'ten'
      WHEN '2' THEN 'twenty'
      WHEN '3' THEN 'thirty'
      WHEN '4' THEN 'fourty'
      WHEN '5' THEN 'fifty'
      WHEN '6' THEN 'sixty'
      WHEN '7' THEN 'seventy'
      WHEN '8' THEN 'eighty'
      WHEN '9' THEN 'ninety'
      END+' '+@result
  END
  IF (((LEN(@s)-@i) % 3)=2) OR (((LEN(@s)-@i) % 3)=0) AND (@i=1)
  BEGIN
  SELECT @result=CASE @temp
    WHEN '0' THEN ''
    WHEN '1' THEN 'one'
    WHEN '2' THEN 'two'
    WHEN '3' THEN 'three'
    WHEN '4' THEN 'four'
    WHEN '5' THEN 'five'
    WHEN '6' THEN 'six'
    WHEN '7' THEN 'seven'
    WHEN '8' THEN 'eight'
    WHEN '9' THEN 'nine'
    END +' '+CASE
      WHEN (@s='0') THEN 'zero'
      WHEN (@temp<>'0')AND( ((LEN(@s)-@i) % 3)=2) THEN 'hundred '
      ELSE ''
      END + CASE
      WHEN ((LEN(@s)-@i)=3) THEN 'thousand '
      WHEN ((LEN(@s)-@i)=6) THEN 'million '
      WHEN ((LEN(@s)-@i)=9) THEN 'billion '
      WHEN ((LEN(@s)-@i)=12) THEN 'trillion '
      WHEN ((LEN(@s)-@i)=15) THEN 'quadrillion '
      WHEN ((LEN(@s)-@i)=18) THEN 'quintillion '
      WHEN ((LEN(@s)-@i)=21) THEN 'sextillion '
      WHEN ((LEN(@s)-@i)=24) THEN 'septillion '
      WHEN ((LEN(@s)-@i)=27) THEN 'octillion '
      WHEN ((LEN(@s)-@i)=30) THEN 'nonillion '
      WHEN ((LEN(@s)-@i)=33) THEN 'decillion '
      WHEN ((LEN(@s)-@i)=36) THEN 'undecillion '
      WHEN ((LEN(@s)-@i)=39) THEN 'duodecillion '
      WHEN ((LEN(@s)-@i)=42) THEN 'tredecillion '
      WHEN ((LEN(@s)-@i)=45) THEN 'quattuordecillion '
      WHEN ((LEN(@s)-@i)=48) THEN 'quindecillion '
      WHEN ((LEN(@s)-@i)=51) THEN 'sexdecillion '
      WHEN ((LEN(@s)-@i)=54) THEN 'septendecillion '
      WHEN ((LEN(@s)-@i)=57) THEN 'octodecillion '
      WHEN ((LEN(@s)-@i)=60) THEN 'novemdecillion '
      ELSE ''
        END+ @result
  END
  SELECT @i=@i-1
  END
  return REPLACE(@result,'  ',' ')
END
GO
