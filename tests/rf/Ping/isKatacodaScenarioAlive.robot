*** Settings ***
Documentation    Launch katacoda scenario on ropsten, kovan and rinkeby. to check all test chain ok
Resource  ../Resources/IexecSdk.robot
Library           OperatingSystem
Library           ArchiveLibrary
Suite Setup  Init Ping Katacoda


# to launch tests :
# pybot --variable PKEY:aprivatekey -v LAUNCHED_IN_CONTAINER:true -d Results ./tests/rf/Ping/isKatacodaScenarioAlive.robot

*** Variables ***
${PKEY}
${REPO_DIR} =  ${CURDIR}/../repo


*** Test Cases ***


Test Deploy And Submit Katacoda Factorial Scenario On Kovan
    [Documentation]  Test Katacoda Hello World Scenario On Kovan
    [Tags]  Katacoda
    Prepare Iexec Factorial
    IexecSdk.Iexec An App  iexec-factorial  account allow 1 --network kovan
    IexecSdk.Iexec An App  iexec-factorial  wallet getRLC --network kovan
    IexecSdk.Iexec An App  iexec-factorial  account login --network kovan
    IexecSdk.Iexec An App  iexec-factorial  deploy --network kovan
    IexecSdk.Iexec An App  iexec-factorial  submit 10 --network kovan
    ${iexec_result} =  IexecSdk.Get Iexec Sdk Log
    @{transactionHash} =  Get Regexp Matches  ${iexec_result}  "transactionHash": "(?P<transactionHash>.*)",  transactionHash
    Wait Until Keyword Succeeds  5 min	30 sec  Check Factorial 10 In Result  @{transactionHash}[0]  --network kovan


Test Submit Katacoda Factorial Scenario On Kovan
    [Documentation]  Test Katacoda Hello World Scenario On Kovan
    [Tags]  Katacoda
    Prepare Iexec Factorial
    IexecSdk.Iexec An App  iexec-factorial  account allow 1 --network kovan
    IexecSdk.Iexec An App  iexec-factorial  wallet getRLC --network kovan
    IexecSdk.Iexec An App  iexec-factorial  account login --network kovan
    IexecSdk.Iexec An App  iexec-factorial  submit 10 --network kovan
    ${iexec_result} =  IexecSdk.Get Iexec Sdk Log
    @{transactionHash} =  Get Regexp Matches  ${iexec_result}  "transactionHash": "(?P<transactionHash>.*)",  transactionHash
    Wait Until Keyword Succeeds  5 min	30 sec  Check Factorial 10 In Result  @{transactionHash}[0]  --network kovan


Test Deploy And Submit Katacoda Factorial Scenario On Ropsten
    [Documentation]  Test Katacoda Hello World Scenario On Ropsten
    [Tags]  Katacoda
    Prepare Iexec Factorial
    IexecSdk.Iexec An App  iexec-factorial  account allow 1
    IexecSdk.Iexec An App  iexec-factorial  wallet getRLC
    IexecSdk.Iexec An App  iexec-factorial  account login
    IexecSdk.Iexec An App  iexec-factorial  deploy
    IexecSdk.Iexec An App  iexec-factorial  submit 10
    ${iexec_result} =  IexecSdk.Get Iexec Sdk Log
    @{transactionHash} =  Get Regexp Matches  ${iexec_result}  "transactionHash": "(?P<transactionHash>.*)",  transactionHash
    Wait Until Keyword Succeeds  10 min	30 sec  Check Factorial 10 In Result  @{transactionHash}[0]  --network ropsten

Test Submit Katacoda Factorial Scenario On Ropsten
    [Documentation]  Test Katacoda Hello World Scenario On Ropsten
    [Tags]  Katacoda
    Prepare Iexec Factorial
    IexecSdk.Iexec An App  iexec-factorial  account allow 1
    IexecSdk.Iexec An App  iexec-factorial  wallet getRLC
    IexecSdk.Iexec An App  iexec-factorial  account login
    IexecSdk.Iexec An App  iexec-factorial  submit 10
    ${iexec_result} =  IexecSdk.Get Iexec Sdk Log
    @{transactionHash} =  Get Regexp Matches  ${iexec_result}  "transactionHash": "(?P<transactionHash>.*)",  transactionHash
    Wait Until Keyword Succeeds  10 min	30 sec  Check Factorial 10 In Result  @{transactionHash}[0]  --network ropsten


