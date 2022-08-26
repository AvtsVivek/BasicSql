/* 70-761 Lesson 11 Live Lessons INLINE Code */

USE WideWorldImporters
GO
--Lesson 11.1----------------------------------------------
DECLARE @testval decimal (5, 2);  
SET @testval = 256.83;  
SELECT CAST(CAST(@testval AS varbinary(20)) AS decimal(10,5));  
-- Or, using CONVERT  
SELECT CONVERT(decimal(10,5), CONVERT(varbinary(20), @testval));


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Example shows silent truncation can affect
--arithmetic operations without raising an error:

DECLARE @BinVar2 BINARY(2);
DECLARE @NEWBinVar2 BINARY(2);
DECLARE @BinVar4 BINARY(4);
DECLARE @NEWBinVar4 BINARY(4);
DECLARE @TestBinary INT;

SET @TestBinary = 123456;
SET @BinVar2 = @TestBinary;
SET @BinVar4 = @TestBinary;
SET @NEWBinVar2 = @BinVar2 + 1;
SET @NEWBinVar4 = @BinVar4 + 1; 

SELECT  @TestBinary AS OriginalINT,
		@BinVar2 AS 'Binary(2)',
		@NEWBinVar2 AS 'Binary(2) + 1',
		CAST( @NEWBinVar2 AS INT) AS 'CAST @NEWBinVar2 Back to INT';
SELECT	@TestBinary AS OriginalINT,
		@BinVar4 AS 'Binary(4)',
		@NEWBinVar4 AS 'Binary(4) + 1',
		CAST( @NEWBinVar4 AS INT) AS 'CAST @NEWBinVar4 Back to INT';
GO

--------------------------------------------------------------------
----LESSON 11.3 Determining Proper Data Types------

USE AdventureWorks2016CTP3
GO
/*
>>>>>>>>>>>>>>>Using the IDENTITY Property>>>>>>>>>>>>>>>>>>>>>>>>>>>
IDENTITY [ (seed , increment) ] 
seed - value used for very first row loaded into the table
increment - value that is added to identity value of the previous row
*/

CREATE TABLE Production.Categories(
	CategoryID INT IDENTITY(1,1) NOT NULL,
	CategoryName NVARCHAR (40),
	Description NVARCHAR(max)
	CONSTRAINT PK_Categories_CategoryID PRIMARY KEY(CategoryID),
);
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

---------------------------------------------------------------------------
------------11.5 Identifying Implicit Data Type Conversions----------------
-----------------------------------------------------
--Operations with different data types---------------
-----------------------------------------------------
SELECT '10' + 10 AS '''10'' + 10';

SELECT 10 + GETDATE() AS '10 + GETDATE()';

SELECT '10' + GETDATE() 

-------------------------------------------------------------------------------
----------11.7 Determining correct results of joins and functions-------------
----------in presence of NULLs------------------------------------------------
Use AdventureWorks2016CTP3
GO

--Returning NULLs in predicate
SELECT BusinessEntityID,SalesQuota
FROM Sales.SalesPerson
WHERE SalesQuota Is NULL;
GO

--Ordering column with NULLs
SELECT BusinessEntityID,SalesQuota
FROM Sales.SalesPerson
ORDER BY SalesQuota;
GO


USE AdventureWorks2016CTP3;  
GO
SELECT Description, DiscountPct, MinQty, MaxQty AS 'Max Quantity'  
FROM Sales.SpecialOffer
ORDER BY MaxQty;  
GO
  
SELECT Description, DiscountPct, MinQty, ISNULL(MaxQty, 0.00) AS 'Max Quantity'  
FROM Sales.SpecialOffer;  
GO

SELECT MIN(MaxQty) AS ' Least Max Quantity'  
FROM Sales.SpecialOffer;  
GO

SELECT CHOOSE ( 3, 'Manager', 'Director', NULL, 'Tester' ) AS Result;

SELECT DATEDIFF(day,startDate,endDate) AS 'Duration' 
  FROM Production.BillOfMaterials 

--ERROR
--At least one of the result expressions in a CASE specification
-- must be an expression other than the NULL constant

SELECT IIF ( 45 > 30, NULL, NULL ) AS Result;

----Returns NULL
DECLARE @P INT = NULL, @S INT = NULL;  
SELECT IIF ( 45 > 30, @p, @s ) AS Result;

--One of the result expressions is NULL
DECLARE @a int = 100, @b int = 80;  
SELECT IIF ( @a > @b, 'TRUE', NULL ) AS Result

-------------------------------------------------------
---Lesson 11.9 Using ISNULL and COALESCE
---ISNULL - substituting 0 for weight of NULL----
SELECT AVG(Weight)  
FROM Production.Product;

SELECT AVG(ISNULL(Weight, 50))  
FROM Production.Product;  
GO  

SELECT AVG(ISNULL(Weight, 0))  
FROM Production.Product;

----------------------------------------------------------------
USE AdventureWorks2016CTP3;  
GO
SELECT Description, DiscountPct, MinQty, MaxQty AS 'Max Quantity'  
FROM Sales.SpecialOffer
ORDER BY MaxQty;  
GO

--Replacing NULL with 0 using ISNULL function  
SELECT Description, DiscountPct, MinQty, ISNULL(MaxQty, 0.00) AS 'Max Quantity'  
FROM Sales.SpecialOffer;  
GO