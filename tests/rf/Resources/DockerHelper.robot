*** Settings ***

*** Variables ***

*** Keywords ***



Get Docker Container Id From Image
    [Arguments]  ${docker_image}
    ${container_id} =  Run Process  docker ps -a --filter \"ancestor\=${docker_image}\" --format \"{{.ID}}\"  shell=yes
    Log  ${container_id.stdout}
    Log  ${container_id.stderr}
    Should not be empty  ${container_id.stdout}
    [Return]  ${container_id.stdout}

Logs By Container Id
    [Arguments]  ${container_id}
    Log  ${container_id}
    Remove File  ${CURDIR}/${container_id}.log
    Create File  ${CURDIR}/${container_id}.log
    Run Process  docker logs ${container_id} > ${CURDIR}/${container_id}.log 2>&1  shell=yes
    Log File  ${CURDIR}/${container_id}.log
    ${content} =  Get File  ${CURDIR}/${container_id}.log
    [Return]  ${content}

Logs By Image
    [Arguments]  ${docker_image}
    ${container_id} =  Get Docker Container Id From Image  ${docker_image}
    ${logs} =  Logs By Container Id  ${container_id}
    [Return]  ${logs}

Stop And Remove All Containers
    Run Process  docker stop $(docker ps -a -q)  shell=yes
    Run Process  docker rm $(docker ps -a -q)  shell=yes

Remove All Images
    Stop And Remove All Containers
    Run Process  docker rmi $(docker images -q)  shell=yes

Remove Container
    [Arguments]  ${container_id}
    Log  ${container_id}
    Run Process  docker rm -f ${container_id}  shell=yes



Init Webproxy Network
    Run Process  docker network create webproxy  shell=yes
