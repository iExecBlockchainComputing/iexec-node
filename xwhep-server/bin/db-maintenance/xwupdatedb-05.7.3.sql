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
-- Version : 5.7.3
--
-- File    : xwupdatedb-5.7.3.sql
-- Purpose : this file contains the needed SQL commands to 
--           update the XWHEP database from previous versions
--


-- 
-- Since XWHEP 5.7.3 ipaddr and natedipaddr length are 50 to comply to IP V6
-- 
ALTER TABLE hosts MODIFY COLUMN ipaddr      char(50);
ALTER TABLE hosts MODIFY COLUMN natedipaddr char(50);
-- 
-- Since XWHEP 5.7.3 Pilot Jobs are noted on DB
-- 
ALTER TABLE hosts ADD    COLUMN pilotjob    char(5)   DEFAULT 'false';


--
-- End Of File
--
