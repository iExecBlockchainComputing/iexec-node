*** Settings ***
Documentation    All smart contract tests on Local Geth
Library  Process
Library  OperatingSystem
Library  String
Resource  ../Resources/IexecOracle.robot
Resource  ../Resources/ETHGeth.robot
Suite Setup  ETHGeth.Start Geth42
Suite Teardown  ETHGeth.Stop Geth42



*** Variables ***

*** Test Cases ***

Test Iexec Oracle Truffle Tests On Local Geth
    [Documentation]  call truffle test on a started local geth and show the result here.
    [Tags]  Smart contract Tests
    IexecOracle.Iexec Oracle Truffle Tests

*** Keywords ***