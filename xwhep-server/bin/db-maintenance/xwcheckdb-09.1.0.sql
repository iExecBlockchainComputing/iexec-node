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
-- File    : xwcheckdb-9.1.0.sql
-- Purpose : this file contains the needed SQL commands to 
--           test if DB is 9.1.0 compliant
--


-- 
-- Since XWHEP 9.1.0 :
--  * some data types have changed
-- 

-- 
-- let always return false to force update, just in case
-- since there is no new nor removed column, but column types modification only, I don't have any other idea
-- ;)
-- 
SELECT availablemem FROM hosts;

--
-- End Of File
--
