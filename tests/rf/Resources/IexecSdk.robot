*** Settings ***
Library  Process
Library  OperatingSystem
Library  String

*** Variables ***
# Github mode
${IEXEC_SDK_GIT_URL} =  https://github.com/iExecBlockchainComputing/iexec-sdk.git
${IEXEC_SDK_GIT_BRANCH} =  master
${IEXEC_SDK_FORCE_GIT_CLONE} =  true
${IEXEC_SDK_DISTRIB}
# docker mode
${IEXEC_SDK_IMAGE} =  iexechub/iexec-sdk
${IEXEC_SDK_IMAGE_VERSION} =  1.7.7
${DOCKER_NETWORK} =  docker_iexec-net
${REPO_DIR}

${LAUNCHED_IN_CONTAINER} =  false

*** Keywords ***

Init Sdk
    Run Keyword If  '${LAUNCHED_IN_CONTAINER}' == 'true'  Init Sdk JS

Iexec
    [Arguments]  ${args}
    Run Keyword If  '${LAUNCHED_IN_CONTAINER}' == 'true'  Iexec JS  ${args}
    Run Keyword If  '${LAUNCHED_IN_CONTAINER}' == 'false'  Iexec Docker  ${args}


Iexec An app
    [Arguments]  ${directory}  ${args}
    Run Keyword If  '${LAUNCHED_IN_CONTAINER}' == 'true'  Iexec An app JS  ${directory}  ${args}
    Run Keyword If  '${LAUNCHED_IN_CONTAINER}' == 'false'  Iexec An app Docker  ${directory}  ${args}

Iexec Init An App
    [Arguments]  ${appName}
    Run Keyword If  '${LAUNCHED_IN_CONTAINER}' == 'true'  Iexec Init An App JS  ${appName}
    Run Keyword If  '${LAUNCHED_IN_CONTAINER}' == 'false'  Iexec Init An App Docker  ${appName}

Get Iexec Sdk Log
    ${logs} =  GET FILE  ${REPO_DIR}/iexec-sdk.log
    LOG  ${logs}
    [Return]  ${logs}

# JS section start
Init Sdk JS
     Wait Until Keyword Succeeds  8 min	2 min  Npm Install Iexec Sdk JS

Npm Install Iexec Sdk JS
    ${npm_result} =  Run Process  npm i iexec -g  shell=yes
    Log  ${npm_result.stderr}
    Log  ${npm_result.stdout}
    Should Be Equal As Integers	${npm_result.rc}	0
    ${iexec_result} =  Run Process  iexec --version  shell=yes
    Log  ${iexec_result.stderr}
    Log  ${iexec_result.stdout}
    Should Be Equal As Integers	${iexec_result.rc}	0
    ${iexec_result} =  Run Process  iexec --help  shell=yes
    Log  ${iexec_result.stderr}
    Log  ${iexec_result.stdout}
    Should Be Equal As Integers	${iexec_result.rc}	0

Iexec JS
    [Arguments]  ${args}
    Remove File  ${REPO_DIR}/iexec-sdk.log
    Create File  ${REPO_DIR}/iexec-sdk.log
    ${iexec_result} =  Run Process  iexec ${args}  shell=yes  stderr=STDOUT  timeout=340s  stdout=${REPO_DIR}/iexec-sdk.log
    ${logs} =  Get Iexec Sdk Log
    [Return]  ${logs}

Iexec An app JS
    [Arguments]  ${directory}  ${args}
    Remove File  ${REPO_DIR}/iexec-sdk.log
    Create File  ${REPO_DIR}/iexec-sdk.log
    ${iexec_result} =  Run Process  cd ${REPO_DIR}/${directory} && DEBUG\=* iexec ${args}  shell=yes  stderr=STDOUT  timeout=340s  stdout=${REPO_DIR}/iexec-sdk.log
    ${logs} =  Get Iexec Sdk Log
    [Return]  ${logs}


Iexec Init An App JS
    [Arguments]  ${appName}
    Remove File  ${REPO_DIR}/iexec-sdk.log
    Create File  ${REPO_DIR}/iexec-sdk.log
    ${iexec_result} =  Run Process  cd ${REPO_DIR} && iexec init ${appName}  shell=yes  stderr=STDOUT  timeout=340s  stdout=${REPO_DIR}/iexec-sdk.log
    ${logs} =  Get Iexec Sdk Log
    [Return]  ${logs}
# JS section end

# Docker section start
Iexec Docker
    [Arguments]  ${args}
    Remove File  ${REPO_DIR}/iexec-sdk.log
    Create File  ${REPO_DIR}/iexec-sdk.log
    ${iexec_result} =  Run Process  docker run -e DEBUG\=* --interactive --rm --net ${DOCKER_NETWORK} -v $(pwd):/iexec-project -w /iexec-project ${IEXEC_SDK_IMAGE}:${IEXEC_SDK_IMAGE_VERSION} ${args}  shell=yes  stderr=STDOUT  timeout=340s  stdout=${REPO_DIR}/iexec-sdk.log
    ${logs} =  Get Iexec Sdk Log
    Should Be Equal As Integers  ${iexec_result.rc}  0
    [Return]  ${logs}


