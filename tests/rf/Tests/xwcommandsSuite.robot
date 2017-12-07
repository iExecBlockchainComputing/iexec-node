*** Settings ***
Documentation    All XtremWeb commands line  tests
Resource  ../Resources/XWCommon.robot
Resource  ../Resources/XWServer.robot
Resource  ../Resources/cli/XWClient.robot
Suite Setup  XWCommon.Prepare XWtremWeb Server And XWtremWeb Worker
Test Setup  XWCommon.Begin XWtremWeb Command Test
Test Teardown  XWCommon.End XWtremWeb Command Test


# to launch tests :
# pybot -d Results  ./tests/rf/Tests/xwcommandsSuite.robot
# Quicker for second launch :
# pybot --variable XW_FORCE_GIT_CLONE:false -d Results ./tests/rf/Tests/xwcommandsSuite.robot
#

*** Variables ***
${A_DAPP_ETHEREUM_ADDRESS_1} =  0xdapppethereumaddress00000000000000000001
${A_DAPP_ETHEREUM_ADDRESS_2} =  0xdapppethereumaddress00000000000000000002
${A_DAPP_ETHEREUM_ADDRESS_3} =  0xdapppethereumaddress00000000000000000003
${ANOTHER_ETHEREUM_ADDRESS}  =  0xanotheruserethereumaddress00000000000000


${FFMPEG_URI} =  https://raw.githubusercontent.com/iExecBlockchainComputing/iexec-dapp-samples/ffmpeg/apps/Ffmpeg
${BIN_DIR} =  ${CURDIR}${/}../Resources/bin

*** Test Cases ***

Test XWSenddata Command With LS Binary
    [Documentation]  Testing XWSenddata cmd
    [Tags]  CommandLine Tests
    ${uid} =  XWClient.XWSENDDATACommand  ls  DEPLOYABLE  LINUX  AMD64  /bin/ls
    XWServer.Count From Datas Where Uid  ${uid}  1
    # TODO check also values : ls  macosx  x86_64  binary  /bin/ls in datas table


Test XWSendapp Command With LS Binary
    [Documentation]  Testing XWSendapp cmd
    [Tags]  CommandLine Tests
    ${uid} =  XWClient.XWSENDAPPCommand  ls  DEPLOYABLE  LINUX  AMD64  /bin/ls
    XWServer.Count From Apps Where Uid  ${uid}  1
    ${stdout_datas} =  XWClient.XWDATASCommand
    #Log  ${stdout_datas}
    #UID='5d546735-d382-41d9-921f-27fa2b08ee63', NAME='ls'
    @{uid} =  Get Regexp Matches  ${stdout_datas}  UID='(?P<uid>.*)', NAME=  uid
    ${data_curl_result} =  XWCommon.Curl To Server  get/@{uid}[0]
    Log  ${data_curl_result}
    ${stdout_apps} =  XWClient.XWAPPSCommand
    #Log  ${stdout_apps}
    @{uid} =  Get Regexp Matches  ${stdout_apps}  UID='(?P<uid>.*)', NAME=  uid
    ${app_curl_result} =  XWCommon.Curl To Server  get/@{uid}[0]
    Log  ${app_curl_result}

Test XWSubmit and XWResults Command On LS Binary
    [Documentation]  Testing XWSubmit and XWResults cmd
    [Tags]  CommandLine Tests
    ${uid} =  XWClient.XWSENDAPPCommand  ls  DEPLOYABLE  LINUX  AMD64  /bin/ls
    XWServer.Count From Apps Where Uid  ${uid}  1
    ${workuid} =  XWSUBMITCommand  ls
    LOG  ${workuid}
    Wait Until Keyword Succeeds  3 min	5 sec  Check XWSTATUS Completed  ${workuid}
    ${results_file} =  XWRESULTSCommand  ${workuid}
    ${results_file_content} =  Get File  ${results_file}
    ${results_file_content_lines_count} =  Get Line Count  ${results_file_content}
    Should Be Equal As Integers	${results_file_content_lines_count}  2
    @{results_file_lines} =  Split To Lines  ${results_file_content}
    Should Be Equal As Strings  @{results_file_lines}[0]  stderr.txt
    Should Be Equal As Strings	@{results_file_lines}[1]  stdout.txt

