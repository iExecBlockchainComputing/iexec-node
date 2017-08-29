-- 
--  Copyrights     : CNRS
--  Author         : Oleg Lodygensky
--  Acknowledgment : XtremWeb-HEP is based on XtremWeb 1.8.0 by inria : http://www.xtremweb.net/
--  Web            : http://www.xtremweb-hep.org
--  
--       This file is part of XtremWeb-HEP.
-- 
--     XtremWeb-HEP is free software: you can redistribute it and/or modify
--     it under the terms of the GNU General Public License as published by
--     the Free Software Foundation, either version 3 of the License, or
--     (at your option) any later version.
-- 
--     XtremWeb-HEP is distributed in the hope that it will be useful,
--     but WITHOUT ANY WARRANTY; without even the implied warranty of
--     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--     GNU General Public License for more details.
-- 
--     You should have received a copy of the GNU General Public License
--     along with XtremWeb-HEP.  If not, see <http://www.gnu.org/licenses/>.
-- 
-- 



--
-- Version : 7.2.0
--
-- File    : xwupdatedb-7.2.0.sql
-- Purpose : this file contains the needed SQL commands to 
--           update the XWHEP database from previous versions
--




-- linux x86 64 
ALTER TABLE  apps         ADD COLUMN linux_x86_64URI char(200);
ALTER TABLE  apps_history ADD COLUMN linux_x86_64URI char(200);
-- ld linux x86 64 
ALTER TABLE  apps         ADD COLUMN ldlinux_x86_64URI char(200);
ALTER TABLE  apps_history ADD COLUMN ldlinux_x86_64URI char(200);

-- service grid ID
ALTER TABLE  works         ADD COLUMN sgid char(200);
ALTER TABLE  works_history ADD COLUMN sgid char(200);

ALTER TABLE hosts          ADD COLUMN batchid char(200);
ALTER TABLE hosts          ADD COLUMN jobid   char(200);
ALTER TABLE hosts_history  ADD COLUMN batchid char(200);
ALTER TABLE hosts_history  ADD COLUMN jobid   char(200);


--
-- End Of File
--
