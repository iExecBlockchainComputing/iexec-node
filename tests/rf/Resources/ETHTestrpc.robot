*** Settings ***
Documentation   testrpc

*** Variables ***
${TESTRPC_PROCESS}
${TESTRPC_UTILS_PATH} =  ./vagrant/testrpcUtils

*** Keywords ***

Init And Start Testrpc
    ${result} =  Run Process  npm install -g ethereumjs-testrpc@4.1.1  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers	${result.rc}	0
    Start Testrpc

Start Testrpc
    ${created_process} =  Start Process  testrpc --network-id\=42  shell=yes
    Set Suite Variable  ${TESTRPC_PROCESS}  ${created_process}

Test Testrpc Up
    Is Process Running  ${TESTRPC_PROCESS}

Stop Testrpc
    Terminate Process  ${TESTRPC_PROCESS}
    ${stdout} =	Get Process Result	${TESTRPC_PROCESS}  stdout=true
    Log  ${stdout}
    ${stderr} =	Get Process Result	${TESTRPC_PROCESS}  stderr=true
    Log  ${stderr}

Log Testrpc
    Log File  testrpcstdout.log
    Log File  testrpcstderr.log

Give Me Five
    [Arguments]  ${to}
    ${testrpc_result} =  Run Process  cd ${TESTRPC_UTILS_PATH} && npm install && node giveMeFive.js ${to}  shell=yes
    Log  ${testrpc_result.stderr}
    Log  ${testrpc_result.stdout}
    Should Be Equal As Integers	${testrpc_result.rc}	0

Get Balance Of
    [Arguments]  ${address}
    ${testrpc_result} =  Run Process  cd ${TESTRPC_UTILS_PATH} && npm install && node balance.js ${address}  shell=yes
    Log  ${testrpc_result.stderr}
    Log  ${testrpc_result.stdout}
    Should Be Equal As Integers	${testrpc_result.rc}	0
    [Return]  ${testrpc_result.stdout}