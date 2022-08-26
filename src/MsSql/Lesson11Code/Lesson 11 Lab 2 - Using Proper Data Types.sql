/****Lesson 11 Lab***********/
/****Determining Proper Data Types for Given Data Elements or Table Columns*****/
USE AdventureWorks2016CTP3
GO

/*
>>>>>>>>>>>>>>>>>>Using SEQUENCE>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
A Sequence is preferred over an Identity property when:
A number needed before data inserted into the table
Single series of numbers needs to be shared between multiple tables or multiple columns within a table.
Series needs to be recycled when a specified number is reached
*/
CREATE SEQUENCE CountBy5
   AS tinyint
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 5
    CYCLE ;
GO

SELECT NEXT VALUE FOR CountBy5 AS SurveyGroup, Name FROM sys.objects ;
GO

/*
>>>>>>>>>>>>>>>>>>>Creating a SEQUENCE used in a table>>>>>>>>>>
*/
USE AdventureWorks2016CTP3
GO

--Create the Cert schema
CREATE SCHEMA Examples;
GO

-- Create a table
CREATE TABLE Examples.Orders
    (OrderID int PRIMARY KEY,
    Name varchar(20) NOT NULL,
    Qty int NOT NULL);
GO

-- Create a sequence
CREATE SEQUENCE Examples.CountBy1
    START WITH 1
    INCREMENT BY 1 ;
GO

-- Insert three records
INSERT Examples.Orders (OrderID, Name, Qty)
    VALUES (NEXT VALUE FOR Cert.CountBy1, 'pineapple', 2) ;
INSERT Examples.Orders (OrderID, Name, Qty)
    VALUES (NEXT VALUE FOR Cert.CountBy1, 'banana', 6) ;
INSERT Examples.Orders (OrderID, Name, Qty)
    VALUES (NEXT VALUE FOR Cert.CountBy1, 'orange', 12) ;
GO

-- View the table
SELECT * FROM Examples.Orders ;
GO

--CLEANUP--
--Drop table Orders and drop schema Cert --
DROP TABLE IF EXISTS Examples.Orders;
GO
DROP SEQUENCE IF EXISTS Examples.CountBy1
GO
--DROP SCHEMA IF EXISTS Examples
--GO
-----------------------------------------------------------------
----------------------------------------------------------------
-- Creating a table using NEWID as the default value -----------
-- for the uniqueidentifier data type --------------------------
DROP TABLE IF EXISTS Examples.Customers;
GO

CREATE TABLE Examples.Customers
(
 CustomerID uniqueidentifier NOT NULL
   DEFAULT NEWID(),
 Company varchar(30) NOT NULL,
 ContactName varchar(60) NOT NULL, 
 CountryRegion varchar(20) NOT NULL, 
);
GO

--------------------------------------------------------------------------
--Assign the default value of NEWID() to each new and existing row -------
--This ensures a unique value for the CustomerID column ------------------
INSERT INTO Examples.Customers (CustomerID,Company,ContactName,CountryRegion)
     VALUES
           (NEWID(), N'SQL Studios',N'Mickey', N'CA'),
		   (NEWID(), N'SQL Studios', N'Minnie', N'PA'),
		   (NEWID(), N'SQL Management', N'Donald', N'UK'),
		   (NEWID(), N'SQL Studios', N'Daisy', N'UK'),
		   (NEWID(), N'SQL Management', N'Grumpy', N'WA'),
		   (NEWID(), N'SQL Studios', N'Happy', N'PA'),
		   (NEWID(), N'SQL Management', N'Dopey', N'WA');
GO

SELECT *
FROM Examples.Customers;
GO

DROP TABLE IF EXISTS Examples.Customers;
GO

-----------------------------------------------------------------------------------
--Using Tempdb, create a table using sequential GUID and nonsequential GUID columns
------------------------------------------------------------------------------------
--Create Unique GUIDs by Using NewSequentialId() and NewId()

USE tempdb
go

---------------------------------------------------------------
--Create table for testing GUID and Identitiy column creation--
--using Identity, NEWSEQUENTIALID(), NEWID()-------------------
---------------------------------------------------------------
DROP TABLE IF EXISTS tempdb.dbo.GUIDTESTING;
GO

CREATE TABLE GUIDTESTING
(
RowNumber			int identity
,NewSequentialIDCol uniqueidentifier DEFAULT NEWSEQUENTIALID()
,NewIdCol			uniqueidentifier DEFAULT NEWID()
);
GO

--------------------------------------------------------------------
-- Insert 5 rows into the GUIDETESTING table using DEFAULT values --
-- as specified by the column datatype ----------------------------- 
DECLARE @RowCount int
SET @RowCount = 0
WHILE @RowCount < 5
BEGIN
	INSERT INTO GUIDTESTING DEFAULT VALUES
	SET @RowCount = @RowCount +1
