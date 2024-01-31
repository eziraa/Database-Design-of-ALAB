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

    --CREATE VIEW TO SEE THE COUNTED HOUSE BUILDING MATERIAL
  GO
  CREATE VIEW CountProperty.vwSeeCountedBLDG AS 
SELECT 
  [First Name] + ' ' + [Last NAme] as 'Land Owner Name', 
  L.[Land Owner ID], 
  H.[House ID], 
  BL.Quantity, 
  BLDG.[Current Price], 
  bl.[BLDGMterial Name] 
FROM 
  Property.tblHouse H, 
  Property.tblBLDGMaterial BLDG, 
  Property.tblBLDGMaterialBuildsHouse BL, 
  Property.tblLand L, 
  LandOwner.tblLandOwner LA 
WHERE 
  L.[Land Owner ID] = LA.[Land Owner ID] 
  AND L.[Land ID] = H.[Land ID] 
  AND H.[House ID] = BL.[House ID] 
  AND BL.[BLDGMterial Name] = BLDG.[BLDGMterial Name] 
  GO

    --CREATE VIEW TO SEE THE FINAL ETIMATED COMPENSATION OF LAND OWNER
  GO
  CREATE VIEW Compensation.vwSeeEstimated AS 
SELECT 
  [First Name] + ' ' + [Last NAme] AS 'Land Owner Name', 
  LA.[Land Owner ID], 
  EP.[Check Estiamtion ], 
  Amount, 
  EP.[Estimation Date], 
  EP.[Project ID], 
  EP.[Estimated by] 
FROM 
  LandOwner.tblLandOwner LA, 
  Compensation.tblEstimatePrice EP 
WHERE 
  lA.[Land Owner ID] = EP.[Land Owner ID] 
  GO

  -- CREATE PROJECTINFO VIEW
  GO
  CREATE VIEW Request.vwProjectInfo AS 
SELECT 
  [Project Type], 
  [Project Name], 
  [Urgency], 
  [Land Recoverability], 
  [Request Date], 
  [Requested Area], 
  [Project Duration], 
  [Region], 
  [Zone], 
  [Wereda], 
  [Kebele], 
  AD.[Sub Kebele] 
FROM 
  Request.tblProject PR, 
  Request.tblProReqToLand PRL, 
  LandOwner.tblAddress AD 
WHERE 
  PR.[Project ID] = PRL.[Project ID] 
  AND PRL.[Sub Kebele] = AD.[Sub Kebele] 
  GO

    -- CREATE VIEW EMPLOYEEINFO
  GO
  CREATE VIEW Staff.vwEmployeeInfo AS 
SELECT 
  [Employee ID], 
  [First Name], 
  [Last Name], 
  [Gender], 
  RE.[Job Title], 
  EM.[Phone Number], 
  Em.[Email], 
  RDN.[RPR Directorate Name] 
FROM 
  tblEmployee EM, 
  tblRPRDirectorate RDN, 
  Staff.tblResponsibility RE 
WHERE 
  RDN.[RPR Directorate Name] = EM.[RPR Director Name] 
  AND EM.[Job Title] = RE.[Job Title] 
GO


  -- CREATE EXPERTINFO
 GO
CREATE VIEW vwExpertInfo AS 
SELECT 
  [First Name], 
  [Last Name], 
  [Gender], 
  [Phone Number], 
  [Job Title] 
FROM 
  staff.tblEmployee 
UNION 
SELECT 
  [First Name], 
  [Last Name], 
  [Gender], 
  [Phone Number], 
  'Observer' as [Job Title] 
FROM 
  CountProperty.tblCountProperties CP, 
  LandOwner.tblLandOwner LO 
WHERE 
  LO.[Land Owner ID] = CP.[Representative ID] 
  GO

  -- To see all counted movable property 
GO
CREATE VIEW CountProperty.vwSeeAllMovableProperty
AS 
SELECT   [First Name] + ' ' + [Last NAme] as 'Land Owner Name', LO.[Land Owner ID], [Project Name], [Property Name],
	[Uprooting Expense] ,[Transportation Expense] ,[Installation Expense] ,[Recovery Expense]
FROM Property.tblMovableProperty MP, LandOwner.tblLandOwner LO, Request.tblProject PR, Property.tblLand LA, 
Request.tblProReqToLand PL

WHERE LO.[Land Owner ID] = LA.[Land Owner ID] AND MP.[Land ID] = LA.[Land ID] AND PR.[Project ID ] = PL.[Project ID]
AND MP.[Land ID] = LA.[Land ID]
GO

