*** Settings ***
Documentation    dappNonReg
Library           OperatingSystem
Library           ArchiveLibrary

Resource   ./IexecSdkDocker.robot

*** Variables ***
${DAPPNAME}
${XW_HOST}
${REPO_DIR}


*** Keywords ***

Echo In Docker
    [Documentation]  Test Echo In Docker
    [Tags]  dappNonReg
    Prepare Iexec Echo In Docker
    Log  ${DAPPNAME}
    IexecSdkDocker.Iexec An App  iexec-tta-step1  account login
    ${iexec_result.stderr} =  IexecSdkDocker.Iexec An App  iexec-tta-step1  server deploy
    @{appUID} =  Get Regexp Matches  ${iexec_result.stderr}  iexec-server-js-client appUID (?P<appUID>.*)  appUID
    Log  @{appUID}[0]
    ${iexec_result.stderr} =  IexecSdkDocker.Iexec An App  iexec-tta-step1  server submit --app @{appUID}[0]
    Log  ${iexec_result.stderr}
    @{workUID} =  Get Regexp Matches  ${iexec_result.stderr}  iexec-server-js-client workUID (?P<workUID>.*)  workUID
    Log  @{workUID}[0]
    Wait Until Keyword Succeeds  2 min	30 sec  Check Echo In Docker Result  @{workUID}[0]




Prepare Iexec Echo In Docker
    ${rm_result} =  Run Process  rm -rf ${REPO_DIR}/iexec-tta-step1  shell=yes
    Should Be Empty	${rm_result.stderr}
    Should Be Equal As Integers	${rm_result.rc}	0
    IexecSdkDocker.Iexec Init An App  tta-step1
    IexecSdkDocker.Iexec An App  iexec-tta-step1  wallet create
    Run  sed "s/testxw.iex.ec/${XW_HOST}/g" ${REPO_DIR}/iexec-tta-step1/truffle.js > ${REPO_DIR}/iexec-tta-step1/truffle.tmp && cat ${REPO_DIR}/iexec-tta-step1/truffle.tmp > ${REPO_DIR}/iexec-tta-step1/truffle.js
    # change the name adress of tta-step1
    ${wallet} =  Get File  ${REPO_DIR}/iexec-tta-step1/wallet.json
    @{address} =  Get Regexp Matches  ${wallet}  "address": "(?P<address>.*)"  address
    ${dappName} =  Catenate  SEPARATOR=  0x  @{address}[0]
    Set Test Variable	${DAPPNAME}	 ${dappName}_name
    #replace 0xd98f5f5c79254656d080159bb147b7c3b616ac5a by DAPPNAME
    Run  sed "s/0xd98f5f5c79254656d080159bb147b7c3b616ac5a/${DAPPNAME}/g" ${REPO_DIR}/iexec-tta-step1/build/contracts/TTA.json > ${REPO_DIR}/iexec-tta-step1/build/contracts/TTA.tmp && cat ${REPO_DIR}/iexec-tta-step1/build/contracts/TTA.tmp > ${REPO_DIR}/iexec-tta-step1/build/contracts/TTA.json


Check Echo In Docker Result
    [Arguments]  ${workUID}
    IexecSdkDocker.Iexec An App  iexec-tta-step1  server result ${workUID} --save
    ${result} =  Get File  ${REPO_DIR}/iexec-tta-step1/${workUID}.text
    ${lines} =  Get Lines Containing String  ${result}  IamAWorker
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1

Factorial
    [Documentation]  Test Factorial
    [Tags]  dappNonReg
    Prepare Iexec Factorial
    Log  ${DAPPNAME}
    IexecSdkDocker.Iexec An App  iexec-factorial  account login
    ${iexec_result.stderr} =  IexecSdkDocker.Iexec An App  iexec-factorial  server deploy
    @{appUID} =  Get Regexp Matches  ${iexec_result.stderr}  iexec-server-js-client appUID (?P<appUID>.*)  appUID
    Log  @{appUID}[0]
    ${iexec_result.stderr} =  IexecSdkDocker.Iexec An App  iexec-factorial  server submit --app @{appUID}[0]
    Log  ${iexec_result.stderr}
    @{workUID} =  Get Regexp Matches  ${iexec_result.stderr}  iexec-server-js-client workUID (?P<workUID>.*)  workUID
    Log  @{workUID}[0]
    Wait Until Keyword Succeeds  2 min	30 sec  Check Factorial Result  @{workUID}[0]

