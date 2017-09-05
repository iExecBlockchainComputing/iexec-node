*** Settings ***
Documentation    All smart contract tests on Local Geth
Library  Process
Library  OperatingSystem
Library  String
Suite Setup  Start Geth42
Suite Teardown  Stop Geth42
Resource  ../Resources/IexecOracle.robot

*** Variables ***

*** Test Cases ***

Test Iexec Oracle Truffle Tests On Local Geth
    [Documentation]  call truffle test on a started local geth and show the result here.
    [Tags]  Smart contract Tests
    IexecOracle.Iexec Oracle Truffle Tests

*** Keywords ***
Start Geth42
    ${geth_result} =  Run Process  cd ~/gethUtils && ./resetANewChain42AndMine.sh  shell=yes
    Log  ${geth_result.stderr}
    Log  ${geth_result.stdout}
    Should Be Equal As Integers	${geth_result.rc}	0


Stop Geth42
    ${geth_result} =  Run Process  cd ~/gethUtils && ./killGeth.sh  shell=yes
    Log  ${geth_result.stderr}
    Log  ${geth_result.stdout}
    Should Be Equal As Integers	${geth_result.rc}	0


