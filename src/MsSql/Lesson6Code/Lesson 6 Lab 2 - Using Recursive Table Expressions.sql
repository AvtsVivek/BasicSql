/***Lesson 6 Lab-***/
/***Using Recursive Table Expressions***/

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
	
--------------------------------------------------

WITH Emp_CTE
	AS 
	(
	SELECT empid, name, mgrid AS Manager_ID, title
	  FROM Examples.Employees
	  WHERE mgrid IS NULL
	UNION ALL
	SELECT e.empid, e.name, e.mgrid, e.title
	  FROM Examples.Employees e
		INNER JOIN Emp_CTE ecte 
		  ON ecte.empid = e.mgrid
)
SELECT *
FROM Emp_CTE;








-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>....
--Simple Recursive CTE-----------------------------
--;WITH Numbers AS
--(
--    SELECT n = 1
--    UNION ALL
--    SELECT n + 1
--    FROM Numbers
--    WHERE n+1 <= 10
--)
--SELECT n
--FROM Numbers
------------------------------
