*** Settings ***
Resource  ./DockerHelper.robot
Library  Process
Library  OperatingSystem
Library  String
Library  DateTime

*** Variables ***
${XTREMWEB_GIT_URL} =  https://github.com/iExecBlockchainComputing/xtremweb-hep.git
${XTREMWEB_GIT_BRANCH} =  fix-SchedulerPocoWatcherImpl
${BUILD_DOCKER_IMAGES} =  true
${XTREMWEB_FORCE_GIT_CLONE} =  true

${REPO_DIR}

${LAUNCHED_IN_CONTAINER} =  false

${JWTETHISSUER} =  TBD
${JWTETHSECRET} =  TBD

${LOGGERLEVEL} =  FINEST
${RESULTS_FOLDER_BASE}  =  /tmp/worker


${XTREMWEB_DOCKERCOMPOSE_PROCESS}

${MYSQL_IMAGE} =  mysql:5.7
${MYSQL_SERVICE_NAME} =  db
${MYSQL_CONTAINER_NAME} =  mysql
${MYSQL_CONTAINER_ID}

${WORKER_CONTAINER_NAME} =  iexecworker
${WORKER_CONTAINER_ID}

${SERVER_SERVICE_NAME} =  scheduler
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
    Wait Until Keyword Succeeds  2 min	3 sec  Check Build Xtremweb Log

Check Build Xtremweb Log
    ${ret} =  Grep File  ${REPO_DIR}/xtremweb-hep-build.log  BUILD SUCCESSFUL in
    ${line_count} =  Get Line Count  ${ret}
    Should Be Equal As Integers	${line_count}	1
    ${logs} =  GET FILE  ${REPO_DIR}/xtremweb-hep-build.log
    LOG  ${logs}

Gradle BuildAll BuildImages Xtremweb
  Run Process  cd ${REPO_DIR}/xtremweb-hep && ./gradlew buildAll buildImages -Penvironment\=docker  shell=yes stderr=STDOUT  stdout=${REPO_DIR}/xtremweb-hep-build.log

Gradle BuildAll Xtremweb
  Run Process  cd ${REPO_DIR}/xtremweb-hep && ./gradlew buildAll  shell=yes stderr=STDOUT  stdout=${REPO_DIR}/xtremweb-hep-build.log






