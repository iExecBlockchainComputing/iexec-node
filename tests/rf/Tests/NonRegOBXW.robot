*** Settings ***
Documentation    End-to-End test OBX = Oracle+bridge+xtremweb
Resource  ../Resources/XWCommon.robot
Resource  ../Resources/XWServer.robot
Resource  ../Resources/IexecOracleDocker.robot
Resource  ../Resources/IexecBridgeDocker.robot
Resource  ../Resources/cli/XWClient.robot
Resource  ../Resources/ETHGethDocker.robot
Resource  ../Resources/DockerHelper.robot
Resource  ../Resources/smartcontracts/IexecOracleAPIimplSmartContractDocker.robot
Resource  ../Resources/smartcontracts/IexceOracleSmartContractDocker.robot
Suite Setup  XWCommon.Prepare XWtremWeb Server And XWtremWeb Worker
Test Setup  OBX Test Setup
Test Teardown  OBX World Test Teardown


# to launch tests : pybot -d Results ./tests/rf/Tests/NonRegOBXW.robot

*** Variables ***
${USER}
${PROVIDER}
${ACCOUNT_0_PRIVATE_KEY}


*** Test Cases ***

Test HelloWorld Submit Iexec On Local Docker Geth
    [Documentation]  Test HelloWorld Submit Iexec On Local Docker Geth
    [Tags]  HelloWorld Tests
    ${user} =  IexceOracleSmartContractDocker.Get User Address
    Set Suite Variable  ${USER}  ${user}
    ${provider} =  IexceOracleSmartContractDocker.Get Provider Address
    Set Suite Variable  ${PROVIDER}  ${provider}

    # 1) : deploy /bin/echo binary in XWtremweb
    ${app_uid} =  XWClient.XWSENDAPPCommand  ${HELLO_WORLD_SM_ADDRESS}  DEPLOYABLE  LINUX  AMD64  /bin/echo
    XWServer.Count From Apps Where Uid  ${app_uid}  1
    XWServer.Count From Works  0

    ${stdout_datas} =  XWClient.XWDATASCommand
    @{uid} =  Get Regexp Matches  ${stdout_datas}  UID='(?P<uid>.*)', NAME=  uid
    ${data_curl_result} =  XWCommon.Curl To Server  get/@{uid}[0]
    Log  ${data_curl_result}
    ${stdout_apps} =  XWClient.XWAPPSCommand

    Log  ${stdout_apps}
    @{uid} =  Get Regexp Matches  ${stdout_apps}  UID='(?P<uid>.*)', NAME=  uid
    ${app_curl_result} =  XWCommon.Curl To Server  get/@{uid}[0]
    Log  ${app_curl_result}

    # 2) : start a echo work
    ${submitTxHash} =  IexecOracleAPIimplSmartContractDocker.Submit  HelloWorld!!!

    Wait Until Keyword Succeeds  3 min	5 sec  XWCommon.Check Work Completed By SubmitTxHash  ${submitTxHash}

    IexceOracleSmartContractDocker.Check Submit Event In IexceOracleSmartContract  ${HELLO_WORLD_SM_ADDRESS}  HelloWorld!!!
    ${app_curl_result} =  XWCommon.Curl To Server  getapps
    Log  ${app_curl_result}
    IexceOracleSmartContractDocker.Check SubmitCallback Event In IexceOracleSmartContract  ${submitTxHash}  ${USER}  HelloWorld!!!
    IexecOracleAPIimplSmartContractDocker.Check IexecSubmitCallback Event In IexecOracleAPIimplSmartContract  ${submitTxHash}  ${USER}  HelloWorld!!!
    IexceOracleSmartContractDocker.Check Work Is Recorded in IexceOracleSmartContract After Submit  ${submitTxHash}
    # status 4 = COMPLETED
    ${work_status} =  IexceOracleSmartContractDocker.Get Work Status  ${submitTxHash}
    Should Be Equal As Strings  ${work_status}  4


Test HelloWorld Submit Iexec On Local Docker Geth With Json Format
    [Documentation]  Test HelloWorld Submit Iexec On Local Docker Geth
    [Tags]  HelloWorld Tests
    ${user} =  IexceOracleSmartContractDocker.Get User Address
    Set Suite Variable  ${USER}  ${user}
    ${provider} =  IexceOracleSmartContractDocker.Get Provider Address
    Set Suite Variable  ${PROVIDER}  ${provider}

    # 1) : deploy /bin/echo binary in XWtremweb
    ${app_uid} =  XWClient.XWSENDAPPCommand  ${HELLO_WORLD_SM_ADDRESS}  DEPLOYABLE  LINUX  AMD64  /bin/echo
    XWServer.Count From Apps Where Uid  ${app_uid}  1
    XWServer.Count From Works  0

    ${stdout_datas} =  XWClient.XWDATASCommand
    @{uid} =  Get Regexp Matches  ${stdout_datas}  UID='(?P<uid>.*)', NAME=  uid
    ${data_curl_result} =  XWCommon.Curl To Server  get/@{uid}[0]
    Log  ${data_curl_result}
    ${stdout_apps} =  XWClient.XWAPPSCommand

    Log  ${stdout_apps}
    @{uid} =  Get Regexp Matches  ${stdout_apps}  UID='(?P<uid>.*)', NAME=  uid
    ${app_curl_result} =  XWCommon.Curl To Server  get/@{uid}[0]
    Log  ${app_curl_result}

    # 2) : start a echo work
    ${submitTxHash} =  IexecOracleAPIimplSmartContractDocker.Submit  {\\"cmdLine\\":\\"HelloWorld!!!\\"}

    Wait Until Keyword Succeeds  3 min	5 sec  XWCommon.Check Work Completed By SubmitTxHash  ${submitTxHash}

    IexceOracleSmartContractDocker.Check Submit Event In IexceOracleSmartContract  ${HELLO_WORLD_SM_ADDRESS}  {"cmdLine":"HelloWorld!!!"}
    ${app_curl_result} =  XWCommon.Curl To Server  getapps
    Log  ${app_curl_result}
    IexceOracleSmartContractDocker.Check SubmitCallback Event In IexceOracleSmartContract  ${submitTxHash}  ${USER}  HelloWorld!!!
    IexecOracleAPIimplSmartContractDocker.Check IexecSubmitCallback Event In IexecOracleAPIimplSmartContract  ${submitTxHash}  ${USER}  HelloWorld!!!
    IexceOracleSmartContractDocker.Check Work Is Recorded in IexceOracleSmartContract After Submit  ${submitTxHash}
    # status 4 = COMPLETED
    ${work_status} =  IexceOracleSmartContractDocker.Get Work Status  ${submitTxHash}
    Should Be Equal As Strings  ${work_status}  4

*** Keywords ***

OBX Test Setup
    DockerHelper.Stop And Remove All Containers
    DockerHelper.Init Webproxy Network
    XWCommon.Begin XWtremWeb Command Test
    IexecOracleDocker.Init Oracle Docker
    IexecBridgeDocker.Init Bridge
    ETHGethDocker.Start Geth42
    IexecOracleDocker.Iexec Oracle Truffle Migrate Docker
    IexecBridgeDocker.Start Bridge

OBX World Test Teardown
     XWCommon.End XWtremWeb Command Test
     ETHGethDocker.Stop Geth42
     IexecBridgeDocker.Stop Bridge
