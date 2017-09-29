*** Settings ***
Documentation   local geth 42 node

*** Variables ***
${GETH_UTILS_PATH} =  ./vagrant/gethUtils
${TESTRPC_UTILS_PATH} =  ./vagrant/testrpcUtils

*** Keywords ***
Start Geth42
    Create File  ~/iexecdev/password.txt  content=whatever
    ${geth_result} =  Run Process  cd ${GETH_UTILS_PATH} && ./resetANewChain42AndMine.sh  shell=yes
    Log  ${geth_result.stderr}
    Log  ${geth_result.stdout}
    Should Be Equal As Integers	${geth_result.rc}	0

Stop Geth42
    Log File  ~/iexecdev/mine42background.log
    ${geth_result} =  Run Process  cd ${GETH_UTILS_PATH} && ./killGeth.sh  shell=yes
    Log  ${geth_result.stderr}
    Log  ${geth_result.stdout}
    Should Be Equal As Integers	${geth_result.rc}	0


Give Me Five
    [Arguments]  ${to}
    ${testrpc_result} =  Run Process  cd ${GETH_UTILS_PATH} && ./giveMeFive42.sh ${to}  shell=yes
    Log  ${testrpc_result.stderr}
    Log  ${testrpc_result.stdout}
    Should Be Equal As Integers	${testrpc_result.rc}	0

Get Balance Of
    [Arguments]  ${address}
    ${testrpc_result} =  Run Process  cd ${TESTRPC_UTILS_PATH} && npm install && node balance.js ${address}  shell=yes
    Log  ${testrpc_result.stderr}
    Log  ${testrpc_result.stdout}
    Should Be Equal As Integers	${testrpc_result.rc}	0
    [Return]  ${testrpc_result.stdout}