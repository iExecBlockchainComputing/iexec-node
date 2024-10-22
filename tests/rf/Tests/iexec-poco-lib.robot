*** Settings ***
Documentation    iexec-poco-lib
Resource  ../Resources/DockerHelper.robot
Resource  ../Resources/GethPocoDocker.robot
Resource  ../Resources/IexecCommon.robot
Resource  ../Resources/IexecScheduler.robot
Resource  ../Resources/IexecSchedulerMock.robot
Resource  ../Resources/IexecWorker.robot
Resource  ../Resources/IexecWorkerMock.robot
Resource  ../Resources/IexecPocoAPI.robot

Suite Setup  This Suite Setup
Suite Teardown  This Suite Teardown
#Test Setup  This Test Setup
#Test Teardown  This Test Teardown


#https://github.com/iExecBlockchainComputing/iexec-poco-api.git
# to launch all tests if robot installed on your host:
# nohup pybot -d Results ./tests/rf/Tests/iexec-poco-lib.robot &


*** Variables ***
${REPO_DIR} =  ${CURDIR}/../repo


*** Test Cases ***

#pybot -d Results -t 'Test Suite Setup Initialized' ./tests/rf/Tests/iexec-poco-lib.robot
Test Suite Setup Initialized
    Log  Suite Setup Initialized


*** Keywords ***

This Suite Setup
    GethPocoDocker.Start GethPoco Container
    IexecCommon.Gradle Build Iexec Common
    IexecScheduler.Gradle Build Iexec Scheduler
    IexecSchedulerMock.Gradle Build BootRun Iexec Scheduler Mock
    IexecWorker.Gradle Build Iexec Worker
    IexecWorkerMock.Gradle Build BootRun Iexec Worker Mock
    IexecPocoAPI.Gradle Build BootRun Iexec Poco Api


This Suite Teardown
    IexecPocoAPI.Stop Iexec Poco Api
    IexecWorkerMock.Stop Worker Mock
    IexecSchedulerMock.Stop Scheduler Mock
    GethPocoDocker.Stop GethPoco Container