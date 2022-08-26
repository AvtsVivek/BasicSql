/***Lesson 2.7***/
/***Determining the Correct Results When Presented with Multi-Table SELECT Statements and Source Data***/ 


USE WideWorldImporters;
GO

--Question 1:----------------------------
/**You are asked to find the delivery method used
 for all suppliers in the WideWorldImporters database. 
 You are to include only suppliers who have a designated delivery method.
**/

SELECT s.SupplierName, d.DeliveryMethodName
FROM Purchasing.Suppliers AS s
JOIN Application.DeliveryMethods AS d
ON s.DeliveryMethodID = d.DeliveryMethodID;


SELECT s.SupplierName, d.DeliveryMethodName
FROM Purchasing.Suppliers AS s
LEFT JOIN Application.DeliveryMethods AS d
ON s.DeliveryMethodID = d.DeliveryMethodID;

SELECT s.SupplierName, d.DeliveryMethodName
FROM Purchasing.Suppliers AS s
LEFT JOIN Application.DeliveryMethods AS d
ON s.DeliveryMethodID = d.DeliveryMethodID
WHERE d.DeliveryMethodName IS NOT NULL;


SELECT s.SupplierName, d.DeliveryMethodName
FROM Purchasing.Suppliers AS s
LEFT JOIN Application.DeliveryMethods AS d
ON s.DeliveryMethodID = d.DeliveryMethodID
WHERE d.DeliveryMethodName IS NULL;


SELECT s.SupplierName, d.DeliveryMethodName
FROM Purchasing.Suppliers AS s
RIGHT JOIN Application.DeliveryMethods AS d
ON s.DeliveryMethodID = d.DeliveryMethodID;

SELECT s.SupplierName, d.DeliveryMethodName
FROM Purchasing.Suppliers AS s
CROSS JOIN Application.DeliveryMethods AS d;


SELECT s.SupplierName, d.DeliveryMethodName
FROM Purchasing.Suppliers AS s
RIGHT JOIN Application.DeliveryMethods AS d
ON s.DeliveryMethodID = d.DeliveryMethodID
WHERE s.SupplierName IS NULL

SELECT c.CustomerName, d.DeliveryMethodName
FROM Sales.Customers AS c
RIGHT JOIN Application.DeliveryMethods AS d
ON c.DeliveryMethodID = d.DeliveryMethodID
WHERE c.CustomerName IS NULL;

SELECT c.CustomerName, d.DeliveryMethodName
FROM Sales.Customers AS c
RIGHT JOIN Application.DeliveryMethods AS d
ON c.DeliveryMethodID = d.DeliveryMethodID;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SELECT d.DeliveryMethodName
FROM Purchasing.Suppliers AS s
RIGHT JOIN Application.DeliveryMethods AS d
ON s.DeliveryMethodID = d.DeliveryMethodID
WHERE s.SupplierName IS NULL
INTERSECT
SELECT d.DeliveryMethodName
FROM Sales.Customers AS c
RIGHT JOIN Application.DeliveryMethods AS d
ON c.DeliveryMethodID = d.DeliveryMethodID
WHERE c.CustomerName IS NULL;

