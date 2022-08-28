-- 1.
-- The Sales.Orders table has CustomerId and date time of the order placed.
-- Get the number of unique customers who placed orders each year. In other words, for each year, get the total count of customers who placed orders.

-- There are two ways to get this.

-- This is direct way.
SELECT YEAR(OrderDate) AS ORDER_YEAR, COUNT(DISTINCT CustomerID) AS CUSTOMER_COUNT  FROM Sales.Orders
GROUP BY YEAR(OrderDate) 
ORDER BY YEAR(OrderDate) 

-- Here is using derived query.
--Below, the outer query summarizes the results of the orders placed into derived table (derived_year)
SELECT order_year, COUNT(DISTINCT CustomerID) AS customer_count
FROM (SELECT YEAR(OrderDate) AS order_year, CustomerID
	  FROM Sales.Orders) AS derived_year
GROUP BY order_year
ORDER BY order_year;

-- Now lets try out using CTE
WITH Customers_Year(order_year, CustomerID)
AS 
(
	SELECT YEAR(OrderDate) AS order_year, CustomerID
	FROM Sales.Orders
)

SELECT order_year, COUNT(DISTINCT CustomerID) FROM Customers_Year
GROUP BY order_year
ORDER BY order_year

-- 2nd question.
-- For each year, get the customer and number of times each customer who placed orders.

-- With CTE, this is the query
WITH Customers_Year(order_year, CustomerID)
AS 
(
	SELECT YEAR(OrderDate) AS order_year, CustomerID
	FROM Sales.Orders
)
SELECT order_year, CustomerID, COUNT(CustomerID) AS Total_Orders_Count FROM Customers_Year
GROUP BY order_year, CustomerID
ORDER BY order_year, CustomerID

-- Use the following to Verify.
SELECT COUNT(*) FROM Sales.Orders WHERE CustomerID = 1 AND YEAR(OrderDate) = 2013
SELECT COUNT(*) FROM Sales.Orders WHERE CustomerID = 2 AND YEAR(OrderDate) = 2013
SELECT COUNT(*) FROM Sales.Orders WHERE CustomerID = 3 AND YEAR(OrderDate) = 2013

-- In Similar Lines, Get the orders taken by each sales person for each year.
SELECT * FROM Sales.Orders WHERE CustomerID = 1 AND YEAR(OrderDate) = 2013

WITH Sales_Data(Order_Year, SalespersonPersonID, OrderID)
AS
(
	SELECT YEAR(OrderDate) Order_Year, SalespersonPersonID, OrderID FROM Sales.Orders
)

SELECT Order_Year, SalespersonPersonID, COUNT(OrderID) ORDER_COUNT FROM Sales_Data
GROUP BY SalespersonPersonID, Order_Year
ORDER BY SalespersonPersonID, Order_Year

SELECT COUNT(*) FROM Sales.Orders WHERE YEAR(OrderDate) = 2013 AND SalespersonPersonID = 2
SELECT COUNT(*) FROM Sales.Orders WHERE YEAR(OrderDate) = 2014 AND SalespersonPersonID = 2
SELECT COUNT(*) FROM Sales.Orders WHERE YEAR(OrderDate) = 2015 AND SalespersonPersonID = 2


