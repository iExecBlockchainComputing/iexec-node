*** Settings ***

*** Variables ***

*** Keywords ***



Get Docker Container Id From Image
    [Arguments]  ${docker_image}
    ${container_id} =  Run Process  docker ps --filter \"ancestor\=${docker_image}\" --format \"{{.ID}}\"  shell=yes
    Log  ${container_id.stdout}
    Set Suite Variable  ${ORACLE_DOCKER_CONTAINER_ID}  ${container_id.stdout}
    ${container_id} =  Run Process  docker ps  shell=yes
    Log  ${container_id.stdout}


    ${lines} =  Get Lines Containing String  ${result.stdout}  ${docker_image}
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1

Stop And Remove All Containers
    Run Process  docker stop $(docker ps -a -q)  shell=yes
    Run Process  docker rm $(docker ps -a -q)  shell=yes


Remove All Images
    Stop And Remove All Containers
    Run Process  docker rmi $(docker images -q)  shell=yes


Init Webproxy Network
    Run Process  docker network create webproxy  shell=yes
