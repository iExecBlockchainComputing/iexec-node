*** Settings ***
Library  Process
Library  OperatingSystem
Library  String
Resource  XWServer.robot
Resource  XWWorker.robot
Resource  ./DB/MySql.robot

*** Variables ***

${RF_RESULT_PATH} =  ../Results
${XW_GIT_URL} =  https://github.com/iExecBlockchainComputing/xtremweb-hep.git
${XW_GIT_BRANCH} =  master
${XW_FORCE_GIT_CLONE} =  false
${XW_PATH} =  ./xtremweb-hep/
${BUILD_PATH} =  ${XW_PATH}/build
${RESOURCES_PATH} =  ${XW_PATH}/src/main/resources
${DIST_PATH} =  ${BUILD_PATH}/dist
${DIST_XWHEP_PATH}
${XW_CACHE_DIR} =  /tmp
${XW_SERVER_NAME} =  vagrant-ubuntu-trusty-64


## xwconfigure.values
${XWCONFIGURE.VALUES.XWUSER} =  root
${XWCONFIGURE.VALUES.DBVENDOR} =  mysql
${XWCONFIGURE.VALUES.DBENGINE} =  InnoDB
${XWCONFIGURE.VALUES.DBHOST} =  ${XW_SERVER_NAME}
${XWCONFIGURE.VALUES.DBADMINLOGIN} =  root
${XWCONFIGURE.VALUES.DBADMINPASSWORD} =  root
${XWCONFIGURE.VALUES.DBNAME} =  xtremweb
${XWCONFIGURE.VALUES.DBUSERLOGIN} =  xwuser
${XWCONFIGURE.VALUES.DBUSERPASSWORD} =  xwuser
${XWCONFIGURE.VALUES.XWADMINLOGIN} =  admin
${XWCONFIGURE.VALUES.XWADMINPASSWORD} =  admin
${XWCONFIGURE.VALUES.XWWORKERLOGIN} =  worker
${XWCONFIGURE.VALUES.XWWORKERPASSWORD} =  worker
${XWCONFIGURE.VALUES.XWVWORKERLOGIN} =  vworker
${XWCONFIGURE.VALUES.XWVWORKERPASSWORD} =  vworker
${XWCONFIGURE.VALUES.XWSERVER} =  ${XW_SERVER_NAME}
${XWCONFIGURE.VALUES.CERTCN} =  ${XW_SERVER_NAME}
${XWCONFIGURE.VALUES.CERTOU} =  MrRobotFramework
${XWCONFIGURE.VALUES.CERTO} =  MrRobotFramework
${XWCONFIGURE.VALUES.CERTL} =  MrRobotFramework
${XWCONFIGURE.VALUES.CERTC} =  fr
${XWCONFIGURE.VALUES.SSLKEYPASSPHRASE} =  MrRobotFramework
${XWCONFIGURE.VALUES.SSLKEYSERVERPASSWORD} =  MrRobotFramework
${XWCONFIGURE.VALUES.SSLKEYWORKERPASSWORD} =  MrRobotFramework
${XWCONFIGURE.VALUES.SSLKEYCLIENTPASSWORD} =  MrRobotFramework
${XWCONFIGURE.VALUES.X509CERTDIR} =  /tmp/castore
${XWCONFIGURE.VALUES.USERCERTDIR} =
${XWCONFIGURE.VALUES.XWUPGRADEURL} =  http://${XW_SERVER_NAME}:8080/somewhere/xtremweb.jar
${XWCONFIGURE.VALUES.HTTPSPORT} =  9443




*** Keywords ***

Prepare XWtremWeb Server And XWtremWeb Worker
    Run Keyword If  '${XW_FORCE_GIT_CLONE}' == 'true'  Git Clone XWtremWeb
    Compile XWtremWeb
    Install XWtremWeb
    XWServer.Start XtremWeb Server  ${DIST_XWHEP_PATH}
    #create a vworker
    ${vworker.conf} =  XWClient.XWSENDUSERCommand  vworker vworkerp vworker VWORKER_USER
    Log  ${vworker.conf}
    XWServer.Stop XtremWeb Server

Start XWtremWeb Server And XWtremWeb Worker
    Ping XWtremWeb Database
    XWServer.Start XtremWeb Server  ${DIST_XWHEP_PATH}
    XWWorker.Start XtremWeb Worker  ${DIST_XWHEP_PATH}


Stop XWtremWeb Server And XWtremWeb Worker
    XWServer.Stop XtremWeb Server
    Log XtremWeb Server
    XWWorker.Stop XtremWeb Worker
    Log XtremWeb Worker

