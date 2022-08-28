
/***Lesson 5 Lab 1***/
/***Comparing Subqueries and Table Joins***/

USE WideWorldImporters;
GO

CREATE SCHEMA Examples;
GO

--Create and fill Examples.CurrentOrders table--
DROP TABLE IF EXISTS Examples.CurrentOrders;

SELECT OrderID, CustomerID, SalespersonPersonID, OrderDate
  INTO Examples.CurrentOrders
  FROM Sales.Orders
  WHERE OrderID BETWEEN 1 AND 20;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SELECT *
FROM Sales.Customers
WHERE CustomerID NOT IN
	(SELECT CustomerID
	FROM Examples.CurrentOrders);

-- The above same query in another way, where we will not have to create a new table.

SELECT *
FROM Sales.Customers
WHERE CustomerID NOT IN
	(SELECT CustomerID
  FROM Sales.Orders
  WHERE OrderID BETWEEN 1 AND 20);

------------------------------------------------------
/***************************************************/
-----EXAMPLE 1: SUBQUERY MORE EFFICIENT THAN JOIN-----------
------------------------------------------------------------
/**Return all DeliveryMethods Not Used by Suppliers*************/
-----SUBQUERY Solution------------------------------------------
--NOTE Left Anti Semi Join in SUBQUERY Solution Execution Plan--
SELECT DM.DeliveryMethodID, DM.DeliveryMethodName
FROM Application.DeliveryMethods AS DM
WHERE NOT EXISTS
	(SELECT * 
	FROM Purchasing.Suppliers AS S
	WHERE S.DeliveryMethodID = DM.DeliveryMethodID);

-----LEFT OUTER JOIN Solution-----------------------------------
SELECT DM.DeliveryMethodID, DM.DeliveryMethodName
FROM Application.DeliveryMethods AS DM
	LEFT OUTER JOIN Purchasing.Suppliers AS S
	ON DM.DeliveryMethodID = S.DeliveryMethodID
WHERE S.SupplierID IS NULL;


--Analyze delivery methods suppliers use----------
--SELECT DISTINCT DeliveryMethodID
--FROM Purchasing.Suppliers;

/***************************************************/
-----EXAMPLE 2: SUBQUERY LESS EFFICIENT THAN JOIN-----------
-----Computations applied in Subquery-----------------------
/**Return Quantity, UnitPrice, TaxRate, TaxAmount, TotalAmount  **/
/**per orderID, per line item*************************************/
/**tax amount and total amount per line item need to be calculated**/
------------------------------------------------------------
-----SUBQUERY Solution for EXAMPLE 2------------------------
SELECT OrderID, OrderLineID, Quantity, UnitPrice, TaxRate,
	(SELECT Quantity*UnitPrice*TaxRate/100 FROM Sales.OrderLines AS O2
		WHERE O2.OrderLineID = O1.OrderLineID) AS TaxAmount,
	(SELECT Quantity* UnitPrice + Quantity*UnitPrice*TaxRate/100 FROM Sales.OrderLines AS O3
		WHERE O3.OrderLineID = O1.OrderLineID) AS TotalAmountPerOrderLine
FROM Sales.OrderLines AS O1
ORDER BY O1.OrderID, O1.OrderLineID;

------JOIN Solution for EXAMPLE 2---------------------------
------More Efficient----------------------------------------
SELECT O.OrderID, O.OrderLineID, O.Quantity, O.UnitPrice, O.TaxRate,
		J.TaxAmount, J.TotalAmountPerOrderLine
FROM Sales.OrderLines AS O
  INNER JOIN (SELECT OrderLineID, Quantity*UnitPrice*TaxRate/100 AS TaxAmount,
			  Quantity* UnitPrice + Quantity*UnitPrice*TaxRate/100 AS TotalAmountPerOrderLine
			  FROM Sales.OrderLines) AS J
  ON O.OrderLineID = J.OrderLineID
ORDER BY O.OrderID, O.OrderLineID;
   
