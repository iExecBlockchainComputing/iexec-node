*** Settings ***

*** Variables ***
${IEXEC_ORACLE_GIT_BRANCH} =  https://github.com/iExecBlockchainComputing/iexec-oracle.git

*** Keywords ***

Iexec Oracle Truffle Tests
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