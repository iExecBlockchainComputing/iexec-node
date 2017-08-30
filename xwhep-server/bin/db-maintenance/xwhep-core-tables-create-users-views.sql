
-- VIEWS for XtremWeb-HEP core tables taking into account the access rights of users

-- DROP
drop view if exists view_users_users;
drop view if exists view_users_usergroups;
drop view if exists view_users_hosts;
drop view if exists view_users_traces;
drop view if exists view_users_datas;
drop view if exists view_users_apps;
drop view if exists view_users_sessions;
drop view if exists view_users_groups;
drop view if exists view_users_works;
drop view if exists view_users_tasks;

-- USERS
create view  view_users_users  as
select       users0.uid                as userUID,
             users0.login              as userLogin,
             userRights0.userRightName as userRight,
             users1.uid,
             users1.login,
             userRights1.userRightName as "userRightName",
             users1.rights,
             usergroups.label          as "usergroup",
             owners.login              as "owner",
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
from       ( users      as users0
inner join   userRights as userRights0  on  users0.userRightId = userRights0.userRightId ),
             users      as users1
left  join   userRights as userRights1  on  users1.userRightId  = userRights1.userRightId
left  join   usergroups                 on  users1.usergroupUID = usergroups.uid
left  join   users      as owners       on  users1.ownerUID     = owners.uid
where        (    userRights0.userRightName = 'SUPER_USER' ) or
             (    users1.ownerUID = users0.uid      ) or
             (    users1.accessrights       & 5 = 5 ) or
             ( ( (users1.accessrights >> 4) & 5 = 5 ) and
               ( ( owners.usergroupUID = users0.usergroupUID ) or
                 ( owners.usergroupUID in ( select usergroupUID from memberships where  userUID = users1.ownerUID ) ) ) );
show warnings;

-- USERGROUPS
create view  view_users_usergroups  as
select       users0.uid                as userUID,
             users0.login              as userLogin,
             userRights0.userRightName as userRight,
             usergroups.uid,
             usergroups.label,
             owners.login as "owner",
             usergroups.mtime,
             usergroups.accessRights,
             usergroups.webpage,
             usergroups.project,
             usergroups.isdeleted,
             usergroups.errorMsg,
             null
from       ( users      as users0
inner join   userRights as userRights0  on  users0.userRightId = userRights0.userRightId ),
             usergroups
left join    users as owners  on  usergroups.ownerUID = owners.uid
where        (    userRights0.userRightName = 'SUPER_USER' ) or
             (    usergroups.ownerUID = users0.uid      ) or
             (    usergroups.accessrights       & 5 = 5 ) or
             ( ( (usergroups.accessrights >> 4) & 5 = 5 ) and
               ( ( owners.usergroupUID = users0.usergroupUID ) or
                 ( owners.usergroupUID in ( select usergroupUID from memberships where  userUID = usergroups.ownerUID ) ) ) );
show warnings;

-- HOSTS
create view  view_users_hosts  as
select       users0.uid                as userUID,
             users0.login              as userLogin,
             userRights0.userRightName as userRight,
             hosts.uid,
             oses.osName,
             hosts.os,
             hosts.osversion,
             cpuTypes.cpuTypeName,
             hosts.cputype,
             usergroups1.label    as "projectName",
             hosts.project,
             hosts.sharedapps,
             hosts.sharedpackages,
             hosts.shareddatas,
             owners.login         as "owner",  usergroups2.label as "usergroup",
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
from       ( users      as users0
inner join   userRights as userRights0  on  users0.userRightId = userRights0.userRightId ),
             hosts
left join    oses                       on  hosts.osId         = oses.osId
left join    cpuTypes                   on  hosts.cpuTypeId    = cpuTypes.cpuTypeId
left join    usergroups as usergroups1  on  hosts.usergroupUID = usergroups1.uid
left join    users      as owners       on  hosts.ownerUID     = owners.uid
left join    usergroups as usergroups2  on  owners.usergroupUID = usergroups2.uid
where        (    userRights0.userRightName = 'SUPER_USER' ) or
             (    hosts.ownerUID = users0.uid      ) or
             (    hosts.accessrights       & 5 = 5 ) or
             ( ( (hosts.accessrights >> 4) & 5 = 5 ) and
               ( ( owners.usergroupUID = users0.usergroupUID ) or
                 ( owners.usergroupUID in ( select usergroupUID from memberships where  userUID = hosts.ownerUID ) ) ) );
show warnings;

