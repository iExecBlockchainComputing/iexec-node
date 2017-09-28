*** Settings ***
Documentation    End-to-End test HelloWorld usecase Oracle+bridge+xtremweb
Resource  ../Resources/XWCommon.robot
Resource  ../Resources/XWServer.robot
Resource  ../Resources/IexecOracle.robot
Resource  ../Resources/IexecBridge.robot
Resource  ../Resources/cli/XWClient.robot
Resource  ../Resources/ETHGeth.robot
Resource  ../Resources/smartcontracts/IexecOracleAPIimplSmartContract.robot
Resource  ../Resources/smartcontracts/IexceOracleSmartContract.robot
Suite Setup  Start Oracle Bridge And Xtremweb
Suite Teardown  Stop Oracle Bridge And Xtremweb



# to launch tests : pybot -d Results ./tests/rf/Tests/helloWorldSuiteOnLocalGeth.robot

*** Variables ***
${USER}
${CREATOR}


*** Test Cases ***
Test HelloWorld Submit Iexec On Local Geth
    [Documentation]  Test HelloWorld Submit Iexec
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
    ${submitTxHash} =  IexecOracleAPIimplSmartContract.Submit  echo  HelloWorld!!!
    IexceOracleSmartContract.Check Submit Event In IexceOracleSmartContract  ${HELLO_WORLD_SM_ADDRESS}  echo  HelloWorld!!!
    IexceOracleSmartContract.Check SubmitCallback Event In IexceOracleSmartContract  ${submitTxHash}  ${USER}  echo  HelloWorld!!!
    IexecOracleAPIimplSmartContract.Check IexecSubmitCallback Event In IexecOracleAPIimplSmartContract  ${submitTxHash}  ${USER}  echo  HelloWorld!!!
    IexceOracleSmartContract.Check Work Is Recorded in IexceOracleSmartContract After Submit  ${submitTxHash}  ${HELLO_WORLD_SM_ADDRESS}  echo
    # status 4 = COMPLETED
    ${work_status} =  IexceOracleSmartContract.Get Work Status  ${submitTxHash}
    Should Be Equal As Strings  ${work_status}  4
    ${workuid} =  IexceOracleSmartContract.Get Work Uid  ${submitTxHash}
    XWServer.Count From Works Where Uid  ${workuid}  1

*** Keywords ***

Start Oracle Bridge And Xtremweb
    XWCommon.Prepare XWtremWeb Server And XWtremWeb Worker
    XWCommon.Begin XWtremWeb Command Test
    ETHGeth.Start Geth42
    IexecOracle.Init Oracle
    IexecBridge.Init Bridge
    IexecBridge.Start Bridge


Stop Oracle Bridge And Xtremweb
    IexecBridge.Stop Bridge
    ETHGeth.Stop Geth42
    XWCommon.End XWtremWeb Command Test




