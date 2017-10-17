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
Suite Setup  XWCommon.Prepare XWtremWeb Server And XWtremWeb Worker
Test Setup  Hello World Test Setup
Test Teardown  Hello World Test Teardown




# to launch tests : pybot -d Results ./tests/rf/Tests/helloWorldSuiteOnLocalGeth.robot

*** Variables ***
${USER}
${PROVIDER}


*** Test Cases ***

Test HelloWorld Submit Iexec On Testrpc
    [Documentation]  Test HelloWorld Submit Iexec On Testrpc
    [Tags]  HelloWorld Tests
    ${user} =  IexceOracleSmartContract.Get User Address
    Set Suite Variable  ${USER}  ${user}
    ${provider} =  IexceOracleSmartContract.Get Provider Address
    Set Suite Variable  ${PROVIDER}  ${provider}

    # 1) : deploy /bin/echo binary in XWtremweb
    ${app_uid} =  XWClient.XWSENDAPPCommand  echo  DEPLOYABLE  LINUX  AMD64  /bin/echo
    XWServer.Count From Apps Where Uid  ${app_uid}  1
    XWServer.Count From Works  0

    # 2) : start a echo work
    ${submitTxHash} =  IexecOracleAPIimplSmartContract.Submit  echo  HelloWorld!!!
    IexceOracleSmartContract.Check Submit Event In IexceOracleSmartContract  ${HELLO_WORLD_SM_ADDRESS}  echo  HelloWorld!!!
    IexceOracleSmartContract.Check SubmitCallback Event In IexceOracleSmartContract  ${submitTxHash}  ${USER}  echo  HelloWorld!!!
    IexecOracleAPIimplSmartContract.Check IexecSubmitCallback Event In IexecOracleAPIimplSmartContract  ${submitTxHash}  ${USER}  echo  HelloWorld!!!
    IexceOracleSmartContract.Check Work Is Recorded in IexceOracleSmartContract After Submit  ${submitTxHash}  echo
    # status 4 = COMPLETED
    ${work_status} =  IexceOracleSmartContract.Get Work Status  ${submitTxHash}
    Should Be Equal As Strings  ${work_status}  4
    ${workuid} =  IexceOracleSmartContract.Get Work Uid  ${submitTxHash}
    XWServer.Count From Works Where Uid  ${workuid}  1

Test HelloWorld Submit Iexec On Testrpc With Json Format
    [Documentation]  Test HelloWorld Submit Iexec On Testrpc
    [Tags]  HelloWorld Tests
    ${user} =  IexceOracleSmartContract.Get User Address
    Set Suite Variable  ${USER}  ${user}
    ${provider} =  IexceOracleSmartContract.Get Provider Address
    Set Suite Variable  ${PROVIDER}  ${provider}

    # 1) : deploy /bin/echo binary in XWtremweb
    ${app_uid} =  XWClient.XWSENDAPPCommand  echo  DEPLOYABLE  LINUX  AMD64  /bin/echo
    XWServer.Count From Apps Where Uid  ${app_uid}  1
    XWServer.Count From Works  0

    # 2) : start a echo work
    ${submitTxHash} =  IexecOracleAPIimplSmartContract.Submit  echo  {\\"cmdLine\\":\\"HelloWorld!!!\\"}
    IexceOracleSmartContract.Check Submit Event In IexceOracleSmartContract  ${HELLO_WORLD_SM_ADDRESS}  echo  {"cmdLine":"HelloWorld!!!"}
    IexceOracleSmartContract.Check SubmitCallback Event In IexceOracleSmartContract  ${submitTxHash}  ${USER}  echo  HelloWorld!!!
    IexecOracleAPIimplSmartContract.Check IexecSubmitCallback Event In IexecOracleAPIimplSmartContract  ${submitTxHash}  ${USER}  echo  HelloWorld!!!
    IexceOracleSmartContract.Check Work Is Recorded in IexceOracleSmartContract After Submit  ${submitTxHash}  echo
    # status 4 = COMPLETED
    ${work_status} =  IexceOracleSmartContract.Get Work Status  ${submitTxHash}
    Should Be Equal As Strings  ${work_status}  4
    ${workuid} =  IexceOracleSmartContract.Get Work Uid  ${submitTxHash}
    XWServer.Count From Works Where Uid  ${workuid}  1

*** Keywords ***

Hello World Test Setup
    XWCommon.Begin XWtremWeb Command Test
    ETHGeth.Start Geth42
    IexecOracle.Init Oracle
    IexecBridge.Init Bridge
    IexecBridge.Start Bridge

Hello World Test Teardown
     XWCommon.End XWtremWeb Command Test
     ETHGeth.Stop Geth42
     IexecBridge.Stop Bridge






