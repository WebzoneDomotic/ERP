SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create function [dbo].[fdxIncluded] (@s varchar(255),@p varchar(255) )
--Returns how many times a string is included (occurs) into another one.
returns int
as
BEGIN
  DECLARE @i int,@c int
  SET @i=1
  SET @c=0
  WHILE charindex(@s, @p, @i)>0
  BEGIN
     SET @i=charindex(@s, @p, @i)+1
     SET @c=@c+1
  END
  RETURN  @c
END
GO
