
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
