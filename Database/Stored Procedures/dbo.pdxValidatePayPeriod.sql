SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Francois Baillarge
-- Create date: 2012-11-01
-- Description:	Validate pay period. Raises error if date is part of a closed period
-- --------------------------------------------------------------------------------------------
CREATE Procedure [dbo].[pdxValidatePayPeriod]  @Date Datetime
as
Begin
   Declare @PK_dxPayPeriod int
   Declare @MSG varchar(1000)
   Declare @ERRNO int
   
   Set @PK_dxPayPeriod = (Select PK_dxPayPeriod From dxPayPeriod where @Date between StartDate and EndDate)

   if Coalesce( (Select Convert(int, PeriodIsClosed) From dxPayPeriod where PK_dxPayPeriod = @PK_dxPayPeriod),1) = 1
   begin
		-- dbMsgPayPeriodClosed = 1000;
        Set @ERRNO = 1000		
        Set @MSG = Convert(Varchar(20),@PK_dxPayPeriod)
        RAISERROR(@ERRNO, @MSG , 16, 1)
        RETURN
   end
End
GO
