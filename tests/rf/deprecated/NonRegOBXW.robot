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
    #${app_uid} =  XWClient.XWSENDAPPCommand  ${HELLO_WORLD_SM_ADDRESS} DEPLOYABLE LINUX AMD64 /bin/echo

    # 1.1 : create user and provider in xw
    XWClient.XWSENDUSERCommand  ${USER} nopass1 noemail1
    ${xwusers} =  XWUSERSCommand
    Should Contain	${xwusers}	LOGIN='${USER}'

    XWClient.XWSENDUSERCommand  ${PROVIDER} nopass2 noemail2
    ${xwusers} =  XWUSERSCommand
    Should Contain	${xwusers}	LOGIN='${PROVIDER}'
    @{dapp_provider_uid} =  Get Regexp Matches  ${xwusers}  UID='(?P<useruid>.*)', LOGIN='${PROVIDER}'  useruid

    # 1.2 : deploy as provider and set stickybit in app in xw
    # ADD MANDATINGLOGIN to the DAPP PROVIDER
    XWCommon.Set MANDATINGLOGIN in Xtremweb Xlient Conf  ${DIST_XWHEP_PATH}  ${PROVIDER}

    # deployed DAPP in the name of DAPP PROVIDER
    ${app_uid} =  XWClient.XWSENDAPPCommand  ${HELLO_WORLD_SM_ADDRESS} DEPLOYABLE LINUX AMD64 /bin/echo
    ${curl_result} =  XWCommon.Curl To Server  get/${app_uid}
    # we find dapp_provider as owner in the dapo description
    Should Contain	${curl_result}  @{dapp_provider_uid}[0]

    ################## A PRIVATE APP ##################
    Should Contain	${curl_result}  0x700
    ########################################

    # UPDATE DAPP to 0x1700 rights
    XWCommon.Remove MANDATINGLOGIN in Xtremweb Xlient Conf  ${DIST_XWHEP_PATH}
    XWClient.XWCMODCommand  0x1700  ${app_uid}

    ${curl_result} =  XWCommon.Curl To Server  get/${app_uid}
    # we find dapp_provider as owner in the dapo description
    Should Contain	${curl_result}  @{dapp_provider_uid}[0]

    ################## we have now a Private with stickybit.  ##################
    Should Contain	${curl_result}  0x1700
    ########################################


    XWCommon.Remove MANDATINGLOGIN in Xtremweb Xlient Conf  ${DIST_XWHEP_PATH}

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

    @{work_result} =  IexceOracleSmartContractDocker.Check Work Is Recorded in IexceOracleSmartContract After Submit  ${submitTxHash}

    IexceOracleSmartContractDocker.Check SubmitCallback Event In IexceOracleSmartContract  ${submitTxHash}  ${USER}  HelloWorld!!!  @{work_result}[4]
    IexecOracleAPIimplSmartContractDocker.Check IexecSubmitCallback Event In IexecOracleAPIimplSmartContract  ${submitTxHash}  ${USER}  HelloWorld!!!  @{work_result}[4]

    # status 4 = COMPLETED  394fa1df-1d99-4ea3-864a-940120e26c50
    Should Be Equal As Strings  @{work_result}[1]  4

    Log  @{work_result}[4]

    # check result as admin
    ${results_file} =  XWRESULTSCommand  @{work_result}[4]
    Log  ${results_file}
    ${results_file_content} =  Get File  ${results_file}
    Log  ${results_file_content}


    # check result as user
    XWCommon.Set MANDATINGLOGIN in Xtremweb Xlient Conf  ${DIST_XWHEP_PATH}  ${USER}

    ${results_file} =  XWRESULTSCommand  @{work_result}[4]
    Log  ${results_file}
    ${results_file_content} =  Get File  ${results_file}
    Log  ${results_file_content}


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
