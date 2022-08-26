/***Lesson 1 Lab 4***/
/***Understanding All-at-once Operations***/

USE WideWorldImporters
GO

/***All expressions in SELECT clause evaluated logically at the same time***/
--Use of alias in following query evaluates without a problem --------------
SELECT OrderID, YEAR(Orderdate) AS OrderYear, YEAR(OrderDate) + 1 AS NextYear
FROM Sales.Orders;

--Second use of OrderYear alias in same SELECT clause causes an error-------
SELECT OrderID, YEAR(Orderdate) AS OrderYear, OrderYear + 1 AS NextYear
FROM Sales.Orders;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/***Recall that SELECT clause evaluates after GROUP BY ***/
--Use of alias in following query evaluates without a problem --------------
SELECT SalespersonPersonID, YEAR(OrderDate) as OrderYear, COUNT(DISTINCT CustomerID) AS numberofcustomers
FROM Sales.Orders
GROUP BY SalespersonPersonID, YEAR(OrderDate);

--Use of alias in GROUP BY clause is not recognized-----------------------
SELECT SalespersonPersonID, YEAR(OrderDate) as OrderYear, COUNT(DISTINCT CustomerID) AS numberofcustomers
FROM Sales.Orders
GROUP BY SalespersonPersonID, OrderYear;


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/***Expressions in WHERE clause are processed in any order***/
--SQL Server supports short circuits and processes the WHERE clause
--in any order, hence neither query  below yields an error----
SELECT TotalDryItems, TotalChillerItems
FROM Sales.Invoices
WHERE TotalChillerItems <> 0 AND TotalDryItems/TotalChillerItems > 3;

--TotalChillerItems with a value of 0 are eliminated because 
--SQL has decided to process this part of the clause first
--even when it appears after the AND.-----------------------
--HOWEVER, to be absolutely certain the query will not fail,
--put the WHERE clause in a CASE statement as we will learn later--
SELECT TotalDryItems, TotalChillerItems
FROM Sales.Invoices
WHERE TotalDryItems/TotalChillerItems > 3 AND TotalChillerItems <> 0;


