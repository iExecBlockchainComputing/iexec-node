*** Settings ***
Documentation    Test Start Xtremweb
Library  Dialogs
Resource  ../Resources/XWCommon.robot
Resource  ../Resources/XWServer.robot
Resource  ../Resources/cli/XWClient.robot
Suite Setup  Start Xtremweb
Suite Teardown  XWCommon.End XWtremWeb Command Test


# to launch tests : pybot -d Results ./tests/rf/Tests/launchXtremWeb.robot

*** Variables ***



*** Test Cases ***

Test Start Xtremweb
    [Documentation]  Test Start Xtremweb
    [Tags]  Manual Tests
    Log  Test Start Xtremweb
    Wait Until Keyword Succeeds  1440 min  60 min  Never Success


*** Keywords ***

Never Success
    Should Be Equal As Strings  OK  KO

Start Xtremweb
    XWCommon.Prepare XWtremWeb Server And XWtremWeb Worker
    XWCommon.Begin XWtremWeb Command Test


