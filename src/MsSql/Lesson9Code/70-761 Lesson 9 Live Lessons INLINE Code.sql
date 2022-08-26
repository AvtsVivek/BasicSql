/* 70-761 Lesson 9 Live Lessons INLINE Code */

/*****LESSON 9.1*****/
/**Creating Stored Procedures, Table-Valued and Scalar-Valued User-Defined Functions, and Views**/

USE WideWorldImporters
GO

DROP PROCEDURE IF EXISTS Purchasing.uspGetAirFreightSuppliers;
GO

CREATE OR ALTER PROCEDURE Purchasing.uspGetAirFreightSuppliers
AS
    SELECT SupplierName, PhoneNumber, WebsiteURL
    FROM Purchasing.Suppliers
	WHERE DeliveryMethodID IN (8, 10);
GO

-->>>>>>Invoke the Procedure<<<<<<<-----------------
EXECUTE Purchasing.uspGetAirFreightSuppliers;
GO



-->>>>>>Return procedure definition<<<<<<------------ 
SELECT *
FROM sys.sql_modules;

-->>>>>>Return procedure definition<<<<<<------------ 
--Set results to text--------------------------------
--NOTE: Object id may differ when you execute the code
--Select an object id from the preceding query--------
SELECT object_id, Definition
FROM sys.sql_modules
WHERE object_id = 535672956; 


---------------------------------------------------------------
USE WideWorldImporters;
GO

DROP FUNCTION IF EXISTS dbo.ufnTotalCustTransExcludingTax;
GO

-->>>>CREATE User-Defined Scalar-Valued Function<<<<-----------------------------

CREATE FUNCTION dbo.ufnTotalCustTransExcludingTax    -- function name
(@TransactionDate datetime)                   -- input parameter name and data type
RETURNS decimal                               -- return parameter data type
 AS
 BEGIN                                        -- begin body definition
	DECLARE @ret decimal;
	SELECT @ret = SUM(ct.AmountExcludingTax)
	FROM Sales.CustomerTransactions AS ct
	WHERE ct.TransactionDate = @TransactionDate;
	RETURN @ret;                              -- action performed
END;
GO

--Total amount in sales for a given day-------------------------------------------
SELECT DISTINCT TransactionDate,dbo.ufnTotalCustTransExcludingTax(TransactionDate) AS 'Total Daily Amount Sold'
FROM Sales.CustomerTransactions
WHERE TransactionDate = '2013-01-03';
GO

------------------------------------------------------------------------
/***Implementing Queries Using Table-Valued Functions ***/

USE WideWorldImporters;
GO

-->>>>CREATE User-Defined Table-Valued Function<<<<-----------------------------

DROP FUNCTION IF EXISTS dbo.ufnGetFilteredTransactions;
GO

CREATE FUNCTION dbo.ufnGetFilteredTransactions
(
  @minamt AS Decimal,
  @maxamt AS Decimal
 )
RETURNS @returntable TABLE 
(
	CustomerID  INT
	,CustomerTransactionID INT
	,InvoiceID INT
	,TransactionAmount  Decimal
)
AS
BEGIN
  INSERT @returntable
	SELECT CustomerID, CustomerTransactionID, InvoiceID, TransactionAmount
	FROM Sales.CustomerTransactions
	WHERE TransactionAmount BETWEEN @minamt AND @maxamt
  RETURN
END;
GO

-->>>>Implementing the Table-Valued Function<<<<--------------------
SELECT CustomerID, CustomerTransactionID, InvoiceID, TransactionAmount AS 'Transaction Amount'
FROM dbo.ufnGetFilteredTransactions (20000.00,20100.00)
ORDER BY CustomerID, [Transaction Amount];

-------------------------------------------------------------
-------------------------------------------------------------
--USE AdventureWorks2016CTP3 ;
--GO

--CREATE VIEW HumanResources.vEmployeeHireDate
--	WITH SCHEMABINDING
--AS
--SELECT p.FirstName, p.LastName, emp.HireDate
--	FROM HumanResources.Employee AS emp
--	 JOIN Person.Person AS  p
--	ON emp.BusinessEntityID = p.BusinessEntityID;
--GO

--SELECT *
--	FROM HumanResources.vEmployeeHireDate;
--GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Create View-------------------------------------------

USE WideWorldImporters;
GO

DROP VIEW IF EXISTS vMideastSalesTerritory;
GO
--Create view to display cities and states in the 
--Mideast Sales Territory

CREATE OR ALTER VIEW Application.vMideastSalesTerritory
	WITH SCHEMABINDING
AS
SELECT C.CityName, P.StateProvinceName
FROM Application.StateProvinces AS P
JOIN Application.Cities AS C
  ON P.StateProvinceID = C.StateProvinceID
  WHERE p.SalesTerritory = 'Mideast';
