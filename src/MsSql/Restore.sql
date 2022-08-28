
RESTORE DATABASE WideWorldImporters FROM DISK = N'C:\Users\msi\Downloads\WideWorldImporters-Standard.bak'


RESTORE DATABASE WideWorldImporters FROM DISK = N'C:\Users\msi\Downloads\WideWorldImporters-Standard.bak' WITH 
	MOVE 'WideWorldImporters' TO 'C:\Users\msi\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\WideWorldImporters.mdf'
	, 
	MOVE 'WideWorldImporters_Log' TO 'C:\Users\msi\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\WideWorldImporters_Log.ldf'


RESTORE FILELISTONLY from disk=N'C:\Users\msi\Downloads\WideWorldImporters-Standard.bak'

-- The following finally works
RESTORE DATABASE WideWorldImporters FROM DISK = N'C:\Users\msi\Downloads\WideWorldImporters-Standard.bak' WITH 
MOVE 'WWI_Primary' TO 'C:\Users\msi\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\WideWorldImporters.mdf'
, MOVE 'WWI_Log' TO 'C:\Users\msi\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\WideWorldImporters_Log.ldf'
, MOVE 'WWI_UserData'  TO 'C:\Users\msi\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\WideWorldImporters_UserData.ndf'

