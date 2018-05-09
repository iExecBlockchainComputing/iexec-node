*** Settings ***
Documentation    iexec-poco-mock
Resource  ../Resources/DockerHelper.robot
Resource  ../Resources/GethPocoDocker.robot
Resource  ../Resources/IexecCommon.robot
Resource  ../Resources/IexecScheduler.robot
Resource  ../Resources/IexecSchedulerMock.robot
Resource  ../Resources/IexecWorker.robot
Resource  ../Resources/IexecWorkerMock.robot
Suite Setup  This Suite Setup
Suite Teardown  This Suite Teardown
#Test Setup  This Test Setup
#Test Teardown  This Test Teardown


# to launch all tests if robot installed on your host:
# nohup pybot -d Results ./tests/rf/Tests/iexec-poco-mock.robot &


*** Variables ***
${REPO_DIR} =  ${CURDIR}/../repo


*** Test Cases ***

#pybot -d Results ./tests/rf/Tests/iexec-poco-mock.robot
Test Suite Setup Initialized
    Log  Suite Setup Initialized

Test Workflow Ask With Mock Activate
    Wait Until Keyword Succeeds  1 min	 5 sec  Check WorkerPoolSubscription
    Wait Until Keyword Succeeds  1 min	 5 sec  Check CreateMarketOrder
    Wait Until Keyword Succeeds  1 min	 5 sec  Check BuyForWorkOrder
    Wait Until Keyword Succeeds  1 min	 5 sec  Check AllowWorkersToContribute
    Wait Until Keyword Succeeds  1 min	 5 sec  Check Contribute
    Wait Until Keyword Succeeds  1 min	 5 sec  Check RevealConsensus
    Wait Until Keyword Succeeds  1 min	 5 sec  Check Reveal
    Wait Until Keyword Succeeds  1 min	 5 sec  Check FinalizeWork

*** Keywords ***


Check FinalizeWork
    ${logs} =  Get File  ${REPO_DIR}/scheduler-mock.log
    ${lines} =  Get Lines Containing String  ${logs}  ActuatorService - FinalizeWork
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1
    ${logs} =  Get File  ${REPO_DIR}/worker-mock.log
    ${lines} =  Get Lines Containing String  ${logs}  Received WorkOrderCompletedEvent
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1
    ${logs} =  Get File  ${REPO_DIR}/worker-mock.log
    ${lines} =  Get Lines Containing String  ${logs}  Received RewardEvent
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1

Check Reveal
    ${logs} =  Get File  ${REPO_DIR}/worker-mock.log
    ${lines} =  Get Lines Containing String  ${logs}  ActuatorService - Reveal
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1
    ${logs} =  Get File  ${REPO_DIR}/scheduler-mock.log
    ${lines} =  Get Lines Containing String  ${logs}  Received RevealEvent
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1


Check RevealConsensus
    ${logs} =  Get File  ${REPO_DIR}/scheduler-mock.log
    ${lines} =  Get Lines Containing String  ${logs}  ActuatorService - RevealConsensus
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1
    ${logs} =  Get File  ${REPO_DIR}/worker-mock.log
    ${lines} =  Get Lines Containing String  ${logs}  Received RevealConsensusEvent
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1


Check Contribute
    ${logs} =  Get File  ${REPO_DIR}/worker-mock.log
    ${lines} =  Get Lines Containing String  ${logs}  ActuatorService - Contribute
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1
    ${logs} =  Get File  ${REPO_DIR}/scheduler-mock.log
    ${lines} =  Get Lines Containing String  ${logs}  Received ContributeEvent
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1

Check AllowWorkersToContribute
    ${logs} =  Get File  ${REPO_DIR}/scheduler-mock.log
    ${lines} =  Get Lines Containing String  ${logs}  AllowWorkersToContribute [workOrderId:
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1
    ${logs} =  Get File  ${REPO_DIR}/worker-mock.log
    ${lines} =  Get Lines Containing String  ${logs}  Received AllowWorkerToContributeEvent
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1


Check BuyForWorkOrder
    ${logs} =  Get File  ${REPO_DIR}/scheduler-mock.log
    ${lines} =  Get Lines Containing String  ${logs}  Received WorkOrderActivatedEvent
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1


Check CreateMarketOrder
    ${logs} =  Get File  ${REPO_DIR}/scheduler-mock.log
    ${lines} =  Get Lines Containing String  ${logs}  ActuatorService - CreateMarketOrder
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1
    ${logs} =  Get File  ${REPO_DIR}/scheduler-mock.log
    ${lines} =  Get Lines Containing String  ${logs}  Received marketOrderCreatedEvent
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1


Check WorkerPoolSubscription
    ${logs} =  Get File  ${REPO_DIR}/scheduler-mock.log
    ${lines} =  Get Lines Containing String  ${logs}  Received WorkerPoolSubscriptionEvent
    ${lines_count} =  Get Line Count  ${lines}
    Should Be Equal As Integers	${lines_count}	1



This Suite Setup
    GethPocoDocker.Start GethPoco Container
    IexecCommon.Gradle Build Iexec Common
    IexecScheduler.Gradle Build Iexec Scheduler
    IexecSchedulerMock.Gradle Build BootRun Iexec Scheduler Mock Active
    IexecWorker.Gradle Build Iexec Worker
    IexecWorkerMock.Gradle Build BootRun Iexec Worker Mock Active


This Suite Teardown
    IexecWorkerMock.Stop Worker Mock
    IexecSchedulerMock.Stop Scheduler Mock
    GethPocoDocker.Stop GethPoco Container