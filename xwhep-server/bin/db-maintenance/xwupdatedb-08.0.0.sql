--
-- Version : 8.0.0
--
-- File    : xwupdatedb-8.0.0.sql
-- Purpose : this file contains the needed SQL commands to 
--           update the XWHEP database from previous versions
--




ALTER TABLE  apps         ADD COLUMN launchscriptshuri  varchar(200);
ALTER TABLE  apps         ADD COLUMN launchscriptcmduri varchar(200);
ALTER TABLE  apps         ADD COLUMN unloadscriptshuri  varchar(200);
ALTER TABLE  apps         ADD COLUMN unloadscriptcmduri varchar(200);
ALTER TABLE  apps         ADD COLUMN envvars varchar(200);
ALTER TABLE  apps         ADD COLUMN type varchar(50) DEFAULT 'none';
ALTER TABLE  apps         ADD COLUMN neededpackages varchar(200);

ALTER TABLE  datas        MODIFY COLUMN size bigint;

ALTER TABLE  hosts        ADD COLUMN sharedapps     varchar(200);
ALTER TABLE  hosts        ADD COLUMN sharedpackages varchar(200);
ALTER TABLE  hosts        ADD COLUMN shareddatas varchar(200);
ALTER TABLE  hosts        ADD COLUMN incomingconnections char(5) DEFAULT 'false';
ALTER TABLE  hosts        ADD COLUMN cpuLoad int(3) DEFAULT 50;

ALTER TABLE  tasks        ADD COLUMN workUID char(50) NOT NULL;

ALTER TABLE  works        ADD COLUMN envvars varchar(200);
ALTER TABLE  works        ADD COLUMN retry int(3);
ALTER TABLE  works        ADD COLUMN listenport char(200);
ALTER TABLE  works        ADD COLUMN smartsocketaddr text;
ALTER TABLE  works        ADD COLUMN smartsocketclient text;
ALTER TABLE  works        ADD COLUMN diskSpace int(10) default 0;
ALTER TABLE  works        ADD COLUMN readydate datetime;
ALTER TABLE  works        ADD COLUMN datareadydate datetime;
ALTER TABLE  works        ADD COLUMN compstartdate datetime;
ALTER TABLE  works        ADD COLUMN compenddate datetime;



ALTER TABLE  apps_history         ADD COLUMN launchscriptshuri  varchar(200);
ALTER TABLE  apps_history         ADD COLUMN launchscriptcmduri varchar(200);
ALTER TABLE  apps_history         ADD COLUMN unloadscriptshuri  varchar(200);
ALTER TABLE  apps_history         ADD COLUMN unloadscriptcmduri varchar(200);
ALTER TABLE  apps_history         ADD COLUMN envvars varchar(200);
ALTER TABLE  apps_history         ADD COLUMN type varchar(50) DEFAULT 'none';
ALTER TABLE  apps_history         ADD COLUMN neededpackages varchar(200);

ALTER TABLE  hosts_history        ADD COLUMN sharedapps     varchar(200);
ALTER TABLE  hosts_history        ADD COLUMN sharedpackages varchar(200);
ALTER TABLE  hosts_history        ADD COLUMN shareddatas varchar(200);
ALTER TABLE  hosts_history        ADD COLUMN incomingconnections char(5) DEFAULT 'false';
ALTER TABLE  hosts_history        ADD COLUMN cpuLoad int(3) DEFAULT 50;

ALTER TABLE  tasks_history        ADD COLUMN workUID char(50) NOT NULL;

ALTER TABLE  works_history        ADD COLUMN envvars varchar(200);
ALTER TABLE  works_history        ADD COLUMN retry int(3);
ALTER TABLE  works_history        ADD COLUMN listenport char(200);
ALTER TABLE  works_history        ADD COLUMN smartsocketaddr text;
ALTER TABLE  works_history        ADD COLUMN smartsocketclient text;
ALTER TABLE  works_history        ADD COLUMN diskSpace int(10) default 0;
ALTER TABLE  works_history        ADD COLUMN readydate datetime;
ALTER TABLE  works_history        ADD COLUMN datareadydate datetime;
ALTER TABLE  works_history        ADD COLUMN compstartdate datetime;
ALTER TABLE  works_history        ADD COLUMN compenddate datetime;



-- 
-- since XWHEP 8, tasks have their own UID and are linked to work through workuid column
-- 

update tasks set workuid=uid;
update tasks_history set workuid=uid;



--
-- End Of File
--
