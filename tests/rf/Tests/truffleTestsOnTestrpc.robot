*** Settings ***
Documentation    All smart contract tests on testrpc
Library  Process
Library  OperatingSystem
Library  String
Suite Setup  Start Testrpc
Suite Teardown  Stop Testrpc
Resource  ../Resources/ETHTruffleTests.robot

*** Variables ***
${TESTRPC_PROCESS}

*** Test Cases ***

Test Iexec Oracle Truffle Tests On Testrpc
    [Documentation]  call truffle test on a started testrpc and show the result here.
    [Tags]  Smart contract Tests
    ETHTruffleTests.Iexec Oracle Truffle Tests

*** Keywords ***
Start Testrpc
    ${created_process} =  Start Process  testrpc  shell=yes
    Set Suite Variable  ${TESTRPC_PROCESS}  ${created_process}

Stop Testrpc
    Terminate Process  ${TESTRPC_PROCESS}


