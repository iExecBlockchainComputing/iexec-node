-- ===========================================================================
--  Copyrights     : CNRS
--  Authors        : Oleg Lodygensky, Etienne Urbah
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

-- ===========================================================================
-- 
-- Version : 9.0.0
-- 
-- File    : xwsetupdb.sql
-- 
-- Purpose : This file is a template for a SQL script containing commands to :
--           - Create the XtremWeb-HEP database
--           - Create the tables
--           - Insert the first users
--           - Grant access to the database
-- 
--           Attention :  Only the 'InnoDB' engine is able to manage foreign
--                        keys.  But InnoDB may be replaced by something
--                        else than 'InnoDB'.  Therefore, this file does NOT
--                        contain the creation of FOREIGN KEYS.
-- 
--           Note :  Creation of triggers and views are in separate scripts
-- 
-- Usage   : this is used by xtremweb.database
-- 
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- xtremweb must be replaced by the appropriate database name
-- ---------------------------------------------------------------------------
create database if not exists xtremweb;

use xtremweb;

-- ---------------------------------------------------------------------------
-- Please don't forget to look at the end of this file
-- to set your xtremweb database user privileges
-- ---------------------------------------------------------------------------


-- ===========================================================================
-- 
-- Tables containing constant data
-- 
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Table "versions"  (since XWHEP 5.7.3)
-- Timestamps of XtremWeb-HEP middleware versions
-- ---------------------------------------------------------------------------
create table if not exists  versions  (
  version       varchar(254),
  installation  datetime
  )
engine  = InnoDB,
comment = 'versions = Timestamps of XtremWeb-HEP versions';

show warnings;


-- ---------------------------------------------------------------------------
-- Table "userRights" :
-- Constants for "users"."rights"
-- ---------------------------------------------------------------------------
create table if not exists  userRights  (
  userRightId           tinyint unsigned  not null  primary key,
  userRightName         varchar(254)      not null  unique,
  mtime                 timestamp,
  userRightDescription  varchar(254)
  )
engine  = InnoDB,
comment = 'userRights = Constants for "users"."rights"';

show warnings;


-- ---------------------------------------------------------------------------
-- Table "statuses" :
-- Constants for *."status"
-- ---------------------------------------------------------------------------
create table if not exists  statuses  (
  statusId          tinyint unsigned  not null  primary key,
  statusName        varchar(36)       not null  unique,
  mtime             timestamp,
  statusObjects     varchar(254)      not null,
  statusComment     varchar(254),
  statusDeprecated  varchar(254)
  )
engine  = InnoDB,
comment = 'statuses = Constants for *."status"';

show warnings;


-- ---------------------------------------------------------------------------
-- Table "dataTypes" :
-- Constants for "datas"."type"
-- ---------------------------------------------------------------------------
create table if not exists  dataTypes  (
  dataTypeId           tinyint unsigned  not null  primary key,
  dataTypeName         varchar(254)      not null  unique,
  mtime                timestamp,
  dataTypeDescription  varchar(254)
  )
engine  = InnoDB,
comment = 'dataTypes = Constants for "datas"."type"';

show warnings;


-- ---------------------------------------------------------------------------
-- Table "appTypes" :
-- Constants for "apps"."type"
-- ---------------------------------------------------------------------------
create table if not exists  appTypes  (
  appTypeId           tinyint unsigned  not null  primary key,
  appTypeName         varchar(254)      not null  unique,
  mtime               timestamp,
  appTypeDescription  varchar(254)
  )
engine  = InnoDB,
comment = 'appTypes = Constants for "apps"."type"';

show warnings;


-- ---------------------------------------------------------------------------
-- Table "packageTypes" :
-- Constants for "apps"."neededpackages"
-- ---------------------------------------------------------------------------
create table if not exists  packageTypes  (
  packageTypeId           tinyint unsigned  not null  primary key,
  packageTypeName         varchar(254)      not null  unique,
  mtime                   timestamp,
  packageTypeDescription  varchar(254)
  )
engine  = InnoDB,
comment = 'appTypes = Constants for "apps"."neededpackages"';

show warnings;


-- ---------------------------------------------------------------------------
-- Table "oses" (Operating Systems) :
-- Constants for *."os"
-- ---------------------------------------------------------------------------
create table if not exists  oses  (
  osId           tinyint unsigned  not null  primary key,
  osName         char(7)           not null  unique,
  mtime          timestamp,
  osDescription  varchar(254)
  )
engine  = InnoDB,
comment = 'oses = Constants for *."os"';

show warnings;


-- ---------------------------------------------------------------------------
-- Table "cpuTypes" :
-- Constants for *."cpuType"
-- ---------------------------------------------------------------------------
create table if not exists  cpuTypes  (
  cpuTypeId           tinyint unsigned  not null  primary key,
  cpuTypeName         char(7)           not null  unique,
  mtime               timestamp,
  cpuTypeDescription  varchar(254)
  )
engine  = InnoDB,
comment = 'cpuTypes = Constants for *."cpuType"';

show warnings;


-- ===========================================================================
-- 
-- Initial data for tables containing constant data
-- 
-- ===========================================================================

start transaction;
-- ---------------------------------------------------------------------------
-- Data for table "versions"
-- ---------------------------------------------------------------------------
insert into versions (version, installation) values ('@XWVERSION@', now());

