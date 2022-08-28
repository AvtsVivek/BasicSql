/***Lesson 6 Lab-***/
/***Using Recursive Table Expressions***/

USE WideWorldImporters;
GO

-- First esure the table is present.

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

GO
**********************************************/

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
	SELECT e.empid, e.name, e.mgrid, e.title FROM Examples.Employees e
		INNER JOIN Emp_CTE ecte 
		  ON ecte.empid = e.mgrid
)
SELECT * FROM Emp_CTE;

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




