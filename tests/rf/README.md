
## Launch xtremweb robotframework tests
```
cd ~/iexecdev/

git clone https://github.com/iExecBlockchainComputing/xtremweb-hep.git

cd ~/iexecdev/xtremweb-hep

git checkout testsrobotframework

cd test/robotframework/

pybot -d Results ./Tests/
```

Expected results 
```
Tests                                                                 | PASS |
14 critical tests, 14 passed, 0 failed
14 tests total, 14 passed, 0 failed
Output:  /home/vagrant/iexecdev/xtremweb-hep/test/robotframework/Results/output.xml
Log:     /home/vagrant/iexecdev/xtremweb-hep/test/robotframework/Results/log.html
Report:  /home/vagrant/iexecdev/xtremweb-hep/test/robotframework/Results/report.html
```
