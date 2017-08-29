*** Settings ***
Library  DatabaseLibrary

*** Variables ***
# need
# pip install robotframework-databaselibrary
# pip install pymysql

${XWCONFIGURE.VALUES.DBNAME} =  xtremweb
${XWCONFIGURE.VALUES.DBUSERLOGIN} =  xwuser
${XWCONFIGURE.VALUES.DBUSERPASSWORD} =  xwuser
${XWCONFIGURE.VALUES.DBHOST} =  localhost
${DB_PORT} =  3306

*** Keywords ***
Connect
    Connect To Database Using Custom Params  pymysql  database='${XWCONFIGURE.VALUES.DBNAME}', user='${XWCONFIGURE.VALUES.DBUSERLOGIN}', password='${XWCONFIGURE.VALUES.DBUSERPASSWORD}', host='${XWCONFIGURE.VALUES.DBHOST}', port=${DB_PORT}

Disconnect
    Disconnect from Database


Count From Table Where Uid
    [Arguments]  ${table}  ${uid}  ${countExpected}
    Connect
    Row Count Is Equal To X  SELECT * FROM ${table} WHERE uid = '${uid}'  ${countExpected}
    Disconnect


Delete Fonctionnal Xtremweb Tables
    Connect
    Delete All Rows From Table  apps
    Delete All Rows From Table  apps_history
    Delete All Rows From Table  datas
    Delete All Rows From Table  datas_history
    Delete All Rows From Table  executables
    Delete All Rows From Table  executables_history
    Delete All Rows From Table  groups
    Delete All Rows From Table  groups_history
    Delete All Rows From Table  hosts
    Delete All Rows From Table  hosts_history
    Delete All Rows From Table  memberships
    Delete All Rows From Table  memberships_history
    Delete All Rows From Table  sessions
    Delete All Rows From Table  sessions_history
    Delete All Rows From Table  sharedAppTypes
    Delete All Rows From Table  sharedAppTypes_history
    Delete All Rows From Table  sharedPackageTypes
    Delete All Rows From Table  sharedPackageTypes_history
    Delete All Rows From Table  tasks
    Delete All Rows From Table  tasks_history
    Delete All Rows From Table  traces
    Delete All Rows From Table  traces_history
    Delete All Rows From Table  usergroups
    Delete All Rows From Table  usergroups_history
    Delete All Rows From Table  users_history
    Delete All Rows From Table  works
    Delete All Rows From Table  works_history
    Disconnect

Delete All Xtremweb Tables
    Delete Fonctionnal Xtremweb Tables
    Connect
    Delete All Rows From Table  appTypes
    Delete All Rows From Table  cpuTypes
    Delete All Rows From Table  dataTypes
    Delete All Rows From Table  oses
    Delete All Rows From Table  packageTypes
    Delete All Rows From Table  statuses
    Delete All Rows From Table  userRights
    Delete All Rows From Table  users
    Delete All Rows From Table  version
    Delete All Rows From Table  versions
    Disconnect

Xtremweb Tables Must Exist
    Connect
    Table Must Exist  appTypes
    Table Must Exist  apps
    Table Must Exist  apps_history
    Table Must Exist  cpuTypes
    Table Must Exist  dataTypes
    Table Must Exist  datas
    Table Must Exist  datas_history
    Table Must Exist  executables
    Table Must Exist  executables_history
    Table Must Exist  groups
    Table Must Exist  groups_history
    Table Must Exist  hosts
    Table Must Exist  hosts_history
    Table Must Exist  memberships
    Table Must Exist  memberships_history
    Table Must Exist  oses
    Table Must Exist  packageTypes
    Table Must Exist  sessions
    Table Must Exist  sessions_history
    Table Must Exist  sharedAppTypes
    Table Must Exist  sharedAppTypes_history
    Table Must Exist  sharedPackageTypes
    Table Must Exist  sharedPackageTypes_history
    Table Must Exist  statuses
    Table Must Exist  tasks
    Table Must Exist  tasks_history
    Table Must Exist  traces
    Table Must Exist  traces_history
    Table Must Exist  userRights
    Table Must Exist  usergroups
    Table Must Exist  usergroups_history
    Table Must Exist  users
    Table Must Exist  users_history
    Table Must Exist  version
    Table Must Exist  versions
    Table Must Exist  view_apps
    Table Must Exist  view_apps_for_offering
    Table Must Exist  view_apps_for_offering_with_file_sizes
    Table Must Exist  view_datas
    Table Must Exist  view_executables
    Table Must Exist  view_groups
    Table Must Exist  view_hosts
    Table Must Exist  view_hosts_matching_works_deployable
    Table Must Exist  view_hosts_matching_works_deployable_and_shared
    Table Must Exist  view_hosts_matching_works_shared
    Table Must Exist  view_sessions
    #Table Must Exist  view_sharedapptypes
    #Table Must Exist  view_sharedpackagetypes
    Table Must Exist  view_tasks
    Table Must Exist  view_traces
    Table Must Exist  view_usergroups
    Table Must Exist  view_users
    Table Must Exist  view_users_apps
    Table Must Exist  view_users_datas
    Table Must Exist  view_users_groups
    Table Must Exist  view_users_hosts
    Table Must Exist  view_users_sessions
    Table Must Exist  view_users_tasks
    Table Must Exist  view_users_traces
    Table Must Exist  view_users_usergroups
    Table Must Exist  view_users_users
    Table Must Exist  view_users_works
    Table Must Exist  view_works
    Table Must Exist  view_works_for_billing
    Table Must Exist  view_works_for_billing_with_file_sizes
    Table Must Exist  works
    Table Must Exist  works_history
    Disconnect
