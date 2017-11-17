*** Settings ***
Documentation    All smart contract tests on Local Geth Docker
Library  Process
Library  OperatingSystem
Library  String
Resource  ../Resources/IexecOracleDocker.robot
Resource  ../Resources/ETHGethDocker.robot
Resource  ../Resources/DockerHelper.robot
Suite Setup  Truffle Test Setup
Suite Teardown  Truffle Test Teardown


# to launch tests : pybot -d Results ./tests/rf/Tests/truffleTestsOnLocalGethDocker.robot


*** Variables ***

*** Test Cases ***

Test Iexec Oracle Truffle Tests On Local Geth
    [Documentation]  call truffle test on a started local geth and show the result here.
    [Tags]  Smart contract Tests
    IexecOracleDocker.Iexec Oracle Truffle Tests

*** Keywords ***

Truffle Test Setup
    DockerHelper.Remove All Images
    DockerHelper.Init Webproxy Network
    ETHGethDocker.Start Geth42
    IexecOracleDocker.Init Oracle

Truffle Test Teardown
    ETHGethDocker.Stop Geth42


