*** Settings ***

*** Variables ***

*** Keywords ***



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


Watch IExecCallbackEvent
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/watchIExecCallbackEventHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    #TODO PARSE JSON
    [Return]  ${truffletest_result.stdout}


SubmitEcho
    [Arguments]  ${text}
    Run  sed -i "s/.*return aHelloWorldInstance.iexecSubmit(.*/return aHelloWorldInstance.iexecSubmit(\\"echo\\",\\"${text}\\",{/g" iexec-oracle/test/rf/submitHelloWorldTest.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/submitHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
