
--CREATING A STORE PROCEDURE THAT DISPLAY ALL INFORMATION OF THE PROJECT AND THE INFORMARION OF THE THE REQUEST 
GO
CREATE  PROCEDURE Request.spProjectInfo(@ProjectName VARCHAR(23))
AS 
BEGIN
    SELECT [Project Type],[Project Name],[Urgency],[Land Recoverability],[Request Date],[Requested Area],
	[Project Duration],[Region],[Zone],[Wereda],[Kebele],AD.[Sub Kebele] FROM Request.tblProject PR, 
	Request.tblProReqToLand PRL,LandOwner.tblAddress AD WHERE PR.[Project ID] = PRL.[Project ID] AND 
	PRL.[Sub Kebele] = AD.[Sub Kebele] AND [Project Name] = @ProjectName
END
GO



-- CREATING A STORED PROCEDURE TO SEE LAND INFORMATION

GO 
CREATE PROCEDURE Property.spLandInfo(@SubKebele VARCHAR(23))
AS
BEGIN 
	SELECT [Region],[Zone],[Wereda],[Kebele],AD.[Sub Kebele] ,[First Name] + ' ' +  [Last Name] AS [Land  Owner Name],LO.[Land Owner ID], [Land ID]
	FROM LandOwner.tblLandOwner LO, LandOwner.tblAddress AD ,Property.tblLand L
	WHERE LO.[Sub Kebele] = AD.[Sub Kebele] AND L.[Land Owner ID] = LO.[Land Owner ID] AND AD.[Sub Kebele] = @SubKebele
END 
GO



--THE PROJECT MANAGER MAKE Land request

GO
CREATE PROCEDURE Request.spMakeRequest (
    @projectType VARCHAR(23),
    @Urgency VARCHAR(12),
    @LandRecoverability VARCHAR(12), 
    @RequestedArea FLOAT,
    @ProjectDuration FLOAT,
    @SubKebele VARCHAR(23),
    @ProjectName VARCHAR(23)
)
AS 
BEGIN TRANSACTION T1
    DECLARE @PRID INT
    IF NOT EXISTS (SELECT [Project ID] FROM Request.tblProject WHERE [Project Name] = @ProjectName)
        INSERT INTO Request.tblProject VALUES(@ProjectName, @projectType)
        
    SELECT  @PRID = (SELECT [Project ID] FROM Request.tblProject WHERE [Project Name] = @ProjectName)

    IF EXISTS (SELECT * FROM Request.tblProReqToLand WHERE [Project ID] = @PRID AND [Responsed By] IS NOT NULL) 
        OR	NOT  EXISTS (SELECT * FROM Request.tblProReqToLand WHERE [Project ID] = @PRID)
    
        INSERT INTO Request.tblProReqToLand (
            [Urgency],
            [Land Recoverability],
            [Request Date],
            [Requested Area],
            [Project Duration],
            [Sub Kebele],
            [Project ID]
        ) VALUES (
            @Urgency,
            @LandRecoverability,
            GETDATE(),
            @RequestedArea,
            @ProjectDuration,
            @SubKebele,
            @PRID
        )
    
    ELSE 
        RAISERROR('The request already exists', 16, 1)

    IF (@@ERROR <> 0)
        ROLLBACK TRANSACTION T1
        COMMIT 

GO



--CREATE PROCEDURE TO MAKE NOTIFICATION
GO
 CREATE PROCEDURE Request.spNotifyLandOwner (@LandOwnerId INT, @Reason VARCHAR(23), @ProjectName VARCHAR(23))
AS 
BEGIN
	DECLARE @PRID INT
	IF NOT EXISTS (SELECT * FROM Request.tblNotifyLandOwner WHERE [Notification Reason] = @Reason AND [Land Owner ID] = @LandOwnerId)
	BEGIN
	SELECT @PRID = (SELECT [Project ID] FROM Request.tblProject WHERE [Project Name] = @ProjectName)
	INSERT INTO Request.tblNotifyLandOwner ( [Notification Reason], [Land Owner ID],
	[Notified By],	[Project ID],[Notification Date])	VALUES ( @Reason, @LandOwnerID, 'Notifier',  @PRID , getDate())
	END
	ELSE
	RAISERROR('Sorry the notification already exist',16,1)	