Test XWSubmit and XWResults Command On LS Binary With Param
    [Documentation]  Testing XWSubmit and XWResults cmd with param
    [Tags]  CommandLine Tests
    ${uid} =  XWClient.XWSENDAPPCommand  ls  DEPLOYABLE  LINUX  AMD64  /bin/ls
    XWServer.Count From Apps Where Uid  ${uid}  1
    ${workuid} =  XWSUBMITCommand  ls -atr
    LOG  ${workuid}
    Wait Until Keyword Succeeds  3 min	5 sec  XWClient.Check XWSTATUS Completed  ${workuid}
    ${results_file} =  XWRESULTSCommand  ${workuid}
    ${results_file_content} =  Get File  ${results_file}
    ${results_file_content_lines_count} =  Get Line Count  ${results_file_content}
    Should Be Equal As Integers	${results_file_content_lines_count}  4
    @{results_file_lines} =  Split To Lines  ${results_file_content}
    Should Be Equal As Strings  @{results_file_lines}[0]  ..
    Should Be Equal As Strings	@{results_file_lines}[1]  stdout.txt
    Should Be Equal As Strings	@{results_file_lines}[2]  stderr.txt
    Should Be Equal As Strings	@{results_file_lines}[3]  .


Test XWSENDUSER and XWUSERS Command
    [Documentation]  Testing Test XWSENDUSER and XWUSERS Command
    [Tags]  CommandLine Tests
    XWClient.XWSENDUSERCommand  ${A_DAPP_ETHEREUM_ADDRESS_1}  nopass1  noemail1
    ${stdout} =  XWUSERSCommand
    Log  ${stdout}
    Should Contain	${stdout}	LOGIN='${A_DAPP_ETHEREUM_ADDRESS_1}'

Test Sendapp Call By A Admin Create A Public App
    [Documentation]  Test Sendapp Call By A Admin Create A Public App
    [Tags]  CommandLine Tests
    # deployed DAPP in the name of DAPP PROVIDER
    ${app_uid} =  XWClient.XWSENDAPPCommand  ${A_DAPP_ETHEREUM_ADDRESS_1}  DEPLOYABLE  LINUX  AMD64  /bin/echo
    ${curl_result} =  XWCommon.Curl To Server  get/${app_uid}

    ################## Public ##################
    Should Contain	${curl_result}  0x755
    ########################################

    ${workuid} =  XWSUBMITCommand  ${A_DAPP_ETHEREUM_ADDRESS_1}
    LOG  ${workuid}
    Wait Until Keyword Succeeds  3 min	5 sec  Check XWSTATUS Completed  ${workuid}

Test Sendapp Call By A Provider Create A Private App
    [Documentation]  Test Sendapp Call By A Provider Create A Private App
    [Tags]  CommandLine Tests
    XWClient.XWSENDUSERCommand  ${A_DAPP_ETHEREUM_ADDRESS_1}  nopass1  noemail1
    ${xwusers} =  XWUSERSCommand
    Should Contain	${xwusers}	LOGIN='${A_DAPP_ETHEREUM_ADDRESS_1}'
    @{dapp_provider_uid} =  Get Regexp Matches  ${xwusers}  UID='(?P<useruid>.*)', LOGIN='${A_DAPP_ETHEREUM_ADDRESS_1}'  useruid

    # ADD MANDATINGLOGIN to the DAPP PROVIDER
    XWCommon.Set MANDATINGLOGIN in Xtremweb Xlient Conf  ${DIST_XWHEP_PATH}  ${A_DAPP_ETHEREUM_ADDRESS_1}

    # deployed DAPP in the name of DAPP PROVIDER
    ${app_uid} =  XWClient.XWSENDAPPCommand  ${A_DAPP_ETHEREUM_ADDRESS_1}  DEPLOYABLE  LINUX  AMD64  /bin/echo
    ${curl_result} =  XWCommon.Curl To Server  get/${app_uid}
    # we find dapp_provider as owner in the dapo description
    Should Contain	${curl_result}  @{dapp_provider_uid}[0]

    ################## A PRIVATE APP ##################
    Should Contain	${curl_result}  0x700
    ########################################

