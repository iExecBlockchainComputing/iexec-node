*** Settings ***
Documentation    dappNonReg
Library           OperatingSystem
Library           ArchiveLibrary
Resource  ../Resources/IexecSdk.robot
Suite Setup  Init Test


# to launch tests :
# pybot -d Results ./tests/rf/Ping/dappNonReg.robot

*** Variables ***
${DAPPNAME}
${XW_HOST} =  devxw.iex.ec


*** Test Cases ***

Test Factorial
    Factorial

Test Ffmpeg
    Ffmpeg

Test DockerWithScript
    DockerWithScript

*** Keywords ***

Init Test
    IexecSdk.Init Sdk


Factorial
    [Documentation]  Test Factorial
    [Tags]  dappNonReg
    Prepare Iexec Factorial
    Log  ${DAPPNAME}
    IexecSdk.Iexec An App  iexec-factorial  account login
    ${iexec_result.stderr} =  IexecSdk.Iexec An App  iexec-factorial  server deploy
    @{appUID} =  Get Regexp Matches  ${iexec_result.stderr}  iexec-server-js-client appUID (?P<appUID>.*)  appUID
    Log  @{appUID}[0]
    ${iexec_result.stderr} =  IexecSdk.Iexec An App  iexec-factorial  server submit --app @{appUID}[0]
    Log  ${iexec_result.stderr}
    @{workUID} =  Get Regexp Matches  ${iexec_result.stderr}  iexec-server-js-client workUID (?P<workUID>.*)  workUID
    Log  @{workUID}[0]
    Wait Until Keyword Succeeds  5 min	30 sec  Check Factorial Result  @{workUID}[0]

Prepare Iexec Factorial
    ${rm_result} =  Run Process  rm -rf iexec-factorial  shell=yes
    Should Be Empty	${rm_result.stderr}
    Should Be Equal As Integers	${rm_result.rc}	0
    IexecSdk.Iexec Init An App  factorial
    IexecSdk.Iexec An App  iexec-factorial  wallet create
    Run  sed -i "s/testxw.iex.ec/${XW_HOST}/g" iexec-factorial/truffle.js
    # change the name adress of factorial
    ${wallet} =  Get File  iexec-factorial/wallet.json
    @{address} =  Get Regexp Matches  ${wallet}  "address": "(?P<address>.*)"  address
    ${dappName} =  Catenate  SEPARATOR=  0x  @{address}[0]
    Set Test Variable	${DAPPNAME}	 ${dappName}
    #replace 0xd2b9d3ecc76b6d43277fd986afdb8b79685d4d1a by DAPPNAME
    Run  sed -i "s/0xd2b9d3ecc76b6d43277fd986afdb8b79685d4d1a/${dappName}/g" iexec-factorial/build/contracts/Factorial.json


Check Factorial Result
    [Arguments]  ${workUID}
    IexecSdk.Iexec An App  iexec-factorial  server result ${workUID} --save
    ${result} =  Get File  iexec-factorial/${workUID}.text
    ${lines} =  Get Lines Containing String  ${result}  3628800
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1


Ffmpeg
    [Documentation]  Test Ffmpeg
    [Tags]  dappNonReg
    Prepare Iexec Ffmpeg
    Log  ${DAPPNAME}
    IexecSdk.Iexec An App  iexec-ffmpeg  account login
    ${iexec_result.stderr} =  IexecSdk.Iexec An App  iexec-ffmpeg  server deploy
    @{appUID} =  Get Regexp Matches  ${iexec_result.stderr}  iexec-server-js-client appUID (?P<appUID>.*)  appUID
    Log  @{appUID}[0]
    ${iexec_result.stderr} =  IexecSdk.Iexec An App  iexec-ffmpeg  server submit --app @{appUID}[0]
    Log  ${iexec_result.stderr}
    @{workUID} =  Get Regexp Matches  ${iexec_result.stderr}  iexec-server-js-client workUID (?P<workUID>.*)  workUID
    Log  @{workUID}[0]
    Wait Until Keyword Succeeds  2 min	30 sec  Check Ffmpeg Result  @{workUID}[0]



 Prepare Iexec Ffmpeg
     ${rm_result} =  Run Process  rm -rf iexec-ffmpeg  shell=yes
     Should Be Empty	${rm_result.stderr}
     Should Be Equal As Integers	${rm_result.rc}	0
     IexecSdk.Iexec Init An App  ffmpeg
     IexecSdk.Iexec An App  iexec-ffmpeg   wallet create
     Run  sed -i "s/testxw.iex.ec/${XW_HOST}/g" iexec-ffmpeg/truffle.js
     # change the name adress of ffmpeg
     ${wallet} =  Get File  iexec-ffmpeg/wallet.json
      @{address} =  Get Regexp Matches  ${wallet}  "address": "(?P<address>.*)"  address
      ${dappName} =  Catenate  SEPARATOR=  0x  @{address}[0]
      Set Test Variable	${DAPPNAME}	 ${dappName}
      #replace 0x48db8e153710a865526d1c601bdf393bb68e41fa by DAPPNAME
      Run  sed -i "s/0x48db8e153710a865526d1c601bdf393bb68e41fa/${dappName}/g" iexec-ffmpeg/build/contracts/Ffmpeg.json

