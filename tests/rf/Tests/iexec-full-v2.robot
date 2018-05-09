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


*** Keywords ***

This Suite Setup
    #GethPocoDocker.Start GethPoco Container
    Create Directory  ${REPO_DIR}
    IexecSdk.Init Sdk
    Xtremweb.Gradle Build Xtremweb
    Xtremweb.Start DockerCompose Xtremweb
    IexecCommon.Gradle Build Iexec Common
    IexecScheduler.Gradle Build Iexec Scheduler
    IexecSchedulerMock.Gradle Build BootRun Iexec Scheduler Mock
    IexecWorker.Gradle Build Iexec Worker
    IexecWorkerMock.Gradle Build BootRun Iexec Worker Mock


This Suite Teardown
    IexecWorkerMock.Stop Worker Mock
    IexecSchedulerMock.Stop Scheduler Mock
    #GethPocoDocker.Stop GethPoco Container
    Xtremweb.Stop DockerCompose Xtremweb