/***Lesson 3 Lab 1***/
/***Implementing  Queries Using Scalar-Valued Functions ***/

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


USE WideWorldImporters;
GO

--Total amount in sales for a given day-------------------------------------------
SELECT DISTINCT TransactionDate,dbo.ufnTotalCustTransExcludingTax(TransactionDate) AS 'Total Daily Amount Sold'
FROM Sales.CustomerTransactions
WHERE TransactionDate = '2013-01-03';
GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Total amount in sales for a given day-------------------------------------------
SELECT CustomerID, CustomerTransactionID, TransactionDate, AmountExcludingTax AS 'Sales Transaction', dbo.ufnTotalCustTransExcludingTax(TransactionDate) AS 'Total Daily Amount Sold'
FROM Sales.CustomerTransactions
WHERE TransactionDate = '2013-01-02'
ORDER BY CustomerID;

--Total amount in sales for a given day-------------------------------------------
SELECT TransactionDate,dbo.ufnTotalCustTransExcludingTax(TransactionDate) AS 'Total Daily Amount Sold'
FROM Sales.CustomerTransactions
WHERE TransactionDate = '2013-01-03';

--Total amount in sales for a given day-------------------------------------------
SELECT DISTINCT TransactionDate,dbo.ufnTotalCustTransExcludingTax(TransactionDate) AS 'Total Daily Amount Sold'
FROM Sales.CustomerTransactions
WHERE TransactionDate = '2013-01-03';
