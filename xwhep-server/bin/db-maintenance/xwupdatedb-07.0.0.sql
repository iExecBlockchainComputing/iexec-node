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
-- Version : 7.0.0
--
-- File    : xwupdatedb-7.0.0.sql
-- Purpose : this file contains the needed SQL commands to 
--           update the XWHEP database from previous versions
--




-- users.certificate column contains the X509 proxy itself
ALTER TABLE  users MODIFY COLUMN certificate text;
-- more char to store distinguished name
ALTER TABLE  users MODIFY COLUMN login char(250);

-- default 0
ALTER TABLE users MODIFY COLUMN nbJobs int(15) default 0;
-- pending jobs counter; updated on work submission
ALTER TABLE users ADD COLUMN pendingJobs int(15) default 0;
-- running jobs counter; updated on sucessfull worker request
ALTER TABLE users ADD COLUMN runningJobs int(15) default 0;
-- error jobs counter; updated on job error
ALTER TABLE users ADD COLUMN errorJobs int(15) default 0;
-- average execution time. updated on work completion
ALTER TABLE users ADD COLUMN usedCpuTime bigint default 0;

-- default 0
ALTER TABLE apps MODIFY COLUMN avgExecTime int(15) default 0;
ALTER TABLE apps MODIFY COLUMN nbJobs int(15) default 0;
-- linux intel itanium library
ALTER TABLE apps ADD COLUMN ldlinux_ia64URI char(200);
-- linux intel itanium binary
ALTER TABLE apps ADD COLUMN linux_ia64URI char(200);
-- pending jobs counter; updated on work submission
ALTER TABLE apps ADD COLUMN pendingJobs int(15) default 0;
-- running jobs counter; updated on sucessfull worker request
ALTER TABLE apps ADD COLUMN runningJobs int(15) default 0;
-- error jobs counter; updated on job error
ALTER TABLE apps ADD COLUMN errorJobs int(15) default 0;
-- application web page
ALTER TABLE apps ADD COLUMN webpage char(200);

-- default 0
ALTER TABLE hosts MODIFY COLUMN avgExecTime int(15) default 0;
ALTER TABLE hosts MODIFY COLUMN nbJobs int(15) default 0;
-- this is the amount of simultaneous jobs
ALTER TABLE hosts ADD COLUMN poolworksize int(2) default 0;
-- pending jobs counter; updated on work submission
ALTER TABLE hosts ADD COLUMN pendingJobs int(15) default 0;
-- running jobs counter; updated on sucessfull worker request
ALTER TABLE hosts ADD COLUMN runningJobs int(15) default 0;
-- error jobs counter; updated on job error
ALTER TABLE hosts ADD COLUMN errorJobs int(15) default 0;
-- cpu speed
ALTER TABLE hosts MODIFY COLUMN cpuspeed bigint default 0;
-- total swap
ALTER TABLE hosts MODIFY COLUMN totalswap bigint default 0;
-- total memory
ALTER TABLE hosts MODIFY COLUMN totalmem bigint default 0;
-- total space on tmp partition
ALTER TABLE hosts ADD COLUMN totaltmp bigint default 0;
-- free space on tmp partition
ALTER TABLE hosts ADD COLUMN freetmp bigint default 0;
-- this is the Service Grid Identifier; this is set by the DG 2 SG bridge, if any
ALTER TABLE hosts ADD COLUMN sgid char(200);

-- application web page
ALTER TABLE usergroups ADD COLUMN webpage char(200);

-- this is the Service Grid Identifier; this is set by the DG 2 SG bridge, if any
ALTER TABLE tasks MODIFY COLUMN duration bigint default 0;

-- we keep track of installations
alter table version add column installation datetime;


