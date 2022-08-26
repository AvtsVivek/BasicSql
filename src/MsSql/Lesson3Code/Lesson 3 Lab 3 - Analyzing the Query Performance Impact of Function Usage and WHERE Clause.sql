/***Lesson 3 Lab 3***/
/***Analyzing the Query Performance Impact of Function Usage and WHERE Clause ***/

USE WideWorldImporters;
GO

--Manipulation of applying YEAR to the OrderDate column prevents
--the sargability of the filter
--The optimizer scans the whole index--------------------------
SELECT OrderID,OrderDate
FROM Sales.Orders
WHERE YEAR(OrderDate) = 2014;

-->>>>THIS FILTER IS SARGABLE>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--The query plan applies a SEEK in the index
--employing only the rows qualified by the filter - the OrderDate column
SELECT OrderID,OrderDate
FROM Sales.Orders
WHERE OrderDate >= '20140101'
AND OrderDate< '20150101';


--Manipulation of applying LEFT to the FullName column prevents
--the sargability of the filter
--The optimizer scans the whole index--------------------------
SELECT PersonID, FullName
FROM Application.People
WHERE LEFT(FullName, 1) = N'C';

--Manipulation of applying LIKE followed by wildcard to the FullName column prevents
--the sargability of the filter
--The optimizer scans the whole index--------------------------
SELECT PersonID, FullName
FROM Application.People
WHERE FullName LIKE N'%ali%';

-->>>>THIS FILTER IS SARGABLE>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--The query plan applies a SEEK in the index
--employing only the rows qualified by the filter
SELECT PersonID, FullName
FROM Application.People
WHERE FullName LIKE N'C%';