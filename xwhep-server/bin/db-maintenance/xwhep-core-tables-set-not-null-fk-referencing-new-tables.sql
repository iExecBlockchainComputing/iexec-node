-- ===========================================================================
--
--  Copyright 2013  E. URBAH
--                  at LAL, Univ Paris-Sud, IN2P3/CNRS, Orsay, France
--  License GPL v3
--
--  XtremWeb-HEP Core Tables :
--  SQL script permitting to set NOT NULL the foreign keys referencing
--  the new tables
--
-- ===========================================================================

select 'Foreign key "users.userRightId"' as '';
alter table users  modify column userRightId tinyint unsigned not null default 255;
show warnings;

select 'Foreign key "datas.statusId"' as '';
alter table datas  modify column statusId    tinyint unsigned not null default 255;
show warnings;

select 'Foreign key "apps.appTypeId"' as '';
alter table apps   modify column appTypeId   tinyint unsigned not null default 255;
show warnings;

select 'Foreign key "works.statusId"' as '';
alter table works  modify column statusId    tinyint unsigned not null default 255;
show warnings;

select 'Foreign key "tasks.statusId"' as '';
alter table tasks  modify column statusId    tinyint unsigned not null default 255;
show warnings;
