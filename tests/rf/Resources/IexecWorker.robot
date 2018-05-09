*** Settings ***

*** Variables ***
${REPO_DIR}
${IEXEC_WORKER_GIT_URL} =  https://github.com/iExecBlockchainComputing/iexec-worker.git
${IEXEC_WORKER_GIT_BRANCH} =  master
${IEXEC_WORKER_FORCE_GIT_CLONE} =  true
*** Keywords ***

Gradle Build Iexec Worker
    Run Keyword If  '${IEXEC_WORKER_FORCE_GIT_CLONE}' == 'true'  Git Clone Iexec Worker
    Directory Should Exist  ${REPO_DIR}/iexec-worker
    Run  sed -i '/compile "com.iexec.common:iexec-common*/d' ${REPO_DIR}/iexec-worker/build.gradle
    Run  sed -i 's/\\/\\/compile files/compile files/g' ${REPO_DIR}/iexec-worker/build.gradle
    ${gradle_result} =  Run Process  cd ${REPO_DIR}/iexec-worker && ./gradlew build  shell=yes
    Log  ${gradle_result.stderr}
    Log  ${gradle_result.stdout}
    Should Be Equal As Integers	${gradle_result.rc}	0


Git Clone Iexec Worker
    Directory Should Exist  ${REPO_DIR}
    Remove Directory  ${REPO_DIR}/iexec-worker  recursive=true
    ${git_result} =  Run Process  cd ${REPO_DIR} && git clone -b ${IEXEC_WORKER_GIT_BRANCH} ${IEXEC_WORKER_GIT_URL}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0

