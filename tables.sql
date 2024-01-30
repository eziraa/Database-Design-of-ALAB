
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


