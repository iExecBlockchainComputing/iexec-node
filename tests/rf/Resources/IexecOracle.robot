*** Settings ***

*** Variables ***
${IEXEC_ORACLE_GIT_BRANCH} =  https://github.com/iExecBlockchainComputing/iexec-oracle.git
${IEXEC_ORACLE_FORCE_GIT_CLONE} =  true
${IEXEC_ORACLE_SM_ADDRESS}
${HELLO_WORLD_SM_ADDRESS}
*** Keywords ***

Init Oracle
    Iexec Oracle Truffle Migrate
    Iexec Oracle Set Contract Address In Test

Git Clone Iexec Oracle
    Remove Directory  iexec-oracle  recursive=true
    ${git_result} =  Run Process  git clone ${IEXEC_ORACLE_GIT_BRANCH}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0
    ${npm_result} =  Run Process  cd iexec-oracle && npm install  shell=yes
    Log  ${npm_result.stderr}
    Log  ${npm_result.stdout}
    Should Be Equal As Integers	${npm_result.rc}	0

Iexec Oracle Truffle Tests
    [Documentation]  call truffle test and show the result here.
    [Tags]  Smart contract Tests
    Run Keyword If  '${IEXEC_ORACLE_FORCE_GIT_CLONE}' == 'true'  Git Clone Iexec Oracle
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/iexecoracleapi.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0


Iexec Oracle Truffle Migrate
    [Documentation]  call truffle migrate
    [Tags]  Smart contract Tests
    Run Keyword If  '${IEXEC_ORACLE_FORCE_GIT_CLONE}' == 'true'  Git Clone Iexec Oracle
    ${rm_result} =  Run Process  rm -rf iexec-oracle/build  shell=yes
    Should Be Empty	${rm_result.stderr}
    Should Be Equal As Integers	${rm_result.rc}	0
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle migrate  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0

Iexec Oracle Set Contract Address In Test
    #IexecOracle.sol
    ${iexecOracle_json_content} =  Get File  iexec-oracle/build/contracts/IexecOracle.json
    @{smartContractAddress} =  Get Regexp Matches  ${iexecOracle_json_content}  "address": "(?P<smartContractAddress>.*)",  smartContractAddress
    LOG  @{smartContractAddress}
    LOG  @{smartContractAddress}[0]
    Set Suite Variable  ${IEXEC_ORACLE_SM_ADDRESS}  @{smartContractAddress}[0]
    Run  sed -i 's/.*return IexecOracle.at(.*/return IexecOracle.at(\"${IEXEC_ORACLE_SM_ADDRESS}\")/g' iexec-oracle/test/rf/*
    #HelloWorld.sol
    ${helloworld_json_content} =  Get File  iexec-oracle/build/contracts/HelloWorldTest.json
    @{smartContractAddress} =  Get Regexp Matches  ${helloworld_json_content}  "address": "(?P<smartContractAddress>.*)",  smartContractAddress
    LOG  @{smartContractAddress}
    LOG  @{smartContractAddress}[0]
    Set Suite Variable  ${HELLO_WORLD_SM_ADDRESS}  @{smartContractAddress}[0]
    Run  sed -i 's/.*return HelloWorldTest.at(.*/return HelloWorldTest.at(\"${HELLO_WORLD_SM_ADDRESS}\")/g' iexec-oracle/test/rf/*