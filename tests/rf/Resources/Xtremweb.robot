*** Settings ***
Resource  ./DockerHelper.robot
Library  Process
Library  OperatingSystem
Library  String
Library  DateTime

*** Variables ***
${XTREMWEB_GIT_URL} =  https://github.com/iExecBlockchainComputing/xtremweb-hep.git
${XTREMWEB_GIT_BRANCH} =  master-compile
${BUILD_DOCKER_IMAGES} =  true
${XTREMWEB_FORCE_GIT_CLONE} =  true
${START_POA_GETH_POCO} =  false

${REPO_DIR}

${LAUNCHED_IN_CONTAINER} =  false

${JWTETHISSUER}
${JWTETHSECRET}
${BLOCKCHAINETHENABLED} =  false

${LOGGERLEVEL} =  FINEST
${RESULTS_FOLDER_BASE} =  /tmp/worker
${WALLET_PASSWORD}


${XTREMWEB_DOCKERCOMPOSE_PROCESS}

${MYSQL_IMAGE} =  mysql:5.7
${MYSQL_SERVICE_NAME} =  db
${MYSQL_CONTAINER_NAME} =  mysql
${MYSQL_CONTAINER_ID}

${WORKER_1_PROCESS}
${WORKER_CONTAINER_NAME_1} =  iexecworker1
${WORKER_CONTAINER_ID_1}


${WORKER_2_PROCESS}
${WORKER_3_PROCESS}
${WORKER_4_PROCESS}
${WORKER_5_PROCESS}
${WORKER_CONTAINER_NAME_BASE} =  iexecworker
${WORKER_CONTAINER_ID_2}
${WORKER_CONTAINER_ID_3}
${WORKER_CONTAINER_ID_4}
${WORKER_CONTAINER_ID_5}


${SERVER_SERVICE_NAME} =  scheduler
${SERVER_CONTAINER_NAME} =  scheduler
${SERVER_CONTAINER_ID}

${GRAFANA_CONTAINER_NAME} =  iexecgrafana
${GRAFANA_CONTAINER_ID}

${ORDER_PUBLISHER_CONTAINER_NAME} =  order-publisher
${ORDER_PUBLISHER_CONTAINER_ID}

${ADMINER_IMAGE} =  adminer:4.6.2
${ADMINER_CONTAINER_ID}

${GETH_POCO_IMAGE} =  iexechub/geth-poco
${GETH_POCO_IMAGE_VERSION} =  1.0.10
${GETH_POCO_PROCESS}
${GETH_POCO_CONTAINER_ID}
${GETH_POCO_IP_IN_DOCKER_NETWORK}
${DOCKER_NETWORK} =  docker_iexec-net
${GETH_POCO_RLCCONTRACT} =  0x091233035dcb12ae5a4a4b7fb144d3c5189892e1
${GETH_POCO_IEXECHUBCONTRACT} =  0xc4e4a08bf4c6fd11028b714038846006e27d7be8
${GETH_POCO_WORKERPOOL_CREATED_AT_START}

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
  Run Process  cd ${REPO_DIR}/xtremweb-hep && ./gradlew buildAll buildImages --refresh-dependencies -Penvironment\=docker  shell=yes stderr=STDOUT  stdout=${REPO_DIR}/xtremweb-hep-build.log

Gradle BuildAll Xtremweb
  Run Process  cd ${REPO_DIR}/xtremweb-hep && ./gradlew buildAll --refresh-dependencies  shell=yes stderr=STDOUT  stdout=${REPO_DIR}/xtremweb-hep-build.log