GO

SELECT *
	FROM Application.vMideastSalesTerritory;
GO

---------------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-------LESSON 9.3 ---------------------------------
-------Implementing Input and Output parameters in stored procedures
--INPUT Parameters
USE WideWorldImporters;
GO

DROP PROCEDURE IF EXISTS Purchasing.uspGetSuppliersByDeliveryMethod;
GO

CREATE OR ALTER PROCEDURE Purchasing.uspGetSuppliersByDeliveryMethod
	@DeliveryMethodID AS int
AS
BEGIN
    SELECT SupplierName, PhoneNumber, WebsiteURL, DeliveryMethodID
    FROM Purchasing.Suppliers
	WHERE DeliveryMethodID = @DeliveryMethodID;
END;
GO

-->>>>>>Invoke the Procedure<<<<<<<-----------------
EXECUTE Purchasing.uspGetSuppliersByDeliveryMethod @DeliveryMethodID = 10;
GO

-------------------------------------------------------------------------
--INPUT and OUTPUT Parameters
USE WideWorldImporters;
GO

DROP PROCEDURE IF EXISTS Purchasing.uspGetSuppliersByDeliveryMethod;
GO

CREATE OR ALTER PROCEDURE Purchasing.uspGetSuppliersByDeliveryMethod
	@DeliveryMethodID AS int,
	@numSuppliers AS INT = 0 OUTPUT
AS
BEGIN
    SELECT SupplierName, PhoneNumber, WebsiteURL, DeliveryMethodID
    FROM Purchasing.Suppliers
	WHERE DeliveryMethodID = @DeliveryMethodID;
	SET @numSuppliers = @@ROWCOUNT;
	RETURN;
END;
GO

-->>>>>>Invoke the Procedure<<<<<<<-----------------
DECLARE @numofSuppliers AS INT
EXECUTE Purchasing.uspGetSuppliersByDeliveryMethod @DeliveryMethodID = 10,
		@numSuppliers = @numofSuppliers OUTPUT;
SELECT @numofSuppliers AS "Number of Suppliers using this Shipping Method";
GO

--Lesson 9.5 User-Defined Functions

-- In-Memory OLTP: Syntax for natively compiled, scalar user-defined function  
--CREATE [ OR ALTER ] FUNCTION [ schema_name. ] function_name   
-- ( [ { @parameter_name [ AS ][ type_schema_name. ] parameter_data_type   
--    [ NULL | NOT NULL ] [ = default ] [ READONLY ] }   
--    [ ,...n ]   
--  ]   
--)   
--RETURNS return_data_type  
--     WITH <function_option> [ ,...n ]   
--    [ AS ]   
--    BEGIN ATOMIC WITH (set_option [ ,... n ])   
--        function_body   
--        RETURN scalar_expression  
--    END  

--<function_option>::=   
--{  
--  |  NATIVE_COMPILATION   
--  |  SCHEMABINDING   
--  | [ EXECUTE_AS_Clause ]   
--  | [ RETURNS NULL ON NULL INPUT | CALLED ON NULL INPUT ]   
--}

---Lesson 9.7 Distinguishing Between Deterministic and Non-Deterministic Functions

USE WideWorldImporters;
GO

DROP FUNCTION IF EXISTS dbo.ufnTotalCustTrans;
GO

CREATE OR ALTER FUNCTION dbo.ufnTotalCustTrans    
(@TransactionDate datetime)                   
RETURNS decimal                               
 AS
 BEGIN                                        
	DECLARE @ret decimal;
	SELECT @ret = SUM(ct.TransactionAmount)
	FROM Sales.CustomerTransactions AS ct
	WHERE ct.TransactionDate = @TransactionDate;
	RETURN @ret;                              
END;
GO

--Total amount in sales for a given day-------------------------------------------
SELECT DISTINCT TransactionDate,dbo.ufnTotalCustTrans(TransactionDate) AS 'Total Daily Amount Sold'
FROM Sales.CustomerTransactions
WHERE TransactionDate = '2013-01-02';
GO

-->>>>Nondeterministic Built-in Function<<<<-----------------------------
-- Create local variable with DECLARE/SET syntax; using NEWID() function
--  Run the code more than once to show nondeterminism of NEW()-------------------

DECLARE @testid uniqueidentifier, @testcount INT
SET @testcount = 1

WHILE @testcount<= 5
	BEGIN
		SET @testid = NEWID()
		PRINT 'Value of the testid is: '+ CONVERT(varchar(255), @testid);
		SET @testcount +=1
	END;
GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
----Lesson 9.8 Creating Indexed Views---------------------

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