END
GO

--CREATE PROCEDURE TO Update the notification cofirmition wheather or not landowners has recieved notification for discusssion
GO
CREATE PROCEDURE Request.spUpdateAcceptance (@LandOwnerId INT, @Reason VARCHAR(23),@projectname VARCHAR(23), @RecievedOrNot VARCHAR(23))
AS
BEGIN
	DECLARE @PRID INT
	SELECT @PRID = (SELECT [Project ID] FROM Request.tblProject WHERE [Project Name] = @ProjectName)
    IF EXISTS (SELECT * FROM Request.tblNotifyLandOwner WHERE [Land Owner ID] = @LandOwnerId AND [Notification Reason] = @Reason )	
	UPDATE Request.tblNotifyLandOwner set [Recieved Or Not] = @RecievedOrNot WHERE [Land Owner ID] = @LandOwnerId AND [Project ID] = @PRID AND
	[Notification Reason] = @Reason
	ELSE
	RAISERROR('The record does not exist',16,1)
END
GO



--CREATE STORE PROCEDURE TO SEE NOTIFICATION 
GO
CREATE PROCEDURE Request.spSeeNotificaton(@reason VARCHAR(23) , @projectName VARCHAR(23))
AS
 SELECT * FROM Request.vwNotification WHERE [Notification Reason] = @reason AND [Project Name] = @projectName
GO


-- Create procedure to make minute document by taking landownerid, project name, reason, checkpresence
GO

CREATE PROCEDURE CountProperty.spMakeMinuteDocument (@LandOwnerId INT, @Reason VARCHAR(23), @ProjectName VARCHAR(23), @checkpresence VARCHAR(23))
AS
BEGIN 
	DECLARE @PRID INT
	SELECT @PRID = (SELECT [Project ID] FROM Request.tblProject WHERE [Project Name] = @ProjectName)
	IF EXISTS (SELECT * FROM Request.tblNotifyLandOwner WHERE 
	[Land Owner ID] = @LandOwnerId AND [Project ID] = @PRID)
	IF NOT EXISTS ( SELECT * FROM CountProperty.tblMinuteDocument
	WHERE [Land Owner ID] = @LandOwnerId AND [Document Type] = @Reason) 
	BEGIN
		INSERT INTO CountProperty.tblMinuteDocument VALUES (@checkpresence, GETDATE(), @Reason, @LandOwnerId, 'Minute Document Holder', @PRID)
	END
	ELSE
	RAISERROR('The record  already  exist in the document ',16,1)
	ELSE
	RAISERROR('The LAND OWNER  IS not notified ',16,1)
END
GO


--CREATE STORE PROCEDURE TO SEE THE MINUTE DOCUMENT INFORMATON BY PASSING ITS TYPE AND PROJECT NAME
 GO
 CREATE PROCEDURE CountProperty.spSeeMinuteDocument(@type VARCHAR(23), @projectName VARCHAR(23))
 AS
 SELECT * FROM CountProperty.vwMinutedocument  WHERE [Document Type] = @type AND [Project Name] = @projectName
 GO

 -- create procedure to update quantity of crops QperH of 2years ago, last, and this year 

GO
CREATE PROCEDURE CountProperty.spUpdateCropQuantity (@cropName VARCHAR(23), @last2 FLOAT, @last FLOAT, @this FLOAT, @LandID INT)
AS
BEGIN
  IF EXISTS (SELECT * FROM Property.tblCrop WHERE [Crop Name] = @cropName)
	  IF NOT EXISTS (SELECT * FROM Property.tblLandGivesCrop WHERE [Crop Name] = @cropName AND [Land ID] = @LandID)
	  INSERT INTO Property.tblLandGivesCrop VALUES(@cropName, @this,  @last,  @last2 , @LandID  )
	  ELSE
	
	  RAISERROR('The CROP is already counted ',16,1)

  ELSE
	RAISERROR('The CROP is not found in the DATABASE ',16,1)

END
GO



--Create a procedure to  update quantity of nonproductive plants byn entring the the plant name ,growth expense ,preservation expense and the land oreservation expense

