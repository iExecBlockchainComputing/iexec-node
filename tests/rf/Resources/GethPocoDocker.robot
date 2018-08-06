*** Settings ***
Library  Process
Resource  ./DockerHelper.robot

*** Variables ***
${GETH_POCO_IMAGE} =  iexechub/geth-poco
${GETH_POCO_IMAGE_VERSION} =  1.0.14-30sec-snap4
${GETH_POCO_PROCESS}
${GETH_POCO_CONTAINER_ID}


*** Keywords ***

Start GethPoco Container
    Remove File  ${REPO_DIR}/geth-poco.log
    Create File  ${REPO_DIR}/geth-poco.log
    ${created_process} =  Start Process  docker run -t -d --name geth-poco -p 8545:8545 ${GETH_POCO_IMAGE}:${GETH_POCO_IMAGE_VERSION}  shell=yes  stderr=STDOUT  stdout=${REPO_DIR}/geth-poco.log
    Set Suite Variable  ${GETH_POCO_PROCESS}  ${created_process}
    ${container_id} =  Wait Until Keyword Succeeds  5 min	10 sec  DockerHelper.Get Docker Container Id From Image  ${GETH_POCO_IMAGE}:${GETH_POCO_IMAGE_VERSION}
    Log  ${container_id}
    Set Suite Variable  ${GETH_POCO_CONTAINER_ID}  ${container_id}

Stop GethPoco Container
    DockerHelper.Stop Log And Remove Container  ${GETH_POCO_CONTAINER_ID}
    Terminate Process  ${GETH_POCO_PROCESS}


Get GethPoco Log
    ${logs} =  GET FILE  ${REPO_DIR}/geth-poco.log
    LOG  ${logs}
    [Return]  ${logs}
