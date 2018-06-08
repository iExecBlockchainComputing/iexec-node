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


# prerequiste see :
# https://github.com/iExecBlockchainComputing/iexec-node/blob/master/tests/rf/README.md

# to launch all tests if robot installed on your host:
# nohup pybot -i FullV2 -v XTREMWEB_GIT_BRANCH:13.1.0 -v LOGGERLEVEL:DEBUG -v PRIVATE_KEY_SDK_TO_USE:TBD -v JWTETHISSUER:TBD -v JWTETHSECRET:TBD -d Results ./tests/rf/Tests/01-iexec-2orders-seq-1worker.robot &
# PRIVATE_KEY_SDK_TO_USE use the first account of ther geth-poco node





*** Variables ***
${REPO_DIR} =  ${CURDIR}/../repo

${XW_HOST} =  scheduler

${IEXEC_APP_TO_CHECK} =  https://raw.githubusercontent.com/iExecBlockchainComputing/iexec-dapps-registry/master/iExecBlockchainComputing/VanityEth/iexec.json

${IEXEC_SDK_IMAGE_VERSION} =  2.2.15
${PRIVATE_KEY_SDK_TO_USE}
${XTREMWEB_GIT_BRANCH} =  13.1.0
${START_POA_GETH_POCO} =  true
${BLOCKCHAINETHENABLED} =  true
${GETH_POCO_WORKERPOOL_CREATED_AT_START}
${GETH_POCO_RLCCONTRACT} =  0x091233035dcb12ae5a4a4b7fb144d3c5189892e1
${GETH_POCO_IEXECHUBCONTRACT} =  0xc4e4a08bf4c6fd11028b714038846006e27d7be8
${SCHEDULER_ADDRESS} =  0x8bd535d49b095ef648cd85ea827867d358872809



*** Test Cases ***

Test Suite Setup Initialized
    [Tags]  FullV2
    Log  Suite Setup Initialized

