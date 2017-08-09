
Vagrant IEXEC DEV 


Let Vagrant build an Ubuntu machine with all the developer needs :
lib to compile, run, test xtremweb, git, python, truffle, web3, node, parity, geth, testrpc etc ...

* Prerequisite:

install Vagrant 1.9.7 on your machine 
install virtuabox 5.1.x on your machine 

* Mount your vm :

'vagrant up' 

* connnect to your vm  :

vagrant ssh

* test your vm ok for xtremweb :

cd iexecdev/

git clone https://github.com/iExecBlockchainComputing/xtremweb-hep.git

cd xtremweb-hep/

git checkout testsrobotframework

cd test/robotframework/

pybot -d Results ./Tests/


Expected results :
Tests                                                                 | PASS |
14 critical tests, 14 passed, 0 failed
14 tests total, 14 passed, 0 failed
==============================================================================
Output:  /home/vagrant/iexecdev/xtremweb-hep/test/robotframework/Results/output.xml
Log:     /home/vagrant/iexecdev/xtremweb-hep/test/robotframework/Results/log.html
Report:  /home/vagrant/iexecdev/xtremweb-hep/test/robotframework/Results/report.html

* next to test/come : stockfish on your local vagrant vm (with local private net ethereum)
* next to test/come : vanitygen v2 on your local vagrant vm
* next to test/come : new bridge api solidy on your local vagrant vm