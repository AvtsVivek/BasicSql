/****Lesson 7 Lab***********/
/****Using PIVOT and UNPIVOT in Queries with NULL Values*****/

USE AdventureWorks2016CTP3
GO

DROP TABLE IF Exists Sales.TotalFreightCost;
GO

WITH PivotData AS
(
SELECT
	CustomerID,
	ShipMethodID,
	Freight
FROM Sales.SalesOrderHeader
)
SELECT *
INTO Sales.TotalFreightCost
FROM PivotData
	PIVOT
(SUM(Freight) FOR ShipMethodID IN ([1], [2], [3], [4], [5])
)
AS P;

SELECT * FROM Sales.TotalFreightCost
ORDER BY CustomerID;

---UNPIVOT the Sales.TotalFreightCost table-----------
--Target values column - Freight
--Name to assign to target names column - ShipMethodID
--Source columns UPIVOTing are [1], [2], [3], [4], [5]
SELECT CustomerID, ShipMethodID, Freight
FROM Sales.TotalFreightCost
	UNPIVOT
	(Freight FOR ShipMethodID IN ([1], [2], [3], [4], [5])
)
AS U
ORDER BY CustomerID;


----->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
USE AdventureWorks2016CTP3
GO

SELECT  
		ShipMethodID,
		SUM(Freight) AS 'Total Freight Cost'
FROM Sales.SalesOrderHeader
WHERE ShipMethodID IN (1, 2, 3, 4, 5)
GROUP BY ShipMethodID
ORDER BY ShipMethodID;

---------------------PIVOTED QUERY Saved to table for later unpivoting---------------
USE AdventureWorks2016CTP3
GO

DROP TABLE IF Exists Sales.ShipMethodFreightCost;
GO

WITH PivotData AS
(
SELECT
	
	ShipMethodID,
	Freight
FROM Sales.SalesOrderHeader
)
SELECT *
INTO Sales.ShipMethodFreightCost
FROM PivotData
	PIVOT
(SUM(Freight) FOR ShipMethodID IN ([1], [2], [3], [4], [5])
)
AS P;


SELECT * FROM Sales.ShipMethodFreightCost;


---UNPIVOT the Sales.ShipMethodFreightCost table-----------
--Target values column - Freight
--Name to assign to target names column - ShipMethodID
--Source columns UPIVOTing are [1], [2], [3], [4], [5]
SELECT ShipMethodID, Freight
FROM Sales.ShipMethodFreightCost
	UNPIVOT
	(Freight FOR ShipMethodID IN ([1], [2], [3], [4], [5])
)
AS U;

--REPLACING NULLS with unused value and then
--replace with NULL in outer query
--to force NULLs in UNPIVOT query table
WITH C AS
(
	SELECT 
		ISNULL([1], 0.00) AS [1],
		ISNULL([2], 0.00) AS [2],
		ISNULL([3], 0.00) AS [3],
		ISNULL([4], 0.00) AS [4],
		ISNULL([5], 0.00) AS [5]
	FROM Sales.ShipMethodFreightCost
)
SELECT ShipMethodID, NULLIF(Freight,0.00) AS Freight
FROM C	
	UNPIVOT
	(Freight FOR ShipMethodID IN ([1], [2], [3], [4], [5])
)
AS U;