-- ---------------------------------------------------------------------------
-- Data for table "userRights"
-- ---------------------------------------------------------------------------
insert into userRights (userRightId, userRightName, userRightDescription) values ( 0, 'NONE',            null);
insert into userRights (userRightId, userRightName, userRightDescription) values ( 1, 'LISTJOB',         null);
insert into userRights (userRightId, userRightName, userRightDescription) values ( 2, 'INSERTJOB',       null);
insert into userRights (userRightId, userRightName, userRightDescription) values ( 3, 'GETJOB',          null);
insert into userRights (userRightId, userRightName, userRightDescription) values ( 4, 'DELETEJOB',       null);
insert into userRights (userRightId, userRightName, userRightDescription) values ( 5, 'LISTDATA',        null);
insert into userRights (userRightId, userRightName, userRightDescription) values ( 6, 'INSERTDATA',      null);
insert into userRights (userRightId, userRightName, userRightDescription) values ( 7, 'GETDATA',         null);
insert into userRights (userRightId, userRightName, userRightDescription) values ( 8, 'DELETEDATA',      null);
insert into userRights (userRightId, userRightName, userRightDescription) values ( 9, 'LISTGROUP',       null);
insert into userRights (userRightId, userRightName, userRightDescription) values (10, 'INSERTGROUP',     null);
insert into userRights (userRightId, userRightName, userRightDescription) values (11, 'GETGROUP',        null);
insert into userRights (userRightId, userRightName, userRightDescription) values (12, 'DELETEGROUP',     null);
insert into userRights (userRightId, userRightName, userRightDescription) values (13, 'LISTSESSION',     null);
insert into userRights (userRightId, userRightName, userRightDescription) values (14, 'INSERTSESSION',   null);
insert into userRights (userRightId, userRightName, userRightDescription) values (15, 'GETSESSION',      null);
insert into userRights (userRightId, userRightName, userRightDescription) values (16, 'DELETESESSION',   null);
insert into userRights (userRightId, userRightName, userRightDescription) values (17, 'LISTHOST',        null);
insert into userRights (userRightId, userRightName, userRightDescription) values (18, 'GETHOST',         null);
insert into userRights (userRightId, userRightName, userRightDescription) values (19, 'LISTUSER',        null);
insert into userRights (userRightId, userRightName, userRightDescription) values (20, 'GETUSER',         null);
insert into userRights (userRightId, userRightName, userRightDescription) values (21, 'LISTUSERGROUP',   null);
insert into userRights (userRightId, userRightName, userRightDescription) values (22, 'GETUSERGROUP',    null);
insert into userRights (userRightId, userRightName, userRightDescription) values (23, 'LISTAPP',         null);
insert into userRights (userRightId, userRightName, userRightDescription) values (24, 'GETAPP',          null);
insert into userRights (userRightId, userRightName, userRightDescription) values (25, 'STANDARD_USER',   null);
insert into userRights (userRightId, userRightName, userRightDescription) values (26, 'UPDATEWORK',      null);
insert into userRights (userRightId, userRightName, userRightDescription) values (27, 'WORKER_USER',     null);
insert into userRights (userRightId, userRightName, userRightDescription) values (28, 'INSERTUSER',      null);
insert into userRights (userRightId, userRightName, userRightDescription) values (29, 'DELETEUSER',      null);
insert into userRights (userRightId, userRightName, userRightDescription) values (30, 'INSERTAPP',       null);
insert into userRights (userRightId, userRightName, userRightDescription) values (31, 'DELETEAPP',       null);
insert into userRights (userRightId, userRightName, userRightDescription) values (32, 'ADVANCED_USER',   null);
insert into userRights (userRightId, userRightName, userRightDescription) values (33, 'INSERTHOST',      null);
insert into userRights (userRightId, userRightName, userRightDescription) values (34, 'DELETEHOST',      null);
insert into userRights (userRightId, userRightName, userRightDescription) values (35, 'INSERTUSERGROUP', null);
insert into userRights (userRightId, userRightName, userRightDescription) values (36, 'DELETEUSERGROUP', null);
insert into userRights (userRightId, userRightName, userRightDescription) values (37, 'SUPER_USER',      null);

-- ---------------------------------------------------------------------------
-- Data for table "statuses"
-- ---------------------------------------------------------------------------
insert into statuses (statusId, statusName, statusObjects, statusComment, statusDeprecated) values ( 0, 'NONE',          'none',                null,                                                                                null);
insert into statuses (statusId, statusName, statusObjects, statusComment, statusDeprecated) values ( 1, 'ANY',           'any',                 null,                                                                                null);
insert into statuses (statusId, statusName, statusObjects, statusComment, statusDeprecated) values ( 2, 'WAITING',       'works',               'The object is stored on server but not in the server queue yet',                    null);
insert into statuses (statusId, statusName, statusObjects, statusComment, statusDeprecated) values ( 3, 'PENDING',       'works, tasks',        'The object is stored and inserted in the server queue',                             null);
insert into statuses (statusId, statusName, statusObjects, statusComment, statusDeprecated) values ( 4, 'RUNNING',       'works, tasks',        'The object is being run by a worker',                                               null);
insert into statuses (statusId, statusName, statusObjects, statusComment, statusDeprecated) values ( 5, 'ERROR',         'any',                 'The object is erroneous',                                                           null);
insert into statuses (statusId, statusName, statusObjects, statusComment, statusDeprecated) values ( 6, 'COMPLETED',     'works, tasks',        'The job has been successfully computed',                                            null);
insert into statuses (statusId, statusName, statusObjects, statusComment, statusDeprecated) values ( 7, 'ABORTED',       'works, tasks',        'NOT used anymore', 'Since XWHEP, aborted objects are set to PENDING');
insert into statuses (statusId, statusName, statusObjects, statusComment, statusDeprecated) values ( 8, 'LOST',          'works, tasks',        'NOT used anymore', 'Since XWHEP, lost objects are set to PENDING');
insert into statuses (statusId, statusName, statusObjects, statusComment, statusDeprecated) values ( 9, 'DATAREQUEST',   'datas, works, tasks', 'The server is unable to store the uploaded object. Waiting for another upload try', null);
insert into statuses (statusId, statusName, statusObjects, statusComment, statusDeprecated) values (10, 'RESULTREQUEST', 'works',               'The worker should retry to upload the results',                                     null);
insert into statuses (statusId, statusName, statusObjects, statusComment, statusDeprecated) values (11, 'AVAILABLE',     'datas',               'The data is available and can be downloaded on demand',                             null);
insert into statuses (statusId, statusName, statusObjects, statusComment, statusDeprecated) values (12, 'UNAVAILABLE',   'datas',               'The data is not available and can not be downloaded on demand',                     null);
insert into statuses (statusId, statusName, statusObjects, statusComment, statusDeprecated) values (13, 'REPLICATING',   'works',               'The object is being replicated',                                                   null);

-- ---------------------------------------------------------------------------
-- Data for table "dataTypes"
-- ---------------------------------------------------------------------------
insert into dataTypes (dataTypeId, dataTypeName, dataTypeDescription) values ( 0, 'NONE',           'Unknown data type');
insert into dataTypes (dataTypeId, dataTypeName, dataTypeDescription) values ( 1, 'BINARY',         'Binary data');
insert into dataTypes (dataTypeId, dataTypeName, dataTypeDescription) values ( 2, 'LIBRARY',        'Library data');
insert into dataTypes (dataTypeId, dataTypeName, dataTypeDescription) values ( 3, 'JAVA',           'Java byte code');
insert into dataTypes (dataTypeId, dataTypeName, dataTypeDescription) values ( 4, 'TEXT',           'Text data');
insert into dataTypes (dataTypeId, dataTypeName, dataTypeDescription) values ( 5, 'ZIP',            'Compressed data');
insert into dataTypes (dataTypeId, dataTypeName, dataTypeDescription) values ( 6, 'X509',           'X509 certificate');
insert into dataTypes (dataTypeId, dataTypeName, dataTypeDescription) values ( 7, 'URIPASSTHROUGH', 'Text file containing a list of uri, one per line');
insert into dataTypes (dataTypeId, dataTypeName, dataTypeDescription) values ( 8, 'UDPPACKET',      'Data that should be send using udp protocol');
insert into dataTypes (dataTypeId, dataTypeName, dataTypeDescription) values ( 9, 'STREAM',         'Data that should be send using tcp protocol');
insert into dataTypes (dataTypeId, dataTypeName, dataTypeDescription) values (10, 'ISO',            'Disk image');
insert into dataTypes (dataTypeId, dataTypeName, dataTypeDescription) values (11, 'VMDK',           'Virtual machine disk');
insert into dataTypes (dataTypeId, dataTypeName, dataTypeDescription) values (12, 'VDI',            'Virtual disk image');
insert into dataTypes (dataTypeId, dataTypeName, dataTypeDescription) values (13, 'SH',             'SH script');
insert into dataTypes (dataTypeId, dataTypeName, dataTypeDescription) values (14, 'BAT',            'CMD script');

