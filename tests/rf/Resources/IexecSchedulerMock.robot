*** Settings ***
Library  String

*** Variables ***
${REPO_DIR}
${IEXEC_SCHEDULER_MOCK_GIT_URL} =  https://github.com/iExecBlockchainComputing/iexec-scheduler-mock.git
${IEXEC_SCHEDULER_MOCK_GIT_BRANCH} =  master
${IEXEC_SCHEDULER_MOCK_FORCE_GIT_CLONE} =  true
${IEXEC_SCHEDULER_MOCK_PROCESS}
${DOCKER_NETWORK} =  docker_iexec-net
${IEXEC_SCHEDULER_MOCK_CONTAINER_ID}
${IEXEC_SCHEDULER_IP_IN_DOCKER_NETWORK}


*** Keywords ***

Git Clone Iexec Scheduler Mock
    Directory Should Exist  ${REPO_DIR}
    Remove Directory  ${REPO_DIR}/iexec-scheduler-mock  recursive=true
    ${git_result} =  Run Process  cd ${REPO_DIR} && git clone -b ${IEXEC_SCHEDULER_MOCK_GIT_BRANCH} ${IEXEC_SCHEDULER_MOCK_GIT_URL}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0

Gradle Build Iexec Scheduler Mock
    Run Keyword If  '${IEXEC_SCHEDULER_MOCK_FORCE_GIT_CLONE}' == 'true'  Git Clone Iexec Scheduler Mock
    Directory Should Exist  ${REPO_DIR}/iexec-scheduler-mock
    Run  sed -i '/compile "com.iexec.scheduler:iexec-scheduler*/d' ${REPO_DIR}/iexec-scheduler-mock/build.gradle
    Run  sed -i 's/\\/\\/compile files/compile files/g' ${REPO_DIR}/iexec-scheduler-mock/build.gradle
    ${gradle_result} =  Run Process  cd ${REPO_DIR}/iexec-scheduler-mock && ./gradlew build  shell=yes
    Log  ${gradle_result.stderr}
    Log  ${gradle_result.stdout}
    Should Be Equal As Integers	${gradle_result.rc}	0



Docker Run Iexec Scheduler Mock
    Gradle Build Iexec Scheduler Mock
    Set RlcAddress IexecHubAddress Conf
    Set PoCo Geth IP Conf
    Run Keyword If  '${GETH_POCO_WORKERPOOL_CREATED_AT_START}' != '${EMPTY}'  Set WorkerPoolAddress Conf
    Desactivate All Scheduler Mock
    ${result} =  Run Process  cd ${REPO_DIR}/iexec-scheduler-mock && docker build -t iexechub/iexec-scheduler-mock .  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers	${result.rc}	0
    Remove File  ${REPO_DIR}/iexec-scheduler-mock.log
    Create File  ${REPO_DIR}/iexec-scheduler-mock.log
    ${created_process} =  Start Process  cd ${REPO_DIR}/iexec-scheduler-mock && docker run --net ${DOCKER_NETWORK} -v `pwd`/src/main/resources/:/src/main/resources/ iexechub/iexec-scheduler-mock  shell=yes  stderr=STDOUT  stdout=${REPO_DIR}/iexec-scheduler-mock.log
    Set Suite Variable  ${IEXEC_SCHEDULER_MOCK_PROCESS}  ${created_process}
    ${container_id} =  Wait Until Keyword Succeeds  5 min	10 sec  DockerHelper.Get Docker Container Id From Image  iexechub/iexec-scheduler-mock
    Log  ${container_id}
    Set Suite Variable  ${IEXEC_SCHEDULER_MOCK_CONTAINER_ID}  ${container_id}
    Wait Until Keyword Succeeds  3 min	 5 sec  Check Scheduler Mock Initialized

    ${result} =  Run Process  docker inspect ${IEXEC_SCHEDULER_MOCK_CONTAINER_ID}  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers  ${result.rc}  0
    @{IPAddress} =  Get Regexp Matches  ${result.stdout}  "IPAddress": "1(?P<IPAddress>.*)"  IPAddress
    Log  @{IPAddress}[0]
    ${ip} =  Catenate  SEPARATOR=  1  @{IPAddress}[0]
    Set Suite Variable  ${IEXEC_SCHEDULER_IP_IN_DOCKER_NETWORK}  ${ip}



