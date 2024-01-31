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


  --CREATE VIEW TO SEE COUNTED PRODUCTIVE PLANT
 GO
 CREATE VIEW CountProperty.vwSeeCountedPlant AS 
SELECT 
  [First Name] + ' ' + [Last NAme] as 'Land Owner Name', 
  L.[Land Owner ID], 
  [Project Name], 
  P.[Plant Name], 
  LP.[High Level Quantity], 
  p.[High Level Current Price], 
  LP.[Low Level Quantity], 
  P.[low Level Current Price], 
  LP.[Middle Level Quantity], 
  P.[Middel Level Current Price], 
  [Preservation Expense] 
FROM 
  Property.tblLandGrowsProdPlants LP, 
  Property.tblProductivePlants P, 
  CountProperty.vwMinutedocument VN, 
  Property.tblLand L, 
  LandOwner.tblLandOwner LA 
WHERE 
  L.[Land Owner ID] = LA.[Land Owner ID] 
  AND L.[Land ID] = LP.[Land ID] 
  AND LP.[Plant Name] = P.[Plant Name] 
  AND L.[Land Owner ID] = VN.[Land Owner ID] 
GO 

  --CREATE VIEW TO SEE COUNTED NON PRODUCTIVE PLANT
  GO
  CREATE VIEW CountProperty.vwSeeCountedNonProd AS 
SELECT 
  [First Name] + ' ' + [Last NAme] as 'Land Owner Name', 
  L.[Land Owner ID], 
  [Project Name], 
  NP.[Plant Name], 
  Quantity, 
  [Current Price], 
  [Preservation Expense] 
FROM 
  Property.tblLandGrowsNonProPlants LNP, 
  CountProperty.vwMinutedocument VN, 
  Property.tblNonProductivePlants NP, 
  Property.tblLand L, 
  LandOwner.tblLandOwner LA 
WHERE 
  L.[Land Owner ID] = LA.[Land Owner ID] 
  AND L.[Land ID] = LNP.[Land ID] 
  AND NP.[PLant Name] = LNP.[Plant Name] 
  AND LA.[Land Owner ID] = VN.[Land Owner ID] 
 GO

   --CREATE VIEW TO SEE THE HOUSE INFORMATION
  GO
  CREATE VIEW CountProperty.vwSeeCountedHouse AS 
SELECT 
  [First Name] + ' ' + [Last NAme] as 'Land Owner Name', 
  L.[Land Owner ID], 
  [Project Name], 
  [House ID], 
  [Labour Quantity], 
  [Current labour Cost] 
FROM 
  Property.tblHouse H, 
  Property.tblLand L, 
  CountProperty.vwMinutedocument VN, 
  LandOwner.tblLandOwner LA 
WHERE 
  L.[Land Owner ID] = LA.[Land Owner ID] 
  AND L.[Land ID] = H.[Land ID] 
  AND LA.[Land Owner ID] = VN.[Land Owner ID] 
  GO