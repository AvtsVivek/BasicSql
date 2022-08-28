-- First create a Employee Salary table.
/****************************************************
USE WideWorldImporters
GO

CREATE SCHEMA Examples;
GO

CREATE TABLE [Examples].[EmployeeSalary](
	[empid] [int] IDENTITY(1,1) NOT NULL,
	[salary] [int] NULL
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
( [empid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE WideWorldImporters
GO


Insert into Examples.EmployeeSalary values(1000);
Insert into Examples.EmployeeSalary values(2000);
Insert into Examples.EmployeeSalary values(3000);
Insert into Examples.EmployeeSalary values(4000);
Insert into Examples.EmployeeSalary values(5000);
Insert into Examples.EmployeeSalary values(6000);
Insert into Examples.EmployeeSalary values(7000);
Insert into Examples.EmployeeSalary values(8000);
Insert into Examples.EmployeeSalary values(9000);
Insert into Examples.EmployeeSalary values(10000);
Insert into Examples.EmployeeSalary values(11000);
Insert into Examples.EmployeeSalary values(12000);

SELECT * FROM Examples.EmployeeSalary 

GO
**********************************************/

-- FIRST WAY: USING NOT in 
-- Step 1
SELECT * FROM Examples.Employeesalary
WHERE salary NOT IN (SELECT MAX(salary) FROM Examples.Employeesalary)
ORDER BY Salary DESC

-- Stpe 2
SELECT MAX(Salary) AS SecondHighestSalary FROM Examples.Employeesalary
WHERE salary NOT IN (SELECT MAX(salary) FROM Examples.Employeesalary)

-- SECOND WAY: Using Less than
-- Step 1
SELECT * FROM Examples.Employeesalary
WHERE salary < (SELECT MAX(salary) FROM Examples.Employeesalary)
ORDER BY Salary DESC

-- Stpe 2
SELECT MAX(Salary) AS SecondHighestSalary FROM Examples.Employeesalary
WHERE salary < (SELECT MAX(salary) FROM Examples.Employeesalary)

-- https://www.youtube.com/watch?v=mFdyfB7RdgA
-- https://www.youtube.com/watch?v=ms-99n1KbT0

-- THIRD WAY
/******SELECT Query with OFFSET-FETCH clause   ******/
--10 rows returned starting with the 6 row of previous query----
SELECT SALARY AS SecondHighestSalary
FROM Examples.Employeesalary
ORDER BY Salary DESC
OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY;

-- Forth way
SELECT TOP 1 SALARY FROM (
SELECT TOP 2 * FROM Examples.Employeesalary
ORDER BY Salary DESC) AS innerQuery
ORDER BY Salary ASC

-- If you want 4th highest salary
SELECT TOP 1 SALARY FROM (
SELECT TOP 4 * FROM Examples.Employeesalary -- put 4 here
ORDER BY Salary DESC) AS innerQuery
ORDER BY Salary ASC

-- If you want 5th highest salary
SELECT TOP 1 SALARY FROM (
SELECT TOP 5 * FROM Examples.Employeesalary -- Put 5 here
ORDER BY Salary DESC) AS innerQuery
ORDER BY Salary ASC




