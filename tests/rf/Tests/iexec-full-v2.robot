*** Settings ***
Documentation    iexec-full-v2
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
Suite Setup  This Suite Setup
Suite Teardown  This Suite Teardown
#Test Setup  This Test Setup
#Test Teardown  This Test Teardown


# to launch all tests if robot installed on your host:
# nohup pybot -v JWTETHISSUER:TBD -v JWTETHSECRET:TBD -d Results ./tests/rf/Tests/iexec-full-v2.robot &


*** Variables ***
${REPO_DIR} =  ${CURDIR}/../repo

${XW_HOST} =  scheduler


${IEXEC_SDK_IMAGE_VERSION} =  2.2.1
${PRIVATE_KEY_SDK_TO_USE}
${XTREMWEB_GIT_BRANCH} =  13.1.0
${START_POA_GETH_POCO} =  true
${BLOCKCHAINETHENABLED} =  true
${GETH_POCO_WORKERPOOL_CREATED_AT_START}
${GETH_POCO_RLCCONTRACT} =  0x091233035dcb12ae5a4a4b7fb144d3c5189892e1
${GETH_POCO_IEXECHUBCONTRACT} =  0xc4e4a08bf4c6fd11028b714038846006e27d7be8
${SCHEDULER_ADDRESS} =  0x8bd535d49b095ef648cd85ea827867d358872809



*** Test Cases ***

#nohup pybot -v JWTETHISSUER:TBD -v JWTETHSECRET:TBD  -d Results -t 'Test Suite Setup Initialized' ./tests/rf/Tests/iexec-full-v2.robot &
Test Suite Setup Initialized
    Log  Suite Setup Initialized

Test Full V2
    #init
    IexecSdk.Prepare Iexec App For Robot Test Docker  https://raw.githubusercontent.com/iExecBlockchainComputing/iexec-dapps-registry/master/iExecBlockchainComputing/Blender/iexec.json  ${GETH_POCO_IP_IN_DOCKER_NETWORK}  ${XW_HOST}  ${GETH_POCO_IEXECHUBCONTRACT}
    IexecSdk.Iexec An app Docker  wallet show

    ${logs} =  IexecPocoAPI.Curl On Iexec Poco Api  api/marketorders/count
    Log  ${logs}
    Should Be Equal As Integers	 ${logs}  0

    # create app
    ${app} =  IexecSchedulerMock.Curl On Scheduler Mock  api/createApp
    Log  ${app}

    ${logs} =  IexecSdk.Iexec An app Docker  app deploy

    @{app} =  Get Regexp Matches  ${logs}  app: '(?P<app>.*)',  app
    Log  @{app}[0]

    ${logs} =  IexecPocoAPI.Curl On Iexec Poco Api  api/apps/@{app}[0]
    Log  ${logs}

    # create marketorder
    ${logs} =  Xtremweb.Curl On Scheduler  sendmarketorder?XWLOGIN=admin&XWPASSWD=adminp&XMLDESC=<marketorder><direction>ASK</direction><categoryid>1</categoryid><expectedworkers>1</expectedworkers><nbworkers>0</nbworkers><trust>50</trust><price>1</price><volume>1</volume><workerpooladdr>${GETH_POCO_WORKERPOOL_CREATED_AT_START}</workerpooladdr><workerpoolowneraddr>${SCHEDULER_ADDRESS}</workerpoolowneraddr></marketorder>
    Log  ${logs}
    ${logs} =  Xtremweb.Curl On Scheduler  getmarketorders?XWLOGIN=admin&XWPASSWD=adminp
    Log  ${logs}
    Should Contain  ${logs}	 XMLVector SIZE="1"

    Wait Until Keyword Succeeds  2 min	3 sec  Check One Marketorder

    #${logs} =  IexecSdk.Iexec An app Docker  order count
    #Should Be Equal As Integers	 ${logs}  1

    #deposit
    ${logs} =  IexecSdk.Iexec An app Docker  account deposit 30000
    Log  ${logs}

    #buyforworkorder
    ${logs} =  IexecSdk.Iexec An app Docker  order fill 1
    Log  ${logs}

    #TODO check allowtocontribute
    #TODO check contributed
    #TODO check revealConsensus
    #TODO check reveal
    #TODO check finializeWork





*** Keywords ***


Check One Marketorder
    ${logs} =  IexecPocoAPI.Curl On Iexec Poco Api  api/marketorders/count
    Log  ${logs}
    Should Be Equal As Integers	 ${logs}  1

This Suite Setup
    Create Directory  ${REPO_DIR}
    IexecSdk.Init Sdk
    Xtremweb.Gradle Build Xtremweb
    Xtremweb.Start DockerCompose Xtremweb
    IexecCommon.Gradle Build Iexec Common
    IexecScheduler.Gradle Build Iexec Scheduler
    IexecSchedulerMock.Docker Run Iexec Scheduler Mock
    IexecWorker.Gradle Build Iexec Worker
    #IexecWorkerMock.Docker Run Iexec Worker Mock
    IexecPocoAPI.Docker Run Iexec Poco Api



This Suite Teardown
    IexecPocoAPI.Docker Stop Iexec Poco Api
    #IexecWorkerMock.Docker Stop Worker Mock
    IexecSchedulerMock.Docker Stop Scheduler Mock
    Xtremweb.Stop DockerCompose Xtremweb