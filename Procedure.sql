
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

