*** Settings ***

*** Variables ***

*** Keywords ***

XWSENDAPPCommand
    [Documentation]  Usage :  SENDAPP appName appType cpuType osName URI | UID : inserts/updates an application; URI or UID points to binary file ; application name must be the first parameter
    [Arguments]  ${options}=${EMPTY}
    ${cmd_result} =  Run Process  cd ${DIST_XWHEP_PATH}/bin && ./xwsendapp ${options}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers	${cmd_result.rc}	0
    ${uid} =  Get Substring  ${cmd_result.stdout}  -36
    [Return]  ${uid}

XWSENDDATACommand
    [Documentation]  Usage :  SENDDATA dataName [cpuType] [osName] [dataType] [accessRigths] [dataFile | dataURI | dataUID] : sends data and uploads data if dataFile provided
    [Arguments]  ${options}=${EMPTY}
    ${cmd_result} =  Run Process  cd ${DIST_XWHEP_PATH}/bin && ./xwsenddata ${options}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers	${cmd_result.rc}	0
    ${uid} =  Get Substring  ${cmd_result.stdout}  -36
    [Return]  ${uid}

XWSUBMITCommand
    [Documentation]  Usage :  XWSUBMIT appName
    [Arguments]  ${appName}
    ${cmd_result} =  Run Process  cd ${DIST_XWHEP_PATH}/bin && ./xwsubmit ${appName}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers	${cmd_result.rc}	0
    ${uid} =  Get Substring  ${cmd_result.stdout}  -36
    [Return]  ${uid}

XWSTATUSCommand
    [Documentation]  Usage :  XWSTATUS uid
    [Arguments]  ${uid}
    ${cmd_result} =  Run Process  cd ${DIST_XWHEP_PATH}/bin && ./xwstatus ${uid}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers	${cmd_result.rc}	0
    #UID='a3d8e3d1-4d6a-409b-88b7-2cef2378ccef', STATUS='PENDING', COMPLETEDDATE=NULL, LABEL=NULL
    @{status_result} =  Get Regexp Matches  ${cmd_result.stdout}  STATUS='(?P<status>.*)', COMPLETEDDATE  status
    [Return]  @{status_result}[0]

Check XWSTATUS Completed
    [Arguments]  ${uid}
    ${status_result} =  XWSTATUSCommand  ${uid}
    Should Be Equal As Strings  ${status_result}  COMPLETED

Check XWSTATUS Running
    [Arguments]  ${uid}
    ${status_result} =  XWSTATUSCommand  ${uid}
    Should Be Equal As Strings  ${status_result}  RUNNING

Check XWSTATUS Pending
    [Arguments]  ${uid}
    ${status_result} =  XWSTATUSCommand  ${uid}
    Should Be Equal As Strings  ${status_result}  PENDING

XWRESULTSCommand
    [Documentation]  Usage :  XWRESULT uid
    [Arguments]  ${uid}
    ${cmd_result} =  Run Process  cd ${DIST_XWHEP_PATH}/bin && ./xwresults ${uid}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers	${cmd_result.rc}	0
    @{results_file} =  Get Regexp Matches  ${cmd_result.stdout}  INFO : Downloaded to : (?P<file>.*)  file
    [Return]  @{results_file}[0]

XWWORKSCommand
    [Documentation]  Usage :  XWWORKS uid
    ${cmd_result} =  Run Process  cd ${DIST_XWHEP_PATH}/bin && ./xwworks  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers	${cmd_result.rc}	0
    [Return]  ${cmd_result.stdout}

XWAPPSCommand
    [Documentation]  Usage :  XWAPPSCommand uid
    [Arguments]  ${options}=${EMPTY}
    ${cmd_result} =  Run Process  cd ${DIST_XWHEP_PATH}/bin && ./xwapps ${options}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers	${cmd_result.rc}	0
    [Return]  ${cmd_result.stdout}


XWDATASCommand
    [Documentation]  Usage :  XWAPPSCommand uid
    ${cmd_result} =  Run Process  cd ${DIST_XWHEP_PATH}/bin && ./xwdatas  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers	${cmd_result.rc}	0
    [Return]  ${cmd_result.stdout}

XWSENDUSERCommand
    [Documentation]  Usage :  XWSENDUSERCommand SENDUSER login password email rights [<a user group UID | URI> ] : sends/updates a useruid
    [Arguments]  ${options}=${EMPTY}
    ${cmd_result} =  Run Process  cd ${DIST_XWHEP_PATH}/bin && ./xwsenduser ${options}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers	${cmd_result.rc}	0
    [Return]  ${cmd_result.stdout}

XWUSERSCommand
    [Documentation]  Usage :  XWUSERS
    ${cmd_result} =  Run Process  cd ${DIST_XWHEP_PATH}/bin && ./xwusers  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers	${cmd_result.rc}	0
    [Return]  ${cmd_result.stdout}

XWCMODCommand
    [Documentation]  Usage :  XWCMOD
    [Arguments]  ${rights}  ${uid}
    ${cmd_result} =  Run Process  cd ${DIST_XWHEP_PATH}/bin && ./xwchmod ${rights} ${uid}   shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers	${cmd_result.rc}	0
    [Return]  ${cmd_result.stdout}


