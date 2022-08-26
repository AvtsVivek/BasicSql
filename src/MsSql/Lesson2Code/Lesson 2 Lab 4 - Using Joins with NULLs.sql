/***Lesson 2 Lab 4***/
/***Using JOINS with NULLs***/

USE WideWorldImporters;
GO

--Standard SELECT from StockItems table
SELECT si.StockItemName, si.ColorID
FROM Warehouse.StockItems AS si
ORDER BY si.StockItemName;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>--
/****INNER JOIN matching StockItems and their Color****/
--128 rows---------------------------------------------
--Only StockItems having a valued color are returned---
SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
ORDER BY si.StockItemName;

/****LEFT OUTER JOIN returns all StockItems regardless
*****of whether or not color is valued****/
---Ordered by StockItemName--------------------------

SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
LEFT JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
ORDER BY si.StockItemName;

/****LEFT OUTER JOIN returns all StockItems regardless
*****of whether or not color is valued****/
---Ordered by ColorName--------------------
SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
LEFT JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
ORDER BY c.ColorName;

/****StockItems that have no valued color********/
SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
LEFT JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
WHERE c.ColorName IS NULL;


/****RIGHT OUTER JOIN returns all ColorNames regardless
*****of whether or not StockItemName is valued****/

SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
RIGHT JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
ORDER BY si.StockItemName;


--Returns Items in stock and their Colors-------
SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
RIGHT JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
WHERE si.StockItemName IS NOT NULL
ORDER BY si.StockItemName;

--Returns Colors not used for items in stock--------------------
SELECT si.StockItemName, c.Colorname
FROM Warehouse.StockItems AS si
RIGHT JOIN
Warehouse.Colors AS c
ON si.ColorID = c.ColorID
WHERE si.StockItemName IS NULL
ORDER BY si.StockItemName;
