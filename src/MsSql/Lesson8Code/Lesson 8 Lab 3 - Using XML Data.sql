/****Lesson 8 Lab***********/
/****Using XML Data*****/
/**** This lab uses AdventureWorks2016CTP3 database****/

USE AdventureWorks2016CTP3
GO

--Sample Query with Tabular Output--------------------------------
SELECT CustomerID
	,SalesOrderID 
	,TerritoryID
	,Convert(Date,OrderDate) AS 'OrderDate'
	,FORMAT(SubTotal, 'N', 'en-us') AS 'SalesTotal'
FROM Sales.SalesOrderHeader
WHERE CustomerID IN (29825, 29734)
	ORDER BY CustomerID, SalesOrderID;
GO

/******************************************************************/
/*****OUTPUTTING TABLE RESULTS AS XML******************************/
/******************************************************************/

-->>>>>Results as XML - some fragments and some documents<<<<<<<----
--------------------------------------------------------------------
--Returning Results as XML using SalesOrderHeader table with XMl RAW
--------------------------------------------------------------------
USE AdventureWorks2016CTP3
GO

SELECT CustomerID
	,SalesOrderID
	,TerritoryID
	,Convert(Date,OrderDate) AS 'OrderDate'
	,FORMAT(SubTotal, 'N', 'en-us') AS 'SalesTotal'
FROM Sales.SalesOrderHeader
WHERE CustomerID IN ( 29825, 29734)
	ORDER BY CustomerID, SalesOrderID
FOR XML RAW;
GO

--------------------------------------------------------------------
--Returning Results as XML using SalesOrderHeader table with XML RAW
--specifying ROOT element Customer----------------------------------
--------------------------------------------------------------------
USE AdventureWorks2016CTP3
GO

SELECT CustomerID
	,SalesOrderID
	,TerritoryID
	,Convert(Date,OrderDate) AS 'OrderDate'
	,FORMAT(SubTotal, 'N', 'en-us') AS 'SalesTotal'
FROM Sales.SalesOrderHeader
WHERE CustomerID IN ( 29825, 29734)
	ORDER BY CustomerID, SalesOrderID
FOR XML RAW, ROOT('CustomerOrders');
GO

--------------------------------------------------------------------
--Returning Results as XML using SalesOrderHeader table with XML AUTO
--------------------------------------------------------------------
USE AdventureWorks2016CTP3
GO

SELECT CustomerID
	,SalesOrderID
	,TerritoryID
	,Convert(Date,OrderDate) AS 'OrderDate'
	,FORMAT(SubTotal, 'N', 'en-us') AS 'SalesTotal'
FROM Sales.SalesOrderHeader
WHERE CustomerID IN ( 29825, 29734)
	ORDER BY CustomerID, SalesOrderID
FOR XML AUTO;
GO

--------------------------------------------------------------------
--Returning Results as XML using SalesOrderHeader table with XML AUTO 
--and ELEMENTS------------------------------------------------------
--------------------------------------------------------------------
USE AdventureWorks2016CTP3
GO

SELECT CustomerID
	,SalesOrderID
	,TerritoryID
	,Convert(Date,OrderDate) AS 'OrderDate'
	,FORMAT(SubTotal, 'N', 'en-us') AS 'SalesTotal'
FROM Sales.SalesOrderHeader
WHERE CustomerID IN ( 29825, 29734)
	ORDER BY CustomerID, SalesOrderID
FOR XML AUTO, ELEMENTS;
GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--Returning Results as XML joining SalesOrderHeader and Customer table using XML RAW
--Selecting both CustomerID and StoreID from Customer table--------------------------
-------------------------------------------------------------------------------------
USE AdventureWorks2016CTP3
GO
SELECT Cust.CustomerID, Cust.StoreID 
	,SOH.SalesOrderID 
	,Convert(Date,SOH.OrderDate) AS 'OrderDate'
	,FORMAT(SOH.SubTotal, 'N', 'en-us') AS 'SalesTotal'
FROM Sales.Customer AS Cust
	INNER JOIN Sales.SalesOrderHeader AS SOH
		ON Cust.CustomerID = SOH.CustomerID
WHERE SOH.CustomerID IN (29825, 29734)
	ORDER BY Cust.CustomerID, SOH.SalesOrderID
FOR XML RAW;
GO

-------------------------------------------------------------------------------------
--Returning Results as XML joining SalesOrderHeader and Customer table using XML RAW
--Selecting both CustomerID and StoreID from Customer table--------------------------
--Enhanced by renaming the row element to 'Order' 
--and specifying top level ROOT element of 'CustomerOrders' 
-------------------------------------------------------------------------------------
USE AdventureWorks2016CTP3
GO
SELECT Cust.CustomerID, Cust.StoreID 
	,SOH.SalesOrderID 
	,Convert(Date,SOH.OrderDate) AS 'OrderDate'
	,FORMAT(SOH.SubTotal, 'N', 'en-us') AS 'SalesTotal'