-- ---------------------------------------------------------------------------
-- Data for table "appTypes"
-- ---------------------------------------------------------------------------
insert into appTypes (appTypeId, appTypeName, appTypeDescription) values (0, 'NONE',       'Unknown application type.');
insert into appTypes (appTypeId, appTypeName, appTypeDescription) values (1, 'DEPLOYABLE', 'Type for an application that must be deployed :  Its binary must be downloaded by volunteer resources.');
insert into appTypes (appTypeId, appTypeName, appTypeDescription) values (2, 'SHARED',     'Type for an application that is shared by volunteer resources :  Its binary should not be downloaded by volunteer resources.');
insert into appTypes (appTypeId, appTypeName, appTypeDescription) values (3, 'VIRTUALBOX', 'Type for a VirtualBox image of a virtual machine');
insert into appTypes (appTypeId, appTypeName, appTypeDescription) values (4, 'DOCKER',     'Type for a Docker image of a container');

-- ---------------------------------------------------------------------------
-- Data for table "packageTypes"
-- ---------------------------------------------------------------------------
insert into packageTypes (packageTypeId, packageTypeName, packageTypeDescription) values (0, 'NONE',   'Unknown package type');
insert into packageTypes (packageTypeId, packageTypeName, packageTypeDescription) values (1, 'GEANT4', 'Package for High Energy Physics');
insert into packageTypes (packageTypeId, packageTypeName, packageTypeDescription) values (2, 'ROOT',   'Package for High Energy Physics');

-- ---------------------------------------------------------------------------
-- Data for table "oses"
-- ---------------------------------------------------------------------------
insert into oses (osId, osName, osDescription) values (0, 'NONE',    'Unknown');
insert into oses (osId, osName, osDescription) values (1, 'ANDROID', 'Android');
insert into oses (osId, osName, osDescription) values (2, 'JAVA',    'Java Virtual Machine');
insert into oses (osId, osName, osDescription) values (3, 'LINUX',   'Linux');
insert into oses (osId, osName, osDescription) values (4, 'MACOSX',  'MacOS-X ');
insert into oses (osId, osName, osDescription) values (5, 'WIN32',   'MS-Windows 32 bits');
insert into oses (osId, osName, osDescription) values (6, 'WIN64',   'MS-Windows 64 bits');

-- ---------------------------------------------------------------------------
-- Data for table "cpuTypes"
-- ---------------------------------------------------------------------------
insert into cpuTypes (cpuTypeId, cpuTypeName, cpuTypeDescription) values (0, 'NONE',   'Unknown');
insert into cpuTypes (cpuTypeId, cpuTypeName, cpuTypeDescription) values (1, 'ALL',    'Architecture independant');
insert into cpuTypes (cpuTypeId, cpuTypeName, cpuTypeDescription) values (2, 'AMD64',  'AMD - 64 bits');
insert into cpuTypes (cpuTypeId, cpuTypeName, cpuTypeDescription) values (3, 'ARM',    'Advanced RISC Machines');
insert into cpuTypes (cpuTypeId, cpuTypeName, cpuTypeDescription) values (4, 'IA64',   'Intel Itanium - 64 bits');
insert into cpuTypes (cpuTypeId, cpuTypeName, cpuTypeDescription) values (5, 'IX86',   'Intel x86 - 32 bits');
insert into cpuTypes (cpuTypeId, cpuTypeName, cpuTypeDescription) values (6, 'PPC',    'Power PC');
insert into cpuTypes (cpuTypeId, cpuTypeName, cpuTypeDescription) values (7, 'X86_64', 'Intel x86 - 64 bits');

commit;


-- ===========================================================================
-- 
-- Tables referencing :
--        - Tables containing constant data
--        - Other tables
-- 
-- ===========================================================================


-- ---------------------------------------------------------------------------
-- Table "users" :
-- Owners of objects.  Most users may submit works.
-- ---------------------------------------------------------------------------
create table if not exists  users  (
  uid           char(36)          not null  primary key      comment 'Primary key',
  login         varchar(254)      not null  unique           comment 'User login. if your change length, don t forget to change UserInterface.USERLOGINLENGTH',
  userRightId   tinyint unsigned  not null  default 255      comment 'User rights Id. See common/UserRights.java',
  rights        varchar(254)      not null  default 'NONE'   comment 'User rights (deprecated)',
  usergroupUID  char(36)                                     comment 'Optionnal. user group UID',
  ownerUID      char(36)          not null                   comment 'Owner UID',
  mtime         timestamp                                    comment 'Timestamp of last update',
  nbJobs        int(15)                     default 0        comment 'Completed jobs counter. updated on work completion',
  pendingJobs   int(15)                     default 0        comment 'Pending jobs counter. updated on work submission',
  runningJobs   int(15)                     default 0        comment 'Running jobs counter. updated on work request',
  errorJobs     int(15)                     default 0        comment 'Error jobs counter. updated on job error',
  usedCpuTime   bigint                      default 0        comment 'Average execution time. updated on work completion',
  certificate   text                                         comment 'This is the X.509 proxy file content',
  accessRights  int(4)                      default 0x700    comment 'Since 5.8.0  This defines access rights "a la" linux FS  See xtremweb.common.XWAccessRights.java',
  password      varchar(254)      not null  default ''       comment 'User password',
  email         varchar(254)      not null  default ''       comment 'User email',
  fname         varchar(254)                                 comment 'Optionnal, user first name',
  lname         varchar(254)                                 comment 'Optionnal, user last name',
  country       varchar(254)                                 comment 'User country',
  challenging   char(5)                     default 'false'  comment 'True if this user connect using private/public keys pair',
  isdeleted     char(5)                     default 'false'  comment 'True if this row has been deleted',
  errorMsg      varchar(254)                                 comment 'Error message',
  
  index  userRightId  (userRightId),
  index  usergroupUID (usergroupUID),
  index  ownerUID     (ownerUID)
  ) 
engine  = InnoDB,
comment = 'users = Owners of objects.  Most users may submit works';

show warnings;

create table if not exists  users_history  like  users;

show warnings;


-- ---------------------------------------------------------------------------
-- Table "usergroups" :
-- Groups of users
-- ---------------------------------------------------------------------------
create table if not exists  usergroups  (
  uid           char(36)      not null  primary key      comment 'Primary key',
  label         varchar(254)  not null                   comment 'User group label',
  ownerUID      char(36)      not null                   comment 'Since 5.8.0',
  mtime         timestamp                                comment 'Timestamp of last update',
  accessRights  int(4)                  default 0x700    comment 'Since 5.8.0  This defines access rights "a la" linux FS  See xtremweb.common.XWAccessRights.java',
  webpage       varchar(254)                             comment 'Application web page',
  project       char(5)                 default 'true'   comment 'True if this can be a "project"  This is always true, except for worker and administrator user groups',
  isdeleted     char(5)                 default 'false'  comment 'True if this row has been deleted',
  errorMsg      varchar(254)                             comment 'Error message',
  
  index  ownerUID (ownerUID)
  )
engine  = InnoDB,
comment = 'usergroups = Groups of users';

show warnings;

create table if not exists  usergroups_history  like  usergroups;

show warnings;