GO
CREATE PROCEDURE CountProperty.spUpdateQuanNonProd (@plantName VARCHAR(23), @quantity INT, @growExp FLOAT, @preserveExp FLOAT, @landID INT)
AS
BEGIN
    IF EXISTS (SELECT * FROM Property.tblNonProductivePlants WHERE [Plant Name] = @plantName)
		IF NOT EXISTS (SELECT *  FROM Property.tblLandGrowsNonProPlants WHERE [Plant Name] = @plantName AND [Land ID] = @landID)
		INSERT INTO Property.tblLandGrowsNonProPlants VALUES(@plantName, @quantity, @growExp, @preserveExp, @landID)
		ELSE
		RAISERROR('The plant is already counted ',16,1)
	ELSE
	RAISERROR('The plant is nor found in the DATABASE ',16,1)
END
GO


-- Create   a procedure to  Update quatntity of productive plants

GO
CREATE PROCEDURE CountProperty.spUpdateProdPlant(@plantName VARCHAR(23), @highQuantity INT, @midQuantity INT, @lowQuantity INT, @growExp FLOAT,
 @preserveExp FLOAT, @landID INT)
AS
BEGIN
    IF EXISTS (SELECT * FROM Property.tblProductivePlants WHERE [Plant Name] = @plantName)
		IF NOT EXISTS (SELECT *  FROM Property.tblLandGrowsProdPlants WHERE [Plant Name] = @plantName AND [Land ID] = @landID)
		INSERT INTO Property.tblLandGrowsProdPlants VALUES(@plantName,  @highQuantity , @midQuantity , @lowQuantity, @growExp, @preserveExp, @landID)
		ELSE
		RAISERROR('The plant is already exist ',16,1)
	ELSE
	RAISERROR('The plant is nor found in the DATABASE ',16,1)
	

END
GO

--the counters count  Update movable property on the given land

GO
CREATE PROCEDURE CountProperty.spUpdatingMovableProperty(@propertyName VARCHAR(23), @uprooteExp FLOAT, @transportExp FLOAT, @InstallExp FLOAT, 
				 @recoveryExp FLOAT, @landID INT)
AS
BEGIN
		IF NOT EXISTS (SELECT *  FROM Property.tblMovableProperty WHERE [Property Name] = @propertyName AND [Land ID] = @landID)
		INSERT INTO Property.tblMovableProperty VALUES (@propertyName, @uprooteExp, @transportExp, @InstallExp, @recoveryExp, @landID)
		ELSE
		RAISERROR('Property  already exist ',16,1)
	
END
GO

--create a procedure to update the labour force quantity and cost the the given house consumed

GO
CREATE PROCEDURE CountProperty.spUpdatingHouse(@houseID INT, @labQuan INT)
AS
BEGIN
	UPDATE Property.tblHouse SET [Labour Quantity] = @labQuan WHERE [House ID] = @houseID
END
GO


--create a procedure to  Update quantity of building material of the given  house
GO
CREATE PROCEDURE CountProperty.spUpdateQuaBM (@name VARCHAR(23), @Quantity INT, @houseID INT)
AS
BEGIN
   IF EXISTS(SELECT * FROM Property.tblBLDGMaterial WHERE [BLDGMterial Name] = @name)
	   IF NOT EXISTS (SELECT * FROM Property.tblBLDGMaterialBuildsHouse WHERE [BLDGMterial Name] = @name AND [House ID] = @houseID)
		INSERT INTO Property.tblBLDGMaterialBuildsHouse VALUES(@name, @Quantity, @houseID)
	   ELSE
	   RAISERROR('The recorder already exist',16,1)
  ELSE 
   RAISERROR('The building material does not found in the database',16,1)
END
GO

