/***Lesson 1 Lab 2***/
/***Reviewing Non-Efficient and Efficient Sample Queries***/

USE WideWorldImporters
GO

SELECT *
FROM Sales.Orders;

/******SELECT Query with restricted columns   ******/
SELECT CustomerID, OrderID, CustomerPurchaseOrderNumber, OrderDate, ExpectedDeliveryDate
FROM Sales.Orders;

/******SELECT Query with WHERE predicate clause   ******/
SELECT SalespersonPersonID, CustomerID, OrderID 
FROM Sales.Orders 
WHERE CustomerPurchaseOrderNumber < 15000; 

/******SELECT Query with HAVING clause   ******/
SELECT SalespersonPersonID, CustomerID, OrderID
FROM Sales.Orders 
WHERE CustomerPurchaseOrderNumber = 12211
GROUP BY SalespersonPersonID, CustomerID, OrderID
HAVING CustomerID < 500;
