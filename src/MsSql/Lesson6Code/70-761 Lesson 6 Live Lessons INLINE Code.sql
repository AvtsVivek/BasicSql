/* 70-761 Lesson 6 Live Lessons INLINE Code */

USE WideWorldImporters;
GO

SELECT FullName, PreferredName FROM Application.People WHERE PreferredName = 'Adam'

SELECT  FullName, PreferredName
FROM
(SELECT * FROM Application.People) AS PersonDerivedTable
WHERE PreferredName = 'Adam';

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
----------------------------Using Derived Table------------------------------
--Derived table - derived_year - is used to retrieve info regarding orders
--placed by distinct customers per year
--Outer query summarizes the results of the orders placed into derived table (derived_year)

SELECT YEAR(OrderDate) AS order_year, CustomerID FROM Sales.Orders

SELECT OrderDate, COUNT(CustomerID) FROM Sales.Orders
GROUP BY OrderDate

SELECT OrderDate, COUNT(DISTINCT CustomerID) FROM Sales.Orders
GROUP BY OrderDate

SELECT YEAR(OrderDate) AS ORDER_YEAR, COUNT(CustomerID) AS CUSTOMER_COUNT  FROM Sales.Orders
GROUP BY YEAR(OrderDate) 
ORDER BY YEAR(OrderDate) 

SELECT YEAR(OrderDate) AS ORDER_YEAR, COUNT(DISTINCT CustomerID) AS CUSTOMER_COUNT  FROM Sales.Orders
GROUP BY YEAR(OrderDate) 
ORDER BY YEAR(OrderDate) 

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



-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
------------Using CTE--------------------------------------------------

-- Define the CTE expression name and column list.
WITH Sales_CTE (SalespersonPersonID, OrderID, SalesYear)
AS
-- Define the CTE query.
(
    SELECT SalespersonPersonID, OrderID, YEAR(OrderDate) AS SalesYear
    FROM Sales.Orders
    WHERE SalespersonPersonID IS NOT NULL
)
-- Define the outer query referencing the CTE name.
SELECT SalespersonPersonID, COUNT(OrderID) AS TotalSales, SalesYear
FROM Sales_CTE
GROUP BY SalesYear, SalespersonPersonID
ORDER BY SalespersonPersonID, SalesYear;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/***Lesson 6.4 ***/
/***Constructing Recursive Table Expressions to Meet Business Requirements***/

USE WideWorldImporters;
GO

WITH Emp_CTE
	AS
	(
	SELECT empid, name, CAST(CONCAT('\', empid, '\') AS varchar(1500)) AS Corporate_Hierarchy
	  FROM Examples.Employees
	  WHERE mgrid IS NULL
	UNION ALL
	SELECT e.empid, e.name,CAST(CONCAT(Corporate_Hierarchy, e.empid, '\') AS varchar(1500)) AS Corporate_Hierarchy
	  FROM Examples.Employees e
		INNER JOIN Emp_CTE ecte
		  ON e.mgrid = ecte.empid
	)
	SELECT *
	FROM Emp_CTE;


