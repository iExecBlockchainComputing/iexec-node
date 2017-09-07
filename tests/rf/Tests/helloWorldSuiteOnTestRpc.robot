*** Settings ***
Documentation    End-to-End test HelloWorld usacase Oracle+bridge+xtremweb
Resource  ../Resources/XWCommon.robot
Resource  ../Resources/XWServer.robot
Resource  ../Resources/IexecOracle.robot
Resource  ../Resources/ETHTestrpc.robot
Resource  ../Resources/cli/XWClient.robot
Resource  ../Resources/smartcontracts/HelloWorldSmartContract.robot
Resource  ../Resources/smartcontracts/IexceOracleSmartContract.robot
Suite Setup  Start Oracle Bridge And Xtremweb
Suite Teardown  Stop Oracle Bridge And Xtremweb


# to launch tests : pybot -d Results ./Tests/helloWorldSuiteOnTestRpc.robot
# Quicker for second launch :
# pybot --variable XW_FORCE_GIT_CLONE:false --variable IEXEC_ORACLE_FORCE_GIT_CLONE:false -d Results ./Tests/helloWorldSuiteOnTestRpc.robot

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
    # 1 : deploy /bin/echo binary in XWtremweb
    ${app_uid} =  XWClient.XWSENDAPPCommand  echo  DEPLOYABLE  LINUX  AMD64  /bin/echo
    XWServer.Count From Apps Where Uid  ${app_uid}  1
    # 2 : start a echo work
    HelloWorldSmartContract.RegisterEcho
    Check Register Launch Event In IexceOracleSmartContract
    ${work_uid} =  Check Register CallbackEvent Event In IexceOracleSmartContract
    LOG  ${work_uid}
    Check Work Is Recorded in IexceOracleSmartContract After Register  ${work_uid}
    # 3 : set Param HelloWorld!!! for the  work
    HelloWorldSmartContract.SetParamHelloWorld  ${work_uid}  HelloWorld!!!
    Check SetParam Launch Event In IexceOracleSmartContract  ${work_uid}
    IexecOracle.Get Bridge Log
    Check SetParam CallbackEvent Event In IexceOracleSmartContract
    # 4 : Work configured : change work status in order to be treat by a worker
    #HelloWorldSmartContract.Set Pending
    # 5 : Wait completed by checking status
    #HelloWorldSmartContract.Get status
    # 6 : get the result of the echo HelloWorld!!!
    #HelloWorldSmartContract.Get Result






    # ???? Failed :  XWServer.Count From Works Where Uid  @{work_uid}[0]  1
    # ???? Failed : XWClient.Check XWSTATUS Pending  xw://vagrant-ubuntu-trusty-64/@{work_uid}[0]



*** Keywords ***

Start Oracle Bridge And Xtremweb
    XWCommon.Prepare And Start XWtremWeb Server And XWtremWeb Worker
    ETHTestrpc.Start Testrpc
    IexecOracle.Iexec Oracle Truffle Migrate
    IexecOracle.Iexec Oracle Set Contract Address In Bridge
    IexecOracle.Iexec Oracle Set XtremWeb Config In Bridge
    IexecOracle.Start Bridge


Stop Oracle Bridge And Xtremweb
    IexecOracle.Stop Bridge
    ETHTestrpc.Stop Testrpc
    XWCommon.Stop XWtremWeb Server And XWtremWeb Worker

Check SetParam Launch Event In IexceOracleSmartContract
    [Arguments]  ${work_uid}
    ${watch_launch_event} =  Wait Until Keyword Succeeds  1 min	10 sec  IexceOracleSmartContract.Watch LaunchEvent
    Should Contain  ${watch_launch_event}  functionName: 'setParam'
    Should Contain  ${watch_launch_event}  param2: 'HelloWorld!!!'
    Should Contain  ${watch_launch_event}  user: '${USER}'
    Should Contain  ${watch_launch_event}  creator: '${CREATOR}'
    Should Contain  ${watch_launch_event}  provider: '${HELLO_WORLD_SM_ADDRESS}'
    Should Contain  ${watch_launch_event}  uid: '${work_uid}'

