/****Lesson 9 Lab***********/
/****Creating Views and Using View Options*****/

USE WideWorldImporters;
GO

/*Compare the CREATE VIEW Syntax with a Sample VIEW statement and Options */

--------------------------------------------------------------------------------------------------
/*
CREATE OR ALTER VIEW [ schema_name . ] view_name [ (column [ ,...n ] ) ] 
[ WITH <view_attribute> [ ,...n ] ] 
AS select_statement 
[ WITH CHECK OPTION ] 
[ ; ]

<view_attribute> ::= 
{
    [ ENCRYPTION ]
    [ SCHEMABINDING ]
    [ VIEW_METADATA ]     
} 
 */

USE AdventureWorks2016CTP3 ;
GO

DROP VIEW IF EXISTS HumanResources.vEmployeeHireDate;
GO

CREATE OR ALTER VIEW HumanResources.vEmployeeHireDate
	WITH SCHEMABINDING
AS
SELECT p.FirstName, p.LastName, emp.HireDate
	FROM HumanResources.Employee AS emp
	 JOIN Person.Person AS  p
	ON emp.BusinessEntityID = p.BusinessEntityID;
GO

SELECT *
	FROM HumanResources.vEmployeeHireDate;
GO

--------------------------------------------------------------

USE AdventureWorks2016CTP3 ;
GO


ALTER VIEW HumanResources.vEmployeeHireDate
	WITH SCHEMABINDING
AS
SELECT p.FirstName, p.LastName, emp.HireDate
	FROM HumanResources.Employee AS emp
		JOIN Person.Person AS  p
	ON emp.BusinessEntityID = p.BusinessEntityID
WHERE HireDate < CONVERT(DATETIME,'20090101',101) ;
GO
  
SELECT *
	FROM HumanResources.vEmployeeHireDate;
GO

----ALTER VIEW with invalid ORDER BY---------
ALTER VIEW HumanResources.vEmployeeHireDate
	WITH SCHEMABINDING
AS
SELECT p.FirstName, p.LastName, emp.HireDate
	FROM HumanResources.Employee AS emp
		JOIN Person.Person AS  p
	ON emp.BusinessEntityID = p.BusinessEntityID
ORDER BY p.LastName;
GO

----ALTER VIEW with valid ORDER BY including TOP---------
ALTER VIEW HumanResources.vEmployeeHireDate
	WITH SCHEMABINDING
AS
SELECT TOP 10 p.FirstName, p.LastName, emp.HireDate
	FROM HumanResources.Employee AS emp
		JOIN Person.Person AS  p
	ON emp.BusinessEntityID = p.BusinessEntityID
ORDER BY p.LastName;
GO

SELECT LastName, FirstName, HireDate
	FROM HumanResources.vEmployeeHireDate;
GO

-------------Delete the View------------------
DROP VIEW HumanResources.vEmployeeHireDate;
GO


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--USING WIDEWORLDIMPORTERS------------------------------
--Querying Cities and StateProvinces tables----------
---Cities and States in the Mideast Sales Territory----

USE WideWorldImporters;
GO

DROP VIEW IF EXISTS Application.vMideastSalesTerritory;
GO
--Create view to display cities and states in the 
--Mideast Sales Territory

--Incorrect Use of ORDER BY--------------------
CREATE OR ALTER VIEW Application.vMideastSalesTerritory
	WITH SCHEMABINDING
AS
SELECT C.CityName, P.StateProvinceName
FROM Application.StateProvinces AS P
JOIN Application.Cities AS C
  ON P.StateProvinceID = C.StateProvinceID
  WHERE p.SalesTerritory = 'Mideast'
  ORDER BY C.CityName, P.StateProvinceCode;
GO

--Correct Use of ORDER BY--------------------------
USE WideWorldImporters;
GO

DROP VIEW IF EXISTS Application.vMideastSalesTerritory;
GO

CREATE OR ALTER VIEW Application.vMideastSalesTerritory
	WITH SCHEMABINDING
AS
SELECT TOP 10 C.CityName, P.StateProvinceName
FROM Application.StateProvinces AS P
JOIN Application.Cities AS C
  ON P.StateProvinceID = C.StateProvinceID
  WHERE p.SalesTerritory = 'Mideast'
  ORDER BY C.CityName, P.StateProvinceCode;
GO



SELECT *
	FROM Application.vMideastSalesTerritory;
GO






