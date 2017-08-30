
-- VIEWS for XtremWeb-HEP core tables

-- DROP
drop view if exists view_users;
drop view if exists view_usergroups;
drop view if exists view_hosts;
drop view if exists view_traces;
drop view if exists view_datas;
drop view if exists view_apps;
drop view if exists view_sessions;
drop view if exists view_groups;
drop view if exists view_works;
drop view if exists view_tasks;

-- USERS
create view  view_users  as
select
             users1.uid,
             users1.login,
             userRights.userRightName as "userRightName",
             users1.rights,
             usergroups.label         as "usergroup",
             users2.login             as "owner",
             users1.mtime,
             users1.nbJobs,
             users1.pendingJobs,
             users1.runningJobs,
             users1.errorJobs,
             users1.usedCpuTime,
             users1.certificate,
             users1.accessRights,
             users1.password,
             users1.email,
             users1.fname,
             users1.lname,
             users1.country,
             users1.challenging,
             users1.isdeleted,
             users1.errorMsg,
             null
from         users as users1
left join    userRights       on  users1.userRightId  = userRights.userRightId
left join    usergroups       on  users1.usergroupUID = usergroups.uid
left join    users as users2  on  users1.ownerUID     = users2.uid;
show warnings;

-- USERGROUPS
create view  view_usergroups  as
select
             usergroups.uid,
             usergroups.label,
             users.login as "owner",
             usergroups.mtime,
             usergroups.accessRights,
             usergroups.webpage,
             usergroups.project,
             usergroups.isdeleted,
             usergroups.errorMsg,
             null
from         usergroups
left join    users  on  usergroups.ownerUID = users.uid;
show warnings;

-- HOSTS
create view  view_hosts  as
select
             hosts.uid,
             hosts.osId,
             hosts.os,
             hosts.osversion,
             cpuTypes.cpuTypeName,
             hosts.cputype,
             usergroups1.label    as "projectName",
             hosts.project,
             hosts.sharedapps,
             hosts.sharedpackages,
             hosts.shareddatas,
             users.login          as "owner",  usergroups2.label as "usergroup",
             hosts.name,
             hosts.mtime,
             hosts.poolworksize,
             hosts.nbJobs,
             hosts.pendingJobs,
             hosts.runningJobs,
             hosts.errorJobs,
             hosts.timeOut,
             hosts.avgExecTime,
             hosts.lastAlive,
             hosts.nbconnections,
             hosts.natedipaddr,
             hosts.ipaddr,
             hosts.hwaddr,
             hosts.timezone,
             hosts.javaversion,
             hosts.javadatamodel,
             hosts.cpunb,
             hosts.cpumodel,
             hosts.cpuspeed,
             hosts.totalmem,
             hosts.availablemem,
             hosts.totalswap,
             hosts.totaltmp,
             hosts.freetmp,
             hosts.timeShift,
             hosts.avgping,
             hosts.nbping,
             hosts.uploadbandwidth,
             hosts.downloadbandwidth,
             hosts.accessRights,
             hosts.cpuLoad,
             hosts.active,
             hosts.available,
             hosts.incomingconnections,
             hosts.acceptbin,
             hosts.version,
             hosts.traces,
             hosts.isdeleted,
             hosts.pilotjob,
             hosts.sgid,
             hosts.jobid,
             hosts.batchid,
             hosts.userproxy,
             hosts.errorMsg,
             null
from         hosts
left join    oses                       on  hosts.osId         = oses.osId
left join    cpuTypes                   on  hosts.cpuTypeId    = cpuTypes.cpuTypeId
left join    usergroups as usergroups1  on  hosts.usergroupUID = usergroups1.uid
left join    users                      on  hosts.ownerUID     = users.uid
left join    usergroups as usergroups2  on  users.usergroupUID = usergroups2.uid;
show warnings;

