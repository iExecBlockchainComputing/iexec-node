*** Settings ***
Library  String

*** Variables ***
${REPO_DIR}
${IEXEC_SCHEDULER_MOCK_GIT_URL} =  https://github.com/iExecBlockchainComputing/iexec-scheduler-mock.git
${IEXEC_SCHEDULER_MOCK_GIT_BRANCH} =  master
${IEXEC_SCHEDULER_MOCK_FORCE_GIT_CLONE} =  true
${IEXEC_SCHEDULER_MOCK_PROCESS}
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
    Remove File  ${REPO_DIR}/scheduler-mock.log
    Create File  ${REPO_DIR}/scheduler-mock.log
    Run  sed -i '/compile "com.iexec.scheduler:iexec-scheduler*/d' ${REPO_DIR}/iexec-scheduler-mock/build.gradle
    Run  sed -i 's/\\/\\/compile files/compile files/g' ${REPO_DIR}/iexec-scheduler-mock/build.gradle
    ${gradle_result} =  Run Process  cd ${REPO_DIR}/iexec-scheduler-mock && ./gradlew build  shell=yes
    Log  ${gradle_result.stderr}
    Log  ${gradle_result.stdout}
    Should Be Equal As Integers	${gradle_result.rc}	0


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

Set RlcAddress IexecHubAddress Conf
    File Should Exist  ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.yml
    Run  cat ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.yml|sed 's/rlcAddress: 0xCHANGE_IT/rlcAddress: 0x091233035dcb12ae5a4a4b7fb144d3c5189892e1/g'|sed 's/iexecHubAddress: 0xCHANGE_IT/iexecHubAddress: 0xc4e4a08bf4c6fd11028b714038846006e27d7be8/g' >${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.tmp
    File Should Exist  ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.tmp
    Run  cat ${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.tmp >${REPO_DIR}/iexec-scheduler-mock/src/main/resources/iexec-scheduler.yml

Gradle BootRun Scheduler
    ${created_process} =  Start Process  cd ${REPO_DIR}/iexec-scheduler-mock && ./gradlew bootRun  shell=yes  stderr=STDOUT  stdout=${REPO_DIR}/scheduler-mock.log
    Set Suite Variable  ${IEXEC_SCHEDULER_MOCK_PROCESS}  ${created_process}
    Wait Until Keyword Succeeds  3 min	 5 sec  Check Scheduler Mock Initialized

Check Scheduler Mock Initialized
    ${logs} =  Get File  ${REPO_DIR}/scheduler-mock.log
    ${lines} =  Get Lines Containing String  ${logs}  com.iexec.scheduler.mock.Application - Started Application in
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1

Get Scheduler Mock Log
    ${logs} =  GET FILE  ${REPO_DIR}/scheduler-mock.log
    LOG  ${logs}
    [Return]  ${logs}

Stop Scheduler Mock
    Get Scheduler Mock Log
    Desactivate All Scheduler Mock
    Terminate Process  ${IEXEC_SCHEDULER_MOCK_PROCESS}




