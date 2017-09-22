*** Settings ***
Documentation    Launch katacoda scenario on ropsten, kovan and rinkeby. to check all test chain ok
Resource  ../Resources/IexecSdk.robot
Suite Setup  Init Ping Katacoda


# to launch tests :
# pybot --variable PKEY:aprivatekey -d Results ./Tests/isKatacodaScenarioAlive.robot

*** Variables ***
${PKEY}


#iexec.js
#module.exports = {
#    name: 'Factorial',
#    constructorArgs: ['0x552075c9e40b050c8b61339b770e2a21e9014b3c'],
#    // constructorArgs: ['0x0b1ea4ff347e05ca175e3d3cfb4499bc4ad5ada5'], // rinkeby
#    // constructorArgs: ['0xe6b658facf9621eff76a0d649c61dba4c8de85fb'], // kovan
#};

${IEXEC_ORACLE_ON_ROPSTEN} =  0x552075c9e40b050c8b61339b770e2a21e9014b3c
${IEXEC_ORACLE_ON_KOVAN} =  0xe6b658facf9621eff76a0d649c61dba4c8de85fb
${IEXEC_ORACLE_ON_RINKEBY} =  0x0b1ea4ff347e05ca175e3d3cfb4499bc4ad5ada5

*** Test Cases ***


Test Katacoda Hello World Scenario On Kovan
    [Documentation]  Test Katacoda Hello World Scenario On Kovan
    [Tags]  Katacoda
    Prepare Iexec Factorial Kovan
    IexecSdk.Iexec An App  iexec-factorial  migrate --network kovan
    IexecSdk.Iexec An App  iexec-factorial  submit factorial 10 --network kovan
    Wait Until Keyword Succeeds  30 min	30 sec  Check Factorial 10 In Result  --network kovan

#Test Katacoda Hello World Scenario On Ropsten
#    [Documentation]  Test Katacoda Hello World Scenario On Ropsten
#    [Tags]  Katacoda
#    Prepare Iexec Factorial
#    IexecSdk.Iexec An App  iexec-factorial  migrate
#    IexecSdk.Iexec An App  iexec-factorial  submit factorial 10
#    Wait Until Keyword Succeeds  30 min	30 sec  Check Factorial 10 In Result  --network ropsten

#Test Katacoda Hello World Scenario On Rinkeby
#    [Documentation]  Test Katacoda Hello World Scenario On Rinkeby
#    [Tags]  Katacoda
#    Prepare Iexec Factorial Rinkeby
#    IexecSdk.Iexec An App  iexec-factorial  migrate --network rinkeby
#    IexecSdk.Iexec An App  iexec-factorial  submit factorial 10 --network rinkeby
#    Wait Until Keyword Succeeds  30 min	30 sec  Check Factorial 10 In Result  --network rinkeby

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
    [Arguments]  ${network}
    ${stdout} =  IexecSdk.Iexec An App  iexec-factorial  results ${network}
    ${lines} =  Get Lines Containing String  ${stdout}  3628800
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1

