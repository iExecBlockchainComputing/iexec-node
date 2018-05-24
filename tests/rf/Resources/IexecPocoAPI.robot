*** Settings ***
Library  String

*** Variables ***
${REPO_DIR}
${IEXEC_POCO_API_GIT_URL} =  https://github.com/iExecBlockchainComputing/iexec-poco-api.git
${IEXEC_POCO_API_GIT_BRANCH} =  master
${IEXEC_POCO_API_FORCE_GIT_CLONE} =  true
${IEXEC_POCO_API_PROCESS}
${DOCKER_NETWORK} =  docker_iexec-net
${IEXEC_POCO_API_CONTAINER_ID}
${IEXEC_POCO_API_IP_IN_DOCKER_NETWORK}
${GETH_POCO_RLCCONTRACT} =  0x091233035dcb12ae5a4a4b7fb144d3c5189892e1
${GETH_POCO_IEXECHUBCONTRACT} =  0xc4e4a08bf4c6fd11028b714038846006e27d7be8


*** Keywords ***

Git Clone Iexec Poco Api
    Directory Should Exist  ${REPO_DIR}
    Remove Directory  ${REPO_DIR}/iexec-poco-api  recursive=true
    ${git_result} =  Run Process  cd ${REPO_DIR} && git clone -b ${IEXEC_POCO_API_GIT_BRANCH} ${IEXEC_POCO_API_GIT_URL}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0

Gradle Build Iexec Poco Api
    Run Keyword If  '${IEXEC_POCO_API_FORCE_GIT_CLONE}' == 'true'  Git Clone Iexec Poco Api
    Directory Should Exist  ${REPO_DIR}/iexec-poco-api
    Run  sed -i '/compile "com.iexec.scheduler:iexec-scheduler*/d' ${REPO_DIR}/iexec-poco-api/build.gradle
    Run  sed -i 's/\\/\\/compile files/compile files/g' ${REPO_DIR}/iexec-poco-api/build.gradle
    ${gradle_result} =  Run Process  cd ${REPO_DIR}/iexec-poco-api && ./gradlew build --refresh-dependencies  shell=yes
    Log  ${gradle_result.stderr}
    Log  ${gradle_result.stdout}
    Should Be Equal As Integers	${gradle_result.rc}	0


Docker Run Iexec Poco Api
    Gradle Build Iexec Poco Api
    Run Keyword If  '${GETH_POCO_WORKERPOOL_CREATED_AT_START}' != '${EMPTY}'  Set WorkerPoolAddress Conf Iexec Poco Api
    Set RlcAddress IexecHubAddress Conf Iexec Poco Api
    Set PoCo Geth IP Conf Iexec Poco Api
    ${result} =  Run Process  cd ${REPO_DIR}/iexec-poco-api && docker build -t iexechub/iexec-poco-api .  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers	${result.rc}	0
    Remove File  ${REPO_DIR}/iexec-poco-api.log
    Create File  ${REPO_DIR}/iexec-poco-api.log
    ${created_process} =  Start Process  cd ${REPO_DIR}/iexec-poco-api && docker run --net ${DOCKER_NETWORK} -v `pwd`/src/main/resources/:/src/main/resources/ iexechub/iexec-poco-api  shell=yes  stderr=STDOUT  stdout=${REPO_DIR}/iexec-poco-api.log
    Set Suite Variable  ${IEXEC_POCO_API_PROCESS}  ${created_process}
    ${container_id} =  Wait Until Keyword Succeeds  5 min	10 sec  DockerHelper.Get Docker Container Id From Image  iexechub/iexec-poco-api
    Log  ${container_id}
    Set Suite Variable  ${IEXEC_POCO_API_CONTAINER_ID}  ${container_id}
    Wait Until Keyword Succeeds  3 min	 5 sec  Check Iexec Poco Api Initialized

    ${result} =  Run Process  docker inspect ${IEXEC_POCO_API_CONTAINER_ID}  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers  ${result.rc}  0
    @{IPAddress} =  Get Regexp Matches  ${result.stdout}  "IPAddress": "1(?P<IPAddress>.*)"  IPAddress
    Log  @{IPAddress}[0]
    ${ip} =  Catenate  SEPARATOR=  1  @{IPAddress}[0]
    Set Suite Variable  ${IEXEC_POCO_API_IP_IN_DOCKER_NETWORK}  ${ip}



Gradle Build BootRun Iexec Poco Api
    Gradle Build Iexec Poco Api
    Set RlcAddress IexecHubAddress Conf Iexec Poco Api
    Gradle BootRun Iexec Poco Api


