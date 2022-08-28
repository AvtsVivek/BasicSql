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