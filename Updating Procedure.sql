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