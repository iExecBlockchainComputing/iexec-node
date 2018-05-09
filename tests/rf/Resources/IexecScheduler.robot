*** Settings ***

*** Variables ***
${REPO_DIR}
${IEXEC_SCHEDULER_GIT_URL} =  https://github.com/iExecBlockchainComputing/iexec-scheduler.git
${IEXEC_SCHEDULER_GIT_BRANCH} =  master
${IEXEC_SCHEDULER_FORCE_GIT_CLONE} =  true
*** Keywords ***

Gradle Build Iexec Scheduler
    Run Keyword If  '${IEXEC_SCHEDULER_FORCE_GIT_CLONE}' == 'true'  Git Clone Iexec Scheduler
    Directory Should Exist  ${REPO_DIR}/iexec-scheduler
    Run  sed -i '/compile "com.iexec.common:iexec-common*/d' ${REPO_DIR}/iexec-scheduler/build.gradle
    Run  sed -i 's/\\/\\/compile files/compile files/g' ${REPO_DIR}/iexec-scheduler/build.gradle
    ${gradle_result} =  Run Process  cd ${REPO_DIR}/iexec-scheduler && ./gradlew build  shell=yes
    Log  ${gradle_result.stderr}
    Log  ${gradle_result.stdout}
    Should Be Equal As Integers	${gradle_result.rc}	0


Git Clone Iexec Scheduler
    Directory Should Exist  ${REPO_DIR}
    Remove Directory  ${REPO_DIR}/iexec-scheduler  recursive=true
    ${git_result} =  Run Process  cd ${REPO_DIR} && git clone -b ${IEXEC_SCHEDULER_GIT_BRANCH} ${IEXEC_SCHEDULER_GIT_URL}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0

