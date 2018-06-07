*** Settings ***
Library  OperatingSystem

*** Variables ***

${REPO_DIR}

*** Keywords ***



Get Docker Container Id From Image
    [Arguments]  ${docker_image}
    ${container_id} =  Run Process  docker ps -a --filter \"ancestor\=${docker_image}\" --format \"{{.ID}}\"  shell=yes
    Log  ${container_id.stdout}
    Log  ${container_id.stderr}
    Should not be empty  ${container_id.stdout}
    [Return]  ${container_id.stdout}


Get Docker Container Id By Name
    [Arguments]  ${docker_name}
    ${container_id} =  Run Process  docker ps -a -q --filter \"name\=${docker_name}\"  shell=yes
    Log  ${container_id.stdout}
    Log  ${container_id.stderr}
    Should not be empty  ${container_id.stdout}
    [Return]  ${container_id.stdout}

Logs By Container Id
    [Arguments]  ${container_id}
    Log  ${container_id}
    Remove File  ${REPO_DIR}/${container_id}.log
    Create File  ${REPO_DIR}/${container_id}.log
    Run Process  docker logs ${container_id} > ${REPO_DIR}/${container_id}.log 2>&1  shell=yes
    Log File  ${REPO_DIR}/${container_id}.log
    ${content} =  Get File  ${REPO_DIR}/${container_id}.log
    [Return]  ${content}

Log File Of Container
    [Arguments]  ${container_id}  ${file_path}
    Log  ${container_id}
    ${cmd_result} =  Run Process  docker exec -t ${container_id} cat ${file_path}  shell=yes
    Log  ${cmd_result.stdout}
    Should Be Equal As Integers  ${cmd_result.rc}  0
    [Return]  ${cmd_result.stdout}

Logs By Image
    [Arguments]  ${docker_image}
    ${container_id} =  Get Docker Container Id From Image  ${docker_image}
    ${logs} =  Logs By Container Id  ${container_id}
    [Return]  ${logs}

Stop And Remove All Containers
    Run Process  docker stop $(docker ps -a -q)  shell=yes
    Run Process  docker rm $(docker ps -a -q)  shell=yes
    # Delete all images
    # docker rmi $(docker images -q)

Remove All Images
    Stop And Remove All Containers
    Run Process  docker rmi $(docker images -q)  shell=yes

Stop Log And Remove Container
    [Arguments]  ${container_id}
    Stop Container  ${container_id}
    Logs By Container Id  ${container_id}
    Remove Container  ${container_id}

Stop Container
    [Arguments]  ${container_id}
    Log  ${container_id}
    Run Process  docker stop ${container_id}  shell=yes

Start Container
    [Arguments]  ${container_id}
    Log  ${container_id}
    Run Process  docker start ${container_id}  shell=yes


Restart Container
    [Arguments]  ${container_id}
    Stop Container  ${container_id}
    Start Container  ${container_id}


Remove Container
    [Arguments]  ${container_id}
    Log  ${container_id}
    Run Process  docker rm -f ${container_id}  shell=yes


Copy File To Container
    [Arguments]  ${container_id}  ${src}  ${dest}
    Run Process  docker cp ${src} ${container_id}:${dest}  shell=yes

Copy File From Container
    [Arguments]  ${container_id}  ${src}  ${dest}
    Run Process  docker cp ${container_id}:${src} ${dest}  shell=yes
