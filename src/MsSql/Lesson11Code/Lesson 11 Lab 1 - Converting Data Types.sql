/****Lesson 11 Lab***********/
/****Converting Data Types*****/

USE WideWorldImporters;
GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Example shows silent truncation can affect
--arithmetic operations without raising an error:

DECLARE @BinVar2 BINARY(2);
DECLARE @NEWBinVar2 BINARY(2);
DECLARE @BinVar4 BINARY(4);
DECLARE @NEWBinVar4 BINARY(4);
DECLARE @TestBinary INT;

SET @TestBinary = 123456;
SET @BinVar2 = @TestBinary;
SET @BinVar4 = @TestBinary;
SET @NEWBinVar2 = @BinVar2 + 1;
SET @NEWBinVar4 = @BinVar4 + 1; 

SELECT  @TestBinary AS OriginalINT,
		@BinVar2 AS 'Binary(2)',
		@NEWBinVar2 AS 'Binary(2) + 1',
		CAST( @NEWBinVar2 AS INT) AS 'CAST @NEWBinVar2 Back to INT';
SELECT	@TestBinary AS OriginalINT,
		@BinVar4 AS 'Binary(4)',
		@NEWBinVar4 AS 'Binary(4) + 1',
		CAST( @NEWBinVar4 AS INT) AS 'CAST @NEWBinVar4 Back to INT';
GO
--Roundtrip Conversion Example------------------------------------
DECLARE @testval decimal (5, 2);  
SET @testval = 256.83;  
SELECT CAST(CAST(@testval AS varbinary(20)) AS decimal(10,5));  
-- Or, using CONVERT  
SELECT CONVERT(decimal(10,5), CONVERT(varbinary(20), @testval));
GO

--Using CONVERT with various data types and styles--------- 
DECLARE @myval INT;
SET @myval = 23456;

SELECT CONVERT( VARCHAR(20), @myval);
SELECT CONVERT(money, @myval, 1);
SELECT CONVERT(real, @myval, 2);
SELECT CONVERT(numeric, @myval, 1)
GO

--When converting data types that differ in decimal places,
--sometimes result truncated and at other times rounded
--
SELECT  100.652 AS 'Original number',
        CAST(100.652 AS int) AS 'Converting to INT truncates number',
        CAST(100.652 AS numeric) AS 'Converting to numeric rounds number';
SELECT  -100.652 AS 'Original number',
        CAST(-100.652 AS int) AS 'Converting to INT truncates number',
        CAST(-100.652 AS numeric) AS 'Converting to numeric rounds number';
GO

-------------------------------------------------------------------------------
--Using CONVERT to display different formats----------------------------------
SELECT
CONVERT(VARCHAR(19),GETDATE()) AS 'system timestamp type datetime',
CONVERT(VARCHAR(10),GETDATE(),10) AS 'US format',
CONVERT(VARCHAR(10),GETDATE(),110) AS 'US format with century',
CONVERT(VARCHAR(11),GETDATE(),103) AS 'British/French format ',
CONVERT(VARCHAR(11),GETDATE(),104) AS 'German format ',
CONVERT(VARCHAR(24),GETDATE(),113) AS 'European format';
GO

-----------------------------------------------------------------------
--Using CONVERT with DATETIME data type--------------------------------
DECLARE @TestDate DATETIME = GETDATE();

SELECT CONVERT(DATE, @TestDate) AS 'Date';

SELECT DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) AS 'Date Part Only';

DECLARE @GETDATE AS DATETIME = GETDATE()
SELECT CONVERT(VARCHAR(4),DATEPART(YEAR, @GETDATE)) 
       + '/'+ CONVERT(VARCHAR(2),DATEPART(MONTH, @GETDATE)) 
       + '/' + CONVERT(VARCHAR(2),DATEPART(DAY, @GETDATE)) 
       AS 'Date Part Only'
 
