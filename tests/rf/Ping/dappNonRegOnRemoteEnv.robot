*** Settings ***
Documentation    dappNonReg
Library           OperatingSystem
Library           ArchiveLibrary
Resource  ../Resources/DappNonReg.robot
Resource  ../Resources/IexecSdk.robot
Suite Setup  IexecSdk.Init Sdk

# to launch tests :
# pybot -d Results -v LAUNCHED_IN_CONTAINER:true ./tests/rf/Ping/dappNonRegOnRemoteEnv.robot

#docker run -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/opt/robotframework -v $(pwd)/Results:/opt/robotframework/tests/Results iexechub/iexec-robot -d /opt/robotframework/tests/Results -v LAUNCHED_IN_CONTAINER:true /opt/robotframework/tests/rf/Ping/dappNonRegOnRemoteEnv.robot

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






