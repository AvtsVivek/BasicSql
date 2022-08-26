/****Lesson 7 Lab***********/
/****Using PIVOT and UNPIVOT*****/

USE AdventureWorks2016CTP3 ;
GO

------Review Data from the Production.Product table---------------
SELECT Name, DaysToManufacture,StandardCost
FROM Production.Product

SELECT Name, DaysToManufacture,AVG(StandardCost) AS AverageCost
FROM Production.Product
GROUP BY Name, DaysToManufacture


SELECT DaysToManufacture, AVG(StandardCost) AS AverageCost 
FROM Production.Product
GROUP BY DaysToManufacture;

-----------ORIGINAL QUERY----------------------
USE AdventureWorks2016CTP3 ;
GO

SELECT 
	DaysToManufacture, 
	AVG(StandardCost) AS 'Average Cost' 
FROM Production.Product
WHERE DaysToManufacture IN (0, 1, 2, 3, 4)
GROUP BY DaysToManufacture
ORDER BY DaysToManufacture;


-->>>>>>>>>>>>>>>>PIVOT table>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Pivot table with one row and five columns
SELECT 'AverageCost' AS Cost_Sorted_By_Production_Days, 
[0], [1], [2], [3], [4]
FROM
(SELECT DaysToManufacture, StandardCost 
    FROM Production.Product) AS SourceTable
PIVOT
(
AVG(StandardCost)
FOR DaysToManufacture IN ([0], [1], [2], [3], [4])
) AS PivotTable;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Simplified Sample Query
--Total Freight Cost by Ship Method-----------
-------------ORIGINAL QUERY---------------------
USE AdventureWorks2016CTP3
GO

SELECT  
		ShipMethodID,
		SUM(Freight) AS 'Total Freight Cost'
FROM Sales.SalesOrderHeader
WHERE ShipMethodID IN (1, 2, 3, 4, 5)
GROUP BY ShipMethodID
ORDER BY ShipMethodID;

---------------------PIVOTED QUERY---------------
SELECT 'Total Freight Cost' AS Cost_By_ShipMethod,
 [1], [2], [3], [4], [5]
FROM
 (SELECT ShipMethodID, Freight
	FROM Sales.SalesOrderHeader) AS SourceTable
PIVOT
(
SUM(Freight)
FOR ShipMethodID IN ([1], [2], [3], [4], [5])
) AS PivotTable;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--More Complete Sample Query
-------------ORIGINAL QUERY---------------------
USE AdventureWorks2016CTP3
GO
--Original
SELECT  CustomerID,
		ShipMethodID,
		SUM(Freight) AS 'Total Freight Cost'
FROM Sales.SalesOrderHeader
WHERE ShipMethodID IN (1, 2, 3, 4, 5)
GROUP BY CustomerID, ShipMethodID
ORDER BY CustomerID;

--PIVOTED Using CTE
WITH PivotTable AS
(
SELECT  CustomerID,    --GROUPING COLUMN
		ShipMethodID,  --SPREADING COLUMN
		Freight        --AGGREGATION COLUMN
FROM Sales.SalesOrderHeader
)
SELECT CustomerID,
 [1], [2], [3], [4], [5]
FROM PivotTable
PIVOT
(
SUM(Freight)
FOR ShipMethodID IN ([1], [2], [3], [4], [5])
) AS P
ORDER BY CustomerID;
-->>>>>>>>>>>>>>>>>>.







-->>>>>>>>>>>>>>>>>>>>UNPIVOT table>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
USE tempdb
GO

DECLARE @p TABLE
(    
  col1 int,
  col2 int,
  col3 int,
  col4 int,
  col5 int
)  

INSERT INTO @p
SELECT 1,2,3,4,5

Select * 
FROM @p


----->Now to UNPIVOT the table<-----------------------------------
SELECT
  unpvt.ColName,
  unpvt.ColValue
FROM 
(
SELECT col1, col2, col3, col4, col5
FROM @p
) p
UNPIVOT (ColValue FOR ColName IN (col1, col2, col3, col4, col5) ) AS unpvt;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.

