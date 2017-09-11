*** Settings ***
Documentation    End-to-End test HelloWorld usecase Oracle+bridge+xtremweb
Resource  ../Resources/XWCommon.robot
Resource  ../Resources/XWServer.robot
Resource  ../Resources/IexecOracle.robot
Resource  ../Resources/cli/XWClient.robot
Resource  ../Resources/ETHGeth.robot
Resource  ../Resources/smartcontracts/HelloWorldSmartContract.robot
Resource  ../Resources/smartcontracts/IexceOracleSmartContract.robot
Suite Setup  Start Oracle Bridge And Xtremweb
Suite Teardown  Stop Oracle Bridge And Xtremweb


# to launch tests : pybot -d Results ./Tests/helloWorldSuiteOnLocalGeth.robot
# Quicker for second launch :
# pybot --variable XW_FORCE_GIT_CLONE:false --variable IEXEC_ORACLE_FORCE_GIT_CLONE:false -d Results ./Tests/helloWorldSuiteOnLocalGeth.robot

*** Variables ***
${USER}
${CREATOR}


*** Test Cases ***

Test HelloWorld Iexec
    [Documentation]  Test HelloWorld Iexec
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
    HelloWorldSmartContract.SubmitEcho  HelloWorld!!!
    IexecOracle.Get Bridge Log
    Check Submit Launch Event In IexceOracleSmartContract  ${HELLO_WORLD_SM_ADDRESS}
    ${work_uid} =  Check Submit CallbackEvent Event In IexceOracleSmartContract  ${HELLO_WORLD_SM_ADDRESS}
    LOG  ${work_uid}
    Check Submit CallbackEvent Event In HelloWorldSmartContract  ${work_uid}  ${HELLO_WORLD_SM_ADDRESS}
    Check Work Is Recorded in IexceOracleSmartContract After Register  ${work_uid}  ${HELLO_WORLD_SM_ADDRESS}
    # status 2 = PENDING
    ${work_status} =  IexceOracleSmartContract.Get Work Status  ${USER}  ${HELLO_WORLD_SM_ADDRESS}  ${work_uid}
    Should Be Equal As Strings  ${work_status}  2
    XWServer.Count From Works Where Uid  ${work_uid}  1

    # 3) : Wait completed by checking status
    Wait Until Keyword Succeeds  3 min	5 sec  XWClient.Check XWSTATUS Completed  ${work_uid}
    HelloWorldSmartContract.Get Status  ${work_uid}
    Check Status Launch Event In IexceOracleSmartContract  ${work_uid}  ${HELLO_WORLD_SM_ADDRESS}
    Check Status CallbackEvent Event In IexceOracleSmartContract  ${work_uid}  ${HELLO_WORLD_SM_ADDRESS}
    Check Status CallbackEvent Event In HelloWorldSmartContract  ${work_uid}  ${HELLO_WORLD_SM_ADDRESS}
    ${work_status} =  IexceOracleSmartContract.Get Work Status  ${USER}  ${HELLO_WORLD_SM_ADDRESS}  ${work_uid}
    # status 4 = COMPLETED
    Should Be Equal As Strings  ${work_status}  4

    # 4) : get the result of the echo HelloWorld!!!
    HelloWorldSmartContract.Get Result  ${work_uid}
    Check Result Launch Event In IexceOracleSmartContract  ${work_uid}  ${HELLO_WORLD_SM_ADDRESS}
    Check Result CallbackEvent Event In IexceOracleSmartContract  ${work_uid}  ${HELLO_WORLD_SM_ADDRESS}
    Check Result CallbackEvent Event In HelloWorldSmartContract  ${work_uid}  ${HELLO_WORLD_SM_ADDRESS}
    ${work_stdout} =  IexceOracleSmartContract.Get Work Stdout  ${USER}  ${HELLO_WORLD_SM_ADDRESS}  ${work_uid}
    Should Be Equal As Strings  ${work_stdout}  HelloWorld!!!

*** Keywords ***

Start Oracle Bridge And Xtremweb
    XWCommon.Prepare And Start XWtremWeb Server And XWtremWeb Worker
    ETHGeth.Start Geth42
    IexecOracle.Iexec Oracle Truffle Migrate
    IexecOracle.Iexec Oracle Set Contract Address In Bridge
    IexecOracle.Iexec Oracle Set XtremWeb Config In Bridge
    IexecOracle.Start Bridge


Stop Oracle Bridge And Xtremweb
    IexecOracle.Stop Bridge
    ETHGeth.Stop Geth42
    XWCommon.Stop XWtremWeb Server And XWtremWeb Worker




