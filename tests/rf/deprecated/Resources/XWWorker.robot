*** Settings ***
Resource  ./DockerHelper.robot
Resource  ./XWCommon.robot

*** Variables ***

${XWCONFIGURE.VALUES.HTTPSPORT} =  9443
${WORKER_PROCESS}


*** Keywords ***
Start XtremWeb Worker
    [Arguments]  ${DIST_XWHEP_PATH}
    File Should Exist  ${DIST_XWHEP_PATH}/conf/xtremweb.worker.conf
    ${config_content} =  Get File  ${DIST_XWHEP_PATH}/conf/xtremweb.worker.conf
    ${config_content_filtered} =  Remove String Using Regexp  ${config_content}  LAUNCHERURL=${XWCONFIGURE.VALUES.XWUPGRADEURL}

    ${config_content_filtered} =  Replace String  ${config_content_filtered}  LOGIN=worker  LOGIN=vworker
    ${config_content_filtered} =  Replace String  ${config_content_filtered}  PASSWORD=worker  PASSWORD=vworkerp


    ${config_content_filtered} =  Replace String  ${config_content_filtered}  LOGGERLEVEL=INFO  LOGGERLEVEL=FINEST
    Create File  ${DIST_XWHEP_PATH}/conf/xtremweb.worker.conf  content=${config_content_filtered}

    Remove File  ${DIST_XWHEP_PATH}/xwhep.worker.process.log
    ${created_process} =  Start Process  ${DIST_XWHEP_PATH}/bin/xtremweb.worker console  shell=yes  stderr=STDOUT  stdout=${DIST_XWHEP_PATH}/xwhep.worker.process.log
    Set Suite Variable  ${WORKER_PROCESS}  ${created_process}
    #Wait Until Keyword Succeeds  2 min	5 sec  Check XtremWeb Worker Start From Log  ${DIST_XWHEP_PATH}/xwhep.worker.process.log
    #  TODO check woker start
    Log File  ${DIST_XWHEP_PATH}/xwhep.worker.process.log

Start XtremWeb Worker In Docker
    [Arguments]  ${DIST_XWHEP_PATH}
    Log  ${DIST_XWHEP_PATH}/conf/xtremweb.worker.conf
    File Should Exist  ${DIST_XWHEP_PATH}/conf/xtremweb.worker.conf
    ${config_content} =  Get File  ${DIST_XWHEP_PATH}/conf/xtremweb.worker.conf
    ${config_content_filtered} =  Remove String Using Regexp  ${config_content}  LAUNCHERURL=${XWCONFIGURE.VALUES.XWUPGRADEURL}

    ${config_content_filtered} =  Replace String  ${config_content_filtered}  LOGIN=worker  LOGIN=vworker
    ${config_content_filtered} =  Replace String  ${config_content_filtered}  PASSWORD=worker  PASSWORD=vworkerp


    ${config_content_filtered} =  Replace String  ${config_content_filtered}  LOGGERLEVEL=INFO  LOGGERLEVEL=FINEST
    Create File  ${DIST_XWHEP_PATH}/conf/xtremweb.worker.conf  content=${config_content_filtered}

    Remove File  ${DIST_XWHEP_PATH}/xwhep.worker.process.log
    ${xtremweb_version} =  XWCommon.Get Xtremweb Version  ${DIST_XWHEP_PATH}
    ${created_process} =  Start Process  docker run --env XWSERVERADDR\="172.18.0.1" --env XWSERVERNAME\="james-xps" -v ${DIST_XWHEP_PATH}/keystore/xwhepcert.pem:/xwhep/certificate/xwhepcert.pem xtremweb/worker:${xtremweb_version}  shell=yes  stderr=STDOUT  stdout=${DIST_XWHEP_PATH}/xwhep.worker.process.log

    ${container_id} =  Wait Until Keyword Succeeds  3 min   10 sec  DockerHelper.Get Docker Container Id From Image  xtremweb/worker:${xtremweb_version}
    Log  ${container_id}

    ${container_log} =  DockerHelper.Logs By Container Id  ${container_id}    

    Set Suite Variable  ${WORKER_PROCESS}  ${container_id}
    #Wait Until Keyword Succeeds  2 min 5 sec  Check XtremWeb Worker Start From Log  ${container_log}
    #  TODO check woker start
    Log File  ${DIST_XWHEP_PATH}/xwhep.worker.process.log

Check XtremWeb Worker Start From Log
    [Arguments]  ${log}
    ${ret} =  Grep File  ${log}  INFO : Server gave no work to compute
    ${line_count} =  Get Line Count  ${ret}
    Should Be Equal As Integers	${line_count}	1

Stop XtremWeb Worker
    Log  Stop XtremWeb Worker
    Terminate Process  ${WORKER_PROCESS}

Stop XtremWeb Worker In Docker
    Log  Stop XtremWeb Worker
    DockerHelper.Stop And Remove All Containers


Log XtremWeb Worker Log File
     Log File  ${DIST_XWHEP_PATH}/xwhep.worker.process.log
