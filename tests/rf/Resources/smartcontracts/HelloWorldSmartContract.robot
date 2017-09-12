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

Check Submit CallbackEvent Event In HelloWorldSmartContract
    [Arguments]  ${work_uid}  ${provider}
    ${watch_callback_event} =  Wait Until Keyword Succeeds  3 min  1 min  Watch IExecCallbackEvent
    Should Contain  ${watch_callback_event}  event: 'IexecCallbackEvent'
    Should Contain  ${watch_callback_event}  callbackType: 'SubmitCallback'
    Should Contain  ${watch_callback_event}  appName: 'echo'
    Should Contain  ${watch_callback_event}  user: '${USER}'
    Should Contain  ${watch_callback_event}  creator: '${CREATOR}'
    Should Contain  ${watch_callback_event}  provider: '${provider}'
    Should Contain  ${watch_callback_event}  workUid: '${work_uid}'


Check SubmitAndWait CallbackEvent Event In HelloWorldSmartContract
    [Arguments]  ${work_uid}  ${provider}
    ${watch_callback_event} =  Watch IExecCallbackEvent
    Should Contain  ${watch_callback_event}  event: 'IexecCallbackEvent'
    Should Contain  ${watch_callback_event}  callbackType: 'SubmitAndWaitCallback'
    Should Contain  ${watch_callback_event}  appName: 'echo'
    Should Contain  ${watch_callback_event}  user: '${USER}'
    Should Contain  ${watch_callback_event}  creator: '${CREATOR}'
    Should Contain  ${watch_callback_event}  provider: '${provider}'
    Should Contain  ${watch_callback_event}  workUid: '${work_uid}'


Watch IExecCallbackEvent
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/watchIExecCallbackEventHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    #TODO PARSE JSON
    [Return]  ${truffletest_result.stdout}



SubmitAndWaitEcho
    [Arguments]  ${text}
    Run  sed -i "s/.*return aHelloWorldInstance.submitAndWaitEcho(.*/return aHelloWorldInstance.submitAndWaitEcho(\\"${text}\\",{/g" iexec-oracle/test/rf/submitAndWaitHelloWorldTest.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/submitAndWaitHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0

SubmitEcho
    [Arguments]  ${text}
    Run  sed -i "s/.*return aHelloWorldInstance.submitEcho(.*/return aHelloWorldInstance.submitEcho(\\"${text}\\",{/g" iexec-oracle/test/rf/submitHelloWorldTest.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/submitHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0

RegisterEcho
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/registerHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0


SetParamHelloWorld
    [Arguments]  ${uid}  ${text}
    Run  sed -i "s/.*return aHelloWorldInstance.setHelloWorldParam(.*/return aHelloWorldInstance.setHelloWorldParam(\\"${uid}\\",\\"${text}\\",{/g" iexec-oracle/test/rf/setParamHelloWorldTest.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/setParamHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0


Set Pending
    [Arguments]  ${uid}
    Run  sed -i "s/.*return aHelloWorldInstance.setPendingHelloWorld(.*/return aHelloWorldInstance.setPendingHelloWorld(\\"${uid}\\",{/g" iexec-oracle/test/rf/setPendingHelloWorldTest.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/setPendingHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0

Get Status
    [Arguments]  ${uid}
    Run  sed -i "s/.*return aHelloWorldInstance.statusHelloWorld(.*/return aHelloWorldInstance.statusHelloWorld(\\"${uid}\\",{/g" iexec-oracle/test/rf/statusHelloWorldTest.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/statusHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0

Get Result
    [Arguments]  ${uid}
    Run  sed -i "s/.*return aHelloWorldInstance.resultHelloWorld(.*/return aHelloWorldInstance.resultHelloWorld(\\"${uid}\\",{/g" iexec-oracle/test/rf/resultHelloWorldTest.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/resultHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
