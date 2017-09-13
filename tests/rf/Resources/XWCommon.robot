*** Settings ***
Library  Process
Library  OperatingSystem
Library  String
Resource  XWServer.robot
Resource  XWWorker.robot
Resource  ./DB/MySql.robot

*** Variables ***

${RF_RESULT_PATH} =  ../Results
${XW_GIT_BRANCH} =  https://github.com/iExecBlockchainComputing/xtremweb-hep.git
${XW_FORCE_GIT_CLONE} =  false
${BUILD_PATH} =  ./xtremweb-hep/build
${DIST_PATH} =  ${BUILD_PATH}/dist
${DIST_XWHEP_PATH}
${XW_CACHE_DIR} =  /tmp


## xwconfigure.values
${XWCONFIGURE.VALUES.XWUSER} =  root
${XWCONFIGURE.VALUES.DBVENDOR} =  mysql
${XWCONFIGURE.VALUES.DBENGINE} =  InnoDB
${XWCONFIGURE.VALUES.DBHOST} =  localhost
${XWCONFIGURE.VALUES.DBADMINLOGIN} =  root
${XWCONFIGURE.VALUES.DBADMINPASSWORD} =  root
${XWCONFIGURE.VALUES.DBNAME} =  xtremweb
${XWCONFIGURE.VALUES.DBUSERLOGIN} =  xwuser
${XWCONFIGURE.VALUES.DBUSERPASSWORD} =  xwuser
${XWCONFIGURE.VALUES.XWADMINLOGIN} =  admin
${XWCONFIGURE.VALUES.XWADMINPASSWORD} =  admin
${XWCONFIGURE.VALUES.XWWORKERLOGIN} =  worker
${XWCONFIGURE.VALUES.XWWORKERPASSWORD} =  worker
${XWCONFIGURE.VALUES.XWSERVER} =  localhost
${XWCONFIGURE.VALUES.CERTCN} =  localhost
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
${XWCONFIGURE.VALUES.XWUPGRADEURL} =  http://localhost:8080/somewhere/xtremweb.jar
${XWCONFIGURE.VALUES.HTTPSPORT} =  9443



*** Keywords ***

Prepare And Start XWtremWeb Server And XWtremWeb Worker
    Run Keyword If  '${XW_FORCE_GIT_CLONE}' == 'true'  Git Clone XWtremWeb
    Compile XWtremWeb
    Install XWtremWeb
    Start XWtremWeb Server And XWtremWeb Worker

Start XWtremWeb Server And XWtremWeb Worker
    Ping XWtremWeb Database
    XWServer.Start XtremWeb Server  ${DIST_XWHEP_PATH}
    XWWorker.Start XtremWeb Worker  ${DIST_XWHEP_PATH}


Stop XWtremWeb Server And XWtremWeb Worker
    XWServer.Stop XtremWeb Server
    Log XtremWeb Server
    XWWorker.Stop XtremWeb Worker

Log XtremWeb Server
    XWServer.Log XtremWeb Process Log File

Begin XWtremWeb Command Test
    Ping XWtremWeb Database
    # TODO ping XWtremWeb server up before one test
    LOG  TODO ping XWtremWeb server up
    # TODO ping XWtremWeb worker up
    LOG  TODO ping XWtremWeb worker up before one test
    MySql.Delete Fonctionnal Xtremweb Tables
    Stop XWtremWeb Server And XWtremWeb Worker
    Start XWtremWeb Server And XWtremWeb Worker


Clear XWtremWeb Cache
    ${rm_result} =  Run Process  rm -rf ${XW_CACHE_DIR}/XW*  shell=yes
    Should Be Empty	${rm_result.stderr}
    Should Be Equal As Integers	${rm_result.rc}	0
    ${rm_result} =  Run Process  rm -rf ${XW_CACHE_DIR}/xw*  shell=yes
    Should Be Empty	${rm_result.stderr}
    Should Be Equal As Integers	${rm_result.rc}	0

End XWtremWeb Command Test
    LOG  Nothing to do

Git Clone XWtremWeb
    Remove Directory  xtremweb-hep  recursive=true
    ${git_result} =  Run Process  git clone ${XW_GIT_BRANCH}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0

Compile XWtremWeb
    ${compile_result} =  Run Process  cd ${BUILD_PATH} && make clean && make  shell=yes
    Log  ${compile_result.stderr}
    #Should Be Empty	${compile_result.stderr} some warnings ...
    Log  ${compile_result.stdout}
    Should Be Equal As Integers	${compile_result.rc}	0
    ${extract_build_successful} =  Get Lines Containing String  ${compile_result.stdout}  BUILD SUCCESSFUL
    ${line_count_build_successful} =  Get Line Count  ${extract_build_successful}
    Should Be Equal As Integers	${line_count_build_successful}	3


Install XWtremWeb
    @{list_directories_dist_path} =  List Directories In Directory  ${DIST_PATH}  xwhep-*  absolute
    Log  @{list_directories_dist_path}[0]
    Set Suite Variable  ${DIST_XWHEP_PATH}  @{list_directories_dist_path}[0]
    Directory Should Exist  ${DIST_XWHEP_PATH}
    Create XWCONFIGURE.VALUES FILE  ${DIST_XWHEP_PATH}
    ${install_result} =  Run Process  cd ${DIST_XWHEP_PATH} && ./bin/xwconfigure --yes --nopkg --rmdb  shell=yes
    #Should Be Empty	${install_result.stderr} some errors
    Log  ${install_result.stdout}
    Should Be Equal As Integers	${install_result.rc}	0

    ${install_result_successful} =  Get Lines Containing String  ${install_result.stdout}  That's all folks
    ${line_install_result_successful} =  Get Line Count  ${install_result_successful}
    Should Be Equal As Integers	${line_install_result_successful}	1



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
    LOG FILE  ${DIST_XWHEP_PATH}/conf/xwconfigure.values