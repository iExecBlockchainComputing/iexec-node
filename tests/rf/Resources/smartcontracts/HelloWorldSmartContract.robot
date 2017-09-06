*** Settings ***

*** Variables ***

*** Keywords ***

Call RegisterEcho
    ${truffletest_result} =  Run Process  cd iexec-oracle/API && ./node_modules/.bin/truffle test test/rf/registerHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
