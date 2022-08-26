/***Lesson 1 Lab 5***/
/***Creating Queries Using Set Operators***/

USE WideWorldImporters
GO

/*** INTERSECT OPERATOR ***/
SELECT CityName
FROM Application.Cities

INTERSECT

SELECT PostalAddressLine2
FROM Sales.Customers;

/*** EXCEPT OPERATOR - Cities table named first ***/
SELECT CityName
FROM Application.Cities

EXCEPT

SELECT PostalAddressLine2
FROM Sales.Customers;


/*** EXCEPT OPERATOR with DISTINCT - Cities table named first ***/
SELECT DISTINCT CityName
FROM Application.Cities

EXCEPT

SELECT PostalAddressLine2
FROM Sales.Customers;

/*** EXCEPT OPERATOR - Customers table named first ***/
SELECT PostalAddressLine2
FROM Sales.Customers

EXCEPT

SELECT CityName
FROM Application.Cities;


/*** UNION OPERATOR ***/
SELECT CityName
FROM Application.Cities

UNION

SELECT PostalAddressLine2
FROM Sales.Customers;


