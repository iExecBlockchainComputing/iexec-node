
# Vagrant IEXEC DEV 


Let Vagrant build an Ubuntu machine with all the developer needs :
lib to compile, run, test xtremweb, git, python, truffle, web3, node, parity, geth, testrpc etc ...


### Prerequisite:

* git
* install Vagrant 1.9.7 on your machine 
* install virtuabox 5.1.x on your machine  
* download the latest ubuntu/trusty64 image :
```
vagrant box update
```

### Mount your vm :
```
git clone https://github.com/iExecBlockchainComputing/iexec-node.git
cd iexec-node/vagrant
vagrant up
```
### Connnect to your vm  :
```
vagrant ssh
```

### Edit the /etc/hosts 
```
add vagrant-ubuntu-trusty-64 here :
127.0.0.1 localhost vagrant-ubuntu-trusty-64
```
### Configure your git identity
* git config --global user.email "you@example.com"
* git config --global user.name "Your Name"


### Discover your dev vm

* [Discover Xtremweb](discoverXtremweb.md)
* [Discover Truffle, Testrpc, geth](discoverTruffleTestRpcGeth.md)

### Deploy project on your dev vm

* [stockfish on your local vagrant vm ](https://github.com/iExecBlockchainComputing/iexec-node/tree/master/poc/stockfish/front)
* [Vanitygen on your local vagrant vm ](https://github.com/iExecBlockchainComputing/iexec-node/tree/master/poc/vanitygen/front)
* Next to test/come : new bridge api solidy on your local vagrant vm
