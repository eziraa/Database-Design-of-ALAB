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


-- create function to calculate maximum of 3 

GO
CREATE FUNCTION Compensation.fnGetMax(@last2 FLOAT, @last FLOAT, @this FLOAT)
RETURNS FLOAT
AS
BEGIN 
	DECLARE @max FLOAT
	IF ( @last2 > @last AND @last2 > @this)
		SET @max = @last2
	ELSE IF ( @last > @last2 AND @last > @this)
		SET @max = @last
	ELSE 
		SET @max = @this
RETURN @max
END
GO



-- Create a function tof calulate total price for a single crop in a land

GO
CREATE FUNCTION Compensation.fnCropMax (@LandID INT, @cropName VARCHAR(23))
RETURNS FLOAT
AS
BEGIN
	DECLARE @total FLOAT, @maxHarvest FLOAT, @currentPriceMaxHarvest FLOAT
	DECLARE @last2 FLOAT, @last FLOAT, @this FLOAT
	SELECT @this= (SELECT [Hervest QPerH of This Year] FROM Property.tblLandGivesCrop WHERE [Crop Name] = @cropName AND [Land ID]= @landID)
	SELECT @last = (SELECT [Hervest QPerH of Last Year] FROM Property.tblLandGivesCrop WHERE [Crop Name] = @cropName AND [Land ID]= @landID)
	SELECT @last2 = (SELECT [Hervest QPerH Two Year Ago] FROM Property.tblLandGivesCrop WHERE [Crop Name] = @cropName AND [Land ID]= @landID)
	SET @maxHarvest = Compensation.fnGetMax(@this, @last, @last2)
	SELECT @currentPriceMaxHarvest = (SELECT [Current Price] FROM Property.tblCrop WHERE [Crop Name] = @cropName)
	SET @total = @maxHarvest * @currentPriceMaxHarvest

RETURN @total
END
GO

-- Create a function to calculating to compensation for crops in  a given land

GO
CREATE FUNCTION Compensation.fnCropCompenstation (@LandID INT)
RETURNS FLOAT
AS
BEGIN

	DECLARE @total FLOAT
	SELECT @total = (SELECT AVG(Compensation.fnCropMax(@LandID, [Crop Name])) FROM Property.tblLandGivesCrop)
RETURN @total * 15
END
GO


-- calculate total compensation for non productive plants

GO
CREATE FUNCTION .Compensation.fnTotalNonProductiveComp(@landID INT)
RETURNS FLOAT
AS
BEGIN
	DECLARE @total FLOAT
	SELECT @total = (SELECT SUM([Quantity] * [Current Price] + [Growth Expense] + [Preservation Expense])
	 FROM Property.tblLandGrowsNonProPlants LGNP, Property.tblNonProductivePlants NP WHERE LGNP.[Plant Name] = NP.[Plant Name] AND [Land ID] = @landID)
RETURN @total * 15
END
GO


--The estimators calcualte the total compensation for productive plants  

GO
CREATE FUNCTION Compensation.fnTotalProComp(@landID INT)
RETURNS FLOAT
AS
BEGIN
	DECLARE @total FLOAT
	SELECT @total = (SELECT SUM([High Level Quantity] *[High Level Current Price] +
	[Middle Level Quantity] *[Middel Level Current Price] +
	[Low Level Quantity] *[Low Level Current Price] + [Growth Expense] + [Preservation Expense])
	 FROM Property.tblLandGrowsProdPlants LGP, Property.tblProductivePlants PP
	  WHERE LGP.[Plant Name] = PP.[Plant Name] AND [Land ID] = @landID)
RETURN @total
END
GO


-- create a function to calculate total compensation for movable property

GO
CREATE FUNCTION Compensation.fnTotalMVExpComp(@landID INT)
RETURNS FLOAT
AS
BEGIN
	DECLARE @total FLOAT
	SELECT @total = (SELECT SUM([Uprooting Expense] + [Transportation Expense] +
	[Installation Expense] + [Recovery Expense]) FROM Property.tblMovableProperty WHERE [Land ID] = @landID)
RETURN @total
END
GO

