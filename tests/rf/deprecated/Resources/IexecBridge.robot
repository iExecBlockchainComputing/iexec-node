*** Settings ***

*** Variables ***
${IEXEC_BRIDGE_GIT_URL} =  https://github.com/iExecBlockchainComputing/iexec-bridge.git
${IEXEC_BRIDGE_GIT_BRANCH} =  master
${IEXEC_BRIDGE_FORCE_GIT_CLONE} =  false
${BRIDGE_PROCESS}
${IEXEC_ORACLE_SM_ADDRESS}
${HELLO_WORLD_SM_ADDRESS}
*** Keywords ***


Init Bridge
    Run Keyword If  '${IEXEC_BRIDGE_FORCE_GIT_CLONE}' == 'true'  Git Clone Iexec Bridge
    Npm Install Bridge
    Set Oracle Address In Bridge


Git Clone Iexec Bridge
    Remove Directory  iexec-bridge  recursive=true
    ${git_result} =  Run Process  git clone -b ${IEXEC_BRIDGE_GIT_BRANCH} ${IEXEC_BRIDGE_GIT_URL}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0

Npm Install Bridge
    ${npm_result} =  Run Process  cd iexec-bridge && npm install  shell=yes
    Log  ${npm_result.stderr}
    Log  ${npm_result.stdout}
    Should Be Equal As Integers	${npm_result.rc}	0

Set Oracle Address In Bridge
    Run  sed -i 's/.*truffleContract.at(.*/const contractInstance = truffleContract.at(\"${IEXEC_ORACLE_SM_ADDRESS}\");/g' iexec-bridge/bridge.js

Start Bridge
    # clear log
    Remove File  iexec-bridge/bridge.log
    ${created_process} =  Start Process  cd iexec-bridge && npm run devbridgelog  shell=yes
    Set Suite Variable  ${BRIDGE_PROCESS}  ${created_process}

Stop Bridge
    Get Bridge Log
    Terminate Process  ${BRIDGE_PROCESS}

Get Bridge Log
    ${bridge_log} =  GET FILE  iexec-bridge/bridge.log
    LOG  ${bridge_log}
    [Return]  ${bridge_log}