-- TRACES
create view  view_traces  as
select
             traces.uid,
             hosts.name  as "host",
             users.login as "owner",  usergroups.label as "usergroup",
             traces.mtime,
             traces.login,
             traces.arrivalDate,
             traces.startDate,
             traces.endDate,
             traces.accessRights,
             traces.data,
             traces.isdeleted,
             null
from         traces
left join    hosts       on  traces.hostUID      = hosts.uid
left join    users       on  traces.ownerUID     = users.uid
left join    usergroups  on  users.usergroupUID = usergroups.uid;
show warnings;

-- DATAS
create view  view_datas  as
select
             datas.uid,
             datas.workUID,
             datas.package,
             statuses.statusName,
             datas.status,
             dataTypes.dataTypeName,
             datas.type,
             oses.osName,
             datas.os,
             datas.osVersion,
             cpuTypes.cpuTypeName,
             datas.cpu,
             users.login as "owner",  usergroups.label as "usergroup",
             datas.name,
             datas.mtime,
             datas.uri,
             datas.accessRights,
             datas.links,
             datas.accessDate,
             datas.insertionDate,
             datas.md5,
             datas.size,
             datas.sendToClient,
             datas.replicated,
             datas.isdeleted,
             datas.errorMsg,
             null
from         datas
left join    statuses    on  datas.statusId     = statuses.statusId
left join    dataTypes   on  datas.dataTypeId   = dataTypes.dataTypeId
left join    oses        on  datas.osId         = oses.osId
left join    cpuTypes    on  datas.cpuTypeId    = cpuTypes.cpuTypeId
left join    users       on  datas.ownerUID     = users.uid
left join    usergroups  on  users.usergroupUID = usergroups.uid;
show warnings;

-- APPS
create view  view_apps  as
select
             apps.uid,
             apps.name,
             appTypes.appTypeName,
             apps.type,
             packageTypes.packageTypeName,
             apps.neededpackages,
             users.login as "owner",  usergroups.label as "usergroup",
             apps.mtime,
             apps.envvars,
             apps.isdeleted,
             apps.isService,
             apps.accessRights,
             apps.avgExecTime,
             apps.minMemory,
             apps.minCPUSpeed,
             apps.minFreeMassStorage,
             apps.nbJobs,
             apps.pendingJobs,
             apps.runningJobs,
             apps.errorJobs,
             apps.webpage,
             apps.defaultStdinURI,
             apps.baseDirinURI,
             apps.defaultDirinURI,
             apps.launchscriptshuri,
             apps.launchscriptcmduri,
             apps.unloadscriptshuri,
             apps.unloadscriptcmduri,
             apps.errorMsg,
             apps.linux_ix86URI,
             apps.linux_amd64URI,
             apps.linux_x86_64URI,
             apps.linux_ia64URI,
             apps.linux_ppcURI,
             apps.macos_ix86URI,
             apps.macos_x86_64URI,
             apps.macos_ppcURI,
             apps.win32_ix86URI,
             apps.win32_amd64URI,
             apps.win32_x86_64URI,
             apps.javaURI,
             apps.osf1_alphaURI,
             apps.osf1_sparcURI,
             apps.solaris_alphaURI,
             apps.solaris_sparcURI,
             apps.ldlinux_ix86URI,
             apps.ldlinux_amd64URI,
             apps.ldlinux_x86_64URI,
             apps.ldlinux_ia64URI,
             apps.ldlinux_ppcURI,
             apps.ldmacos_ix86URI,
             apps.ldmacos_x86_64URI,
             apps.ldmacos_ppcURI,
             apps.ldwin32_ix86URI,
             apps.ldwin32_amd64URI,
             apps.ldwin32_x86_64URI,
             apps.ldosf1_alphaURI,
             apps.ldosf1_sparcURI,
             apps.ldsolaris_alphaURI,
             apps.ldsolaris_sparcURI,
             null
