*** Settings ***
Documentation    All XtremWeb commands line  tests
Resource  ../Resources/XWCommon.robot
Resource  ../Resources/XWServer.robot
Suite Setup  Prepare And Start XWtremWeb Server And XWtremWeb Worker
Suite Teardown  XWCommon.Stop XWtremWeb Server And XWtremWeb Worker
Test Setup  XWCommon.Begin XWtremWeb Command Test
Test Teardown  XWCommon.End XWtremWeb Command Test


# to launch tests :
# pybot  -d Results ./Tests/xwcommandsSuite.robot
# Quicker for second launch :
# pybot --variable XW_FORCE_GIT_CLONE:false -d Results ./Tests/xwcommandsSuite.robot
#


*** Test Cases ***

Test XWSenddata Command With LS Binary
    [Documentation]  Testing XWSenddata cmd
    [Tags]  CommandLine Tests
    ${uid} =  XWSENDDATACommand  ls  DEPLOYABLE  LINUX  AMD64  /bin/ls
    XWServer.Count From Datas Where Uid  ${uid}  1
    # TODO check also values : ls  macosx  x86_64  binary  /bin/ls in datas table


Test XWSendapp Command With LS Binary
    [Documentation]  Testing XWSendapp cmd
    [Tags]  CommandLine Tests
    ${uid} =  XWSENDAPPCommand  ls  DEPLOYABLE  LINUX  AMD64  /bin/ls
    XWServer.Count From Apps Where Uid  ${uid}  1
    # TODO check also values : ls  deployable  macosx  x86_64  /bin/ls in apps table

Test XWSubmit and XWResults Command On LS Binary
    [Documentation]  Testing XWSubmit and XWResults cmd
    [Tags]  CommandLine Tests
    ${uid} =  XWSENDAPPCommand  ls  DEPLOYABLE  LINUX  AMD64  /bin/ls
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
    ${uid} =  XWSENDAPPCommand  ls  DEPLOYABLE  LINUX  AMD64  /bin/ls
    XWServer.Count From Apps Where Uid  ${uid}  1
    ${workuid} =  XWSUBMITCommand  ls -atr
    LOG  ${workuid}
    Wait Until Keyword Succeeds  3 min	5 sec  Check XWSTATUS Completed  ${workuid}
    ${results_file} =  XWRESULTSCommand  ${workuid}
    ${results_file_content} =  Get File  ${results_file}
    ${results_file_content_lines_count} =  Get Line Count  ${results_file_content}
    Should Be Equal As Integers	${results_file_content_lines_count}  4
    @{results_file_lines} =  Split To Lines  ${results_file_content}
    Should Be Equal As Strings  @{results_file_lines}[0]  ..
    Should Be Equal As Strings	@{results_file_lines}[1]  stdout.txt
    Should Be Equal As Strings	@{results_file_lines}[2]  stderr.txt
    Should Be Equal As Strings	@{results_file_lines}[3]  .



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

XWSENDAPPCommand
    [Documentation]  Usage :  SENDAPP appName appType cpuType osName URI | UID : inserts/updates an application; URI or UID points to binary file ; application name must be the first parameter
    [Arguments]  ${appName}  ${appType}  ${cpuType}  ${osName}  ${uri-udi}
    ${cmd_result} =  Run Process  cd ${DIST_XWHEP_PATH}/bin && ./xwsendapp ${appName} ${appType} ${cpuType} ${osName} ${uri-udi}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers	${cmd_result.rc}	0
    ${uid} =  Get Substring  ${cmd_result.stdout}  -36
    [Return]  ${uid}

XWSENDDATACommand
    [Documentation]  Usage :  SENDDATA dataName [cpuType] [osName] [dataType] [accessRigths] [dataFile | dataURI | dataUID] : sends data and uploads data if dataFile provided
    [Arguments]  ${dataName}  ${osName}  ${cpuType}  ${dataType}  ${dataFile-dataURI-dataUID}
    ${cmd_result} =  Run Process  cd ${DIST_XWHEP_PATH}/bin && ./xwsenddata ${dataName} ${osName} ${cpuType} ${dataType} ${dataFile-dataURI-dataUID}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers	${cmd_result.rc}	0
    ${uid} =  Get Substring  ${cmd_result.stdout}  -36
    [Return]  ${uid}

XWSUBMITCommand
    [Documentation]  Usage :  XWSUBMIT appName
    [Arguments]  ${appName}
    ${cmd_result} =  Run Process  cd ${DIST_XWHEP_PATH}/bin && ./xwsubmit ${appName}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers	${cmd_result.rc}	0
    ${uid} =  Get Substring  ${cmd_result.stdout}  -36
    [Return]  ${uid}

XWSTATUSCommand
    [Documentation]  Usage :  XWSTATUS uid
    [Arguments]  ${uid}
    ${cmd_result} =  Run Process  cd ${DIST_XWHEP_PATH}/bin && ./xwstatus ${uid}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers	${cmd_result.rc}	0
    #UID='a3d8e3d1-4d6a-409b-88b7-2cef2378ccef', STATUS='PENDING', COMPLETEDDATE=NULL, LABEL=NULL
    @{status_result} =  Get Regexp Matches  ${cmd_result.stdout}  STATUS='(?P<status>.*)', COMPLETEDDATE  status
    [Return]  @{status_result}[0]

Check XWSTATUS Completed
    [Arguments]  ${uid}
    ${status_result} =  XWSTATUSCommand  ${uid}
    Should Be Equal As Strings  ${status_result}  COMPLETED

XWRESULTSCommand
    [Documentation]  Usage :  XWRESULT uid
    [Arguments]  ${uid}
    ${cmd_result} =  Run Process  cd ${DIST_XWHEP_PATH}/bin && ./xwresults ${uid}  shell=yes
    Log  ${cmd_result.stderr}
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers	${cmd_result.rc}	0
    @{results_file} =  Get Regexp Matches  ${cmd_result.stdout}  INFO : Downloaded to : (?P<file>.*)  file
    [Return]  @{results_file}[0]