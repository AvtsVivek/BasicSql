/****Lesson 10 Lab 4***********/
/****Using Transaction Control in Conjunction with error handling in Stored Procedures*****/

----In the first two examples, the errer handling occurs when the procedure is executed
----Using a TRY...CATCH construct

/****EXAMPLE 1****/
USE WideWorldImporters;
GO

-- Verify that the stored procedure does not already exist.    
DROP PROCEDURE IF EXISTS dbo.usp_TranExProc;
GO


-- Create a stored procedure that   
-- generates a divide-by-zero error.  
CREATE OR ALTER PROCEDURE dbo.usp_TranExProc  
AS  
    SELECT 1/0;  
GO  


BEGIN TRY  
    -- Execute the stored procedure inside the TRY block.  
    EXECUTE dbo.usp_TranExProc;  
END TRY  
BEGIN CATCH  
    SELECT	ERROR_PROCEDURE() AS 'Procedure containing Error',
			ERROR_MESSAGE() AS ErrorMessage,
			ERROR_SEVERITY() AS 'Severity of the Error';			  
END CATCH;  
GO


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.
/****Example 2****/
USE WideWorldImporters;
GO

-- Verify that the stored procedure does not already exist.    
DROP PROCEDURE IF EXISTS dbo.usp_TranCastProc;
GO


-- Create a stored procedure that   
-- generates a divide-by-zero error.  
CREATE OR ALTER PROCEDURE dbo.usp_TranCastProc  
AS  
    SELECT CAST('This is not an INT' AS INT)
GO  


BEGIN TRY  
    -- Execute the stored procedure inside the TRY block.  
    EXECUTE dbo.usp_TranCastProc;  
END TRY  
BEGIN CATCH  
    SELECT	ERROR_PROCEDURE() AS 'Procedure containing Error',
			ERROR_MESSAGE() AS ErrorMessage,
			ERROR_SEVERITY() AS 'Severity of the Error',
			ERROR_NUMBER() AS 'Error Number',
			ERROR_STATE() AS ErrorState			  
END CATCH;  
GO


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--TRANSACTION INSIDE STORED PROCEDURE-----------

/****Example 3****/
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
---The following example creates a procedure with
---a transaction included within the procedure
USE WideWorldImporters;
GO

DROP TABLE IF EXISTS dbo.ProcTranExample;
GO

DROP PROCEDURE IF EXISTS dbo.usp_ProcTranExample;
GO

CREATE TABLE dbo.ProcTranExample (value int)
GO


-- This stored procedure will roll back a transaction if the 
-- @Rollbk parameter is a 1.
CREATE OR ALTER PROCEDURE dbo.usp_ProcTranExample @Value int, @Rollbk bit
AS
BEGIN
    BEGIN TRANSACTION
    INSERT INTO dbo.ProcTranExample VALUES (@Value)
    PRINT @@TRANCOUNT;
	IF @Rollbk = 1 
        -- If procedure called from within transaction,
        -- @@TRANCOUNT when exit procedure different than when started
        ROLLBACK TRANSACTION
    ELSE
        COMMIT
END
GO


-- Begin a new transaction
PRINT @@TRANCOUNT;
BEGIN TRANSACTION
PRINT @@TRANCOUNT;
INSERT INTO dbo.ProcTranExample VALUES (1)
-- Run the sp with the param to roll back a transaction
-- This will return an error because tran count has changed
PRINT @@TRANCOUNT;
EXEC dbo.usp_ProcTranExample 5,1
PRINT @@TRANCOUNT;
-- Run the commit to close the initial transaction
-- This will return an error because there is no valid transaction
-- to commit
COMMIT
PRINT @@TRANCOUNT;
-- No rows are in the table because the initial insert
-- rolled back
SELECT * FROM dbo.ProcTranExample; --No values in table, everything in stored procedure rolled back
PRINT @@TRANCOUNT;
GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--TRANSACTION INSIDE STORED PROCEDURE USING SAVEPOINT-----------
/****Example 4****/
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- This stored procedure will roll back a saved transaction if 
-- the @ROLLBK parameter is a 1.
ALTER PROCEDURE dbo.usp_ProcTranExample @Value int, @RollBk bit
AS
BEGIN
    BEGIN TRANSACTION
    SAVE TRANSACTION TranExample --savepoint created
    INSERT INTO dbo.ProcTranExample VALUES (@Value)
	PRINT @@TRANCOUNT;
    IF @Rollbk = 1 
        -- Roll back to the saved point.
        -- The transaction is not closed and  
        -- @@TRANCOUNT is not changed.
        ROLLBACK TRANSACTION TranExample --transaction rolls back to save point
    -- Close the transaction created at the beginning of the SP
    COMMIT
END
GO
 
TRUNCATE TABLE dbo.ProcTranExample;
GO
-- Begin a new transaction
PRINT @@TRANCOUNT;
BEGIN TRANSACTION
PRINT @@TRANCOUNT;
INSERT INTO dbo.ProcTranExample VALUES (1) --this value of 1 is retained in the table, inserted before savepoint
-- Run the sp with the param to roll back a transaction
PRINT @@TRANCOUNT;
EXEC dbo.usp_ProcTranExample 5,1
PRINT @@TRANCOUNT;
-- Run the commit to close the initial transaction
COMMIT
PRINT @@TRANCOUNT;
SELECT * FROM dbo.ProcTranExample;
PRINT @@TRANCOUNT;
GO

--IN THIS EXAMPLE WE WILL SET THE ROLLBACK VALUE TO 0 SO ALL WORK COMPLETES
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--TRANSACTION INSIDE STORED PROCEDURE USING SAVEPOINT-----------
/****Example 5****/
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- This stored procedure will roll back a saved transaction if 
-- the @ROLLBK parameter is a 1.
ALTER PROCEDURE dbo.usp_ProcTranExample @Value int, @RollBk bit
AS
BEGIN
    BEGIN TRANSACTION
    SAVE TRANSACTION TranExample --savepoint created
    INSERT INTO dbo.ProcTranExample VALUES (@Value)
	PRINT @@TRANCOUNT;
    IF @Rollbk = 1 
        -- Roll back to the savepoint
        -- The transaction is not closed and  
        -- @@TRANCOUNT is not changed
        ROLLBACK TRANSACTION TranExample --transaction rolls back to savepoint
    -- Close the transaction created at the beginning of the SP
    COMMIT
END
GO
 
TRUNCATE TABLE dbo.ProcTranExample;

-- Begin a new transaction
PRINT @@TRANCOUNT;
BEGIN TRANSACTION
PRINT @@TRANCOUNT;
INSERT INTO dbo.ProcTranExample VALUES (1)
-- Run the sp with the param to roll back a transaction
PRINT @@TRANCOUNT;
EXEC dbo.usp_ProcTranExample 5,0 --@ROLLBK has value of 0
PRINT @@TRANCOUNT;           -- @@TRANCOUNT decreases by 1 and is now 1
-- Run the commit to close the initial transaction
COMMIT
PRINT @@TRANCOUNT;           --@@TRANCOUNT decreases by 1 and is now 0
SELECT * FROM dbo.ProcTranExample;
PRINT @@TRANCOUNT;			 --Two values in table, first from insert statement and second from proc
GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/****Example 6****/
-->>>>>>>>TRANSACTION CONTROL AND ERROR HANDLING IN STORED PROC<<<<<<<

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