-- 
-- Since XWHEP 7.0.0 :
--  * table works_history contains deleted rows from works table
--  * table tasks_history contains deleted rows from tasks table
--
CREATE TABLE IF NOT EXISTS apps_history       LIKE apps;
CREATE TABLE IF NOT EXISTS datas_history      LIKE datas;
CREATE TABLE IF NOT EXISTS groups_history     LIKE groups;
CREATE TABLE IF NOT EXISTS hosts_history      LIKE hosts;
CREATE TABLE IF NOT EXISTS sessions_history   LIKE sessions;
CREATE TABLE IF NOT EXISTS tasks_history      LIKE tasks;
CREATE TABLE IF NOT EXISTS traces_history     LIKE traces;
CREATE TABLE IF NOT EXISTS usergroups_history LIKE usergroups;
CREATE TABLE IF NOT EXISTS users_history      LIKE users;
CREATE TABLE IF NOT EXISTS works_history      LIKE works;

--
-- if history tables already exists, let ensure they reflect production ones
--

-- users_history.certificate column contains the X509 proxy itself
ALTER TABLE  users_history MODIFY COLUMN certificate text;
-- more char to store distinguished name
ALTER TABLE  users_history MODIFY COLUMN login char(250);

-- default 0
ALTER TABLE users_history MODIFY COLUMN nbJobs int(15) default 0;
-- pending jobs counter; updated on work submission
ALTER TABLE users_history ADD COLUMN pendingJobs int(15) default 0;
-- running jobs counter; updated on sucessfull worker request
ALTER TABLE users_history ADD COLUMN runningJobs int(15) default 0;
-- error jobs counter; updated on job error
ALTER TABLE users_history ADD COLUMN errorJobs int(15) default 0;
-- average execution time. updated on work completion
ALTER TABLE users_history ADD COLUMN usedCpuTime bigint default 0;

-- default 0
ALTER TABLE apps_history MODIFY COLUMN avgExecTime int(15) default 0;
ALTER TABLE apps_history MODIFY COLUMN nbJobs int(15) default 0;
-- linux intel itanium library
ALTER TABLE apps_history ADD COLUMN ldlinux_ia64URI char(200);
-- linux intel itanium binary
ALTER TABLE apps_history ADD COLUMN linux_ia64URI char(200);
-- pending jobs counter; updated on work submission
ALTER TABLE apps_history ADD COLUMN pendingJobs int(15) default 0;
-- running jobs counter; updated on sucessfull worker request
ALTER TABLE apps_history ADD COLUMN runningJobs int(15) default 0;
-- error jobs counter; updated on job error
ALTER TABLE apps_history ADD COLUMN errorJobs int(15) default 0;
-- application web page
ALTER TABLE apps_history ADD COLUMN webpage char(200);

-- default 0
ALTER TABLE hosts_history MODIFY COLUMN avgExecTime int(15) default 0;
ALTER TABLE hosts_history MODIFY COLUMN nbJobs int(15) default 0;
-- this is the amount of simultaneous jobs
ALTER TABLE hosts_history ADD COLUMN poolworksize int(2) default 0;
-- pending jobs counter; updated on work submission
ALTER TABLE hosts_history ADD COLUMN pendingJobs int(15) default 0;
-- running jobs counter; updated on sucessfull worker request
ALTER TABLE hosts_history ADD COLUMN runningJobs int(15) default 0;
-- error jobs counter; updated on job error
ALTER TABLE hosts_history ADD COLUMN errorJobs int(15) default 0;
-- cpu speed
ALTER TABLE hosts_history MODIFY COLUMN cpuspeed bigint default 0;
-- total swap
ALTER TABLE hosts_history MODIFY COLUMN totalswap bigint default 0;
-- total memory
ALTER TABLE hosts_history MODIFY COLUMN totalmem bigint default 0;
-- total space on tmp partition
ALTER TABLE hosts_history ADD COLUMN totaltmp bigint default 0;
-- free space on tmp partition
ALTER TABLE hosts_history ADD COLUMN freetmp bigint default 0;
-- this is the Service Grid Identifier; this is set by the DG 2 SG bridge, if any
ALTER TABLE hosts_history ADD COLUMN sgid char(200);

-- application web page
ALTER TABLE usergroups_history ADD COLUMN webpage char(200);

-- this is the Service Grid Identifier; this is set by the DG 2 SG bridge, if any
ALTER TABLE tasks_history MODIFY COLUMN duration bigint default 0;



--
-- End Of File
--
