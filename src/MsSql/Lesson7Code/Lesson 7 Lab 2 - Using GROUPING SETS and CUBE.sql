/****Lesson 7 Lab***********/
/****Using GROUPING SETS and CUBE*****/

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

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--EXTRA: Using Joins to Aggregate SALES by Sales Territory,
--Country, Store Name, and Sales Person-------------------------------
/*
------------------------------------------------------------------------------------------------
--Using Multiple Grouping Sets -----------------------------------------------------------------
*/
------------------------------------------------------------------------------------------------
-------------Using GROUP BY with GROUPING SETS Clause-------------------------------------------
USE AdventureWorks2016CTP3
GO
SELECT ST.[Group] AS N'Sales Territory', ST.CountryRegionCode AS N'Country'
    ,S.Name AS N'Store Name', SOH.SalesPersonID AS N'Sales Person ID'
    ,SUM(TotalDue) AS N'Total Sales'
FROM Sales.Customer C
    INNER JOIN Sales.Store AS S
        ON C.StoreID  = S.BusinessEntityId 
    INNER JOIN Sales.SalesTerritory AS ST
        ON C.TerritoryID  = ST.TerritoryID 
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON C.CustomerID = SOH.CustomerID
WHERE ST.[Group] = N'North America'
    AND ST.CountryRegionCode IN(N'US', N'CA')
    AND SOH.SalesPersonID IN(275, 277, 281, 289)
    AND SUBSTRING(S.Name,1,2)IN(N'Ac', N'Bi ')
GROUP BY GROUPING SETS
    (
	  ST.[Group]
	, ST.CountryRegionCode
	, S.Name
	, SOH.SalesPersonID
	)
ORDER BY ST.[Group], ST.CountryRegionCode, S.Name, SOH.SalesPersonID;
GO

------------------------------------------------------------------------------------------------
-------------Using GROUP BY with Multiple GROUPING SETS ----------------------------------------
USE AdventureWorks2016CTP3
GO
SELECT ST.[Group] AS N'Sales Territory', ST.CountryRegionCode AS N'Country'
    ,S.Name AS N'Store Name', SOH.SalesPersonID AS N'Sales Person ID'
    ,SUM(TotalDue) AS N'Total Sales'
FROM Sales.Customer C
    INNER JOIN Sales.Store AS S
        ON C.StoreID  = S.BusinessEntityId 
    INNER JOIN Sales.SalesTerritory AS ST
        ON C.TerritoryID  = ST.TerritoryID 
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON C.CustomerID = SOH.CustomerID
WHERE ST.[Group] = N'North America'
    AND ST.CountryRegionCode IN(N'US', N'CA')
    AND SOH.SalesPersonID IN(275, 277, 281, 289)
    AND SUBSTRING(S.Name,1,2)IN(N'Ac', N'Bi ')
GROUP BY GROUPING SETS
(
	(ST.[Group], ST.CountryRegionCode)
	, (ST.[Group], SOH.SalesPersonID )
	, (S.Name                        )
	, (SOH.SalesPersonID             )
	,(                               )
	)
ORDER BY ST.[Group], ST.CountryRegionCode, S.Name, SOH.SalesPersonID;
GO

------------------------------------------------------------------------------------------------
-------------Using ROLLUP Clause with GROUPING SETS ---------------------------------------------

USE AdventureWorks2016CTP3
GO
SELECT ST.[Group] AS N'Sales Territory', ST.CountryRegionCode AS N'Country'
    ,S.Name AS N'Store Name', SOH.SalesPersonID AS N'Sales Person ID'
    ,SUM(TotalDue) AS N'Total Sales'
FROM Sales.Customer C
    INNER JOIN Sales.Store AS S
        ON C.StoreID  = S.BusinessEntityId 
    INNER JOIN Sales.SalesTerritory AS ST
        ON C.TerritoryID  = ST.TerritoryID 
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON C.CustomerID = SOH.CustomerID
WHERE ST.[Group] = N'North America'
    AND ST.CountryRegionCode IN(N'US', N'CA')
    AND SOH.SalesPersonID IN(275, 277, 281, 289)
    AND SUBSTRING(S.Name,1,2)IN(N'Ac', N'Bi ')
GROUP BY GROUPING SETS
(
	ST.[Group]
	, ST.CountryRegionCode 
	, ROLLUP(S.Name, SOH.SalesPersonID)
	)
ORDER BY ST.[Group], ST.CountryRegionCode, S.Name, SOH.SalesPersonID;
GO

------------------------------------------------------------------------------------------------
-------------Using CUBE Clause with GROUPING SETS ----------------------------------------------
USE AdventureWorks2016CTP3
GO
SELECT ST.[Group] AS N'Sales Territory', ST.CountryRegionCode AS N'Country'
    ,S.Name AS N'Store Name', SOH.SalesPersonID AS N'Sales Person ID'
    ,SUM(TotalDue) AS N'Total Sales'
FROM Sales.Customer C
    INNER JOIN Sales.Store AS S
        ON C.StoreID  = S.BusinessEntityId 
    INNER JOIN Sales.SalesTerritory AS ST
        ON C.TerritoryID  = ST.TerritoryID 
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON C.CustomerID = SOH.CustomerID
WHERE ST.[Group] = N'North America'
    AND ST.CountryRegionCode IN(N'US', N'CA')
    AND SOH.SalesPersonID IN(275, 277, 281, 289)
    AND SUBSTRING(S.Name,1,2)IN(N'Ac', N'Bi ')
GROUP BY GROUPING SETS
(
	ST.[Group]
	, ST.CountryRegionCode 
	, CUBE(S.Name, SOH.SalesPersonID)
	)
ORDER BY ST.[Group], ST.CountryRegionCode, S.Name, SOH.SalesPersonID;