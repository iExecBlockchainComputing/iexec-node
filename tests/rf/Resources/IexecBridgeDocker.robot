*** Settings ***
Resource  ./DockerHelper.robot

*** Variables ***
${IEXEC_BRIDGE_GIT_URL} =  https://github.com/iExecBlockchainComputing/iexec-bridge.git
${IEXEC_BRIDGE_GIT_BRANCH} =  master
${IEXEC_BRIDGE_FORCE_GIT_CLONE} =  false
${BRIDGE_PROCESS}
${BRIDGE_CONTAINER_ID}
${IEXEC_ORACLE_SM_ADDRESS}
${HELLO_WORLD_SM_ADDRESS}
*** Keywords ***


Init Bridge
    Run Keyword If  '${IEXEC_BRIDGE_FORCE_GIT_CLONE}' == 'true'  Git Clone Iexec Bridge
    Remove File  iexec-bridge/.env
    Create File  iexec-bridge/.env
    Append To File  iexec-bridge/.env  CHAIN\=local\n
    Append To File  iexec-bridge/.env  HOST\=ws://${LOCAL_GETH_DOCKER_SERVICE}:${LOCAL_GETH_WS_PORT}\n
    #Append To File  iexec-bridge/.env  PRIVATE_KEY\=${ACCOUNT_0_PRIVATE_KEY}\n
    Append To File  iexec-bridge/.env  XW_LOGIN\=${XWCONFIGURE.VALUES.XWADMINLOGIN}\n
    Append To File  iexec-bridge/.env  XW_PWD\=${XWCONFIGURE.VALUES.XWADMINPASSWORD}\n
    Append To File  iexec-bridge/.env  XW_HOST\=${XWCONFIGURE.VALUES.XWSERVER}\n
    Append To File  iexec-bridge/.env  XW_PORT\=${XWCONFIGURE.VALUES.HTTPSPORT}\n
    #Append To File  iexec-bridge/.env  IEXEC_ORACLE\=${IEXEC_ORACLE_SM_ADDRESS}\n
    ${docker_build} =  Run Process  cd iexec-bridge && docker build -t iexec-bridge:latest . -f ./Dockerfile.dev && cd -  shell=yes
    Log  ${docker_build.stderr}
    Should Be Empty	${docker_build.stderr}
    Log  ${docker_build.stdout}
    Should Be Equal As Integers	${docker_build.rc}	0

Git Clone Iexec Bridge
    Remove Directory  iexec-bridge  recursive=true
    ${git_result} =  Run Process  git clone -b ${IEXEC_BRIDGE_GIT_BRANCH} ${IEXEC_BRIDGE_GIT_URL}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0

Start Bridge
    ${created_process} =  Start Process  cd iexec-bridge && export PRIVATE_KEY\=${ACCOUNT_0_PRIVATE_KEY} && export IEXEC_ORACLE\=${IEXEC_ORACLE_SM_ADDRESS} && docker-compose -f docker-compose.dev.yml up  shell=yes  stderr=STDOUT
    Set Suite Variable  ${BRIDGE_PROCESS}  ${created_process}
    ${container_id} =  Wait Until Keyword Succeeds  3 min	10 sec  DockerHelper.Get Docker Container Id From Image  iexec-bridge
    Log  ${container_id}
    Set Suite Variable  ${BRIDGE_CONTAINER_ID}  ${container_id}

Stop Bridge
    Terminate Process  ${BRIDGE_PROCESS}
    Get Bridge Log


Get Bridge Log
    ${bridge_log} =  DockerHelper.Logs By Container Id  ${BRIDGE_CONTAINER_ID}
    LOG  ${bridge_log}
    [Return]  ${bridge_log}