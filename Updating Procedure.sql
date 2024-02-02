-- to update land gives crop table
GO
CREATE PROCEDURE Compensation.spUpdate2LandGivesCrop(@cropName VARCHAR(23), @landID INT, @UpdateValue INT, @UpdateYear VARCHAR(30))
AS
BEGIN
	IF(@UpdateYear = 'this')
		UPDATE Property.tblLandGivesCrop SET [Hervest QPerH of This Year] = @UpdateValue WHERE [Land ID] = @landID AND [Crop Name] = @cropName
	ELSE IF(@UpdateYear = 'last')
		UPDATE Property.tblLandGivesCrop SET [Hervest QPerH of Last Year] = @UpdateValue WHERE [Land ID] = @landID AND [Crop Name] = @cropName
	ELSE 
		UPDATE Property.tblLandGivesCrop SET [Hervest QPerH Two Year Ago] = @UpdateValue WHERE [Land ID] = @landID AND [Crop Name] = @cropName
END
GO


-- to update non productive plants table

GO
CREATE PROCEDURE Compensation.spUpdate2LandGrowsNonProPlant(@Name VARCHAR(23), @landID INT, @UpdateValue INT, @UpdateType VARCHAR(23))
AS
BEGIN
	IF(@UpdateType = 'quantity')
		UPDATE Property.tblLandGrowsNonProPlants SET [Quantity] = @UpdateValue WHERE [Land ID] = @landID AND [Plant Name] = @Name
	ELSE IF(@UpdateType = 'growth')
		UPDATE Property.tblLandGrowsNonProPlants SET [Growth Expense] = @UpdateValue WHERE [Land ID] = @landID AND [Plant Name] = @Name
	ELSE 
		UPDATE Property.tblLandGrowsNonProPlants SET [Preservation Expense] = @UpdateValue WHERE [Land ID] = @landID AND [Plant Name] = @Name
END
GO

-- TO UPDATE LANG GROWS PRODUCTIVE PLANT TABLE

GO
CREATE PROCEDURE Compensation.spUpdate2LandGrowsProdPlant(@Name VARCHAR(23), @landID INT, @UpdateValue INT, @UpdateType VARCHAR(23))
AS
BEGIN
	IF(@UpdateType = ' low')
		UPDATE Property.tblLandGrowsProdPlants SET [Low Level Quantity] = @UpdateValue WHERE [Land ID] = @landID AND [Plant Name] = @Name
	ELSE IF(@UpdateType = 'mid')
		UPDATE Property.tblLandGrowsProdPlants SET  [Middle Level Quantity] = @UpdateValue WHERE [Land ID] = @landID AND [Plant Name] = @Name
	ELSE IF (@UpdateType = 'high')
		UPDATE Property.tblLandGrowsProdPlants SET [High Level Quantity] = @UpdateValue WHERE [Land ID] = @landID AND [Plant Name] = @Name
	ELSE IF(@UpdateType = 'growth')
		UPDATE Property.tblLandGrowsProdPlants SET [Growth Expense] = @UpdateValue WHERE [Land ID] = @landID AND [Plant Name] = @Name
	ELSE 
		UPDATE Property.tblLandGrowsProdPlants SET [Preservation Expense] = @UpdateValue WHERE [Land ID] = @landID AND [Plant Name] = @Name
END
GO

-- updates movable property table
GO
CREATE PROCEDURE Compensation.spUpdate2MovProp(@Name VARCHAR(23), @landID INT, @UpdateValue INT, @UpdateType VARCHAR(23))
AS
BEGIN
	IF(@UpdateType = ' uproot')
		UPDATE Property.tblMovableProperty SET [Uprooting Expense] = @UpdateValue WHERE [Land ID] = @landID AND [Property Name] = @Name
	ELSE IF(@UpdateType = 'transport')
		UPDATE Property.tblMovableProperty SET  [Transportation Expense] = @UpdateValue WHERE [Land ID] = @landID AND [Property Name] = @Name
	ELSE IF (@UpdateType = 'install')
		UPDATE Property.tblMovableProperty SET [Installation Expense] = @UpdateValue WHERE [Land ID] = @landID AND [Property Name] = @Name
	ELSE 
		UPDATE Property.tblMovableProperty SET [Recovery Expense] = @UpdateValue WHERE [Land ID] = @landID AND [Property Name] = @Name
END
GO
