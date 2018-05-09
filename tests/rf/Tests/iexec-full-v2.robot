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
# nohup pybot -d Results ./tests/rf/Tests/iexec-full-v2.robot &


*** Variables ***
${REPO_DIR} =  ${CURDIR}/../repo

${XW_HOST} =  scheduler


*** Test Cases ***

#nohup pybot -d Results -t 'Test Suite Setup Initialized' ./tests/rf/Tests/iexec-full-v2.robot &
Test Suite Setup Initialized
    Log  Suite Setup Initialized

Test Only With Mock
    ${logs} =  IexecSchedulerMock.Curl On Scheduler Mock  getMarketOrdersCount
    Log  ${logs}




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