*** Settings ***
Documentation   local geth 42 node

*** Variables ***
${GETH_UTILS_PATH} =  ../../../vagrant/gethUtils

*** Keywords ***
Start Geth42
    ${geth_result} =  Run Process  cd ${GETH_UTILS_PATH} && ./resetANewChain42AndMine.sh  shell=yes
    Log  ${geth_result.stderr}
    Log  ${geth_result.stdout}
    Should Be Equal As Integers	${geth_result.rc}	0

Stop Geth42
    ${geth_result} =  Run Process  cd ${GETH_UTILS_PATH} && ./killGeth.sh  shell=yes
    Log  ${geth_result.stderr}
    Log  ${geth_result.stdout}
    Should Be Equal As Integers	${geth_result.rc}	0