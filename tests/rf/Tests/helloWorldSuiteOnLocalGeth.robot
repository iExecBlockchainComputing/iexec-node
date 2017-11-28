*** Settings ***
Documentation    End-to-End test HelloWorld usecase Oracle+bridge+xtremweb
Resource  ../Resources/XWCommon.robot
Resource  ../Resources/XWServer.robot
Resource  ../Resources/IexecOracleDocker.robot
Resource  ../Resources/IexecBridgeDocker.robot
Resource  ../Resources/cli/XWClient.robot
Resource  ../Resources/ETHGethDocker.robot
Resource  ../Resources/DockerHelper.robot
Resource  ../Resources/IexecSdkFromGithub.robot
Resource  ../Resources/smartcontracts/IexecOracleAPIimplSmartContractDocker.robot
Resource  ../Resources/smartcontracts/IexceOracleSmartContractDocker.robot
Suite Setup  XWCommon.Prepare XWtremWeb Server And XWtremWeb Worker
Test Setup  Hello World Test Setup
Test Teardown  Hello World Test Teardown




# to launch tests : pybot -d Results ./tests/rf/Tests/helloWorldSuiteOnLocalGeth.robot

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

    #IexecSdkFromGithub.Iexec An App  iexec-ls  apps deploy ${HELLO_WORLD_SM_ADDRESS}
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
    IexceOracleSmartContractDocker.Check Submit Event In IexceOracleSmartContract  ${HELLO_WORLD_SM_ADDRESS}  HelloWorld!!!
    ${app_curl_result} =  XWCommon.Curl To Server  getapps
    Log  ${app_curl_result}
    IexceOracleSmartContractDocker.Check SubmitCallback Event In IexceOracleSmartContract  ${submitTxHash}  ${USER}  HelloWorld!!!
    IexecOracleAPIimplSmartContractDocker.Check IexecSubmitCallback Event In IexecOracleAPIimplSmartContract  ${submitTxHash}  ${USER}  HelloWorld!!!
    IexceOracleSmartContract.Check Work Is Recorded in IexceOracleSmartContract After Submit  ${submitTxHash}
    # status 4 = COMPLETED
    ${work_status} =  IexceOracleSmartContract.Get Work Status  ${submitTxHash}
    Should Be Equal As Strings  ${work_status}  4


*** Keywords ***

Hello World Test Setup
    DockerHelper.Stop And Remove All Containers
    DockerHelper.Init Webproxy Network
    XWCommon.Begin XWtremWeb Command Test
    ETHGethDocker.Start Geth42
    IexecOracleDocker.Init Oracle
    IexecBridgeDocker.Init Bridge
    IexecBridgeDocker.Start Bridge
    #IexecSdkFromGithub.Init Sdk
    #Prepare Iexec Ls

Hello World Test Teardown
     XWCommon.End XWtremWeb Command Test
     ETHGethDocker.Stop Geth42
     IexecBridgeDocker.Stop Bridge




Prepare Iexec Ls
    ${rm_result} =  Run Process  rm -rf iexec-ls  shell=yes
    Should Be Empty	${rm_result.stderr}
    Should Be Equal As Integers	${rm_result.rc}	0
    IexecSdkFromGithub.Iexec Init An App  ls
    ##init wallet
    IexecSdkFromGithub.Iexec An App  iexec-ls  wallet create
    ${wallet_content} =  Get File  iexec-ls/wallet.json
    Log  ${ACCOUNT_0_PRIVATE_KEY}
    Run  sed -i 's/.*"privateKey": ".*/"privateKey": "${ACCOUNT_0_PRIVATE_KEY}",/g' iexec-ls/wallet.json
    Log File  iexec-ls/wallet.json


