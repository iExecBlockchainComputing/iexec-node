*** Settings ***
Documentation    Launch katacoda scenario on ropsten, kovan and rinkeby. to check all test chain ok
Resource  ../Resources/IexecSdk.robot
Suite Setup  Init Ping Katacoda


# to launch tests :
# pybot --variable PKEY:aprivatekey -d Results ./tests/rf/Tests/isKatacodaScenarioAlive.robot

*** Variables ***
${PKEY}


${IEXEC_ORACLE_ON_ROPSTEN} =  0x065097b71b2e372eee4e31374b0262fa08238754
${IEXEC_ORACLE_ON_KOVAN} =  0x77040475d5cf05e9dd44f96d7dab3b7da7adbc6a
${IEXEC_ORACLE_ON_RINKEBY} =  0x9752f4bb6ab182a98e7347936e2172e7c0821338


*** Test Cases ***


Test Katacoda Hello World Scenario On Kovan
    [Documentation]  Test Katacoda Hello World Scenario On Kovan
    [Tags]  Katacoda
    Prepare Iexec Factorial Kovan
    IexecSdk.Iexec An App  iexec-factorial  migrate --network kovan
    ${iexec_result.stdout} =  IexecSdk.Iexec An App  iexec-factorial  submit factorial 10 --network kovan
    @{transactionHash} =  Get Regexp Matches  ${iexec_result.stdout}  View on etherscan: https://kovan.etherscan.io/tx/(?P<transactionHash>.*)  transactionHash
    Wait Until Keyword Succeeds  30 min	30 sec  Check Factorial 10 In Result  @{transactionHash}[0]  --network kovan

Test Katacoda Hello World Scenario On Ropsten
    [Documentation]  Test Katacoda Hello World Scenario On Ropsten
    [Tags]  Katacoda
    Prepare Iexec Factorial
    IexecSdk.Iexec An App  iexec-factorial  migrate
    ${iexec_result.stdout} =  IexecSdk.Iexec An App  iexec-factorial  submit factorial 10
    @{transactionHash} =  Get Regexp Matches  ${iexec_result.stdout}  View on etherscan: https://ropsten.etherscan.io/tx/(?P<transactionHash>.*)  transactionHash
    Wait Until Keyword Succeeds  30 min	30 sec  Check Factorial 10 In Result  @{transactionHash}[0]  --network ropsten

Test Katacoda Hello World Scenario On Rinkeby
    [Documentation]  Test Katacoda Hello World Scenario On Rinkeby
    [Tags]  Katacoda
    Prepare Iexec Factorial Rinkeby
    IexecSdk.Iexec An App  iexec-factorial  migrate --network rinkeby
    ${iexec_result.stdout} =  IexecSdk.Iexec An App  iexec-factorial  submit factorial 10 --network rinkeby
    @{transactionHash} =  Get Regexp Matches  ${iexec_result.stdout}  View on etherscan: https://rinkeby.etherscan.io/tx/(?P<transactionHash>.*)  transactionHash
    Wait Until Keyword Succeeds  30 min	30 sec  Check Factorial 10 In Result  @{transactionHash}[0]  --network rinkeby

*** Keywords ***

Init Ping Katacoda
    IexecSdk.Init Sdk

Prepare Iexec Factorial
    ${rm_result} =  Run Process  rm -rf iexec-factorial  shell=yes
    Should Be Empty	${rm_result.stderr}
    Should Be Equal As Integers	${rm_result.rc}	0
    IexecSdk.Iexec Init An App  factorial
    IexecSdk.Iexec An App  iexec-factorial  wallet create
    Run  sed -i 's/.*\"privateKey\":.*/\"privateKey\":\"${PKEY}\",/g' iexec-factorial/wallet.json

Prepare Iexec Factorial Kovan
    Prepare Iexec Factorial
    # replace ropsten by Kovan oracle address
    Run  sed -i 's/${IEXEC_ORACLE_ON_ROPSTEN}/${IEXEC_ORACLE_ON_KOVAN}/g' iexec-factorial/iexec.js


Prepare Iexec Factorial Rinkeby
    Prepare Iexec Factorial
    # replace ropsten by Rinkeby oracle address
    Run  sed -i 's/${IEXEC_ORACLE_ON_ROPSTEN}/${IEXEC_ORACLE_ON_RINKEBY}/g' iexec-factorial/iexec.js


Check Factorial 10 In Result
    [Arguments]  ${transactionHash}  ${network}
    ${stdout} =  IexecSdk.Iexec An App  iexec-factorial  result ${transactionHash} ${network}
    ${lines} =  Get Lines Containing String  ${stdout}  3628800
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1

