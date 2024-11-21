-- Creating data base
create database project  
--- using database
use project
--- Importing file to the data base 
---- right click on database --> task--> import data
-- displying data
Select * from usedcar

-- Calculating number of rows
select count(*) from usedcar  --> number of rows = 33559
-- displying the info of columns 
select COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'usedcar'  -- 13 columns

-- displying the null valuse for each columnn
Select count(name) as name, count(price) as price, count(color) as color,
count(mileage) as mileage, count(make) as make, count(model) as model, count(city) as city,
count(Date_Displayed) as date, count(Automatic_Transmission) as Automatic_Transmission,
count(Air_Conditioner) as Air_Conditioner, count(Power_Steering) as Power_Steering,
count(Remote_Control) as Remote_Control, count(Item_URL) as URL from usedcar  ----- null values in price and mileage columns only

-- lets see the kind of data for each column
select distinct Name from usedcar -- 4158 unique name
select distinct Price from usedcar -- 829 unique value
select distinct Color from usedcar -- 24 unique color
select distinct Mileage from usedcar  -- 1085 unqiue value
select distinct Make from usedcar --101 unique 
select distinct model from usedcar --887 unique 
select distinct city from usedcar --103 unique 
select distinct Date_Displayed from usedcar --124 unique 
select distinct Automatic_Transmission from usedcar -- 2 unique 
select distinct Air_Conditioner from usedcar -- 2 unique
select distinct Power_Steering from usedcar --2 unique 
select distinct Remote_Control from usedcar --2 unique 

--- Steps I'm going to work on
-- Format 
-- null valuse 
-- outliers
-- duplication

-- First: Formatting 
-- let's remove EGP and KM from price and mileage 

update usedcar
set price = REPLACE(price,'EGP','')

update usedcar
set Mileage = REPLACE(Mileage,'Km','')

-- Let's now change the format to be decimals but let's first see if there are values can't be converted 
select price from usedcar
where price is null or ISNUMERIC(price)=0  -- we need to fill null to convert

-- Counting null values 
select count(name) from usedcar
where price is null -- 934 values are null

-- See if there is date =0 
select price from usedcar
where price = '0' -- No values
-- Filling null
update usedcar
set price = '0'
where price is null

-- Removing ,, from numbers 
update usedcar
set price = REPLACE(price,',','')

-- Let's convet into decimal
alter table usedcar
alter column price decimal(12,0)

update usedcar
set Price = null 
where Price = 0

-- Now same steps but for mileage

select Mileage from usedcar
where Mileage is null or ISNUMERIC(Mileage)=0  -- we need to fill null to convert

-- Counting null values 
select count(name) from usedcar
where Mileage is null -- 2119 values are null

-- See if there is date =0 
select Mileage from usedcar
where Mileage = '0' -- there are values
-- Filling null
update usedcar
set Mileage = '-1'
where Mileage is null

-- Removing ,, from numbers 
update usedcar
set Mileage = REPLACE(Mileage,',','')

-- Let's convet into decimal
alter table usedcar
alter column Mileage decimal(12,0)

update usedcar
set Mileage = null 
where Mileage = -1

-- Change Foramtting for 4 features of cars for yes/ no instead of 0,1 
-- First let's change their type insteat of bit to nvarchar 
Alter table usedcar 
Alter column Automatic_Transmission nvarchar(5)

update usedcar
set Automatic_Transmission = 'Yes'
where Automatic_Transmission = '1'

update usedcar
set Automatic_Transmission = 'No'
where Automatic_Transmission = '0'

select distinct Automatic_Transmission from usedcar

-- Air_Conditioner column

Alter table usedcar 
Alter column Air_Conditioner nvarchar(5)

update usedcar
set Air_Conditioner = 'Yes'
where Air_Conditioner = '1'

update usedcar
set Air_Conditioner = 'No'
where Air_Conditioner = '0'