--create  procedure to check count
GO
CREATE PROCEDURE CountProperty.spCheckcounting(@checkcounting VARCHAR(23), @landOwnerID INT, @projectID INT, @RepresentativeID INT)
AS
BEGIN
	IF EXISTS (SELECT * FROM Request.tblNotifyLandOwner WHERE [Land Owner ID] = @LandOwnerId AND [Project ID] = @projectID)

	IF NOT EXISTS ( SELECT * FROM Request.tblNotifyLandOwner WHERE [Land Owner ID] = @RepresentativeID ) 
	IF NOT EXISTS ( SELECT * FROM CountProperty.tblCountProperties WHERE [Land Owner ID] = @LandOwnerId ) 
	BEGIN
		INSERT INTO CountProperty.tblCountProperties VALUES(getDate(), @checkcounting , @landOwnerID,
		'Property Counter', @projectID,@RepresentativeID)
	END
	ELSE
	RAISERROR('The record  already  counted ',16,1)
	ELSE
	RAISERROR('This land owner can not be representative because he is the owner of the land  ',16,1)
	ELSE
	RAISERROR('The record is not found in the notification table',16,1)
	
END
GO

--CREATE PROCEDURE TO SEE ALL COUNTED PROPERTY
GO
CREATE PROCEDURE  CountProperty.spSeeCountedAll(@projectName VARCHAR(23))
AS
BEGIN   
	SELECT * FROM  CountProperty.vwSeeCountedCrop WHERE [Project Name] = @projectName	ORDER BY [Land Owner ID]
	SELECT * FROM  CountProperty.vwSeeCountedPlant WHERE [Project Name] = @projectName	ORDER BY [Land Owner ID]
	SELECT * FROM  CountProperty.vwSeeCountedNonProd WHERE [Project Name] = @projectName	ORDER BY [Land Owner ID]
	SELECT * FROM  CountProperty.vwSeeAllMovableProperty WHERE [Project Name] = @projectName	ORDER BY [Land Owner ID]
	SELECT * FROM  CountProperty.vwSeeCountedHouse WHERE [Project Name] = @projectName	ORDER BY [Land Owner ID]
	SELECT * FROM  CountProperty.vwSeeCountedBLDG  WHERE [House ID] in (	SELECT [House ID] FROM  CountProperty.vwSeeCountedHouse WHERE [Project Name] = @projectName)	ORDER BY [House ID]
END
GO


-- CREATE PROCEDURE TO SEE TH SPECIFIC LAND OWNER PROPERTY
GO
CREATE PROCEDURE  CountProperty.spSeeCountedOne(@LandOwnerId INT, @projectName VARCHAR(23))
AS
BEGIN
	SELECT * FROM  CountProperty.vwSeeCountedCrop	WHERE [Land Owner ID] = @LandOwnerId AND [Project Name] = @projectName
	SELECT * FROM  CountProperty.vwSeeCountedPlant	WHERE  [Land Owner ID] = @LandOwnerId AND [Project Name] = @projectName
	SELECT * FROM  CountProperty.vwSeeCountedNonProd WHERE  [Land Owner ID] = @LandOwnerId AND [Project Name] = @projectName
	SELECT * FROM  CountProperty.vwSeeAllMovableProperty	WHERE  [Land Owner ID] = @LandOwnerId AND [Project Name] = @projectName
	SELECT * FROM  CountProperty.vwSeeCountedHouse	WHERE  [Land Owner ID] = @LandOwnerId AND [Project Name] = @projectName
	SELECT * FROM  CountProperty.vwSeeCountedBLDG  WHERE [House ID] in (	SELECT [House ID] FROM  CountProperty.vwSeeCountedHouse WHERE [Project Name] = @projectName and   [Land Owner ID] = @LandOwnerId)	ORDER BY [House ID]
END
GO

--create  procedure to updatewhether estimation has been done or not
GO
CREATE PROCEDURE Compensation.spMakeEstimation( @landOwnerID INT, @projectID INT)
AS
BEGIN
	IF EXISTS (SELECT * FROM CountProperty.tblCountProperties WHERE [Land Owner ID] = @LandOwnerId AND [Project ID] = @projectID) 
		IF NOT EXISTS ( SELECT * FROM Compensation.tblEstimatePrice WHERE [Land Owner ID] = @LandOwnerId ) 
		IF (SELECT Compensation.fnTotalComp( [Land ID] ) from Property.tblLand  WHERE [Land Owner ID] = @landOwnerID) IS NOT NULL
		BEGIN
		SELECT * FROM Compensation.tblEstimatePrice
			INSERT INTO Compensation.tblEstimatePrice ([Estimation Date] , [Amount],[Land Owner ID],[Estimated by],[Project ID]) VALUES  (GETDATE(), Compensation.fnTotalComp( @landOwnerID),
			@landOwnerID, 'Estimator', @projectID)
		END
		ELSE
		RAISERROR('Required information is not fulfilled',16,1)
		ELSE
		RAISERROR('The record  already  estimated ',16,1)
	ELSE
	RAISERROR('The property is not counted',16,1)
	
