*** Settings ***
Documentation   local geth 42 node

*** Variables ***
${GETH_UTILS_PATH} =  ./vagrant/geth
${GETH_PROCESS}
${GETH_LOG} =  ./vagrant/geth/localgeth.log

*** Keywords ***
Start Geth42
    Run Process  cd ${GETH_UTILS_PATH} && docker network create webproxy  shell=yes
    Remove File  ${GETH_LOG}
    ${created_process} =  Start Process  cd ${GETH_UTILS_PATH} && docker-compose -f geth-local.docker-compose.yml up --build  shell=yes  stderr=STDOUT  stdout=${GETH_LOG}
    Set Suite Variable  ${GETH_PROCESS}  ${created_process}
    Sleep  120s

Stop Geth42
    Terminate Process  ${GETH_PROCESS}
    Log File  ${GETH_LOG}


Give Me Five
    [Arguments]  ${to}
    ${testrpc_result} =  Run Process  cd ${GETH_UTILS_PATH} && ./giveMeFive42.sh ${to}  shell=yes
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