select distinct Air_Conditioner from usedcar
-- Power_Steering 
Alter table usedcar 
Alter column Power_Steering nvarchar(5)

update usedcar
set Power_Steering = 'Yes'
where Power_Steering = '1'

update usedcar
set Power_Steering = 'No'
where Power_Steering = '0'

select distinct Power_Steering from usedcar

-- Remote_Control

Alter table usedcar 
Alter column Remote_Control nvarchar(5)

update usedcar
set Remote_Control = 'Yes'
where Remote_Control = '1'

update usedcar
set Remote_Control = 'No'
where Remote_Control = '0'

select distinct Remote_Control from usedcar

--- Adding year model table  (display the year of the model)
Alter table usedcar
add year nvarchar(10)

update usedcar
set year = right(name,4)
where year is null

select count(year) from usedcar -- no nulls

select distinct year from usedcar -- 57 unique date

select year from usedcar
where year is null or ISNUMERIC(year)=0 -- 24 0

update usedcar 
set year = '1980'
where year = '24 0'

alter table usedcar
alter column year numeric


-- Some date needs edit Like in City 
--(1)
select * from usedcar
where city = 'Rosetta' -- 15 rows only 

update usedcar
set city = 'Rashid'
where city = 'Rosetta'

---------------
-- (2) some price 

select top 6 *  from usedcar
where price is not null
order by Price  -- here we can find car 1060 and 5000 

update usedcar 
set price = 50000
where price = 5000

update usedcar 
set price = 300000
where price = 1060

-- Now let's dive into null values 

-- Displying null again with more details 

select name, color, city, Air_Conditioner, Power_Steering, Remote_Control, Automatic_Transmission,price, mileage, Date_Displayed,
count(name) as nullcount from usedcar
where price is null 
group by  name, color, city, Air_Conditioner, Power_Steering, Remote_Control, Automatic_Transmission,price, mileage,Date_Displayed
order by count(name) desc -- here we can notice that the most of null values are duplicated

-- Let's drop nulls which are duplicated
-- Drop and add 
--(1)
delete usedcar
where name = 'Chevrolet Lanos 2011' and city='Alexandria'and color='Dark red'

insert into usedcar
values('Chevrolet Lanos 2011',null,'Dark red',null,'Chevrolet','Lanos','Alexandria','2024-02-16','No','No','No','No',null,2011)
--(2)
delete usedcar
where name = 'Chery Arrizo 5 2022' and city='Nasr city'and color='Bronze'

insert into usedcar
values('Chery Arrizo 5 2022',null,'Bronze',86000,'Chery','Arrizo 5','Nasr city','2024-02-16','Yes','Yes','Yes','Yes',null,2022)

--(3)
delete usedcar
where name = 'Brilliance FRV 2009' and city='Marsa Matrouh'and color='Silver'

insert into usedcar
values('Brilliance FRV 2009',null,'Silver',null,'Brilliance','FRV','Marsa Matrouh','2024-02-16','No','Yes','No','Yes',null,2009)

--(4)
delete usedcar
where name = 'Renault Clio 2008' and city='Alexandria'and color='Red'

insert into usedcar
values('Renault Clio 2008',null,'Red',null,'Renault',' Clio','Alexandria','2024-02-16','No','No','No','No',null,2008)

---
-- Let's display again 
select name, color, city, Air_Conditioner, Power_Steering, Remote_Control, Automatic_Transmission,price, mileage, Date_Displayed,
count(name) as nullcount from usedcar
where price is null 
group by  name, color, city, Air_Conditioner, Power_Steering, Remote_Control, Automatic_Transmission,price, mileage,Date_Displayed
order by count(name) desc -- No duplicated in null values 

-- Let's join the table with it's self for price column
-- name, city, and color
select distinct a.name, b.name, a.city, b.city, a.color, b.color, a.price, b.price from usedcar a
join usedcar b on a.name = b.name and a.city = b.city and a.color =b.color and 
a.Air_Conditioner=b.Air_Conditioner and a.Power_Steering = b.Power_Steering and a.Remote_Control=b.Remote_Control and a.Automatic_Transmission=
b.Automatic_Transmission
where a.price is null and b.price is not null -- 8 rows are matching 

