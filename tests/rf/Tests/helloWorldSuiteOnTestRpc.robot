*** Settings ***
Documentation    End-to-End test HelloWorld usacase Oracle+bridge+xtremweb
Resource  ../Resources/XWCommon.robot
Resource  ../Resources/XWServer.robot
Resource  ../Resources/IexecOracle.robot
Resource  ../Resources/ETHTestrpc.robot
Suite Setup  Start Oracle Bridge And Xtremweb
Suite Teardown  Stop Oracle Bridge And Xtremweb


# to launch tests : pybot -d Results ./Tests/helloWorldSuiteOnTestRpc.robot
# Quicker for second launch :
# pybot --variable XW_FORCE_GIT_CLONE:false --variable IEXEC_ORACLE_FORCE_GIT_CLONE:false -d Results ./Tests/helloWorldSuiteOnTestRpc.robot
*** Variables ***


*** Test Cases ***

Test Register HelloWorld
    [Documentation]  Test Register HelloWorld
    [Tags]  HelloWorld Tests
    LOG  TODO

*** Keywords ***

Start Oracle Bridge And Xtremweb
    XWCommon.Prepare And Start XWtremWeb Server And XWtremWeb Worker
    ETHTestrpc.Start Testrpc
    IexecOracle.Iexec Oracle Truffle Migrate
    IexecOracle.Iexec Oracle Set XtremWeb Config In Bridge
    IexecOracle.Start Bridge


Stop Oracle Bridge And Xtremweb
    IexecOracle.Stop Bridge
    ETHTestrpc.Stop Testrpc
    XWCommon.Stop XWtremWeb Server And XWtremWeb Worker
