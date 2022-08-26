/* 70-761 Lesson 5 Live Lessons INLINE Code */

USE WideWorldImporters;
GO

--Lesson 5.1  Determining the Results of Queries Using Subqueries and Table Joins 
-----Scalar Subquery-----------------------------
--Most expensive StockItem-----------------------
SELECT StockItemID, StockItemName, UnitPrice
FROM Warehouse.StockItems
WHERE UnitPrice = 
	(SELECT MAX(UnitPrice)
	FROM Warehouse.StockItems);


--Multi-Valued Subquery-------------------
SELECT CustomerID, CustomerName, CustomerCategoryID 
FROM Sales.Customers
WHERE CustomerCategoryID IN (
	SELECT CustomerCategoryID
	FROM Sales.CustomerCategories
	WHERE CustomerCategoryName = N'Computer Store');

--Correlated Subquery---------------------
SELECT CustomerID, OrderID, OrderDate
FROM Sales.Orders AS outerso
WHERE OrderDate = 
	(SELECT Max(OrderDate)
	FROM Sales.Orders AS innerso
	WHERE innerso.CustomerID = outerso.CustomerID)
ORDER BY CustomerID;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Lesson 5.2 Evaluating Performance Differences Between Table Joins
--and Correlated Subqueries Based on Provided Data and Query Plans

--MODIFY DATA FOR SAMPLE QUERY------------------------------------------
--Create and fill Examples.CurrentOrders table--
DROP TABLE IF EXISTS Examples.CurrentOrders;

SELECT OrderID, CustomerID, SalespersonPersonID, OrderDate
  INTO Examples.CurrentOrders
  FROM Sales.Orders
  WHERE OrderID BETWEEN 1 AND 20;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SELECT *
FROM Sales.Customers
WHERE CustomerID NOT IN
	(SELECT CustomerID
	FROM Examples.CurrentOrders);
------------------------------------------------------
/***************************************************/
/**Return all DeliveryMethods Not Used by Suppliers*************/
-----SUBQUERY Solution------------------------------------------
--NOTE Left Anti Semi Join in SUBQUERY Solution Execution Plan--
SELECT DM.DeliveryMethodID, DM.DeliveryMethodName
FROM Application.DeliveryMethods AS DM
WHERE NOT EXISTS
	(SELECT * 
	FROM Purchasing.Suppliers AS S
	WHERE S.DeliveryMethodID = DM.DeliveryMethodID);

-----LEFT OUTER JOIN Solution-----------------------------------
SELECT DM.DeliveryMethodID, DM.DeliveryMethodName
FROM Application.DeliveryMethods AS DM
	LEFT OUTER JOIN Purchasing.Suppliers AS S
	ON DM.DeliveryMethodID = S.DeliveryMethodID
WHERE S.SupplierID IS NULL;


--Analyze delivery methods suppliers use----------
SELECT DISTINCT DeliveryMethodID
FROM Purchasing.Suppliers;


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Lesson 5.5  Writing APPLY Statements That Return a Given Data Set
-- Based on Supplied Data

--Modify Data FOR EXAMPLE------------------------------------------
DROP TABLE IF EXISTS Examples.CustomerInfo;
GO


SELECT CustomerID, CustomerName, BuyingGroupID,PrimaryContactPersonID, DeliveryMethodID, DeliveryCityID
INTO Examples.CustomerInfo
FROM Sales.Customers;
GO

--Insert a customer with no orders in DeliveryCityID 19586---------------------------------
INSERT INTO Examples.CustomerInfo
	VALUES(2000, 'CustomerWithNoOrders', 1, 1001, 3, 19586);
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--USING CROSS APPLY----------------------------------------------------
USE WideWorldImporters;
GO


--RETURN THE LAST 5 ORDERS FOR CUSTOMERS IN DeliveryCityID 19586
SELECT 
	cust.customerID, cust.CustomerName,
	ca.*
FROM Examples.CustomerInfo AS cust
CROSS APPLY(
	SELECT TOP(5) so.Orderdate, so.OrderID FROM Sales.Orders AS so
	WHERE so.CustomerID = cust.CustomerID
	ORDER BY so.OrderDate DESC
) AS ca  --------------------------RETURNS A CORRELATED DERIVED TABLE FILTERED FROM Sales.Orders--------------
WHERE cust.DeliveryCityID = 19586;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--USING OUTER APPLY----------------------------------------------------
USE WideWorldImporters;
GO

--RETURN THE LAST 5 ORDERS FOR CUSTOMERS IN DeliveryCityID 19586--
--AND ANY CUSTOMERS IN 19586 WHO HAVE NO ORDERS-------------------
SELECT 
	cust.customerID, cust.CustomerName,
	oa.*
FROM Examples.CustomerInfo AS cust
OUTER APPLY(
	SELECT TOP(5) so.Orderdate, so.OrderID FROM Sales.Orders AS so
	WHERE so.CustomerID = cust.CustomerID
	ORDER BY so.OrderDate DESC
) AS oa     --------------------------RETURNS A CORRELATED DERIVED TABLE FILTERED FROM Sales.Orders---------------
WHERE cust.DeliveryCityID = 19586;


