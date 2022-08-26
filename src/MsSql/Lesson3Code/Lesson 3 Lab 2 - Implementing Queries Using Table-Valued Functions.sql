/***Lesson 3 Lab 2***/
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