Iexec An app Docker
    [Arguments]  ${directory}  ${args}
    Remove File  ${REPO_DIR}/iexec-sdk.log
    Create File  ${REPO_DIR}/iexec-sdk.log
    ${iexec_result} =  Run Process  cd ${REPO_DIR}/${directory} && docker run -e DEBUG\=* --interactive --rm --net ${DOCKER_NETWORK} -v $(pwd):/iexec-project -w /iexec-project ${IEXEC_SDK_IMAGE}:${IEXEC_SDK_IMAGE_VERSION} ${args}  shell=yes  stderr=STDOUT  timeout=340s  stdout=${REPO_DIR}/iexec-sdk.log
    ${logs} =  Get Iexec Sdk Log
    #Should Be Equal As Integers	${iexec_result.rc}	0
    [Return]  ${logs}


Iexec Init An App Docker
    [Arguments]  ${appName}
    Remove File  ${REPO_DIR}/iexec-sdk.log
    Create File  ${REPO_DIR}/iexec-sdk.log
    Remove Directory  ${REPO_DIR}/iexec-${appName}  recursive=true
    Create Directory  ${REPO_DIR}/iexec-${appName}
    ${iexec_result} =  Run Process  cd ${REPO_DIR}/iexec-${appName} && docker run -e DEBUG\=* --interactive --rm --net ${DOCKER_NETWORK} -v $(pwd):/iexec-project -w /iexec-project ${IEXEC_SDK_IMAGE}:${IEXEC_SDK_IMAGE_VERSION} init ${appName}  shell=yes  stderr=STDOUT  timeout=340s  stdout=${REPO_DIR}/iexec-sdk.log
    ${logs} =  Get Iexec Sdk Log
    Directory Should Exist  ${REPO_DIR}/iexec-${appName}
    [Return]  ${logs}


Create Robot Chain Json
    [Arguments]  ${appName}
     Directory Should Exist  ${REPO_DIR}/iexec-${appName}
     File Should Exist  ${REPO_DIR}/iexec-${appName}/chain.json
     Copy File  ${REPO_DIR}/iexec-${appName}/chain.json  ${REPO_DIR}/iexec-${appName}/chain.json.ori
     Remove File  ${REPO_DIR}/iexec-${appName}/chain.json
     Create File  ${REPO_DIR}/iexec-${appName}/chain.json
     Append To File  ${REPO_DIR}/iexec-${appName}/chain.json  {
     Append To File  ${REPO_DIR}/iexec-${appName}/chain.json  "chains": {
     Append To File  ${REPO_DIR}/iexec-${appName}/chain.json  "robot": {
     Append To File  ${REPO_DIR}/iexec-${appName}/chain.json  "host": "http://TODO:8545",
     Append To File  ${REPO_DIR}/iexec-${appName}/chain.json  "id": "RODO",
     Append To File  ${REPO_DIR}/iexec-${appName}/chain.json  "server": "https://TODO:443",
     Append To File  ${REPO_DIR}/iexec-${appName}/chain.json  "hub": "TODO"
     Append To File  ${REPO_DIR}/iexec-${appName}/chain.json   }
     Append To File  ${REPO_DIR}/iexec-${appName}/chain.json   }
     Append To File  ${REPO_DIR}/iexec-${appName}/chain.json   }



# Docker section end

# Github section start
Init Sdk Github
    Run Keyword If  '${IEXEC_SDK_FORCE_GIT_CLONE}' == 'true'  Git Clone Iexec Sdk Github
    Npm Install Iexec Sdk Github


Git Clone Iexec Sdk Github
    Remove Directory  iexec-sdk  recursive=true
    ${git_result} =  Run Process  git clone -b ${IEXEC_SDK_GIT_BRANCH} ${IEXEC_SDK_GIT_URL}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0

Npm Install Iexec Sdk Github
    ${npm_result} =  Run Process  cd iexec-sdk && npm install  shell=yes
    Log  ${npm_result.stderr}
    Log  ${npm_result.stdout}
    Should Be Equal As Integers	${npm_result.rc}	0
    ${npm_result} =  Run Process  cd iexec-sdk && npm run build  shell=yes
    Log  ${npm_result.stderr}
    Log  ${npm_result.stdout}
    Should Be Equal As Integers	${npm_result.rc}	0
    Set Suite Variable  ${IEXEC_SDK_DISTRIB}  iexec-sdk/dist/iexec.js
    File Should Exist  ${IEXEC_SDK_DISTRIB}
    Iexec  --version
    Iexec  --help


Iexec Github
    [Arguments]  ${args}
    ${iexec_result} =  Run Process  ${IEXEC_SDK_DISTRIB} ${args}  shell=yes
    Log  ${iexec_result.stderr}
    Log  ${iexec_result.stdout}
    Should Be Equal As Integers	${iexec_result.rc}	0
    [Return]  ${iexec_result.stdout}

Iexec An app Github
    [Arguments]  ${directory}  ${args}
    ${iexec_result} =  Run Process  cd ${directory} && DEBUG\=* ../${IEXEC_SDK_DISTRIB} ${args}  shell=yes
    Log  ${iexec_result.stderr}
    Log  ${iexec_result.stdout}
    Should Be Equal As Integers	${iexec_result.rc}	0
    [Return]  ${iexec_result.stderr}


Iexec Init An App Github
    [Arguments]  ${appName}
    ${iexec_result} =  Run Process  ${IEXEC_SDK_DISTRIB} init ${appName}  shell=yes
    Log  ${iexec_result.stderr}
    Log  ${iexec_result.stdout}
    Should Be Equal As Integers	${iexec_result.rc}	0
    [Return]  ${iexec_result.stdout}
# Github section end