*** Settings ***
Documentation   testrpc

*** Variables ***
${TESTRPC_PROCESS}

*** Keywords ***
Start Testrpc
    ${created_process} =  Start Process  testrpc  shell=yes
    Set Suite Variable  ${TESTRPC_PROCESS}  ${created_process}

Stop Testrpc
    Terminate Process  ${TESTRPC_PROCESS}
