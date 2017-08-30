*** Settings ***

*** Variables ***

${XWCONFIGURE.VALUES.HTTPSPORT} =  9443
${WORKER_PROCESS}


*** Keywords ***
Start XtremWeb Worker
    [Arguments]  ${DIST_XWHEP_PATH}
    File Should Exist  ${DIST_XWHEP_PATH}/conf/xtremweb.worker.conf
    ${config_content} =  Get File  ${DIST_XWHEP_PATH}/conf/xtremweb.worker.conf
    ${config_content_filtered} =  Remove String Using Regexp  ${config_content}  LAUNCHERURL=${XWCONFIGURE.VALUES.XWUPGRADEURL}
    # change default 443 to 9443 to not use sudo
    #${config_content_filtered} =  Replace String  ${config_content_filtered}  HTTPSPORT=443  HTTPSPORT=${XWCONFIGURE.VALUES.HTTPSPORT}

    Create File  ${DIST_XWHEP_PATH}/conf/xtremweb.worker.conf  content=${config_content_filtered}

    Remove File  ${DIST_XWHEP_PATH}/xwhep.worker.process.log
    ${created_process} =  Start Process  ${DIST_XWHEP_PATH}/bin/xtremweb.worker console  shell=yes  stderr=STDOUT  stdout=${DIST_XWHEP_PATH}/xwhep.worker.process.log
    Set Suite Variable  ${WORKER_PROCESS}  ${created_process}
    #Wait Until Keyword Succeeds  2 min	5 sec  Check XtremWeb Worker Start From Log  ${DIST_XWHEP_PATH}/xwhep.worker.process.log
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