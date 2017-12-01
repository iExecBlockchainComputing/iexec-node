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
    IexecOracleDocker.Iexec Oracle Truffle Tests Docker

*** Keywords ***

Truffle Test Setup
    DockerHelper.Stop And Remove All Containers
    DockerHelper.Init Webproxy Network
    IexecOracleDocker.Init Oracle Docker
    ETHGethDocker.Start Geth42


Truffle Test Teardown
    ETHGethDocker.Stop Geth42


