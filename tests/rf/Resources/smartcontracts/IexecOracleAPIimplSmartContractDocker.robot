*** Settings ***

*** Variables ***

*** Keywords ***

Check IexecSubmitCallback Event In IexecOracleAPIimplSmartContract
    [Arguments]  ${submitTxHash}  ${user}  ${stdout}  ${uri}
    ${watch_callback_events} =  Wait Until Keyword Succeeds  3 min  1 min  Watch IexecSubmitCallback
    Should Be Equal As Strings  ${watch_callback_events[0]["event"]}  IexecSubmitCallback
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["submitTxHash"]}  ${submitTxHash}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["user"]}  ${user}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["stdout"]}  ${stdout}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["uri"]}  ${uri}

Watch IexecSubmitCallback
    ${truffletest_result} =  Run Process  cd iexec-oracle-contract && docker-compose -f docker-compose.dev.yml run iexec-oracle bash ./test/rf/watchIexecSubmitCallbackTest.sh ${IEXEC_ORACLE_SM_ADDRESS} ${HELLO_WORLD_SM_ADDRESS}  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    ${after_begin_log} =  Fetch From Right  ${truffletest_result.stdout}  BEGIN_LOG
    ${before_end_log} =  Fetch From Left  ${after_begin_log}  END_LOG
    ${before_end_log} =	Replace String	${before_end_log}  \\n  ${EMPTY}
    ${events}=  evaluate  json.loads('''${before_end_log}''')  json
    Log  ${events}
    [Return]  ${events}

Submit
    [Arguments]  ${param}
    ${truffletest_result} =  Run Process  cd iexec-oracle-contract && docker-compose -f docker-compose.dev.yml run iexec-oracle bash ./test/rf/submitTest.sh ${IEXEC_ORACLE_SM_ADDRESS} ${HELLO_WORLD_SM_ADDRESS} ${param}  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{tx} =  Get Regexp Matches  ${truffletest_result.stdout}  { tx: '(?P<tx>.*)'  tx
    Log   @{tx}
    [Return]   @{tx}[0]