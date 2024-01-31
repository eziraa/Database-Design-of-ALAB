
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

