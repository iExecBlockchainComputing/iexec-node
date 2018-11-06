*** Settings ***

*** Variables ***

${POCO_GIT_URL} =  https://github.com/iExecBlockchainComputing/PoCo.git

*** Keywords ***


Git Clone PoCo
    Directory Should Exist  ${REPO_DIR}
    Remove Directory  ${REPO_DIR}/PoCo  recursive=true
    ${git_result} =  Run Process  cd ${REPO_DIR} && git clone -b callback ${POCO_GIT_URL}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0

Deploy IexecAPIContract
    Git Clone PoCo
    ${truffletest_result} =  Run Process  cd ${REPO_DIR}/PoCo/test/callback && npm i   shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0

    ${resultofrun} =  Run Process  cd ${REPO_DIR}/PoCo/test/callback && node deployIexecAPI.js  shell=yes
    Log  ${resultofrun.stderr}
    Log  ${resultofrun.stdout}
    Should Be Equal As Integers	${resultofrun.rc}	0