-- TRACES
create view  view_users_traces  as
select       users0.uid                as userUID,
             users0.login              as userLogin,
             userRights0.userRightName as userRight,
             traces.uid,
             hosts.name   as "host",
             owners.login as "owner",  usergroups.label as "usergroup",
             traces.mtime,
             traces.login,
             traces.arrivalDate,
             traces.startDate,
             traces.endDate,
             traces.accessRights,
             traces.data,
             traces.isdeleted,
             null
from       ( users      as users0
inner join   userRights as userRights0  on  users0.userRightId = userRights0.userRightId ),
             traces
left join    hosts            on  traces.hostUID      = hosts.uid
left join    users as owners  on  traces.ownerUID     = owners.uid
left join    usergroups       on  owners.usergroupUID = usergroups.uid
where        (    userRights0.userRightName = 'SUPER_USER' ) or
             (    traces.ownerUID = users0.uid      ) or
             (    traces.accessrights       & 5 = 5 ) or
             ( ( (traces.accessrights >> 4) & 5 = 5 ) and
               ( ( owners.usergroupUID = users0.usergroupUID ) or
                 ( owners.usergroupUID in ( select usergroupUID from memberships where  userUID = traces.ownerUID ) ) ) );
show warnings;

-- DATAS
create view  view_users_datas  as
select       users0.uid                as userUID,
             users0.login              as userLogin,
             userRights0.userRightName as userRight,
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
             owners.login as "owner",  usergroups.label as "usergroup",
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
from       ( users      as users0
inner join   userRights as userRights0  on  users0.userRightId = userRights0.userRightId ),
             datas
left join    statuses         on  datas.statusId     = statuses.statusId
left join    dataTypes        on  datas.dataTypeId   = dataTypes.dataTypeId
left join    oses             on  datas.osId         = oses.osId
left join    cpuTypes         on  datas.cpuTypeId    = cpuTypes.cpuTypeId
left join    users as owners  on  datas.ownerUID     = owners.uid
left join    usergroups       on  owners.usergroupUID = usergroups.uid
where        (    userRights0.userRightName = 'SUPER_USER' ) or
             (    datas.ownerUID = users0.uid      ) or
             (    datas.accessrights       & 5 = 5 ) or
             ( ( (datas.accessrights >> 4) & 5 = 5 ) and
               ( ( owners.usergroupUID = users0.usergroupUID ) or
                 ( owners.usergroupUID in ( select usergroupUID from memberships where  userUID = datas.ownerUID ) ) ) );
show warnings;

-- APPS
create view  view_users_apps  as
select       users0.uid                as userUID,
             users0.login              as userLogin,
             userRights0.userRightName as userRight,
             apps.uid,
             apps.name,
             appTypes.appTypeName,
             apps.type,
             packageTypes.packageTypeName,
             apps.neededpackages,
             owners.login as "owner",  usergroups.label as "usergroup",
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
from       ( users      as users0
inner join   userRights as userRights0  on  users0.userRightId = userRights0.userRightId ),
             apps
left join    appTypes         on  apps.appTypeId     = appTypes.appTypeId
left join    packageTypes     on  apps.packageTypeId = packageTypes.packageTypeId
left join    users as owners  on  apps.ownerUID      = owners.uid
left join    usergroups       on  owners.usergroupUID  = usergroups.uid
where        (    userRights0.userRightName = 'SUPER_USER' ) or
             (    apps.ownerUID = users0.uid      ) or
             (    apps.accessrights       & 5 = 5 ) or
             ( ( (apps.accessrights >> 4) & 5 = 5 ) and
               ( ( owners.usergroupUID = users0.usergroupUID ) or
                 ( owners.usergroupUID in ( select usergroupUID from memberships where  userUID = apps.ownerUID ) ) ) );
show warnings;

-- SESSIONS
create view  view_users_sessions  as
select       users0.uid                as userUID,
             users0.login              as userLogin,
             userRights0.userRightName as userRight,
             sessions.uid,
             owners.login as "owner",  usergroups.label as "usergroup",
             sessions.name,
             sessions.mtime,
             sessions.accessRights,
             sessions.isdeleted,
             sessions.errorMsg,
             null
from       ( users      as users0
inner join   userRights as userRights0  on  users0.userRightId = userRights0.userRightId ),
             sessions