FROM Sales.Customer AS Cust
	INNER JOIN Sales.SalesOrderHeader AS SOH
		ON Cust.CustomerID = SOH.CustomerID
WHERE SOH.CustomerID IN (29825, 29734)
	ORDER BY Cust.CustomerID, SOH.SalesOrderID
FOR XML RAW('Order'), ROOT('CustomersOrders');
GO


-------------------------------------------------------------------------------------
--Returning Results as XML joining SalesOrderHeader and Customer table using XML AUTO
--Selecting both CustomerID and StoreID from Customer table--------------------------
-------------------------------------------------------------------------------------
USE AdventureWorks2016CTP3
GO
SELECT Cust.CustomerID, Cust.StoreID 
	,SOH.SalesOrderID 
	,Convert(Date,SOH.OrderDate) AS 'OrderDate'
	,FORMAT(SOH.SubTotal, 'N', 'en-us') AS 'SalesTotal'
FROM Sales.Customer AS Cust
	INNER JOIN Sales.SalesOrderHeader AS SOH
		ON Cust.CustomerID = SOH.CustomerID
WHERE SOH.CustomerID IN (29825, 29734)
	ORDER BY Cust.CustomerID, SOH.SalesOrderID
FOR XML AUTO;
GO

-------------------------------------------------------------------------------------
--Returning Results as XML joining SalesOrderHeader and Customer table using XML AUTO
--Selecting both CustomerID and StoreID from Customer table--------------------------
--Specifying top level ROOT element of 'CustomerOrders' -----------------------------
-------------------------------------------------------------------------------------
USE AdventureWorks2016CTP3
GO
SELECT Cust.CustomerID, Cust.StoreID 
	,SOH.SalesOrderID 
	,Convert(Date,SOH.OrderDate) AS 'OrderDate'
	,FORMAT(SOH.SubTotal, 'N', 'en-us') AS 'SalesTotal'
FROM Sales.Customer AS Cust
	INNER JOIN Sales.SalesOrderHeader AS SOH
		ON Cust.CustomerID = SOH.CustomerID
WHERE SOH.CustomerID IN (29825, 29734)
	ORDER BY Cust.CustomerID, SOH.SalesOrderID
FOR XML AUTO, ROOT('CustomersOrders');
GO

-------------------------------------------------------------------------------------
--Returning Results as XML joining SalesOrderHeader and Customer table using XML AUTO
--Selecting both CustomerID and StoreID from Customer table--------------------------
--Specifying top level ROOT element of 'CustomerOrders' -----------------------------
--AND Specifying ELEMENTS lists each attribute on a separate line--------------------
-------------------------------------------------------------------------------------
USE AdventureWorks2016CTP3
GO
SELECT Cust.CustomerID, Cust.StoreID 
	,SOH.SalesOrderID 
	,Convert(Date,SOH.OrderDate) AS 'OrderDate'
	,FORMAT(SOH.SubTotal, 'N', 'en-us') AS 'SalesTotal'
FROM Sales.Customer AS Cust
	INNER JOIN Sales.SalesOrderHeader AS SOH
		ON Cust.CustomerID = SOH.CustomerID
WHERE SOH.CustomerID IN (29825, 29734)
	ORDER BY Cust.CustomerID, SOH.SalesOrderID
FOR XML AUTO, ELEMENTS, ROOT('CustomersOrders');
GO

-------------------------------------------------------------------------------------
--Returning Results as XML joining SalesOrderHeader and Customer table using XML PATH
--Selecting both CustomerID and StoreID from Customer table--------------------------
--Enhanced by renaming the row element to 'Order' 
--and specifying top level ROOT element of 'CustomerOrders' 
-------------------------------------------------------------------------------------
USE AdventureWorks2016CTP3
GO
SELECT Cust.CustomerID, Cust.StoreID 
	,SOH.SalesOrderID 
	,Convert(Date,SOH.OrderDate) AS 'OrderDate'
	,FORMAT(SOH.SubTotal, 'N', 'en-us') AS 'SalesTotal'
FROM Sales.Customer AS Cust
	INNER JOIN Sales.SalesOrderHeader AS SOH
		ON Cust.CustomerID = SOH.CustomerID
WHERE SOH.CustomerID IN (29825, 29734)
	ORDER BY Cust.CustomerID, SOH.SalesOrderID
FOR XML PATH;
GO

-------------------------------------------------------------------------------------
--Returning Results as XML joining SalesOrderHeader and Customer table using XML PATH
--Selecting both CustomerID and StoreID from Customer table--------------------------
--Enhanced by renaming the row element to 'Order' 
--and specifying top level ROOT element of 'CustomerOrders' 
-------------------------------------------------------------------------------------
USE AdventureWorks2016CTP3
GO
SELECT Cust.CustomerID, Cust.StoreID 
	,SOH.SalesOrderID 
	,Convert(Date,SOH.OrderDate) AS 'OrderDate'
	,FORMAT(SOH.SubTotal, 'N', 'en-us') AS 'SalesTotal'
