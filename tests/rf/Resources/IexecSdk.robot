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
${IEXEC_SDK_IMAGE_VERSION} =  2.2.1
${DOCKER_NETWORK} =  docker_iexec-net
${REPO_DIR}
${PRIVATE_KEY_SDK_TO_USE}

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
    [Arguments]  ${args}
    Remove File  ${REPO_DIR}/iexec-sdk.log
    Create File  ${REPO_DIR}/iexec-sdk.log
    Directory Should Exist  ${REPO_DIR}/iexec-app
    ${iexec_result} =  Run Process  cd ${REPO_DIR}/iexec-app && docker run -e DEBUG\=* --interactive --rm --net ${DOCKER_NETWORK} -v $(pwd):/iexec-project -w /iexec-project ${IEXEC_SDK_IMAGE}:${IEXEC_SDK_IMAGE_VERSION} ${args} --chain robot  shell=yes  stderr=STDOUT  timeout=340s  stdout=${REPO_DIR}/iexec-sdk.log
    ${logs} =  Get Iexec Sdk Log
    #Should Be Equal As Integers	${iexec_result.rc}	0
    [Return]  ${logs}


Prepare Iexec App For Robot Test Docker
   [Arguments]  ${iexecdotjs}  ${chainhost}  ${schedulerhost}  ${hub}
   Directory Should Exist  ${REPO_DIR}
   Remove Directory  ${REPO_DIR}/iexec-app  recursive=true
   Create Directory  ${REPO_DIR}/iexec-app
   Run Process  cd ${REPO_DIR}/iexec-app && docker run -e DEBUG\=* --interactive --rm --net ${DOCKER_NETWORK} -v $(pwd):/iexec-project -w /iexec-project ${IEXEC_SDK_IMAGE}:${IEXEC_SDK_IMAGE_VERSION} init  shell=yes  stderr=STDOUT  timeout=340s  stdout=${REPO_DIR}/iexec-sdk.log
   ${logs} =  Get Iexec Sdk Log
   File Should Exist  ${REPO_DIR}/iexec-app/iexec.json
   Copy File  ${REPO_DIR}/iexec-app/iexec.json  ${REPO_DIR}/iexec-app/iexec.json.ori
   Remove File  ${REPO_DIR}/iexec-app/iexec.json
   Run Process  cd ${REPO_DIR}/iexec-app && wget ${iexecdotjs}  shell=yes  stderr=STDOUT  timeout=340s  stdout=${REPO_DIR}/iexec-sdk.log
   File Should Exist  ${REPO_DIR}/iexec-app/iexec.json
   Log File  ${REPO_DIR}/iexec-app/iexec.json
   Create Robot Chain Json  ${chainhost}  ${schedulerhost}  ${hub}
   Create Robot Wallet Json


Add App To Buy To Iexec Conf
   [Arguments]  ${app}
    Directory Should Exist  ${REPO_DIR}/iexec-app
    File Should Exist  ${REPO_DIR}/iexec-app/iexec.json
    ${contents}=  Get File  ${REPO_DIR}/iexec-app/iexec.json
    ${contents} =  Replace String  ${contents}  "params": {  "app":"${app}","params": {
    Copy File  ${REPO_DIR}/iexec-app/iexec.json  ${REPO_DIR}/iexec-app/iexec.json.${app}
    Remove File  ${REPO_DIR}/iexec-app/iexec.json
    Create File  ${REPO_DIR}/iexec-app/iexec.json  content=${contents}

Create Robot Wallet Json
    Directory Should Exist  ${REPO_DIR}/iexec-app
    File Should Exist  ${REPO_DIR}/iexec-app/wallet.json
    Copy File  ${REPO_DIR}/iexec-app/wallet.json  ${REPO_DIR}/iexec-app/wallet.json.ori
    ${wallet_content} =  GET FILE  ${REPO_DIR}/iexec-app/wallet.json
    @{privateKey} =  Get Regexp Matches  ${wallet_content}  "privateKey": "(?P<privateKey>.*)"  privateKey
    Log  @{privateKey}[0]
    ${wallet_content} =  Replace String  ${wallet_content}  @{privateKey}[0]  ${PRIVATE_KEY_SDK_TO_USE}
    Remove File  ${REPO_DIR}/iexec-app/wallet.json
    Create File  ${REPO_DIR}/iexec-app/wallet.json  content=${wallet_content}


Create Robot Chain Json
    [Arguments]  ${chainhost}  ${schedulerhost}  ${hub}
     Directory Should Exist  ${REPO_DIR}/iexec-app
     File Should Exist  ${REPO_DIR}/iexec-app/chain.json
     Copy File  ${REPO_DIR}/iexec-app/chain.json  ${REPO_DIR}/iexec-app/chain.json.ori
     Remove File  ${REPO_DIR}/iexec-app/chain.json
     Create File  ${REPO_DIR}/iexec-app/chain.json
     Append To File  ${REPO_DIR}/iexec-app/chain.json  {
     Append To File  ${REPO_DIR}/iexec-app/chain.json  "chains": {
     Append To File  ${REPO_DIR}/iexec-app/chain.json  "robot": {
     Append To File  ${REPO_DIR}/iexec-app/chain.json  "host": "http://${chainhost}:8545",
     Append To File  ${REPO_DIR}/iexec-app/chain.json  "id": "1337",
     Append To File  ${REPO_DIR}/iexec-app/chain.json  "server": "https://${schedulerhost}:443",
     Append To File  ${REPO_DIR}/iexec-app/chain.json  "hub": "${hub}"
     Append To File  ${REPO_DIR}/iexec-app/chain.json   }
     Append To File  ${REPO_DIR}/iexec-app/chain.json   }
     Append To File  ${REPO_DIR}/iexec-app/chain.json   }



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