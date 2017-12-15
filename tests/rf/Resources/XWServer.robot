*** Settings ***
Resource  ./DB/MySql.robot

*** Variables ***

*** Variables ***

${XWCONFIGURE.VALUES.HTTPSPORT} =  9443
${SERVER_PROCESS}


*** Keywords ***
Start XtremWeb Server
    [Arguments]  ${DIST_XWHEP_PATH}
    #remove LAUNCHERURL= in the config file
    File Should Exist  ${DIST_XWHEP_PATH}/conf/xtremweb.server.conf
    ${config_content} =  Get File  ${DIST_XWHEP_PATH}/conf/xtremweb.server.conf
    ${config_content_filtered} =  Remove String Using Regexp  ${config_content}  LAUNCHERURL=${XWCONFIGURE.VALUES.XWUPGRADEURL}
    # change default 443 to 9443 to not use sudo
    ${config_content_filtered} =  Replace String  ${config_content_filtered}  \## HTTPSPORT=443  HTTPSPORT=${XWCONFIGURE.VALUES.HTTPSPORT}
    ${config_content_filtered} =  Replace String  ${config_content_filtered}  LOGGERLEVEL=INFO  LOGGERLEVEL=FINEST
    Create File  ${DIST_XWHEP_PATH}/conf/xtremweb.server.conf  content=${config_content_filtered}

    Append To File  ${DIST_XWHEP_PATH}/conf/xtremweb.server.conf  DELEGATEDREGISTRATION=true\n

    Remove File  ${DIST_XWHEP_PATH}/xwhep.server.process.log
    ${created_process} =  Start Process  ${DIST_XWHEP_PATH}/bin/xtremweb.server console  shell=yes  stderr=STDOUT  stdout=${DIST_XWHEP_PATH}/xwhep.server.process.log
    Set Suite Variable  ${SERVER_PROCESS}  ${created_process}
    #test multiple time string : started, listening on port :  in log
    Wait Until Keyword Succeeds  2 min	5 sec  Check XtremWeb Server Start From Log  ${DIST_XWHEP_PATH}/xwhep.server.process.log
    Log XtremWeb Server Log File

Restart XtremWeb Server
    Stop XtremWeb Server
    Start XtremWeb Server  ${DIST_XWHEP_PATH}

Check XtremWeb Server Start From Log
    [Arguments]  ${log}
    Log XtremWeb Server Log File
    ${ret} =  Grep File  ${log}  listening on port : ${XWCONFIGURE.VALUES.HTTPSPORT}
    ${line_count} =  Get Line Count  ${ret}
    #listening on port : must be present twice for success
    Should Be Equal As Integers	${line_count}	2

Stop XtremWeb Server
    Terminate Process  ${SERVER_PROCESS}

Log XtremWeb Server Log File
     Log File  ${DIST_XWHEP_PATH}/xwhep.server.process.log


Ping XWtremWeb Database
    MySql.Xtremweb Tables Must Exist


Clear XWtremWeb Database
    MySql.Delete All Xtremweb Tables


Count From Datas Where Uid
    [Arguments]  ${uid}  ${countExpected}
    MySql.Count From Table Where Uid  datas  ${uid}  ${countExpected}

Count From Apps Where Uid
    [Arguments]  ${uid}  ${countExpected}
    MySql.Count From Table Where Uid  apps  ${uid}  ${countExpected}

Count From Works Where Uid
    [Arguments]  ${uid}  ${countExpected}
    MySql.Count From Table Where Uid  works  ${uid}  ${countExpected}

Count From Works
    [Arguments]  ${countExpected}
    MySql.Count From Table  works  ${countExpected}
