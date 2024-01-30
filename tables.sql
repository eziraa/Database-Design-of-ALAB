
--CREATE ADDRESS TABLE
CREATE TABLE tblAddress ( 
	[Region] VARCHAR(23) DEFAULT 'Amhara',
	[Zone] VARCHAR(23),
	[Wereda] VARCHAR(23),
	[Kebele] VARCHAR(23),
	[Sub Kebele] VARCHAR(23) CONSTRAINT tblAddressPK PRIMARY KEY )


--CREATE LAND OWNER TABLE 
CREATE TABLE tblLandOwner(
	[Land Owner ID] INT CONSTRAINT tblLandOwnerPK PRIMARY KEY,
	[First Name] VARCHAR(23),
	[Last Name] VARCHAR (23),
	[Gender] CHAR,
	[Birth Date] DATE,
	[Phone Number] INT UNIQUE,
	[Photo] VARBINARY(MAX),
	[Sub Kebele] VARCHAR (23) CONSTRAINT tblLandOwnerFK1 FOREIGN KEY REFERENCES LandOwner.tblAddress([Sub Kebele]))



--CREATING LAND TABLE
CREATE TABLE tblLand (
	[Land ID] INT CONSTRAINT tblLandPK PRIMARY KEY,
	[Land Type] VARCHAR(23),
	[Land Use] VARCHAR(23),
	[Land Area] FLOAT ,
	[Sub Kebele]VARCHAR(23) CONSTRAINT tblLandFK1  FOREIGN KEY REFERENCES LandOwner.tblAddress([Sub Kebele]),
	[Land Owner ID] INT CONSTRAINT tblLandFK2 FOREIGN KEY REFERENCES LandOwner.tblLandOwner([Land Owner ID]),
	)

--CREATING CROP TABLE
  CREATE TABLE tblCrop( 
	[Crop Name] VARCHAR(23) CONSTRAINT cropPK PRIMARY KEY ([Crop Name]) ,
	[Current Price] FLOAT )

--CREATING LANDGIVESCROP TABLE
CREATE TABLE tblLandGivesCrop( 
	[Crop Name] VARCHAR(23)  CONSTRAINT tblLandGivesCropFK1 FOREIGN KEY REFERENCES Property.tblCrop([Crop Name]),
	[Hervest QPerH of This Year] FLOAT ,
	[Hervest QPerH of Last Year] FLOAT ,
	[Hervest QPerH Two Year Ago] FLOAT ,
	[Land ID]INT CONSTRAINT tblLandGivesCropFK2 FOREIGN KEY REFERENCES Property.tblLand([Land ID]),
	CONSTRAINT tblLandGivesCropcropPK PRIMARY KEY ([Crop Name],[Land ID])
	)

--CREATING NON PRODUCTIVE PLANT TABLE
CREATE TABLE tblNonProductivePlants( 
	[Plant Name] VARCHAR(23) CONSTRAINT tblNonProductivePlantsPK PRIMARY KEY,
	[Current Price] FLOAT)

--CREATING LAND GROWS NON PRODUCTIVE PLANT TABLE
CREATE TABLE tblLandGrowsNonProPlants( 
	[Plant Name] VARCHAR(23) CONSTRAINT tblLandGrowsNonProPlantsFK1 FOREIGN KEY REFERENCES
	Property.tblNonProductivePlants([Plant Name]),
	[Quantity] INT ,
	[Growth Expense] FLOAT , 
	[Preservation Expense] FLOAT ,
	[Land ID]INT CONSTRAINT tblLandGrowsNonProPlantsFK2 FOREIGN KEY REFERENCES Property.tblLand([Land ID]),
	CONSTRAINT tblLandGrowsNonProPlantsPK PRIMARY KEY([Plant Name],[land ID]))


--CREATING PRODUCTIVE PLANTS TABLE

CREATE TABLE tblProductivePlants(
	[Plant Name] VARCHAR(23) CONSTRAINT tblProductivePlantsPK PRIMARY KEY,
	[High Level Current Price] FLOAT ,
	[Middel Level Current Price] FLOAT ,
	[low Level Current Price] FLOAT	)


