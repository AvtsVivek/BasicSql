/***Lesson 1 Lab 7***/
/***Creating Queries with UNION and UNION ALL***/

USE WideWorldImporters
GO

/*** UNION OPERATOR ***/
SELECT CityName
FROM Application.Cities

UNION

SELECT PostalAddressLine2
FROM Sales.Customers;

/*** UNION ALL OPERATOR ***/
SELECT CityName
FROM Application.Cities

UNION ALL

SELECT PostalAddressLine2
FROM Sales.Customers;

