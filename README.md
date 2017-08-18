
# Vagrant IEXEC DEV 


Let Vagrant build an Ubuntu machine with all the developer needs :
lib to compile, run, test xtremweb, git, python, truffle, web3, node, parity, geth, testrpc etc ...

### Prerequisite:

* install Vagrant 1.9.7 on your machine 
* install virtuabox 5.1.x on your machine  
* download the latest ubuntu/trusty64 image :
```
vagrant box update
```

### Mount your vm :
```
vagrant up
```
### Connnect to your vm  :
```
vagrant ssh
```

### Configure your git identity
* git config --global user.email "you@example.com"
* git config --global user.name "Your Name"


### Discover your dev vm

* [Discover Xtremweb](discoverXtremweb.md)
* [Discover Truffle, Testrpc, geth](discoverTruffleTestRpcGeth.md)

### Deploy project on your dev vm

* [stockfish on your local vagrant vm ](https://github.com/iExecBlockchainComputing/bridge_stockfish/pull/1)
*  Vanitygen v2 [front end](https://github.com/iExecBlockchainComputing/vanitygen/tree/local-vagrant) and [bridge](https://github.com/iExecBlockchainComputing/bridge_vanity/tree/local-vagrant) on your local vagrant vm : 
* next to test/come : new bridge api solidy on your local vagrant vm
