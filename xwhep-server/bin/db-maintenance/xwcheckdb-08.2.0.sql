--
-- Version : 8.2.0
--
-- File    : xwcheckdb-8.2.0.sql
-- Purpose : this file contains the needed SQL commands to 
--           test if DB is 8.2.0 compliant
--


-- 
-- Since XWHEP 8.2.0 :
-- works table has a wallclocktime column
-- 
SELECT wallclocktime FROM works;

--
-- End Of File
--