Check Ffmpeg Result
    [Arguments]  ${workUID}
    IexecSdk.Iexec An App  iexec-ffmpeg  server result ${workUID} --save
    Archive Should Contain File  iexec-ffmpeg/${workUID}.zip  small.avi

DockerWithScript
    [Documentation]  Test DockerWithScript
    [Tags]  dappNonReg
    Prepare Iexec DockerWithScript
    Log  ${DAPPNAME}
    IexecSdk.Iexec An App  iexec-docker-with-script  account login
    ${iexec_result.stderr} =  IexecSdk.Iexec An App  iexec-docker-with-script  server deploy
    @{appUID} =  Get Regexp Matches  ${iexec_result.stderr}  iexec-server-js-client appUID (?P<appUID>.*)  appUID
    Log  @{appUID}[0]
    ${iexec_result.stderr} =  IexecSdk.Iexec An App  iexec-docker-with-script  server submit --app @{appUID}[0]
    Log  ${iexec_result.stderr}
    @{workUID} =  Get Regexp Matches  ${iexec_result.stderr}  iexec-server-js-client workUID (?P<workUID>.*)  workUID
    Log  @{workUID}[0]
    Wait Until Keyword Succeeds  2 min	30 sec  Check DockerWithScript Result  @{workUID}[0]

Prepare Iexec DockerWithScript
    ${rm_result} =  Run Process  rm -rf iexec-docker-with-script  shell=yes
    Should Be Empty	${rm_result.stderr}
    Should Be Equal As Integers	${rm_result.rc}	0
    IexecSdk.Iexec Init An App  docker-with-script
    IexecSdk.Iexec An App  iexec-docker-with-script  wallet create
    Run  sed -i "s/testxw.iex.ec/${XW_HOST}/g" iexec-docker-with-script/truffle.js
    # change the name adress of iexec-docker-with-script
    ${wallet} =  Get File  iexec-docker-with-script/wallet.json
     @{address} =  Get Regexp Matches  ${wallet}  "address": "(?P<address>.*)"  address
     ${dappName} =  Catenate  SEPARATOR=  0x  @{address}[0]
     Set Test Variable	${DAPPNAME}	 ${dappName}
     #replace 0xa53b2a36b8df7b63c83f76ee6519a62712bcbf4a by DAPPNAME
     Run  sed -i "s/0xa53b2a36b8df7b63c83f76ee6519a62712bcbf4a/${dappName}/g" iexec-docker-with-script/build/contracts/DockerWithScript.json



Check DockerWithScript Result
     [Arguments]  ${workUID}
     IexecSdk.Iexec An App  iexec-docker-with-script  server result ${workUID} --save
     Archive Should Contain File  iexec-docker-with-script/${workUID}.zip  seeYouInMyZip.txt
     Extract Zip File  iexec-docker-with-script/${workUID}.zip    iexec-docker-with-script/zipout
     ${stdout} =  Get File  iexec-docker-with-script/zipout/stdout.txt
     ${lines} =  Get Lines Containing String  ${stdout}  I am the text.txt content
     ${lines_count} =  Get Line Count  ${lines}
     Should Be Equal As Integers	${lines_count}	1
     ${lines} =  Get Lines Containing String  ${stdout}  ShowMethisText
     ${lines_count} =  Get Line Count  ${lines}
     Should Be Equal As Integers	${lines_count}	1
     ${lines} =  Get Lines Containing String  ${stdout}  i am MyFileIniExecDir.txt content
     ${lines_count} =  Get Line Count  ${lines}
     Should Be Equal As Integers	${lines_count}	1