-- ---------------------------------------------------------------------------
-- Table "memberships" :
-- Pure n-n relationship between "users" and "usergoups"
-- ---------------------------------------------------------------------------
create table if not exists  memberships  (
  userUID       char(36)   not null,
  usergroupUID  char(36)   not null,
  mtime         timestamp,
  
  index  userUID      (userUID),
  index  usergroupUID (usergroupUID)
  )
engine  = InnoDB,
comment = 'memberships = n-n relationship "users" - "usergoups"';

show warnings;

create table if not exists  memberships_history  like  memberships;

show warnings;


-- ---------------------------------------------------------------------------
-- Table "hosts" :
-- Computing resources where an XWHEP worker may run
-- ---------------------------------------------------------------------------
create table if not exists  hosts  (
  uid                  char(36)      not null  primary key      comment 'Primary key',
  osId                 tinyint unsigned                         comment 'Maybe unknown yet',
  os                   char(7)                                  comment 'OS name',
  osversion            varchar(36)                              comment 'OS version   Since XWHEP 6.0.0',
  cpuTypeId            tinyint unsigned                         comment 'Maybe unknown yet',
  cputype              char(7)                                  comment 'CPU name',
  usergroupUID         char(36)                                 comment 'Optional, UID of the usergroup of the owner of jobs which will match.  Jobs from other groups will NOT match.',
  project              varchar(254)                             comment 'Project this worker wants to limit its participation  In practice, this is a usergroup name  How it works : if a worker runs under an identity that belongs to a usergroup  This worker can execute any public or group job for the users of its group.  This w',  --  Project this worker wants to limit its participation  In practice, this is a usergroup name  How it works : if a worker runs under an identity that belongs to a usergroup  This worker can execute any public or group job for the users of its group.  This worker may want to run group jobs only. It can do so by setting project to its usergroup label',
  sharedapps           varchar(254)                             comment 'Optional, list of coma separated applications shared by the worker  Since 8.0.0 ',
  sharedpackages       varchar(254)                             comment 'Optional, list of coma separated libraries shared by the worker  Since 8.0.0 ',
  shareddatas          varchar(254)                             comment 'Optional, list of coma separated data shared by the worker  Since 8.0.0 (not used yet)',
  ownerUID             char(36)      not null                   comment 'User UID',
  name                 varchar(254)                             comment 'This host name',
  mtime                timestamp                                comment 'Timestamp of last update',
  poolworksize         int(2)                  default 0        comment 'This is the amount of simultaneous jobs',
  nbJobs               int(15)                 default 0        comment 'Completed jobs counter. updated on work completion',
  pendingJobs          int(15)                 default 0        comment 'Pending jobs counter. updated on work submission',
  runningJobs          int(15)                 default 0        comment 'Running jobs counter. updated on work request',
  errorJobs            int(15)                 default 0        comment 'Error jobs counter. updated on job error',
  timeOut              int(15)                                  comment 'How many time to wait before this host is considered as lost  Default is provided by server, but this may also be defined from host config',
  avgExecTime          int(15)                 default 0        comment 'Average execution time. updated on work completion',
  lastAlive            datetime                                 comment 'Last communication time (helps to determine whether this host is lost)',
  nbconnections        int(10)                                  comment 'How many time this host has been connected',
  natedipaddr          varchar(50)                              comment 'This is the IP address as provided by worker itself.  This may be  a NATed IP  Since XWHEP 5.7.3 this length is 50 to comply to IP V6',
  ipaddr               varchar(50)                              comment 'This is the IP address obtained at connexion time.  This is set by server at connexion time.  This may be different from NATed IP.  Since XWHEP 5.7.3 this length is 50 to comply to IP V6',
  hwaddr               varchar(36)                              comment 'MAC address',
  timezone             varchar(254)                             comment 'Time zone',
  javaversion          varchar(254)                             comment 'Java version   Since XWHEP 6.0.0',
  javadatamodel        int(4)                                   comment 'Java data model (32 or 64 bits)  Since XWHEP 6.0.0',
  cpunb                int(2)                                   comment 'CPU counter',
  cpumodel             varchar(50)                              comment 'CPU model',
  cpuspeed             int(10)                 default 0        comment 'CPU speed in MHz',
  totalmem             bigint                  default 0        comment 'Total RAM in Kb',
  availablemem         int(10)                 default 0        comment 'Available RAM in Kb, according to resource owner policy',
  totalswap            bigint                  default 0        comment 'Total SWAP in Mb',
  totaltmp             bigint                  default 0        comment 'Total space on tmp partition in Mb',
  freetmp              bigint                  default 0        comment 'Free space on tmp partition in Mb',
  timeShift            int(15)                                  comment 'Time diff from host to server',
  avgping              int(20)                                  comment 'Average ping to server',
  nbping               int(10)                                  comment 'Ping amount to server',
  uploadbandwidth      float                                    comment 'Upload bandwidth usage (in Mb/s)',
  downloadbandwidth    float                                    comment 'Download bandwidth usage (in Mb/s)',
  accessRights         int(4)                  default 0x700    comment 'This defines access rights "a la" linux FS  See xtremweb.common.XWAccessRights.java  Since 5.8.0',
  cpuLoad              int(3)                  default 50       comment 'This defines the percentage of CPU usable by the worker  Since 8.0.0',
  active               char(5)                 default 'true'   comment 'This flag tells whether this host may be used   If a host has ever generated any error, this flag is automatically set to false  So that we don"t use faulty worker',
  available            char(5)                 default 'false'  comment 'This flag tells whether this host may run jobs accordingly to its local activation policy  This flag is provided by worker with alive signal',
  incomingconnections  char(5)                 default 'false'  comment 'This flag tells whether this host accepts to run jobs that listen for incoming connections  Since 8.0.0',
  acceptbin            char(5)                 default 'true'   comment 'This flag tells whether this host accept application binary   If false, this host accept to execute services written in java only',
  version              varchar(254)  not null                   comment 'This is this host XWHEP software version',
  traces               char(5)                 default 'false'  comment 'This flag tells whether this host is collecting traces (CPU, memory, disk usage)',
  isdeleted            char(5)                 default 'false'  comment 'True if this row has been deleted',
  pilotjob             char(5)                 default 'false'  comment 'XWHEP 5.7.3 : this is set to true if the worker is run on SG ressource (e.g. EGEE)  XWHEP 7.0.0 : this is deprecated; please use sgid instead ',
  sgid                 varchar(254)                             comment 'XWHEP 7.0.0 : this is the Service Grid Identifier; this is set by the DG 2 SG bridge, if any',
  jobid                varchar(254)                             comment 'XWHEP 7.2.0 : this is a job URI; this is for SpeQuLoS (EDGI/JRA2).   If this is set, the worker will receive this job in priority,  If available, and according to the match making - CPU, OS...  This has a higher priority than batchid',
  batchid              varchar(254)                             comment 'XWHEP 7.2.0 : this is a job group URI; this is for SpeQuLoS (EDGI/JRA2).  If this is set, the worker will receive a job from this group in priority,  If any, and according to the match making - CPU, OS...  This has a lower priority than jobid',
  userproxy            varchar(254)                             comment 'XWHEP 7.0.0 this is not used',
  errorMsg             varchar(254)                             comment 'Error message',
  
  index  osId         (osId),
  index  cputypeId    (cputypeId),
  index  usergroupUID (usergroupUID),
  index  ownerUID     (ownerUID),
  index  hosts_characteristics (name, ipaddr, hwaddr, cpuTypeId,
                                cpunb, cpumodel, osId, osversion)
  )
