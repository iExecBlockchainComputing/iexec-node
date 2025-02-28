*** Settings ***
Documentation    dappNonRegOnLocalXtremweb
Library           OperatingSystem
Library           ArchiveLibrary
Resource  ../Resources/DockerHelper.robot
Resource  ../Resources/DappNonReg.robot
Resource  ../Resources/IexecSdk.robot
Resource  ../Resources/Xtremweb.robot
Suite Setup  DappNonReg Suite Setup
Suite Teardown  DappNonReg Suite Teardown

# to launch tests :
# pybot -v JWTETHISSUER:TBD -v JWTETHSECRET:TBD -d Results ./tests/rf/Tests/dappNonRegOnLocalXtremweb.robot
# DO NOT WORK FOR MAC.
# IT WORKS ONLY UBUNTU WITH prerequiste : https://github.com/iExecBlockchainComputing/iexec-node/blob/master/docker/iexec-robot/iexec-robot-aws.sh

*** Variables ***
${DAPPNAME}
${XW_HOST} =  scheduler
${REPO_DIR} =  ${CURDIR}/../repo

*** Test Cases ***

# pybot -v JWTETHISSUER:TBD -v JWTETHSECRET:TBD -d Results -t 'Test Factorial' ./tests/rf/Tests/dappNonRegOnLocalXtremweb.robot

Test Factorial
    DappNonReg.Factorial

Test Ffmpeg
    DappNonReg.Ffmpeg

Test DockerWithScript
    DappNonReg.DockerWithScript

Test Echo In Docker
    DappNonReg.Echo In Docker


*** Keywords ***


DappNonReg Suite Setup
     Create Directory  ${REPO_DIR}
     IexecSdk.Init Sdk
     Xtremweb.Gradle Build Xtremweb
     Xtremweb.Start DockerCompose Xtremweb

DappNonReg Suite Teardown
     Xtremweb.Stop DockerCompose Xtremweb
