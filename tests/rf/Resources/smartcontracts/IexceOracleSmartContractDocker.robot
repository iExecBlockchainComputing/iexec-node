*** Settings ***

*** Variables ***

*** Keywords ***

Check Submit Event In IexceOracleSmartContract
    [Arguments]  ${dapp}  ${args}
    ${watch_callback_events} =  Wait Until Keyword Succeeds  3 min  1 min  Watch Submit
    Should Be Equal As Strings  ${watch_callback_events[0]["event"]}  Submit
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["args"]}  ${args}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["user"]}  ${USER}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["provider"]}  ${PROVIDER}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["dapp"]}  ${dapp}


Check SubmitCallback Event In IexceOracleSmartContract
    [Arguments]  ${submitTxHash}  ${user}  ${stdout}  ${uri}
    ${watch_callback_events} =  Wait Until Keyword Succeeds  3 min  1 min  Watch SubmitCallback
    Should Be Equal As Strings  ${watch_callback_events[0]["event"]}  SubmitCallback
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["submitTxHash"]}  ${submitTxHash}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["user"]}  ${user}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["stdout"]}  ${stdout}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["uri"]}  ${uri}


Check Work Is Recorded in IexceOracleSmartContract After Submit
    [Arguments]  ${submitTxHash}
    @{work_result} =  Get Work  ${submitTxHash}
    ${work_timestamp} =  Get Work Timestamp  ${submitTxHash}
    Should Be Equal As Strings  ${work_timestamp}  @{work_result}[0]
    ${work_status} =  Get Work Status  ${submitTxHash}
    Should Be Equal As Strings  ${work_status}  @{work_result}[1]
    ${work_stdout} =  Get Work Stdout  ${submitTxHash}
    Should Be Equal As Strings  ${work_stdout}  @{work_result}[2]
    ${work_stderr} =  Get Work Stderr  ${submitTxHash}
    Should Be Equal As Strings  ${work_stderr}  @{work_result}[3]
    Should Be Empty  ${work_stderr}
    ${work_uri} =  Get Work Uri  ${submitTxHash}
    Should Be Equal As Strings  ${work_uri}  @{work_result}[4]
    Should Contain  ${work_uri}  :
    [Return]  @{work_result}

Watch SubmitCallback
    ${truffletest_result} =  Run Process  cd iexec-oracle-contract && docker-compose -f docker-compose.dev.yml run iexec-oracle bash ./test/rf/watchSubmitCallbackInIexecOracle.sh ${IEXEC_ORACLE_SM_ADDRESS} ${HELLO_WORLD_SM_ADDRESS}  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    ${after_begin_log} =  Fetch From Right  ${truffletest_result.stdout}  BEGIN_LOG
    ${before_end_log} =  Fetch From Left  ${after_begin_log}  END_LOG
    ${before_end_log} =	Replace String	${before_end_log}  \\n  ${EMPTY}
    ${events}=  evaluate  json.loads('''${before_end_log}''')  json
    Log  ${events}
    [Return]  ${events}

Watch Submit
    ${truffletest_result} =  Run Process  cd iexec-oracle-contract && docker-compose -f docker-compose.dev.yml run iexec-oracle bash ./test/rf/watchSubmitInIexecOracle.sh ${IEXEC_ORACLE_SM_ADDRESS} ${HELLO_WORLD_SM_ADDRESS}  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    ${after_begin_log} =  Fetch From Right  ${truffletest_result.stdout}  BEGIN_LOG
    ${before_end_log} =  Fetch From Left  ${after_begin_log}  END_LOG
    ${before_end_log} =	Replace String	${before_end_log}  \"  \\"
    ${events}=  evaluate  json.loads('''${before_end_log}''')  json
    Log  ${events}
    [Return]  ${events}

Get User Address
    ${truffletest_result} =  Run Process  cd iexec-oracle-contract && docker-compose -f docker-compose.dev.yml run iexec-oracle ./node_modules/.bin/truffle test test/rf/getUserAddress.js --network docker  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{address} =  Get Regexp Matches  ${truffletest_result.stdout}  BEGIN_LOG(?P<address>.*)END_LOG  address
    [Return]  @{address}[0]