Log XtremWeb Server
    XWServer.Log XtremWeb Server Log File

Log XtremWeb Worker
    XWWorker.Log XtremWeb Worker Log File


Begin XWtremWeb Command Test
    Ping XWtremWeb Database
    Remove MANDATINGLOGIN in Xtremweb Xlient Conf  ${DIST_XWHEP_PATH}
    Start XWtremWeb Server And XWtremWeb Worker

End XWtremWeb Command Test
    Stop XWtremWeb Server And XWtremWeb Worker
    MySql.Delete Fonctionnal Xtremweb Tables


Clear XWtremWeb Cache
    ${rm_result} =  Run Process  rm -rf ${XW_CACHE_DIR}/XW*  shell=yes
    Should Be Empty	${rm_result.stderr}
    Should Be Equal As Integers	${rm_result.rc}	0
    ${rm_result} =  Run Process  rm -rf ${XW_CACHE_DIR}/xw*  shell=yes
    Should Be Empty	${rm_result.stderr}
    Should Be Equal As Integers	${rm_result.rc}	0


Git Clone XWtremWeb
    Remove Directory  xtremweb-hep  recursive=true
    ${git_result} =  Run Process  git clone -b ${XW_GIT_BRANCH} ${XW_GIT_URL}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0

Compile XWtremWeb
    Create XWCONFIGURE.VALUES FILE  ${RESOURCES_PATH}
    ${compile_result} =  Run Process  cd ${XW_PATH} && ./gradlew buildAll generateKeys  shell=yes  stderr=STDOUT  timeout=340s  stdout=stdoutxwbuild.txt
    Log  ${compile_result.stderr}
    #Should Be Empty	${compile_result.stderr} some warnings ...
    Log  ${compile_result.stdout}
    Should Be Equal As Integers	${compile_result.rc}	0
    ${extract_build_successful} =  Get Lines Containing String  ${compile_result.stdout}  BUILD SUCCESSFUL
    ${line_count_build_successful} =  Get Line Count  ${extract_build_successful}
    Should Be Equal As Integers	${line_count_build_successful}	1

Install XWtremWeb
    @{list_directories_dist_path} =  List Directories In Directory  ${DIST_PATH}  xtremweb-*  absolute
    Log  @{list_directories_dist_path}[0]
    Set Suite Variable  ${DIST_XWHEP_PATH}  @{list_directories_dist_path}[0]
    Directory Should Exist  ${DIST_XWHEP_PATH}
    ${database_setup_result} =  Run Process  cd ${DIST_XWHEP_PATH} && ./bin/setupDatabase --yes --rmdb  shell=yes
    Log  ${database_setup_result.stdout}
    ${database_result_successful} =  Get Lines Containing String  ${database_setup_result.stdout}  That's all for database
    ${line_database_result_successful} =  Get Line Count  ${database_result_successful}
    Should Be Equal As Integers  ${line_database_result_successful}  1

    #${install_result} =  Run Process  cd ${DIST_XWHEP_PATH} && ./bin/xwconfigure --yes --nopkg  shell=yes  stderr=STDOUT  timeout=15s  stdout=stdoutxwconfigure.txt
    #Should Be Empty	${install_result.stderr} some errors
    #Log  ${install_result.stdout}
    #Should Be Equal As Integers	${install_result.rc}	0
    #${install_result_successful} =  Get Lines Containing String  ${install_result.stdout}  That's all folks
    #${line_install_result_successful} =  Get Line Count  ${install_result_successful}
    #Should Be Equal As Integers	${line_install_result_successful}	1



Set MANDATINGLOGIN in Xtremweb Xlient Conf
    [Arguments]  ${DIST_XWHEP_PATH}  ${MANDATED}
    Directory Should Exist  ${DIST_XWHEP_PATH}/conf
    Run  sed -i "s/.*MANDATINGLOGIN.*//g" ${DIST_XWHEP_PATH}/conf/xtremweb.client.conf
    Append To File  ${DIST_XWHEP_PATH}/conf/xtremweb.client.conf  MANDATINGLOGIN=${MANDATED}
    Log file  ${DIST_XWHEP_PATH}/conf/xtremweb.client.conf


Remove MANDATINGLOGIN in Xtremweb Xlient Conf
    [Arguments]  ${DIST_XWHEP_PATH}
    Directory Should Exist  ${DIST_XWHEP_PATH}/conf
    Run  sed -i "s/.*MANDATINGLOGIN.*//g" ${DIST_XWHEP_PATH}/conf/xtremweb.client.conf
    Log file  ${DIST_XWHEP_PATH}/conf/xtremweb.client.conf

