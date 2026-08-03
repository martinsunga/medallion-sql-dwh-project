/*
===============================================================================
Table: silver.load_log
===============================================================================
Purpose:
    Stores the load history for each silver table load. Used to track whether
    a table load succeeded or failed, how long it took, and (if applicable)
    the error message returned.

Populated By:
    silver.load_silver (stored procedure)

Columns:
    log_id                  : Auto-incrementing identifier for each log entry.
    table_name              : Name of the silver table that was loaded.
    load_status             : Result of the load, either 'SUCCESS' or 'FAILED'.
    load_duration_seconds   : Time taken to load the table, in seconds. 
                              NULL if the load failed.
    error_message           : Error details if the load failed. 
                              NULL if the load succeeded.
    load_time               : Timestamp of when the log entry was created.
===============================================================================
*/

DROP TABLE IF EXISTS silver.load_log;
GO
CREATE TABLE silver.load_log (
	log_id INT 				IDENTITY(1,1) PRIMARY KEY,
	table_name 				NVARCHAR(100),
	load_status 			NVARCHAR(20),
	load_duration_seconds 	INT NULL,
	error_message 			NVARCHAR(4000) NULL,
	load_time 				DATETIME2 DEFAULT GETDATE()
);