--CREATING LAND GIVES PRODUCTIVE PLANTS TABLE

CREATE TABLE tblLandGrowsProdPlants(
	[Plant Name] VARCHAR(23) CONSTRAINT tblLandGrowsProPlantsFK1 FOREIGN KEY REFERENCES Property.tblProductivePlants([Plant Name]) ,
	[High Level Quantity] INT,
	[Middle Level Quantity] INT,
	[Low Level Quantity] INT,
	[Growth Expense] FLOAT, 
	[Preservation Expense] FLOAT,
	[Land ID] INT CONSTRAINT tblLandGrowsProdPlantsFK2 FOREIGN KEY REFERENCES Property.tblLand([Land ID]),
	CONSTRAINT tblLandGrowsProdPlantsPK PRIMARY KEY([Plant Name],[Land ID]))

--CREATET MOVABLE PROPERTY TABLE

CREATE TABLE tblMovableProperty(
	[Property Name] VARCHAR(23) ,
	[Uprooting Expense] FLOAT ,
	[Transportation Expense] FLOAT ,
	[Installation Expense] FLOAT ,
	[Recovery Expense] FLOAT ,
	[Land ID] INT CONSTRAINT tblMovablePropertyFK FOREIGN KEY REFERENCES Property.tblLand([Land ID]),
	CONSTRAINT tblMovablePropertyPK PRIMARY KEY ([Land ID] ,[Property Name]))

--CREATE HOUSE TABLE
CREATE TABLE tblHouse(
	[House ID] INT CONSTRAINT tblHousePK PRIMARY KEY ,
	[Labour Quantity] INT ,
	[Current labour Cost] FLOAT ,
	[Land ID] INT CONSTRAINT tblHouseFK FOREIGN KEY REFERENCES Property.tblLand([Land ID]))


--CREATE BUILDING MATERIAL TABLE
CREATE TABLE tblBLDGMaterial( 
	[BLDGMterial Name] VARCHAR(23) CONSTRAINT tblBLDGMaterialPK PRIMARY KEY ,
	[Current Price] FLOAT)

--CREATE BUILDING MATERIAL BUILDS HOUSE TABLE
CREATE TABLE tblBLDGMaterialBuildsHouse( 
	[BLDGMterial Name] VARCHAR(23)  CONSTRAINT tblBLDGMaterialBuildsHouseFK1 FOREIGN KEY REFERENCES Property.tblBLDGMaterial([BLDGMterial Name]),
	[Quantity] INT,
	[House ID] INT CONSTRAINT tblBLDGMaterialBuildsHouseFK2 FOREIGN KEY REFERENCES Property.tblHouse([House ID]),
	CONSTRAINT tblBLDGMaterialBuildsHousePK PRIMARY KEY ([BLDGMterial Name],[House ID]))

--CREATE PROJECT TABLE
CREATE TABLE tblProject(
	[Project ID ]INT CONSTRAINT tblProjectPK PRIMARY KEY IDENTITY(1, 1),
	[Project Name] VARCHAR(23),
	[Project Type] VARCHAR(25))


--CREATE Responsibility TABLE

CREATE TABLE tblResponsibility([Job Title] VARCHAR(23) CONSTRAINT tblResponsibilityPK PRIMARY KEY )

--CREATE FAMILY MEMEBER TABLE
CREATE TABLE tblFamilyMember(
	[Member ID] INT ,
	[First Name] VARCHAR(23),
	[Last Name] VARCHAR (23),
	[Gender] CHAR,
	[Relationship] VARCHAR (23),
	[Birth Date] DATE,
	[Phone Number] INT UNIQUE,
	[Photo] VARBINARY(MAX),
	[Land Owner ID] INT CONSTRAINT tblFamilyMemberFK FOREIGN KEY  REFERENCES LandOwner.tblLandOwner([Land Owner ID]),
	CONSTRAINT tblFamilyMemberPK PRIMARY KEY([Member ID],[Land Owner ID]))

