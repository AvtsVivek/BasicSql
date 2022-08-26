/* 70-761 Lesson 10 Live Lessons INLINE Code */

USE WideWorldImporters
GO
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-->>>>Lesson 10.1<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--To view the current setting for IMPLICIT_TRANSACTIONS----

DECLARE @IMPLICIT_TRANSACTIONS VARCHAR(3) = 'OFF';  
IF ( (2 & @@OPTIONS) = 2 ) SET @IMPLICIT_TRANSACTIONS = 'ON';  
SELECT @IMPLICIT_TRANSACTIONS AS IMPLICIT_TRANSACTIONS;
GO

--Using @@OPTIONS To get the settings for the current session -----

DECLARE @options INT 
SELECT @options = @@OPTIONS 
PRINT @options
IF ( (1 & @options) = 1 ) PRINT 'DISABLE_DEF_CNST_CHK' 
IF ( (2 & @options) = 2 ) PRINT 'IMPLICIT_TRANSACTIONS' 
IF ( (4 & @options) = 4 ) PRINT 'CURSOR_CLOSE_ON_COMMIT' 
IF ( (8 & @options) = 8 ) PRINT 'ANSI_WARNINGS' 
IF ( (16 & @options) = 16 ) PRINT 'ANSI_PADDING' 
IF ( (32 & @options) = 32 ) PRINT 'ANSI_NULLS' 
IF ( (64 & @options) = 64 ) PRINT 'ARITHABORT' 
IF ( (128 & @options) = 128 ) PRINT 'ARITHIGNORE'
IF ( (256 & @options) = 256 ) PRINT 'QUOTED_IDENTIFIER' 
IF ( (512 & @options) = 512 ) PRINT 'NOCOUNT' 
IF ( (1024 & @options) = 1024 ) PRINT 'ANSI_NULL_DFLT_ON' 
IF ( (2048 & @options) = 2048 ) PRINT 'ANSI_NULL_DFLT_OFF' 
IF ( (4096 & @options) = 4096 ) PRINT 'CONCAT_NULL_YIELDS_NULL' 
IF ( (8192 & @options) = 8192 ) PRINT 'NUMERIC_ROUNDABORT' 
IF ( (16384 & @options) = 16384 ) PRINT 'XACT_ABORT' 


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-->>>>Lesson 10.2 Implementing TRY...CATCH Error Handling<<<<<--

--Using TRY...CATCH with an error
SET NOCOUNT ON
BEGIN TRY
	PRINT 'Start TRY Code Block'
	PRINT 'Attempting to CAST ''This is not an INT'' AS INT'
	SELECT CAST('This is not an INT' AS INT)
	PRINT 'End of the TRY Block'
END TRY
BEGIN CATCH
	PRINT 'In the CATCH block because an error ocurred'
	PRINT 'The Expression ''This is not an INT'' could not be CAST as INT'
END CATCH;
GO

--Using TRY...CATCH without an error
SET NOCOUNT ON
BEGIN TRY
	PRINT 'Start TRY Code Block'
	PRINT 'Attempting to CAST ''11'' AS INT'
	SELECT CAST('11' AS INT)
	PRINT 'The Expression ''11'' can be CAST as INT'
	PRINT 'End of the TRY Block'
END TRY
BEGIN CATCH
	PRINT 'In the CATCH block because an error ocurred'
END CATCH
GO

-->>>>>>Viewing current EXACT_ABORT settings<<<<<<-------
USE WideWorldImporters;
GO

DECLARE @XACT_ABORT VARCHAR(3) = 'OFF';
IF ( (16384 & @@OPTIONS) = 16384 ) SET @XACT_ABORT = 'ON';
SELECT @XACT_ABORT AS XACT_ABORT;

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

USE WideWorldImporters;
GO

-->>>>>>This example produces an error - division by zero
-->>>>>>TRY block does not complete, and control transferred to the CATCH block
-->>>>>>NOTE: Error functions relay the error and its description
BEGIN TRY
    UPDATE Warehouse.StockItemHoldings
	SET ReorderLevel = ReorderLevel/0
		WHERE StockItemID = 1;
	SELECT ReorderLevel
	FROM Warehouse.StockItemHoldings
		WHERE StockItemID = 1;
	PRINT 'Completing TRY block';
END TRY
BEGIN CATCH
    SELECT
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Lesson 10.7 Implementing Transaction Control with error Handling
--in stored procedures
USE WideWorldImporters;
GO

-- Verify that the stored procedure does not already exist.    
DROP PROCEDURE IF EXISTS dbo.usp_TranINProc;
GO


-- Create a stored procedure that   
-- generates a divide-by-zero error.  
CREATE OR ALTER PROCEDURE dbo.usp_TranINProc  
AS 
  SET XACT_ABORT, NOCOUNT ON;
  BEGIN TRY
	BEGIN TRANSACTION; 
      SELECT 1/0;
	COMMIT TRANSACTION;  
  END TRY  
  BEGIN CATCH  
      SELECT	ERROR_PROCEDURE() AS 'Procedure containing Error',
			    ERROR_MESSAGE() AS ErrorMessage,
			    ERROR_SEVERITY() AS 'Severity of the Error';
	  IF @@TRANCOUNT > 0
	     ROLLBACK TRANSACTION;
	  THROW;			  
  END CATCH;
  GO
  ------------EXECUTE STORED PROCEDURE---------------------
  EXEC dbo.usp_TranINProc;
  GO

SET XACT_ABORT OFF;