END;
GO

-- Return the rows sorted by NewSequentialIDCol--
--Notice this sort follows the identity ---------
SELECT * FROM GUIDTESTING ORDER BY NewSequentialIDCol;
GO

-----------------------------------------------
-- Return the rows sorted by NewIDCol----------
SELECT * FROM GUIDTESTING ORDER BY NewIDCol;
GO

DROP TABLE IF EXISTS tempdb.dbo.GUIDTESTING;
GO
/*****************************************************/
/*  Use Data Types for  Dates */
----------------------------------------------------
--Querying Date and Time ---------------------------
--Know if source data includes time and if time
--other than midnight has been entered
--Otherwise queries will not resolve correctly
----------------------------------------------------

USE AdventureWorks2016CTP3
GO

--Query orderdate from Sales.SalesOrderHeader------
SELECT SalesOrderID, OrderDate
FROM Sales.SalesOrderHeader;
GO

SELECT SalesOrderID, OrderDate
FROM Sales.SalesOrderHeader
WHERE OrderDate = '20140210';
GO

--------------------------------------------------------
---Create table Sales.SalesOrderDateTest and fill with data
-----------------------------------------------------------

 
DROP TABLE IF EXISTS Examples.SalesOrderDateTest;
GO

SELECT SalesOrderID, OrderDate
INTO Examples.SalesOrderDateTest
FROM Sales.SalesOrderHeader
WHERE SalesOrderID >= 66079 and SalesOrderID < 66153
GO

SELECT * 
FROM Examples.SalesOrderDateTest;
GO

-----------------------------------------------------------
--Add data with dates that have a time value also---------
-----------------------------------------------------------

SET IDENTITY_INSERT Examples.SalesOrderDateTest  ON;

INSERT INTO Examples.SalesOrderDateTest(SalesOrderID, OrderDate)
VALUES (50001, '2014-02-10 00:35'),
(50002, '2014-02-10 11:30'),
(50003, '2014-02-10 12:45');
GO

SET IDENTITY_INSERT Examples.SalesOrderDateTest  OFF;


--Query the table-------------------------------------
--for all inserted orders-----------------------------
-------------------------------------------------------
SELECT SalesOrderID, OrderDate
FROM Examples.SalesOrderDateTest;
GO

----Query for a date which also has timed data-----------
----Not all values are returned--------------------------
SELECT SalesOrderID, OrderDate
FROM Examples.SalesOrderDateTest
WHERE OrderDate = '20140210'
ORDER BY SalesOrderID;
GO

---Need to change the query to account for time past midnight
-------------------------------------------------------------
SELECT SalesOrderID, OrderDate
FROM Examples.SalesOrderDateTest
WHERE OrderDate >= '20140210' AND OrderDate < '20140211'
ORDER BY SalesOrderID;
GO

-----------------------------------------------------------
---------Using DATEADD function to add 2 days to OrderDate
-----------------------------------------------------------

SELECT SalesOrderID
    ,OrderDate 
    ,DATEADD(day,2,OrderDate) AS PromisedShipDate
FROM Examples.SalesOrderDateTest
ORDER BY SalesOrderID;;
GO

------------------------------------------------------------------
---------Using EOMONTH function to OrderDate to create billing date
-------------------------------------------------------------------

SELECT SalesOrderID
    ,OrderDate 
    ,EOMONTH(OrderDate) AS BillingDate
FROM Examples.SalesOrderDateTest
ORDER BY SalesOrderID;;
GO

---------------------------------------------------------------
---------Using DATEFROMPARTS function--------------------------
---------to create date from its parts-------------------------
---------------------------------------------------------------
SELECT DATEFROMPARTS ( 2014, 04, 01 ) AS Result;


/*-----------------------------------------------------------
---------Cleanup -DROP Table Sales.SalesOrderDateTest--------

-------------------------------------------------------------  
*/
DROP TABLE IF EXISTS Examples.SalesOrderDateTest;
GO

--------------------------------------------------------------
/*************************************************************/
---Using GEOGRAPHY Data Type----------------------------------
----with .Lat and .Long methods--------------------------------
/*************************************************************/
USE WideWorldImporters
GO

SELECT CityName, StateProvinceID, Location, Location.Lat AS Latitude, Location.Long AS Longitude
FROM Application.Cities;

USE WideWorldImporters
GO

SELECT CityName, Location.Lat AS Latitude, Location.Long AS Longitude
FROM Application.Cities
WHERE CityName = 'Seattle' AND StateProvinceID = 50;