-- To see all counted property 
GO
CREATE VIEW CountProperty.vwCountedInfo
AS 
SELECT   LO.[First Name] + ' ' + LO.[Last Name] as 'Land Owner Name', LO.[Land Owner ID], [Project Name], [Counting Date],
[Check Counting], [Counted By], RP.[First Name] + ' ' + RP.[Last NAme] as 'Representative Name'
FROM LandOwner.tblLandOwner LO, Request.tblProject PR, CountProperty.tblCountProperties CP, 
LandOwner.tblLandOwner RP
WHERE LO.[Land Owner ID] = CP.[Land Owner ID] AND PR.[Project ID ] = CP.[Project ID] 
AND  [Representative ID] = RP.[Land Owner ID]
GO

-- To see all estimated price
GO
CREATE VIEW Compensation.vwAllEstimatedPrice
AS 
SELECT   LO.[First Name] + ' ' + LO.[Last Name] as 'Land Owner Name', LO.[Land Owner ID], [Project Name], 
[Estimation Date],[Check Estiamtion], [Estimated By]
FROM LandOwner.tblLandOwner LO, Request.tblProject PR, Compensation.tblEstimatePrice EP
WHERE LO.[Land Owner ID] = EP.[Land Owner ID] AND PR.[Project ID ] = EP.[Project ID] 
GO

--CREATE VIEW TO SEE THE TOTAL COMPENSATION
GO
CREATE VIEW Compensation.vwSeeTotalCompensation
AS
SELECT LO.[First Name] + ' ' + LO.[Last Name] as 'Land Owner Name', LO.[Land Owner ID], [Project Name], 
[Amount] , [Compensation Date]
FROM LandOwner.tblLandOwner LO, Request.tblProject PR, Compensation.tblTotalCompensation TC
WHERE LO.[Land Owner ID] = TC.[Land Owner ID] AND PR.[Project ID ] = TC.[Project ID] 
GO

--CREATE VIEW TO SEE THE ACCOUNT OF THE LAND OWNERS
GO
CREATE VIEW Compensation.vwSeeAccount
AS
 SELECT   LO.[First Name] + ' ' + LO.[Last Name] as 'Land Owner Name', LO.[Land Owner ID],[Account Number]
FROM LandOwner.tblLandOwner LO, Compensation.tblAccount AC 
WHERE LO.[Land Owner ID] = AC.[Land Owner ID]

GO

--CREATE VIEW TO CHECK PAYMENT
GO
CREATE VIEW Compensation.vwPaymentCheck
AS
 SELECT   LO.[First Name] + ' ' + LO.[Last Name] as 'Land Owner Name', LO.[Land Owner ID],[Checked By], PR.[Project Name],
 [Compensation Date], [Check Payment], [Amount] 
FROM LandOwner.tblLandOwner LO, Request.tblProject PR, Compensation.tblPaymentCheck PC
WHERE LO.[Land Owner ID] = PC.[Land Owner ID] AND PR.[Project ID ] = PC.[Project ID] 
GO

--CREATE VIEW TO SEE PAYMENT
GO
CREATE VIEW Compensation.vwProjPaysToLanOwn
AS
 SELECT   LO.[First Name] + ' ' + LO.[Last Name] as 'Land Owner Name', LO.[Land Owner ID], PR.[Project Name],
 [Deposited Date], [Amount] 
FROM LandOwner.tblLandOwner LO, Request.tblProject PR, Compensation.tblProjPaysToLanOwn PC
WHERE LO.[Land Owner ID] = PC.[Land Owner ID] AND PR.[Project ID ] = PC.[Project ID]

GO

--CREATE VIEW TO SEE PROIRITY TABLE
GO
CREATE VIEW Rehabilitation.vwSeePriority
AS
SELECT LO.[First Name] + ' ' + LO.[Last Name] as 'Land Owner Name',   LO.[Land Owner ID], 
PT.[City Land Area], PT.[Reason for City Land], PT.Disability
FROM Rehabilitation.tblPriority PT, LandOwner.tblLandOwner LO
WHERE  LO.[Land Owner ID] = PT.[Land Owner ID] 
GO

--CREATE VIEW TO SEE THE PRIORITIZED MEMBER
GO
CREATE VIEW Rehabilitation.vwPrioritizedLandowner
AS
SELECT  LO.[First Name] + ' ' + LO.[Last Name] as 'Land Owner Name',   LO.[Land Owner ID],PL.[Compensated Area of City Land] 
,[Prioritized By] FROM Rehabilitation.tblPrioritizedLandOwner PL, LandOwner.tblLandOwner LO
WHERE  LO.[Land Owner ID] = PL.[Land Owner ID] 
GO

--CREATE VIEW TO SEE THE INTEREST OF THE LAND OWNER
GO
  CREATE VIEW Rehabilitation.vwSeeLandOwersInterest AS 
SELECT 
  [Interest Name], 
  [First Name] + ' ' + [Last Name] as 'Land Owner Name', 
  L.[Land Owner ID], 
  [Requested By] 
FROM 
  LandOwner.tblLandOwner L, 
  Rehabilitation.tblInterestRequest I 
WHERE 
  L.[Land Owner ID] = I.[Land Owner ID] 
 GO
 

