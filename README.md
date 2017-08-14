
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
  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"


### Discover your dev vm

* [Discover Xtremweb](discoverXtremweb.md)
* [Discover Truffle, Testrpc, geth](discoverTruffleTestRpcGeth.md)

### Deploy project on your dev vm

* next to test/come : stockfish on your local vagrant vm (with local private net ethereum)
* next to test/come : vanitygen v2 on your local vagrant vm
* next to test/come : new bridge api solidy on your local vagrant vm
