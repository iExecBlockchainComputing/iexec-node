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
-- Version : 5.7.4
--
-- File    : xwrunning.sql
-- Purpose : this file contains the needed SQL commands to 
--           retreive running jobs
-- Usage   : mysql < xwrunning.sql
--


select apps.name,works.status,tasks.status,hosts.name,hosts.pilotjob from works,tasks,apps,hosts where works.isdeleted="false" and apps.isdeleted="false" and tasks.isdeleted="false" and hosts.isdeleted="false" and works.uid=tasks.uid and works.appuid=apps.uid and tasks.hostuid=hosts.uid and works.status="RUNNING";

--
-- End Of File
--
