--
-- Version : 8.2.0
--
-- File    : xwupdatedb-8.2.0.sql
-- Purpose : since 8.2.0 works table has a wallclocktime column
--




ALTER TABLE  works         ADD COLUMN wallclocktime int(10);
ALTER TABLE  works_history ADD COLUMN wallclocktime int(10);

update works set wallclocktime=21600;

--
-- End Of File
--
