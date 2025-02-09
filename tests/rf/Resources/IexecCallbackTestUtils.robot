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

    ${sed_result} =  Run Process  cd ${REPO_DIR}/PoCo && sed "s/localhost/${GETH_POCO_IP_IN_DOCKER_NETWORK}/g" truffle.js > truffle.js.tmp && cat truffle.js.tmp > truffle.js   shell=yes
    Log  ${sed_result.stderr}
    Log  ${sed_result.stdout}
    Should Be Equal As Integers	${sed_result.rc}	0



Deploy IexecAPIContract
    Git Clone PoCo
    ${npm_result} =  Run Process  cd ${REPO_DIR}/PoCo && npm i   shell=yes
    Log  ${npm_result.stderr}
    Log  ${npm_result.stdout}
    Should Be Equal As Integers	${npm_result.rc}	0

    ${npm_result} =  Run Process  cd ${REPO_DIR}/PoCo/test/callback && npm i   shell=yes
    Log  ${npm_result.stderr}
    Log  ${npm_result.stdout}
    Should Be Equal As Integers	${npm_result.rc}	0

    ${npm_result} =  Run Process  cd ${REPO_DIR}/PoCo/test/callbackweb3old && npm i   shell=yes
    Log  ${npm_result.stderr}
    Log  ${npm_result.stdout}
    Should Be Equal As Integers	${npm_result.rc}	0

    ${unlockcheck_result} =  Run Process  cd ${REPO_DIR}/PoCo/test/callback && node isUnlock.js  shell=yes
    Log  ${unlockcheck_result.stderr}
    Log  ${unlockcheck_result.stdout}
    Should Be Equal As Integers	${unlockcheck_result.rc}	0

    #${resultofrun} =  Run Process  cd ${REPO_DIR}/PoCo/test/callback && node deployIexecAPI.js  shell=yes
    #Log  ${resultofrun.stderr}
    #Log  ${resultofrun.stdout}
    #Should Be Equal As Integers	${resultofrun.rc}	0

    ${trufflemigrate_result} =  Run Process  cd ${REPO_DIR}/PoCo/ && ./node_modules/.bin/truffle migrate  shell=yes
    Log  ${trufflemigrate_result.stderr}
    Log  ${trufflemigrate_result.stdout}

    ${approveIexecHub} =  Run Process  cd ${REPO_DIR}/PoCo/test/callback && node transferRLC.js  shell=yes
    Log  ${approveIexecHub.stderr}
    Log  ${approveIexecHub.stdout}
    Should Be Equal As Integers	${approveIexecHub.rc}	0

    ${approveIexecHub} =  Run Process  cd ${REPO_DIR}/PoCo/test/callback && node approveIexecHub.js  shell=yes
    Log  ${approveIexecHub.stderr}
    Log  ${approveIexecHub.stdout}
    Should Be Equal As Integers	${approveIexecHub.rc}	0

    ${approveIexecHub} =  Run Process  cd ${REPO_DIR}/PoCo/test/callback && node depositRLCOnIexecHub.js  shell=yes
    Log  ${approveIexecHub.stderr}
    Log  ${approveIexecHub.stdout}
    Should Be Equal As Integers	${approveIexecHub.rc}	0


Check Balances
    ${checkBalanceIexecHub} =  Run Process  cd ${REPO_DIR}/PoCo/test/callback && node checkBalance.js  shell=yes
    Log  ${checkBalanceIexecHub.stderr}
    Log  ${checkBalanceIexecHub.stdout}
    Should Be Equal As Integers	${checkBalanceIexecHub.rc}	0


Buy For WorkOrder
    ${buyForWorkOrderIexecHub} =  Run Process  cd ${REPO_DIR}/PoCo/test/callback && node buyForWorkOrder.js  shell=yes
    Log  ${buyForWorkOrderIexecHub.stderr}
    Log  ${buyForWorkOrderIexecHub.stdout}
    Should Be Equal As Integers	${buyForWorkOrderIexecHub.rc}	0


Tx Receipt
    ${getTransactionReceiptJS} =  Run Process  cd ${REPO_DIR}/PoCo/test/callback && node getTransactionReceipt.js  shell=yes
    Log  ${getTransactionReceiptJS.stderr}
    Log  ${getTransactionReceiptJS.stdout}
    Should Be Equal As Integers	${getTransactionReceiptJS.rc}	0


Test IsCallbackDone
    ${isCallbackDoneJS} =  Run Process  cd ${REPO_DIR}/PoCo/test/callback && node isCallbackDone.js  shell=yes
    Log  ${isCallbackDoneJS.stderr}
    Log  ${isCallbackDoneJS.stdout}
    Should Be Equal As Integers	${isCallbackDoneJS.rc}	0


Watch CallBackEvent
    ${watchCallbackIexecHub} =  Run Process  cd ${REPO_DIR}/PoCo/test/callbackweb3old && node watchCallback.js  shell=yes
    Log  ${watchCallbackIexecHub.stderr}
    Log  ${watchCallbackIexecHub.stdout}
    Should Be Equal As Integers	${watchCallbackIexecHub.rc}	0
    [Return]  ${watchCallbackIexecHub.stdout}

Buy For WorkOrder Old
    ${buyForWorkOrderIexecHub} =  Run Process  cd ${REPO_DIR}/PoCo/test/callbackweb3old && node buyForWorkOrder.js  shell=yes
    Log  ${buyForWorkOrderIexecHub.stderr}
    Log  ${buyForWorkOrderIexecHub.stdout}
    Should Be Equal As Integers	${buyForWorkOrderIexecHub.rc}	0
    [Return]  ${buyForWorkOrderIexecHub.stdout}
