
/***Lesson 4 Lab 1***/
/***Using INSERT, UPDATE, and DELETE to modify the contents of a table***/

USE WideWorldImporters;
GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/****** Using INSERT VALUES Statement******/
INSERT INTO Examples.Employees (name,title,mgrid)
     VALUES
		   (N'Goofy', N'Story Production',2);

SELECT *
FROM Examples.Employees;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/********Using SELECT INTO*******************/
--Start with only the original Employees table----
DROP TABLE IF EXISTS Examples.GlobalEmployees;

--Use SELECT INTO to create and fill the GlobalEmployees table--
--with data from the Employees table----------------------------
SELECT name, title, mgrid
 INTO Examples.GlobalEmployees
 FROM Examples.Employees;


SELECT *
FROM Examples.GlobalEmployees; 

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/******** Using INSERT SELECT***************/
/*SET IDENTITY_INSERT Examples.GlobalEmployees ON;

INSERT INTO Examples.GlobalEmployees (empid, name, title, mgrid)
  SELECT PersonID, PreferredName, FullName, IsEmployee
  FROM Application.People
  WHERE IsPermittedToLogon = 1;

SELECT *
FROM Examples.GlobalEmployees;
*/
--------------------------------------
/*SET IDENTITY_INSERT Examples.GlobalEmployees OFF; */

INSERT INTO Examples.GlobalEmployees (name, title, mgrid)
  SELECT PreferredName, FullName, IsEmployee
  FROM Application.People
  WHERE IsPermittedToLogon = 1;

SELECT *
FROM Examples.GlobalEmployees;  

GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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

SELECT *
FROM Examples.GlobalEmployees;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/***UPDATE Statements**************/
UPDATE Examples.Employees
SET mgrid = 1
WHERE name = N'Goofy';

SELECT *
FROM Examples.Employees;

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

SELECT *
FROM Examples.OrderInfo;

/***UPDATE Data using JOINs*********/
/**Replaces TaxRate in Examples.OrderInfo table with 
   TaxRate in Sales.OrderLines table ***/
UPDATE OI
  SET OI.TaxRate = OL.TaxRate
  FROM Sales.OrderLines OL
  INNER JOIN Examples.OrderInfo OI
  ON OI.OrderLineID = OL.OrderLineID;

SELECT *
FROM Examples.OrderInfo;

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

Select *
FROM Examples.OrderInfo


/*** DELETE based on a Join***/
DELETE FROM Examples.OrderInfo
	FROM Sales.OrderLines AS OL
	INNER JOIN Examples.OrderInfo AS OI
	ON OL.OrderLineID = OI.OrderLineID
WHERE OL.StockItemID = 10;

Select *
FROM Examples.OrderInfo

/***TRUNCATE TABLE statement***/
TRUNCATE TABLE Examples.OrderInfo;

/***Note - table structure retained***/
Select *
FROM Examples.OrderInfo

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/**** Use the MERGE Statement to Merge Source Data to a Target ****/
/*
Create two temporary tables:
	 Original_Cast (source)
     Updated_Cast (target)
Update data in the Original_Cast (source) table
Use the MERGE statement to update the Updated_Cast (target) table
*/

USE TempDB;
GO
 
DROP TABLE IF EXISTS tempdb.#Original_Cast;
DROP TABLE IF EXISTS tempdb.#Updated_Cast;

CREATE TABLE #Original_Cast
(  CastID    TINYINT NOT NULL
  ,Name   VARCHAR (25) NULL
  ,Location         VARCHAR (25) NULL);
GO
 
CREATE TABLE #Updated_Cast
(  CastID    TINYINT NOT NULL
  ,Name   VARCHAR (25) NULL
  ,Location         VARCHAR (25) NULL);
GO
 
INSERT INTO #Original_Cast (CastID, Name, Location)
   VALUES (1, 'Cinderella', 'Fantasyland')
         ,(2, 'Aladdin', 'Adventureland')
         ,(3, 'Brer Rabbit', 'Frontierland')
		 ,(4, 'Charming', 'Fantasyland');

INSERT INTO #Updated_Cast (CastID, Name, Location)
   VALUES (1, 'Cinderella', 'Fantasyland')
         ,(2, 'Aladdin', 'Adventureland')
         ,(3, 'Brer Rabbit', 'Frontierland')
		 ,(4, 'Charming', 'Fantasyland');

SELECT *
FROM #Original_Cast
GO

SELECT *
FROM #Updated_Cast
GO

--UPDATE, INSERT, and DELETE entries in the Original_Cast table --
-- Update Mister Charming's Title --
UPDATE #Original_Cast
   SET Name = 'Prince Charming'
 WHERE CastID = 4
-- Delete Brer Rabbit --
DELETE #Original_Cast
 WHERE CastID = 3
--Add Buzz Lightyear and his location --
INSERT INTO #Original_Cast (CastID, Name, Location)
VALUES (5, 'Buzz Lightyear', 'Tomorrowland')
GO

SELECT *
FROM #Original_Cast
GO

SELECT *
FROM #Updated_Cast
GO

-- Using the Original_Cast table as the source, MERGE changes into the Updated_Cast table --
MERGE  #Updated_Cast AS Target
 USING #Original_Cast AS Source
    ON Target.CastID = Source.CastID
WHEN MATCHED
                AND (Target.Name <> Source.Name
                     OR Target.Location <> Source.Location)
THEN
   UPDATE SET    -- this UPDATES Prince Charming's name --
      Target.Name = Source.Name
     ,Target.Location = Source.Location
WHEN NOT MATCHED BY TARGET  
THEN
   INSERT (CastID, Name, Location)  -- this INSERTS Buzz into the Updated_Cast table --
   VALUES (Source.CastID, Source.Name, Source.Location)
WHEN NOT MATCHED BY SOURCE THEN DELETE;  -- for this sample, just deletes any unmatched data --
GO

SELECT *
FROM #Original_Cast
GO

SELECT *
FROM #Updated_Cast
GO

--Cleanup Tables --
DROP TABLE #Original_Cast;
DROP TABLE #Updated_Cast;




-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
