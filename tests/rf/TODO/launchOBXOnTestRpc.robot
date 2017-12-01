*** Settings ***
Documentation    Start Xtremweb Bridge And Oracle And Use Testrpc
Library  Dialogs
Resource  ../Resources/XWCommon.robot
Resource  ../Resources/XWServer.robot
Resource  ../Resources/IexecOracle.robot
Resource  ../Resources/IexecBridge.robot
Resource  ../Resources/ETHTestrpc.robot
Resource  ../Resources/cli/XWClient.robot
Resource  ../Resources/smartcontracts/IexecOracleAPIimplSmartContract.robot
Resource  ../Resources/smartcontracts/IexceOracleSmartContract.robot
Suite Setup  Start Oracle Bridge And Xtremweb
Suite Teardown  Stop Oracle Bridge And Xtremweb


# to launch tests : pybot -d Results ./tests/rf/Tests/launchOBXOnTestRpc.robot

*** Variables ***



*** Test Cases ***

Test Start Xtremweb Bridge And Oracle And Use Testrpc
    [Documentation]  Start Xtremweb Bridge And Oracle And Use Testrpc
    [Tags]  Manual Tests
    Log  Xtremweb Bridge And Oracle And Use Testrpc
    Wait Until Keyword Succeeds  1440 min  60 min  Never Success


*** Keywords ***

Never Success
    Should Be Equal As Strings  OK  KO

Start Oracle Bridge And Xtremweb
    XWCommon.Prepare XWtremWeb Server And XWtremWeb Worker
    XWCommon.Begin XWtremWeb Command Test
    ETHTestrpc.Init And Start Testrpc
    IexecOracle.Init Oracle
    IexecBridge.Init Bridge
    IexecBridge.Start Bridge


Stop Oracle Bridge And Xtremweb
    IexecBridge.Stop Bridge
    ETHTestrpc.Stop Testrpc
    XWCommon.End XWtremWeb Command Test

