*** Settings ***

*** Variables ***

*** Keywords ***

Check Submit Launch Event In IexceOracleSmartContract
    [Arguments]  ${provider}
    ${watch_callback_events} =  Wait Until Keyword Succeeds  1 min  1 min  Watch LaunchEvent
    Should Be Equal As Strings  ${watch_callback_events[0]["event"]}  Launch
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["functionName"]}  submit
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["param1"]}  echo
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["user"]}  ${USER}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["creator"]}  ${CREATOR}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["provider"]}  ${provider}
    Log  ${watch_callback_events[0]["args"]["opid"]}
    [Return]  ${watch_callback_events[0]["args"]["opid"]}


Check Submit CallbackEvent Event In IexceOracleSmartContract
    [Arguments]  ${opid}  ${provider}
    ${watch_callback_events} =  Wait Until Keyword Succeeds  3 min  1 min  Watch CallbackEvent
    Should Be Equal As Strings  ${watch_callback_events[0]["event"]}  CallbackEvent
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["callbackType"]}  SubmitCallback
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["opid"]}  ${opid}


Check Work Is Recorded in IexceOracleSmartContract After Submit
    [Arguments]  ${opid}  ${provider}
    @{work_result} =  Get Work  ${opid}
    ${workuid} =  Get Work Uid  ${opid}
    Should Be Equal As Strings  ${workuid}  @{work_result}[0]
    ${work_name} =  Get Work Name  ${opid}
    Should Be Equal As Strings  ${work_name}  @{work_result}[1]
    Should Be Equal As Strings  ${work_name}  echo
    ${work_timestamp} =  Get Work Timestamp  ${opid}
    Should Be Equal As Strings  ${work_timestamp}  @{work_result}[2]
    ${work_status} =  Get Work Status  ${opid}
    Should Be Equal As Strings  ${work_status}  @{work_result}[3]
    ${work_stdout} =  Get Work Stdout  ${opid}
    Should Be Equal As Strings  ${work_stdout}  @{work_result}[4]
    ${work_stderr} =  Get Work Stderr  ${opid}
    Should Be Equal As Strings  ${work_stderr}  @{work_result}[5]
    Should Be Empty  ${work_stderr}

Watch CallbackEvent
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/watchCallbackEventInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    ${after_begin_log} =  Fetch From Right  ${truffletest_result.stdout}  BEGIN_LOG
    ${before_end_log} =  Fetch From Left  ${after_begin_log}  END_LOG
    ${events}=  evaluate  json.loads('''${before_end_log}''')  json
    Log  ${events}
    [Return]  ${events}

Watch LaunchEvent
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/watchLaunchEventInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    ${after_begin_log} =  Fetch From Right  ${truffletest_result.stdout}  BEGIN_LOG
    ${before_end_log} =  Fetch From Left  ${after_begin_log}  END_LOG
    ${events}=  evaluate  json.loads('''${before_end_log}''')  json
    Log  ${events}
    [Return]  ${events}

Get User Address
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getUserAddress.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{address} =  Get Regexp Matches  ${truffletest_result.stdout}  BEGIN_LOG(?P<address>.*)END_LOG  address
    [Return]  @{address}[0]

Get Creator Address
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getCreatorAddress.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{address} =  Get Regexp Matches  ${truffletest_result.stdout}  BEGIN_LOG(?P<address>.*)END_LOG  address
    [Return]  @{address}[0]

Get Work
    [Arguments]  ${opid}
    Run  sed -i "s/.*getWork.call(.*/return aIexecOracleInstance.getWork.call('${opid}');/g" iexec-oracle/test/rf/getWorkInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{workuid} =  Get Regexp Matches  ${truffletest_result.stdout}  workuid:(?P<workuid>.*)  workuid
    @{name} =  Get Regexp Matches  ${truffletest_result.stdout}  name:(?P<name>.*)  name
    @{timestamp} =  Get Regexp Matches  ${truffletest_result.stdout}  timestamp:(?P<timestamp>.*)  timestamp
    @{status} =  Get Regexp Matches  ${truffletest_result.stdout}  status:(?P<status>.*)  status
    @{stdout} =  Get Regexp Matches  ${truffletest_result.stdout}  stdout:(?P<stdout>.*)  stdout
    @{stderr} =  Get Regexp Matches  ${truffletest_result.stdout}  stderr:(?P<stderr>.*)  stderr
    @{work_result} =  Create List  @{workuid}[0]  @{name}[0]  @{timestamp}[0]  @{status}[0]  @{stdout}[0]  @{stderr}[0]
    [Return]  @{work_result}


Get Work Uid
    [Arguments]  ${opid}
    Run  sed -i "s/.*getWorkUid.call(.*/return aIexecOracleInstance.getWorkUid.call('${opid}');/g" iexec-oracle/test/rf/getWorkUidInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkUidInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{workuid} =  Get Regexp Matches  ${truffletest_result.stdout}  workuid:(?P<workuid>.*)  workuid
    [Return]  @{workuid}[0]

Get Work Name
    [Arguments]  ${opid}
    Run  sed -i "s/.*getWorkName.call(.*/return aIexecOracleInstance.getWorkName.call('${opid}');/g" iexec-oracle/test/rf/getWorkNameInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkNameInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{name} =  Get Regexp Matches  ${truffletest_result.stdout}  name:(?P<name>.*)  name
    [Return]  @{name}[0]

Get Work Timestamp
    [Arguments]  ${opid}
    Run  sed -i "s/.*getWorkTimestamp.call(.*/return aIexecOracleInstance.getWorkTimestamp.call('${opid}');/g" iexec-oracle/test/rf/getWorkTimestampInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkTimestampInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{timestamp} =  Get Regexp Matches  ${truffletest_result.stdout}  timestamp:(?P<timestamp>.*)  timestamp
    [Return]  @{timestamp}[0]

Get Work Status
    [Arguments]  ${opid}
    Run  sed -i "s/.*getWorkStatus.call(.*/return aIexecOracleInstance.getWorkStatus.call('${opid}');/g" iexec-oracle/test/rf/getWorkStatusInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkStatusInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{status} =  Get Regexp Matches  ${truffletest_result.stdout}  status:(?P<status>.*)  status
    [Return]  @{status}[0]

Get Work Stdout
    [Arguments]  ${opid}
    Run  sed -i "s/.*getWorkStdout.call(.*/return aIexecOracleInstance.getWorkStdout.call('${opid}');/g" iexec-oracle/test/rf/getWorkStdoutInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkStdoutInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{stdout} =  Get Regexp Matches  ${truffletest_result.stdout}  stdout:(?P<stdout>.*)  stdout
    [Return]  @{stdout}[0]

Get Work Stderr
    [Arguments]  ${opid}
    Run  sed -i "s/.*getWorkStderr.call(.*/return aIexecOracleInstance.getWorkStderr.call('${opid}');/g" iexec-oracle/test/rf/getWorkStderrInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkStderrInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{stderr} =  Get Regexp Matches  ${truffletest_result.stdout}  stderr:(?P<stderr>.*)  stderr
    [Return]  @{stderr}[0]





