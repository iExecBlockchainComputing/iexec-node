-- ===========================================================================
--
--  Copyright 2014  E. URBAH
--                  at LAL, Univ Paris-Sud, IN2P3/CNRS, Orsay, France
--  License GPL v3
--
--  XtremWeb-HEP Core Tables 'sessions' and 'groups' :
--  SQL script creating views showing also the numbers of waiting, pending,
--  running, error, completed, aborted, lost, ... and all jobs.
--
-- ===========================================================================
drop  view  if exists  view_groups;
drop  view  if exists  view_sessions;

-- ---------------------------------------------------------------------------
create  view  view_sessions  as
-- ---------------------------------------------------------------------------
select 
  sessions.uid,
  users.login                         as owner,
  usergroups.label                    as usergroup,
  sessions.name,
  sessions.mtime,
  sessions.accessRights,
  sessions.isdeleted,
  sessions.errorMsg,
  sum(works.status = 'WAITING')       as Waiting,
  sum(works.status = 'PENDING')       as Pending,
  sum(works.status = 'RUNNING')       as Running,
  sum(works.status = 'REPLICATING')   as Replicating,
  sum(works.status = 'ERROR')         as Error,
  sum(works.status = 'COMPLETED')     as Completed,
  sum(works.status = 'ABORTED')       as Aborted,
  sum(works.status = 'LOST')          as Lost,
  sum(works.status = 'DATAREQUEST')   as DataRequest,
  sum(works.status = 'RESULTREQUEST') as ResultRequest,
  count(works.uid)                    as nb_works
from      sessions
left join users      on sessions.ownerUID  = users.uid
left join usergroups on users.usergroupUID = usergroups.uid
left join works      on sessions.uid       = works.sessionUID
group by  sessions.uid, owner, usergroup, sessions.name,
          sessions.mtime,     sessions.accessRights,
          sessions.isdeleted, sessions.errorMsg;

-- ---------------------------------------------------------------------------
create  view  view_groups  as
-- ---------------------------------------------------------------------------
select 
  groups.uid,
  sessions.name                       as session,
  users.login                         as owner,
  usergroups.label                    as usergroup,
  groups.name,
  groups.mtime,
  groups.accessRights,
  groups.isdeleted,
  groups.errorMsg,
  sum(works.status = 'WAITING')       as Waiting,
  sum(works.status = 'PENDING')       as Pending,
  sum(works.status = 'RUNNING')       as Running,
  sum(works.status = 'REPLICATING')   as Replicating,
  sum(works.status = 'ERROR')         as Error,
  sum(works.status = 'COMPLETED')     as Completed,
  sum(works.status = 'ABORTED')       as Aborted,
  sum(works.status = 'LOST')          as Lost,
  sum(works.status = 'DATAREQUEST')   as DataRequest,
  sum(works.status = 'RESULTREQUEST') as ResultRequest,
  count(works.uid) as nb_works
from      groups
left join users      on groups.ownerUID    = users.uid
left join sessions   on groups.sessionUID  = sessions.uid
left join usergroups on users.usergroupUID = usergroups.uid
left join works      on groups.uid         = works.groupUID
group by  groups.uid, session, owner, usergroup, groups.name,
          groups.mtime,     groups.accessRights,
          groups.isdeleted, groups.errorMsg;
