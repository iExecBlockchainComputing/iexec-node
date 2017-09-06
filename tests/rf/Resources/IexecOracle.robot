*** Settings ***

*** Variables ***
${IEXEC_ORACLE_GIT_BRANCH} =  https://github.com/iExecBlockchainComputing/iexec-oracle.git
${IEXEC_ORACLE_FORCE_GIT_CLONE} =  true
${BRIDGE_PROCESS}
${IEXEC_ORACLE_SM_ADDRESS}
${HELLO_WORLD_SM_ADDRESS}
*** Keywords ***


Git Clone Iexec Oracle
    Remove Directory  iexec-oracle  recursive=true
    ${git_result} =  Run Process  git clone ${IEXEC_ORACLE_GIT_BRANCH}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0
    ${npm_result} =  Run Process  cd iexec-oracle/API && npm install  shell=yes
    Log  ${npm_result.stderr}
    Log  ${npm_result.stdout}
    Should Be Equal As Integers	${npm_result.rc}	0
    ${npm_result} =  Run Process  cd iexec-oracle/Bridge && npm install  shell=yes
    Log  ${npm_result.stderr}
    Log  ${npm_result.stdout}
    Should Be Equal As Integers	${npm_result.rc}	0

Iexec Oracle Truffle Tests
    [Documentation]  call truffle test and show the result here.
    [Tags]  Smart contract Tests
    Run Keyword If  '${IEXEC_ORACLE_FORCE_GIT_CLONE}' == 'true'  Git Clone Iexec Oracle
    ${truffletest_result} =  Run Process  cd iexec-oracle/API && ./node_modules/.bin/truffle test test/iexecoracleapi.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0


Iexec Oracle Truffle Migrate
    [Documentation]  call truffle migrate
    [Tags]  Smart contract Tests
    Run Keyword If  '${IEXEC_ORACLE_FORCE_GIT_CLONE}' == 'true'  Git Clone Iexec Oracle
    ${rm_result} =  Run Process  rm -rf iexec-oracle/API/build  shell=yes
    Should Be Empty	${rm_result.stderr}
    Should Be Equal As Integers	${rm_result.rc}	0
    ${truffletest_result} =  Run Process  cd iexec-oracle/API && ./node_modules/.bin/truffle migrate  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0

Iexec Oracle Set Contract Address In Bridge
    #IexecOracle.sol
    ${iexecOracle_json_content} =  Get File  iexec-oracle/API/build/contracts/IexecOracle.json
    @{smartContractAddress} =  Get Regexp Matches  ${iexecOracle_json_content}  "address": "(?P<smartContractAddress>.*)",  smartContractAddress
    LOG  @{smartContractAddress}
    LOG  @{smartContractAddress}[0]
    Set Suite Variable  ${IEXEC_ORACLE_SM_ADDRESS}  @{smartContractAddress}[0]
    Run  sed -i 's/.*"ContractAddress":.*/"ContractAddress":\"${IEXEC_ORACLE_SM_ADDRESS}\"/g' iexec-oracle/Bridge/config.json
    Run  sed -i 's/.*return IexecOracle.at(.*/return IexecOracle.at(\"${IEXEC_ORACLE_SM_ADDRESS}\")/g' iexec-oracle/API/test/rf/*
    #HelloWorld.sol
    ${helloworld_json_content} =  Get File  iexec-oracle/API/build/contracts/HelloWorld.json
    @{smartContractAddress} =  Get Regexp Matches  ${helloworld_json_content}  "address": "(?P<smartContractAddress>.*)",  smartContractAddress
    LOG  @{smartContractAddress}
    LOG  @{smartContractAddress}[0]
    Set Suite Variable  ${HELLO_WORLD_SM_ADDRESS}  @{smartContractAddress}[0]
    Run  sed -i 's/.*return HelloWorld.at(.*/return HelloWorld.at(\"${HELLO_WORLD_SM_ADDRESS}\")/g' iexec-oracle/API/test/rf/*

Iexec Oracle Set XtremWeb Config In Bridge
    LOG  ${XWCONFIGURE.VALUES.XWSERVER}
    Run  sed -i "s/.*const LOCALHOSTNAME = .*/const LOCALHOSTNAME = '${XWCONFIGURE.VALUES.XWSERVER}';/g" iexec-oracle/Bridge/xwhep.js
    LOG  ${XWCONFIGURE.VALUES.HTTPSPORT}
    Run  sed -i "s/.*const LOCALHOSTPORT = .*/const LOCALHOSTPORT = ${XWCONFIGURE.VALUES.HTTPSPORT};/g" iexec-oracle/Bridge/xwhep.js
    LOG  ${XWCONFIGURE.VALUES.XWADMINLOGIN}
    Run  sed -i "s/.*const LOGIN = .*/const LOGIN = '${XWCONFIGURE.VALUES.XWADMINLOGIN}';/g" iexec-oracle/Bridge/xwhep.js
    LOG  ${XWCONFIGURE.VALUES.XWADMINPASSWORD}
    Run  sed -i "s/.*const PASSWD = .*/const PASSWD = '${XWCONFIGURE.VALUES.XWADMINPASSWORD}';/g" iexec-oracle/Bridge/xwhep.js

Start Bridge
    # clear log
    Remove File  iexec-oracle/Bridge/bridge.log
    ${created_process} =  Start Process  cd iexec-oracle/Bridge && npm run devbridgelog  shell=yes
    Set Suite Variable  ${BRIDGE_PROCESS}  ${created_process}

Stop Bridge
    Terminate Process  ${BRIDGE_PROCESS}

Get Bridge Log
    ${bridge_log} =  GET FILE  iexec-oracle/Bridge/bridge.log
    LOG  ${bridge_log}
    [Return]  ${bridge_log}