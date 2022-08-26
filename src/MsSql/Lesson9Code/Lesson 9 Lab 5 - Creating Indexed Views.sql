/****Lesson 9 Lab***********/
/****Creating Indexed Views*****/

USE AdventureWorks2016CTP3;
GO
--Set the options to support indexed views.
SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
    QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO

-----CREATING AN INDEXED VIEW IN ADVENTUREWROKS2016CTP3----
--Create view with schemabinding.



DROP VIEW IF EXISTS Sales.vOrders ;
GO

-->>>Find the revenue per product per order date<<<<<<<<<<--------
CREATE OR ALTER VIEW Sales.vOrders
WITH SCHEMABINDING
AS
    SELECT SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS Revenue,
        OrderDate, ProductID, COUNT_BIG(*) AS COUNT
    FROM Sales.SalesOrderDetail AS OD, Sales.SalesOrderHeader AS SOH
    WHERE OD.SalesOrderID = SOH.SalesOrderID
    GROUP BY OrderDate, ProductID;
GO
--Create an index on the view.
CREATE UNIQUE CLUSTERED INDEX IDX_V1 
    ON Sales.vOrders (OrderDate, ProductID);
GO

--This query uses the above indexed view - Sales.vOrders-----------------------
--Use Ctrl-M to set Actual Execution Plan ON-----------------------------------

SELECT *
FROM Sales.vOrders

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

USE AdventureWorks2016CTP3 ;
GO

--Set the options to support indexed views.
SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
    QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO


DROP VIEW IF EXISTS HumanResources.vEmployeeHireDate;
GO

CREATE OR ALTER VIEW HumanResources.vEmployeeHireDate
	WITH SCHEMABINDING
AS
SELECT p.FirstName, p.LastName, emp.HireDate
	FROM HumanResources.Employee AS emp
	 JOIN Person.Person AS  p
	ON emp.BusinessEntityID = p.BusinessEntityID;
GO

--Create an index on the view.
CREATE UNIQUE CLUSTERED INDEX IDX_V2 
    ON  HumanResources.vEmployeeHireDate (Hiredate, LastName);
GO

--This query uses the above indexed view - HumanResources.vEmployeeHireDate-----------------------
--Use Ctrl-M to set Actual Execution Plan ON-----------------------------------

SELECT *
FROM HumanResources.vEmployeeHireDate

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
