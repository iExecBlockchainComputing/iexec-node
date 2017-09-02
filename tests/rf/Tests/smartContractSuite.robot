*** Settings ***
Documentation    All smart contract tests
Library  Process
Library  OperatingSystem
Library  String
Suite Setup  Start Testrpc
Suite Teardown  Stop Testrpc

*** Variables ***
${IEXEC_ORACLE_GIT_BRANCH} =  https://github.com/iExecBlockchainComputing/iexec-oracle.git
${TESTRPC_PROCESS}

*** Test Cases ***

Test Iexec Oracle smart contract
    [Documentation]  call truffle test and show the result here.
    [Tags]  Smart contract Tests
    Remove Directory  iexec-oracle  recursive=true
    ${git_result} =  Run Process  git clone ${IEXEC_ORACLE_GIT_BRANCH}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0
    ${npm_result} =  Run Process  cd iexec-oracle/API && npm install  shell=yes
    Log  ${npm_result.stderr}
    Log  ${npm_result.stdout}
    Should Be Equal As Integers	${npm_result.rc}	0
    ${truffletest_result} =  Run Process  cd iexec-oracle/API && ./node_modules/.bin/truffle test test/iexecoracleapi.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0

*** Keywords ***
Start Testrpc
    ${created_process} =  Start Process  testrpc  shell=yes
    Set Suite Variable  ${TESTRPC_PROCESS}  ${created_process}

Stop Testrpc
    Terminate Process  ${TESTRPC_PROCESS}


