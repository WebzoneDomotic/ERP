SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2011-01-11
-- Description:	Arrondi un nombre selon la méthode des finances 
-- --------------------------------------------------------------------------------------------
Create Function [dbo].[fdxBankersRound](@Val Float, @Digits INT)
RETURNS Float
AS
BEGIN
    RETURN CASE WHEN ABS(@Val - ROUND(@Val, @Digits, 1)) * POWER(10,@Digits+1) = 5
           THEN ROUND(@Val, @Digits, CASE WHEN CONVERT(INT, ROUND(ABS(@Val) * POWER(10,@Digits), 0, 1)) % 2 = 1 THEN 0 ELSE 1 END)
           ELSE ROUND(@Val, @Digits)
           END
END
GO