FROM Sales.Customer AS Cust
	INNER JOIN Sales.SalesOrderHeader AS SOH
		ON Cust.CustomerID = SOH.CustomerID
WHERE SOH.CustomerID IN (29825, 29734)
	ORDER BY Cust.CustomerID, SOH.SalesOrderID
FOR XML PATH ('Customer'), ROOT('CustomerOrders');
GO

/***********************************************************************/
/********QUERYING XML DATA TYPE*****************************************/

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-->>>>XQUERY Methods on XML data type column in AW2016CTP3<<<<<<<-----
USE AdventureWorks2016CTP3
GO
--CatalogDescription is XML data type--------------------------
--Query the data type contents---------------------------------
SELECT CatalogDescription
FROM Production.ProductModel
WHERE CatalogDescription IS NOT NULL;


---------XQUERY methods---------------------------------------------------
--query() and exist() methods on XML data type CatalogDescription---------
SELECT CatalogDescription.query('  
declare namespace PD="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";  
<Product ProductModelID="{ /PD:ProductDescription[1]/@ProductModelID }" />  
') as Result  
FROM Production.ProductModel  
where CatalogDescription.exist('  
declare namespace PD="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";  
declare namespace wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain";  
     /PD:ProductDescription/PD:Features/wm:Warranty ') = 1


----query() and exist() methods using WITH XMLNAMESPACES to first define the prefixes and use it in the query-- 
WITH XMLNAMESPACES (  
   'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription' AS PD,  
   'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain' AS wm)  
SELECT CatalogDescription.query('  
<Product ProductModelID="{ /PD:ProductDescription[1]/@ProductModelID }" />  
') as Result  
FROM Production.ProductModel  
where CatalogDescription.exist('  
     /PD:ProductDescription/PD:Features/wm:Warranty ') = 1;


--------------value() method to extract values from XML data type-------------------
SELECT CatalogDescription.value('             
    declare namespace PD="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";             
       (/PD:ProductDescription/@ProductModelID)[1]', 'int') AS Result             
FROM Production.ProductModel             
WHERE CatalogDescription IS NOT NULL             
ORDER BY Result desc;

---------------nodes() method-----------------------------
/**Find Location IDs in each <Location> 
Retrieve manufacturing steps (<step> child elements) in each <Location> 
This query returns the context item, in which the abbreviated syntax '.' 
for self::node() is specified, in the query() method.
The nodes() method is applied to the Instructions column and returns a rowset, T (C). 
This rowset contains logical copies of the original manufacturing instructions document
 with /root/Location as the context item. 
CROSS APPLY applies nodes() to each row in the Instructions table
 and returns only the rows that produce a result set.
 */
SELECT C.query('.') as result  
FROM Production.ProductModel  
CROSS APPLY Instructions.nodes('  
declare namespace MI="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions";  
/MI:root/MI:Location') as T(C)  
WHERE ProductModelID=7

--OPENXML--------------------------
--The OPENXML rowset provider creates a two-column rowset 
--(CustomerID and ContactName) from which the SELECT statement
--retrieves the necessary columns (in this case, all the columns)

DECLARE @idoc int, @doc varchar(1000);  
SET @doc ='  
<ROOT>  
<Customer CustomerID="VINET" ContactName="Paul Henriot">  
   <Order CustomerID="VINET" EmployeeID="5" OrderDate="1996-07-04T00:00:00">  
      <OrderDetail OrderID="10248" ProductID="11" Quantity="12"/>  
      <OrderDetail OrderID="10248" ProductID="42" Quantity="10"/>  
   </Order>  
</Customer>  
<Customer CustomerID="LILAS" ContactName="Carlos Gonzlez">  
   <Order CustomerID="LILAS" EmployeeID="3" OrderDate="1996-08-16T00:00:00">  
      <OrderDetail OrderID="10283" ProductID="72" Quantity="3"/>  
   </Order>  
</Customer>  
</ROOT>';  
--Create an internal representation of the XML document.  
EXEC sp_xml_preparedocument @idoc OUTPUT, @doc;  
-- Execute a SELECT statement that uses the OPENXML rowset provider.  
SELECT    *  
FROM       OPENXML (@idoc, '/ROOT/Customer',1)  
            WITH (CustomerID  varchar(10),  
                  ContactName varchar(20));





/********************************************************/
/****EXTRA EXAMPLE USING WideWorldImpporters database****/
USE WideWorldImporters;
GO

SELECT StockItemID, StockItemName,
         Tags as Tags,
         CONCAT('["',ValidFrom,'","',ValidTo,'"]') ValidityPeriod
FROM Warehouse.StockItems
FOR XML PATH;
-------------------------------------------------------------