Get Provider Address
    ${truffletest_result} =  Run Process  cd iexec-oracle-contract && docker-compose -f docker-compose.dev.yml run iexec-oracle ./node_modules/.bin/truffle test test/rf/getProviderAddress.js --network docker  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{address} =  Get Regexp Matches  ${truffletest_result.stdout}  BEGIN_LOG(?P<address>.*)END_LOG  address
    [Return]  @{address}[0]

Get Work
    [Arguments]  ${submitTxHash}
    ${truffletest_result} =  Run Process  cd iexec-oracle-contract && docker-compose -f docker-compose.dev.yml run iexec-oracle bash ./test/rf/getWorkInIexecOracle.sh ${IEXEC_ORACLE_SM_ADDRESS} ${HELLO_WORLD_SM_ADDRESS} ${submitTxHash}  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{timestamp} =  Get Regexp Matches  ${truffletest_result.stdout}  timestamp:(?P<timestamp>.*)  timestamp
    @{status} =  Get Regexp Matches  ${truffletest_result.stdout}  status:(?P<status>.*)  status
    @{stdout} =  Get Regexp Matches  ${truffletest_result.stdout}  stdout:(?P<stdout>.*)  stdout
    @{stderr} =  Get Regexp Matches  ${truffletest_result.stdout}  stderr:(?P<stderr>.*)  stderr
    @{uri} =  Get Regexp Matches  ${truffletest_result.stdout}  uri:(?P<uri>.*)  uri
    @{work_result} =  Create List  @{timestamp}[0]  @{status}[0]  @{stdout}[0]  @{stderr}[0]  @{uri}[0]
    [Return]  @{work_result}

Get Work Timestamp
    [Arguments]  ${submitTxHash}
    ${truffletest_result} =  Run Process  cd iexec-oracle-contract && docker-compose -f docker-compose.dev.yml run iexec-oracle bash ./test/rf/getWorkTimestampInIexecOracle.sh ${IEXEC_ORACLE_SM_ADDRESS} ${HELLO_WORLD_SM_ADDRESS} ${submitTxHash}  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{timestamp} =  Get Regexp Matches  ${truffletest_result.stdout}  timestamp:(?P<timestamp>.*)  timestamp
    [Return]  @{timestamp}[0]

Get Work Status
    [Arguments]  ${submitTxHash}
    ${truffletest_result} =  Run Process  cd iexec-oracle-contract && docker-compose -f docker-compose.dev.yml run iexec-oracle bash ./test/rf/getWorkStatusInIexecOracle.sh ${IEXEC_ORACLE_SM_ADDRESS} ${HELLO_WORLD_SM_ADDRESS} ${submitTxHash}  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{status} =  Get Regexp Matches  ${truffletest_result.stdout}  status:(?P<status>.*)  status
    [Return]  @{status}[0]

Get Work Stdout
    [Arguments]  ${submitTxHash}
    ${truffletest_result} =  Run Process  cd iexec-oracle-contract && docker-compose -f docker-compose.dev.yml run iexec-oracle bash ./test/rf/getWorkStdoutInIexecOracle.sh ${IEXEC_ORACLE_SM_ADDRESS} ${HELLO_WORLD_SM_ADDRESS} ${submitTxHash}  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{stdout} =  Get Regexp Matches  ${truffletest_result.stdout}  stdout:(?P<stdout>.*)  stdout
    [Return]  @{stdout}[0]

Get Work Stderr
    [Arguments]  ${submitTxHash}
    ${truffletest_result} =  Run Process  cd iexec-oracle-contract && docker-compose -f docker-compose.dev.yml run iexec-oracle bash ./test/rf/getWorkStderrInIexecOracle.sh ${IEXEC_ORACLE_SM_ADDRESS} ${HELLO_WORLD_SM_ADDRESS} ${submitTxHash}  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{stderr} =  Get Regexp Matches  ${truffletest_result.stdout}  stderr:(?P<stderr>.*)  stderr
    [Return]  @{stderr}[0]

Get Work Uri
    [Arguments]  ${submitTxHash}
    ${truffletest_result} =  Run Process  cd iexec-oracle-contract && docker-compose -f docker-compose.dev.yml run iexec-oracle bash ./test/rf/getWorkUriInIexecOracle.sh ${IEXEC_ORACLE_SM_ADDRESS} ${HELLO_WORLD_SM_ADDRESS} ${submitTxHash}  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{uri} =  Get Regexp Matches  ${truffletest_result.stdout}  uri:(?P<uri>.*)  uri
    [Return]  @{uri}[0]


