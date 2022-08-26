/****Lesson 10 Lab 1***********/
/****Using Try...Catch to Redirect Errors*****/


-->>>>>>This first example produces no error, ReorderPoint is printed, 
-->>>>>>TRY block completes, and control transferred past the CATCH block

USE AdventureWorks2016CTP3;
GO

BEGIN TRY
    UPDATE Production.Product
	SET ReorderPoint = ReorderPoint/1
		WHERE ProductID = 1;
	SELECT ReorderPoint
	FROM Production.Product
		WHERE ProductID = 1;
	PRINT 'Completing TRY block';
END TRY
BEGIN CATCH
	PRINT 'No can do';
END CATCH;
PRINT 'Continue after END CATCH';
GO

-->>>>>>This second example produces an error - division by zero
-->>>>>>TRY block does not complete, and control transferred to the CATCH block
-->>>>>>NOTE: We do not know the error or its description
USE AdventureWorks2016CTP3;
GO

BEGIN TRY
    UPDATE Production.Product
	SET ReorderPoint = ReorderPoint/0
		WHERE ProductID = 1;
	SELECT ReorderPoint
	FROM Production.Product
		WHERE ProductID = 1;
	PRINT 'Completing TRY block';
END TRY
BEGIN CATCH
	PRINT 'No can do';
END CATCH;
PRINT 'Continue after END CATCH';
GO
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

----HANDLING ERRORS THAT OCCUR WITHIN A TRANSACTIONUSING TRY...CATCH---------------------

/*****Using the TRY…CATCH construct to handle errors that occur inside a transaction*******/ 
/*****The XACT_STATE function determines whether the transaction should be committed*******/
/*****or rolled back NOTE: SET XACT_ABORT is ON********************************************/ 
/*****This makes the transaction uncommittable when the constraint violation error occurs**/ 
  
USE AdventureWorks2016CTP3;
GO
-- Check to see if stored procedure exists
DROP PROCEDURE IF EXISTS dbo.usp_GetErrorInfo; 
GO  


-- Create procedure to retrieve error information.  
CREATE PROCEDURE dbo.usp_GetErrorInfo  
AS  
    SELECT   
         ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_LINE () AS ErrorLine  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_MESSAGE() AS ErrorMessage;  
GO  


-- SET XACT_ABORT ON will cause the transaction to be uncommittable  
-- when constraint violation occurs   
SET XACT_ABORT ON;  

BEGIN TRY  
    BEGIN TRANSACTION;  
        -- A FOREIGN KEY constraint exists on this table. This   
        -- statement will generate a constraint violation error.  
        DELETE FROM Production.Product  
            WHERE ProductID = 750;  

    -- If the DELETE statement succeeds, commit the transaction.  
    COMMIT TRANSACTION;  
END TRY  
BEGIN CATCH  
    -- Execute error retrieval routine.  
    EXECUTE dbo.usp_GetErrorInfo;  

    -- Test XACT_STATE:  
        -- If 1, the transaction is committable.  
        -- If -1, the transaction is uncommittable and should   
        --     be rolled back.  
        -- XACT_STATE = 0 means that there is no transaction and  
        --     a commit or rollback operation would generate an error.  

    -- Test whether the transaction is uncommittable.  
    IF (XACT_STATE()) = -1  
    BEGIN  
        PRINT  
            N'The transaction is in an uncommittable state.' +  
            'Rolling back transaction.'  
        ROLLBACK TRANSACTION;  
    END;  

    -- Test whether the transaction is committable.  
    IF (XACT_STATE()) = 1  
    BEGIN  
        PRINT  
            N'The transaction is committable.' +  
            'Committing transaction.'  
        COMMIT TRANSACTION;     
    END;  
END CATCH;  
GO
--SET XACT_ABORT OFF---------------------------------------
SET XACT_ABORT OFF;