--CREATE PRIVATE WORK TABLE 
CREATE TABLE tblPrivateWork (
	[PIntersted Job Type] VARCHAR(23),
	[Governmental Budget Support] FLOAT ,
	[Expert Advice] VARCHAR(MAX) ,
	[Land Owner ID] INT CONSTRAINT tblPrivateWorkFK1 FOREIGN KEY  REFERENCES LandOwner.tblLandOwner([Land Owner ID]),
	[Managed By] VARCHAR(23) CONSTRAINT tblPrivateWorkFK2 FOREIGN KEY REFERENCES staff.tblResponsibility ([Job Title]),
	CONSTRAINT tblPrivateWorkPK PRIMARY KEY ([Land Owner ID]) )

--CREATE RPRDIRACTORATE TABLE
CREATE TABLE tblRPRDirectorate (
[RPR Directorate Name] VARCHAR(70) CONSTRAINT tblRPRDirectoratePK PRIMARY KEY ,
[Email] VARCHAR(70) UNIQUE,
[Phone Number] INT UNIQUE)


--CREATE EMPLOYEE TABLE
CREATE TABLE  tblEmployee(
	[Employee ID] INT CONSTRAINT tblEpmloyee PRIMARY KEY ,
	[First Name] VARCHAR(23),
	[Last Name] VARCHAR (23),
	[Gender] CHAR,
	[Phone Number] INT UNIQUE,
	[Photo] VARBINARY(MAX),
	[Email] VARCHAR(23) UNIQUE,
	[RPR Director Name] VARCHAR(70) CONSTRAINT tblEpmloyeeFK1 FOREIGN KEY REFERENCES staff.tblRPRDirectorate([RPR Directorate Name]),
	[Job Title] VARCHAR(23) CONSTRAINT tblEpmloyeeFK2 FOREIGN KEY REFERENCES staff.tblResponsibility ([Job Title]))


--CREATE PROJECT REQUEST TO LAND
CREATE TABLE tblProReqToLand(
	[Request ID] INT CONSTRAINT tblProReqToLandPK PRIMARY KEY  IDENTITY(1,1),
	[Urgency] VARCHAR(20),
	[Land Recoverability] VARCHAR(20),
	[Request Date] DATE ,
	[Requested Area] FLOAT ,
	[Project Duration] FLOAT ,
	[Sub Kebele] VARCHAR(23) CONSTRAINT tblProReqToLandFK1 FOREIGN KEY REFERENCES LandOwner.tblAddress([Sub Kebele]),
	[Responsed By] VARCHAR(23) CONSTRAINT tblProReqToLandFK2 FOREIGN KEY REFERENCES staff.tblresponsibility([Job Title]),
	[Project ID] INT CONSTRAINT tblProReqToLandFK3 FOREIGN KEY REFERENCES Request.tblProject([Project ID]))


--CREATE PAYMENT CHECK TABLE
CREATE TABLE tblPaymentCheck(
	[Land Owner ID] INT CONSTRAINT tblPaymentCheckFK1 FOREIGN KEY  REFERENCES LandOwner.tblLandOwner([Land Owner ID]),
	[Checked By] VARCHAR(23) CONSTRAINT tblPaymentCheckFK2 FOREIGN KEY REFERENCES staff.tblresponsibility([Job Title]),
	[Project ID] INT CONSTRAINT tblPaymentCheckFK3 FOREIGN KEY REFERENCES Request.tblProject([Project ID]),
	[Compensation Date] DATE,
	[Check Payment] VARCHAR(23),
	[Amount] FLOAT,
	CONSTRAINT tblPaymentCheckPK PRIMARY KEY ([Land Owner ID],[Project ID]) )