engine  = InnoDB,
comment = 'hosts = Computing resources where an XWHEP worker may run';

show warnings;
 
create table if not exists  hosts_history  like  hosts;

show warnings;


-- ---------------------------------------------------------------------------
-- Table "traces" :
-- Traces from workers (to trace CPU, RAM, Disk etc. activities)
-- NOT USED ANYMORE
-- ---------------------------------------------------------------------------
create table if not exists  traces  (
  uid           char(36)      not null  primary key      comment 'Primary key',
  hostUID       char(36)      not null  default ''       comment 'Host UID',
  ownerUID      char(36)      not null                   comment 'Since 5.8.0',
  mtime         timestamp                                comment 'Timestamp of last update',
  login         varchar(254)  not null  default ''       comment '',
  arrivalDate   datetime      not null,
  startDate     datetime      not null,
  endDate       datetime      not null,
  accessRights  int(4)                  default 0x700    comment 'Since 5.8.0  This defines access rights "a la" linux FS  See xtremweb.common.XWAccessRights.java',
  data          varchar(254)  not null  default ''       comment 'Data URI',
  isdeleted     char(5)                 default 'false'  comment 'True if this row has been deleted',
  
  index  hostUID  (hostUID),
  index  ownerUID (ownerUID)
  )
engine  = InnoDB,
comment = 'traces from workers (to trace CPU, RAM, Disk etc. activities';

show warnings;
 
create table if not exists  traces_history  like  traces;

show warnings;


-- ---------------------------------------------------------------------------
-- Table "sharedAppTypes" :
-- Pure n-n relationship between "hosts" and "appTypes"
-- ---------------------------------------------------------------------------
create table if not exists  sharedAppTypes  (
  hostUID    char(36)            not null,
  appTypeId  tinyint   unsigned  not null,
  mtime      timestamp,
  primary key (hostUID, appTypeId),
  
  index  hostUID   (hostUID),
  index  appTypeId (appTypeId)
  )
engine  = InnoDB,
comment = 'sharedAppTypes = n-n relationship "hosts" - "appTypes"';

show warnings;

create table if not exists  sharedAppTypes_history  like  sharedAppTypes;

show warnings;


-- ---------------------------------------------------------------------------
-- Table "sharedPackageTypes" :
-- Pure n-n relationship between "hosts" and "packageTypes"
-- ---------------------------------------------------------------------------
create table if not exists  sharedPackageTypes  (
  hostUID        char(36)            not null,
  packageTypeId  tinyint    unsigned not null,
  mtime          timestamp,
  primary key (hostUID, packageTypeId),
  
  index  hostUID       (hostUID),
  index  packageTypeId (packageTypeId)
  )
engine  = InnoDB,
comment = 'sharedPackageTypes = n-n relationship "hosts"-"packageTypes"';

show warnings;

create table if not exists  sharedPackageTypes_history  like  sharedPackageTypes;

show warnings;


-- ---------------------------------------------------------------------------
-- Table "datas" :
-- Files (binaries, input files, results)
-- ---------------------------------------------------------------------------
create table if not exists  datas  (
  uid            char(36)          not null  primary key      comment 'Primary key',
  workUID        char(36)                                     comment 'This is the reference work for data driven scheduling. Since 10.0.0',
  package        varchar(254)                                 comment 'Optional, needed packages on worker side. Since 10.0.0',
  statusId       tinyint unsigned  not null  default 255      comment 'Status Id. See common/XWStatus.java',
  status         varchar(36)       not null  default 'NONE'   comment 'Status (deprecated)',
  dataTypeId     tinyint unsigned                             comment 'DataType Id. See common/DataType.java',
  type           varchar(254)                                 comment 'Data type (deprecated)',
  osId           tinyint unsigned                             comment 'OS id',
  os             char(7)                                      comment 'Optionnal. mainly necessary if data is an app binary',
  osVersion      varchar(36)                                  comment 'Optionnal. mainly necessary if data is an app binary',
  cpuTypeId      tinyint unsigned                             comment 'CPU type id',
  cpu            char(7)                                      comment 'Optionnal. mainly necessary if data is an app binary',
  ownerUID       char(36)          not null                   comment 'May be {user, app, work} UID',
  name           varchar(254)                                 comment 'Symbolic file name (i.e. alias name)',
  mtime          timestamp                                    comment 'Timestamp of last update',
  uri            varchar(254)                                 comment 'This is the URI of the content',
  accessRights   int(4)                      default 0x700    comment 'This defines access rights "a la" linux FS  See xtremweb.common.XWAccessRights.java',
  links          int(4)                                       comment 'How many times it is used. can be deleted if 0',
  accessDate     datetime                                     comment 'Last access date',
  insertionDate  datetime                                     comment 'Creation date',
  md5            varchar(254)                                 comment 'Data md5',
  size           bigint                                       comment 'Effective file size',
  sendToClient   char(5)                     default 'false'  comment 'Optionnal. used by replication',
  replicated     char(5)                     default 'false'  comment 'Optionnal. used by replication',
  isdeleted      char(5)                     default 'false'  comment 'True if row has been deleted ',
  errorMsg       varchar(254)                                 comment 'Error message',
  
  index  statusId   (statusId),
  index  dataTypeId (dataTypeId),
  index  osId       (osId),
  index  cpuTypeId  (cpuTypeId),
  index  ownerUID   (ownerUID)
  )
engine  = InnoDB,
comment = 'datas = Files (binaries, input files, results)';

show warnings;
 
create table if not exists  datas_history  like  datas;

show warnings;


