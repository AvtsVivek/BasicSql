/***Lesson 2 Lab 2***/
/***Implementing  CROSS JOIN on Provided Tables***/

USE WideWorldImporters;
GO

--->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--INNER JOIN returns Supplier Name and Category
SELECT s.SupplierName, c.SupplierCategoryName
FROM Purchasing.Suppliers AS s
  JOIN Purchasing.SupplierCategories as c
  ON s.SupplierCategoryID = c.SupplierCategoryID
  ORDER BY s.SupplierName, c.SupplierCategoryName;

--->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--CROSS JOIN returns each Supplier name paired with all Categories

SELECT COUNT(*) FROM Purchasing.Suppliers -- Gives 13

SELECT COUNT(*) FROM Purchasing.SupplierCategories -- Gives 9

SELECT 13*9 AS TotalCount -- Gives cross product count

SELECT s.SupplierName, c.SupplierCategoryName
FROM Purchasing.Suppliers AS s
CROSS JOIN Purchasing.SupplierCategories as c
ORDER BY s.SupplierName, c.SupplierCategoryName;

--->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--EXTRA -- SAMPLE SELF JOIN--------------------------

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


--->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
---Employees table listing--------------------
SELECT empid, name, title, mgrid AS ManagerID 
FROM Examples.Employees;

--->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
---Use INNER JOIN to return result set without NULLs
SELECT E.empid,
  E.name AS employee,
  M.name AS manager,
  E.mgrid as managerID 
FROM Examples.Employees AS E
  INNER JOIN Examples.Employees AS M
    ON E.mgrid = M.empid;

--->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
---Use LEFT OUTER JOIN to return result set with NULLS
SELECT E.empid,
  E.name AS employee,
  M.name AS manager,
  E.mgrid as managerID 
FROM Examples.Employees AS E
  LEFT OUTER JOIN Examples.Employees AS M
    ON E.mgrid = M.empid;


/*---Cleanup Code if you no longer wish to work with the table and schema----
DROP TABLE IF EXISTS Examples.Employees;
GO

DROP SCHEMA IF EXISTS Examples;
GO

*/
