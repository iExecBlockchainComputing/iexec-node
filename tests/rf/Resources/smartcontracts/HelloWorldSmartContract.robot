*** Settings ***

*** Variables ***

*** Keywords ***

RegisterEcho
    ${truffletest_result} =  Run Process  cd iexec-oracle/API && ./node_modules/.bin/truffle test test/rf/registerHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0


SetParamHelloWorld
    [Arguments]  ${uid}  ${text}
    Run  sed -i "s/.*return aHelloWorldInstance.setHelloWorldParam(.*/return aHelloWorldInstance.setHelloWorldParam(\\"${uid}\\",\\"${text}\\",{/g" iexec-oracle/API/test/rf/setParamHelloWorldTest.js
    ${truffletest_result} =  Run Process  cd iexec-oracle/API && ./node_modules/.bin/truffle test test/rf/setParamHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0