Start DockerCompose Xtremweb
    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/^BLOCKCHAINETHENABLED\=.*/BLOCKCHAINETHENABLED\=${BLOCKCHAINETHENABLED}/g" .env > env.tmp && cat env.tmp > .env  shell=yes
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

    ${date} =	Get Current Date
    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/^RESULTS_FOLDER\=.*/RESULTS_FOLDER\=${RESULTS_FOLDER_BASE}_${date}/g" .env > env.tmp && cat env.tmp > .env  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}

    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/iexecscheduler/${SERVER_CONTAINER_NAME}/g" docker-compose.yml > docker-compose.tmp && cat docker-compose.tmp > docker-compose.yml  shell=yes
    Log  ${result.stderr}
    Log  ${result.stdout}

    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/container_name: iexecworker/container_name: ${WORKER_CONTAINER_NAME_1}/g" docker-compose.yml > docker-compose.tmp && cat docker-compose.tmp > docker-compose.yml  shell=yes
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

    ${dbbinFullPath} =  Join Path  ${REPO_DIR}  dbbin
    Log  ${dbbinFullPath}

    ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && docker cp ${SERVER_CONTAINER_NAME}:/iexec/bin ${dbbinFullPath}  shell=yes
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
    ${get_admin_uid} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && docker exec -i ${MYSQL_CONTAINER_NAME} mysql -sN --user\=root --password\=root --database\="iexec" -e "SELECT uid FROM users where login\='admin';"  shell=yes
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


    Run Keyword If  '${START_POA_GETH_POCO}' == 'true'  Start Poa Geth PoCo


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

    ${container_id} =  Wait Until Keyword Succeeds  3 min	10 sec  DockerHelper.Get Docker Container Id By Name  ${WORKER_CONTAINER_NAME_1}
    Log  ${container_id}
    Set Suite Variable  ${WORKER_CONTAINER_ID_1}  ${container_id}

    ${container_id} =  Wait Until Keyword Succeeds  3 min	10 sec  DockerHelper.Get Docker Container Id From Image  ${ADMINER_IMAGE}
    Log  ${container_id}
    Set Suite Variable  ${ADMINER_CONTAINER_ID}  ${container_id}

    ${container_id} =  Wait Until Keyword Succeeds  3 min	10 sec  DockerHelper.Get Docker Container Id By Name  ${GRAFANA_CONTAINER_NAME}
    Log  ${container_id}
    Set Suite Variable  ${GRAFANA_CONTAINER_ID}  ${container_id}

    ${container_id} =  Wait Until Keyword Succeeds  3 min   10 sec  DockerHelper.Get Docker Container Id By Name  ${ORDER_PUBLISHER_CONTAINER_NAME}
    Log  ${container_id}
    Set Suite Variable  ${ORDER_PUBLISHER_CONTAINER_ID}  ${container_id}



Start Poa Geth PoCo
        Remove File  ${REPO_DIR}/geth-poco.log
        Create File  ${REPO_DIR}/geth-poco.log
        ${created_process} =  Start Process  docker run -t -d --net ${DOCKER_NETWORK} --name geth-poco -p 8545:8545 ${GETH_POCO_IMAGE}:${GETH_POCO_IMAGE_VERSION}  shell=yes  stderr=STDOUT  stdout=${REPO_DIR}/geth-poco.log
        Set Suite Variable  ${GETH_POCO_PROCESS}  ${created_process}
        ${container_id} =  Wait Until Keyword Succeeds  3 min	10 sec  DockerHelper.Get Docker Container Id From Image  ${GETH_POCO_IMAGE}:${GETH_POCO_IMAGE_VERSION}
        Log  ${container_id}
        Set Suite Variable  ${GETH_POCO_CONTAINER_ID}  ${container_id}
        ${result} =  Run Process  docker inspect ${GETH_POCO_CONTAINER_ID}  shell=yes
        Log  ${result.stderr}
        Log  ${result.stdout}
        Should Be Equal As Integers  ${result.rc}  0
        @{IPAddress} =  Get Regexp Matches  ${result.stdout}  "IPAddress": "1(?P<IPAddress>.*)"  IPAddress
        Log  @{IPAddress}[0]
        ${ip_poco} =  Catenate  SEPARATOR=  1  @{IPAddress}[0]
        Set Suite Variable  ${GETH_POCO_IP_IN_DOCKER_NETWORK}  ${ip_poco}

        ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/geth-poco/${GETH_POCO_IP_IN_DOCKER_NETWORK}/g" .env > env.tmp && cat env.tmp > .env  shell=yes
        Log  ${result.stderr}
        Log  ${result.stdout}

        ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/^RLCCONTRACT\=.*/RLCCONTRACT\=${GETH_POCO_RLCCONTRACT}/g" .env > env.tmp && cat env.tmp > .env  shell=yes
        Log  ${result.stderr}
        Log  ${result.stdout}

        ${result} =  Run Process  cd ${REPO_DIR}/xtremweb-hep/build/dist/*/docker/ && sed "s/^IEXECHUBCONTRACT\=.*/IEXECHUBCONTRACT\=${GETH_POCO_IEXECHUBCONTRACT}/g" .env > env.tmp && cat env.tmp > .env  shell=yes
        Log  ${result.stderr}
        Log  ${result.stdout}


