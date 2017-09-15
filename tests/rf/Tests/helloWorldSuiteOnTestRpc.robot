*** Settings ***
Documentation    End-to-End test HelloWorld usecase Oracle+bridge+xtremweb
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


# to launch tests : pybot -d Results ./Tests/helloWorldSuiteOnTestRpc.robot
# Quicker for second launch :
# pybot --variable XW_FORCE_GIT_CLONE:false --variable IEXEC_BRIDGE_FORCE_GIT_CLONE:false --variable IEXEC_ORACLE_FORCE_GIT_CLONE:false -d Results ./Tests/helloWorldSuiteOnTestRpc.robot

*** Variables ***
${USER}
${CREATOR}


*** Test Cases ***

Test HelloWorld Submit Iexec On Testrpc
    [Documentation]  Test HelloWorld Submit Iexec On Testrpc
    [Tags]  HelloWorld Tests
    ${user} =  IexceOracleSmartContract.Get User Address
    Set Suite Variable  ${USER}  ${user}
    ${creator} =  IexceOracleSmartContract.Get Creator Address
    Set Suite Variable  ${CREATOR}  ${creator}

    # 1) : deploy /bin/echo binary in XWtremweb
    ${app_uid} =  XWClient.XWSENDAPPCommand  echo  DEPLOYABLE  LINUX  AMD64  /bin/echo
    XWServer.Count From Apps Where Uid  ${app_uid}  1
    XWServer.Count From Works  0

    # 2) : start a echo work
    IexecOracleAPIimplSmartContract.Submit  echo  HelloWorld!!!
    Check Submit Launch Event In IexceOracleSmartContract  ${HELLO_WORLD_SM_ADDRESS}
    ${index} =  Check Submit CallbackEvent Event In IexceOracleSmartContract  ${HELLO_WORLD_SM_ADDRESS}
    LOG  ${index}
    Check Submit CallbackEvent Event In IexecOracleAPIimplSmartContract  ${index}  ${HELLO_WORLD_SM_ADDRESS}
    Check Work Is Recorded in IexceOracleSmartContract After Submit  ${index}  ${HELLO_WORLD_SM_ADDRESS}
    # status 4 = COMPLETED
    ${work_status} =  IexceOracleSmartContract.Get Work Status  ${USER}  ${HELLO_WORLD_SM_ADDRESS}  ${index}
    Should Be Equal As Strings  ${work_status}  4
    ${workuid} =  IexceOracleSmartContract.Get Work Uid  ${USER}  ${HELLO_WORLD_SM_ADDRESS}  ${index}
    XWServer.Count From Works Where Uid  ${workuid}  1


    #better example ? : echo  hello | cat /etc/passwd | tr "[a-z]" "[A-Z]"


    # TODO check  HelloWorldSmartContract.RegisterEcho call twice
    # TODO add error usecase HelloWorld tests



*** Keywords ***

Start Oracle Bridge And Xtremweb
    XWCommon.Prepare And Start XWtremWeb Server And XWtremWeb Worker
    ETHTestrpc.Start Testrpc
    IexecOracle.Init Oracle
    IexecBridge.Init Bridge
    IexecBridge.Start Bridge


Stop Oracle Bridge And Xtremweb
    IexecBridge.Stop Bridge
    ETHTestrpc.Stop Testrpc
    XWCommon.Stop XWtremWeb Server And XWtremWeb Worker