Test Sendapp Call By A Provider Create A Private App And Force It To Public
    XWClient.XWSENDUSERCommand  ${A_DAPP_ETHEREUM_ADDRESS_2}  nopass2  noemail2
    ${xwusers} =  XWUSERSCommand
    Should Contain	${xwusers}	LOGIN='${A_DAPP_ETHEREUM_ADDRESS_2}'
    @{dapp_provider_uid} =  Get Regexp Matches  ${xwusers}  UID='(?P<useruid>.*)', LOGIN='${A_DAPP_ETHEREUM_ADDRESS_2}'  useruid

    XWClient.XWSENDUSERCommand  ${A_DAPP_ETHEREUM_ADDRESS_3}  nopass3  noemail3
    ${xwusers} =  XWUSERSCommand
    Should Contain	${xwusers}	LOGIN='${A_DAPP_ETHEREUM_ADDRESS_3}'

    # ADD MANDATINGLOGIN to the DAPP PROVIDER
    XWCommon.Set MANDATINGLOGIN in Xtremweb Xlient Conf  ${DIST_XWHEP_PATH}  ${A_DAPP_ETHEREUM_ADDRESS_2}

    # deployed DAPP in the name of DAPP PROVIDER
    ${app_uid} =  XWClient.XWSENDAPPCommand  ${A_DAPP_ETHEREUM_ADDRESS_2}  DEPLOYABLE  LINUX  AMD64  /bin/echo
    ${curl_result} =  XWCommon.Curl To Server  get/${app_uid}
    # we find dapp_provider as owner in the dapo description
    Should Contain	${curl_result}  @{dapp_provider_uid}[0]

    ################## A PRIVATE APP ##################
    Should Contain	${curl_result}  0x700
    ########################################

    # UPDATE DAPP to 0x755 rights
    XWCommon.Remove MANDATINGLOGIN in Xtremweb Xlient Conf  ${DIST_XWHEP_PATH}
    XWClient.XWCMODCommand  0x755  ${app_uid}

    ${curl_result} =  XWCommon.Curl To Server  get/${app_uid}
    # we find dapp_provider as owner in the dapo description
    Should Contain	${curl_result}  @{dapp_provider_uid}[0]

    ################## we have now a PUBLIC APP owned by provider.  ##################
    Should Contain	${curl_result}  0x755
    ########################################

    # User  and worker are now happyly using this public app from Mr Provider
    ${workuid} =  XWSUBMITCommand  ${A_DAPP_ETHEREUM_ADDRESS_2}
    LOG  ${workuid}
    Wait Until Keyword Succeeds  3 min	5 sec  Check XWSTATUS Completed  ${workuid}

    # ADD MANDATINGLOGIN to the provider
    XWCommon.Set MANDATINGLOGIN in Xtremweb Xlient Conf  ${DIST_XWHEP_PATH}  ${A_DAPP_ETHEREUM_ADDRESS_2}
    ${workuid} =  XWSUBMITCommand  ${A_DAPP_ETHEREUM_ADDRESS_2}
    LOG  ${workuid}
    Wait Until Keyword Succeeds  3 min	5 sec  Check XWSTATUS Completed  ${workuid}

    # ADD MANDATINGLOGIN to the a random guy => do not work
    XWCommon.Set MANDATINGLOGIN in Xtremweb Xlient Conf  ${DIST_XWHEP_PATH}  ${A_DAPP_ETHEREUM_ADDRESS_3}
    ${workuid} =  XWSUBMITCommand  ${A_DAPP_ETHEREUM_ADDRESS_2}
    LOG  ${workuid}
    Wait Until Keyword Succeeds  3 min	5 sec  Check XWSTATUS Completed  ${workuid}