Check Mysql Start From Log
    DockerHelper.Logs By Container Id  ${MYSQL_CONTAINER_ID}
    ${ret} =  Grep File  ${REPO_DIR}/${MYSQL_CONTAINER_ID}.log  mysqld: ready for connections.
    ${line_count} =  Get Line Count  ${ret}
    Should Not Be Equal As Integers	${line_count}	0

Check XtremWeb Server Start From Log
    DockerHelper.Logs By Container Id  ${SERVER_CONTAINER_ID}
    ${ret} =  Grep File  ${REPO_DIR}/${SERVER_CONTAINER_ID}.log  listening on port : 443
    ${line_count} =  Get Line Count  ${ret}
    #listening on port : must be present twice for success
    Should Be Equal As Integers	${line_count}	2

    Run Keyword If  '${START_POA_GETH_POCO}' == 'true'  Retrieved WorkerPool Address Automaticaly Created

Retrieved WorkerPool Address Automaticaly Created
    DockerHelper.Logs By Container Id  ${SERVER_CONTAINER_ID}
    ${ret} =  Grep File  ${REPO_DIR}/${SERVER_CONTAINER_ID}.log  CreateWorkerPool \[address
    ${line_count} =  Get Line Count  ${ret}
    Should Be Equal As Integers	${line_count}	1
    ${content} =  Fetch From Right  ${ret}  address
    ${content} =  Fetch From Right  ${content}  :
    ${content} =  Fetch From Left  ${content}  ]
    Set Suite Variable  ${GETH_POCO_WORKERPOOL_CREATED_AT_START}  ${content}

Stop DockerCompose Xtremweb
    Get Xtremweb Log

    DockerHelper.Stop Log And Remove Container  ${WORKER_CONTAINER_ID_1}

    DockerHelper.Stop Log And Remove Container  ${GRAFANA_CONTAINER_NAME}

    DockerHelper.Stop Log And Remove Container  ${ORDER_PUBLISHER_CONTAINER_NAME}

    DockerHelper.Stop Log And Remove Container  ${ADMINER_CONTAINER_ID}

    DockerHelper.Stop Log And Remove Container  ${SERVER_CONTAINER_ID}

    DockerHelper.Stop Log And Remove Container  ${MYSQL_CONTAINER_ID}

    Run Keyword If  '${START_POA_GETH_POCO}' == 'true'  DockerHelper.Stop Log And Remove Container  ${GETH_POCO_CONTAINER_ID}

    Terminate Process  ${XTREMWEB_DOCKERCOMPOSE_PROCESS}



Get Xtremweb Log
    ${logs} =  GET FILE  ${REPO_DIR}/xtremweb-hep.log
    LOG  ${logs}
    [Return]  ${logs}


Curl On Scheduler
    [Arguments]  ${URL}
    ${curl_result} =  Run Process  docker run --rm --net ${DOCKER_NETWORK} appropriate/curl --request GET --insecure 'https://${SERVER_SERVICE_NAME}:443/${URL}'  shell=yes
    Log  ${curl_result.stdout}
    Log  ${curl_result.stderr}
    Should Be Equal As Integers  ${curl_result.rc}  0
    [Return]  ${curl_result.stdout}


Curl Download On Scheduler
    [Arguments]  ${URL}  ${filename}
    ${curl_result} =  Run Process  docker run --rm -v $(pwd):/iexec-project -w /iexec-project --net ${DOCKER_NETWORK} appropriate/curl --request GET --insecure 'https://${SERVER_SERVICE_NAME}:443/${URL}' -o ${filename}.zip  shell=yes
    Log  ${curl_result.stdout}
    Log  ${curl_result.stderr}
    Should Be Equal As Integers  ${curl_result.rc}  0
    [Return]  ${curl_result.stdout}