END
GO

-- stored procedure to see all counted movable property for a specific project
GO
CREATE PROCEDURE CountProperty.spSeeMovableProperty(@projectName VARCHAR(34))
AS
BEGIN
SELECT * FROM CountProperty.vwSeeAllMovableProperty 
WHERE [Project Name] = @projectName
END
GO


-- stored procedure to see all counted movable property for a specific project and landowner id
GO
CREATE PROCEDURE CountProperty.spSeeMovablePropertyOne(@landOwnID INT, @projectName VARCHAR(34))
AS
BEGIN
SELECT * FROM CountProperty.vwSeeAllMovableProperty 
WHERE [Project Name] = @projectName AND [Land Owner ID] = @landOwnID
END
GO


-- To see all counted property for a specific project
GO
CREATE PROCEDURE CountProperty.spCountedInfo (@ProjectName VARCHAR(23))
AS
BEGIN
SELECT * FROM CountProperty.vwCountedInfo
WHERE [Project Name] = @ProjectName
END
GO


-- To see all estimated price for a specific project
GO
CREATE PROCEDURE Compensation.spEstimatedPrice(@ProjectName VARCHAR(23))
AS
BEGIN
SELECT * FROM Compensation.vwAllEstimatedPrice
WHERE [Project Name] = @ProjectName
END
GO

--CREATE STORE PROCEDURE TO SEE THE TOTAL COMPENSATION for prticular project
GO
CREATE PROCEDURE Compensation.spSeeTotalCompensation(@projectName VARCHAR(23))
AS
SELECT * FROM Compensation.vwSeeTotalCompensation WHERE [Project Name] = @projectName
GO


--CREATE STORE PROCEDURE TO SEE THE ACCOUNT OF LANDOWNERS OF SPECIFIC PROJECT
GO
CREATE PROCEDURE Compensation.spSeeAllAcount(@projectName VARCHAR(34))
AS
SELECT * FROM Compensation.vwSeeAccount WHERE [Land Owner ID] IN (SELECT [Land Owner ID] 
FROM  Compensation.vwSeeTotalCompensation WHERE [Project Name] = @projectName) 
GO


--Create store procedure to verify the estimation result
GO
CREATE PROCEDURE Compensation.spVerifyEstimation(@checkEstim VARCHAR(23), @landOwnerID INT, @projectID INT)
AS   
BEGIN TRANSACTION T1
	IF EXISTS (SELECT * FROM Compensation.tblEstimatePrice WHERE [Land Owner ID] = @LandOwnerId AND [Project ID] = @projectID) 
		BEGIN
			DECLARE @landid INT
			SELECT @landid = (SELECT [Land ID] from Property.tblLand WHERE [Land Owner ID] = @landOwnerID)
			UPDATE  Compensation.tblEstimatePrice SET [Amount] =Compensation.fnTotalComp( @landid)  WHERE [Land Owner ID] = @LandOwnerId 
			AND [Project ID] = @projectID
			UPDATE  Compensation.tblEstimatePrice SET [Check Estiamtion ] = @checkEstim  WHERE [Land Owner ID] = @LandOwnerId 
			AND [Project ID] = @projectID
		END
	ELSE
	RAISERROR('The property is not counted',16,1)
IF(@@ERROR<>0)
	ROLLBACK TRANSACTION T1
COMMIT
GO

