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
    ${created_process} =  Start Process  docker run -t --env XWSERVERADDR\="scheduler" --env XWSERVERNAME\="xwscheduler" -v ${DIST_XWHEP_PATH}/docker/xwscheduler.pem:/xwhep/certificate/xwscheduler.pem --network\=docker_xtremweb-net ${DOCKER_CLIENT_IMAGE_NAME}  shell=yes  stderr=STDOUT  stdout=./xwhep.client.docker.process.log

    ${container_id} =  Wait Until Keyword Succeeds  5 sec   1 sec  DockerHelper.Get Docker Container Id From Image  ${DOCKER_CLIENT_IMAGE_NAME}
    Log  ${container_id}
    [Return]  ${container_id}

StopDockerClient
    ${container_id} =  Wait Until Keyword Succeeds  5 sec   1 sec  DockerHelper.Get Docker Container Id From Image  ${DOCKER_CLIENT_IMAGE_NAME}
    Log  ${container_id}
    DockerHelper.Remove Container  ${container_id}
    

XWSENDAPPCommand
    [Documentation]  Usage :  SENDAPP appName appType cpuType osName URI | UID : inserts/updates an application; URI or UID points to binary file ; application name must be the first parameter
    #[Arguments]  ${options}=${EMPTY}
    [Arguments]   ${appName}  ${appType}  ${osName}  ${cpuType}  ${host_file}  ${options}=''
    ${container_id} =  StartDockerClient
    ${filename} =  Run Process  basename ${host_file}  shell=yes
    DockerHelper.Copy File To Container  ${container_id}  ${host_file}  /xwhep/${filename.stdout}
    ${cmd_result} =  Run Process  docker exec -t ${container_id} ./xwsendapp ${appName} ${appType} ${osName} ${cpuType} /xwhep/${filename.stdout} ${options}  shell=yes
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    ${uid} =  Get Substring  ${cmd_result.stdout}  -36
    StopDockerClient 
    [Return]  ${uid}

XWSENDAPPCommandOnContainer
    [Documentation]  Usage :  SENDAPP appName appType cpuType osName URI | UID : inserts/updates an application; URI or UID points to binary file ; application name must be the first parameter
    [Arguments]  ${container_id}  ${options}=${EMPTY}
    #[Arguments]   ${appName}  ${appType}  ${osName}  ${cpuType}  ${host_file}  ${options}=''

    ${cmd_result} =  Run Process  docker exec -t ${container_id} ./xwsendapp ${options}  shell=yes
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    ${uid} =  Get Substring  ${cmd_result.stdout}  -36

    [Return]  ${uid}

Set MANDATINGLOGIN With Docker Client
    [Arguments]  ${container_id}  ${MANDATED}
    ${cmd_result} =  Run Process  docker exec -t ${container_id} sed -i \"s/.*MANDATINGLOGIN.*/MANDATINGLOGIN\=${MANDATED}/g\" /xwhep/conf/xtremweb.client.conf  shell=yes
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    DockerHelper.Log File Of Container  ${container_id}  /xwhep/conf/xtremweb.client.conf

Set MANDATINGLOGIN OnContainer
    [Arguments]  ${container_id}  ${MANDATED}
    ${cmd_result} =  Run Process  docker exec -t ${container_id} sed -i \"s/.*MANDATINGLOGIN.*/MANDATINGLOGIN\=${MANDATED}/g\" /xwhep/conf/xtremweb.client.conf  shell=yes
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    DockerHelper.Log File Of Container  ${container_id}  /xwhep/conf/xtremweb.client.conf


Remove MANDATINGLOGIN OnContainer
    [Arguments]  ${container_id}
    ${cmd_result} =  Run Process  docker exec -t ${container_id} sed -i \"s/.*MANDATINGLOGIN.*//g\" /xwhep/conf/xtremweb.client.conf  shell=yes
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    DockerHelper.Log File Of Container  ${container_id}  /xwhep/conf/xtremweb.client.conf


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

XWSENDDATACommandOnContainer
    [Documentation]  Usage :  SENDDATA dataName [cpuType] [osName] [dataType] [accessRigths] [dataFile | dataURI | dataUID] : sends data and uploads data if dataFile provided
    [Arguments]  ${container_id}  ${options}=${EMPTY}

    ${cmd_result} =  Run Process  docker exec -t ${container_id} ./xwsenddata ${options}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    ${uid} =  Get Substring  ${cmd_result.stdout}  -36

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

XWSUBMITCommandOnContainer
    [Documentation]  Usage :  XWSUBMIT appName
    [Arguments]  ${container_id}  ${appName}

    ${cmd_result} =  Run Process  docker exec -t ${container_id} ./xwsubmit ${appName}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    ${uid} =  Get Substring  ${cmd_result.stdout}  -36

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

    DockerHelper.Copy File From Container  ${container_id}  @{results_file}[0]  ${DIST_XWHEP_PATH}

    ${filename_result} =  Run Process  basename @{results_file}[0]  shell=yes
    Log  ${filename_result.stderr}
    Log  ${filename_result.stdout}
    Should Be Equal As Integers  ${filename_result.rc}  0

    StopDockerClient 
    [Return]  ${DIST_XWHEP_PATH}/${filename_result.stdout}

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

XWSENDUSERCommandOnContainer
    [Documentation]  Usage :  XWSENDUSERCommand SENDUSER login password email rights [<a user group UID | URI> ] : sends/updates a useruid
    [Arguments]  ${container_id}  ${options}=${EMPTY}

    ${cmd_result} =  Run Process  docker exec -t ${container_id} ./xwsenduser ${options}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0

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


