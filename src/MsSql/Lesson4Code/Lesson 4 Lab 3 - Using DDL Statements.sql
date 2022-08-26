/***Lesson 4 Lab 3***/
/***Using Date Definition Language (DDL) Statements***/

USE WideWorldImporters;
GO

--Create and fill Examples.CurrentOrders table--
DROP TABLE IF EXISTS Examples.CurrentOrders;

SELECT OrderID, CustomerID, SalespersonPersonID, OrderDate
  INTO Examples.CurrentOrders
  FROM Sales.Orders
WHERE OrderID BETWEEN 1 AND 20;

SELECT *
FROM Examples.CurrentOrders;

/********ADD Column************/
--Adding a Column allowing NULLs--
ALTER TABLE Examples.CurrentOrders ADD CustomerCountryName VARCHAR(20) NULL ;  
GO 

SELECT *
FROM Examples.CurrentOrders;

--Adding Nullable column with default constraint
ALTER TABLE Examples.CurrentOrders   
ADD LastEditedDate datetime2(7) not null  
CONSTRAINT AddDateDflt  
DEFAULT GETDATE() WITH VALUES ;  
GO  

SELECT *
FROM Examples.CurrentOrders;

/******DROP Column***********/
--Remove a single column.  
ALTER TABLE Examples.CurrentOrders DROP COLUMN CustomerCountryName ;  
GO 

SELECT *
FROM Examples.CurrentOrders; 

-- Remove a constraint and a column  
-- The keyword CONSTRAINT is optional. The keyword COLUMN is required.  
ALTER TABLE Examples.CurrentOrders   
 DROP CONSTRAINT AddDateDflt, COLUMN LastEditedDate ;  
GO  

SELECT *
FROM Examples.CurrentOrders;

/*******ALTER Column******************/
-- Changing the data type of a column 
ALTER TABLE Examples.CurrentOrders ALTER COLUMN CustomerID DECIMAL (5, 2) ;  
GO  

SELECT *
FROM Examples.CurrentOrders; 

--Changing the size of a column
--Adding a Column allowing NULLs--
ALTER TABLE Examples.CurrentOrders 
	ADD CustomerCityName VARCHAR(20) NULL ;  
GO

SELECT *
FROM Examples.CurrentOrders;
  
-- Increase the size of the varchar column.  
ALTER TABLE Examples.CurrentOrders 
	ALTER COLUMN CustomerCityName varchar(50);  
GO  
 
SELECT *
FROM Examples.CurrentOrders;
