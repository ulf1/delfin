-- How to debug a locked InnoDB table?
-- Typical symptom: `Error Code: 1205. Lock wait timeout exceeded; try restarting transaction`. 
-- I.e. queries will timeout on a locked table. 
-- Usually previous query caused the lock and is still running as (unfinished) process. 
-- The solution is to find the problematic process and kill it.

-- get a full report
SHOW ENGINE INNODB STATUS;

-- get problematic process IDs
SHOW FULL PROCESSLIST;

-- kill problematic a process ID
KILL 1234567890;