Check Register Launch Event In IexceOracleSmartContract
    ${watch_launch_event} =  Wait Until Keyword Succeeds  1 min	10 sec  IexceOracleSmartContract.Watch LaunchEvent
    Should Contain  ${watch_launch_event}  functionName: 'register'
    Should Contain  ${watch_launch_event}  param1: 'echo'
    Should Contain  ${watch_launch_event}  user: '${USER}'
    Should Contain  ${watch_launch_event}  creator: '${CREATOR}'
    Should Contain  ${watch_launch_event}  provider: '${HELLO_WORLD_SM_ADDRESS}'

Check Register CallbackEvent Event In IexceOracleSmartContract
    ${watch_callback_event} =  Wait Until Keyword Succeeds  1 min	10 sec  IexceOracleSmartContract.Watch CallbackEvent
    Should Contain  ${watch_callback_event}  callbackType: 'RegisterCallback'
    Should Contain  ${watch_callback_event}  appName: 'echo'
    Should Contain  ${watch_callback_event}  user: '${USER}'
    Should Contain  ${watch_callback_event}  creator: '${CREATOR}'
    Should Contain  ${watch_callback_event}  provider: '${HELLO_WORLD_SM_ADDRESS}'
    @{work_uid} =  Get Regexp Matches  ${watch_callback_event}  uid: '(?P<work_uid>.*)',  work_uid
    [Return]  @{work_uid}[0]

Check SetParam CallbackEvent Event In IexceOracleSmartContract
    ${watch_callback_event} =  Wait Until Keyword Succeeds  1 min	10 sec  IexceOracleSmartContract.Watch CallbackEvent
    Should Contain  ${watch_callback_event}  callbackType: 'SetParamCallback'
    Should Contain  ${watch_callback_event}  appName: 'echo'
    Should Contain  ${watch_callback_event}  user: '${USER}'
    Should Contain  ${watch_callback_event}  creator: '${CREATOR}'
    Should Contain  ${watch_callback_event}  provider: '${HELLO_WORLD_SM_ADDRESS}'

Check Work Is Recorded in IexceOracleSmartContract After Register
    [Arguments]  ${work_uid}
    @{work_result} =  IexceOracleSmartContract.Get Work  ${USER}  ${HELLO_WORLD_SM_ADDRESS}  ${work_uid}
    ${work_name} =  IexceOracleSmartContract.Get Work Name  ${USER}  ${HELLO_WORLD_SM_ADDRESS}  ${work_uid}
    Should Be Equal As Strings  ${work_name}  @{work_result}[0]
    Should Be Equal As Strings  ${work_name}  echo
    ${work_timestamp} =  IexceOracleSmartContract.Get Work Timestamp  ${USER}  ${HELLO_WORLD_SM_ADDRESS}  ${work_uid}
    Should Be Equal As Strings  ${work_timestamp}  @{work_result}[1]
    ${work_status} =  IexceOracleSmartContract.Get Work Status  ${USER}  ${HELLO_WORLD_SM_ADDRESS}  ${work_uid}
    Should Be Equal As Strings  ${work_status}  @{work_result}[2]
    # status 1 = UNAVAILABLE
    Should Be Equal As Strings  ${work_status}  1
    ${work_stdout} =  IexceOracleSmartContract.Get Work Stdout  ${USER}  ${HELLO_WORLD_SM_ADDRESS}  ${work_uid}
    Should Be Equal As Strings  ${work_stdout}  @{work_result}[3]
    Should Be Empty  ${work_stdout}
    ${work_stderr} =  IexceOracleSmartContract.Get Work Stderr  ${USER}  ${HELLO_WORLD_SM_ADDRESS}  ${work_uid}
    Should Be Equal As Strings  ${work_stderr}  @{work_result}[4]
    Should Be Empty  ${work_stderr}