Test Full V2
    [Tags]  FullV2
    #init
    IexecSdk.Prepare Iexec App For Robot Test Docker  ${IEXEC_APP_TO_CHECK}  ${GETH_POCO_IP_IN_DOCKER_NETWORK}  ${XW_HOST}  ${GETH_POCO_IEXECHUBCONTRACT}
    IexecSdk.Iexec An app Docker  wallet show

    ${logs} =  IexecPocoAPI.Curl On Iexec Poco Api  api/marketorders/count
    Log  ${logs}
    Should Be Equal As Integers	 ${logs}  0

    # create app

    ${logs} =  IexecSdk.Iexec An app Docker  app deploy

    @{app} =  Get Regexp Matches  ${logs}  app: '(?P<app>.*)',  app
    Log  @{app}[0]

    ${logs} =  IexecSdk.Iexec An app Docker  app show @{app}[0]
    Log  ${logs}

    ${logs} =  IexecPocoAPI.Curl On Iexec Poco Api  api/apps/@{app}[0]
    Log  ${logs}

    # add app address in iexec.json
    IexecSdk.Add App To Buy To Iexec Conf  @{app}[0]

    # create marketorder
    ${logs} =  Xtremweb.Curl On Scheduler  sendmarketorder?XWLOGIN=admin&XWPASSWD=adminp&XMLDESC=<marketorder><direction>ASK</direction><categoryid>5</categoryid><expectedworkers>1</expectedworkers><nbworkers>0</nbworkers><trust>50</trust><price>1</price><volume>1</volume><workerpooladdr>${GETH_POCO_WORKERPOOL_CREATED_AT_START}</workerpooladdr><workerpoolowneraddr>${SCHEDULER_ADDRESS}</workerpoolowneraddr></marketorder>
    Log  ${logs}

    ${logs} =  Xtremweb.Curl On Scheduler  getmarketorders?XWLOGIN=admin&XWPASSWD=adminp
    Log  ${logs}
    Should Contain  ${logs}	 XMLVector SIZE="1"

    Wait Until Keyword Succeeds  2 min	3 sec  Check One Marketorder

    ${logs} =  IexecPocoAPI.Curl On Iexec Poco Api  api/marketorders/1
    Log  ${logs}

    #deposit
    ${logs} =  IexecSdk.Iexec An app Docker  account deposit 30000
    Log  ${logs}

    ${logs} =  IexecSdk.Iexec An app Docker  order show 1
    Log  ${logs}

    #buyforworkorder
    ${logs} =  IexecSdk.Iexec An app Docker  order fill 1 --force
    Log  ${logs}
    Should Contain  ${logs}  woid
    @{woid} =  Get Regexp Matches  ${logs}  woid: '(?P<woid>.*)',  woid
    Log  @{woid}[0]

    Wait Until Keyword Succeeds  3 min	3 sec  Check WorkOrderRevealing  @{woid}[0]

    Wait Until Keyword Succeeds  3 min	3 sec  Check WorkOrderCompleted  @{woid}[0]

    ${logs} =  IexecSdk.Iexec An app Docker  work show @{woid}[0]
    Log  ${logs}
    Should Contain  ${logs}	 m_uri: 'xw://scheduler

    #launch 2
    ${logs} =  Xtremweb.Curl On Scheduler  sendmarketorder?XWLOGIN=admin&XWPASSWD=adminp&XMLDESC=<marketorder><direction>ASK</direction><categoryid>5</categoryid><expectedworkers>1</expectedworkers><nbworkers>0</nbworkers><trust>50</trust><price>1</price><volume>1</volume><workerpooladdr>${GETH_POCO_WORKERPOOL_CREATED_AT_START}</workerpooladdr><workerpoolowneraddr>${SCHEDULER_ADDRESS}</workerpoolowneraddr></marketorder>
    Log  ${logs}

    ${logs} =  Xtremweb.Curl On Scheduler  getmarketorders?XWLOGIN=admin&XWPASSWD=adminp
    Log  ${logs}
    Should Contain  ${logs}	 XMLVector SIZE="2"

    Wait Until Keyword Succeeds  2 min	3 sec  Check Two Marketorder

    ${logs} =  IexecSdk.Iexec An app Docker  order fill 2 --force
    Log  ${logs}
    Should Contain  ${logs}  woid
    @{woid2} =  Get Regexp Matches  ${logs}  woid: '(?P<woid>.*)',  woid
    Log  @{woid2}[0]

    Wait Until Keyword Succeeds  3 min	3 sec  Check WorkOrderRevealing  @{woid2}[0]

    Wait Until Keyword Succeeds  3 min	3 sec  Check WorkOrderCompleted  @{woid2}[0]

    ${logs} =  IexecSdk.Iexec An app Docker  work show @{woid2}[0]
    Log  ${logs}
    Should Contain  ${logs}	 m_uri: 'xw://scheduler


    ${logs} =  IexecSdk.Iexec An app Docker  account login --force
    Log  ${logs}

    ${logs} =  IexecSdk.Iexec An app Docker  work show @{woid}[0] --watch --download
    Log  ${logs}
    Should Contain  ${logs}  resultUID


    Archive Should Contain File  ${REPO_DIR}/iexec-app/@{woid}[0].zip  consensus.iexec

    ${logs} =  IexecSdk.Iexec An app Docker  work show @{woid2}[0] --watch --download
    Log  ${logs}
    Should Contain  ${logs}  resultUID

    Archive Should Contain File  ${REPO_DIR}/iexec-app/@{woid2}[0].zip  consensus.iexec


     Extract Zip File  ${REPO_DIR}/iexec-app/@{woid}[0].zip    ${REPO_DIR}/iexec-app/zipout1
     ${stdout} =  Get File  ${REPO_DIR}/iexec-app/zipout1/consensus.iexec
     Log  ${stdout}

     Extract Zip File  ${REPO_DIR}/iexec-app/@{woid2}[0].zip    ${REPO_DIR}/iexec-app/zipout2
     ${stdout} =  Get File  ${REPO_DIR}/iexec-app/zipout2/consensus.iexec
     Log  ${stdout}

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


Check One Marketorder
    ${logs} =  IexecPocoAPI.Curl On Iexec Poco Api  api/marketorders/count
    Log  ${logs}
    Should Be Equal As Integers	 ${logs}  1


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



This Suite Teardown
    IexecPocoAPI.Docker Stop Iexec Poco Api
    Xtremweb.Stop DockerCompose Xtremweb