-- ---------------------------------------------------------------------------
-- Table "apps" :
-- Applications, submitted by users inside works
-- ---------------------------------------------------------------------------
create table if not exists  apps  (
  uid                 char(36)          not null  primary key      comment 'Primary key',
  name                varchar(254)      not null  unique           comment 'Secondary key. if your change length, don t forget to change AppInterface.APPNAMELENGTH',
  appTypeId           tinyint unsigned  not null  default 255      comment 'Application type Id. See table AppTypes.',
  type                varchar(254)      not null  default 'NONE'   comment 'Application type :  "NONE" = Undefined; no job will run.  "DEPLOYABLE" = The worker must download the binary.  "SHARED" = Shared application : the worker will not download the binary.  "VIRTUALBOX" = Script for virtualbox shared application.  "VMWARE" = S',  --  Application type :  "NONE" = Undefined; no job will run.  "DEPLOYABLE" = The worker must download the binary.  "SHARED" = Shared application : the worker will not download the binary.  "VIRTUALBOX" = Script for virtualbox shared application.  "VMWARE" = Script for vmware shared application.  Since 8.0.0',
  packageTypeId       tinyint unsigned                             comment 'Optional, Id of a needed package',
  neededpackages      varchar(254)                                 comment 'Optional, needed packages on worker side  Since 8.0.0',
  ownerUID            char(36)          not null                   comment 'Optionnal. user UID',
  mtime               timestamp                                    comment 'Timestamp of last update',
  envvars             varchar(254)                                 comment 'Optional, env vars  Since 8.0.0',
  isdeleted           char(5)                     default 'false'  comment 'True if this row has been deleted',
  isService           char(5)                     default 'false'  comment 'Optionnal. true if app is a service',
  accessRights        int(4)                      default 0x700    comment 'This defines access rights "a la" linux FS  See xtremweb.common.XWAccessRights.java',
  avgExecTime         int(15)                     default 0        comment 'Average execution time. updated on work completion',
  minMemory           int(10)                     default 0        comment 'Optionnal. minimum memory needed in Kb',
  minCPUSpeed         int(10)                     default 0        comment 'Optionnal. minimum CPU speed need in MHz',
  minFreeMassStorage  bigint                      default 0        comment 'Min free amount of mass storage in Mb',
  nbJobs              int(15)                     default 0        comment 'Completed jobs counter. updated on work completion',
  pendingJobs         int(15)                     default 0        comment 'Pending jobs counter. updated on work submission',
  runningJobs         int(15)                     default 0        comment 'Running jobs counter. updated on work request',
  errorJobs           int(15)                     default 0        comment 'Error jobs counter. updated on job error',
  webpage             varchar(254)                                 comment 'Application web page',
  defaultStdinURI     varchar(254)                                 comment 'Optionnal. this is the default STDIN, if any. this is an URI  If set, this is automatically provided to any job, except if job defines its own STDIN  Works.stdin may be set to NULLUID to force no STDIN even if this apps.stdin is defined',
  baseDirinURI        varchar(254)                                 comment 'Optionnal. this is the base environments, if any. this is an URI  If set, this is automatically provided to any job  If set, this is installed **after** defaultdirin or works.dirin  To ensure those last do not override any file contained in basedirin',
  defaultDirinURI     varchar(254)                                 comment 'Optionnal. this is the default environment, if any. this is an URI  If set, this is automatically provided to any job, except if job defines its own DIRIN  Works.dirin may be set to NULLUID to force no DIRIN even if this apps.dirin is defined  This is ins',  --  Optionnal. this is the default environment, if any. this is an URI  If set, this is automatically provided to any job, except if job defines its own DIRIN  Works.dirin may be set to NULLUID to force no DIRIN even if this apps.dirin is defined  This is installed before basedirin to ensure this does not override  Any of the apps.basedirin files',
  launchscriptshuri   varchar(254)                                 comment 'Optionnal, launch shell scripts  Since 8.0.0',
  launchscriptcmduri  varchar(254)                                 comment 'Optionnal, launch MS command scripts  Since 8.0.0',
  unloadscriptshuri   varchar(254)                                 comment 'Optionnal, unload shell scripts  Since 8.0.0',
  unloadscriptcmduri  varchar(254)                                 comment 'Optionnal, unload MS command scripts  Since 8.0.0',
  errorMsg            varchar(254)                                 comment 'Error message',
  linux_ix86URI       varchar(254)                                 comment 'Optionnal. this is the linux    ix86  binary, if any. this is an URI',
  linux_amd64URI      varchar(254)                                 comment 'Optionnal. this is the linux    amd64 binary, if any. this is an URI',
  linux_x86_64URI     varchar(254)                                 comment 'Optionnal. this is the linux    x86 64 binary, if any. this is an URI',
  linux_ia64URI       varchar(254)                                 comment 'Optionnal. this is the linux    intel itanium binary, if any. this is an URI',
  linux_ppcURI        varchar(254)                                 comment 'Optionnal. this is the linux    ppc   binary, if any. this is an URI',
  macos_ix86URI       varchar(254)                                 comment 'Optionnal. this is the mac os 10 ix86  binary, if any. this is an URI',
  macos_x86_64URI     varchar(254)                                 comment 'Optionnal. this is the mac os 10 x86_64  binary, if any. this is an URI',
  macos_ppcURI        varchar(254)                                 comment 'Optionnal. this is the mac os 10 ppc   binary, if any. this is an URI',
  win32_ix86URI       varchar(254)                                 comment 'Optionnal. this is the win32    ix86  binary, if any. this is an URI',
  win32_amd64URI      varchar(254)                                 comment 'Optionnal. this is the win32    amd64 binary, if any. this is an URI',
  win32_x86_64URI     varchar(254)                                 comment 'Optionnal. this is the win32   x86_64 binary, if any. this is an URI',
  javaURI             varchar(254)                                 comment 'Optionnal. this is the java           binary, if any. this is an URI',
  osf1_alphaURI       varchar(254)                                 comment 'Optionnal. this is the osf1     alpha binary, if any. this is an URI',
  osf1_sparcURI       varchar(254)                                 comment 'Optionnal. this is the osf1     sparc binary, if any. this is an URI',
  solaris_alphaURI    varchar(254)                                 comment 'Optionnal. this is the solaris  alpha binary, if any. this is an URI',
  solaris_sparcURI    varchar(254)                                 comment 'Optionnal. this is the solaris  sparc binary, if any. this is an URI',
  ldlinux_ix86URI     varchar(254)                                 comment 'Optionnal. this is the linux    ix86  library, if any. this is an URI',
  ldlinux_amd64URI    varchar(254)                                 comment 'Optionnal. this is the linux    amd64 library, if any. this is an URI',
  ldlinux_x86_64URI   varchar(254)                                 comment 'Optionnal. this is the linux    x86 64 library, if any. this is an URI',
  ldlinux_ia64URI     varchar(254)                                 comment 'Optionnal. this is the linux    intel itanium library, if any. this is an URI',
  ldlinux_ppcURI      varchar(254)                                 comment 'Optionnal. this is the linux    ppc   library, if any. this is an URI',
  ldmacos_ix86URI     varchar(254)                                 comment 'Optionnal. this is the mac os x ix86  library, if any. this is an URI',
  ldmacos_x86_64URI   varchar(254)                                 comment 'Optionnal. this is the mac os x ix86  library, if any. this is an URI',
  ldmacos_ppcURI      varchar(254)                                 comment 'Optionnal. this is the mac os x ppc   library, if any. this is an URI',
  ldwin32_ix86URI     varchar(254)                                 comment 'Optionnal. this is the win32    ix86  library, if any. this is an URI',
  ldwin32_amd64URI    varchar(254)                                 comment 'Optionnal. this is the win32    amd64 library, if any. this is an URI',
  ldwin32_x86_64URI   varchar(254)                                 comment 'Optionnal. this is the win32   x86_64 library, if any. this is an URI',
  ldosf1_alphaURI     varchar(254)                                 comment 'Optionnal. this is the osf1     alpha library, if any. this is an URI',
  ldosf1_sparcURI     varchar(254)                                 comment 'Optionnal. this is the osf1     sparc library, if any. this is an URI',
  ldsolaris_alphaURI  varchar(254)                                 comment 'Optionnal. this is the solaris  alpha library, if any. this is an URI',
  ldsolaris_sparcURI  varchar(254)                                 comment 'Optionnal. this is the solaris  sparc library, if any. this is an URI',
  
  index  appTypeId     (appTypeId),
  index  packageTypeId (packageTypeId),
  index  ownerUID      (ownerUID)
  )