Test Deploy And Submit Katacoda Factorial Scenario On Rinkeby
    [Documentation]  Test Katacoda Hello World Scenario On Rinkeby
    [Tags]  Katacoda
    Prepare Iexec Factorial
    IexecSdk.Iexec An App  iexec-factorial  account allow 1 --network rinkeby
    IexecSdk.Iexec An App  iexec-factorial  wallet getRLC --network rinkeby
    IexecSdk.Iexec An App  iexec-factorial  account login --network rinkeby
    IexecSdk.Iexec An App  iexec-factorial  deploy --network rinkeby
    IexecSdk.Iexec An App  iexec-factorial  submit 10 --network rinkeby
    ${iexec_result} =  IexecSdk.Get Iexec Sdk Log
    @{transactionHash} =  Get Regexp Matches  ${iexec_result}  "transactionHash": "(?P<transactionHash>.*)",  transactionHash
    Wait Until Keyword Succeeds  10 min	30 sec  Check Factorial 10 In Result  @{transactionHash}[0]  --network rinkeby

Test Submit Katacoda Factorial Scenario On Rinkeby
    [Documentation]  Test Katacoda Hello World Scenario On Rinkeby
    [Tags]  Katacoda
    Prepare Iexec Factorial
    IexecSdk.Iexec An App  iexec-factorial  account allow 1 --network rinkeby
    IexecSdk.Iexec An App  iexec-factorial  wallet getRLC --network rinkeby
    IexecSdk.Iexec An App  iexec-factorial  account login --network rinkeby
    IexecSdk.Iexec An App  iexec-factorial  submit 10 --network rinkeby
    ${iexec_result} =  IexecSdk.Get Iexec Sdk Log
    @{transactionHash} =  Get Regexp Matches  ${iexec_result}  "transactionHash": "(?P<transactionHash>.*)",  transactionHash
    Wait Until Keyword Succeeds  10 min	30 sec  Check Factorial 10 In Result  @{transactionHash}[0]  --network rinkeby


*** Keywords ***

Init Ping Katacoda
    IexecSdk.Init Sdk

Prepare Iexec Factorial
    ${rm_result} =  Run Process  rm -rf ${REPO_DIR}/iexec-factorial  shell=yes
    Should Be Empty	${rm_result.stderr}
    Should Be Equal As Integers	${rm_result.rc}	0
    IexecSdk.Iexec Init An App  factorial
    IexecSdk.Iexec An App  iexec-factorial  wallet create
    Run  sed 's/.*\"privateKey\":.*/\"privateKey\":\"${PKEY}\",/g' ${REPO_DIR}/iexec-factorial/wallet.json > ${REPO_DIR}/iexec-factorial/wallet.tmp && cat ${REPO_DIR}/iexec-factorial/wallet.tmp > ${REPO_DIR}/iexec-factorial/wallet.json


Check Factorial 10 In Result
    [Arguments]  ${transactionHash}  ${network}
    IexecSdk.Iexec An App  iexec-factorial  result ${transactionHash} ${network} --save
    ${stdout} =  IexecSdk.Get Iexec Sdk Log
    ${count_zip} =	Count Files In Directory  ${REPO_DIR}/iexec-factorial  *.zip
    ${count_txt} =  Count Files In Directory  ${REPO_DIR}/iexec-factorial  *.text
    ${sum}=  Evaluate  int(${count_zip}) + int(${count_txt})
    Should Be True  ${sum} > 0
    Run Keyword If  ${count_zip} > 0  Check Factorial ZIP  ${transactionHash}
    Run Keyword If  ${count_txt} > 0  Check Factorial TXT  ${transactionHash}


Check Factorial TXT
    [Arguments]  ${transactionHash}
    ${result} =  Get File  ${REPO_DIR}/iexec-factorial/${transactionHash}.text
    ${lines} =  Get Lines Containing String  ${result}  3628800
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1

Check Factorial ZIP
    [Arguments]  ${transactionHash}
    Extract Zip File  ${REPO_DIR}/iexec-factorial/${transactionHash}.zip  ${REPO_DIR}/iexec-factorial/zipout
    ${result} =  Get File  ${REPO_DIR}/iexec-factorial/zipout/stdout.txt
    ${lines} =  Get Lines Containing String  ${result}  3628800
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1
