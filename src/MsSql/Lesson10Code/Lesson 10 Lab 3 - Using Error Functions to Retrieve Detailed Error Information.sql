/****Lesson 10 Lab***********/
/****Using Error Functions to Retrieve Detailed Error Information*****/

-->>>>>>Using Error Functions to Return Detailed Error Information<<<<<<--
-->>>>>>This example produces an error - division by zero
-->>>>>>TRY block does not complete, and control transferred to the CATCH block
-->>>>>>NOTE: Error function relays the error and its description

USE WideWorldImporters;
GO
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