-- Let's update 

update a
set a.price = b.price from usedcar a 
join usedcar b on a.name = b.name and a.city = b.city and a.color =b.color and 
a.Air_Conditioner=b.Air_Conditioner and a.Power_Steering = b.Power_Steering and a.Remote_Control=b.Remote_Control and a.Automatic_Transmission=
b.Automatic_Transmission
where a.price is null and b.price is not null -- 4 rows uppdated 

-- Let's see do it again under different conditions
--name only
select distinct a.name, b.name, a.city, b.city, a.color, b.color, a.price, b.price from usedcar a
join usedcar b on a.name = b.name and a.Air_Conditioner=b.Air_Conditioner and a.Power_Steering = b.Power_Steering and a.Remote_Control=b.Remote_Control and a.Automatic_Transmission=
b.Automatic_Transmission
where a.price is null and b.price is not null -- 877 rows are matching 

update a
set a.price = b.price from usedcar a 
join usedcar b on a.name = b.name and 
a.Air_Conditioner=b.Air_Conditioner and a.Power_Steering = b.Power_Steering and a.Remote_Control=b.Remote_Control and a.Automatic_Transmission=
b.Automatic_Transmission
where a.price is null and b.price is not null -- 48 rows affected

-- Displying null values again

select name, color, city, Air_Conditioner, Power_Steering, Remote_Control, Automatic_Transmission,price, mileage,
count(name) as nullcount from usedcar
where price is null 
group by  name, color, city, Air_Conditioner, Power_Steering, Remote_Control, Automatic_Transmission,price, mileage
order by count(name) desc -- Remaingin 19 nulls values only 

-- Let's drop null

delete usedcar
where price is null



-- let's do the same with mileage 

-- Displying null again with more details 

select name, color, city, Air_Conditioner, Power_Steering, Remote_Control, Automatic_Transmission,price, mileage, Date_Displayed,
count(name) as nullcount from usedcar
where Mileage is null 
group by  name, color, city, Air_Conditioner, Power_Steering, Remote_Control, Automatic_Transmission,price, mileage,Date_Displayed
order by count(name) desc -- let's drop duplicated vlues 

-- drop and add
--(1)
delete usedcar
where name = 'Skoda Kodiaq 2023' and city='Tagamo3 - New Cairo'and color='Dark grey'

insert into usedcar
values('Skoda Kodiaq 2023',3000000,'Dark grey',null,'Skoda','Kodiaq','Tagamo3 - New Cairo','2024-02-16','Yes','Yes','Yes','Yes',null,2023)
--(2)
delete usedcar
where name = 'Chery Arrizo 5 2020' and city='El Haram'and color='White'

insert into usedcar
values('Chery Arrizo 5 2020',560000,'White',null,'Chery','Arrizo 5','El Haram','2024-02-16','Yes','Yes','Yes','Yes',null,2020)

-- Displying null again 

select name, color, city, Air_Conditioner, Power_Steering, Remote_Control, Automatic_Transmission,price, mileage, Date_Displayed,
count(name) as nullcount from usedcar
where Mileage is null 
group by  name, color, city, Air_Conditioner, Power_Steering, Remote_Control, Automatic_Transmission,price, mileage,Date_Displayed
order by count(name) desc 

-- Let's join the table with it's self for mileage column
-- name, price, color, and city
select distinct a.name, b.name, a.city, b.city, a.color, b.color, a.price, b.price,a.mileage,b.mileage from usedcar a
join usedcar b on a.name = b.name and a.city = b.city and a.color =b.color and a.price = b.price and
a.Air_Conditioner=b.Air_Conditioner and a.Power_Steering = b.Power_Steering and a.Remote_Control=b.Remote_Control and a.Automatic_Transmission=
b.Automatic_Transmission
where a.Mileage is null and b.Mileage is not null  -- 9 unique rows

