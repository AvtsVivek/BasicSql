/***Lesson 5 Lab 2***/
/***Using the APPLY Operator***/

USE WideWorldImporters;
GO

/**Modify Data for DEMO Sample*******************/
--SELECT *
--FROM Sales.Customers;


DROP TABLE IF EXISTS Examples.CustomerInfo;
GO


SELECT CustomerID, CustomerName, BuyingGroupID,PrimaryContactPersonID, DeliveryMethodID, DeliveryCityID
INTO Examples.CustomerInfo
FROM Sales.Customers;
GO

--Insert a customer with no orders in DeliveryCityID 19586---------------------------------
INSERT INTO Examples.CustomerInfo
	VALUES(2000, 'CustomerWithNoOrders', 1, 1001, 3, 19586);
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--USING CROSS APPLY----------------------------------------------------
USE WideWorldImporters;
GO


--RETURN THE LAST 5 ORDERS FOR CUSTOMERS IN DeliveryCityID 19586
SELECT 
	cust.customerID, cust.CustomerName,
	ca.*
FROM Examples.CustomerInfo AS cust
--USE CROSS APPLY WHICH IS SIMILAR TO LEFT OUTER JOIN BETWEEN TWO TABLES --
--APPLIES THE Sales from the Sales.Orders (right) table to each row in the Examples.CustomerInfo (left) table --
--CROSS APPLY does not return rows for those with NULL in columns of the right (Sales.Orders) table --
CROSS APPLY(
	SELECT TOP(5) so.Orderdate, so.OrderID FROM Sales.Orders AS so
	WHERE so.CustomerID = cust.CustomerID
	ORDER BY so.OrderDate DESC
) AS ca  --------------------------RETURNS A CORRELATED DERIVED TABLE FILTERED FROM Sales.Orders--------------
WHERE cust.DeliveryCityID = 19586;
GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--USING OUTER APPLY----------------------------------------------------
USE WideWorldImporters;
GO

--RETURN THE LAST 5 ORDERS FOR CUSTOMERS IN DeliveryCityID 19586--
--AND ANY CUSTOMERS IN 19586 WHO HAVE NO ORDERS-------------------
SELECT 
	cust.customerID, cust.CustomerName,
	oa.*
FROM Examples.CustomerInfo AS cust
--USE OUTER APPLY WHICH IS SIMILAR TO LEFT OUTER JOIN BETWEEN TWO TABLES --
--APPLIES THE Sales from the Sales.Orders (right) table to each row in the Examples.CustomerInfo (left) table --
--OUTER APPLY adds rows for those with NULL in columns of the right (Sales.Orders) table --
OUTER APPLY(
	SELECT TOP(5) so.Orderdate, so.OrderID FROM Sales.Orders AS so
	WHERE so.CustomerID = cust.CustomerID
	ORDER BY so.OrderDate DESC
) AS oa     --------------------------RETURNS A CORRELATED DERIVED TABLE FILTERED FROM Sales.Orders---------------
WHERE cust.DeliveryCityID = 19586;
GO

