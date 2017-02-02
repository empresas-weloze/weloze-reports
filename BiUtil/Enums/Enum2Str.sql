
CREATE FUNCTION [BiUtil].[Enum2Str](@name AS varchar(40), @value AS int)
RETURNS varchar(255)
AS
BEGIN

	/* 
		All development credits to
		http://abraaxapta.blogspot.com.br/2012/11/accessing-enum-labels-from-outside-ax.html 
	*/

 DECLARE @bin AS varbinary(MAX);
 SET @bin = (SELECT TOP 1 Properties
    FROM DAX_Weloze_PRD_model.dbo.ModelElement me
    JOIN DAX_Weloze_PRD_model.dbo.ModelElementData med
     ON med.ElementHandle = me.ElementHandle
    WHERE me.Name = @name
     AND me.ElementType = 40
    ORDER BY med.LayerId DESC);
 DECLARE @pos AS int;
 DECLARE @flags AS int;
 DECLARE @count AS int;
 DECLARE @idx AS int;
 DECLARE @off AS int;
 DECLARE @ret AS varchar(255);
 SET @pos = 3;
 SET @off = CAST(SUBSTRING(@bin, @pos, 1) AS int) - 1;
 SET @pos = @pos + 1;
 WHILE @off > 0 --skip BaseEnum Label/Help/CountryRegionCode
	BEGIN
		WHILE SUBSTRING(@bin, @pos, 2) <> 0x0000
			SET @pos = @pos + 2;
		SET @pos = @pos + 2;
		SET @off = @off - 1;
	END
 SET @flags = CAST(SUBSTRING(@bin, @pos, 3) AS int);
 SET @pos = @pos + 3;
 IF @flags & 0x008000 = 0x008000 --skip BaseEnum ConfigurationKey
	BEGIN
		WHILE SUBSTRING(@bin, @pos, 2) <> 0x0000
			SET @pos = @pos + 2;
		SET @pos = @pos + 2;
	END
 IF @flags & 0x000002 = 0x000002 --skip BaseEnum ConfigurationKey
	SET @pos = @pos + 1;
 SET @pos = @pos + 1; --skip DisplayLength
 SET @count = CAST(SUBSTRING(@bin, @pos, 1) AS int);
 IF @count > 0
	BEGIN
		SET @pos = @pos + 1;
		IF @flags & 0x000200 = 0x000200 --UseEnumValue property
			SET @idx = @value;
		ELSE
			BEGIN
				SET @idx = 0;
				SET @off = 2 + CAST(CAST(REVERSE(SUBSTRING(@bin, @pos, 2)) AS binary(2)) AS int) * 2;
				SET @off = @off + 2 + CAST(CAST(REVERSE(SUBSTRING(@bin, @pos + @off, 2)) AS binary(2)) AS int) * 2;
				WHILE CAST(SUBSTRING(@bin, @pos + @off + @idx, 1) AS int) <> @value AND @idx < @count
					SET @idx = @idx + 1;
				IF CAST(SUBSTRING(@bin, @pos + @off + @idx, 1) AS int) <> @value
					SET @idx = -1;
			END
		IF @idx >= 0
			BEGIN
				SET @pos = @pos + 2;
				WHILE 1 = 1
					BEGIN
						SET @off = 0;
						SET @ret = '';
						WHILE SUBSTRING(@bin, @pos + @off, 2) <> 0x0000
							BEGIN
								SET @ret = @ret + CHAR(CAST(REVERSE(SUBSTRING(@bin, @pos + @off, 2)) AS binary(2)));
								SET @off = @off + 2;
							END
						SET @pos = @pos + @off + 2;
						IF @idx <= 0
							BREAK;
						SET @idx = @idx - 1;
					END
			END
		ELSE
			SET @ret = '<NOT FOUND';
	END
 ELSE
	SET @ret = '<ERROR>';
 IF SUBSTRING(@ret, 1, 1) = '@' --label file
	BEGIN
		DECLARE @module AS varchar(3);
		DECLARE @label AS int;
		SET @module = SUBSTRING(@ret, 2, 3);
		SET @label = CAST(SUBSTRING(@ret, 5, DATALENGTH(@ret) - 4) AS int);
		SET @ret = (SELECT TOP 1 Text FROM DAX_Weloze_PRD_model.dbo.ModelElementLabel
					WHERE LabelId = @label
						AND Module = @module
						AND Language = 'pt_br'
					ORDER BY LayerId DESC);
	END
 RETURN @ret;
END
