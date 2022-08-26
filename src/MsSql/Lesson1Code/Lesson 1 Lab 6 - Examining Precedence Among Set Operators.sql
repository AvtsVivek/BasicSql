/***Lesson 1 Lab 6***/
/***Examining Precedence Among Set Operators***/

USE WideWorldImporters
GO

/*** Set Operator Precedence ***/
/** INTERSECT operator is evaluated first **/
--Cities that are sales customers cities
--but NOT(cities that are both application and purchasing supplier cities)
SELECT PostalAddressLine2
FROM Sales.Customers

EXCEPT

SELECT CityName
FROM Application.Cities

INTERSECT

SELECT PostalAddressLine2
FROM Purchasing.Suppliers;

/***Adding parentheses around INTERSECT operation            ***/
/***does not change the order of operations of previous query***/

SELECT PostalAddressLine2
FROM Sales.Customers

EXCEPT

(SELECT CityName
FROM Application.Cities

INTERSECT

SELECT PostalAddressLine2
FROM Purchasing.Suppliers);

/***HOWEVER, Adding parentheses around EXCEPT operation  ***/
/***DOES change the order of operations of previous query***/
--(Cities that are sales customers cities but not in application cities)
--and that are also purchasing supplier cities

(SELECT PostalAddressLine2
FROM Sales.Customers

EXCEPT

SELECT CityName
FROM Application.Cities)

INTERSECT

SELECT PostalAddressLine2
FROM Purchasing.Suppliers;


