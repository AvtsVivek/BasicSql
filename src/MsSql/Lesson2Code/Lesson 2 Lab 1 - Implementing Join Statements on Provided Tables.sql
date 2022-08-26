/***Lesson 2 Lab 1***/
/***Implementing Join Statements on Provided Tables***/

USE WideWorldImporters;
GO

--Querying Cities and StateProvinces tables----------
/******(INNER) JOIN with aliases******/
SELECT C.CityName, P.StateProvinceCode, P.StateProvinceName
FROM Application.StateProvinces AS P
JOIN Application.Cities AS C
  ON P.StateProvinceID = C.StateProvinceID
  ORDER BY C.CityName, P.StateProvinceCode;

--Querying Cities and StateProvinces tables----------
--All cities along with their states and Sales Territories
SELECT C.CityName, P.StateProvinceName, p.SalesTerritory
FROM Application.StateProvinces AS P
JOIN Application.Cities AS C
  ON P.StateProvinceID = C.StateProvinceID
  ORDER BY C.CityName, P.StateProvinceCode;

--Querying Cities and StateProvinces tables----------
---Cities and States in the Mideast Sales Territory----
SELECT C.CityName, P.StateProvinceName
FROM Application.StateProvinces AS P
JOIN Application.Cities AS C
  ON P.StateProvinceID = C.StateProvinceID
  WHERE p.SalesTerritory = 'Mideast'
  ORDER BY C.CityName, P.StateProvinceCode;


--Querying Cities and StateProvinces tables----------
/******LEFT OUTER JOIN with aliases******/
SELECT C.CityName, P.StateProvinceName, p.SalesTerritory
FROM Application.StateProvinces AS P
LEFT JOIN Application.Cities AS C
  ON P.StateProvinceID = C.StateProvinceID
  ORDER BY C.CityName, P.StateProvinceCode;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Querying StockItems and Suppliers tables---------------
/** INNER JOIN******************************************/
SELECT si.StockItemName, si.SupplierID, s.SupplierName
FROM Warehouse.StockItems AS si
JOIN
Purchasing.Suppliers AS s
ON si.SupplierID = s.SupplierID
ORDER BY si.StockItemName;

--Querying StockItems and Suppliers tables---------------
/** LEFT OUTER JOIN*************************************/
SELECT si.StockItemName, si.SupplierID, s.SupplierName
FROM Warehouse.StockItems AS si
LEFT OUTER JOIN
Purchasing.Suppliers AS s
ON si.SupplierID = s.SupplierID
ORDER BY si.StockItemName;


--Querying StockItems and Suppliers tables---------------
/** RIGHT OUTER JOIN*************************************/
SELECT si.StockItemName, si.SupplierID, s.SupplierName
FROM Warehouse.StockItems AS si
RIGHT OUTER JOIN
Purchasing.Suppliers AS s
ON si.SupplierID = s.SupplierID
ORDER BY si.StockItemName;


--Querying StockItems and Suppliers tables---------------
/** CROSS JOIN******************************************/
--NOTE the ON clause removed (commented out)-------------
SELECT si.StockItemName, si.SupplierID, s.SupplierName
FROM Warehouse.StockItems AS si
CROSS JOIN
Purchasing.Suppliers AS s
--ON si.SupplierID = s.SupplierID
ORDER BY si.StockItemName;

