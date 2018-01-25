*** Settings ***
Library  Process
Resource  ../DockerHelper.robot

*** Variables ***

${DOCKER_CLIENT_IMAGE_NAME}
${DIST_XWHEP_PATH}

*** Keywords ***

SetDockerClientImageName
    [Arguments]  ${client_image_name}
    Set Suite Variable  ${DOCKER_CLIENT_IMAGE_NAME}  ${client_image_name}
    Log  ${DOCKER_CLIENT_IMAGE_NAME}

SetDockerClientXtremwebPath
    [Arguments]  ${dist_xwhep_path}
    Set Suite Variable  ${DIST_XWHEP_PATH}  ${dist_xwhep_path}
    Log  ${DIST_XWHEP_PATH}


StartDockerClient
    ${created_process} =  Start Process  docker run -t --env XWSERVERADDR\="scheduler" --env XWSERVERNAME\="xwscheduler" -v ${DIST_XWHEP_PATH}/keystore/xwhepcert.pem:/xwhep/certificate/xwhepcert.pem --network\=docker_xtremweb-net ${DOCKER_CLIENT_IMAGE_NAME}  shell=yes  stderr=STDOUT  stdout=./xwhep.client.docker.process.log

    ${container_id} =  Wait Until Keyword Succeeds  5 sec   1 sec  DockerHelper.Get Docker Container Id From Image  ${DOCKER_CLIENT_IMAGE_NAME}
    Log  ${container_id}
    [Return]  ${container_id}

StopDockerClient
    ${container_id} =  Wait Until Keyword Succeeds  5 sec   1 sec  DockerHelper.Get Docker Container Id From Image  ${DOCKER_CLIENT_IMAGE_NAME}
    Log  ${container_id}
    DockerHelper.Remove Container  ${container_id}
    

XWSENDAPPCommand
    [Documentation]  Usage :  SENDAPP appName appType cpuType osName URI | UID : inserts/updates an application; URI or UID points to binary file ; application name must be the first parameter
    [Arguments]  ${options}=${EMPTY}    
    ${container_id} =  StartDockerClient
    ${cmd_result} =  Run Process  docker exec -t ${container_id} ./xwsendapp ${options}  shell=yes
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    ${uid} =  Get Substring  ${cmd_result.stdout}  -36
    StopDockerClient 
    [Return]  ${uid}

XWSENDDATACommand
    [Documentation]  Usage :  SENDDATA dataName [cpuType] [osName] [dataType] [accessRigths] [dataFile | dataURI | dataUID] : sends data and uploads data if dataFile provided
    [Arguments]  ${options}=${EMPTY}
    ${container_id} =  StartDockerClient
    ${cmd_result} =  Run Process  docker exec -t ${container_id} ./xwsenddata ${options}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    ${uid} =  Get Substring  ${cmd_result.stdout}  -36
    StopDockerClient 
    [Return]  ${uid}

XWSUBMITCommand
    [Documentation]  Usage :  XWSUBMIT appName
    [Arguments]  ${appName}
    ${container_id} =  StartDockerClient
    ${cmd_result} =  Run Process  docker exec -t ${container_id} ./xwsubmit ${appName}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    ${uid} =  Get Substring  ${cmd_result.stdout}  -36
    StopDockerClient 
    [Return]  ${uid}

XWSTATUSCommand
    [Documentation]  Usage :  XWSTATUS uid
    [Arguments]  ${uid}
    ${container_id} =  StartDockerClient
    ${cmd_result} =  Run Process  docker exec -t ${container_id} ./xwstatus ${uid}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    #UID='a3d8e3d1-4d6a-409b-88b7-2cef2378ccef', STATUS='PENDING', COMPLETEDDATE=NULL, LABEL=NULL
    @{status_result} =  Get Regexp Matches  ${cmd_result.stdout}  STATUS='(?P<status>.*)', COMPLETEDDATE  status
    StopDockerClient 
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
    ${container_id} =  StartDockerClient
    ${cmd_result} =  Run Process  docker exec -t ${container_id} ./xwresults ${uid}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    @{results_file} =  Get Regexp Matches  ${cmd_result.stdout}  INFO : Downloaded to : (?P<file>.*)  file

    ${cat_file_result} =  Run Process  docker exec -t ${container_id} cat @{results_file}[0]  shell=yes
    Log  ${cat_file_result.stderr}
    Log  ${cat_file_result.stdout}
    Should Be Equal As Integers  ${cat_file_result.rc}  0

    StopDockerClient 
    [Return]  ${cat_file_result.stdout}

XWWORKSCommand
    [Documentation]  Usage :  XWWORKS uid
    ${container_id} =  StartDockerClient
    ${cmd_result} =  Run Process  docker exec -t ${container_id} ./xwworks  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    StopDockerClient 
    [Return]  ${cmd_result.stdout}

XWAPPSCommand
    [Documentation]  Usage :  XWAPPSCommand uid
    [Arguments]  ${options}=${EMPTY}
    ${container_id} =  StartDockerClient
    ${cmd_result} =  Run Process  docker exec -t ${container_id} ./xwapps ${options}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    StopDockerClient 
    [Return]  ${cmd_result.stdout}


XWDATASCommand
    [Documentation]  Usage :  XWAPPSCommand uid
    ${container_id} =  StartDockerClient
    ${cmd_result} =  Run Process  docker exec -t ${container_id} ./xwdatas  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    StopDockerClient
    [Return]  ${cmd_result.stdout}

XWSENDUSERCommand
    [Documentation]  Usage :  XWSENDUSERCommand SENDUSER login password email rights [<a user group UID | URI> ] : sends/updates a useruid
    [Arguments]  ${options}=${EMPTY}
    ${container_id} =  StartDockerClient
    ${cmd_result} =  Run Process  docker exec -t ${container_id} ./xwsenduser ${options}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    StopDockerClient
    [Return]  ${cmd_result.stdout}

XWUSERSCommand
    [Documentation]  Usage :  XWUSERS
    ${container_id} =  StartDockerClient
    ${cmd_result} =  Run Process  docker exec -t ${container_id} ./xwusers  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    StopDockerClient
    [Return]  ${cmd_result.stdout}

XWCMODCommand
    [Documentation]  Usage :  XWCMOD
    [Arguments]  ${rights}  ${uid}
    ${container_id} =  StartDockerClient
    ${cmd_result} =  Run Process  docker exec -t ${container_id} ./xwchmod ${rights} ${uid}   shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    StopDockerClient
    [Return]  ${cmd_result.stdout}


