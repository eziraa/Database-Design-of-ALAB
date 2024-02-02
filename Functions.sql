-- CREATE A FUNCTION WHICH SELECT THE   AVELIABLE  LANDS WHICH ARE APPROPRIATE TO THE LAND REQUEST

GO
CREATE FUNCTION Request.fnSelectsLand(@SubKebele VARCHAR(23))
RETURNS TABLE 
AS
RETURN SELECT * FROM Property.tblLand WHERE [Land Type] = 'Plain' AND [Land Use] IN ('Farming', 'Grazing') AND 
[Sub Kebele] = @SubKebele
GO

-- CREATE A FUNCTION WHICH SELECT THE BEST LAND OPTION WHICH WILL NOT DIPLACE MORE POEPLE

GO
 CREATE FUNCTION Request.fnSelectsAppropriateLand(@area FLOAT, @SubKebele VARCHAR(23))
 RETURNS @Temp TABLE([Land ID] INT,
	[Land Status] VARCHAR(23),
	[Land Type] VARCHAR(23),
	[Land Area] FLOAT,
	[Sub Kebele]VARCHAR(23),
	[Land Owner ID] INT,
	[Land Owner Name] VARCHAR(23),
	[Gender] CHAR,
	[Phone Number] INT )
AS
BEGIN	
	DECLARE @maxLand FLOAT, @SUM FLOAT
	SET @maxLand=(SELECT MAX([Land Area]) from fnSelectsLand(@SubKebele)) 
	INSERT INTO @Temp SELECT [Land ID], [Land Type] , [Land Use], [Land Area], LO.[Sub Kebele], LO.[Land Owner ID], [First Name]+ ' '+
							 [Last Name],[Gender], [Phone Number] FROM Request.fnSelectsLand(@SubKebele) fnSL, LandOwner.tblLandOwner LO
	WHERE [Land Area] = @maxLand AND fnSL.[Land Owner ID] = LO.[Land Owner ID] 

	SET @SUM = @maxLand 

	WHILE ( @SUM < @area)
		BEGIN
			SET @maxLand = (SELECT MAX([Land Area]) from fnSelectsLand(@SubKebele) WHERE [Land Area] < ( @maxLand)) 
			SET @SUM = @maxLand + @SUM
			INSERT INTO @Temp SELECT [Land ID], [Land Type] , [Land Use], [Land Area], LO.[Sub Kebele],LO.[Land Owner ID], [First Name]+ ' ' + 
							 [Last Name],[Gender], [Phone Number] FROM Request.fnSelectsLand(@SubKebele) fnSL, landOwner.tblLandOwner LO
					WHERE [Land Area] = @maxLand AND fnSL.[Land Owner ID] = LO.[Land Owner ID] 
		END
 RETURN 
 END
GO
