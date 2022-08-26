/****Lesson 10 Lab***********/
/****Using THROW and RAISERROR*****/

-->>>>>>---- Method 1 ----<<<<<<--
-->>>>>> Use THROW anywhere in code
-->>>>>> Invoke THROW with parameters to raise user-defined error message

THROW 51000, 'The stated object cannot be found', 1;
GO

-->>>>>>----Method 2 ----<<<<<<--
-->>>>>> Use THROW within CATCH block
-->>>>>> without parameters to re-raise original error that invoked CATCH block

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
    PRINT 'Currently beginning catch block.';
	PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(50));
    THROW;  -- use the THROW statement to raise the last thrown exception again
END CATCH;
GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/****USING RAISERROR************************************/
BEGIN TRY
  DECLARE @result INT
--Generate divide-by-zero error
  SET @result = 25/0
END TRY
BEGIN CATCH
--Get the details of the error
--that invoked the CATCH block
 DECLARE
   @ErMessage NVARCHAR(2048),
   @ErSeverity INT,
   @ErState INT
 
 SELECT
   @ErMessage = ERROR_MESSAGE(),
   @ErSeverity = ERROR_SEVERITY(),
   @ErState = ERROR_STATE()
 
 RAISERROR (@ErMessage,
             @ErSeverity,
             @ErState )
END CATCH;
GO
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/****USING THROW****************************************/
BEGIN TRY
  DECLARE @result INT
--Generate divide-by-zero error
  SET @result = 25/0
END TRY
BEGIN CATCH
    THROW
END CATCH;
GO

----THROW - PRINT statment after THROW will NOT be executed

BEGIN
    PRINT 'BEFORE THROW';
    THROW 50000,'THROW TEST',1
    PRINT 'AFTER THROW'
END;
GO

----RAISERROR - PRINT statment after RAISERROR will be executed
BEGIN
 PRINT 'BEFORE RAISERROR'
 RAISERROR('RAISERROR TEST',16,1)
 PRINT 'AFTER RAISERROR'
END;
GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--CAN RAISE user-defined message with message_id greater than 50000
-- which is not defined in SYS.MESSAGES table---------------------

--THROW - Can RAISE user-defined message
THROW 60000, 'This is a user defined message', 1;


--RAISERROR - Can only use messages defined in sys.messages
RAISERROR (60000, 16, 1);
GO
--Now add the Message to SYS.MESSAGES Table by using the below statement:
--EXEC sys.sp_addmessage 60000, 16, ‘This is a user defined message’
--and run the code again------------------------------------------------


--RAISERROR
DECLARE 
    @ERR_MSG AS NVARCHAR(4000)
    ,@ERR_SEV AS SMALLINT
    ,@ERR_STA AS SMALLINT
 
BEGIN TRY
    SELECT 1/0 as DivideByZero
END TRY
BEGIN CATCH
    SELECT @ERR_MSG = ERROR_MESSAGE(),
        @ERR_SEV =ERROR_SEVERITY(),
        @ERR_STA = ERROR_STATE()
    SET @ERR_MSG= 'Error occurred while retrieving the data from database: ' + @ERR_MSG
 
    RAISERROR (@ERR_MSG, @ERR_SEV, @ERR_STA)  WITH NOWAIT
END CATCH
GO

--THROW
BEGIN TRY
    SELECT 1/0 as DivideByZero
END TRY
BEGIN CATCH
    THROW;
END CATCH
GO