Start DockerCompose Xtremweb
   # ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/^ADMINUID\=.*/ADMINUID\=/g" .env > env.tmp && cat env.tmp > .env  shell=yes
   # Log  ${result.stderr}
   # Log  ${result.stdout}

    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/^JWTETHISSUER\=.*/JWTETHISSUER\=${JWTETHISSUER}/g" .env > env.tmp && cat env.tmp > .env  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}

    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/^JWTETHSECRET\=.*/JWTETHSECRET\=${JWTETHSECRET}/g" .env > env.tmp && cat env.tmp > .env  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}


    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/^LOGGERLEVEL\=.*/LOGGERLEVEL\=${LOGGERLEVEL}/g" .env > env.tmp && cat env.tmp > .env  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}

    ${date} =	Get Current Date
    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/^RESULTS_FOLDER\=.*/RESULTS_FOLDER\=${RESULTS_FOLDER_BASE}_${date}/g" .env > env.tmp && cat env.tmp > .env  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}

    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/iexecscheduler/${SERVER_CONTAINER_NAME}/g" docker-compose.yml > docker-compose.tmp && cat docker-compose.tmp > docker-compose.yml  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}



    Remove File  ${REPO_DIR}/xtremweb-hep.log
    Create File  ${REPO_DIR}/xtremweb-hep.log

    # run dummy scheduler to get scripts for db
    ${created_process} =  Start Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && docker-compose -f docker-compose.yml up -d ${SERVER_SERVICE_NAME}  shell=yes  stderr=STDOUT  stdout=${REPO_DIR}/xtremweb-hep.log
    Set Suite Variable  ${XTREMWEB_DOCKERCOMPOSE_PROCESS}  ${created_process}

    ${container_id} =  Wait Until Keyword Succeeds  3 min	10 sec  DockerHelper.Get Docker Container Id By Name  ${SERVER_CONTAINER_NAME}
    Log  ${container_id}
    Set Suite Variable  ${SERVER_CONTAINER_ID}  ${container_id}




    # copy scripts, conf and certificate from scheduler
    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && docker cp ${SERVER_CONTAINER_NAME}:/iexec/bin ${REPO_DIR}/dbbin  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers  ${result.rc}  0
    Directory Should Exist  ${REPO_DIR}/dbbin


    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && docker cp ${SERVER_CONTAINER_NAME}:/iexec/conf ${REPO_DIR}/dbconf  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers  ${result.rc}  0
    Directory Should Exist  ${REPO_DIR}/dbconf

    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && docker cp ${SERVER_CONTAINER_NAME}:/iexec/keystore/xwscheduler.pem ${REPO_DIR}  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers  ${result.rc}  0

    # kill the dummy scheduler
    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && docker-compose -f docker-compose.yml down -v  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers  ${result.rc}  0


    # first start the database and wait a bit to have it started
    ${created_process} =  Start Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && docker-compose -f docker-compose.yml up -d ${MYSQL_SERVICE_NAME}  shell=yes  stderr=STDOUT  stdout=${REPO_DIR}/xtremweb-hep.log
    Set Suite Variable  ${XTREMWEB_DOCKERCOMPOSE_PROCESS}  ${created_process}

    ${container_id} =  Wait Until Keyword Succeeds  3 min	10 sec  DockerHelper.Get Docker Container Id By Name  ${MYSQL_CONTAINER_NAME}
    Log  ${container_id}
    Set Suite Variable  ${MYSQL_CONTAINER_ID}  ${container_id}

    Wait Until Keyword Succeeds  2 min	5 sec  Check Mysql Start From Log

    Sleep  10 sec

    # copy scripts and conf in the mysql container
    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && docker exec -i ${MYSQL_CONTAINER_NAME} mkdir scripts  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers  ${result.rc}  0

    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && docker cp ${REPO_DIR}/dbbin ${MYSQL_CONTAINER_NAME}:/scripts/bin  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers  ${result.rc}  0

    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && docker cp ${REPO_DIR}/dbconf ${MYSQL_CONTAINER_NAME}:/scripts/conf  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers  ${result.rc}  0

    # trigger the database creation in the mysql container
    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && docker exec -i ${MYSQL_CONTAINER_NAME} /scripts/bin/setupDatabase --yes --rmdb --dbhost db  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers  ${result.rc}  0

    #get adminuid
    ${get_admin_uid} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && docker exec -i ${MYSQL_CONTAINER_NAME} mysql --user\=root --password\=root --database\="iexec" -e "SELECT uid FROM users where login\='admin';"  shell=yes
    Log  ${get_admin_uid.stderr}
    Log  ${get_admin_uid.stdout}
    Should Be Equal As Integers  ${result.rc}  0

    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/^ADMINUID\=.*/ADMINUID\=${get_admin_uid.stdout}/g" .env > env.tmp && cat env.tmp > .env  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}

    # remove temporary files and folders
    ${result} =  Run Process  rm -rf ${REPO_DIR}/dbbin/  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers  ${result.rc}  0
    ${result} =  Run Process  rm -rf ${REPO_DIR}/dbconf/  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers  ${result.rc}  0

    # then start the scheduler and a little bit after all remaining services
    ${created_process} =  Start Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && docker-compose -f docker-compose.yml up -d ${SERVER_SERVICE_NAME}  shell=yes  stderr=STDOUT  stdout=${REPO_DIR}/xtremweb-hep.log
    Set Suite Variable  ${XTREMWEB_DOCKERCOMPOSE_PROCESS}  ${created_process}

    ${container_id} =  Wait Until Keyword Succeeds  3 min	10 sec  DockerHelper.Get Docker Container Id By Name  ${SERVER_CONTAINER_NAME}
    Log  ${container_id}
    Set Suite Variable  ${SERVER_CONTAINER_ID}  ${container_id}

    ${result} =  Run Process  docker inspect ${SERVER_CONTAINER_ID}  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}
    Should Be Equal As Integers  ${result.rc}  0

    Wait Until Keyword Succeeds  2 min	5 sec  Check XtremWeb Server Start From Log

    ${created_process} =  Start Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && docker-compose -f docker-compose.yml up -d  shell=yes  stderr=STDOUT  stdout=${REPO_DIR}/xtremweb-hep.log
    Set Suite Variable  ${XTREMWEB_DOCKERCOMPOSE_PROCESS}  ${created_process}

    ${created_process} =  Start Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && docker-compose -f docker-compose.yml logs -f  shell=yes  stderr=STDOUT  stdout=${REPO_DIR}/xtremweb-hep.log
    Set Suite Variable  ${XTREMWEB_DOCKERCOMPOSE_PROCESS}  ${created_process}

    ${container_id} =  Wait Until Keyword Succeeds  3 min	10 sec  DockerHelper.Get Docker Container Id By Name  ${WORKER_CONTAINER_NAME}
    Log  ${container_id}
    Set Suite Variable  ${WORKER_CONTAINER_ID}  ${container_id}

    ${container_id} =  Wait Until Keyword Succeeds  3 min	10 sec  DockerHelper.Get Docker Container Id From Image  ${ADMINER_IMAGE}
    Log  ${container_id}
    Set Suite Variable  ${ADMINER_CONTAINER_ID}  ${container_id}

    ${container_id} =  Wait Until Keyword Succeeds  3 min	10 sec  DockerHelper.Get Docker Container Id By Name  ${GRAFANA_CONTAINER_NAME}
    Log  ${container_id}
    Set Suite Variable  ${GRAFANA_CONTAINER_ID}  ${container_id}


Check Mysql Start From Log
    DockerHelper.Logs By Container Id  ${MYSQL_CONTAINER_ID}
    ${ret} =  Grep File  ${REPO_DIR}/${MYSQL_CONTAINER_ID}.log  mysqld: ready for connections.
    ${line_count} =  Get Line Count  ${ret}
    Should Be Equal As Integers	${line_count}	1

Check XtremWeb Server Start From Log
    DockerHelper.Logs By Container Id  ${SERVER_CONTAINER_ID}
    ${ret} =  Grep File  ${REPO_DIR}/${SERVER_CONTAINER_ID}.log  listening on port : 443
    ${line_count} =  Get Line Count  ${ret}
    #listening on port : must be present twice for success
    Should Be Equal As Integers	${line_count}	2


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