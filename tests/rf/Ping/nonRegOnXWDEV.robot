*** Settings ***
Documentation    Non reg on dev.iex.ec
Resource  ../Resources/IexecSdk.robot
Suite Setup  Init Test Dev


# to launch tests :
# pybot -d Results ./tests/rf/Ping/nonRegOnXWDEV.robot

*** Variables ***
${DAPPNAME}


*** Test Cases ***


Test Factorial On Dev
    [Documentation]  Test Factorial On Dev
    [Tags]  nonRegOnXWDEV
     Prepare Iexec Factorial
     Log  ${DAPPNAME}
     IexecSdk.Iexec An App  iexec-factorial  account login
     ${iexec_result.stderr} =  IexecSdk.Iexec An App  iexec-factorial  server deploy
     @{appUID} =  Get Regexp Matches  ${iexec_result.stderr}  iexec-server-js-client appUID (?P<appUID>.*)  appUID
     Log  @{appUID}[0]
    ${iexec_result.stderr} =  IexecSdk.Iexec An App  iexec-factorial  server submit --app @{appUID}[0]
    Log  ${iexec_result.stderr}
    @{workUID} =  Get Regexp Matches  ${iexec_result.stderr}  iexec-server-js-client workUID (?P<workUID>.*)  workUID
     Log  @{workUID}[0]
    Wait Until Keyword Succeeds  1 min	30 sec  Check Factorial 10 In Result  @{workUID}[0]


*** Keywords ***

Init Test Dev
    IexecSdk.Init Sdk


Prepare Iexec Factorial
    ${rm_result} =  Run Process  rm -rf iexec-factorial  shell=yes
    Should Be Empty	${rm_result.stderr}
    Should Be Equal As Integers	${rm_result.rc}	0
    IexecSdk.Iexec Init An App  factorial
    IexecSdk.Iexec An App  iexec-factorial  wallet create
    Run  sed -i "s/testxw.iex.ec/devxw.iex.ec/g" iexec-factorial/truffle.js
    # change the name adress of factorial
    ${wallet} =  Get File  iexec-factorial/wallet.json
     @{address} =  Get Regexp Matches  ${wallet}  "address": "(?P<address>.*)"  address
     ${dappName} =  Catenate  SEPARATOR=  0x  @{address}[0]
     Set Test Variable	${DAPPNAME}	 ${dappName}
     #replace 0xd2b9d3ecc76b6d43277fd986afdb8b79685d4d1a by DAPPNAME
     Run  sed -i "s/0xd2b9d3ecc76b6d43277fd986afdb8b79685d4d1a/${dappName}/g" iexec-factorial/build/contracts/Factorial.json


Check Factorial 10 In Result
    [Arguments]  ${workUID}
    IexecSdk.Iexec An App  iexec-factorial  server result ${workUID} --save
    ${result} =  Get File  iexec-factorial/${workUID}.text
    ${lines} =  Get Lines Containing String  ${result}  3628800
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1
