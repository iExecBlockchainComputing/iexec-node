*** Settings ***

*** Variables ***
${IEXEC_ORACLE_GIT_URL} =  https://github.com/iExecBlockchainComputing/iexec-oracle-contract.git
${IEXEC_ORACLE_GIT_BRANCH} =  master
${IEXEC_ORACLE_FORCE_GIT_CLONE} =  false
${IEXEC_ORACLE_SM_ADDRESS}
${HELLO_WORLD_SM_ADDRESS}
*** Keywords ***

Init Oracle Docker
    Run Keyword If  '${IEXEC_ORACLE_FORCE_GIT_CLONE}' == 'true'  Git Clone Iexec Oracle Docker
    ${docker_build} =  Run Process  cd iexec-oracle-contract && docker build -t iexec-oracle-contract:latest . -f ./Dockerfile.dev  shell=yes  	stderr=STDOUT  timeout=140s  stdout=stdoutoracle.txt
    Log  ${docker_build.stdout}
    Should Be Equal As Integers	${docker_build.rc}	0



Git Clone Iexec Oracle Docker
    Remove Directory  iexec-oracle-contract  recursive=true
    ${git_result} =  Run Process  git clone -b ${IEXEC_ORACLE_GIT_BRANCH} ${IEXEC_ORACLE_GIT_URL}  shell=yes
    Log  ${git_result.stderr}
    Log  ${git_result.stdout}
    Should Be Equal As Integers	${git_result.rc}	0


Iexec Oracle Truffle Tests Docker
    [Documentation]  call truffle test and show the result here.
    [Tags]  Smart contract Tests
    ${truffletest_result} =  Run Process  cd iexec-oracle-contract && docker-compose -f docker-compose.dev.yml run iexec-oracle ./node_modules/.bin/truffle test test/iexecoracleapi.js --network docker  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0


Iexec Oracle Truffle Migrate Docker
    [Documentation]  call truffle migrate
    [Tags]  Smart contract Tests
    ${truffletest_result} =  Run Process  cd iexec-oracle-contract && docker-compose -f docker-compose.dev.yml run iexec-oracle ./node_modules/.bin/truffle migrate --network docker  shell=yes
    Log  ${truffletest_result.stderr}
    Log  ${truffletest_result.stdout}
    Should Be Equal As Integers	${truffletest_result.rc}	0

    @{smartContractAddress} =  Get Regexp Matches  ${truffletest_result.stdout}  IexecOracle deployed at address :(?P<smartContractAddress>.*)  smartContractAddress
    LOG  @{smartContractAddress}
    LOG  @{smartContractAddress}[0]
    Set Suite Variable  ${IEXEC_ORACLE_SM_ADDRESS}  @{smartContractAddress}[0]

    @{smartContractAddress} =  Get Regexp Matches  ${truffletest_result.stdout}  IexecOracleAPIimpl deployed at address :(?P<smartContractAddress>.*)  smartContractAddress
    LOG  @{smartContractAddress}
    LOG  @{smartContractAddress}[0]
    Set Suite Variable  ${HELLO_WORLD_SM_ADDRESS}  @{smartContractAddress}[0]
