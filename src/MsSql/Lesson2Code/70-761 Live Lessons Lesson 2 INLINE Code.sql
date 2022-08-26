/* 70-761 Lesson 2 Live Lessons INLINE Code */

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Lesson 2.1 Writing Queries With Join Statements Based on Provided Tables, Data, and Requirements------

/******(INNER) JOIN with no aliases******/
USE WideWorldImporters
GO

SELECT CustomerName, CustomerCategoryName
FROM Sales.Customers
JOIN Sales.CustomerCategories
  ON Customers.CustomerCategoryID = CustomerCategories.CustomerCategoryID;
 

/******(INNER) JOIN with aliases******/
SELECT c.CustomerName, ccat.CustomerCategoryName
FROM Sales.Customers as c
JOIN Sales.CustomerCategories as ccat
  ON c.CustomerCategoryID = ccat.CustomerCategoryID;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Lesson 2.2 Determining Proper Usage of INNER JOIN, LEFT/RIGHT/FULL OUTER JOIN, and CROSS JOIN--

/******(INNER) JOIN with aliases******/
SELECT C.CityName, P.StateProvinceCode, P.StateProvinceName
FROM Application.StateProvinces AS P
JOIN Application.Cities AS C
  ON P.StateProvinceID = C.StateProvinceID
  ORDER BY C.CityName, P.StateProvinceCode;


/******LEFT OUTER JOIN with aliases******/
SELECT C.CityName, P.StateProvinceCode, P.StateProvinceName
FROM Application.StateProvinces AS P
LEFT OUTER JOIN Application.Cities AS C
  ON P.StateProvinceID = C.StateProvinceID
  ORDER BY C.CityName, P.StateProvinceCode;
/* DS
Not the best example for an outer join.
This query returns the same result as the orevious one.
*/

/******CROSS JOIN with aliases******/
----Notice no ON clause-------------
SELECT C.CityName, P.StateProvinceCode, P.StateProvinceName
FROM Application.StateProvinces AS P
CROSS JOIN Application.Cities AS C
  ORDER BY C.CityName, P.StateProvinceCode;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Lesson 2.5 Constructing Multiple JOIN Operators Using AND and OR---
USE WideWorldImporters
GO


/****Compositie Join using AND**********/
SELECT st.SupplierID, st.PurchaseOrderID, po.SupplierID, po.PurchaseOrderID
FROM Purchasing.SupplierTransactions AS st
JOIN Purchasing.PurchaseOrders AS po
ON st.SupplierID = po.SupplierID
AND st.PurchaseOrderID = po.PurchaseOrderID;

/****Multi Join Query**************/
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

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Lesson 2.8 Writing Queries with NULLs on Joins---------
USE WideWorldImporters
GO

SELECT si.StockItemName, si.ColorID
FROM Warehouse.StockItems AS si
ORDER BY si.StockItemName;

--128 rows------------------------------------
SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
ORDER BY si.StockItemName;


SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
LEFT JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
ORDER BY si.StockItemName;


SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
LEFT JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
WHERE c.ColorName IS NULL;

SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
LEFT JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
ORDER BY c.ColorName;


SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
RIGHT JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
ORDER BY si.StockItemName;


--Items in stock and their Colors----------------------------
SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
RIGHT JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
WHERE si.StockItemName IS NOT NULL
ORDER BY si.StockItemName;

--Colors not used for items in stock--------------------
SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
RIGHT JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
WHERE si.StockItemName IS NULL
ORDER BY si.StockItemName;
