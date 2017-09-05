*** Settings ***
Documentation    All smart contract tests on testrpc
Library  Process
Library  OperatingSystem
Library  String
Resource  ../Resources/IexecOracle.robot
Resource  ../Resources/ETHTestrpc.robot
Suite Setup  ETHTestrpc.Start Testrpc
Suite Teardown  ETHTestrpc.Stop Testrpc

*** Variables ***

*** Test Cases ***

Test Iexec Oracle Truffle Tests On Testrpc
    [Documentation]  call truffle test on a started testrpc and show the result here.
    [Tags]  Smart contract Tests
    IexecOracle.Iexec Oracle Truffle Tests



