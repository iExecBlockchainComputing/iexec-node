*** Settings ***

*** Variables ***
${IEXEC_BRIDGE_GIT_BRANCH} =  https://github.com/iExecBlockchainComputing/iexec-bridge.git
${IEXEC_BRIDGE_FORCE_GIT_CLONE} =  false
${BRIDGE_PROCESS}
${IEXEC_ORACLE_SM_ADDRESS}
${HELLO_WORLD_SM_ADDRESS}
*** Keywords ***


Init Bridge
    Run Keyword If  '${IEXEC_BRIDGE_FORCE_GIT_CLONE}' == 'true'  Git Clone Iexec Bridge
    Npm Install Bridge
    Set Oracle Address In Bridge
    Set XtremWeb Config In Bridge

Git Clone Iexec Bridge
    Remove Directory  iexec-bridge  recursive=true
    ${git_result} =  Run Process  git clone ${IEXEC_BRIDGE_GIT_BRANCH}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0

Npm Install Bridge
    ${npm_result} =  Run Process  cd iexec-bridge && npm install  shell=yes
    Log  ${npm_result.stderr}
    Log  ${npm_result.stdout}
    Should Be Equal As Integers	${npm_result.rc}	0


Set Oracle Address In Bridge
    Run  sed -i 's/.*"ContractAddress":.*/"ContractAddress":\"${IEXEC_ORACLE_SM_ADDRESS}\"/g' iexec-bridge/config.json

Set XtremWeb Config In Bridge
    LOG  ${XWCONFIGURE.VALUES.XWSERVER}
    Run  sed -i "s/.*const LOCALHOSTNAME = .*/const LOCALHOSTNAME = '${XWCONFIGURE.VALUES.XWSERVER}';/g" iexec-bridge/xwhep.js
    LOG  ${XWCONFIGURE.VALUES.HTTPSPORT}
    Run  sed -i "s/.*const LOCALHOSTPORT = .*/const LOCALHOSTPORT = ${XWCONFIGURE.VALUES.HTTPSPORT};/g" iexec-bridge/xwhep.js
    LOG  ${XWCONFIGURE.VALUES.XWADMINLOGIN}
    Run  sed -i "s/.*const LOGIN = .*/const LOGIN = '${XWCONFIGURE.VALUES.XWADMINLOGIN}';/g" iexec-bridge/xwhep.js
    LOG  ${XWCONFIGURE.VALUES.XWADMINPASSWORD}
    Run  sed -i "s/.*const PASSWD = .*/const PASSWD = '${XWCONFIGURE.VALUES.XWADMINPASSWORD}';/g" iexec-bridge/xwhep.js

Start Bridge
    # clear log
    Remove File  iexec-bridge/bridge.log
    ${created_process} =  Start Process  cd iexec-bridge && npm run devbridgelog  shell=yes
    Set Suite Variable  ${BRIDGE_PROCESS}  ${created_process}

Stop Bridge
    Terminate Process  ${BRIDGE_PROCESS}

Get Bridge Log
    ${bridge_log} =  GET FILE  iexec-bridge/bridge.log
    LOG  ${bridge_log}
    [Return]  ${bridge_log}