--Let's update 

update a
set a.mileage =b.mileage from usedcar a
join usedcar b on a.name = b.name and a.city = b.city and a.color =b.color and a.price = b.price and
a.Air_Conditioner=b.Air_Conditioner and a.Power_Steering = b.Power_Steering and a.Remote_Control=b.Remote_Control and a.Automatic_Transmission=
b.Automatic_Transmission
where a.Mileage is null and b.Mileage is not null  -- 9 rows affected

-- let's join under different conditions
--name, city, and price

select distinct a.name, b.name, a.city, b.city, a.color, b.color, a.price, b.price,a.mileage,b.mileage from usedcar a
join usedcar b on a.name = b.name  and a.price = b.price and a.city=b.city and
a.Air_Conditioner=b.Air_Conditioner and a.Power_Steering = b.Power_Steering and a.Remote_Control=b.Remote_Control and a.Automatic_Transmission=
b.Automatic_Transmission
where a.Mileage is null and b.Mileage is not null -- 11 values

update a
set a.mileage =b.mileage from usedcar a
join usedcar b on a.name = b.name and a.city = b.city and a.price = b.price and
a.Air_Conditioner=b.Air_Conditioner and a.Power_Steering = b.Power_Steering and a.Remote_Control=b.Remote_Control and a.Automatic_Transmission=
b.Automatic_Transmission
where a.Mileage is null and b.Mileage is not null -- 11 rows affect

--- under differenct conditions
-- name and price

select distinct a.name, b.name, a.city, b.city, a.color, b.color, a.price, b.price,a.mileage,b.mileage from usedcar a
join usedcar b on a.name = b.name  and a.price = b.price and
a.Air_Conditioner=b.Air_Conditioner and a.Power_Steering = b.Power_Steering and a.Remote_Control=b.Remote_Control and a.Automatic_Transmission=
b.Automatic_Transmission
where a.Mileage is null and b.Mileage  is not null  -- 161 values

update a
set a.mileage =b.mileage from usedcar a
join usedcar b on a.name = b.name and a.price = b.price and
a.Air_Conditioner=b.Air_Conditioner and a.Power_Steering = b.Power_Steering and a.Remote_Control=b.Remote_Control and a.Automatic_Transmission=
b.Automatic_Transmission
where a.Mileage is null and b.Mileage is not null --120 rows affected

-- Displying null again 

select name, color, city, Air_Conditioner, Power_Steering, Remote_Control, Automatic_Transmission,price, mileage, Date_Displayed,
count(name) as nullcount from usedcar
where Mileage is null 
group by  name, color, city, Air_Conditioner, Power_Steering, Remote_Control, Automatic_Transmission,price, mileage,Date_Displayed
order by count(name) desc --1071 nulls remaining 

--Let's fill mileage with median 

update usedcar
set Mileage = (SELECT distinct PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Mileage) OVER () AS median FROM usedcar)
where Mileage is null -- Now no nulls here 

-----------------------------------------------------------------------------------------------
-- let's drop outliers (for price)
SELECt * from usedcar
order by price desc

--Let's drop data more than 10 M

delete usedcar
where price > 10000000 -- 20 rows only

SELECt * from usedcar
order by price -- price are close to each other so no needed for dropping


-- let's drop outliers (for mileage)

SELECt * from usedcar
order by Mileage desc --Let's drop more than 600k

delete usedcar
where Mileage > 600000 -- 288 rows 

SELECt * from usedcar
order by Mileage -- let's drop less than 500

delete usedcar
where Mileage <500 --1242 rows

-----------------------------------------------
-- Now unique date 
select distinct * into uniquecar from usedcar  -- 21632 rows 


select count(*) from usedcar

SELECT Name, count(Name) OVER (PARTITION BY Name) AS duplicated
FROM usedcar

select count(*) from uniquecar
select count(*)  from usedcar