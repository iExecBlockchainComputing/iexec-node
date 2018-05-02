*** Settings ***
Resource  ./DockerHelper.robot
Library  Process
Library  OperatingSystem
Library  String

*** Variables ***
${XTREMWEB_GIT_URL} =  https://github.com/iExecBlockchainComputing/xtremweb-hep.git
${XTREMWEB_GIT_BRANCH} =  master
${BUILD_DOCKER_IMAGES} =  true
${XTREMWEB_FORCE_GIT_CLONE} =  true

${REPO_DIR}

${LAUNCHED_IN_CONTAINER} =  false

${JWTETHISSUER}
${JWTETHSECRET}
${LOGGERLEVEL} =  FINEST

${XTREMWEB_DOCKERCOMPOSE_PROCESS}

${MYSQL_IMAGE} =  mysql:5.7
${MYSQL_CONTAINER_NAME} =  mysql
${MYSQL_CONTAINER_ID}

${WORKER_CONTAINER_NAME} =  iexecworker
${WORKER_CONTAINER_ID}

${SERVER_CONTAINER_NAME} =  scheduler
${SERVER_CONTAINER_ID}

${GRAFANA_CONTAINER_NAME} =  iexecgrafana
${GRAFANA_CONTAINER_ID}

${ADMINER_IMAGE} =  adminer:4.6.2
${ADMINER_CONTAINER_ID}


*** Keywords ***

Git Clone Xtremweb
    Directory Should Exist  ${REPO_DIR}
    Remove Directory  ${REPO_DIR}/xtremweb-hep  recursive=true
    ${git_result} =  Run Process  cd ${REPO_DIR} && git clone -b ${XTREMWEB_GIT_BRANCH} ${XTREMWEB_GIT_URL}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0


Gradle Build Xtremweb
    Run Keyword If  '${XTREMWEB_FORCE_GIT_CLONE}' == 'true'  Git Clone Xtremweb
    Directory Should Exist  ${REPO_DIR}/xtremweb-hep
    Remove File  ${REPO_DIR}/xtremweb-hep-build.log
    Create File  ${REPO_DIR}/xtremweb-hep-build.log
    Run Keyword If  '${BUILD_DOCKER_IMAGES}' == 'true'  Gradle BuildAll BuildImages Xtremweb
    Run Keyword If  '${BUILD_DOCKER_IMAGES}' == 'false'  Gradle BuildAll Xtremweb
    ${ret} =  Grep File  ${REPO_DIR}/xtremweb-hep-build.log  BUILD SUCCESSFUL in
    ${line_count} =  Get Line Count  ${ret}
    Should Be Equal As Integers	${line_count}	1
    ${logs} =  GET FILE  ${REPO_DIR}/xtremweb-hep-build.log
    LOG  ${logs}

Gradle BuildAll BuildImages Xtremweb
  Run Process  cd ${REPO_DIR}/xtremweb-hep && gradle buildAll buildImages -Penvironment\=docker  shell=yes stderr=STDOUT  stdout=${REPO_DIR}/xtremweb-hep-build.log

Gradle BuildAll Xtremweb
  Run Process  cd ${REPO_DIR}/xtremweb-hep && gradle buildAll  shell=yes stderr=STDOUT  stdout=${REPO_DIR}/xtremweb-hep-build.log


Start DockerCompose Xtremweb
    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/^ADMINUID\=.*/ADMINUID\=/g" .env > env.tmp && cat env.tmp > .env  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}

    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/^JWTETHISSUER\=.*/JWTETHISSUER\=${JWTETHISSUER}/g" .env > env.tmp && cat env.tmp > .env  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}

    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/^JWTETHSECRET\=.*/JWTETHSECRET\=${JWTETHSECRET}/g" .env > env.tmp && cat env.tmp > .env  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}


    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/^LOGGERLEVEL\=.*/LOGGERLEVEL\=${LOGGERLEVEL}/g" .env > env.tmp && cat env.tmp > .env  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}

    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/iexecscheduler/scheduler/g" docker-compose.yml > docker-compose.tmp && cat docker-compose.tmp > docker-compose.yml  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}


    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/iexecscheduler/scheduler/g" docker-compose-firstinstall.sh > docker-compose-firstinstall.tmp && cat docker-compose-firstinstall.tmp > docker-compose-firstinstall.sh  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}

    Remove File  ${REPO_DIR}/xtremweb-hep.log
    Create File  ${REPO_DIR}/xtremweb-hep.log
    ${created_process} =  Start Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && ./docker-compose-firstinstall.sh  shell=yes  stderr=STDOUT  stdout=${REPO_DIR}/xtremweb-hep.log
    Set Suite Variable  ${XTREMWEB_DOCKERCOMPOSE_PROCESS}  ${created_process}

    ${container_id} =  Wait Until Keyword Succeeds  3 min	10 sec  DockerHelper.Get Docker Container Id By Name  ${MYSQL_CONTAINER_NAME}
    Log  ${container_id}
    Set Suite Variable  ${MYSQL_CONTAINER_ID}  ${container_id}

    ${container_id} =  Wait Until Keyword Succeeds  3 min	10 sec  DockerHelper.Get Docker Container Id By Name  ${SERVER_CONTAINER_NAME}
    Log  ${container_id}
    Set Suite Variable  ${SERVER_CONTAINER_ID}  ${container_id}

    ${container_id} =  Wait Until Keyword Succeeds  3 min	10 sec  DockerHelper.Get Docker Container Id By Name  ${WORKER_CONTAINER_NAME}
    Log  ${container_id}
    Set Suite Variable  ${WORKER_CONTAINER_ID}  ${container_id}

    ${container_id} =  Wait Until Keyword Succeeds  3 min	10 sec  DockerHelper.Get Docker Container Id From Image  ${ADMINER_IMAGE}
    Log  ${container_id}
    Set Suite Variable  ${ADMINER_CONTAINER_ID}  ${container_id}

    ${container_id} =  Wait Until Keyword Succeeds  3 min	10 sec  DockerHelper.Get Docker Container Id By Name  ${GRAFANA_CONTAINER_NAME}
    Log  ${container_id}
    Set Suite Variable  ${GRAFANA_CONTAINER_ID}  ${container_id}

Stop DockerCompose Xtremweb
    Get Xtremweb Log

    DockerHelper.Stop Log And Remove Container  ${WORKER_CONTAINER_ID}

    DockerHelper.Stop Log And Remove Container  ${GRAFANA_CONTAINER_NAME}

    DockerHelper.Stop Log And Remove Container  ${ADMINER_CONTAINER_ID}

    DockerHelper.Stop Log And Remove Container  ${SERVER_CONTAINER_ID}

    DockerHelper.Stop Log And Remove Container  ${MYSQL_CONTAINER_ID}

    Terminate Process  ${XTREMWEB_DOCKERCOMPOSE_PROCESS}



Get Xtremweb Log
    ${logs} =  GET FILE  ${REPO_DIR}/xtremweb-hep.log
    LOG  ${logs}
    [Return]  ${logs}