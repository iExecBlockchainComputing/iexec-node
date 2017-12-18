
## Robotframework tests

### Prerequisite 

iexec vagrant, needed dependency are already in your local vagrant

or

ubuntu and see bootstrap.sh for lib needed: 

[bootstrap.sh](../../vagrant/bootstrap.sh)

or this :
```
add-apt-repository -y ppa:ethereum/ethereum
apt-get update -q

apt-get -y install icedtea-8-plugin openjdk-8-jre openjdk-8-jdk ethereum python-pip groff-base zip unzip wget make ant gcc uuid uuid-runtime vim git

pip install robotframework robotframework-selenium2library robotframework-databaselibrary pymysql


```

### General 
Before tests launch select your targeted iexec repo to test in 
```
iexec-node/gitcloneall.sh
```

by default master are cloned.
If you want to test non reg into your evol branch

Modifiy the git clone like this :
```
git clone -b "your branch to test" https://github.com/iExecBlockchainComputing/The iexec repo impacted.git
```
gitcloneall.sh


### Full Non Reg
```
bash
cd ~/iexecdev/iexec-node
./gitcloneall.sh
pybot -d Results ./tests/rf/Tests/
```


### Xtremweb Non Reg
```
bash
cd ~/iexecdev/iexec-node
./gitcloneall.sh
pybot -d Results ./tests/rf/Tests/xwcommandsSuite.robot
```


### Oracle Non Reg On test Rpc
```
bash
cd ~/iexecdev/iexec-node
./gitcloneall.sh
pybot -d Results ./tests/rf/Tests/truffleTestsOnTestrpc.robot
```

### Oracle Non Reg On Geth Local
```
bash
cd ~/iexecdev/iexec-node
./gitcloneall.sh
pybot -d Results ./tests/rf/Tests/truffleTestsOnLocalGeth.robot
```

### Oracle Non Reg On Geth Local Dockerized
```
bash
cd ~/iexecdev/iexec-node
./gitcloneall.sh
pybot -d Results ./tests/rf/Tests/truffleTestsOnLocalGethDocker.robot
```


### OBXW Non Reg : Geth Local Dockerized+ Oracle Dockerized+ Bridge Dockerized + Xtremweb 
```
bash
cd ~/iexecdev/iexec-node
./gitcloneall.sh
pybot -d Results ./tests/rf/Tests/NonRegOBXW.robot
```


