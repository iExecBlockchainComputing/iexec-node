*** Settings ***

*** Variables ***

*** Keywords ***

Check Submit Launch Event In IexceOracleSmartContract
    [Arguments]  ${provider}
    ${watch_launch_event} =  Wait Until Keyword Succeeds  3 min  1 min  Watch LaunchEvent
    Should Contain  ${watch_launch_event}  functionName: 'submit'
    Should Contain  ${watch_launch_event}  param1: 'echo'
    Should Contain  ${watch_launch_event}  user: '${USER}'
    Should Contain  ${watch_launch_event}  creator: '${CREATOR}'
    Should Contain  ${watch_launch_event}  provider: '${provider}'


Check Submit CallbackEvent Event In IexceOracleSmartContract
    [Arguments]  ${provider}
    ${watch_callback_event} =  Wait Until Keyword Succeeds  3 min  1 min  Watch CallbackEvent
    Should Contain  ${watch_callback_event}  event: 'CallbackEvent'
    Should Contain  ${watch_callback_event}  callbackType: 'SubmitCallback'
    Should Contain  ${watch_callback_event}  appName: 'echo'
    Should Contain  ${watch_callback_event}  user: '${USER}'
    Should Contain  ${watch_callback_event}  creator: '${CREATOR}'
    Should Contain  ${watch_callback_event}  provider: '${provider}'
    @{work_uid} =  Get Regexp Matches  ${watch_callback_event}  workUid: '(?P<work_uid>.*)',  work_uid
    [Return]  @{work_uid}[0]

Check Work Is Recorded in IexceOracleSmartContract After Submit
    [Arguments]  ${work_uid}  ${provider}
    @{work_result} =  Get Work  ${USER}  ${provider}  ${work_uid}
    ${work_name} =  Get Work Name  ${USER}  ${provider}  ${work_uid}
    Should Be Equal As Strings  ${work_name}  @{work_result}[0]
    Should Be Equal As Strings  ${work_name}  echo
    ${work_timestamp} =  Get Work Timestamp  ${USER}  ${provider}  ${work_uid}
    Should Be Equal As Strings  ${work_timestamp}  @{work_result}[1]
    ${work_status} =  Get Work Status  ${USER}  ${provider}  ${work_uid}
    Should Be Equal As Strings  ${work_status}  @{work_result}[2]
    ${work_stdout} =  Get Work Stdout  ${USER}  ${provider}  ${work_uid}
    Should Be Equal As Strings  ${work_stdout}  @{work_result}[3]
    ${work_stderr} =  Get Work Stderr  ${USER}  ${provider}  ${work_uid}
    Should Be Equal As Strings  ${work_stderr}  @{work_result}[4]
    Should Be Empty  ${work_stderr}

Watch CallbackEvent
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/watchCallbackEventInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    #TODO PARSE JSON
    [Return]  ${truffletest_result.stdout}

Watch LaunchEvent
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/watchLaunchEventInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    #TODO PARSE JSON
    [Return]  ${truffletest_result.stdout}

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
    [Arguments]  ${user}  ${provider}  ${uid}
    Run  sed -i "s/.*getWork.call(.*/return aIexecOracleInstance.getWork.call('${user}','${provider}',\\"${uid}\\");/g" iexec-oracle/test/rf/getWorkInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{name} =  Get Regexp Matches  ${truffletest_result.stdout}  name:(?P<name>.*)  name
    @{timestamp} =  Get Regexp Matches  ${truffletest_result.stdout}  timestamp:(?P<timestamp>.*)  timestamp
    @{status} =  Get Regexp Matches  ${truffletest_result.stdout}  status:(?P<status>.*)  status
    @{stdout} =  Get Regexp Matches  ${truffletest_result.stdout}  stdout:(?P<stdout>.*)  stdout
    @{stderr} =  Get Regexp Matches  ${truffletest_result.stdout}  stderr:(?P<stderr>.*)  stderr
    @{work_result} =  Create List  @{name}[0]  @{timestamp}[0]  @{status}[0]  @{stdout}[0]  @{stderr}[0]
    [Return]  @{work_result}


Get Work Name
    [Arguments]  ${user}  ${provider}  ${uid}
    Run  sed -i "s/.*getWorkName.call(.*/return aIexecOracleInstance.getWorkName.call('${user}','${provider}',\\"${uid}\\");/g" iexec-oracle/test/rf/getWorkNameInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkNameInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{name} =  Get Regexp Matches  ${truffletest_result.stdout}  name:(?P<name>.*)  name
    [Return]  @{name}[0]

Get Work Timestamp
    [Arguments]  ${user}  ${provider}  ${uid}
    Run  sed -i "s/.*getWorkTimestamp.call(.*/return aIexecOracleInstance.getWorkTimestamp.call('${user}','${provider}',\\"${uid}\\");/g" iexec-oracle/test/rf/getWorkTimestampInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkTimestampInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{timestamp} =  Get Regexp Matches  ${truffletest_result.stdout}  timestamp:(?P<timestamp>.*)  timestamp
    [Return]  @{timestamp}[0]

Get Work Status
    [Arguments]  ${user}  ${provider}  ${uid}
    Run  sed -i "s/.*getWorkStatus.call(.*/return aIexecOracleInstance.getWorkStatus.call('${user}','${provider}',\\"${uid}\\");/g" iexec-oracle/test/rf/getWorkStatusInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkStatusInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{status} =  Get Regexp Matches  ${truffletest_result.stdout}  status:(?P<status>.*)  status
    [Return]  @{status}[0]

Get Work Stdout
    [Arguments]  ${user}  ${provider}  ${uid}
    Run  sed -i "s/.*getWorkStdout.call(.*/return aIexecOracleInstance.getWorkStdout.call('${user}','${provider}',\\"${uid}\\");/g" iexec-oracle/test/rf/getWorkStdoutInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkStdoutInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{stdout} =  Get Regexp Matches  ${truffletest_result.stdout}  stdout:(?P<stdout>.*)  stdout
    [Return]  @{stdout}[0]

Get Work Stderr
    [Arguments]  ${user}  ${provider}  ${uid}
    Run  sed -i "s/.*getWorkStderr.call(.*/return aIexecOracleInstance.getWorkStderr.call('${user}','${provider}',\\"${uid}\\");/g" iexec-oracle/test/rf/getWorkStderrInIexecOracle.js
    ${truffletest_result} =  Run Process  cd iexec-oracle && ./node_modules/.bin/truffle test test/rf/getWorkStderrInIexecOracle.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    @{stderr} =  Get Regexp Matches  ${truffletest_result.stdout}  stderr:(?P<stderr>.*)  stderr
    [Return]  @{stderr}[0]