Attach New Worker To Docker Network By Number
    [Arguments]  ${workerNumber}
    # range possible 1->5
    Should Be True	${workerNumber} < 6
    Should Be True	${workerNumber} > 0
    # may be stop it before if present
    Run Keyword And Ignore Error  Stop Worker On Docker Network By Number  ${workerNumber}

    ${dir} =  Run Process  ls ${REPO_DIR}/xtremweb-hep/build/dist/  shell=yes
    Log  ${dir.stderr}
    Log  ${dir.stdout}
    File Should Exist  ${REPO_DIR}/xtremweb-hep/build/dist/${dir.stdout}/docker/.env
    ${env} =  GET FILE  ${REPO_DIR}/xtremweb-hep/build/dist/${dir.stdout}/docker/.env
    @{WORKER_DOCKER_IMAGE_VERSION} =  Get Regexp Matches  ${env}  WORKER_DOCKER_IMAGE_VERSION\=(?P<imgdocker>.*)  imgdocker
    Log  @{WORKER_DOCKER_IMAGE_VERSION}[0]

    ${created_process} =  Start Process  docker run -t -d --net ${DOCKER_NETWORK} --restart unless-stopped -v ${REPO_DIR}/xtremweb-hep/build/dist/${dir.stdout}/wallet/wallet_worker${workerNumber}.json:/iexec/wallet/wallet_worker.json -v ${RESULTS_FOLDER_BASE}${workerNumber}:${RESULTS_FOLDER_BASE}${workerNumber} -v /var/run/docker.sock:/var/run/docker.sock --env SCHEDULER_IP\=${XW_HOST} --env SCHEDULER_DOMAIN\=${XW_HOST} --env TMPDIR\=${RESULTS_FOLDER_BASE}${workerNumber} --env SANDBOXENABLED\=true --env LOGGERLEVEL\=${LOGGERLEVEL} --env BLOCKCHAINETHENABLED\=${BLOCKCHAINETHENABLED} --env WALLETPASSWORD\=${WALLET_PASSWORD} --name ${WORKER_CONTAINER_NAME_BASE}${workerNumber} iexechub/worker:@{WORKER_DOCKER_IMAGE_VERSION}[0]  shell=yes  stderr=STDOUT  stdout=${REPO_DIR}/worker${workerNumber}.log

    Run Keyword If  '${workerNumber}' == '1'  Set Suite Variable  ${WORKER_1_PROCESS}  ${created_process}
    Run Keyword If  '${workerNumber}' == '2'  Set Suite Variable  ${WORKER_2_PROCESS}  ${created_process}
    Run Keyword If  '${workerNumber}' == '3'  Set Suite Variable  ${WORKER_3_PROCESS}  ${created_process}
    Run Keyword If  '${workerNumber}' == '4'  Set Suite Variable  ${WORKER_4_PROCESS}  ${created_process}
    Run Keyword If  '${workerNumber}' == '5'  Set Suite Variable  ${WORKER_5_PROCESS}  ${created_process}

    ${container_id} =  Wait Until Keyword Succeeds  5 min	10 sec  DockerHelper.Get Docker Container Id By Name  ${WORKER_CONTAINER_NAME_BASE}${workerNumber}
    Log  ${container_id}

    Run Keyword If  '${workerNumber}' == '1'  Set Suite Variable  ${WORKER_CONTAINER_ID_1}  ${container_id}
    Run Keyword If  '${workerNumber}' == '2'  Set Suite Variable  ${WORKER_CONTAINER_ID_2}  ${container_id}
    Run Keyword If  '${workerNumber}' == '3'  Set Suite Variable  ${WORKER_CONTAINER_ID_3}  ${container_id}
    Run Keyword If  '${workerNumber}' == '4'  Set Suite Variable  ${WORKER_CONTAINER_ID_4}  ${container_id}
    Run Keyword If  '${workerNumber}' == '5'  Set Suite Variable  ${WORKER_CONTAINER_ID_5}  ${container_id}

Stop Worker On Docker Network By Number
    [Arguments]  ${workerNumber}
    # range possible to stop 1->5
    Should Be True	${workerNumber} < 6
    Should Be True	${workerNumber} > 0
    DockerHelper.Stop Log And Remove Container  ${WORKER_CONTAINER_NAME_BASE}${workerNumber}
    Run Keyword If  '${workerNumber}' == '2'  Terminate Process  ${WORKER_2_PROCESS}
    Run Keyword If  '${workerNumber}' == '3'  Terminate Process  ${WORKER_3_PROCESS}
    Run Keyword If  '${workerNumber}' == '4'  Terminate Process  ${WORKER_4_PROCESS}
    Run Keyword If  '${workerNumber}' == '5'  Terminate Process  ${WORKER_5_PROCESS}


Restart Server
    DockerHelper.Restart Container  ${SERVER_CONTAINER_ID}
