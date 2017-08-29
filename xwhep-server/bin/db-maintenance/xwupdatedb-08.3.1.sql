-- 
-- Version : 8.3.1
-- 
-- File    : xwupdatedb-8.3.1.sql
-- Purpose : since 8.3.1
--           table 'version' is renamed as 'versions'
--           table 'version' is renamed as 'versions'
-- 




ALTER TABLE  version         RENAME AS     versions;
ALTER TABLE  groups          MODIFY COLUMN sessionUID char(50);
ALTER TABLE  groups_history  MODIFY COLUMN sessionUID char(50);

-- 
-- End Of File
-- 