engine  = InnoDB,
comment = 'applications, submitted by users inside works';

show warnings;

create table if not exists  apps_history  like  apps;

show warnings;


-- ---------------------------------------------------------------------------
-- Table "executables" (Binary files) : 
-- Pure n-n relationship between data, application, OS and cpuType
-- ---------------------------------------------------------------------------
create table if not exists  executables  (
  executableId  int unsigned      not null  auto_increment  primary key,
  appUID        char(36)          not null,
  dataTypeId    tinyint unsigned  not null,
  osId          tinyint unsigned  not null,
  osVersion     varchar(36)           null  comment 'May be NULL',
  cpuTypeId     tinyint unsigned      null  comment 'May be NULL for Java byte code',
  dataUID       char(36)              null  comment 'May be NULL if data is external',
  dataURI       varchar(254)      not null,
  mtime         timestamp,
  
  index         appUID      (appUID),
  index         dataTypeId  (dataTypeId),
  index         osId        (osId),
  index         cpuTypeId   (cpuTypeId),
  index         dataUID     (dataUID),
  unique index  unique_executables (appUID, dataTypeId, osId, osVersion, cpuTypeId)
  )
engine  = InnoDB,
comment = 'executables = Applications files';

show warnings;

create table if not exists  executables_history  like  executables;

show warnings;


-- ---------------------------------------------------------------------------
-- Table "sessions" :
-- Sessions for transient grouping of works
-- Sessions are automatically erased (and all its jobs) when the client disconnect
-- ---------------------------------------------------------------------------
create table if not exists  sessions  (
  uid           char(36)      not null  primary key      comment 'Primary key',
  ownerUID      char(36)      not null                   comment 'Owner (user) UID',
  name          varchar(254)  not null                   comment 'Session name',
  mtime         timestamp                                comment 'Timestamp of last update',
  accessRights  int(4)                  default 0x700    comment 'Since 5.8.0  This defines access rights "a la" linux FS  See xtremweb.common.XWAccessRights.java',
  isdeleted     char(5)                 default 'false'  comment 'True if this row has been deleted',
  errorMsg      varchar(254)                             comment 'Error message',
  
  index  ownerUID (ownerUID)
  )
engine  = InnoDB,
comment = 'work-sessions = Sessions for transient grouping of works';

show warnings;
 
create table if not exists  sessions_history  like  sessions;

show warnings;


-- ---------------------------------------------------------------------------
-- Table "groups" :
-- Persistent groups of works
-- Groups are NOT erased when the client disconnect : they are kept between client sessions
-- ---------------------------------------------------------------------------
create table if not exists  groups  (
  uid           char(36)      not null  primary key      comment 'Primary key',
  sessionUID    char(36)                                 comment 'Session UID',
  ownerUID      char(36)      not null                   comment 'Owner (user) UID',
  name          varchar(254)  not null                   comment 'Group name',
  mtime         timestamp                                comment 'Timestamp of last update',
  accessRights  int(4)                  default 0x700    comment 'Since 5.8.0  This defines access rights "a la" linux FS  See xtremweb.common.XWAccessRights.java',
  isdeleted     char(5)                 default 'false'  comment 'True if this row has been deleted',
  errorMsg      varchar(254)                             comment 'Error message',
  
  index  sessionUID (sessionUID),
  index  ownerUID   (ownerUID)
  )
engine  = InnoDB,
comment = 'work-groups = Persistent groups of works';

show warnings;
 
create table if not exists  groups_history  like  groups;

show warnings;


-- ---------------------------------------------------------------------------
-- Table "works" :
-- Jobs submitted by a user with app and input data
-- ---------------------------------------------------------------------------
create table if not exists  works  (
  uid                 char(36)          not null  primary key      comment 'Primary key',
  appUID              char(36)          not null                   comment 'Application UID',
  statusId            tinyint unsigned  not null  default 255      comment 'Status Id. See common/XWStatus.java',
  status              varchar(36)       not null  default 'NONE'   comment 'Status. see common/XWStatus.java',
  sessionUID          char(36)                                     comment 'Optionnal. session UID',
  groupUID            char(36)                                     comment 'Optionnal. group UID (we call it "groupUID" since "group" is a MySql reserved word)  This is not an usergroup but a group !',
  expectedhostUID     char(36)                                     comment 'Optionnal. expected host UID',
  ownerUID            char(36)          not null                   comment 'User UID',
  label               varchar(254)                                 comment 'Optionnal. user label',
  mtime               timestamp                                    comment 'Timestamp of last update',
  userproxy           varchar(254)                                 comment 'This is the X.509 user proxy URI to identify the owner of this work. this is not a certificate',
  accessRights        int(4)                      default 0x700    comment 'This defines access rights "a la" linux FS  See xtremweb.common.XWAccessRights.java',
  sgid                varchar(254)                                 comment 'XWHEP 7.2.0 : this is the Service Grid Identifier; this is set by the DG 2 SG bridge, if any',
  wallclocktime       int(10)                                      comment 'Wallclocktime : how many seconds a job can be computed  The job is stopped as the wall clocktime is reached  If wallclocktime < 0, the job is not stopped  Since 8.2.0',
  maxRetry            int(3)                                       comment 'How many time should we try to compute',
  retry               int(3)                                       comment 'How many time have we tried to compute  Since 8.0.0',
  diskSpace           bigint                      default 0        comment 'Optionnal. disk space needed  This is in Mb',
  minMemory           int(10)                     default 0        comment 'Optionnal. minimum memory needed in Kb',
  minCPUSpeed         int(10)                     default 0        comment 'Optionnal. minimum CPU speed needed in MHz',
  minFreeMassStorage  bigint                      default 0        comment 'Min free amount of mass storage in Mb',
  maxWallClockTime    int(10)                                      comment 'Wallclocktime : how many seconds a job can be computed.  The job is stopped as the wall clocktime is reached.  If < 0, the job is not stopped.',
  returnCode          int(3)                                       comment 'Application return code',
  server              varchar(254)                                 comment 'For replication',
  cmdLine             text                                         comment 'This work command line to provide to application',
  listenport          varchar(254)                                 comment 'The job may be a server that needs to listen to some ports  This is a comma separated integer list  Privileged ports (lower than 1024) are ignored  Default : null (no port)  Since 8.0.0',
  smartsocketaddr     varchar(8190)                                comment 'The SmartSockets addresses to connect to the listened ports  This is set if listenport != null  This is a comma separated SmartSockets addresses list  Default : null  Since 8.0.0',
  smartsocketclient   varchar(8190)                                comment 'This is the column index of a semicolon list containing tuple of   SmartSockets address and local port.  This helps a job running on XWHEP worker side to connect to a server  Like application running on XWHEP client side.  E.g. "Saddr1, port1; Saddr2, por',  --  This is the column index of a semicolon list containing tuple of   SmartSockets address and local port.  This helps a job running on XWHEP worker side to connect to a server  Like application running on XWHEP client side.  E.g. "Saddr1, port1; Saddr2, port2"   Default : null  Since 8.0.0',
  stdinURI            varchar(254)                                 comment 'Data URI. This is the STDIN. If not set, apps.stdin is used by default  NULLUID may be used to force no STDIN even if apps.stdin is defined  See common/UID.java#NULLUID',
  dirinURI            varchar(254)                                 comment 'Data URI. This is the DIRIN. If not set, apps.dirin is used by default  NULLURI may be used to force no DIRIN even if apps.dirin is defined  See common/UID.java#NULLUID  This is installed before apps.basedirin to ensure this does not override  Any of the ',  --  Data URI. this is the DIRIN. If not set, apps.dirin is used by default  NULLURI may be used to force no DIRIN even if apps.dirin is defined  See common/UID.java#NULLUID  This is installed before apps.basedirin to ensure this does not override  Any of the apps.basedirin files',
  resultURI           varchar(254)                                 comment 'Data URI',
  arrivalDate         datetime                                     comment 'When the server received this work',
  completedDate       datetime                                     comment 'When this work has been completed',
  resultDate          datetime                                     comment 'When this work result has been available',
  readydate           datetime                                     comment 'When this work has been downloaded by the worker  Since 8.0.0',
  datareadydate       datetime                                     comment 'When this work data have been downloaded by the worker  Since 8.0.0',
  compstartdate       datetime                                     comment 'When this work has been started on worker  Since 8.0.0',
  compenddate         datetime                                     comment 'When this work work has been ended on worker  Since 8.0.0',
  error_msg           varchar(255)                                 comment 'Error message',
  sendToClient        char(5)                     default 'false'  comment 'Used for replication',
  local               char(5)                     default 'true'   comment 'Used for replication',
  active              char(5)                     default 'true'   comment 'Used for replication',
  replicatedUID       char(36)                                     comment 'The UID of the original work, if this work is a replica',
  replications        int(3)                      default 0        comment 'Optionnal. Amount of expected replications. No replication, if <= 0',
  sizer               int(3)                      default 0        comment 'Optionnal. This is the size of the replica set',
  totalr              int(3)                      default 0        comment 'Optionnal. Current amount of replicas',
  datadrivenURI       varchar(254)                                 comment 'Optionnal. The URI of the data the work drives',
  isService           char(5)                     default 'false'  comment 'Is it a service (see apps.isService)',
  isdeleted           char(5)                     default 'false'  comment 'True if row has been deleted ',
  envvars             varchar(254)                                 comment 'Opional,  Since 8.0.0',
  errorMsg            varchar(254)                                 comment 'Error message',
  
  index  works_status_active (status, active),
  index  appUID              (appUID),
  index  statusId            (statusId),
  index  sessionUID          (sessionUID),
  index  groupUID            (groupUID),
  index  expectedhostUID     (expectedhostUID),
  index  ownerUID            (ownerUID),
  index  completedDate       (completedDate)
  )
