*** Settings ***

*** Variables ***
${IEXEC_ORACLE_GIT_BRANCH} =  https://github.com/iExecBlockchainComputing/iexec-oracle.git
${IEXEC_ORACLE_FORCE_GIT_CLONE} =  true
${BRIDGE_PROCESS}
*** Keywords ***


Git Clone Iexec Oracle
    Remove Directory  iexec-oracle  recursive=true
    ${git_result} =  Run Process  git clone ${IEXEC_ORACLE_GIT_BRANCH}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0
    ${npm_result} =  Run Process  cd iexec-oracle/API && npm install  shell=yes
    Log  ${npm_result.stderr}
    Log  ${npm_result.stdout}
    Should Be Equal As Integers	${npm_result.rc}	0
    ${npm_result} =  Run Process  cd iexec-oracle/Bridge && npm install  shell=yes
    Log  ${npm_result.stderr}
    Log  ${npm_result.stdout}
    Should Be Equal As Integers	${npm_result.rc}	0

Iexec Oracle Truffle Tests
    [Documentation]  call truffle test and show the result here.
    [Tags]  Smart contract Tests
    Run Keyword If  '${IEXEC_ORACLE_FORCE_GIT_CLONE}' == 'true'  Git Clone Iexec Oracle
    ${truffletest_result} =  Run Process  cd iexec-oracle/API && ./node_modules/.bin/truffle test test/iexecoracleapi.js  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0


Iexec Oracle Truffle Migrate
    [Documentation]  call truffle migrate
    [Tags]  Smart contract Tests
    Run Keyword If  '${IEXEC_ORACLE_FORCE_GIT_CLONE}' == 'true'  Git Clone Iexec Oracle
    ${rm_result} =  Run Process  rm -rf iexec-oracle/API/build  shell=yes
    Should Be Empty	${rm_result.stderr}
    Should Be Equal As Integers	${rm_result.rc}	0
    ${truffletest_result} =  Run Process  cd iexec-oracle/API && ./node_modules/.bin/truffle migrate  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0
    Iexec Oracle Set Build Contract Address In Bridge

Iexec Oracle Set Build Contract Address In Bridge
    ${iexecOracle_json_content} =  Get File  iexec-oracle/API/build/contracts/IexecOracle.json
    @{smartContractAddress} =  Get Regexp Matches  ${iexecOracle_json_content}  "address": "(?P<smartContractAddress>.*)",  smartContractAddress
    LOG  @{smartContractAddress}
    LOG  @{smartContractAddress}[0]
    Run  sed -i 's/.*"ContractAddress":.*/"ContractAddress":\"@{smartContractAddress}[0]\"/g' iexec-oracle/Bridge/config.json

#"ContractAddress": "0x7883d350e42c3e198e1f8c8b1812abbc34b68284"
    #echo "update address in ~/iexecdev/iexec-node/poc/stockfish/front/app/js/app.js"
    #sed -i "s/.*var contract_address =.*/var contract_address =\"${STOCKFISH_CONTRACT_ADDRESS}\";/g" ~/iexecdev/iexec-node/poc/stockfish/front/app/js/app.js
    #echo "update address in ~/iexecdev/iexec-node/poc/stockfish/bridge/stockfish.js"
    #sed -i "s/.*var contract_address =.*/var contract_address =\"${STOCKFISH_CONTRACT_ADDRESS}\";/g" ~/iexecdev/iexec-node/poc/stockfish/bridge/stockfish.js


    #"address":

   # "ContractAddress": "0x7883d350e42c3e198e1f8c8b1812abbc34b68284"

Iexec Oracle Set XtremWeb Config In Bridge
    LOG  ${XWCONFIGURE.VALUES.XWSERVER}
    LOG  ${XWCONFIGURE.VALUES.HTTPSPORT}
    Run  sed -i 's/.*const LOCALHOSTNAME = .*/const LOCALHOSTNAME = ${XWCONFIGURE.VALUES.XWSERVER};/g' iexec-oracle/Bridge/xwhep.js
    Run  sed -i 's/.*const LOCALHOSTPORT = .*/const LOCALHOSTPORT = ${XWCONFIGURE.VALUES.HTTPSPORT};/g' iexec-oracle/Bridge/xwhep.js

Start Bridge
    ${created_process} =  Start Process  cd iexec-oracle/Bridge && npm run devbridge  shell=yes
    Set Suite Variable  ${BRIDGE_PROCESS}  ${created_process}

Stop Bridge
    Terminate Process  ${BRIDGE_PROCESS}