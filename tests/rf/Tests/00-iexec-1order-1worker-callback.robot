*** Settings ***
Documentation    iexec-full-v2
Library           ArchiveLibrary
Resource  ../Resources/DockerHelper.robot
Resource  ../Resources/GethPocoDocker.robot
Resource  ../Resources/IexecCommon.robot
Resource  ../Resources/IexecScheduler.robot
Resource  ../Resources/IexecSchedulerMock.robot
Resource  ../Resources/IexecWorker.robot
Resource  ../Resources/IexecWorkerMock.robot
Resource  ../Resources/IexecPocoAPI.robot
Resource  ../Resources/IexecSdk.robot
Resource  ../Resources/Xtremweb.robot
Resource  ../Resources/IexecCallbackTestUtils.robot
Suite Setup  This Suite Setup
Suite Teardown  This Suite Teardown
#Test Setup  This Test Setup
#Test Teardown  This Test Teardown


# prerequiste see :
# https://github.com/iExecBlockchainComputing/iexec-node/blob/master/tests/rf/README.md

# to launch all tests if robot installed on your host:
# nohup pybot -i FullV2 -v XTREMWEB_GIT_BRANCH:13.1.0 -v LOGGERLEVEL:DEBUG -v PRIVATE_KEY_SDK_TO_USE:TBD -v JWTETHISSUER:TBD -v JWTETHSECRET:TBD -d Results ./tests/rf/Tests/iexec-full-v2.robot &
# PRIVATE_KEY_SDK_TO_USE use the first account of ther geth-poco node





*** Variables ***
${REPO_DIR} =  ${CURDIR}/../repo

${XW_HOST} =  scheduler


${IEXEC_SDK_IMAGE_VERSION} =  latest
${PRIVATE_KEY_SDK_TO_USE}
${XTREMWEB_GIT_BRANCH} =  master
${START_POA_GETH_POCO} =  true
${BLOCKCHAINETHENABLED} =  true
${GETH_POCO_WORKERPOOL_CREATED_AT_START}
${GETH_POCO_RLCCONTRACT} =  0x091233035dcb12ae5a4a4b7fb144d3c5189892e1
${GETH_POCO_IEXECHUBCONTRACT} =  0xc4e4a08bf4c6fd11028b714038846006e27d7be8
${SCHEDULER_ADDRESS} =  0x8bd535d49b095ef648cd85ea827867d358872809


${IEXEC_APP_TO_CHECK} =  https://raw.githubusercontent.com/iExecBlockchainComputing/iexec-dapps-registry/master/iExecBlockchainComputing/VanityEth/iexec.json



*** Test Cases ***

Test Suite Setup Initialized
    [Tags]  FullV2
    Log  Suite Setup Initialized

Test Full V2
    [Tags]  FullV2
    #init
    IexecSdk.Prepare Iexec App For Robot Test Docker  ${IEXEC_APP_TO_CHECK}  ${GETH_POCO_IP_IN_DOCKER_NETWORK}  ${XW_HOST}  ${GETH_POCO_IEXECHUBCONTRACT}
    IexecSdk.Iexec An app Docker  wallet show




*** Keywords ***

Check WorkOrderRevealing
    [Arguments]  ${woid}
    ${logs} =  IexecPocoAPI.Curl On Iexec Poco Api  api/workorders/${woid}
    Log  ${logs}
    Should Contain  ${logs}  "status":2

Check WorkOrderCompleted
    [Arguments]  ${woid}
    ${logs} =  IexecPocoAPI.Curl On Iexec Poco Api  api/workorders/${woid}
    Log  ${logs}
    Should Contain  ${logs}  "status":4


Check Two Marketorder

    ${logs} =  IexecPocoAPI.Curl On Iexec Poco Api  api/marketorders/count
    Log  ${logs}
    Should Be Equal As Integers	 ${logs}  2

This Suite Setup
    Create Directory  ${REPO_DIR}
    IexecSdk.Init Sdk
    Xtremweb.Gradle Build Xtremweb
    Xtremweb.Start DockerCompose Xtremweb
    IexecCommon.Gradle Build Iexec Common
    IexecScheduler.Gradle Build Iexec Scheduler
    IexecWorker.Gradle Build Iexec Worker
    IexecPocoAPI.Docker Run Iexec Poco Api

    IexecCallbackTestUtils.Deploy IexecAPIContract



This Suite Teardown
    IexecPocoAPI.Docker Stop Iexec Poco Api
    Xtremweb.Stop DockerCompose Xtremweb
