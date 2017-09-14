*** Settings ***

*** Variables ***

*** Keywords ***

Check Submit CallbackEvent Event In HelloWorldSmartContract
    [Arguments]  ${index}  ${provider}
    ${watch_callback_events} =  Wait Until Keyword Succeeds  3 min  1 min  Watch IExecCallbackEvent
    Should Be Equal As Strings  ${watch_callback_events[0]["event"]}  IexecCallbackEvent
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["callbackType"]}  SubmitCallback
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["appName"]}  echo
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["user"]}  ${USER}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["creator"]}  ${CREATOR}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["provider"]}  ${provider}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["index"]}  ${index}

Watch IExecCallbackEvent
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/watchIExecCallbackEventHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    ${after_begin_log} =  Fetch From Right  ${truffletest_result.stdout}  BEGIN_LOG
    ${before_end_log} =  Fetch From Left  ${after_begin_log}  END_LOG
    ${events}=  evaluate  json.loads('''${before_end_log}''')  json
    Log  ${events}
    [Return]  ${events}

SubmitEcho
    [Arguments]  ${text}
    Run  sed -i "s/.*return aHelloWorldInstance.iexecSubmit(.*/return aHelloWorldInstance.iexecSubmit(\\"echo\\",\\"${text}\\",{/g" iexec-oracle/test/rf/submitHelloWorldTest.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/submitHelloWorldTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
