*** Settings ***

*** Variables ***

*** Keywords ***

Check Submit Event In IexceOracleSmartContract
    [Arguments]  ${provider}  ${appName}  ${args}
    ${watch_callback_events} =  Wait Until Keyword Succeeds  1 min  1 min  Watch Submit
    Should Be Equal As Strings  ${watch_callback_events[0]["event"]}  Submit
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["appName"]}  ${appName}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["args"]}  ${args}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["user"]}  ${USER}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["creator"]}  ${CREATOR}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["provider"]}  ${provider}


Check SubmitCallback Event In IexceOracleSmartContract
    [Arguments]  ${submitTxHash}  ${user}  ${appName}  ${stdout}
    ${watch_callback_events} =  Wait Until Keyword Succeeds  1 min  1 min  Watch SubmitCallback
    Should Be Equal As Strings  ${watch_callback_events[0]["event"]}  SubmitCallback
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["submitTxHash"]}  ${submitTxHash}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["user"]}  ${user}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["appName"]}  ${appName}
    Should Be Equal As Strings  ${watch_callback_events[0]["args"]["stdout"]}  ${stdout}


Check Work Is Recorded in IexceOracleSmartContract After Submit
    [Arguments]  ${submitTxHash}  ${provider}  ${appName}
    @{work_result} =  Get Work  ${submitTxHash}
    ${workuid} =  Get Work Uid  ${submitTxHash}
    Should Be Equal As Strings  ${workuid}  @{work_result}[0]
    ${work_name} =  Get Work AppName  ${submitTxHash}
    Should Be Equal As Strings  ${work_name}  @{work_result}[1]
    Should Be Equal As Strings  ${work_name}  ${appName}
    ${work_timestamp} =  Get Work Timestamp  ${submitTxHash}
    Should Be Equal As Strings  ${work_timestamp}  @{work_result}[2]
    ${work_status} =  Get Work Status  ${submitTxHash}
    Should Be Equal As Strings  ${work_status}  @{work_result}[3]
    ${work_stdout} =  Get Work Stdout  ${submitTxHash}
    Should Be Equal As Strings  ${work_stdout}  @{work_result}[4]
    ${work_stderr} =  Get Work Stderr  ${submitTxHash}
    Should Be Equal As Strings  ${work_stderr}  @{work_result}[5]
    Should Be Empty  ${work_stderr}

Watch SubmitCallback
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/watchSubmitCallbackInIexecOracle.js  shell=yes
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
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/watchSubmitInIexecOracle.js  shell=yes
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
    [Arguments]  ${submitTxHash}
    Run  sed -i "s/.*getWork.call(.*/return aIexecOracleInstance.getWork.call('${submitTxHash}');/g" iexec-oracle/test/rf/getWorkInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{workuid} =  Get Regexp Matches  ${truffletest_result.stdout}  workuid:(?P<workuid>.*)  workuid
    @{appName} =  Get Regexp Matches  ${truffletest_result.stdout}  appName:(?P<appName>.*)  appName
    @{timestamp} =  Get Regexp Matches  ${truffletest_result.stdout}  timestamp:(?P<timestamp>.*)  timestamp
    @{status} =  Get Regexp Matches  ${truffletest_result.stdout}  status:(?P<status>.*)  status
    @{stdout} =  Get Regexp Matches  ${truffletest_result.stdout}  stdout:(?P<stdout>.*)  stdout
    @{stderr} =  Get Regexp Matches  ${truffletest_result.stdout}  stderr:(?P<stderr>.*)  stderr
    @{work_result} =  Create List  @{workuid}[0]  @{appName}[0]  @{timestamp}[0]  @{status}[0]  @{stdout}[0]  @{stderr}[0]
    [Return]  @{work_result}


Get Work Uid
    [Arguments]  ${submitTxHash}
    Run  sed -i "s/.*getWorkUid.call(.*/return aIexecOracleInstance.getWorkUid.call('${submitTxHash}');/g" iexec-oracle/test/rf/getWorkUidInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkUidInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{workuid} =  Get Regexp Matches  ${truffletest_result.stdout}  workuid:(?P<workuid>.*)  workuid
    [Return]  @{workuid}[0]

Get Work AppName
    [Arguments]  ${submitTxHash}
    Run  sed -i "s/.*getWorkAppName.call(.*/return aIexecOracleInstance.getWorkAppName.call('${submitTxHash}');/g" iexec-oracle/test/rf/getWorkAppNameInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkAppNameInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{appName} =  Get Regexp Matches  ${truffletest_result.stdout}  appName:(?P<appName>.*)  appName
    [Return]  @{appName}[0]

Get Work Timestamp
    [Arguments]  ${submitTxHash}
    Run  sed -i "s/.*getWorkTimestamp.call(.*/return aIexecOracleInstance.getWorkTimestamp.call('${submitTxHash}');/g" iexec-oracle/test/rf/getWorkTimestampInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkTimestampInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{timestamp} =  Get Regexp Matches  ${truffletest_result.stdout}  timestamp:(?P<timestamp>.*)  timestamp
    [Return]  @{timestamp}[0]

Get Work Status
    [Arguments]  ${submitTxHash}
    Run  sed -i "s/.*getWorkStatus.call(.*/return aIexecOracleInstance.getWorkStatus.call('${submitTxHash}');/g" iexec-oracle/test/rf/getWorkStatusInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkStatusInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{status} =  Get Regexp Matches  ${truffletest_result.stdout}  status:(?P<status>.*)  status
    [Return]  @{status}[0]

Get Work Stdout
    [Arguments]  ${submitTxHash}
    Run  sed -i "s/.*getWorkStdout.call(.*/return aIexecOracleInstance.getWorkStdout.call('${submitTxHash}');/g" iexec-oracle/test/rf/getWorkStdoutInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkStdoutInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{stdout} =  Get Regexp Matches  ${truffletest_result.stdout}  stdout:(?P<stdout>.*)  stdout
    [Return]  @{stdout}[0]

Get Work Stderr
    [Arguments]  ${submitTxHash}
    Run  sed -i "s/.*getWorkStderr.call(.*/return aIexecOracleInstance.getWorkStderr.call('${submitTxHash}');/g" iexec-oracle/test/rf/getWorkStderrInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkStderrInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{stderr} =  Get Regexp Matches  ${truffletest_result.stdout}  stderr:(?P<stderr>.*)  stderr
    [Return]  @{stderr}[0]





