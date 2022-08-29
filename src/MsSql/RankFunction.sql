-- First create a rank_demo table.
/****************************************************
USE WideWorldImporters
GO

CREATE SCHEMA Examples;
GO

CREATE TABLE Examples.Rank_Demo (
	v VARCHAR(10)
);

GO

USE WideWorldImporters
GO

INSERT INTO Examples.Rank_Demo(v)
VALUES('A'),('B'),('B'),('C'),('C'),('D'),('E');

DROP TABLE [Examples].[EmployeeSalary]

GO
**********************************************/


SELECT v FROM Examples.Rank_Demo 

SELECT
	v,
	RANK () OVER ( 
		ORDER BY v 
	) rank_no,
	DENSE_RANK () OVER ( 
		ORDER BY v 
	) dense_rank_no
FROM
	Examples.Rank_Demo;


SELECT v, asdf = 
CASE v
	WHEN 'M' THEN 'N'
	WHEN 'E' THEN 'F'
	END
FROM Examples.Rank_Demo 


