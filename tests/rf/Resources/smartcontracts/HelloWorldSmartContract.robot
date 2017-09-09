*** Settings ***

*** Variables ***

*** Keywords ***



Check Result CallbackEvent Event In HelloWorldSmartContract
    [Arguments]  ${work_uid}  ${provider}
    ${watch_callback_event} =  Wait Until Keyword Succeeds  3 min  1 min  Watch IExecCallbackEvent
    Should Contain  ${watch_callback_event}  event: 'IexecCallbackEvent'
    Should Contain  ${watch_callback_event}  callbackType: 'StdoutCallback'
    Should Contain  ${watch_callback_event}  appName: 'echo'
    Should Contain  ${watch_callback_event}  user: '${USER}'
    Should Contain  ${watch_callback_event}  creator: '${CREATOR}'
    Should Contain  ${watch_callback_event}  provider: '${provider}'
    Should Contain  ${watch_callback_event}  workUid: '${work_uid}'

Check Status CallbackEvent Event In HelloWorldSmartContract
    [Arguments]  ${work_uid}  ${provider}
    ${watch_callback_event} =  Wait Until Keyword Succeeds  3 min  1 min  Watch IExecCallbackEvent
    Should Contain  ${watch_callback_event}  event: 'IexecCallbackEvent'
    Should Contain  ${watch_callback_event}  callbackType: 'StatusCallback'
    Should Contain  ${watch_callback_event}  appName: 'echo'
    Should Contain  ${watch_callback_event}  user: '${USER}'
    Should Contain  ${watch_callback_event}  creator: '${CREATOR}'
    Should Contain  ${watch_callback_event}  provider: '${provider}'
    Should Contain  ${watch_callback_event}  workUid: '${work_uid}'

Check SetPending CallbackEvent Event In HelloWorldSmartContract
    [Arguments]  ${work_uid}  ${provider}
    ${watch_callback_event} =  Wait Until Keyword Succeeds  3 min  1 min  Watch IExecCallbackEvent
    Should Contain  ${watch_callback_event}  event: 'IexecCallbackEvent'
    Should Contain  ${watch_callback_event}  callbackType: 'SetPendingCallback'
    Should Contain  ${watch_callback_event}  appName: 'echo'
    Should Contain  ${watch_callback_event}  user: '${USER}'
    Should Contain  ${watch_callback_event}  creator: '${CREATOR}'
    Should Contain  ${watch_callback_event}  provider: '${provider}'
    Should Contain  ${watch_callback_event}  workUid: '${work_uid}'

Check SetParam CallbackEvent Event In HelloWorldSmartContract
    [Arguments]  ${work_uid}  ${provider}
    ${watch_callback_event} =  Wait Until Keyword Succeeds  3 min  1 min  Watch IExecCallbackEvent
    Should Contain  ${watch_callback_event}  event: 'IexecCallbackEvent'
    Should Contain  ${watch_callback_event}  callbackType: 'SetParamCallback'
    Should Contain  ${watch_callback_event}  appName: 'echo'
    Should Contain  ${watch_callback_event}  user: '${USER}'
    Should Contain  ${watch_callback_event}  creator: '${CREATOR}'
    Should Contain  ${watch_callback_event}  provider: '${provider}'
    Should Contain  ${watch_callback_event}  workUid: '${work_uid}'

Check Register CallbackEvent Event In HelloWorldSmartContract
    [Arguments]  ${work_uid}  ${provider}
    ${watch_callback_event} =  Wait Until Keyword Succeeds  3 min  1 min  Watch IExecCallbackEvent
    Should Contain  ${watch_callback_event}  event: 'IexecCallbackEvent'
    Should Contain  ${watch_callback_event}  callbackType: 'RegisterCallback'
    Should Contain  ${watch_callback_event}  appName: 'echo'
    Should Contain  ${watch_callback_event}  user: '${USER}'
    Should Contain  ${watch_callback_event}  creator: '${CREATOR}'
    Should Contain  ${watch_callback_event}  provider: '${provider}'
    Should Contain  ${watch_callback_event}  workUid: '${work_uid}'


Watch IExecCallbackEvent
    ${truffletest_result} =  Run Process  cd iexec-oracle/API && ./node_modules/.bin/truffle test test/rf/watchIExecCallbackEventHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    #TODO PARSE JSON
    [Return]  ${truffletest_result.stdout}

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
