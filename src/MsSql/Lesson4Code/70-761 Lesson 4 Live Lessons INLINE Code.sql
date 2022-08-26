/* 70-761 Lesson 4 Live Lessons INLINE Code */

-->>>>Sample Table>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>--
-->>>>Examples.Employees>>>>>>>>>>>>>>>>>>>>>>>>--
/*
USE WideWorldImporters;
GO



CREATE SCHEMA Examples;
GO


CREATE TABLE [Examples].[Employees](
	[empid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](20) NOT NULL,
	[title] [nvarchar](30) NOT NULL,
	[mgrid] [int] NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[empid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [Examples].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_Employees_Employees] FOREIGN KEY([mgrid])
REFERENCES [Examples].[Employees] ([empid])
GO

ALTER TABLE [Examples].[Employees] CHECK CONSTRAINT [FK_Employees_Employees]
GO


USE WideWorldImporters
GO

INSERT INTO Examples.Employees (name,title,mgrid)
     VALUES
           (N'Mickey', N'CEO',NULL),
		   (N'Minnie', N'VP Animation',1),
		   (N'Donald', N'Story Manager',2),
		   (N'Daisy', N'Story Writer',3),
		   (N'Grumpy', N'Story Research',2),
		   (N'Happy', N'Story Development',5),
		   (N'Dopey', N'Story Development',5);

GO
*/


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Lesson 4.1 Writing INSERT, UPDATE, and DELETE Statements------

/****** Using INSERT VALUES Statement******/
INSERT INTO Examples.Employees (name,title,mgrid)
     VALUES
		   (N'Goofy', N'Story Production',2);

/*****Using SELECT INTO*******************/
--Start with only the original Employees table----
DROP TABLE IF EXISTS Examples.GlobalEmployees;

--Use SELECT INTO to create and fill the GlobalEmployees table--
--with data from the Employees table----------------------------
SELECT name, title, mgrid
 INTO Examples.GlobalEmployees
 FROM Examples.Employees;

/******Using INSERT SELECT*****************/
INSERT INTO Examples.GlobalEmployees (name, title, mgrid)
  SELECT PreferredName, FullName, IsEmployee
  FROM Application.People
  WHERE IsPermittedToLogon = 1;

/*****Using INSERT EXEC*****************/

DROP PROCEDURE IF EXISTS Examples.SalespersonStatus;
GO

-----Create stored procedure if it does not already exist----------
CREATE PROC Examples.SalespersonStatus
  @Status AS bit
AS
	SELECT PreferredName, FullName, IsEmployee
	FROM Application.People
	WHERE IsSalesPerson = @Status;
GO

--Execute the Stored Procedure to insert-------
--the results into the specified table---------
INSERT INTO Examples.GlobalEmployees(name, title, mgrid)
  EXEC Examples.SalesPersonStatus
    @Status = 1;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/***UPDATE Statement**************/
UPDATE Examples.Employees
SET mgrid = 1
WHERE name = N'Goofy';

/** Create and fill new table Examples.OrderInfo 
    with data from Sales.OrderLines**/

--Start with only the original table----
DROP TABLE IF EXISTS Examples.OrderInfo;

----Use SELECT INTO to create and fill table-----
SELECT OrderLineID, OrderID, StockItemID, Description, Quantity, UnitPrice, TaxRate
  INTO Examples.OrderInfo
  FROM Sales.OrderLines
    WHERE OrderLineID BETWEEN 1 AND 20
    ORDER BY OrderLineID;

SELECT *
FROM Examples.OrderInfo;

/***UPDATE Data Using Variables********/
DECLARE @TaxRateIncrease decimal(18,3) = 5.000;
UPDATE Examples.OrderInfo
  SET TaxRate += @TaxRateIncrease
  WHERE OrderID = 46;

/***UPDATE Data using JOINs*********/
UPDATE OI
  SET OI.TaxRate = OL.TaxRate
  FROM Sales.OrderLines OL
  INNER JOIN Examples.OrderInfo OI
  ON OI.OrderLineID = OL.OrderLineID;

  /***UPDATE all-at-once*************/
SELECT StockItemID, Quantity
  FROM Examples.OrderInfo
  WHERE OrderLineID = 1;

--UPDATE Quantity and StockItemID in same SET statement----
DECLARE @increase AS INT = 100;
UPDATE Examples.OrderInfo
  SET Quantity +=@increase, StockItemID = Quantity
  WHERE OrderLineID = 1;

SELECT StockItemID, Quantity
  FROM Examples.OrderInfo
  WHERE OrderLineID = 1;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/***Deleting Data**************/

DELETE FROM Examples.OrderInfo
WHERE OrderId = 6;

/*** DELETE based on a Join***/
DELETE FROM Examples.OrderInfo
	FROM Sales.OrderLines AS OL
	INNER JOIN Examples.OrderInfo AS OI
	ON OL.OrderLineID = OI.OrderLineID
