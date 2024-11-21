-- Creating data base
create database relationship
--- using database
use relationship
--- Importing file to the data base 

select * from usedcar
----------------
-- Relationship
-- Let's divide into tables 
-- make table (done)
--- model table (done)
-- date table (done)
-- feature tables (done) and the bridge is done 
--- finalusedcar table 
-- City table  (done)
-- Color table (done)


---------------------
-- color table 
select distinct color
into Colortable from  usedcar

Alter table Colortable
Add colorid int identity(1,1) primary key 
-- Dsiplying 
select * from Colortable

--- Same like colory will do for make and city 
-- citytble

select distinct city into
citytable from  usedcar

Alter table citytable
Add cityid int identity(1,1) primary key 
-- Dsiplying 
select * from citytable


-- make
select distinct make into 
maketable from  usedcar

Alter table maketable 
Add makeid
int identity(1,1) primary key 
-- Dsiplying 
select * from maketable	

----- now for model

Create table modeltable (
modelid int identity(1,1) primary key, 
modelname nvarchar(50) not null,
makeid int, foreign key (makeid) references maketable(makeid) )

select * from modeltable

-- now let's fill
insert into modeltable (makeid,modelname)
select distinct
maketable.makeid , usedcar.Model from usedcar join maketable
on usedcar.make = maketable.make

select * from modeltable


CREATE TABLE finalusedcar ( carId INT PRIMARY KEY IDENTITY(1, 1),name nvarchar(50), MakeID INT, ModelID INT, ColorID INT,CityID INT,
    year numeric, Date date, Price DECIMAL, Mileage DECIMAL,Automatic_Transmission nvarchar(5), Air_Conditioner nvarchar(5), 
	Power_Steering nvarchar(5) , Remote_Control nvarchar(5),
    FOREIGN KEY (MakeID) REFERENCES Maketable(MakeID),
    FOREIGN KEY (ModelID) REFERENCES Modeltable(ModelID),
    FOREIGN KEY (ColorID) REFERENCES Colortable(ColorID),
    FOREIGN KEY (CityID) REFERENCES Citytable(CityID)

);

INSERT INTO Finalusedcar (name,
MakeID, ModelID, ColorID, CityID, Date, Price, Mileage, Year, Automatic_Transmission, Air_Conditioner, 
	Power_Steering , Remote_Control)
SELECT usedcar.name,maketable.MakeID, modeltable.ModelID, Colortable.ColorID, citytable.CityID,  usedcar.Date_Displayed,
    usedcar.Price, usedcar.Mileage, usedcar.Year, usedcar.Automatic_Transmission, usedcar.Air_Conditioner, 
	usedcar.Power_Steering,usedcar.Remote_Control
FROM usedcar JOIN maketable ON usedcar.Make = maketable.Make
JOIN modeltable ON modeltable.ModelName = usedcar.Model AND maketable.MakeID = modeltable.MakeID
JOIN Colortable ON usedcar.Color = Colortable.Color
JOIN citytable ON usedcar.City = citytable.city

select * from finalusedcar