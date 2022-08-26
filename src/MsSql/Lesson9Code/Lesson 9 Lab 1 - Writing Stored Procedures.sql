/****Lesson 9 Lab***********/
/****Writing Stored Procedures*****/

USE WideWorldImporters;
GO

DROP PROCEDURE IF EXISTS Purchasing.uspGetAirFreightSuppliers;
GO

CREATE OR ALTER PROCEDURE Purchasing.uspGetAirFreightSuppliers
AS
    SELECT SupplierName, PhoneNumber, WebsiteURL
    FROM Purchasing.Suppliers
	WHERE DeliveryMethodID IN (8, 10);
GO

-->>>>>>Invoke the Procedure<<<<<<<-----------------
EXECUTE Purchasing.uspGetAirFreightSuppliers;
GO



-->>>>>>Return procedure definition<<<<<<------------ 
SELECT *
FROM sys.sql_modules;

-->>>>>>Return procedure definition<<<<<<------------ 
--Set results to text--------------------------------
SELECT object_id, Definition
FROM sys.sql_modules
WHERE object_id = 535672956; 

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
USE WideWorldImporters;
GO

DROP PROCEDURE IF EXISTS Purchasing.uspGetStockItems;
GO

CREATE OR ALTER PROCEDURE Purchasing.uspGetStockItems
AS
SET NOCOUNT ON
BEGIN
 SELECT si.StockItemName, si.SupplierID, s.SupplierName
 FROM Warehouse.StockItems AS si
 JOIN
 Purchasing.Suppliers AS s
 ON si.SupplierID = s.SupplierID
 ORDER BY si.StockItemName;
END;

-->>>>>>>Invoke the Procedure<<<<<--------------------------------
EXECUTE Purchasing.uspGetStockItems;
GO