*** Settings ***
Documentation    iexec-full-v2
Resource  ../Resources/DockerHelper.robot
Resource  ../Resources/GethPocoDocker.robot
Resource  ../Resources/IexecCommon.robot
Resource  ../Resources/IexecScheduler.robot
Resource  ../Resources/IexecSchedulerMock.robot
Resource  ../Resources/IexecWorker.robot
Resource  ../Resources/IexecWorkerMock.robot
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


${XTREMWEB_GIT_BRANCH} =  support-blockchainenabled-in-docker-env
${START_POA_GETH_POCO} =  true
${BLOCKCHAINETHENABLED} =  true
${GETH_POCO_WORKERPOOL_CREATED_AT_START}


*** Test Cases ***

#nohup pybot -v JWTETHISSUER:TBD -v JWTETHSECRET:TBD  -d Results -t 'Test Suite Setup Initialized' ./tests/rf/Tests/iexec-full-v2.robot &
Test Suite Setup Initialized
    Log  Suite Setup Initialized

Test Full V2
    ${logs} =  IexecSchedulerMock.Curl On Scheduler Mock  api/getMarketOrdersCount
    Log  ${logs}
    Should Be Equal As Integers	 ${logs}  0

    # create app
    ${app} =  IexecSchedulerMock.Curl On Scheduler Mock  api/createApp
    Log  ${app}

    # create marketorder
    ${logs} =  Xtremweb.Curl On Scheduler  sendmarketorder?XWLOGIN=admin&XWPASSWD=adminp&XMLDESC=<marketorder><direction>ASK</direction><categoryid>1</categoryid><expectedworkers>1</expectedworkers><nbworkers>0</nbworkers><trust>50</trust><price>1</price><volume>1</volume><workerpooladdr>${GETH_POCO_WORKERPOOL_CREATED_AT_START}</workerpooladdr><workerpoolowneraddr>0x8bd535d49b095ef648cd85ea827867d358872809</workerpoolowneraddr></marketorder>
    Log  ${logs}
    ${logs} =  Xtremweb.Curl On Scheduler  getmarketorders?XWLOGIN=admin&XWPASSWD=adminp
    Log  ${logs}
    Should Contain  ${logs}	 XMLVector SIZE="1"

    #TODO check buyforworkorder
    #TODO check allowtocontribute
    #TODO check contributed
    #TODO check revealConsensus
    #TODO check reveal
    #TODO check finializeWork




*** Keywords ***

This Suite Setup
    Create Directory  ${REPO_DIR}
    IexecSdk.Init Sdk
    Xtremweb.Gradle Build Xtremweb
    Xtremweb.Start DockerCompose Xtremweb
    IexecCommon.Gradle Build Iexec Common
    IexecScheduler.Gradle Build Iexec Scheduler
    IexecSchedulerMock.Docker Run Iexec Scheduler Mock
    IexecWorker.Gradle Build Iexec Worker
    IexecWorkerMock.Docker Run Iexec Worker Mock


This Suite Teardown
    IexecWorkerMock.Docker Stop Worker Mock
    IexecSchedulerMock.Docker Stop Scheduler Mock
    Xtremweb.Stop DockerCompose Xtremweb