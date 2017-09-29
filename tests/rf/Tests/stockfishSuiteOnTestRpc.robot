*** Settings ***
Library  Dialogs
Documentation    End-to-End test Stockfish test
Resource  ../Resources/XWCommon.robot
Resource  ../Resources/XWServer.robot
Resource  ../Resources/IexecOracle.robot
Resource  ../Resources/IexecBridge.robot
Resource  ../Resources/ETHTestrpc.robot
Resource  ../Resources/cli/XWClient.robot
Resource  ../Resources/IexecSdkFromGithub.robot
Resource  ../Resources/bin/Stockfishbin.robot
Resource  ../Resources/smartcontracts/IexceOracleSmartContract.robot
Suite Setup  Prepare Stockfish Suite
Suite Teardown  End Stockfish Suite


# to launch tests : pybot -d Results ./tests/rf/Tests/stockfishSuiteOnTestRpc.robot

*** Variables ***
${wallet}
${IEXEC_ORACLE_SM_ADDRESS}
${IEXEC_ORACLE_ON_ROPSTEN} =  0x552075c9e40b050c8b61339b770e2a21e9014b3c
${STOCKFISH_PROCESS}

*** Test Cases ***

Test Stockfish On Local Geth
    [Documentation]  Test Stockfish Local Geth
    [Tags]  Stockfish Tests
    # 1) : deploy stockfish binary in XWtremweb
    ${bin} =  Stockfishbin.Get Stockfish Bin Path
    ${app_uid} =  XWClient.XWSENDAPPCommand  stockfish  DEPLOYABLE  LINUX  AMD64  ${bin}
    XWServer.Count From Apps Where Uid  ${app_uid}  1
    XWServer.Count From Works  0
    #Execute Manual Step  You can play chess at http://localhost:8000
    Sleep	20 minutes

*** Keywords ***

Prepare Stockfish Suite
    XWCommon.Prepare XWtremWeb Server And XWtremWeb Worker
    XWCommon.Begin XWtremWeb Command Test
    ETHTestrpc.Init And Start Testrpc
    IexecOracle.Init Oracle
    Stockfishbin.Compile Stockfish
    IexecSdkFromGithub.Init Sdk
    Prepare Iexec Stockfish
    IexecBridge.Init Bridge
    IexecBridge.Start Bridge


End Stockfish Suite
    IexecBridge.Stop Bridge
    ETHTestrpc.Stop Testrpc
    XWCommon.End XWtremWeb Command Test
    Terminate Process  ${STOCKFISH_PROCESS}
    ${stdout} =	Get Process Result	${STOCKFISH_PROCESS}  stdout=true
    Log  ${stdout}
    ${stderr} =	Get Process Result	${STOCKFISH_PROCESS}  stderr=true
    Log  ${stderr}

Prepare Iexec Stockfish
    ${rm_result} =  Run Process  rm -rf iexec-stockfish  shell=yes
    Should Be Empty	${rm_result.stderr}
    Should Be Equal As Integers	${rm_result.rc}	0
    IexecSdkFromGithub.Iexec Init An App  stockfish


    ##init wallet
    IexecSdkFromGithub.Iexec An App  iexec-stockfish  wallet create
    ${wallet_content} =  Get File  iexec-stockfish/wallet.json
    @{wallet_tmp} =  Get Regexp Matches  ${wallet_content}  "address": "(?P<wallet>.*)"  wallet
    ${wallet} =	Set Variable  @{wallet_tmp}[0]
    Log   ${wallet}
    ${wallet} =  Catenate  SEPARATOR=  0x  ${wallet}
    Log   ${wallet}
    ETHTestrpc.Get Balance Of  ${wallet}
    ETHTestrpc.Give Me Five  ${wallet}
    ETHTestrpc.Get Balance Of  ${wallet}

    ## target iexec oracle
    Run  sed -i 's/${IEXEC_ORACLE_ON_ROPSTEN}/${IEXEC_ORACLE_SM_ADDRESS}/g' iexec-stockfish/iexec.js

    IexecSdkFromGithub.Iexec An App  iexec-stockfish  migrate --network development

    # start front end
    ${result} =  Run Process  cd iexec-stockfish && npm install   shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers	${result.rc}	0
    ${created_process} =  Start Process  cd iexec-stockfish && ./buildAndDeploy.sh  shell=yes
    Set Suite Variable  ${STOCKFISH_PROCESS}  ${created_process}