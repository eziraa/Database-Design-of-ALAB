-- create login for system admistrator
CREATE LOGIN Ezira WITH PASSWORD  = '12345'
CREATE USER Ezira FOR LOGIN Ezira

-- Creating login for Notifier
CREATE LOGIN Hewan WITH PASSWORD  = '12345'
CREATE USER Hewan FOR LOGIN Hewan

CREATE LOGIN Tamirat WITH PASSWORD  = '12345'
CREATE USER Tamirat FOR LOGIN Tamirat


CREATE LOGIN Dawud WITH PASSWORD = '12345'
CREATE USER Dawud FOR LOGIN Dawud

CREATE LOGIN Afework WITH PASSWORD = '12345'
CREATE USER Afework FOR LOGIN Afework


CREATE LOGIN Dawit WITH PASSWORD = '12345'
CREATE USER Dawit FOR LOGIN Dawit

CREATE LOGIN Eyob WITH PASSWORD = '12345'
CREATE USER Eyob FOR LOGIN Eyob

CREATE LOGIN Feleke WITH PASSWORD = '12345'
CREATE USER Feleke FOR LOGIN Feleke

CREATE LOGIN Girma WITH PASSWORD = '12345'
CREATE USER Girma FOR LOGIN Girma

CREATE LOGIN Nardos WITH PASSWORD = '12345'
CREATE USER Nardos FOR LOGIN Nardos


CREATE LOGIN Kefyalew WITH PASSWORD = '12345'
CREATE USER Kefyalew FOR LOGIN Kefyalew


-- CREATING ROLES

-- Creating role for Project manager
CREATE ROLE systemAdmins
sp_addrolemember systemAdmins, Ezira

-- Creating role for Project manager
CREATE ROLE projectManagers
	sp_addrolemember projectManagers, Afework

-- Creating role for Land Owner
CREATE ROLE landOwners
	sp_addrolemember landOwners, Girma
	sp_addrolemember landOwners, Dawit


-- Creating role for Notifier
CREATE ROLE notifiers
sp_addrolemember notifiers, Girma


-- Creating role for Minute Document Holder
CREATE ROLE minDocHolders
sp_addrolemember minDocHolders, Nardos


-- Creating role for Property Counter
CREATE ROLE propCounters
sp_addrolemember propCounters, Tamirat



-- Creating role for Estimator
CREATE ROLE estimators
sp_addrolemember estimators, Kefyalew



-- Creating role for Rehabilitator
CREATE ROLE rehabilitators
sp_addrolemember rehabilitators, Dawud


-- Creating role for Payment checker
CREATE ROLE payCheckers
sp_addrolemember payCheckers, payChecker