WHERE OL.StockItemID = 10;

/***TRUNCATE TABLE statement***/
TRUNCATE TABLE Examples.OrderInfo;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/***Lesson 4.4  
Constructing Data Manipulation Language (DML) Statements Using the OUTPUT Statement
***/
--Create and fill Examples.CurrentOrders table--
DROP TABLE IF EXISTS Examples.CurrentOrders;

SELECT OrderID, CustomerID, SalespersonPersonID, OrderDate
  INTO Examples.CurrentOrders
  FROM Sales.Orders
  WHERE OrderID BETWEEN 1 AND 20;

--INSERT with OUTPUT----
INSERT INTO Examples.CurrentOrders(OrderID, CustomerID, SalespersonPersonID, OrderDate)
  OUTPUT
    inserted.OrderID, inserted.CustomerID, inserted.SalespersonPersonID, inserted.OrderDate
  SELECT OrderID, CustomerID, SalespersonPersonID, OrderDate
  FROM Sales.Orders
  WHERE OrderID BETWEEN 30 AND 40;

----DELETE with OUTPUT----
DELETE FROM Examples.CurrentOrders
  OUTPUT deleted.OrderID
  WHERE CustomerID = 567;

  --UPDATE with OUTPUT--
UPDATE Examples.CurrentOrders
  SET OrderDate = DATEADD(day, 7, orderdate)
  OUTPUT 
    inserted.OrderID,
	deleted.OrderDate AS original_orderdate,
	inserted.OrderDate AS new_orderdate
WHERE CustomerID = 105;

--MERGE with OUTPUT--
MERGE INTO Examples.CurrentOrders AS TARGT
USING (VALUES(1, 832, 5, '2017-06-01'), (2, 803, 5, '2017-06-02'), (21, 832, 5, '2017-06-03'))
  AS SRCE(OrderID, CustomerID, SalesPersonPersonID, OrderDate)
  ON SRCE.OrderID = TARGT.OrderID
WHEN MATCHED AND EXISTS(SELECT SRCE.* EXCEPT SELECT TARGT.*)
  THEN
  UPDATE SET 
	TARGT.CustomerID = SRCE.CustomerID,
	TARGT.SalesPersonPersonID = SRCE.SalesPersonPersonID,
	TARGT.OrderDate = SRCE.OrderDate
WHEN NOT MATCHED
  THEN
  INSERT VALUES(SRCE.OrderID, SRCE.CustomerID, SRCE.SalesPersonPersonID, SRCE. OrderDate)
WHEN NOT MATCHED BY SOURCE
  THEN
  DELETE
OUTPUT
  $action AS Action_Taken,
  COALESCE(inserted.OrderID, deleted.OrderID) AS OrderID; 

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/***Lesson 4.6  
Determining the Results of Date Definition Language on Supplied Tables and Data
***/
--Create and fill Examples.CurrentOrders table--
DROP TABLE IF EXISTS Examples.CurrentOrders;

SELECT OrderID, CustomerID, SalespersonPersonID, OrderDate
  INTO Examples.CurrentOrders
  FROM Sales.Orders
  WHERE OrderID BETWEEN 1 AND 20;

/********ADD Column************/
--Adding a Column allowing NULLs--
ALTER TABLE Examples.CurrentOrders 
  ADD CustomerCountryName VARCHAR(20) NULL ;  
GO 

SELECT *
FROM Examples.CurrentOrders;

--Adding non-nullable column with default constraint
ALTER TABLE Examples.CurrentOrders   
ADD LastEditedDate datetime2(7) not null  
CONSTRAINT AddDateDflt  
DEFAULT GETDATE() WITH VALUES ;  
GO  

SELECT *
FROM Examples.CurrentOrders;

/******DROP Column***********/
--Remove a single column.  
ALTER TABLE Examples.CurrentOrders 
  DROP COLUMN CustomerCountryName;  
GO 

SELECT *
FROM Examples.CurrentOrders; 

-- Remove a constraint and a column  
-- The keyword CONSTRAINT is optional. The keyword COLUMN is required.  
ALTER TABLE Examples.CurrentOrders   
 DROP CONSTRAINT AddDateDflt, COLUMN LastEditedDate;  
GO  

SELECT *
FROM Examples.CurrentOrders;

/*******ALTER Column******************/
-- Changing the data type of a column 
ALTER TABLE Examples.CurrentOrders 
  ALTER COLUMN CustomerID DECIMAL (5, 2) ;  
GO  

SELECT *
FROM Examples.CurrentOrders; 

--Changing the size of a column
--Adding a Column allowing NULLs--
ALTER TABLE Examples.CurrentOrders 
	ADD CustomerCityName VARCHAR(20) NULL ;  
GO
  
-- Increase the size of the varchar column.  
ALTER TABLE Examples.CurrentOrders 
	ALTER COLUMN CustomerCityName varchar(50);  
GO  
 
SELECT *
FROM Examples.CurrentOrders;
