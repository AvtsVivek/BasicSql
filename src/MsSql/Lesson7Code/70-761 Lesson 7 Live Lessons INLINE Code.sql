/* 70-761 Lesson 7 Live Lessons INLINE Code */

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/* Lesson 7.1 Using Windowing Functions to Group and Rank Results of a Query */--------------------------------------
----------------------------------------------------------------------------------------------
USE AdventureWorks2016CTP3
GO

SELECT ShipMethodID, YEAR(OrderDate) AS N'Year Ordered', COUNT(*) AS 'Number of Orders'
	,SUM(COUNT(*)) OVER(PARTITION BY ShipMethodID) AS 'Total per ShipMethod'
	,AVG(COUNT(*)) OVER(PARTITION BY ShipMethodID) AS 'Average per ShipMethod'
	,MAX(COUNT(*)) OVER(PARTITION BY ShipMethodID) AS 'Maximum per ShipMethod'
	,SUM(COUNT(*)) OVER() AS 'Grand Total of Orders'
	FROM  Sales.SalesOrderHeader
	GROUP BY ShipMethodID, YEAR(OrderDate)
	ORDER BY ShipMethodID, YEAR(OrderDate);
GO

-----------------------------------------------------------------------------------
--Using Window Framing Clause with OVER and Frame Unit ROWS------------------------
-- and Delimiters UNBOUNDED PRECEDING and CURRENT ROW------------------------------
-----------------------------------------------------------------------------------
USE AdventureWorks2016CTP3
GO

SELECT CustomerID, SalesOrderID
	,Convert(Date,OrderDate) AS 'Order Date'
	, SubTotal
	,SUM(SubTotal) OVER(PARTITION BY CustomerID
		ORDER BY OrderDate, SalesOrderID
			ROWS BETWEEN UNBOUNDED PRECEDING
				AND CURRENT ROW) AS 'Running Total'
	FROM  Sales.SalesOrderHeader
	Where CustomerID IN ( 11000,11001);
GO

-----------------------------------------------------------------------------------
--Using Window Ranking Functions---------------------------------------------------
-----------------------------------------------------------------------------------
USE AdventureWorks2016CTP3
GO

SELECT CustomerID, SalesOrderID, SubTotal
  ,RANK()       OVER(ORDER BY SubTotal) AS Rnk
  ,DENSE_RANK() OVER(ORDER BY SubTotal) AS DenseRnk
  ,NTILE(4)   OVER(ORDER BY SubTotal) AS Quartile
  ,ROW_NUMBER() OVER(ORDER BY SubTotal) AS RowNum
FROM Sales.SalesOrderHeader
	WHERE CustomerID IN ( 11000, 11001, 11002, 11003, 11004)
	ORDER BY SubTotal, CustomerID, SalesOrderID;
GO

-----------------------------------------------------------------------------------
--Using Window Offset Functions---------------------------------------------------
-----------------------------------------------------------------------------------
--Using LAG to retrieve value from previous row------------------------------------
--Using LEAD to retrieve value from next row---------------------------------------
USE AdventureWorks2016CTP3
GO

SELECT CustomerID, SalesOrderID, SubTotal,
	LAG(SubTotal) OVER(PARTITION BY CustomerID
		ORDER BY OrderDate, SalesOrderID) AS previous_value,
	LEAD(SubTotal) OVER(PARTITION BY CustomerID
		ORDER BY OrderDate, SalesOrderID) AS next_value
FROM Sales.SalesOrderHeader
	WHERE CustomerID IN ( 11000, 11001, 11002, 11003, 11004)
	ORDER BY CustomerID, SalesOrderID, SubTotal;
GO



-->>>>Lesson 7.2 
----Simple GROUP BY with ORDER BY----------------------------------------------------

USE AdventureWorks2016CTP3
GO

SELECT YEAR(OrderDate) AS N'Year Ordered', COUNT(*) AS 'Number of Orders'
	FROM Sales.SalesOrderHeader
	GROUP BY YEAR(OrderDate)
	ORDER BY YEAR(OrderDate);
GO

