/****Lesson 11 Lab***********/
/****Using ISNULL and COALESCE*****/

USE AdventureWorks2016CTP3;
GO

----------------------CASE expression-------------------
USE AdventureWorks2016CTP3;
GO
---- Simple form of CASE expression --
---- Use SalariedFlag to designate employment status --
SELECT BusinessEntityID,LoginID,SalariedFlag,
CASE SalariedFlag
	WHEN 0 THEN 'Contractor'
	WHEN 1 THEN 'Employee'
	ELSE 'Trainee'
END AS 'Employment Status'
FROM HumanResources.Employee;
GO

--USE AdventureWorks2016CTP3;
--GO
---- Searched form of CASE expression --
----Defining the Shipmethod fro the difference of the due date and ship date
--SELECT SalesOrderID, OrderDate, DueDate, ShipDate,
--  CASE
--   WHEN DATEDIFF(day, ShipDate, DueDate) < 3 then 'Expedite'
--   WHEN DATEDIFF(day, ShipDate,DueDate) < 7 then 'Express'
--   ELSE 'Standard'
--  END AS ShipMethod
--FROM Sales.SalesOrderHeader;
--GO


----------------------------ISNULL--------------------------------------------------

USE AdventureWorks2016CTP3;
GO
-- USE ISNULL - Replace the NULL in MaxQty column query results with 0.00 --
-- Data type is the argument of the first input--------
SELECT Description, MinQty AS 'Min Quantity', MaxQty, ISNULL(MaxQty, 0.00) AS 'Max Quantity'
FROM Sales.SpecialOffer;
GO

USE AdventureWorks2016CTP3;
GO
SELECT ProductID, Name, ProductNumber, Size AS 'Product Size'
FROM Production.Product;
GO

USE AdventureWorks2016CTP3;
GO
--USE ISNULL - Replace the NULL in Size column in query results with N/A --
-- Data type is the argument of the first input--------
SELECT ProductID, Name, ProductNumber, ISNULL(Size, N'N/A') AS 'Product Size'
FROM Production.Product;
GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>--
----------Using ISNULL------------------------------------------------
USE AdventureWorks2016CTP3;
GO

----Original Query-----------------------------
SELECT Description, MinQty, MaxQty AS 'Max Quantity'
FROM Sales.SpecialOffer;
GO

SELECT Description, MinQty, ISNULL(MaxQty, 0.00) AS 'Max Quantity'
FROM Sales.SpecialOffer;
GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>--
----------Using COALESCE-----------------------------------------------
------------------COALESCE----------------------------

USE AdventureWorks2016CTP3;
GO
--Original Query --
SELECT Name, Class, Color, ProductNumber
FROM Production.Product;
GO

USE AdventureWorks2016CTP3
GO
--USE COALESCE function --
--Returns first non-NULL value in set --
--Data type is the argument with the highest data type precedence --
SELECT Name, Class, Color, ProductNumber,
COALESCE(Class, Color, ProductNumber) AS FirstNotNull
FROM Production.Product;
GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>--
----------NOTE:  More Complex COALESCE Example---------------------------
/*
In the following example, the wages table includes three columns
that contain information about the yearly wages of the employees: 
the hourly wage, salary, and commission. 
However, an employee receives only one type of pay. 
To determine the total amount paid to all employees, 
use COALESCE to receive only the nonnull value 
found in hourly_wage, salary, and commission. 
*/

SET NOCOUNT ON;
GO
USE tempdb;
DROP TABLE IF EXISTS dbo.wages;
GO

CREATE TABLE dbo.wages
(
    emp_id        tinyint   identity,
    hourly_wage   decimal   NULL,
    salary        decimal   NULL,
    commission    decimal   NULL,
    num_sales     tinyint   NULL
);
GO
INSERT dbo.wages (hourly_wage, salary, commission, num_sales)
VALUES
    (10.00, NULL, NULL, NULL),
    (20.00, NULL, NULL, NULL),
    (30.00, NULL, NULL, NULL),
    (40.00, NULL, NULL, NULL),
    (NULL, 10000.00, NULL, NULL),
    (NULL, 20000.00, NULL, NULL),
    (NULL, 30000.00, NULL, NULL),
    (NULL, 40000.00, NULL, NULL),
    (NULL, NULL, 15000, 3),
    (NULL, NULL, 25000, 2),
    (NULL, NULL, 20000, 6),
    (NULL, NULL, 14000, 4);
GO
SET NOCOUNT OFF;
GO
SELECT CAST(COALESCE(hourly_wage * 40 * 52, 
   salary, 
   commission * num_sales) AS money) AS 'Total Salary' 
FROM dbo.wages
--ORDER BY 'Total Salary';
GO

------Drop wages table----------------------------------
USE tempdb;
DROP TABLE IF EXISTS dbo.wages;
GO
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>--