--CREATE NOTIFY LAND OWNER TABLE
CREATE TABLE tblNotifyLandOwner (
	[Notification Date] DATE,
	[Recieved Or Not] VARCHAR(23),
	[Notification Reason] VARCHAR(23),
	[Land Owner ID] INT CONSTRAINT tblNotifyLandOwnerFK1 FOREIGN KEY  REFERENCES LandOwner.tblLandOwner([Land Owner ID]),
	[Notified By] VARCHAR(23) CONSTRAINT tblNotifyLandOwnerFK2 FOREIGN KEY REFERENCES staff.tblresponsibility([Job Title]),
	[Project ID] INT CONSTRAINT tblNotifyLandOwnerFK3 FOREIGN KEY REFERENCES Request.tblProject([Project ID]),
	CONSTRAINT tblNotifyLandOwnerPK PRIMARY KEY ([Land Owner ID],[Notification Reason],[Project ID]) )


--CREATE MINUTE DOCUMNEENT TABLE
CREATE TABLE tblMinuteDocument(
	[Check Presense] VARCHAR (23),
	[Discussion Date] DATE,
	[Document Type] VARCHAR(32),
	[Land Owner ID] INT CONSTRAINT tblMinuteDocumentFK1 FOREIGN KEY  REFERENCES LandOwner.tblLandOwner([Land Owner ID]),
	[Held By] VARCHAR(23) CONSTRAINT tblMinuteDocumentFK2 FOREIGN KEY REFERENCES staff.tblresponsibility([Job Title]),
	[Project ID] INT CONSTRAINT tblMinuteDocumentFK3 FOREIGN KEY REFERENCES Request.tblProject([Project ID]),
	CONSTRAINT tblMinuteDocumentPK PRIMARY KEY ([Land Owner ID],[Document Type],[Project ID]))

--CREATE COUNT PROPERTY TABLE
CREATE TABLE tblCountProperties(
	[Counting Date] DATE,
	[Check Counting] VARCHAR(23),
	[Land Owner ID] INT CONSTRAINT tblCountPropertiesFK1 FOREIGN KEY  REFERENCES LandOwner.tblLandOwner([Land Owner ID]),
	[Counted By] VARCHAR(23) CONSTRAINT tblCountPropertiesFK2 FOREIGN KEY REFERENCES staff.tblresponsibility([Job Title]),
	[Project ID] INT CONSTRAINT tblCountPropertiesFK3 FOREIGN KEY REFERENCES Request.tblProject([Project ID]),
	[Representative ID] INT CONSTRAINT tblCountPropertiesFK4 FOREIGN KEY REFERENCES LandOwner.tblLandOwner([Land Owner ID]),
	CONSTRAINT tblCountPropertiesPK PRIMARY KEY ([Land Owner ID],[Project ID]) )

--CREATE ESTIMATE PRICE TABLE
CREATE TABLE tblEstimatePrice(
	[Estimation Date] DATE,
	[Check Estiamtion ] VARCHAR(23),
	[Amount] FLOAT,
	[Land Owner ID] INT CONSTRAINT tblEstimatePriceFK1 FOREIGN KEY  REFERENCES LandOwner.tblLandOwner([Land Owner ID]),
	[Estimated by] VARCHAR(23) CONSTRAINT tblEstimatePriceFK2 FOREIGN KEY REFERENCES staff.tblresponsibility([Job Title]),
	[Project ID] INT CONSTRAINT tblEstimatePriceFK3 FOREIGN KEY REFERENCES Request.tblProject([Project ID]),
	CONSTRAINT tblEstimatePricesPK PRIMARY KEY ([Land Owner ID],[Project ID]))

--CREATE TABLE PRIORITY LAND OWNERS

CREATE TABLE tblPriority(
	[City Land Area] FLOAT ,
	[Reason for City Land] VARCHAR(23),
	[Disability] VARCHAR(23),
	[Land Owner ID] INT CONSTRAINT tblPriorityFK1 FOREIGN KEY  REFERENCES LandOwner.tblLandOwner([Land Owner ID])
	CONSTRAINT tblPriorityPK PRIMARY KEY ([Land Owner ID])
)


--CREATE TEAM TABLE
CREATE TABLE tblTeam(
	[Team Name] VARCHAR(23) CONSTRAINT tblGroupWorkPK PRIMARY KEY ,
	[Number of Member] 	INT	
	 )