engine  = InnoDB,
comment = 'works = Jobs submitted by a user with app and input data';

show warnings;

create table if not exists  works_history  like  works;

show warnings;


-- ---------------------------------------------------------------------------
-- Table "tasks" :
-- Work sent to a host with the adequate app binary.
-- 
-- a task is a work associated to a worker
-- tasks can not be submitted by users : they must submit jobs
-- tasks are automatically created by server
-- each work has a set of associated tasks, at least one
-- a new task is created each time a task is lost
-- ---------------------------------------------------------------------------
create table if not exists  tasks  (
  uid            char(36)          not null  primary key      comment 'Primary key',
  workUID        char(36)          not null                   comment 'This is the referenced work',
  hostUID        char(36)                                     comment 'Host UID',
  statusId       tinyint unsigned  not null  default 255      comment 'Status Id. See common/XWStatus.java',
  status         varchar(36)                                  comment 'Status. see common/XWStatus.java',
  ownerUID       char(36)                                     comment 'Since 5.8.0',
  mtime          timestamp                                    comment 'Timestamp of last update',
  accessRights   int(4)                      default 0x700    comment 'Since 5.8.0  This defines access rights "a la" linux FS  See xtremweb.common.XWAccessRights.java',
  trial          int(11)                                      comment 'Instanciation counter',
  InsertionDate  datetime                                     comment 'When the server put this task into queue',
  StartDate      datetime                                     comment 'First instanciation date',
  LastStartDate  datetime                                     comment 'Last instanciation date',
  AliveCount     int(11)                                      comment 'Is it necessary ?',
  LastAlive      datetime                                     comment 'Is it necessary ?',
  removalDate    datetime                                     comment 'When this task has been removed',
  duration       bigint                      default 0        comment 'Last instanciation duration',
  isdeleted      char(5)                     default 'false'  comment 'True if row has been deleted ',
  errorMsg       varchar(254)                                 comment 'Error message',
  
  index  workUID  (workUID),
  index  hostUID  (hostUID),
  index  statusId (statusId),
  index  ownerUID (ownerUID)
  )
engine  = InnoDB,
comment = 'tasks = Work sent to a host with the adequate app binary';

show warnings;
 
create table if not exists  tasks_history  like  tasks;

show warnings;


-- ===========================================================================
-- 
-- Insertion of first users  -  Grant access to the database
-- 
-- ===========================================================================

-- insert into usergroups (uid,label,project) values("83e744e7-e9e2-4444-a967-c101e39a8ff2","admin", "false");

-- insert into usergroups (uid,label,project) values("eb97443b-31da-4daf-aa78-c12186e005a4","publicworkers", "false");

-- ---------------------------------------------------------------------------
-- Insert a priviliged user to be able to manage your platform
-- accessrights = 1792 = 0x700
-- ---------------------------------------------------------------------------
insert into users (uid,login,password,fname,lname,email,rights,owneruid,accessrights,userRightId)
       values ("453189a4-93cb-4344-bc4f-8edea3566def","admin","adminp", "@DBADMINFNAME@", "@DBADMINLNAME@",
               "@DBADMINEMAIL@","SUPER_USER","453189a4-93cb-4344-bc4f-8edea3566def","1792",
               (select userRightId from userRights where userRightName = 'SUPER_USER'));

insert into users (uid,login,password,fname,lname,email,rights,owneruid,accessrights,userRightId)
       values ("bc325362-4ff9-4e55-9fa7-603ae33eb528","worker","workerp", "@DBADMINFNAME@", "@DBADMINLNAME@",
               "@DBADMINEMAIL@","WORKER_USER","453189a4-93cb-4344-bc4f-8edea3566def","1792",
               (select userRightId from userRights where userRightName = 'WORKER_USER'));

-- Ff your dispatcher complains about handshake, try this :
-- set password for xtremweb@localhost = old_password('xwpassword');


-- ---------------------------------------------------------------------------
-- Finally, allow access to your database
-- There may be error messages if you don't have enough privileges
-- If so, contact you DB amdinistrator
-- ---------------------------------------------------------------------------
grant all privileges on * to xwuser@localhost             identified by 'xwuserp' with grant option;

grant all privileges on * to xwuser@localhost.localdomain identified by 'xwuserp' with grant option;

grant all privileges on * to xwuser@'$SEDVAR'            identified by 'xwuserp' with grant option;

-- set password for xwuser@localhost = old_password ('xwuserp');


-- ===========================================================================
-- End Of File
-- ===========================================================================
