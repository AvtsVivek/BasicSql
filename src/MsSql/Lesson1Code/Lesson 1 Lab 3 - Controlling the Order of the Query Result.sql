/***Lesson 1 Lab 3***/
/***Controlling the Order of the Query Result***/

USE WideWorldImporters
GO

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


/******SELECT Query with ORDER BY DESC clause   ******/
--8 rows in result-------------------------------------
SELECT OrderID, OrderDate, SalespersonPersonID, CustomerID
FROM Sales.Orders 
WHERE CustomerPurchaseOrderNumber = 12211
ORDER BY OrderDate DESC;


/******SELECT Query with TOP clause   ******/
SELECT TOP(5) OrderID, OrderDate, SalespersonPersonID, CustomerID
FROM Sales.Orders 
WHERE CustomerPurchaseOrderNumber = 12211
ORDER BY OrderDate DESC;


/******SELECT Query with TOP PERCENT clause   ******/
--50 PERCENT of 8 is 4, thus 4 rows returned---------
SELECT TOP(50) PERCENT OrderID, OrderDate, SalespersonPersonID, CustomerID
FROM Sales.Orders 
WHERE CustomerPurchaseOrderNumber = 12211
ORDER BY OrderDate DESC;


/******SELECT Query with TOP PERCENT clause   ******/
--10 PERCENT of 8 is .8, thus 1 row returned (rounded up)---------
SELECT TOP(10) PERCENT OrderID, OrderDate, SalespersonPersonID, CustomerID
FROM Sales.Orders 
WHERE CustomerPurchaseOrderNumber = 12211
ORDER BY OrderDate DESC;


/******SELECT Query with TOP clause   ******/
--5 rows returned---------------------------
SELECT TOP(5) OrderID, OrderDate, SalespersonPersonID, CustomerID
FROM Sales.Orders 
--WHERE CustomerPurchaseOrderNumber = 12211
ORDER BY OrderDate DESC;


/******SELECT Query with TOP clause   ******/
--90 rows returned---------------------------
SELECT TOP(5) WITH TIES OrderID, OrderDate, SalespersonPersonID, CustomerID
FROM Sales.Orders 
--WHERE CustomerPurchaseOrderNumber = 12211
ORDER BY OrderDate DESC;


/******SELECT Query with OFFSET-FETCH clause   ******/
--10 rows returned starting with the 6 row of previous query----
SELECT OrderID, OrderDate, SalespersonPersonID, CustomerID
FROM Sales.Orders 
ORDER BY OrderDate DESC
OFFSET 5 ROWS FETCH NEXT 10 ROWS ONLY;

