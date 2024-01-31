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

  --CREATE VIEW TO SEE THE MINUTE  DOCUMENT
  GO
   CREATE VIEW CountProperty.vwMinutedocument AS 
SELECT 
  l.[Land Owner ID], 
  [First Name] + ' ' + [Last NAme] as 'Land Owner Name', 
  [Check Presense], 
  [Discussion Date], 
  [Document Type], 
  [Project Name], 
  [Held By] 
FROM 
  Request.tblProject P, 
  CountProperty.tblMinuteDocument M, 
  LandOwner.tblLandOwner L 
WHERE 
  P.[Project ID ] = M.[Project ID] 
  AND L.[Land Owner ID] = M.[Land Owner ID] 
  GO
  
  --CREATE VIEW TO SEE COUNTED CROP
  GO 
  CREATE VIEW CountProperty.vwSeeCountedCrop AS 
SELECT 
  [First Name] + ' ' + [Last NAme] as 'Land Owner Name', 
  L.[Land Owner ID], 
  [Project Name], 
  C.[Crop Name], 
  LC.[Hervest QPerH of Last Year], 
  lc.[Hervest QPerH of This Year], 
  lc.[Hervest QPerH Two Year Ago], 
  [Current Price] 
FROM 
  Property.tblLandGivesCrop LC, 
  Property.tblCrop C, 
  Property.tblLand L, 
  CountProperty.vwMinutedocument VN, 
  LandOwner.tblLandOwner LA 
WHERE 
  L.[Land Owner ID] = LA.[Land Owner ID] 
  AND L.[Land ID] = LC.[Land ID] 
  AND LC.[Crop Name] = C.[Crop Name] 
  AND LA.[Land Owner ID] = VN.[Land Owner ID]
  GO 
