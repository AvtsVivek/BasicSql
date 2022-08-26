/***Lesson 1 Lab 1***/
/***Writing Queries that Filter Data Using Predicates***/

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

/******SELECT Query with DISTINCT clause   ******/
SELECT SalesTerritory
FROM Application.StateProvinces;

SELECT DISTINCT SalesTerritory
FROM Application.StateProvinces;

