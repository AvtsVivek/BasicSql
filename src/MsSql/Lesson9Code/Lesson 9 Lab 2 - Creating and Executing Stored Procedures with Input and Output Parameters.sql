/****Lesson 9 Lab***********/
/****Creating and Executing Stored Procedures with Input and Output Parameters*****/

USE WideWorldImporters;
GO

--INPUT Parameters
USE WideWorldImporters;
GO

DROP PROCEDURE IF EXISTS Purchasing.uspGetSuppliersByDeliveryMethod;
GO

CREATE OR ALTER PROCEDURE Purchasing.uspGetSuppliersByDeliveryMethod
	@DeliveryMethodID AS int
AS
BEGIN
    SELECT SupplierName, PhoneNumber, WebsiteURL, DeliveryMethodID
    FROM Purchasing.Suppliers
	WHERE DeliveryMethodID = @DeliveryMethodID;
END;
GO

-->>>>>>Invoke the Procedure<<<<<<<-----------------
EXECUTE Purchasing.uspGetSuppliersByDeliveryMethod @DeliveryMethodID = 10;
GO

-------------------------------------------------------------------------
--INPUT and OUTPUT Parameters
USE WideWorldImporters;
GO

DROP PROCEDURE IF EXISTS Purchasing.uspGetSuppliersByDeliveryMethod;
GO

CREATE OR ALTER PROCEDURE Purchasing.uspGetSuppliersByDeliveryMethod
	@DeliveryMethodID AS int,
	@numSuppliers AS INT = 0 OUTPUT
AS
BEGIN
    SELECT SupplierName, PhoneNumber, WebsiteURL, DeliveryMethodID
    FROM Purchasing.Suppliers
	WHERE DeliveryMethodID = @DeliveryMethodID;
	SET @numSuppliers = @@ROWCOUNT;
	RETURN;
END;
GO

-->>>>>>Invoke the Procedure<<<<<<<-----------------
DECLARE @numofSuppliers AS INT
EXECUTE Purchasing.uspGetSuppliersByDeliveryMethod @DeliveryMethodID = 10,
		@numSuppliers = @numofSuppliers OUTPUT;
SELECT @numofSuppliers AS "Number of Suppliers using this Shipping Method";
GO

/***************************************************************/
/***************************************************************/

USE WideWorldImporters;
GO

DROP PROCEDURE IF EXISTS Purchasing.uspGetStockItems;
GO


--INPUTSupplierID
--OUTPUT Number of StockItems supplied by stated Supplier
CREATE OR ALTER PROCEDURE Purchasing.uspGetStockItems
	@SupplierID AS int,
	@numStockItems AS INT = 0 OUTPUT
AS
SET NOCOUNT ON
BEGIN
 SELECT si.StockItemName, si.SupplierID, s.SupplierName
 FROM Warehouse.StockItems AS si
 JOIN
 Purchasing.Suppliers AS s
 ON si.SupplierID = s.SupplierID
 WHERE si.SupplierID = @SupplierID
 ORDER BY si.StockItemName;
 SET @numStockItems = @@ROWCOUNT;
 RETURN;
END;

-->>>>>>>Invoke the Procedure<<<<<--------------------------------
---------Using SupplierID 12
DECLARE @numofStockitems AS INT
EXECUTE Purchasing.uspGetStockItems @SupplierID = 12,
		@numStockitems = @numofStockItems OUTPUT;
SELECT @numofStockitems AS "Number of StockItems Supplied by this Supplier";
GO