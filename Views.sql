--CREATE VIEW TO SEE LAND  REQUEST

GO
CREATE VIEW Request.vwSeeRequest AS 
SELECT 
  [Request ID], 
  [Project Name], 
  [Project Type], 
  [Urgency], 
  [Land Recoverability], 
  [Requested Area], 
  [Project Duration], 
  [Sub Kebele] 
FROM 
  Request.tblProject P, 
  Request.tblProReqToLand R 
WHERE 
  P.[Project ID ] = R.[Project ID]
  GO


   --CREATE VIEW TO SEE NOTIFICATION
   GO
  CREATE VIEW Request.vwNotification AS 
SELECT 
  [Notification Date], 
  [Project Name], 
  [Recieved Or Not], 
  [Notification Reason], 
  [First Name] + ' ' + [Last NAme] as 'Land Owner Name' 
FROM 
  Request.tblProject P, 
  Request.tblNotifyLandOwner R, 
  LandOwner.tblLandOwner L 
WHERE 
  P.[Project ID ] = R.[Project ID] 
  AND L.[Land Owner ID] = R.[Land Owner ID] 
  GO
