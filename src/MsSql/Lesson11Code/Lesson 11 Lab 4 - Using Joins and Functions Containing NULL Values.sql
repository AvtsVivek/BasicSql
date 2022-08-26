/****Lesson 11 Lab***********/
--Using Joins and Functions Containing NULLs--------------
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

/****Using Joins and Function Containing NULLs*****/

/***Using JOINS with NULLs***/
--FROM LAB IN LESSON 2------------------------
USE WideWorldImporters
GO
--Standard SELECT from StockItems table
SELECT si.StockItemName, si.ColorID
FROM Warehouse.StockItems AS si
ORDER BY si.StockItemName;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>--
/****INNER JOIN matching StockItems and their Color****/
--128 rows---------------------------------------------
--Only StockItems having a valued color are returned---
SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
ORDER BY si.StockItemName;

/****LEFT OUTER JOIN returns all StockItems regardless
*****of whether or not color is valued****/
---Ordered by StockItemName--------------------------

SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
LEFT JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
ORDER BY si.StockItemName;


/****StockItems that have no valued color********/
SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
LEFT JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
WHERE c.ColorName IS NULL;


/****RIGHT OUTER JOIN returns all ColorNames regardless
*****of whether or not StockItemName is valued****/

SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
RIGHT JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
ORDER BY si.StockItemName;


--Returns Items in stock and their Colors-------
SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
RIGHT JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
WHERE si.StockItemName IS NOT NULL
ORDER BY si.StockItemName;

--Returns Colors not used for items in stock--------------------
SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
RIGHT JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
WHERE si.StockItemName IS NULL
ORDER BY si.StockItemName;

-------------------------------------------------------------------------
/***Using FUNCTIONS with NULLs***/
USE AdventureWorks2016CTP3
GO

SELECT TerritoryID, SalesQuota, SalesYTD 
FROM Sales.SalesPerson;    
GO

---AVG and SUM disregard NULLs
SELECT TerritoryID, AVG(SalesQuota)as 'Average Sales Quota', SUM(SalesYTD) as 'YTD sales'  
FROM Sales.SalesPerson  
GROUP BY TerritoryID;  
GO

USE AdventureWorks2016CTP3;  
GO
SELECT Description, DiscountPct, MinQty, MaxQty AS 'Max Quantity'  
FROM Sales.SpecialOffer
ORDER BY MaxQty;  
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
SELECT IIF ( @a > @b, 'TRUE', NULL ) AS Result;