-- INSERTING ACCOUNT OF LANDOWNERS INTO THE TABLE ACCOUNT 
GO
CREATE PROCEDURE Compensation.spAddAccount(@landOwnerID INT, @projectID INT, @accountNum INT)
AS
BEGIN TRANSACTION T1

	IF NOT EXISTS (SELECT * FROM Compensation.tblAccount WHERE [Land Owner ID] = @landOwnerID)
	BEGIN
		INSERT INTO Compensation.tblAccount VALUES (@landOwnerID, @accountNum)
		INSERT INTO Compensation.tblProjPaysToLanOwn([Land Owner ID], [Project ID]) VALUES (@landOwnerID, @projectID)
	END
IF(@@ERROR<>0)
	ROLLBACK TRANSACTION T1

COMMIT 
GO

--CREATE  STORE PROCEDURE TO CHECK PAYMENT CHECK
GO
CREATE PROCEDURE Compensation.spPaymentCheck(@projectName VARCHAR(23))
AS 
SELECT * FROM Compensation.vwPaymentCheck 
WHERE [Project Name] = @projectName
GO

-- updating projects pay to landowners
GO
CREATE PROCEDURE Compensation.spPayToLandOwners( @landOwnerID INT, @projectID INT)
AS
BEGIN
	UPDATE Compensation.tblProjPaysToLanOwn SET [Deposited Date] = GETDATE(), Amount = Compensation.fnTotalComp(@landOwnerID) WHERE [Land Owner ID] = @landOwnerID AND
	[Project ID] = @projectID
END
GO


--CREATE STORE PEROCEDURE TO SEE THE PAYMENT TABLE
GO
CREATE PROCEDURE Compensation.spSeePayment(@projectName VARCHAR(34))
AS
SELECT * FROM Compensation.vwProjPaysToLanOwn WHERE [Project Name] = @projectName
GO


--CREATE STOTE PROCEDURE TO SEE THE PRIORITY TABLE
GO
CREATE PROCEDURE Rehabilitation.spSeePriority(@projectName VARCHAR(23))
AS
SELECT * FROM Rehabilitation.vwSeePriority 
WHERE [Land Owner ID] IN (SELECT [Land Owner ID] FROM Compensation.vwSeeTotalCompensation WHERE 
[Project Name] = @projectName)
GO

-- prioritizing evacuees by inserting valued to prioritize table
GO
CREATE PROCEDURE Rehabilitation.spInsertPriority(@cityLanArea FLOAT, @reasonForLand VARCHAR(30), @disablility VARCHAR(30), @landOwnerID INT)
AS
BEGIN
IF EXISTS (SELECT * FROM Compensation.tblAccount WHERE [Land Owner ID] = @landOwnerID)
	BEGIN
	INSERT INTO Rehabilitation.tblPriority VALUES(@cityLanArea, @reasonForLand, @disablility, @landOwnerID)
	END
ELSE
	RAISERROR('Land owner not applicable.', 16, 1)
END
GO

-- CREATE PROCEDURE TO  prioririze based on age, disability, city land area
GO
CREATE PROCEDURE Rehabilitation.spPrioritizedLanOwner
AS
BEGIN TRANSACTION T1

	 INSERT INTO Rehabilitation.tblPrioritizedLandOwner SELECT [land Owner ID], Rehabilitation.fnCityLanEligibile([land Owner ID]), 'Rehabilitator' FROM Rehabilitation.tblPriority WHERE 
	 [Disability] = 'Disable' AND Rehabilitation.fnCalcAge([land Owner ID]) > 65  AND  Rehabilitation.fnCityLanEligibile([land Owner ID]) > 100

	 INSERT INTO Rehabilitation.tblPrioritizedLandOwner SELECT [land Owner ID], Rehabilitation.fnCityLanEligibile([land Owner ID]), 'Rehabilitator' FROM Rehabilitation.tblPriority WHERE 
	 [Disability] = 'Disable' AND Rehabilitation.fnCalcAge([land Owner ID]) < 65  AND  Rehabilitation.fnCityLanEligibile([land Owner ID]) > 100

	 INSERT INTO Rehabilitation.tblPrioritizedLandOwner SELECT [land Owner ID], Rehabilitation.fnCityLanEligibile([land Owner ID]), 'Rehabilitator' FROM Rehabilitation.tblPriority WHERE 
	 [Disability] = 'None' AND Rehabilitation.fnCalcAge([land Owner ID]) > 65  AND  Rehabilitation.fnCityLanEligibile([land Owner ID]) > 100

	INSERT INTO Rehabilitation.tblPrioritizedLandOwner SELECT [land Owner ID], Rehabilitation.fnCityLanEligibile([land Owner ID]), 'Rehabilitator' FROM Rehabilitation.tblPriority WHERE 
	 [Disability] = 'None' AND Rehabilitation.fnCalcAge([land Owner ID]) < 65  AND  Rehabilitation.fnCityLanEligibile([land Owner ID]) > 100

	 INSERT INTO Rehabilitation.tblPrioritizedLandOwner SELECT [land Owner ID], Rehabilitation.fnCityLanEligibile([land Owner ID]), 'Rehabilitator' FROM Rehabilitation.tblPriority 
      WHERE Rehabilitation.fnCityLanEligibile([land Owner ID]) < 100