left join    users as owners  on  sessions.ownerUID     = owners.uid
left join    usergroups       on  owners.usergroupUID = usergroups.uid
where        (    userRights0.userRightName = 'SUPER_USER' ) or
             (    sessions.ownerUID = users0.uid      ) or
             (    sessions.accessrights       & 5 = 5 ) or
             ( ( (sessions.accessrights >> 4) & 5 = 5 ) and
               ( ( owners.usergroupUID = users0.usergroupUID ) or
                 ( owners.usergroupUID in ( select usergroupUID from memberships where  userUID = sessions.ownerUID ) ) ) );
show warnings;

-- GROUPS
create view  view_users_groups  as
select       users0.uid                as userUID,
             users0.login              as userLogin,
             userRights0.userRightName as userRight,
             groups.uid,
             sessions.name as "session",
             owners.login  as "owner",  usergroups.label as "usergroup",
             groups.name,
             groups.mtime,
             groups.accessRights,
             groups.isdeleted,
             groups.errorMsg,
             null
from       ( users      as users0
inner join   userRights as userRights0  on  users0.userRightId = userRights0.userRightId ),
             groups
left join    sessions         on  groups.sessionUID   = sessions.uid
left join    users as owners  on  groups.ownerUID     = owners.uid
left join    usergroups       on  owners.usergroupUID = usergroups.uid
where        (    userRights0.userRightName = 'SUPER_USER' ) or
             (    groups.ownerUID = users0.uid      ) or
             (    groups.accessrights       & 5 = 5 ) or
             ( ( (groups.accessrights >> 4) & 5 = 5 ) and
               ( ( owners.usergroupUID = users0.usergroupUID ) or
                 ( owners.usergroupUID in ( select usergroupUID from memberships where  userUID = groups.ownerUID ) ) ) );
show warnings;

-- WORKS
create view  view_users_works  as
select       users0.uid                as userUID,
             users0.login              as userLogin,
             userRights0.userRightName as userRight,
             works.uid,
             apps.name           as "application",
             statuses.statusName as "statusName",
             works.status,
             sessions.name       as "session",
             groups.name         as "group",
             hosts.name          as "expectedhost",
             owners.login        as "owner",  usergroups.label as "usergroup",
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
from       ( users      as users0
inner join   userRights as userRights0  on  users0.userRightId = userRights0.userRightId ),
             works
left join    apps             on  works.appUID          = apps.uid
left join    statuses         on  works.statusId        = statuses.statusId
left join    sessions         on  works.sessionUID      = sessions.uid
left join    groups           on  works.groupUID        = groups.uid
left join    hosts            on  works.expectedhostUID = hosts.uid
left join    users as owners  on  works.ownerUID        = owners.uid
left join    usergroups       on  owners.usergroupUID = usergroups.uid
where        (    userRights0.userRightName = 'SUPER_USER' ) or
             (    works.ownerUID = users0.uid      ) or
             (    works.accessrights       & 5 = 5 ) or
             ( ( (works.accessrights >> 4) & 5 = 5 ) and
               ( ( owners.usergroupUID = users0.usergroupUID ) or
                 ( owners.usergroupUID in ( select usergroupUID from memberships where  userUID = works.ownerUID ) ) ) );
show warnings;

-- TASKS
create view  view_users_tasks  as
select       users0.uid                as userUID,
             users0.login              as userLogin,
             userRights0.userRightName as userRight,
             tasks.uid,
apps.name    as "application",  tasks.workUID,
             hosts.name          as "host",
             statuses.statusName as "statusName",
             tasks.status,
             owners.login        as "owner",  usergroups.label as "usergroup",
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
from       ( users      as users0
inner join   userRights as userRights0  on  users0.userRightId = userRights0.userRightId ),
             tasks
left join    works            on  tasks.workUID      = works.uid
left join    apps             on  works.appUID       = apps.uid
left join    hosts            on  tasks.hostUID      = hosts.uid
left join    statuses         on  tasks.statusId     = statuses.statusId
left join    users as owners  on  tasks.ownerUID     = owners.uid
left join    usergroups       on  owners.usergroupUID = usergroups.uid
where        (    userRights0.userRightName = 'SUPER_USER' ) or
             (    tasks.ownerUID = users0.uid      ) or
             (    tasks.accessrights       & 5 = 5 ) or
             ( ( (tasks.accessrights >> 4) & 5 = 5 ) and
               ( ( owners.usergroupUID = users0.usergroupUID ) or
                 ( owners.usergroupUID in ( select usergroupUID from memberships where  userUID = tasks.ownerUID ) ) ) );
show warnings;
