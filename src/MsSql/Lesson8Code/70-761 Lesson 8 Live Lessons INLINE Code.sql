/* 70-761 Lesson 8 Live Lessons INLINE Code */

USE WideWorldImporters
GO

/****Lesson 8.1 Querying Historic Data Using Temporal Tables****/


/**FOR SYSTEM_TIME with AS OF***************/
/*State of entire table AS OF specific date in the past*/   
SELECT CustomerCategoryID
      ,CustomerCategoryName
      ,ValidFrom
      ,ValidTo
FROM Sales.CustomerCategories
FOR SYSTEM_TIME AS OF '2013-06-01 T10:00:00.7230011' ; 

/*State of entire table AS OF specific date in the past*/   
SELECT CustomerCategoryID
      ,CustomerCategoryName
      ,ValidFrom
      ,ValidTo
FROM Sales.CustomerCategories
FOR SYSTEM_TIME AS OF '2015-06-01 T10:00:00.7230011' ; 


/****compares the values between two points in time for a subset of rows****/
DECLARE @ADayAgo datetime2   
SET @ADayAgo = DATEADD (DAY, -1, sysutcdatetime())   
/*Comparison between two points in time for subset of rows*/   
SELECT D_1_Ago.CustomerCategoryID, C.CustomerCategoryID,   
D_1_Ago.CustomerCategoryName, C.CustomerCategoryName,   
D_1_Ago.ValidFrom, C.ValidFrom,   
D_1_Ago.ValidTo, C.ValidTo   
FROM Sales.CustomerCategories FOR SYSTEM_TIME AS OF @ADayAgo AS D_1_Ago   
JOIN Sales.CustomerCategories AS C ON  D_1_Ago.CustomerCategoryID = C.CustomerCategoryID    
AND D_1_Ago.CustomerCategoryID BETWEEN 5 and 8 ;


/**FOR SYSTEM_TIME with FROM TO***************/
SELECT   
      CustomerCategoryID
      ,CustomerCategoryName
      ,LastEditedBy
      ,ValidFrom
      ,ValidTo
   , IIF (YEAR(ValidTo) = 9999, 1, 0) AS IsActual   
FROM Sales.CustomerCategories    
FOR SYSTEM_TIME FROM  '2013-01-01' TO '2015-12-31'   
WHERE CustomerCategoryID = 8   
ORDER BY ValidFrom DESC; 


/**FOR SYSTEM_TIME with BETWEEN AND***************/
/* Query using BETWEEN...AND sub-clause*/  
SELECT   
      CustomerCategoryID
      ,CustomerCategoryName
      ,LastEditedBy
      ,ValidFrom
      ,ValidTo
   , IIF (YEAR(ValidTo) = 9999, 1, 0) AS IsActual   
FROM Sales.CustomerCategories    
FOR SYSTEM_TIME BETWEEN  '2013-01-01' AND '2015-12-31'   
WHERE CustomerCategoryID = 8   
ORDER BY ValidFrom DESC; 



/**FOR SYSTEM_TIME with CONTAINED IN***************/
/*  Query using CONTAINED IN sub-clause */  
SELECT CustomerCategoryID
      ,CustomerCategoryName
      ,LastEditedBy
      ,ValidFrom
      ,ValidTo   
FROM Sales.CustomerCategories   
FOR SYSTEM_TIME CONTAINED IN ('2013-01-01', '2015-01-01')   
WHERE CustomerCategoryID = 8   
ORDER BY ValidFrom DESC;  

/*  Query using ALL sub-clause */   
SELECT CustomerCategoryID
      ,CustomerCategoryName
      ,LastEditedBy
      ,ValidFrom
      ,ValidTo  
   , IIF (YEAR(ValidTo) = 9999, 1, 0) AS IsActual    
FROM Sales.CustomerCategories FOR SYSTEM_TIME ALL   
ORDER BY CustomerCategoryID, ValidFrom Desc;  


/****************************************************/
/****Lesson 8.3 Querying and Outputting JSON Data****/
--Using WideWorldImporters database------------------

------Using JSON PATH-------------------
USE WideWorldImporters;
GO

SELECT    
       PersonID, 
       FullName,  
       EmailAddress 
   FROM Application.People
   WHERE PersonID IN (2,3)
   ORDER BY PersonID  
   FOR JSON PATH, ROOT('People'); 

USE WideWorldImporters;
GO

/****QUERYING JSON COLUMNS******************************/
SELECT PersonID,FullName,
 JSON_QUERY(CustomFields,'$.OtherLanguages') AS Languages
FROM Application.People;

----Using JSON VALUE-----------------------   
SELECT PersonID,FullName,
 JSON_VALUE(CustomFields,'$.HireDate') AS HireDate
FROM Application.People
WHERE PersonID IN (2,3,4,5)
ORDER BY PersonID; 

--Using OPENJSON--------------------------------------
--to convert JSON data to rows and columns------------
USE WideWorldImporters
GO

SELECT StockItemID, StockItemName, [CountryOfManufacture], [ShelfLife], [Tags]
FROM Warehouse.StockItems
  CROSS APPLY OPENJSON(CustomFields)
WITH ([CountryOfManufacture] nvarchar(200) '$.CountryOfManufacture',
		[ShelfLife] nvarchar (50) '$.ShelfLife'	
) AS StockItemCustomFields;


 

/***************************************************/
/****Lesson 8.5 Querying and Outputting XML Data****/
--Using AdventureWorks2016CTP3 database------------

 USE AdventureWorks2016CTP3;
 GO


SELECT CustomerID
	,SalesOrderID
	,TerritoryID
	,Convert(Date,OrderDate) AS 'OrderDate'
	,FORMAT(SubTotal, 'N', 'en-us') AS 'SalesTotal'
FROM Sales.SalesOrderHeader
WHERE CustomerID IN ( 11021, 11022)
	ORDER BY CustomerID, SalesOrderID
FOR XML AUTO, ELEMENTS;
GO