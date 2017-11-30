*** Settings ***
Documentation   local geth 42 node
Resource  ./DockerHelper.robot

*** Variables ***
${GETH_UTILS_PATH} =  ./docker/iexec-geth-local
${GETH_PROCESS}
${ACCOUNT_0_PRIVATE_KEY}
${ACCOUNT_1_PRIVATE_KEY}
${LOCAL_GETH_CONTAINER_ID}
${LOCAL_GETH_DOCKER_SERVICE} =  iexec-geth-local
${LOCAL_GETH_WS_PORT} =  8546



*** Keywords ***
Start Geth42
    Run Process  cd ${GETH_UTILS_PATH} && docker network create webproxy  shell=yes
    ${created_process} =  Start Process  cd ${GETH_UTILS_PATH} && docker-compose -f geth-local.docker-compose.yml up --build  shell=yes  stderr=STDOUT
    Set Suite Variable  ${GETH_PROCESS}  ${created_process}

    ${container_id} =  Wait Until Keyword Succeeds  25 min	10 sec  DockerHelper.Get Docker Container Id From Image  iexec-geth-local

    Set Suite Variable  ${LOCAL_GETH_CONTAINER_ID}  ${container_id}

    Wait Until Keyword Succeeds  10 min	10 sec  Check Local Geth Initialized

    ${account0_file} =  Run Process  cd ${GETH_UTILS_PATH} && docker exec -t ${LOCAL_GETH_CONTAINER_ID} bash -c "ls /root/.ethereum/net1337/keystore/0_*"  shell=yes  stderr=STDOUT
    Log  ${account0_file.stderr}
    Log  ${account0_file.stdout}
    ${path}  ${file} =  Split Path  ${account0_file.stdout}
    Log  ${path}
    Log  ${file}

    ${account_no}  ${public_key}  ${private_key} =  Split String  ${file}  separator=_
    Log  ${account_no}
    Log  ${public_key}
    Log  ${private_key}
    Set Suite Variable  ${ACCOUNT_0_PRIVATE_KEY}  ${private_key}



    ${account1_file} =  Run Process  cd ${GETH_UTILS_PATH} && docker exec -t ${LOCAL_GETH_CONTAINER_ID} bash -c "ls /root/.ethereum/net1337/keystore/1_*"  shell=yes  stderr=STDOUT
    Log  ${account1_file.stderr}
    Log  ${account1_file.stdout}
    ${path}  ${file} =  Split Path  ${account1_file.stdout}
    Log  ${path}
    Log  ${file}

    ${account_no}  ${public_key}  ${private_key} =  Split String  ${file}  separator=_
    Log  ${account_no}
    Log  ${public_key}
    Log  ${private_key}
    Set Suite Variable  ${ACCOUNT_1_PRIVATE_KEY}  ${private_key}



Check Local Geth Initialized
    ${logs} =  DockerHelper.Logs By Container Id  ${LOCAL_GETH_CONTAINER_ID}
    ${lines} =  Get Lines Containing String  ${logs}  LOCAL_GETH_WELL_INITIALIZED
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1

Stop Geth42
    Terminate Process  ${GETH_PROCESS}
    DockerHelper.Logs By Container Id  ${LOCAL_GETH_CONTAINER_ID}
