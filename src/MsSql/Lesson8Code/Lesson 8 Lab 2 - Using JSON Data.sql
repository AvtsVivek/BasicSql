/****Lesson 8 Lab***********/
/****Using JSON Data*****/

USE WideWorldImporters;
GO

/****QUERYING JSON COLUMNS******************************/
SELECT PersonID,FullName,
 JSON_QUERY(CustomFields,'$.OtherLanguages') AS Languages
FROM Application.People;

--------------------------------------------------------

--The FOR JSON clause formats SQL results as JSON text
-- that can be provided to any app that understands JSON. 
--The PATH option uses dot-separated aliases in the SELECT clause
-- to nest objects in the query results. 
SELECT StockItemID, StockItemName,
         JSON_QUERY(Tags) as Tags,
         JSON_QUERY(CONCAT('["',ValidFrom,'","',ValidTo,'"]')) ValidityPeriod
FROM Warehouse.StockItems


--JSON_QUERY returns a valid JSON fragment so FOR JSON will not treat result of JSON_QUERY as a plain text
-- and it will not escape characters returned by JSON_QUERY using JSON escaping rules. 
--If you have JSON stored in column (Tags column in this example) or 
--if you need to dynamically create JSON using some expression, 
--you should wrap it with JSON_QUERY without path parameter if you are returning results using FOR JSON clause.

--to format output see https://jsonformatter.curiousconcept.com/--

SELECT TOP 2
		StockItemID, StockItemName,
         JSON_QUERY(Tags) as Tags,
         JSON_QUERY(CONCAT('["',ValidFrom,'","',ValidTo,'"]')) ValidityPeriod
FROM Warehouse.StockItems
FOR JSON PATH;



-----Using JSON AUTO---------------------------------------------------------
SELECT TOP 2
		StockItemID, StockItemName,
         JSON_QUERY(Tags) as Tags,
         JSON_QUERY(CONCAT('["',ValidFrom,'","',ValidTo,'"]')) ValidityPeriod
FROM Warehouse.StockItems
FOR JSON AUTO;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.
-------------------------------------------------------------------------------
SELECT    
       PersonID,  
       FullName,  
       EmailAddress 
   FROM Application.People
   WHERE PersonID IN (2,3)
   ORDER BY PersonID;  
     
------Using JSON PATH-------------------
SELECT    
       PersonID, 
       FullName,  
       EmailAddress 
   FROM Application.People
   WHERE PersonID IN (2,3)
   ORDER BY PersonID  
   FOR JSON PATH, ROOT('People'); 
    
-------Using JSON AUTO---------------------   
 SELECT    
       PersonID, 
       FullName,  
       EmailAddress 
   FROM Application.People
   WHERE PersonID IN (2,3)
   ORDER BY PersonID  
   FOR JSON AUTO;

----Using JSON VALUE-----------------------   
SELECT PersonID,FullName,
 JSON_VALUE(CustomFields,'$.HireDate') AS HireDate
FROM Application.People
WHERE PersonID IN (2,3,4,5)
ORDER BY PersonID;  
 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
----USING JSON_VALUE and JSON_QUERY ---------------------------------------
SELECT 
	JSON_VALUE(CustomFields, '$.CountryOfManufacture') AS CountryOfManufacture,
	JSON_VALUE(CustomFields, '$.ShelfLife') AS ShelfLife,
	JSON_QUERY(CustomFields, '$.Tags') AS Tags
FROM Warehouse.StockItems;


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

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-----Using ISJSON----------------------------------------
Use WideWorldImporters
GO

SELECT  StockItemName, ISJSON(StockItemName) AS 'IS JSON',
		CustomFields, ISJSON(CustomFields) AS 'IS JSON'
FROM Warehouse.StockItems;


--EXTRA--------------------------------------------------------------------
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Another OPENJSON query using AW2016CTP3-------------------------------------
--Must run Script number one in the JSON folder of the sample scripts---------
--that accompany the database-------------------------------------------------
-------------------------------------------------------------------------------
USE AdventureWorks2016CTP3
GO

SELECT SalesOrderNumber, OrderDate, ShipDate, Status, AccountNumber, TotalDue,
	[Shipping Province], [Shipping Method], ShipRate, [Sales Person], Customer
FROM Sales.SalesOrder_json
	CROSS APPLY OPENJSON(Info)
		WITH ([Shipping Province] nvarchar(100) '$.ShippingInfo.Province',
				[Shipping Method] nvarchar(20) '$.ShippingInfo.Method',
				ShipRate float '$.ShippingInfo.ShipRate',
				[Billing Address] nvarchar(100) '$.BillingInfo.Address',
				[Sales Person] nvarchar(100) '$.SalesPerson.Name',
				Customer nvarchar(4000) '$.Customer.Name') AS SalesOrderInfo
WHERE Customer = 'Edwin Shen';
GO
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
