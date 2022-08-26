/***Lesson 2 Lab 3***/
/***Using Queries with Multiple JOIN Operators***/

USE WideWorldImporters;
GO

/***INNER JOIN of SupplierTransactions and PurchasOrders tables***********/
-----Joining on SupplierID------------------------------------------------
-----2442780 rows---------------------------------------------------------
SELECT st.SupplierID, st.PurchaseOrderID, po.SupplierID, po.PurchaseOrderID
FROM Purchasing.SupplierTransactions AS st
JOIN Purchasing.PurchaseOrders AS po
ON st.SupplierID = po.SupplierID;


/****Compositie Join using AND******************************************/
---Matching SupplierID and PurchaseOrderID------------------------------
---2072 rows------------------------------------------------------------
SELECT st.SupplierID, st.PurchaseOrderID, po.SupplierID, po.PurchaseOrderID
FROM Purchasing.SupplierTransactions AS st
JOIN Purchasing.PurchaseOrders AS po
ON st.SupplierID = po.SupplierID
AND st.PurchaseOrderID = po.PurchaseOrderID;

/****Multi Join Query****************************************************/
---Joining SupplierTransactions, PurchaseOrders, and Suppliers tables-----
SELECT s.SupplierName, st.SupplierID, st.PurchaseOrderID, po.SupplierID, po.PurchaseOrderID
FROM Purchasing.SupplierTransactions AS st
JOIN Purchasing.PurchaseOrders AS po
ON st.SupplierID = po.SupplierID
AND st.PurchaseOrderID = po.PurchaseOrderID
JOIN Purchasing.Suppliers AS s
ON st.SupplierID = s.SupplierID

/**Composite, Multi Join query with Ordering******/
SELECT s.SupplierName, st.SupplierID, st.PurchaseOrderID, po.SupplierID, po.PurchaseOrderID
FROM Purchasing.SupplierTransactions AS st
JOIN Purchasing.PurchaseOrders AS po
ON st.SupplierID = po.SupplierID
AND st.PurchaseOrderID = po.PurchaseOrderID
JOIN Purchasing.Suppliers AS s
ON st.SupplierID = s.SupplierID
ORDER BY s.SupplierName;


/**Composite, Multi Join query with Ordering******/
--EXAMPLE: RETURN ALL SUPPLIERS WITH THEIR PURCHASE ORDERS ORDERING BY SUPPLIERS then PURCHASE ORDER ID--
SELECT s.SupplierName, po.PurchaseOrderID
FROM Purchasing.SupplierTransactions AS st
JOIN Purchasing.PurchaseOrders AS po
ON st.SupplierID = po.SupplierID
AND st.PurchaseOrderID = po.PurchaseOrderID
JOIN Purchasing.Suppliers AS s
ON st.SupplierID = s.SupplierID
ORDER BY s.SupplierName, po.PurchaseOrderID;

