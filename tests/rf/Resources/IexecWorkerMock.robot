*** Settings ***
Library  String

*** Variables ***
${REPO_DIR}
${IEXEC_WORKER_MOCK_GIT_URL} =  https://github.com/iExecBlockchainComputing/iexec-worker-mock.git
${IEXEC_WORKER_MOCK_GIT_BRANCH} =  dockerize-it
${IEXEC_WORKER_MOCK_FORCE_GIT_CLONE} =  true
${IEXEC_WORKER_MOCK_PROCESS}
${DOCKER_NETWORK} =  docker_iexec-net
${IEXEC_WORKER_MOCK_CONTAINER_ID}

*** Keywords ***

Git Clone Iexec Worker Mock
    Directory Should Exist  ${REPO_DIR}
    Remove Directory  ${REPO_DIR}/iexec-worker-mock  recursive=true
    ${git_result} =  Run Process  cd ${REPO_DIR} && git clone -b ${IEXEC_WORKER_MOCK_GIT_BRANCH} ${IEXEC_WORKER_MOCK_GIT_URL}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0

Gradle Build Iexec Worker Mock
    Run Keyword If  '${IEXEC_WORKER_MOCK_FORCE_GIT_CLONE}' == 'true'  Git Clone Iexec Worker Mock
    Directory Should Exist  ${REPO_DIR}/iexec-worker-mock
    Run  sed -i '/compile "com.iexec.worker:iexec-worker*/d' ${REPO_DIR}/iexec-worker-mock/build.gradle
    Run  sed -i 's/\\/\\/compile files/compile files/g' ${REPO_DIR}/iexec-worker-mock/build.gradle
    ${gradle_result} =  Run Process  cd ${REPO_DIR}/iexec-worker-mock && ./gradlew build  shell=yes
    Log  ${gradle_result.stderr}
    Log  ${gradle_result.stdout}
    Should Be Equal As Integers	${gradle_result.rc}	0


Docker Run Iexec Worker Mock
    Gradle Build Iexec Worker Mock
    Desactivate All Worker Mock
    Set Scheduler IP Conf
    ${result} =  Run Process  cd ${REPO_DIR}/iexec-worker-mock && docker build -t iexechub/iexec-worker-mock .  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers	${result.rc}	0
    Remove File  ${REPO_DIR}/iexec-worker-mock.log
    Create File  ${REPO_DIR}/iexec-worker-mock.log
    ${created_process} =  Start Process  cd ${REPO_DIR}/iexec-worker-mock && docker run --net ${DOCKER_NETWORK} -v `pwd`/src/main/resources/:/src/main/resources/ iexechub/iexec-worker-mock  shell=yes  stderr=STDOUT  stdout=${REPO_DIR}/iexec-worker-mock.log
    Set Suite Variable  ${IEXEC_WORKER_MOCK_PROCESS}  ${created_process}
    ${container_id} =  Wait Until Keyword Succeeds  5 min	10 sec  DockerHelper.Get Docker Container Id From Image  iexechub/iexec-worker-mock
    Log  ${container_id}
    Set Suite Variable  ${IEXEC_WORKER_MOCK_CONTAINER_ID}  ${container_id}
    Wait Until Keyword Succeeds  3 min	 5 sec  Check Worker Mock Initialized


Set Scheduler IP Conf
    File Should Exist  ${REPO_DIR}/iexec-worker-mock/src/main/resources/iexec-worker.yml
    Run  cat ${REPO_DIR}/iexec-worker-mock/src/main/resources/iexec-worker.yml|sed 's/localhost/${IEXEC_SCHEDULER_IP_IN_DOCKER_NETWORK}/g' >${REPO_DIR}/iexec-worker-mock/src/main/resources/iexec-worker.tmp
    File Should Exist  ${REPO_DIR}/iexec-worker-mock/src/main/resources/iexec-worker.tmp
    Run  cat ${REPO_DIR}/iexec-worker-mock/src/main/resources/iexec-worker.tmp >${REPO_DIR}/iexec-worker-mock/src/main/resources/iexec-worker.yml


Gradle Build BootRun Iexec Worker Mock
    Gradle Build Iexec Worker Mock
    Desactivate All Worker Mock
    Gradle BootRun Worker

Gradle Build BootRun Iexec Worker Mock Active
    Gradle Build Iexec Worker Mock
    Activate All Worker Mock
    Gradle BootRun Worker


Activate All Worker Mock
    File Should Exist  ${REPO_DIR}/iexec-worker-mock/src/main/resources/application.yml
    Run  cat ${REPO_DIR}/iexec-worker-mock/src/main/resources/application.yml|sed 's/active: false/active: true/g' >${REPO_DIR}/iexec-worker-mock/src/main/resources/application.tmp
    File Should Exist  ${REPO_DIR}/iexec-worker-mock/src/main/resources/application.tmp
    Run  cat ${REPO_DIR}/iexec-worker-mock/src/main/resources/application.tmp >${REPO_DIR}/iexec-worker-mock/src/main/resources/application.yml


Desactivate All Worker Mock
    File Should Exist  ${REPO_DIR}/iexec-worker-mock/src/main/resources/application.yml
    Run  cat ${REPO_DIR}/iexec-worker-mock/src/main/resources/application.yml|sed 's/active: true/active: false/g' >${REPO_DIR}/iexec-worker-mock/src/main/resources/application.tmp
    File Should Exist  ${REPO_DIR}/iexec-worker-mock/src/main/resources/application.tmp
    Run  cat ${REPO_DIR}/iexec-worker-mock/src/main/resources/application.tmp >${REPO_DIR}/iexec-worker-mock/src/main/resources/application.yml

Gradle BootRun Worker
    Remove File  ${REPO_DIR}/iexec-worker-mock.log
    Create File  ${REPO_DIR}/iexec-worker-mock.log
    ${created_process} =  Start Process  cd ${REPO_DIR}/iexec-worker-mock && ./gradlew bootRun  shell=yes  stderr=STDOUT  stdout=${REPO_DIR}/iexec-worker-mock.log
    Set Suite Variable  ${IEXEC_WORKER_MOCK_PROCESS}  ${created_process}
    Wait Until Keyword Succeeds  3 min	 5 sec  Check Worker Mock Initialized

Check Worker Mock Initialized
    ${logs} =  Get File  ${REPO_DIR}/iexec-worker-mock.log
    ${lines} =  Get Lines Containing String  ${logs}  com.iexec.worker.mock.Application - Started Application in
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1


Get Worker Mock Log
    ${logs} =  GET FILE  ${REPO_DIR}/iexec-worker-mock.log
    LOG  ${logs}
    [Return]  ${logs}

Stop Worker Mock
    Get Worker Mock Log
    Desactivate All Worker Mock
    Terminate Process  ${IEXEC_WORKER_MOCK_PROCESS}

Docker Stop Worker Mock
    DockerHelper.Stop Log And Remove Container  ${IEXEC_WORKER_MOCK_CONTAINER_ID}
    Desactivate All Worker Mock
    Terminate Process  ${IEXEC_WORKER_MOCK_PROCESS}
