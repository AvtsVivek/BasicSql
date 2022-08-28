/***Lesson 3 Lab 4***/
/***Using Built-In Functions in Queries ***/

USE WideWorldImporters;
GO

--Aggregating Price
SELECT 
	-- CustomerCategoryID,
	AVG(CreditLimit) AS 'Average Credit Limit'
FROM Sales.Customers
-- GROUP BY CustomerCategoryID
ORDER BY 'Average Credit Limit'

--Aggregating Price
SELECT CustomerCategoryID
      ,AVG(CreditLimit) AS 'Average Credit Limit'
FROM Sales.Customers
GROUP BY CustomerCategoryID
ORDER BY CustomerCategoryID;

--Aggregating Quantities
SELECT OrderID
      ,SUM(Quantity) AS 'Total Orders'
FROM Sales.OrderLines
GROUP BY OrderID
ORDER BY OrderID;

--Aggregating Expressions
SELECT MIN(CustomerName) AS 'First Customer Name'
      ,MAX( CustomerName) AS 'Last Customer Name'
FROM Sales.Customers;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-->>>>LESSON 3.8 Using Arithmetic, Date-Related, and System Functions>>>>>
USE WideWorldImporters;
GO

--Logical Functions
--Simple CHOOSE() Function Sample
SELECT CHOOSE ( 2, 'Mickey', 'Minnie', 'Donald', 'Daisy' ) AS Result;

--Simple IIF() Function Sample
DECLARE @first int = 6, @second int = 1;
SELECT IIF ( @first > @second, 'TRUE', 'FALSE' ) AS Result;


--Conversion Functions
--Simple CAST
SELECT
GETDATE() AS UnconvertedDateTime,
CAST(GETDATE() AS nvarchar(30)) AS UsingCast;

--Example
--Querying for Vehicle Temperatures taken on RecordedWhen date of April 25, 2016
--RecordedWhen is datatype Datetime2 which includes date and time
SELECT VehicleTemperatureID, RecordedWhen, CAST(RecordedWhen AS date) AS 'date'
FROM Warehouse.VehicleTemperatures
WHERE CAST(RecordedWhen AS date) = '20160425'; --Redefine RecordedWhen datatype as date

--Simple CONVERT
SELECT
GETDATE() AS UnconvertedDateTime,
CONVERT(nvarchar(30), GETDATE(), 126) AS UsingConvertTo_ISO8601Standard, 
CONVERT(nvarchar(30), GETDATE(), 110) AS UsingConvertTo_US_Standard;
GO


--Simple PARSE
-- Changing into Datetime2
SELECT PARSE('Saturday, 15 April 2017' AS datetime2 USING 'en-US') AS Result;

--TRY_CAST
--FAILS and returns NULL--not correct format
SET DATEFORMAT dmy;
SELECT TRY_CAST('12/31/2016' AS datetime2) AS Result;

--SUCCEEDS and returns requested data type
SET DATEFORMAT mdy;
SELECT TRY_CAST('12/31/2016' AS datetime2) AS Result;

SELECT
GETDATE() AS UnconvertedDateTime,
CAST(GETDATE() AS nvarchar(30)) AS UsingCast,
CONVERT(nvarchar(30), GETDATE(), 126) AS UsingConvertTo_ISO8601Standard, 
CONVERT(nvarchar(30), GETDATE(), 110) AS UsingConvertTo_US_Standard;
GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--SYSTEM FUNCTIONS 

USE WideWorldImporters;
GO

--Arithmetic Operators--------------------------------------------
SELECT 10 + 4*5 - 8;

SELECT 10 + 4*5 - 8/2;

SELECT (10 + 4*5 - 8)/2;

--(ISNULL)
SELECT StockItemName, ISNULL(Size, 'N/A') AS 'Item Size'
FROM Warehouse.StockItems;

--(ISNUMERIC)
SELECT SupplierName,PostalCityID
FROM Purchasing.Suppliers
WHERE ISNUMERIC(PostalCityID) <>0

--No Results - DeliveryPostalCode is nvarchar---------
SELECT SupplierName,DeliveryPostalCode
FROM Purchasing.Suppliers
WHERE ISNUMERIC(DeliveryPostalCode) <>1;

--NEWID()
SELECT NEWID() AS TestGUID;

--@@ROWCOUNT------------------------------------------------------------------
---
DECLARE @empid AS INT = 10;

SELECT empid, name
FROM Examples.Employees
WHERE empid = @empid;

IF @@ROWCOUNT = 0
  PRINT CONCAT('Employee ', CAST(@empid AS VARCHAR(10)), ' is not in the database');
GO

-----------------------------------------------------------
DECLARE @empid AS INT = 5;

SELECT empid, name
FROM Examples.Employees
WHERE empid = @empid;

IF @@ROWCOUNT = 0
  PRINT CONCAT('Employee ', CAST(@empid AS VARCHAR(10)), ' is not in the database');
GO

-----------------------------------------------------------

