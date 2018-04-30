*** Settings ***
Documentation    dappNonReg
Library           OperatingSystem
Library           ArchiveLibrary
Resource  ../Resources/DappNonReg.robot
Resource  ../Resources/IexecSdkFromGithub.robot
Suite Setup  Init Test


# to launch tests :
# pybot -d Results ./tests/rf/Ping/dappNonRegOnRemoteEnv.robot
#docker run -v $(pwd)/reports:/opt/robotframework/reports:Z -v $(pwd)/tests:/opt/robotframework/tests:Z iexechub/iexec-robot -d /opt/robotframework/reports -t 'Test Factorial' /opt/robotframework/tests/rf/Ping/dappNonRegOnRemoteEnv.robot

*** Variables ***
${DAPPNAME}
${XW_HOST} =  devxw.iex.ec


*** Test Cases ***

Test Factorial
    DappNonReg.Factorial

Test Ffmpeg
    DappNonReg.Ffmpeg

Test DockerWithScript
    DappNonReg.DockerWithScript

Test Echo In Docker
    DappNonReg.Echo In Docker


*** Keywords ***

Init Test
    IexecSdkFromGithub.Init Sdk


