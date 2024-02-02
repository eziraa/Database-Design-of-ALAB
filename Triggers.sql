
--Create trigger to update the total compensation when the crop quantity is updated
GO
CREATE TRIGGER Property.trigUpdateTotalCrop ON Property.tblLandGivesCrop
AFTER UPDATE
AS
IF ( UPDATE([Hervest QPerH of This Year]) OR UPDATE([Hervest QPerH of Last Year]) OR UPDATE([Hervest QPerH Two Year Ago]) )
  BEGIN
  DECLARE @temp1 INT ,@temp2 INT
  SELECT @temp1 = (SELECT Compensation.fnTotalComp ([Land ID]) FROM INSERTED)
  SELECT @temp2 = ( SELECT [Land Owner ID] from Property.tblLand WHERE [Land ID] = (SELECT [Land ID] FROM INSERTED))
  UPDATE Compensation.tblTotalCompensation SET [Amount] = @temp1 WHERE [Land Owner ID] = @temp2
  END
GO

-- create trigger to update the total comopensation when non productive plant quantity is updated
GO
CREATE TRIGGER Property.trigUpdateTotalByNonPro ON Property.tblLandGrowsNonProPlants 
AFTER UPDATE
AS
IF(UPDATE ([Quantity])) OR (UPDATE ([Growth Expense])) OR (UPDATE ([Preservation Expense])) 
  BEGIN
  DECLARE @temp1 INT ,@temp2 INT
  SELECT @temp1 = (SELECT Compensation.fnTotalComp ([Land ID]) FROM INSERTED)
  SELECT @temp2 = ( SELECT [Land Owner ID] from Property.tblLand WHERE [Land ID] = (SELECT [Land ID] FROM INSERTED))
  UPDATE Compensation.tblTotalCompensation SET [Amount] = @temp1 WHERE [Land Owner ID] = @temp2
END
GO


-- create trigger to update the total comopensation when  productive plant quantity is updated
GO
CREATE TRIGGER Property.trigUpdateTotalByPro ON Property.tblLandGrowsProdPlants 
AFTER UPDATE
AS
IF(UPDATE ([Growth Expense]) OR UPDATE ([Preservation Expense]) OR UPDATE ([High Level Quantity]) OR UPDATE( [Middle Level Quantity])
OR UPDATE ([Low Level Quantity]))
BEGIN
  DECLARE @temp1 INT ,@temp2 INT
  SELECT @temp1 = (SELECT Compensation.fnTotalComp ([Land ID]) FROM INSERTED)
  SELECT @temp2 = ( SELECT [Land Owner ID] from Property.tblLand WHERE [Land ID] = (SELECT [Land ID] FROM INSERTED))
  UPDATE Compensation.tblTotalCompensation SET [Amount] = @temp1 WHERE [Land Owner ID] = @temp2
END
GO

-- create trigger to update the total comopensation when movable property quantity is updated
GO
CREATE TRIGGER Property.trigUpdateMoveProp ON Property.tblMovableProperty 
AFTER UPDATE
AS
IF(UPDATE ([Uprooting Expense]) OR UPDATE ([Transportation Expense]) OR UPDATE ([Installation Expense]) OR UPDATE( [Recovery Expense]))
BEGIN
  DECLARE @temp1 INT ,@temp2 INT
  SELECT @temp1 = (SELECT Compensation.fnTotalComp ([Land ID]) FROM INSERTED)
  SELECT @temp2 = ( SELECT [Land Owner ID] from Property.tblLand WHERE [Land ID] = (SELECT [Land ID] FROM INSERTED))
  UPDATE Compensation.tblTotalCompensation SET [Amount] = @temp1 WHERE [Land Owner ID] = @temp2
END
GO

