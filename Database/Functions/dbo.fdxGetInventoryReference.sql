SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
-- Author:		Bernard Cincou
-- Create date: 2012-12-05
-- Description:	Retourne une reference concernant la transaction sur des inventaires
-- --------------------------------------------------------------------------------------------
Create function [dbo].[fdxGetInventoryReference] ( @FK_dxProductTransaction int, @PrimaryKeyValue int, @KindOfDocument int )
--Returns Reference Value.
returns varchar(500)
as
BEGIN
  Declare @R varchar(500)

  Set @R = [dbo].[fcxGetInventoryReference] ( @FK_dxProductTransaction , @PrimaryKeyValue , @KindOfDocument  )

  If @R = ''
  begin
    set @R =   
    case @KindOfDocument
      WHEN 5  THEN 'AJP-' +Convert(varchar(50), @PrimaryKeyValue )
      WHEN 9  THEN 'AJI-' +Convert(varchar(50), @PrimaryKeyValue )
      WHEN 11 THEN 'REC-' +Convert(varchar(50), @PrimaryKeyValue )
      WHEN 12 THEN 'LIV-' +Convert(varchar(50), @PrimaryKeyValue )
      WHEN 13 THEN 'TRI-' +Convert(varchar(50), @PrimaryKeyValue )
      WHEN 14 THEN 'TRS-' +Convert(varchar(50), @PrimaryKeyValue )
      WHEN 15 THEN 'DEC-' +Convert(varchar(50), @PrimaryKeyValue )
      WHEN 16 THEN 'CON-' +Convert(varchar(50), @PrimaryKeyValue )
      WHEN 17 THEN 'PRF-' +Convert(varchar(50), @PrimaryKeyValue )
      WHEN 18 THEN 'MOD-' +Convert(varchar(50), @PrimaryKeyValue )
      WHEN 19 THEN 'BCC-' +Convert(varchar(50), @PrimaryKeyValue )
      WHEN 20 THEN 'RMA-' +Convert(varchar(50), @PrimaryKeyValue )
      WHEN 25 THEN 'Correction'
      WHEN 26 THEN 'Cost Rollup'
    else 
      'Non défini - ' +Convert(varchar(50), @PrimaryKeyValue )
    end
  end

  Return @R
END
GO