Test XWSendapp and XWSubmit and XWResults Ffmpeg Binary
    [Documentation]  Testing XWSubmit and XWResults cmd
    [Tags]  CommandLine Tests
    ${rm_cmd_result} =  Run Process  rm ${BIN_DIR}${/}ffmpeg  shell=yes #rm old ffmpeg binary
    ${wget_cmd_result} =  Run Process  curl ${FFMPEG_URI} -o ${BIN_DIR}/ffmpeg  shell=yes
    Log  ${wget_cmd_result.stdout}
    Should Be Equal As Integers  ${wget_cmd_result.rc}  0
    ${uid} =  XWClient.XWSENDAPPCommand  ffmpeg  DEPLOYABLE  LINUX  AMD64  ${BIN_DIR}${/}ffmpeg
    XWServer.Count From Apps Where Uid  ${uid}  1
    ${rm_cmd_result} =  Run Process  rm ${BIN_DIR}${/}ffmpeg  shell=yes
    Should Be Equal As Integers  ${rm_cmd_result.rc}  0
    ${data_curl_result} =  XWCommon.Curl To Server  get/${uid}
    Log  ${data_curl_result}
    ${workuid} =  XWSUBMITCommand  ffmpeg -i demos/sample-videos/small.mp4 small.avi --xwenv http://techslides.com/demos/sample-videos/small.mp4
    LOG  ${workuid}
    Wait Until Keyword Succeeds  2 min  00 sec  Check XWSTATUS Completed  ${workuid}
    ${zip_file} =  XWRESULTSCommand  ${workuid}
    Should Contain  ${zip_file}  .zip
    ${cmd_result} =  Run Process  unzip -l ${zip_file} | grep small.avi  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Log  ${cmd_result.rc}
    Should Not Be Empty  ${cmd_result.stdout}



#Test 2.2 Soumettre un job avec ligne de commande
#    [Documentation]  Ces tests doivent prouver que la ligne de commande est prise en charge correctement. Ces tests doivent se faire avec un application qui accepte des arguments sur la ligne de commande
#    [Tags]  CommandLine Tests
#    LOG  TODO

#Test 3.2 Soumettre un job avec un petit environnement
#    [Documentation]  Typiquement un fichier ou un répertoire de moins de 10Kb.
#    [Tags]  CommandLine Tests
#    LOG  TODO

#Test 3.3 Soumettre un job avec un gros environnement
#    [Documentation]  Typiquement un fichier ou un répertoire de plus de 1Mb.
#    [Tags]  CommandLine Tests
#    LOG  TODO

#Test 4 Tester la ligne de commande et l’environnement
#    [Tags]  CommandLine Tests
#    LOG  TODO

#Test 5 Tester le matchmaking
#    [Documentation]  Ces test doivent prouver que le scheduler fonctionne correctement.Pour ce faire, il faut insérer une application avec un binaire qui ne correspond à aucun worker du déploiement. Pour ce test nous pouvons utiliser n’importe quelle application avec n’importe quel binaire. Il convient cependant de s’assurer qu’on enregistre l’application avec un type de binaire inutilisable pour le déploiement présenté dans l’introduction.
#    [Tags]  CommandLine Tests
#    LOG  TODO

#Test 6 Récupérer les résultats un job
#    [Documentation]  Récupérer les résultats un job. Vérifier les résultats. Vérifier que le job est bien supprimé.
#    [Tags]  CommandLine Tests
#    LOG  TODO

#Test 7 Tester la durée d’exécution
#    [Documentation]  Ces tests doivent prouver que la synchronisation scheduler/worker est correcte. Par défaut les messages de synchronisation worker/scheduler se font toutes les 5mn. Au bout de trois messages non reçus par le scheduler, le job est considéré comme perdu et doit être reschédulé.
#    [Tags]  CommandLine Tests
#    LOG  TODO

#Test 8 Tester la perte des jobs
#    [Documentation]
#    [Tags]  CommandLine Tests
#    LOG  TODO

*** Keywords ***

