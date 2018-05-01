*** Settings ***
Library  Process

*** Variables ***
${IEXEC_SDK_IMAGE} =  iexechub/iexec-sdk
${IEXEC_SDK_IMAGE_VERSION} =  1.7.7
${DOCKER_NETWORK}  =  docker_iexec-net
${REPO_DIR}
${IEXEC_ROBOT_DOCKER} =  true


*** Keywords ***


Iexec Docker
    [Arguments]  ${args}
    Remove File  ${REPO_DIR}/iexec-sdk.log
    Create File  ${REPO_DIR}/iexec-sdk.log
    ${rc} =  Run Process  docker run -e DEBUG\=* --interactive --rm -v $(pwd):/iexec-project -w /iexec-project ${IEXEC_SDK_IMAGE}:${IEXEC_SDK_IMAGE_VERSION} ${args}  shell=yes  stderr=STDOUT  timeout=340s  stdout=${REPO_DIR}/iexec-sdk.log
    ${logs} =  Get Iexec Sdk Log
    Should Be Equal As Integers  ${rc.rc}  0
    [Return]  ${logs}




Iexec An app
    [Arguments]  ${directory}  ${args}
    Remove File  ${REPO_DIR}/iexec-sdk.log
    Create File  ${REPO_DIR}/iexec-sdk.log
    ${iexec_result} =  Run Process  cd ${REPO_DIR}/${directory} && ls && docker run -e DEBUG\=* --interactive --rm -v $(pwd):/iexec-project -w /iexec-project ${IEXEC_SDK_IMAGE}:${IEXEC_SDK_IMAGE_VERSION} ${args}  shell=yes  stderr=STDOUT  timeout=340s  stdout=${REPO_DIR}/iexec-sdk.log
    ${logs} =  Get Iexec Sdk Log
    #Should Be Equal As Integers	${iexec_result.rc}	0
    [Return]  ${logs}


Iexec Init An App
    [Arguments]  ${appName}
    Remove File  ${REPO_DIR}/iexec-sdk.log
    Create File  ${REPO_DIR}/iexec-sdk.log
    ${iexec_result} =  Run Process  cd ${REPO_DIR} && docker run -e DEBUG\=* --interactive --rm -v $(pwd):/iexec-project -w /iexec-project ${IEXEC_SDK_IMAGE}:${IEXEC_SDK_IMAGE_VERSION} init ${appName}  shell=yes  stderr=STDOUT  timeout=340s  stdout=${REPO_DIR}/iexec-sdk.log
    ${logs} =  Get Iexec Sdk Log
    Directory Should Exist  ${REPO_DIR}/iexec-${appName}
    [Return]  ${logs}

iexec Docker Net
    [Arguments]  ${args}
    ${logs} =  Run Process  docker run -e DEBUG\=* --interactive --rm -v $(pwd):/iexec-project -w /iexec-project --net ${DOCKER_NETWORK} ${IEXEC_SDK_IMAGE}:${IEXEC_SDK_IMAGE_VERSION} ${args}  shell=yes  stderr=STDOUT  timeout=340s  stdout=stdoutxwbuild.txt
    LOG  ${logs}
    [Return]  ${logs}

Get Iexec Sdk Log
    ${logs} =  GET FILE  ${REPO_DIR}/iexec-sdk.log
    LOG  ${logs}
    [Return]  ${logs}