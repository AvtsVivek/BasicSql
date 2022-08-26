/****Lesson 9 Lab***********/
/****Implementing Scalar-Valued and Table-Valued UDFs*****/

USE WideWorldImporters;
GO

USE WideWorldImporters;
GO

DROP FUNCTION IF EXISTS dbo.ufnTotalCustTransExcludingTax;
GO

-->>>>CREATE User-Defined Scalar-Valued Function<<<<-----------------------------

CREATE FUNCTION dbo.ufnTotalCustTransExcludingTax    -- function name
(@TransactionDate datetime)                   -- input parameter name and data type
RETURNS decimal                               -- return parameter data type
 AS
 BEGIN                                        -- begin body definition
	DECLARE @ret decimal;
	SELECT @ret = SUM(ct.AmountExcludingTax)
	FROM Sales.CustomerTransactions AS ct
	WHERE ct.TransactionDate = @TransactionDate;
	RETURN @ret;                              -- action performed
END;
GO

--Total amount in sales for a given day-------------------------------------------
SELECT DISTINCT TransactionDate,dbo.ufnTotalCustTransExcludingTax(TransactionDate) AS 'Total Daily Amount Sold'
FROM Sales.CustomerTransactions
WHERE TransactionDate = '2013-01-03';
GO

/**********************************************************/
/**********************************************************/
/***Implementing Queries Using Table-Valued Functions ***/

USE WideWorldImporters;
GO

-->>>>CREATE User-Defined Table-Valued Function<<<<-----------------------------

DROP FUNCTION IF EXISTS dbo.ufnGetFilteredTransactions;
GO

CREATE FUNCTION dbo.ufnGetFilteredTransactions
(
  @minamt AS Decimal,
  @maxamt AS Decimal
 )
RETURNS @returntable TABLE 
(
	CustomerID  INT
	,CustomerTransactionID INT
	,InvoiceID INT
	,TransactionAmount  Decimal
)
AS
BEGIN
  INSERT @returntable
	SELECT CustomerID, CustomerTransactionID, InvoiceID, TransactionAmount
	FROM Sales.CustomerTransactions
	WHERE TransactionAmount BETWEEN @minamt AND @maxamt
  RETURN
END;
GO

-->>>>Implementing the Table-Valued Function<<<<--------------------
SELECT CustomerID, CustomerTransactionID, InvoiceID, TransactionAmount AS 'Transaction Amount'
FROM dbo.ufnGetFilteredTransactions (20000.00,20100.00)
ORDER BY CustomerID, [Transaction Amount];

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Creating and Implementing a Natively Compiles Scalr-Valued UDF----------
USE AdventureWorks2016CTP3;  
GO  

DROP FUNCTION IF EXISTS dbo.ufnMyGetSalesOrderStatusText_native;
GO

CREATE FUNCTION dbo.ufnMyGetSalesOrderStatusText_native (@Status tinyint)  
RETURNS nvarchar(15)   
WITH NATIVE_COMPILATION, SCHEMABINDING  
AS  
BEGIN 
	ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, 
	LANGUAGE = N'English')
			IF @Status=1 RETURN 'In Process' 
			IF @Status=2 RETURN 'Approved' 
	       	IF @Status=3 RETURN 'Backordered' 
            IF @Status=4 RETURN 'Rejected'      
	       	IF @Status=5 RETURN 'Shipped' 
	      	IF @Status=6 RETURN 'Cancelled' 
	        RETURN '** Invalid **'    
END;
  
-->>>>>>>>>Implement the Function<<<<<<<<<<<<<<<<<<<<<<<<<-- 
DECLARE @returnstatus nvarchar(15);  
SET @returnstatus = NULL;  
EXEC @returnstatus = dbo.ufnMyGetSalesOrderStatusText_native @Status = 5;
-- View the returned value.  The Execute and Select statements must be executed at the same time.  
SELECT N'Order Status: ' + @returnstatus;    
GO