Curl To Server
    [Arguments]  ${URL}
    ${curl_result} =  Run Process  /usr/bin/curl -v --insecure -X GET -G 'https://${XWCONFIGURE.VALUES.XWSERVER}:${XWCONFIGURE.VALUES.HTTPSPORT}/${URL}' -d XWLOGIN\=${XWCONFIGURE.VALUES.XWADMINLOGIN} -d XWPASSWD\=${XWCONFIGURE.VALUES.XWADMINPASSWORD}  shell=yes
    Log  ${curl_result.stdout}
    Log  ${curl_result.stderr}
    Should Be Equal As Integers	${curl_result.rc}	0
    [Return]  ${curl_result.stdout}

Check Work Completed By SubmitTxHash
    [Arguments]  ${submitTxHash}
    ${app_curl_result} =  Curl To Server  getworkbyexternalid/${submitTxHash}
    Log  ${app_curl_result}
    ${lines} =  Get Lines Containing String  ${app_curl_result}  COMPLETED
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1

Create XWCONFIGURE.VALUES FILE
    [Arguments]  ${DIST_XWHEP_PATH}
    Directory Should Exist  ${DIST_XWHEP_PATH}/conf
    Remove File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values
    Create File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  XWUSER='${XWCONFIGURE.VALUES.XWUSER}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  DBVENDOR='${XWCONFIGURE.VALUES.DBVENDOR}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  DBENGINE='${XWCONFIGURE.VALUES.DBENGINE}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  DBHOST='${XWCONFIGURE.VALUES.DBHOST}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  DBADMINLOGIN='${XWCONFIGURE.VALUES.DBADMINLOGIN}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  DBADMINPASSWORD='${XWCONFIGURE.VALUES.DBADMINPASSWORD}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  DBNAME='${XWCONFIGURE.VALUES.DBNAME}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  DBUSERLOGIN='${XWCONFIGURE.VALUES.DBUSERLOGIN}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  DBUSERPASSWORD='${XWCONFIGURE.VALUES.DBUSERPASSWORD}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  XWADMINLOGIN='${XWCONFIGURE.VALUES.XWADMINLOGIN}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  XWADMINPASSWORD='${XWCONFIGURE.VALUES.XWADMINPASSWORD}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  XWWORKERLOGIN='${XWCONFIGURE.VALUES.XWWORKERLOGIN}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  XWWORKERPASSWORD='${XWCONFIGURE.VALUES.XWWORKERPASSWORD}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  XWVWORKERLOGIN='${XWCONFIGURE.VALUES.XWVWORKERLOGIN}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  XWVWORKERPASSWORD='${XWCONFIGURE.VALUES.XWVWORKERPASSWORD}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  XWSERVER='${XWCONFIGURE.VALUES.XWSERVER}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  CERTCN='${XWCONFIGURE.VALUES.CERTCN}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  CERTOU='${XWCONFIGURE.VALUES.CERTOU}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  CERTO='${XWCONFIGURE.VALUES.CERTO}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  CERTL='${XWCONFIGURE.VALUES.CERTL}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  CERTC='${XWCONFIGURE.VALUES.CERTC}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  CERTC='${XWCONFIGURE.VALUES.CERTC}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  SSLKEYPASSPHRASE='${XWCONFIGURE.VALUES.SSLKEYPASSPHRASE}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  SSLKEYSERVERPASSWORD='${XWCONFIGURE.VALUES.SSLKEYSERVERPASSWORD}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  SSLKEYWORKERPASSWORD='${XWCONFIGURE.VALUES.SSLKEYWORKERPASSWORD}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  SSLKEYCLIENTPASSWORD='${XWCONFIGURE.VALUES.SSLKEYCLIENTPASSWORD}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  X509CERTDIR='${XWCONFIGURE.VALUES.X509CERTDIR}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  USERCERTDIR='${XWCONFIGURE.VALUES.USERCERTDIR}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  XWUPGRADEURL='${XWCONFIGURE.VALUES.XWUPGRADEURL}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  HTTPSPORT='${XWCONFIGURE.VALUES.HTTPSPORT}'\n
    Append To File  ${DIST_XWHEP_PATH}/conf/xwconfigure.values  LOGGERLEVEL=INFO\n
    LOG FILE  ${DIST_XWHEP_PATH}/conf/xwconfigure.values