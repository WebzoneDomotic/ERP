SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-02-03
-- Description:	Valider la période comptable
-- --------------------------------------------------------------------------------------------
Create Procedure [dbo].[pdxValidateAccountingPeriod]  @Date Datetime
as
Begin
   Declare @PK_dxPeriod int
   Declare @MSG varchar(1000)
   Set @PK_dxPeriod = (Select PK_dxPeriod From dxPeriod where @Date between StartDate and EndDate)

   if Coalesce( (Select Convert(int,AccountingIsClosed) From dxPeriod where PK_dxPeriod = @PK_dxPeriod),1) = 1
   begin
        Set @MSG = 'La période comptable est fermée / The accounting Period is Closed. '+ Convert(Varchar(10),@PK_dxPeriod)
        --ROLLBACK TRANSACTION
        RAISERROR(@MSG , 16, 1)
        RETURN
   end
End
GO