Gradle Build BootRun Iexec Scheduler Mock
    Gradle Build Iexec Scheduler Mock
    Set RlcAddress IexecHubAddress Conf
    Desactivate All Scheduler Mock
    Gradle BootRun Scheduler

Gradle Build BootRun Iexec Scheduler Mock Active
    Gradle Build Iexec Scheduler Mock
    Set RlcAddress IexecHubAddress Conf
    Activate All Scheduler Mock
    Gradle BootRun Scheduler


Activate All Scheduler Mock
    File Should Exist  ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/application.yml
    Run  cat ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/application.yml|sed 's/active: false/active: true/g' >${REPO_DIR}/iexec-scheduler-mock/src/main/resources/application.tmp
    File Should Exist  ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/application.tmp
    Run  cat ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/application.tmp >${REPO_DIR}/iexec-scheduler-mock/src/main/resources/application.yml


Desactivate All Scheduler Mock
    File Should Exist  ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/application.yml
    Run  cat ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/application.yml|sed 's/active: true/active: false/g' >${REPO_DIR}/iexec-scheduler-mock/src/main/resources/application.tmp
    File Should Exist  ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/application.tmp
    Run  cat ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/application.tmp >${REPO_DIR}/iexec-scheduler-mock/src/main/resources/application.yml

Set PoCo Geth IP Conf
    File Should Exist  ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.yml
    Run  cat ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.yml|sed 's/localhost/${GETH_POCO_IP_IN_DOCKER_NETWORK}/g' >${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.tmp
    File Should Exist  ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.tmp
    Run  cat ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.tmp >${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.yml

Set RlcAddress IexecHubAddress Conf
    File Should Exist  ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.yml
    Run  cat ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.yml|sed 's/rlcAddress: 0xCHANGE_IT/rlcAddress: 0x091233035dcb12ae5a4a4b7fb144d3c5189892e1/g'|sed 's/iexecHubAddress: 0xCHANGE_IT/iexecHubAddress: 0xc4e4a08bf4c6fd11028b714038846006e27d7be8/g' >${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.tmp
    File Should Exist  ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.tmp
    Run  cat ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.tmp >${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.yml

Set WorkerPoolAddress Conf
    File Should Exist  ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.yml
    Run  cat ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.yml|sed 's/address: /address: ${GETH_POCO_WORKERPOOL_CREATED_AT_START} /g' >${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.tmp
    File Should Exist  ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.tmp
    Run  cat ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.tmp >${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.yml

Gradle BootRun Scheduler
    Remove File  ${REPO_DIR}/iexec-scheduler-mock.log
    Create File  ${REPO_DIR}/iexec-scheduler-mock.log
    ${created_process} =  Start Process  cd ${REPO_DIR}/iexec-scheduler-mock && ./gradlew bootRun  shell=yes  stderr=STDOUT  stdout=${REPO_DIR}/iexec-scheduler-mock.log
    Set Suite Variable  ${IEXEC_SCHEDULER_MOCK_PROCESS}  ${created_process}
    Wait Until Keyword Succeeds  3 min	 5 sec  Check Scheduler Mock Initialized

Check Scheduler Mock Initialized
    ${logs} =  Get File  ${REPO_DIR}/iexec-scheduler-mock.log
    ${lines} =  Get Lines Containing String  ${logs}  com.iexec.scheduler.mock.Application - Started Application in
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1

Get Scheduler Mock Log
    ${logs} =  GET FILE  ${REPO_DIR}/iexec-scheduler-mock.log
    LOG  ${logs}
    [Return]  ${logs}

Stop Scheduler Mock
    Get Scheduler Mock Log
    Desactivate All Scheduler Mock
    Terminate Process  ${IEXEC_SCHEDULER_MOCK_PROCESS}

Docker Stop Scheduler Mock
    DockerHelper.Stop Log And Remove Container  ${IEXEC_SCHEDULER_MOCK_CONTAINER_ID}
    Desactivate All Scheduler Mock
    Terminate Process  ${IEXEC_SCHEDULER_MOCK_PROCESS}


Curl On Scheduler Mock
    [Arguments]  ${URL}
    ${curl_result} =  Run Process  docker run --rm --net ${DOCKER_NETWORK} appropriate/curl http://${IEXEC_SCHEDULER_IP_IN_DOCKER_NETWORK}:8080/${URL}  shell=yes
    Log  ${curl_result.stdout}
    Log  ${curl_result.stderr}
    Should Be Equal As Integers  ${curl_result.rc}  0
    [Return]  ${curl_result.stdout}