Set PoCo Geth IP Conf Iexec Poco Api
    File Should Exist  ${REPO_DIR}/iexec-poco-api/src/main/resources/iexec-scheduler.yml
    Run  cat ${REPO_DIR}/iexec-poco-api/src/main/resources/iexec-scheduler.yml|sed 's/localhost/${GETH_POCO_IP_IN_DOCKER_NETWORK}/g' >${REPO_DIR}/iexec-poco-api/src/main/resources/iexec-scheduler.tmp
    File Should Exist  ${REPO_DIR}/iexec-poco-api/src/main/resources/iexec-scheduler.tmp
    Run  cat ${REPO_DIR}/iexec-poco-api/src/main/resources/iexec-scheduler.tmp >${REPO_DIR}/iexec-poco-api/src/main/resources/iexec-scheduler.yml

Set RlcAddress IexecHubAddress Conf Iexec Poco Api
    File Should Exist  ${REPO_DIR}/iexec-poco-api/src/main/resources/iexec-scheduler.yml
    Run  cat ${REPO_DIR}/iexec-poco-api/src/main/resources/iexec-scheduler.yml|sed 's/rlcAddress:*/rlcAddress: ${GETH_POCO_RLCCONTRACT}/g'|sed 's/iexecHubAddress:*/iexecHubAddress: ${GETH_POCO_IEXECHUBCONTRACT}/g' >${REPO_DIR}/iexec-poco-api/src/main/resources/iexec-scheduler.tmp
    File Should Exist  ${REPO_DIR}/iexec-poco-api/src/main/resources/iexec-scheduler.tmp
    Run  cat ${REPO_DIR}/iexec-poco-api/src/main/resources/iexec-scheduler.tmp >${REPO_DIR}/iexec-poco-api/src/main/resources/iexec-scheduler.yml

Set WorkerPoolAddress Conf Iexec Poco Api
    File Should Exist  ${REPO_DIR}/iexec-poco-api/src/main/resources/iexec-scheduler.yml
    Run  cat ${REPO_DIR}/iexec-poco-api/src/main/resources/iexec-scheduler.yml|sed 's/address: /address: ${GETH_POCO_WORKERPOOL_CREATED_AT_START} /g' >${REPO_DIR}/iexec-poco-api/src/main/resources/iexec-scheduler.tmp
    File Should Exist  ${REPO_DIR}/iexec-poco-api/src/main/resources/iexec-scheduler.tmp
    Run  cat ${REPO_DIR}/iexec-poco-api/src/main/resources/iexec-scheduler.tmp >${REPO_DIR}/iexec-poco-api/src/main/resources/iexec-scheduler.yml

Gradle BootRun Iexec Poco Api
    Remove File  ${REPO_DIR}/iexec-poco-api.log
    Create File  ${REPO_DIR}/iexec-poco-api.log
    ${created_process} =  Start Process  cd ${REPO_DIR}/iexec-poco-api && ./gradlew bootRun  shell=yes  stderr=STDOUT  stdout=${REPO_DIR}/iexec-poco-api.log
    Set Suite Variable  ${IEXEC_POCO_API_PROCESS}  ${created_process}
    Wait Until Keyword Succeeds  3 min	 5 sec  Check Scheduler Mock Initialized

Check Iexec Poco Api Initialized
    ${logs} =  Get File  ${REPO_DIR}/iexec-poco-api.log
    ${lines} =  Get Lines Containing String  ${logs}  com.iexec.poco.api.Application - Started Application in
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1

Get Iexec Poco Api Log
    ${logs} =  GET FILE  ${REPO_DIR}/iexec-poco-api.log
    LOG  ${logs}
    [Return]  ${logs}

Stop Iexec Poco Api
    Get Iexec Poco Api Log
    Terminate Process  ${IEXEC_POCO_API_PROCESS}

Docker Stop Iexec Poco Api
    DockerHelper.Stop Log And Remove Container  ${IEXEC_POCO_API_CONTAINER_ID}
    Terminate Process  ${IEXEC_POCO_API_PROCESS}


Curl On Iexec Poco Api
    [Arguments]  ${URL}
    ${curl_result} =  Run Process  docker run --rm --net ${DOCKER_NETWORK} appropriate/curl http://${IEXEC_POCO_API_IP_IN_DOCKER_NETWORK}:3030/${URL}  shell=yes
    Log  ${curl_result.stdout}
    Log  ${curl_result.stderr}
    Should Be Equal As Integers  ${curl_result.rc}  0
    [Return]  ${curl_result.stdout}