IF(@@ERROR<>0)
	ROLLBACK TRANSACTION T1
COMMIT
GO




-- CREATE PROCEDURE Update interest request table

GO
CREATE PROCEDURE Rehabilitation.spRequestInterest(@interest VARCHAR(23), @landOwnID INT)
AS
BEGIN
IF EXISTS (SELECT * FROM Compensation.tblAccount WHERE [Land Owner ID] = @landOwnID)
	BEGIN
	INSERT INTO Rehabilitation.tblInterestRequest VALUES(@interest, @landOwnID, 'Rehabilitator') 
	END
ELSE
	RAISERROR('Land owner not applicable.', 16, 1)
END

GO


-- CREATE PROCEDURE Update private work table
GO
CREATE PROCEDURE Rehabilitation.spAddToPrivateWork(@interest VARCHAR(23), @govBudgetSup INT,@ExpertAdV VARCHAR(500), @landOwnID INT)
AS

BEGIN
IF EXISTS (SELECT * FROM tblInterestRequest WHERE [Land Owner ID] = @landOwnID)
	BEGIN
	INSERT INTO Rehabilitation.tblPrivateWork VALUES(@interest, @govBudgetSup,@ExpertAdV,  @landOwnID, 'Rehabilitator') 
	END
ELSE
	RAISERROR('Land owner not applicable.', 16, 1)
END

GO


--CREATE STORE PROCEDURE TO RETREIVE THE LAND OWNER INFORMATION WHO FOUND IN  AT SOME SUB-KEBELE

GO
CREATE PROCEDURE LandOwner.spLandOwnersInfo(@SubKebele VARCHAR(23))
AS
BEGIN 
SELECT [Land Owner ID], [First Name], [Last Name],[Gender],[Birth Date],[Phone Number],[Region],[Zone],[Wereda],
[Kebele], AD.[Sub Kebele] FROM LandOwner.tblLandOwner LO, LandOwner.tblAddress AD WHERE LO.[Sub Kebele] = AD.[Sub Kebele] AND
AD.[Sub Kebele] = @SubKebele
END 
GO



--CREATE PROCEDURE TO SEE THE INFORMATION OF ABOUTS SOMEONE'S FOXED PROPERTY

GO
CREATE PROCEDURE LandOwner.spFixedPropertyInfo(@landOwnerId INT, @Type VARCHAR(23))
AS
BEGIN
IF (@Type = 'Productive')
SELECT PP.[Plant Name], [High Level Quantity],[High Level Current Price], [Middle Level Quantity] ,[Middel Level Current Price], [Low Level Quantity], [low Level Current Price],
 [Growth Expense],[Preservation Expense] FROM Property.tblProductivePlants PP, Property.Property.tblLandGrowsProdPlants LGPP  WHERE PP.[Plant Name] = LGPP.[Plant Name] AND [Land ID] IN (SELECT [Land ID]
  FROM Property.tblLand WHERE [Land Owner ID] IN (SELECT [Land Owner ID] FROM Property.LandOwner.tblLandOwner WHERE [Land Owner ID] = @landOwnerId))
