*** Settings ***

*** Variables ***
${REPO_DIR}
${IEXEC_COMMON_GIT_URL} =  https://github.com/iExecBlockchainComputing/iexec-common.git
${IEXEC_COMMON_GIT_BRANCH} =  master
${IEXEC_COMMON_FORCE_GIT_CLONE} =  true
*** Keywords ***

Gradle Build Iexec Common
    Run Keyword If  '${IEXEC_COMMON_FORCE_GIT_CLONE}' == 'true'  Git Clone Iexec Common
    Directory Should Exist  ${REPO_DIR}/iexec-common
    ${gradle_result} =  Run Process  cd ${REPO_DIR}/iexec-common && ./gradlew build --refresh-dependencies  shell=yes
    Log  ${gradle_result.stderr}
    Log  ${gradle_result.stdout}
    Should Be Equal As Integers	${gradle_result.rc}	0


Git Clone Iexec Common
    Directory Should Exist  ${REPO_DIR}
    Remove Directory  ${REPO_DIR}/iexec-common  recursive=true
    ${git_result} =  Run Process  cd ${REPO_DIR} && git clone -b ${IEXEC_COMMON_GIT_BRANCH} ${IEXEC_COMMON_GIT_URL} && cd ${REPO_DIR}/iexec-common && git submodule update --init --recursive  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0

