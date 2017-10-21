*** Settings ***
Documentation    All XtremWeb commands line  tests
Resource  ../Resources/XWCommon.robot
Resource  ../Resources/XWServer.robot
Resource  ../Resources/cli/XWClient.robot
Suite Setup  XWCommon.Prepare XWtremWeb Server And XWtremWeb Worker
Test Setup  XWCommon.Begin XWtremWeb Command Test
Test Teardown  XWCommon.End XWtremWeb Command Test


# to launch tests :
# pybot -d Results -t "Test MANDATINGLOGIN" ./tests/rf/Tests/xwcommandsSuite.robot
# Quicker for second launch :
# pybot --variable XW_FORCE_GIT_CLONE:false -d Results ./tests/rf/Tests/xwcommandsSuite.robot
#

*** Variables ***
${A_DAPP_PROVIDER_ETHEREUM_ADDRESS} =  0xdappproviderethereumaddress0000000000000
${ANOTHER_ETHEREUM_ADDRESS} =  0xanotheruserethereumaddress00000000000000


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
    # TODO check also values : ls  deployable  macosx  x86_64  /bin/ls in apps table

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
    XWClient.XWSENDUSERCommand  ${A_DAPP_PROVIDER_ETHEREUM_ADDRESS}  nopass  noemail
    ${stdout} =  XWUSERSCommand
    Log  ${stdout}
    Should Contain	${stdout}	LOGIN='${A_DAPP_PROVIDER_ETHEREUM_ADDRESS}'


Test MANDATINGLOGIN
    [Documentation]  Testing MANDATINGLOGIN
    [Tags]  CommandLine Tests
    XWClient.XWSENDUSERCommand  ${A_DAPP_PROVIDER_ETHEREUM_ADDRESS}  nopass  noemail

    ${xwusers} =  XWUSERSCommand
    Should Contain	${xwusers}	LOGIN='${A_DAPP_PROVIDER_ETHEREUM_ADDRESS}'
    #UID='6865841a-c45d-488c-b51c-bf666e5b0854', LOGIN='0xc2cc35ccfbded406460c74ba22249cc88a615e9c'

    @{dapp_provider_uid} =  Get Regexp Matches  ${xwusers}  UID='(?P<useruid>.*)', LOGIN='${A_DAPP_PROVIDER_ETHEREUM_ADDRESS}'  useruid

    # ADD MANDATINGLOGIN to the DAPP PROVIDER
    XWCommon.Set MANDATINGLOGIN in Xtremweb Xlient Conf  ${DIST_XWHEP_PATH}  ${A_DAPP_PROVIDER_ETHEREUM_ADDRESS}
    # deployed DAPP in the name of DAPP PROVIDER
    ${app_uid} =  XWClient.XWSENDAPPCommand  ${A_DAPP_PROVIDER_ETHEREUM_ADDRESS}  DEPLOYABLE  LINUX  AMD64  /bin/echo
    ${curl_result} =  XWCommon.Curl To Server  get/${app_uid}
    # we find dapp_provider as owner in the dapo description
    Should Contain	${curl_result}  @{dapp_provider_uid}[0]


    ${workuid} =  XWSUBMITCommand  ${A_DAPP_PROVIDER_ETHEREUM_ADDRESS}
    LOG  ${workuid}
    Wait Until Keyword Succeeds  2 min	5 sec  Check XWSTATUS Completed  ${workuid}
    # worker




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