Prepare Iexec Factorial
    ${rm_result} =  Run Process  rm -rf ${REPO_DIR}/iexec-factorial  shell=yes
    Should Be Empty	${rm_result.stderr}
    Should Be Equal As Integers	${rm_result.rc}	0
    IexecSdkDocker.Iexec Init An App  factorial
    IexecSdkDocker.Iexec An App  iexec-factorial  wallet create
    Run  sed "s/testxw.iex.ec/${XW_HOST}/g" ${REPO_DIR}/iexec-factorial/truffle.js > ${REPO_DIR}/iexec-factorial/truffle.tmp && cat ${REPO_DIR}/iexec-factorial/truffle.tmp > ${REPO_DIR}/iexec-factorial/truffle.js
    # change the name adress of factorial
    ${wallet} =  Get File  ${REPO_DIR}/iexec-factorial/wallet.json
    @{address} =  Get Regexp Matches  ${wallet}  "address": "(?P<address>.*)"  address
    ${dappName} =  Catenate  SEPARATOR=  0x  @{address}[0]
    Set Test Variable	${DAPPNAME}	 ${dappName}_name
    #replace 0xd2b9d3ecc76b6d43277fd986afdb8b79685d4d1a by DAPPNAME
    Run  sed "s/0xd2b9d3ecc76b6d43277fd986afdb8b79685d4d1a/${DAPPNAME}/g" ${REPO_DIR}/iexec-factorial/build/contracts/Factorial.json > ${REPO_DIR}/iexec-factorial/build/contracts/Factorial.tmp && cat ${REPO_DIR}/iexec-factorial/build/contracts/Factorial.tmp > ${REPO_DIR}/iexec-factorial/build/contracts/Factorial.json


Check Factorial Result
    [Arguments]  ${workUID}
    IexecSdkDocker.Iexec An App  iexec-factorial  server result ${workUID} --save
    ${count_zip} =	Count Files In Directory  ${REPO_DIR}/iexec-factorial  *.zip
    ${count_txt} =  Count Files In Directory  ${REPO_DIR}/iexec-factorial  *.text
    ${sum}=  Evaluate  int(${count_zip}) + int(${count_txt})
    Should Be True  ${sum} > 0
    Run Keyword If  ${count_zip} > 0  Check Factorial ZIP  ${workUID}
    Run Keyword If  ${count_txt} > 0  Check Factorial TXT  ${workUID}


Check Factorial TXT
    [Arguments]  ${workUID}
    ${result} =  Get File  ${REPO_DIR}/iexec-factorial/${workUID}.text
    ${lines} =  Get Lines Containing String  ${result}  3628800
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1

Check Factorial ZIP
    [Arguments]  ${workUID}
    Extract Zip File  ${REPO_DIR}/iexec-factorial/${workUID}.zip  ${REPO_DIR}/iexec-factorial/zipout
    ${result} =  Get File  ${REPO_DIR}/iexec-factorial/zipout/stdout.txt
    ${lines} =  Get Lines Containing String  ${result}  3628800
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1

Ffmpeg
    [Documentation]  Test Ffmpeg
    [Tags]  dappNonReg
    Prepare Iexec Ffmpeg
    Log  ${DAPPNAME}
    IexecSdkDocker.Iexec An App  iexec-ffmpeg  account login
    ${iexec_result.stderr} =  IexecSdkDocker.Iexec An App  iexec-ffmpeg  server deploy
    @{appUID} =  Get Regexp Matches  ${iexec_result.stderr}  iexec-server-js-client appUID (?P<appUID>.*)  appUID
    Log  @{appUID}[0]
    ${iexec_result.stderr} =  IexecSdkDocker.Iexec An App  iexec-ffmpeg  server submit --app @{appUID}[0]
    Log  ${iexec_result.stderr}
    @{workUID} =  Get Regexp Matches  ${iexec_result.stderr}  iexec-server-js-client workUID (?P<workUID>.*)  workUID
    Log  @{workUID}[0]
    Wait Until Keyword Succeeds  2 min	30 sec  Check Ffmpeg Result  @{workUID}[0]



Prepare Iexec Ffmpeg
   ${rm_result} =  Run Process  rm -rf ${REPO_DIR}/iexec-ffmpeg  shell=yes
   Should Be Empty	${rm_result.stderr}
   Should Be Equal As Integers	${rm_result.rc}	0
   IexecSdkDocker.Iexec Init An App  ffmpeg
   IexecSdkDocker.Iexec An App  iexec-ffmpeg   wallet create
   Run  sed "s/testxw.iex.ec/${XW_HOST}/g" ${REPO_DIR}/iexec-ffmpeg/truffle.js > ${REPO_DIR}/iexec-ffmpeg/truffle.tmp && cat ${REPO_DIR}/iexec-ffmpeg/truffle.tmp > ${REPO_DIR}/iexec-ffmpeg/truffle.js
   # change the name adress of ffmpeg
   ${wallet} =  Get File  ${REPO_DIR}/iexec-ffmpeg/wallet.json
    @{address} =  Get Regexp Matches  ${wallet}  "address": "(?P<address>.*)"  address
    ${dappName} =  Catenate  SEPARATOR=  0x  @{address}[0]
    Set Test Variable	${DAPPNAME}	 ${dappName}_name
    #replace 0x48db8e153710a865526d1c601bdf393bb68e41fa by DAPPNAME
    Run  sed "s/0x48db8e153710a865526d1c601bdf393bb68e41fa/${DAPPNAME}/g" ${REPO_DIR}/iexec-ffmpeg/build/contracts/Ffmpeg.json > ${REPO_DIR}/iexec-ffmpeg/build/contracts/Ffmpeg.tmp && cat ${REPO_DIR}/iexec-ffmpeg/build/contracts/Ffmpeg.tmp > ${REPO_DIR}/iexec-ffmpeg/build/contracts/Ffmpeg.json

