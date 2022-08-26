/***Lesson 6 Lab 1 ***/
/***Using Table Expressions***/

USE WideWorldImporters;
GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
----------------------------Using Derived Table------------------------------
--Derived table - derived_year - is used to retrieve info regarding orders
--placed by distinct customers per year
--Outer query summarizes the results of the orders placed into derived table (derived_year)

/**Return the number of orders placed by distinct customers per year***/
SELECT order_year, COUNT(DISTINCT CustomerID) AS customer_count
FROM (SELECT YEAR(OrderDate) AS order_year,CustomerID
	  FROM Sales.Orders) AS derived_year
GROUP BY order_year
ORDER BY order_year;

/***Return the number of orders placed by distinct customers***
***of Salesperson with ID 7 per year***************************/
SELECT order_year, COUNT(DISTINCT CustomerID) AS customer_count
FROM (SELECT YEAR(OrderDate) AS order_year,
		CustomerID
		FROM Sales.Orders
		WHERE SalespersonPersonID = 7) AS derived_year
GROUP BY order_year
ORDER BY order_year;


/***An argument may be passed to a derived table********
*********Using the previous query***********************/
DECLARE @spersonid INT = 7;
SELECT order_year, COUNT(DISTINCT CustomerID) AS customer_count
FROM (SELECT YEAR(OrderDate) AS order_year,
		CustomerID
		FROM Sales.Orders
		WHERE SalespersonPersonID = @spersonid) AS derived_year
GROUP BY order_year
ORDER BY order_year;


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
------------Using CTE--------------------------------------------------

/****Return the yearly number of orders for each sales person********/

-- Define the CTE expression name and column list.
WITH Orders_CTE (SalespersonPersonID, OrderID, SalesYear)
AS
-- Define the CTE query.
(
    SELECT SalespersonPersonID, OrderID, YEAR(OrderDate) AS SalesYear
    FROM Sales.Orders
    WHERE SalespersonPersonID IS NOT NULL
)
-- Define the outer query referencing the CTE name.
SELECT SalespersonPersonID, COUNT(OrderID) AS TotalOrders, SalesYear
FROM Orders_CTE
GROUP BY SalesYear, SalespersonPersonID
ORDER BY SalespersonPersonID, SalesYear;

/****Return the yearly number of orders for sales person**
*****using an argument @spid to return number of orders**
*****for a specific sales person**************************/
DECLARE @spid INT = 2;
WITH Orders_CTE (SalespersonPersonID, OrderID, SalesYear)
AS
-- Define the CTE query.
(
    SELECT SalespersonPersonID, OrderID, YEAR(OrderDate) AS SalesYear
    FROM Sales.Orders
    WHERE SalespersonPersonID = @spid
)
-- Define the outer query referencing the CTE name.
SELECT SalespersonPersonID, COUNT(OrderID) AS TotalOrders, SalesYear
FROM Orders_CTE
GROUP BY SalesYear, SalespersonPersonID
ORDER BY SalespersonPersonID, SalesYear;

/****Return the yearly number of orders ******************
*****using IN to return number of orders******************
*****for a specific set of  sales people*****************/
WITH Orders_CTE (SalespersonPersonID, OrderID, SalesYear)
AS
-- Define the CTE query.
(
    SELECT SalespersonPersonID, OrderID, YEAR(OrderDate) AS SalesYear
    FROM Sales.Orders
    WHERE SalespersonPersonID IN (2, 7, 8)
)
-- Define the outer query referencing the CTE name.
SELECT SalespersonPersonID, COUNT(OrderID) AS TotalOrders, SalesYear
FROM Orders_CTE
GROUP BY SalesYear, SalespersonPersonID
ORDER BY SalespersonPersonID, SalesYear;

