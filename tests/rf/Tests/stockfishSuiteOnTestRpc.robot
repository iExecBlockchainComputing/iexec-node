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
${IEXEC_ORACLE_ON_KOVAN} =  0x77040475d5cf05e9dd44f96d7dab3b7da7adbc6a
${STOCKFISH_PROCESS}

*** Test Cases ***

Test Stockfish On Test Rpc
    [Documentation]  Test Stockfish On Test Rpc
    [Tags]  Stockfish Tests
    # 1) : deploy stockfish binary in XWtremweb
    ${bin} =  Stockfishbin.Get Stockfish Bin Path
    ${app_uid} =  XWClient.XWSENDAPPCommand  stockfish  DEPLOYABLE  LINUX  AMD64  ${bin}
    XWServer.Count From Apps Where Uid  ${app_uid}  1
    XWServer.Count From Works  0
    IexecSdkFromGithub.Iexec An App  iexec-stockfish  migrate --network development
    #{\\"cmdLine\\":\\"a2a4\\"}
    ${iexec_result.stdout} =  IexecSdkFromGithub.Iexec An App  iexec-stockfish  submit stockfish '{"stdin":"position startpos moves e2e4 \\n go"}' --network development
    @{transactionHash} =  Get Regexp Matches  ${iexec_result.stdout}  View on etherscan: https://development.etherscan.io/tx/(?P<transactionHash>.*)  transactionHash
    Log  @{transactionHash}
    Wait Until Keyword Succeeds  2 min	30 sec  Check Stockfish Status In Result  @{transactionHash}[0]  --network development



*** Keywords ***
Check Stockfish Status In Result
    [Arguments]  ${transactionHash}  ${network}
    ${stdout} =  IexecSdkFromGithub.Iexec An App  iexec-stockfish  result ${transactionHash} ${network}
    ${lines} =  Get Lines Containing String  ${stdout}  stockfish
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1



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
    Run  sed -i 's/LOCAL_ORACLE_ADDRESS_VALUE/${IEXEC_ORACLE_SM_ADDRESS}/g' iexec-stockfish/truffle.js
    Run  sed -i 's/${IEXEC_ORACLE_ON_KOVAN}/${IEXEC_ORACLE_SM_ADDRESS}/g' iexec-stockfish/node_modules/iexec-oracle-contract/build/contracts/IexecOracle.json
    Run  sed -i 's/${IEXEC_ORACLE_ON_KOVAN}/${IEXEC_ORACLE_SM_ADDRESS}/g' iexec-sdk/node_modules/iexec-oracle-contract/build/contracts/IexecOracle.json

    # start front end
    ${result} =  Run Process  cd iexec-stockfish && npm install   shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers	${result.rc}	0

    ${created_process} =  Start Process  cd iexec-stockfish && ./buildAndDeploy.sh  shell=yes
    Set Suite Variable  ${STOCKFISH_PROCESS}  ${created_process}