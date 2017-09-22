*** Settings ***
Library  Process
Library  OperatingSystem
Library  String

*** Variables ***

*** Keywords ***

Init Sdk
    Wait Until Keyword Succeeds  8 min	2 min  Npm Install Iexec Sdk



Npm Install Iexec Sdk
    ${npm_result} =  Run Process  npm i iexec -g  shell=yes
    Log  ${npm_result.stderr}
    Log  ${npm_result.stdout}
    Should Be Equal As Integers	${npm_result.rc}	0
    ${iexec_result} =  Run Process  iexec --version  shell=yes
    Log  ${iexec_result.stderr}
    Log  ${iexec_result.stdout}
    Should Be Equal As Integers	${iexec_result.rc}	0
    ${iexec_result} =  Run Process  iexec --help  shell=yes
    Log  ${iexec_result.stderr}
    Log  ${iexec_result.stdout}
    Should Be Equal As Integers	${iexec_result.rc}	0


Iexec
    [Arguments]  ${args}
    ${iexec_result} =  Run Process  iexec ${args}  shell=yes
    Log  ${iexec_result.stderr}
    Log  ${iexec_result.stdout}
    Should Be Equal As Integers	${iexec_result.rc}	0
    [Return]  ${iexec_result.stdout}

Iexec An app
    [Arguments]  ${directory}  ${args}
    ${iexec_result} =  Run Process  cd ${directory} && iexec ${args}  shell=yes
    Log  ${iexec_result.stderr}
    Log  ${iexec_result.stdout}
    Should Be Equal As Integers	${iexec_result.rc}	0
    [Return]  ${iexec_result.stdout}


Iexec Init An App
    [Arguments]  ${appName}
    ${iexec_result} =  Run Process  iexec init ${appName}  shell=yes
    Log  ${iexec_result.stderr}
    Log  ${iexec_result.stdout}
    Should Be Equal As Integers	${iexec_result.rc}	0
    [Return]  ${iexec_result.stdout}