/***Lesson 4 Lab 2***/
/***Creating DML Statements Using the OUTPUT Statement***/

USE WideWorldImporters;
GO

--Create and fill Examples.CurrentOrders table--
DROP TABLE IF EXISTS Examples.CurrentOrders;

SELECT OrderID, CustomerID, SalespersonPersonID, OrderDate
  INTO Examples.CurrentOrders
  FROM Sales.Orders
  WHERE OrderID BETWEEN 1 AND 20;

--INSERT with OUTPUT----
INSERT INTO Examples.CurrentOrders(OrderID, CustomerID, SalespersonPersonID, OrderDate)
  OUTPUT
    inserted.OrderID, inserted.CustomerID, inserted.SalespersonPersonID, inserted.OrderDate
  SELECT OrderID, CustomerID, SalespersonPersonID, OrderDate
  FROM Sales.Orders
  WHERE OrderID BETWEEN 30 AND 40;

--DELETE with OUTPUT-------
DELETE FROM Examples.CurrentOrders
  OUTPUT deleted.OrderID
  WHERE CustomerID = 567;

SELECT *
FROM Examples.CurrentOrders;

--UPDATE with OUTPUT--
UPDATE Examples.CurrentOrders
  SET OrderDate = DATEADD(day, 7, orderdate)
  OUTPUT 
    inserted.OrderID,
	deleted.OrderDate AS original_orderdate,
	inserted.OrderDate AS new_orderdate
WHERE CustomerID = 105;

--MERGE with OUTPUT--
MERGE INTO Examples.CurrentOrders AS TARGT
USING (VALUES(1, 832, 5, '2017-06-01'), (2, 803, 5, '2017-06-02'), (21, 832, 5, '2017-06-03'))
  AS SRCE(OrderID, CustomerID, SalesPersonPersonID, OrderDate)
  ON SRCE.OrderID = TARGT.OrderID
WHEN MATCHED AND EXISTS(SELECT SRCE.* EXCEPT SELECT TARGT.*) --UPDATE
  THEN
  UPDATE SET 
	TARGT.CustomerID = SRCE.CustomerID,
	TARGT.SalesPersonPersonID = SRCE.SalesPersonPersonID,
	TARGT.OrderDate = SRCE.OrderDate
WHEN NOT MATCHED                                             --INSERT
  THEN
  INSERT VALUES(SRCE.OrderID, SRCE.CustomerID, SRCE.SalesPersonPersonID, SRCE. OrderDate)
WHEN NOT MATCHED BY SOURCE                                   --DELETE
  THEN
  DELETE
OUTPUT
  $action AS Action_Taken,
  COALESCE(inserted.OrderID, deleted.OrderID) AS OrderID;    --Return Values in Single Expression
			
SELECT *
FROM Examples.CurrentOrders;


