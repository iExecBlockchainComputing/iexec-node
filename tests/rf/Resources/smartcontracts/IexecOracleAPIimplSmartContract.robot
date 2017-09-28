*** Settings ***

*** Variables ***

*** Keywords ***

Check IexecSubmitCallback Event In IexecOracleAPIimplSmartContract
    [Arguments]  ${submitTxHash}  ${user}  ${appName}  ${stdout}
    ${watch_callback_events} =  Wait Until Keyword Succeeds  3 min  1 min  Watch IexecSubmitCallback
    Should Be Equal As Strings  ${watch_callback_events[0]["event"]}  IexecSubmitCallback
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["submitTxHash"]}  ${submitTxHash}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["user"]}  ${user}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["appName"]}  ${appName}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["stdout"]}  ${stdout}

Watch IexecSubmitCallback
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/watchIexecSubmitCallbackTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    ${after_begin_log} =  Fetch From Right  ${truffletest_result.stdout}  BEGIN_LOG
    ${before_end_log} =  Fetch From Left  ${after_begin_log}  END_LOG
    ${events}=  evaluate  json.loads('''${before_end_log}''')  json
    Log  ${events}
    [Return]  ${events}

Submit
    [Arguments]  ${appName}  ${param}
    Run  sed -i "s/.*return aIexecOracleAPIimplInstance.iexecSubmit(.*/return aIexecOracleAPIimplInstance.iexecSubmit(\\"${appName}\\",\\"${param}\\",{/g" iexec-oracle/test/rf/submitTest.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/submitTest.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{tx} =  Get Regexp Matches  ${truffletest_result.stdout}  { tx: '(?P<tx>.*)'  tx
    Log   @{tx}
    [Return]   @{tx}[0]