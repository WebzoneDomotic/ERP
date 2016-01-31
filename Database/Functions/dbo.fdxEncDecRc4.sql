SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- --------------------------------------------------------------------------------------------
create FUNCTION [dbo].[fdxEncDecRc4]
(
	@Pwd VARCHAR(256),
	@Text VARCHAR(max)
)
RETURNS	VARCHAR(max)
AS

BEGIN
	DECLARE	@Box TABLE (i TINYINT, v TINYINT)

	INSERT	@Box
		(
			i,
			v
		)
	SELECT	i,
		v
	FROM	dbo.fdxInitRc4(@Pwd)

	DECLARE	@Index SMALLINT,
		@i SMALLINT,
		@j SMALLINT,
		@t TINYINT,
		@k SMALLINT,
      		@CipherBy TINYINT,
      		@Cipher VARCHAR(max)

	SELECT	@Index = 1,
		@i = 0,
		@j = 0,
		@Cipher = ''

	WHILE @Index <= DATALENGTH(@Text)
		BEGIN
			SELECT	@i = (@i + 1) % 256

			SELECT	@j = (@j + b.v) % 256
			FROM	@Box b
			WHERE	b.i = @i

			SELECT	@t = v
			FROM	@Box
			WHERE	i = @i

			UPDATE	b
			SET	b.v = (SELECT w.v FROM @Box w WHERE w.i = @j)
			FROM	@Box b
			WHERE	b.i = @i

			UPDATE	@Box
			SET	v = @t
			WHERE	i = @j

			SELECT	@k = v
			FROM	@Box
			WHERE	i = @i

			SELECT	@k = (@k + v) % 256
			FROM	@Box
			WHERE	i = @j

			SELECT	@k = v
			FROM	@Box
			WHERE	i = @k

			SELECT	@CipherBy = ASCII(SUBSTRING(@Text, @Index, 1)) ^ @k,
				@Cipher = @Cipher + CHAR(@CipherBy)

			SELECT	@Index = @Index  +1
      		END

	RETURN	@Cipher
END
GO
