-- ===========================================================================
--  Copyrights     : CNRS
--  Authors        : Oleg Lodygensky
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
-- ===========================================================================

--
-- Version : 9.1.0
--
-- File    : xwupdatedb-9.1.0.sql
-- Purpose : this file contains the needed SQL commands to 
--           test if DB is 9.1.0 compliant
--




ALTER TABLE  hosts            ADD    COLUMN availablemem         int(10);
ALTER TABLE  hosts            MODIFY COLUMN cpuspeed             int(10);
ALTER TABLE  apps             MODIFY COLUMN minFreeMassStorage   bigint;
ALTER TABLE  works            MODIFY COLUMN diskSpace            bigint;
ALTER TABLE  works            MODIFY COLUMN minFreeMassStorage   bigint;

ALTER TABLE  hosts_history    ADD    COLUMN availablemem         int(10);
ALTER TABLE  hosts_history    MODIFY COLUMN cpuspeed             int(10);
ALTER TABLE  apps_history     MODIFY COLUMN minFreeMassStorage   bigint;
ALTER TABLE  works_history    MODIFY COLUMN diskSpace            bigint;
ALTER TABLE  works_history    MODIFY COLUMN minFreeMassStorage   bigint;


--
-- End Of File
--