USE AdventureWorks2016CTP3
GO
-->>>>>>>Lesson 7.4 Constructing Complex GROUP BY Clauses Using GROUPING SETS and CUBE
--------------Using GROUPING SETS Clause----------------------------------------------
USE AdventureWorks2016CTP3
GO
---Two GROUPING SETS defined------------------------------------------------------
SELECT ShipMethodID, YEAR(OrderDate) AS N'Year Ordered', COUNT(*) AS 'Number of Orders'
	FROM Sales.SalesOrderHeader
	GROUP BY GROUPING SETS
	(
	ShipMethodID, YEAR(OrderDate)
	)
	ORDER BY ShipMethodID, YEAR(OrderDate);
GO


USE AdventureWorks2016CTP3
GO
------Four GROUPING SETS--------------------------------------------------------------
SELECT ShipMethodID, YEAR(OrderDate) AS N'Year Ordered', COUNT(*) AS 'Number of Orders'
	FROM Sales.SalesOrderHeader
	GROUP BY GROUPING SETS
	(
	(ShipMethodID, YEAR(OrderDate)),
	(ShipMethodID                 ),
	(YEAR(OrderDate)              ),
	(                             )
	)
	ORDER BY ShipMethodID, YEAR(OrderDate);
GO
	
-----------Using CUBE------------------------------------------------------------
USE AdventureWorks2016CTP3
GO

SELECT ShipMethodID, YEAR(OrderDate) AS N'Year Ordered', COUNT(*) AS 'Number of Orders'
	FROM Sales.SalesOrderHeader
	GROUP BY CUBE( ShipMethodID, YEAR(OrderDate))
		ORDER BY ShipMethodID, YEAR(OrderDate);
GO

----------Using ROLLUP---------------------------------------------------------------
--Use like GROUPING SETS but where natural hierarchy of data-------------------------
--For example, Territory, ShipToAddress----------------------------------------------
USE AdventureWorks2016CTP3
GO

SELECT TerritoryID, ShipToAddressID, COUNT(*) AS 'Number of Orders'
	FROM Sales.SalesOrderHeader
	GROUP BY ROLLUP( TerritoryID, ShipToAddressID);
GO


------GROUPING Function		
--Distinguishes whether column used in GROUP BY clause is aggregated; 1 = aggregated, 0 = not aggregated
--------------------------------------------------------------------------------------------------------
USE AdventureWorks2016CTP3
GO

SELECT ShipMethodID, YEAR(OrderDate) AS N'Year Ordered', COUNT(*) AS 'Number of Orders', 
	GROUPING(ShipMethodID) AS 'Grouping Ship Method'
	FROM Sales.SalesOrderHeader
	GROUP BY GROUPING SETS
	(
	(ShipMethodID, YEAR(OrderDate)),
	(ShipMethodID                 ),
	(YEAR(OrderDate)              ),
	(                             )
	)
	ORDER BY ShipMethodID, YEAR(OrderDate);
GO	


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Lesson 7.6 Construct PIVOT and UNPIVOT Statements	------------------------------------
USE AdventureWorks2016CTP3
GO

-----------ORIGINAL QUERY----------------------
SELECT 
	DaysToManufacture, 
	AVG(StandardCost) AS 'Average Cost' 
FROM Production.Product
WHERE DaysToManufacture IN (0, 1, 2, 3, 4)
GROUP BY DaysToManufacture
ORDER BY DaysToManufacture;


--------------PIVOTED QUERY---------------------
SELECT 'AverageCost' AS Cost_Sorted_By_Production_Days, 
[0], [1], [2], [3], [4]
FROM
(SELECT DaysToManufacture, StandardCost 
    FROM Production.Product) AS SourceTable
PIVOT
(
AVG(StandardCost)
FOR DaysToManufacture IN ([0], [1], [2], [3], [4])
) AS PivotTable

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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

-------------ORIGINAL QUERY---------------------
--Total Freight Cost per Ship Method------------
USE AdventureWorks2016CTP3
GO
--Original - Simplified for slide
SELECT 
		ShipMethodID,
		SUM(Freight) AS 'Total Freight Cost'
FROM Sales.SalesOrderHeader
WHERE ShipMethodID IN (1, 2, 3, 4, 5)
GROUP BY ShipMethodID
ORDER BY ShipMethodID;

---------------------PIVOTED QUERY---------------
USE AdventureWorks2016CTP3
GO
--PIVOT - Simplified for slide
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

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.
--Saving PIVOTed query to table Sales.ShipMethodFreightCost
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
