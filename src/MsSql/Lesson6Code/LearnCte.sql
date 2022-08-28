-- Simplist CTE
;WITH Sales_Orders AS 
(
	SELECT * FROM Sales.Orders
)
SELECT * FROM Sales_Orders 

-- With some specified columns
;WITH Sales_Orders (OrderID, CustomerID, SalespersonPersonId )
AS 
(
	SELECT OrderID, CustomerID, SalespersonPersonId  FROM Sales.Orders
)
SELECT * FROM Sales_Orders 

--This is another simple example.

;WITH Numbers AS
(
    SELECT n = 1
    UNION ALL
    SELECT n + 1
    FROM Numbers
    WHERE n+1 <= 10
)
SELECT n
FROM Numbers

-- Employee Hirerchy

-- First esure the table is present. Else create it.

-- SELECT * FROM [Examples].[Employees]

--CREATE THE SCHEMA, TABLE, and DATA-----------------
/****************************************************
USE WideWorldImporters
GO

CREATE SCHEMA Examples;
GO

CREATE TABLE [Examples].[Employees](
	[empid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](20) NOT NULL,
	[title] [nvarchar](30) NOT NULL,
	[mgrid] [int] NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[empid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [Examples].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_Employees_Employees] FOREIGN KEY([mgrid])
REFERENCES [Examples].[Employees] ([empid])
GO

ALTER TABLE [Examples].[Employees] CHECK CONSTRAINT [FK_Employees_Employees]
GO

USE WideWorldImporters
GO

INSERT INTO Examples.Employees (name,title,mgrid)
     VALUES
           (N'Mickey', N'CEO',NULL),
		   (N'Minnie', N'VP Animation',1),
		   (N'Donald', N'Story Manager',2),
		   (N'Daisy', N'Story Writer',3),
		   (N'Grumpy', N'Story Research',2),
		   (N'Happy', N'Story Development',5),
		   (N'Dopey', N'Story Development',5);


Insert into Examples.Employees values('Sathya', 'Director', NULL);
Insert into Examples.Employees values('Kavin', 'Senior Manager', 1);
Insert into Examples.Employees values('Kayal', 'Senior Manager', 1);
Insert into Examples.Employees values('Anbu', 'Manager', 2);
Insert into Examples.Employees values('Naga', 'Manager', 3);
Insert into Examples.Employees values('Shanthi', 'Lead', 4);
Insert into Examples.Employees values('Krishna', 'Lead', 5);
Insert into Examples.Employees values('Prithivi', 'Senior Developer', 6);
Insert into Examples.Employees values('Swathi', 'Senior Developer', 7);
Insert into Examples.Employees values('Indu', 'Developer', 8);
Insert into Examples.Employees values('Vijay', 'Developer', 9);
Insert into Examples.Employees values('Vivek', 'Senior Developer', 6);

GO
**********************************************/

-- Step 1. Get the table as it is
;WITH Employee_CTE
AS 
(
	SELECT * FROM [Examples].[Employees]
)
SELECT * FROM Employee_CTE

-- Step 2, with all the column names explicitly specified.
;WITH Employee_CTE (empid, name, title, mgrid)
AS 
(
	SELECT empid, name, title, mgrid FROM [Examples].[Employees]
)
SELECT * FROM Employee_CTE

-- Step 3
;WITH Employee_CTE (empid, name, title, mgrid)
AS 
(
    --initialization
	SELECT empid, name, title, mgrid FROM [Examples].[Employees]
	WHERE mgrid IS NULL
	UNION ALL
	--recursive execution
	SELECT e.empid, e.name, e.title, e.mgrid FROM [Examples].[Employees] AS e
	INNER JOIN Employee_CTE ecte
	ON ecte.empid = e.mgrid
)
SELECT * FROM Employee_CTE ORDER BY empid

SELECT * FROM Examples.Employees;

;WITH Employee_CTE 
AS (
  SELECT    empid,
            name,
            mgrid
       , 0 AS hierarchy_level
  FROM [Examples].[Employees]
  WHERE mgrid IS NULL 
  UNION ALL  
  SELECT    e.empid,
            e.name,
            e.mgrid,
			hierarchy_level + 1
  FROM [Examples].[Employees] e INNER JOIN 
  Employee_CTE AS ch ON e.mgrid = ch.empid
)

SELECT ch.empid AS employee_id,
       ch.name AS employee_name,
       ch.mgrid AS managerId,
	   e.name,
       hierarchy_level
FROM Employee_CTE ch
LEFT JOIN [Examples].[Employees] e
ON ch.mgrid = e.empid
ORDER BY ch.hierarchy_level, ch.mgrid;

-- HERe again in a different way
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

-- Let's create a recursive CTE that returns the hierarchy of the particular person in the employee table. In the below example, will get the Kavin's (Emp_id is 2) reportees hierarchy.
;WITH Emp_Cte AS
(
--initialization
SELECT empid, name, mgrid
FROM Examples.Employees
WHERE mgrid  = 2
UNION ALL
--recursive execution
SELECT e.empid,e.name, e.mgrid
FROM Examples.Employees e INNER JOIN Emp_Cte m
ON e.mgrid = m.empid
)
SELECT * FROM Emp_Cte;

