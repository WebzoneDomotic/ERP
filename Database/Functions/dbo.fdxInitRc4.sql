SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create FUNCTION [dbo].[fdxInitRc4]
(
	@Pwd VARCHAR(256)
)
RETURNS @Box TABLE (i TINYINT, v TINYINT)
AS

BEGIN
	DECLARE	@Key TABLE (i TINYINT, v TINYINT)

	DECLARE	@Index SMALLINT,
		@PwdLen TINYINT

	SELECT	@Index = 0,
		@PwdLen = LEN(@Pwd)

	WHILE @Index <= 255
		BEGIN
			INSERT	@Key
				(
					i,
					v
				)
			VALUES	(
					@Index,
					 ASCII(SUBSTRING(@Pwd, @Index % @PwdLen + 1, 1))
				)

			INSERT	@Box
				(
					i,
					v
				)
			VALUES	(
					@Index,
					@Index
				)

			SELECT	@Index = @Index + 1
		END


	DECLARE	@t TINYINT,
		@b SMALLINT

	SELECT	@Index = 0,
		@b = 0

	WHILE @Index <= 255
		BEGIN
			SELECT		@b = (@b + b.v + k.v) % 256
			FROM		@Box AS b
			INNER JOIN	@Key AS k ON k.i = b.i
			WHERE		b.i = @Index

			SELECT	@t = v
			FROM	@Box
			WHERE	i = @Index

			UPDATE	b1
			SET	b1.v = (SELECT b2.v FROM @Box b2 WHERE b2.i = @b)
			FROM	@Box b1
			WHERE	b1.i = @Index

			UPDATE	@Box
			SET	v = @t
			WHERE	i = @b

			SELECT	@Index = @Index + 1
		END

	RETURN
END
GO