ELSE
SELECT NPP.[Plant Name], [Quantity],[Current Price], [Growth Expense],[Preservation Expense] FROM Property.tblNonProductivePlants NPP , Property.Property.tblLandGrowsNonProPlants LGNPP WHERE 
 NPP.[Plant Name] = LGNPP.[Plant Name] AND [Land ID] IN (SELECT [Land ID] FROM Property.tblLand WHERE [Land Owner ID] IN (SELECT [Land Owner ID] FROM Property.LandOwner.tblLandOwner WHERE 
 [Land Owner ID] = @landOwnerId))
END
GO

--CREATE PROCEDURE TO SEE THE SPECIFIC SUB KEBELE'S LAND INFO
GO
CREATE PROCEDURE Property.spSubKebeleLandInfo(@subkebele varchar(34))
AS 
BEGIN 
SELECT [Land ID], [Land Type] ,[Land Use], [Land Area],[Region], [Zone], [Wereda], [Kebele], AD.[Sub Kebele]
FROM Property.tblLand LA, LandOwner.tblAddress AD
WHERE LA.[Sub Kebele] = AD.[Sub Kebele] AND AD.[Sub Kebele] = @subkebele
END
GO


-- TO DISPLAY FAMILY MEMBERS OF LANDOWNERS
GO
CREATE PROCEDURE LandOwner.spFamilyMembers(@landOwnerID INT)
AS
BEGIN 
	SELECT	[Member ID],FM.[First Name] ,FM.[Last Name], FM.[Gender], [Relationship],FM.[Birth Date] ,
	FM.[Phone Number],FM.[Photo], LO.[First Name], LO.[Last Name],LO.[Gender], LO.[Phone Number],[Region],[Zone],[Wereda], [Kebele],
	AD.[Sub Kebele] FROM tblFamilyMember FM, LandOwner.tblLandOwner LO, LandOwner.tblAddress AD WHERE LO.[Sub Kebele] = AD.[Sub Kebele]
	AND LO.[Land Owner ID] = @landOwnerID AND LO.[Land Owner ID] = FM.[Land Owner ID] 
END
GO

-- grouping the landowners
GO
CREATE PROCEDURE Rehabilitation.spFormTeam(@lamdOwnerID INT,@expertAdvice VARCHAR(MAX) ,@teamName VARCHAR(23),@GovernmentBudgetSupport FLOAT)
AS
BEGIN TRANSACTION T1
	IF NOT EXISTS ( SELECT * FROM Rehabilitation.tblTeam WHERE [Team Name] = @teamName )
	INSERT INTO Rehabilitation.tblTeam([Team Name]) VALUES (@teamName) 
	INSERT INTO Rehabilitation.tblTeamRehabilitatesOn VALUES (@lamdOwnerID,'Rehabilitator', @teamName, @expertAdvice , @GovernmentBudgetSupport)
IF(@@ERROR<>0)
	ROLLBACK TRANSACTION T1
COMMIT
GO


--CREATE PROCEDURE TO SEE EXPERTS WHO INVOLVE IN PARTICULAR PROJECT
GO
 CREATE PROCEDURE staff.spExpertsInfo(@ProjectName VARCHAR(23))
 AS 
 BEGIN
 DECLARE @reqID INT 
 SELECT @reqID = (SELECT [Project ID]  FROM Request.tblProject WHERE [Project Name] = @ProjectName)
 SELECT [First Name],[Last Name],[Gender],[Phone Number],[Job Title] FROM tblEmployee  UNION SELECT
 [First Name],[Last Name],[Gender],[Phone Number],'Representative' as [Job Title]  FROM CountProperty.tblCountProperties CP ,LandOwner.tblLandOwner LO 
 WHERE LO.[Land Owner ID] = CP.[Representative ID] AND [Project ID] = @reqID
 END
 GO

--CREATE PORCEDURE TO SEE PRIORITIZED MEMBER
GO
CREATE PROCEDURE Rehabilitation.spPrioritisedMember(@projectName VARCHAR(23))
AS
SELECT * FROM Rehabilitation.vwPrioritizedLandowner WHERE  [Land Owner ID] IN (SELECT [Land Owner ID]
FROM Compensation.vwSeeTotalCompensation WHERE [Project Name] = @projectName)
GO

 


