
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