from         apps
left join    appTypes     on  apps.appTypeId     = appTypes.appTypeId
left join    packageTypes on  apps.packageTypeId = packageTypes.packageTypeId
left join    users        on  apps.ownerUID      = users.uid
left join    usergroups   on  users.usergroupUID  = usergroups.uid;
show warnings;

-- SESSIONS
create view  view_sessions  as
select
             sessions.uid,
             users.login as "owner",  usergroups.label as "usergroup",
             sessions.name,
             sessions.mtime,
             sessions.accessRights,
             sessions.isdeleted,
             sessions.errorMsg,
             null
from         sessions
left join    users       on  sessions.ownerUID     = users.uid
left join    usergroups  on  users.usergroupUID = usergroups.uid;
show warnings;

-- GROUPS
create view  view_groups  as
select
             groups.uid,
             sessions.name as "session",
             users.login   as "owner",  usergroups.label as "usergroup",
             groups.name,
             groups.mtime,
             groups.accessRights,
             groups.isdeleted,
             groups.errorMsg,
             null
from         groups
left join    sessions    on  groups.sessionUID   = sessions.uid
left join    users       on  groups.ownerUID     = users.uid
left join    usergroups  on  users.usergroupUID = usergroups.uid;
show warnings;

-- WORKS
create view  view_works  as
select
             works.uid,
             apps.name           as "application",
             statuses.statusName as "statusName",
             works.status,
             sessions.name       as "session",
             groups.name         as "group",
             hosts.name          as "expectedhost",
             users.login         as "owner",  usergroups.label as "usergroup",
             works.label,
             works.mtime,
             works.userproxy,
             works.accessRights,
             works.sgid,
             works.wallclocktime,
             works.maxRetry,
             works.retry,
             works.diskSpace,
             works.minMemory,
             works.minCPUSpeed,
             works.minFreeMassStorage,
             works.maxWallClockTime,
             works.returnCode,
             works.server,
             works.cmdLine,
             works.listenport,
             works.smartsocketaddr,
             works.smartsocketclient,
             works.stdinURI,
             works.dirinURI,
             works.resultURI,
             works.arrivalDate,
             works.completedDate,
             works.resultDate,
             works.readydate,
             works.datareadydate,
             works.compstartdate,
             works.compenddate,
             works.error_msg,
             works.sendToClient,
             works.local,
             works.active,
             works.replicatedUID,
             works.replications,
             works.sizer,
             works.totalr,
             works.datadrivenURI,
             works.isService,
             works.isdeleted,
             works.envvars,
             works.errorMsg,
             null
from         works
left join    apps        on  works.appUID          = apps.uid
left join    statuses    on  works.statusId        = statuses.statusId
left join    sessions    on  works.sessionUID      = sessions.uid
left join    groups      on  works.groupUID        = groups.uid
left join    hosts       on  works.expectedhostUID = hosts.uid
left join    users       on  works.ownerUID        = users.uid
left join    usergroups  on  users.usergroupUID    = usergroups.uid;
show warnings;

-- TASKS
create view  view_tasks  as
select
             tasks.uid,
apps.name    as "application",  tasks.workUID,
             hosts.name          as "host",
             statuses.statusName as "statusName",
             tasks.status,
             users.login         as "owner",  usergroups.label as "usergroup",
             tasks.mtime,
             tasks.accessRights,
             tasks.trial,
             tasks.InsertionDate,
             tasks.StartDate,
             tasks.LastStartDate,
             tasks.AliveCount,
             tasks.LastAlive,
             tasks.removalDate,
             tasks.duration,
             tasks.isdeleted,
             tasks.errorMsg,
             null
from         tasks
left join    works       on  tasks.workUID      = works.uid
left join    apps        on  works.appUID       = apps.uid
left join    hosts       on  tasks.hostUID      = hosts.uid
left join    statuses    on  tasks.statusId     = statuses.statusId
left join    users       on  tasks.ownerUID     = users.uid
left join    usergroups  on  users.usergroupUID = usergroups.uid;
show warnings;
