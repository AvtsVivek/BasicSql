/****Lesson 8 Lab***********/
/****Using Temporal Tables*****/

USE WideWorldImporters;
GO

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

/***FOR SYSTEM_TIME with ALL********************/
/*  Query using ALL sub-clause */   
SELECT CustomerCategoryID
      ,CustomerCategoryName
      ,LastEditedBy
      ,ValidFrom
      ,ValidTo  
   , IIF (YEAR(ValidTo) = 9999, 1, 0) AS IsActual    
FROM Sales.CustomerCategories FOR SYSTEM_TIME ALL   
ORDER BY CustomerCategoryID, ValidFrom Desc;  

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>..

