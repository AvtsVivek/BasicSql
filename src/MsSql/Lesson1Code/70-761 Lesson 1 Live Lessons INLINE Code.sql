/* 70-761 Lesson 1 Live Lessons INLINE Code */

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Lesson 1.1 Identifying Proper SELECT Query Structure------

/******SELECT Query with Predicate Filter   ******/
USE WideWorldImporters
GO

SELECT CustomerID, OrderID, CustomerPurchaseOrderNumber, OrderDate, ExpectedDeliveryDate
FROM Sales.Orders 
WHERE CustomerPurchaseOrderNumber BETWEEN '12211' AND '12212';

/******SELECT Query with WHERE clause   ******/
SELECT SalespersonPersonID, CustomerID, OrderID 
FROM Sales.Orders 
WHERE CustomerPurchaseOrderNumber = 12211


/******SELECT Query with GROUP BY clause   ******/
SELECT SalespersonPersonID, CustomerID, OrderID
FROM Sales.Orders 
WHERE CustomerPurchaseOrderNumber = 12211
GROUP BY SalespersonPersonID, CustomerID, OrderID


/******SELECT Query with HAVING clause   ******/
SELECT SalespersonPersonID, CustomerID, OrderID
FROM Sales.Orders 
WHERE CustomerPurchaseOrderNumber = 12211
GROUP BY SalespersonPersonID, CustomerID, OrderID
HAVING CustomerID < 500;


/******SELECT Query with ORDER BY clause   ******/
SELECT SalespersonPersonID, CustomerID, OrderID
FROM Sales.Orders 
WHERE CustomerPurchaseOrderNumber = 12211
GROUP BY SalespersonPersonID, CustomerID, OrderID
HAVING CustomerID < 500
ORDER BY SalespersonPersonID;


/******    Deterministic Query            ******/
USE WideWorldImporters
GO

SELECT AVG(Quantity) AS 'Average Quantity'
FROM Sales.OrderLines;


/****** Non-Deterministic Query           ******/
SELECT GETDATE() AS 'Today''s Date'
FROM Sales.CustomerTransactions;



-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Lesson 1.12 Identifying the query that would return expected results
--based on provided table structure and/or data

/***1.12 Inline Query 1 ***/

USE WideWorldImporters
GO

SELECT CustomerID, SalespersonPersonID
FROM Sales.Orders
WHERE OrderDate >='20130101' AND OrderDate < '20130102'

EXCEPT

SELECT CustomerID, SalespersonPersonID
FROM Sales.Orders
WHERE OrderDate >='20130102' AND OrderDate < '20130103';

/***1.12 Inline Query 2 ***/

USE WideWorldImporters
GO

SELECT CustomerID, SalespersonPersonID
FROM Sales.Orders
WHERE OrderDate >='20130101' AND OrderDate < '20130102'

INTERSECT

SELECT CustomerID, SalespersonPersonID
FROM Sales.Orders
WHERE OrderDate >='20130102' AND OrderDate < '20130103';
