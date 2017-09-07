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


Set Pending
    [Arguments]  ${uid}
    Run  sed -i "s/.*return aHelloWorldInstance.setPendingHelloWorld(.*/return aHelloWorldInstance.setPendingHelloWorld(\\"${uid}\\",{/g" iexec-oracle/API/test/rf/setPendingHelloWorldTest.js
    ${truffletest_result} =  Run Process  cd iexec-oracle/API && ./node_modules/.bin/truffle test test/rf/setPendingHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0

Get Status
    [Arguments]  ${uid}
    Run  sed -i "s/.*return aHelloWorldInstance.statusHelloWorld(.*/return aHelloWorldInstance.statusHelloWorld(\\"${uid}\\",{/g" iexec-oracle/API/test/rf/statusHelloWorldTest.js
    ${truffletest_result} =  Run Process  cd iexec-oracle/API && ./node_modules/.bin/truffle test test/rf/statusHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0

Get Result
    [Arguments]  ${uid}
    Run  sed -i "s/.*return aHelloWorldInstance.resultHelloWorld(.*/return aHelloWorldInstance.resultHelloWorld(\\"${uid}\\",{/g" iexec-oracle/API/test/rf/resultHelloWorldTest.js
    ${truffletest_result} =  Run Process  cd iexec-oracle/API && ./node_modules/.bin/truffle test test/rf/resultHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
