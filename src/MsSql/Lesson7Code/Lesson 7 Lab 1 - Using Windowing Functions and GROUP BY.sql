/****Lesson 7 Lab***********/
/****Using Windowing Functions and GROUP BY*****/

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

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-->>Business Scenario----------------------------------
--RANK Orders by value for each customer---------------
USE AdventureWorks2016CTP3
GO
--RANK Orders by value for each customer---------------
--Use RANK and PARTITION BY CustomerID-----------------
--Use Desc to RANK from largest order total to smallest
SELECT CustomerID, SalesOrderID, SubTotal AS 'Order Total'
  ,RANK() OVER(PARTITION BY CustomerID ORDER BY SubTotal Desc) AS Rnk
FROM Sales.SalesOrderHeader
	ORDER BY CustomerID, SubTotal Desc, SalesOrderID;
GO


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
----Simple GROUP BY with ORDER BY----------------------------------------------------
--Returns the number of orders per year----------------------------------------------
USE AdventureWorks2016CTP3
GO

SELECT YEAR(OrderDate) AS N'Year Ordered', COUNT(*) AS 'Number of Orders'
	FROM Sales.SalesOrderHeader
	GROUP BY YEAR(OrderDate)
	ORDER BY YEAR(OrderDate);
GO

----Simple GROUP BY with ORDER BY----------------------------------------------------
--Returns the total value of orders per year formatted for US currency----------------------------------------------
USE AdventureWorks2016CTP3
GO

SELECT YEAR(OrderDate) AS N'Year Ordered', FORMAT(SUM(SubTotal), 'C', 'en-US') AS 'Total Value of Orders'
	FROM Sales.SalesOrderHeader
	GROUP BY YEAR(OrderDate)
	ORDER BY YEAR(OrderDate);
GO

