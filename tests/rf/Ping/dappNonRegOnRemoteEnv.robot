*** Settings ***
Documentation    dappNonReg
Library           OperatingSystem
Library           ArchiveLibrary
Resource  ../Resources/DappNonReg.robot
Resource  ../Resources/IexecSdkFromGithub.robot
Resource  ../Resources/IexecSdkDocker.robot
Suite Setup  IexecSdkDocker.Iexec Docker  --version

# to launch tests :
# pybot -d Results ./tests/rf/Ping/dappNonRegOnRemoteEnv.robot

#docker run -v /var/run/docker.sock:/var/run/docker.sock -w /opt/robotframework iexechub/iexec-robot -d /opt/robotframework/tests/Results -t 'Test Factorial' /opt/robotframework/tests/rf/Ping/dappNonRegOnRemoteEnv.robot

*** Variables ***
${DAPPNAME}
${XW_HOST} =  devxw.iex.ec
${REPO_DIR} =  ${CURDIR}/../repo


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



