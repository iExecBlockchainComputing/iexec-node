*** Settings ***
Documentation   testrpc

*** Variables ***
${TESTRPC_PROCESS}

*** Keywords ***

Init And Start Testrpc
    ${result} =  Run Process  npm install -g ethereumjs-testrpc@4.1.1  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers	${result.rc}	0
    Start Testrpc

Start Testrpc
    ${created_process} =  Start Process  testrpc  shell=yes
    Set Suite Variable  ${TESTRPC_PROCESS}  ${created_process}

Test Testrpc Up
    Is Process Running  ${TESTRPC_PROCESS}

Stop Testrpc
    Terminate Process  ${TESTRPC_PROCESS}