Check Ffmpeg Result
    [Arguments]  ${workUID}
    IexecSdkDocker.Iexec An App  iexec-ffmpeg  server result ${workUID} --save
    Archive Should Contain File  ${REPO_DIR}/iexec-ffmpeg/${workUID}.zip  small.avi

DockerWithScript
    [Documentation]  Test DockerWithScript
    [Tags]  dappNonReg
    Prepare Iexec DockerWithScript
    Log  ${DAPPNAME}
    IexecSdkDocker.Iexec An App  iexec-docker-with-script  account login
    ${iexec_result.stderr} =  IexecSdkDocker.Iexec An App  iexec-docker-with-script  server deploy
    @{appUID} =  Get Regexp Matches  ${iexec_result.stderr}  iexec-server-js-client appUID (?P<appUID>.*)  appUID
    Log  @{appUID}[0]
    ${iexec_result.stderr} =  IexecSdkDocker.Iexec An App  iexec-docker-with-script  server submit --app @{appUID}[0]
    Log  ${iexec_result.stderr}
    @{workUID} =  Get Regexp Matches  ${iexec_result.stderr}  iexec-server-js-client workUID (?P<workUID>.*)  workUID
    Log  @{workUID}[0]
    Wait Until Keyword Succeeds  2 min	30 sec  Check DockerWithScript Result  @{workUID}[0]

Prepare Iexec DockerWithScript
    ${rm_result} =  Run Process  rm -rf ${REPO_DIR}/iexec-docker-with-script  shell=yes
    Should Be Empty	${rm_result.stderr}
    Should Be Equal As Integers	${rm_result.rc}	0
    IexecSdkDocker.Iexec Init An App  docker-with-script
    IexecSdkDocker.Iexec An App  iexec-docker-with-script  wallet create
    Run  sed "s/testxw.iex.ec/${XW_HOST}/g" ${REPO_DIR}/iexec-docker-with-script/truffle.js > ${REPO_DIR}/iexec-docker-with-script/truffle.tmp && cat ${REPO_DIR}/iexec-docker-with-script/truffle.tmp > ${REPO_DIR}/iexec-docker-with-script/truffle.js
    # change the name adress of iexec-docker-with-script
    ${wallet} =  Get File  ${REPO_DIR}/iexec-docker-with-script/wallet.json
     @{address} =  Get Regexp Matches  ${wallet}  "address": "(?P<address>.*)"  address
     ${dappName} =  Catenate  SEPARATOR=  0x  @{address}[0]
     Set Test Variable	${DAPPNAME}	 ${dappName}
     #replace 0xa53b2a36b8df7b63c83f76ee6519a62712bcbf4a by DAPPNAME
     Run  sed "s/0xa53b2a36b8df7b63c83f76ee6519a62712bcbf4a/${DAPPNAME}/g" ${REPO_DIR}/iexec-docker-with-script/build/contracts/DockerWithScript.json > ${REPO_DIR}/iexec-docker-with-script/build/contracts/DockerWithScript.tmp && cat ${REPO_DIR}/iexec-docker-with-script/build/contracts/DockerWithScript.tmp > ${REPO_DIR}/iexec-docker-with-script/build/contracts/DockerWithScript.json



Check DockerWithScript Result
     [Arguments]  ${workUID}
     IexecSdkDocker.Iexec An App  iexec-docker-with-script  server result ${workUID} --save
     Archive Should Contain File  ${REPO_DIR}/iexec-docker-with-script/${workUID}.zip  seeYouInMyZip.txt
     Extract Zip File  ${REPO_DIR}/iexec-docker-with-script/${workUID}.zip    ${REPO_DIR}/iexec-docker-with-script/zipout
     ${stdout} =  Get File  ${REPO_DIR}/iexec-docker-with-script/zipout/stdout.txt
     ${lines} =  Get Lines Containing String  ${stdout}  I am the text.txt content
     ${lines_count} =  Get Line Count  ${lines}
     Should Be Equal As Integers	${lines_count}	1
     ${lines} =  Get Lines Containing String  ${stdout}  ShowMethisText
     ${lines_count} =  Get Line Count  ${lines}
     Should Be Equal As Integers	${lines_count}	1
     ${lines} =  Get Lines Containing String  ${stdout}  i am MyFileInAppDir.txt content
     ${lines_count} =  Get Line Count  ${lines}
     Should Be Equal As Integers	${lines_count}	1
     ${lines} =  Get Lines Containing String  ${stdout}  This is my scriptAtRoot.sh in docker
     ${lines_count} =  Get Line Count  ${lines}
     Should Be Equal As Integers	${lines_count}	1
     ${lines} =  Get Lines Containing String  ${stdout}  i am fileAtRoot.txt content
     ${lines_count} =  Get Line Count  ${lines}
     Should Be Equal As Integers	${lines_count}	1
