/****Lesson 11 Lab 3***********/
/****Identifying Implicit Data Type Conversions*****/

USE AdventureWorks2016CTP3;
GO

----Implicit conversion----------
----smallint to money------------
SELECT P.Name,
       I.Quantity,          ----smallint
       P.StandardCost,      ----money
       I.Quantity * P.StandardCost as TotalCost  --implicit conversion to money
FROM   Production.ProductInventory I
       INNER JOIN Production.Product P
       ON P.ProductID = I.ProductID
WHERE  P.StandardCost > 0.00


-------------------------------------
--Consequences of Implicit data type conversion------
--NationalIDNumber is data type nvarchar--

use AdventureWorks2016CTP3
go

SELECT BusinessEntityID, NationalIDNumber, LoginID
FROM HumanResources.Employee
WHERE NationalIDNumber = 134969118;
go


SELECT BusinessEntityID, NationalIDNumber, LoginID
FROM HumanResources.Employee
WHERE NationalIDNumber = '134969118';
go

SELECT BusinessEntityID, NationalIDNumber, LoginID
FROM HumanResources.Employee
WHERE NationalIDNumber = N'134969118';
go

-----------------------------------------------------
--Operations with different data types---------------
-----------------------------------------------------

SELECT '10' + 10 AS '''10'' + 10';

SELECT 10 + GETDATE() AS '10 + GETDATE()';

SELECT '10' + GETDATE() 



