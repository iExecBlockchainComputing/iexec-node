*** Settings ***

*** Variables ***

*** Keywords ***

Watch CallbackEvent
    ${truffletest_result} =  Run Process  cd iexec-oracle/API && ./node_modules/.bin/truffle test test/rf/watchCallbackEventInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    [Return]  ${truffletest_result.stdout}

Watch LaunchEvent
    ${truffletest_result} =  Run Process  cd iexec-oracle/API && ./node_modules/.bin/truffle test test/rf/watchLaunchEventInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    [Return]  ${truffletest_result.stdout}

Get User Address
    ${truffletest_result} =  Run Process  cd iexec-oracle/API && ./node_modules/.bin/truffle test test/rf/getUserAddress.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{address} =  Get Regexp Matches  ${truffletest_result.stdout}  BEGIN_LOG(?P<address>.*)END_LOG  address
    [Return]  @{address}[0]

Get Creator Address
    ${truffletest_result} =  Run Process  cd iexec-oracle/API && ./node_modules/.bin/truffle test test/rf/getCreatorAddress.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{address} =  Get Regexp Matches  ${truffletest_result.stdout}  BEGIN_LOG(?P<address>.*)END_LOG  address
    [Return]  @{address}[0]

Get Work
    ${truffletest_result} =  Run Process  cd iexec-oracle/API && ./node_modules/.bin/truffle test test/rf/getWorkInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    [Return]  ${truffletest_result.stdout}



