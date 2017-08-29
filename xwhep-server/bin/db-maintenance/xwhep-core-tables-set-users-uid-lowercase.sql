-- ===========================================================================
--
--  Copyright 2013  E. URBAH
--                  at LAL, Univ Paris-Sud, IN2P3/CNRS, Orsay, France
--  License GPL v3
--
--  XtremWeb-HEP Core Tables :
--  SQL script permitting to set 'users.uid' and '*.ownerUID' to lowercase
--
-- ===========================================================================
update users               set uid      = lower(uid)       where cast(uid      as binary) regexp '[A-Z]';
update usergroups          set ownerUID = lower(ownerUID)  where cast(ownerUID as binary) regexp '[A-Z]';
update hosts               set ownerUID = lower(ownerUID)  where cast(ownerUID as binary) regexp '[A-Z]';
update traces              set ownerUID = lower(ownerUID)  where cast(ownerUID as binary) regexp '[A-Z]';
update datas               set ownerUID = lower(ownerUID)  where cast(ownerUID as binary) regexp '[A-Z]';
update apps                set ownerUID = lower(ownerUID)  where cast(ownerUID as binary) regexp '[A-Z]';
update sessions            set ownerUID = lower(ownerUID)  where cast(ownerUID as binary) regexp '[A-Z]';
update groups              set ownerUID = lower(ownerUID)  where cast(ownerUID as binary) regexp '[A-Z]';
update works               set ownerUID = lower(ownerUID)  where cast(ownerUID as binary) regexp '[A-Z]';
update tasks               set ownerUID = lower(ownerUID)  where cast(ownerUID as binary) regexp '[A-Z]';

update users_history       set uid      = lower(uid)       where cast(uid      as binary) regexp '[A-Z]';
update usergroups_history  set ownerUID = lower(ownerUID)  where cast(ownerUID as binary) regexp '[A-Z]';
update hosts_history       set ownerUID = lower(ownerUID)  where cast(ownerUID as binary) regexp '[A-Z]';
update traces_history      set ownerUID = lower(ownerUID)  where cast(ownerUID as binary) regexp '[A-Z]';
update datas_history       set ownerUID = lower(ownerUID)  where cast(ownerUID as binary) regexp '[A-Z]';
update apps_history        set ownerUID = lower(ownerUID)  where cast(ownerUID as binary) regexp '[A-Z]';
update sessions_history    set ownerUID = lower(ownerUID)  where cast(ownerUID as binary) regexp '[A-Z]';
update groups_history      set ownerUID = lower(ownerUID)  where cast(ownerUID as binary) regexp '[A-Z]';
update works_history       set ownerUID = lower(ownerUID)  where cast(ownerUID as binary) regexp '[A-Z]';
update tasks_history       set ownerUID = lower(ownerUID)  where cast(ownerUID as binary) regexp '[A-Z]';
