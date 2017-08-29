--
-- Version : 8.0.0
--
-- File    : xwcheckdb-8.0.0.sql
-- Purpose : this file contains the needed SQL commands to 
--           test if DB is 7.2.0 compliant
--


-- 
-- Since XWHEP 8.0.0 :
--  * apps contains two rows for init scripts
-- 
SELECT launchscriptshuri FROM apps;

--
-- End Of File
--
