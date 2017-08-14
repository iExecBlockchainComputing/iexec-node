# stockfish


###Prerequisite:

init your iexec vagrant local vm see :
https://github.com/iExecBlockchainComputing/iexec-vagrant-devenv


###Configure ans start your local xtremweb server and worker

see : https://github.com/iExecBlockchainComputing/iexec-vagrant-devenv/discoverXtremweb.md

###Provision stockfish app into xtremweb

compile Stockfish
```
cd ~/iexecdev/
git clone https://github.com/iExecBlockchainComputing/Stockfish.git
cd Stockfish/src

#remove -static bug see https://bugs.launchpad.net/ubuntu/+source/gcc-defaults/+bug/1228201
#make -e EXTRALDFLAGS="-static -static-libgcc -static-libstdc++ " ARCH=x86-64 build

make -e EXTRALDFLAGS="-static-libgcc -static-libstdc++ " ARCH=x86-64 build

```

check a move on your compiled stockfish compile

```
cd ~/iexecdev/Stockfish/src
./stockfish <~/iexecdev/bridge_stockfish/test/stockfishSimpleTest.txt
```
expected result :

```
...
...
bestmove d7d5 ponder d2d4
```

send Stockfish to xtremweb
```
cd ~/iexecdev/xtremweb-hep/build/dist/${XTREMWEB_VERSION}/bin/
./xwsendapp stockfish deployable Linux amd64 /home/vagrant/iexecdev/Stockfish/src/stockfish

```
you should see an id as answer like :
```
xw://vagrant-ubuntu-trusty-64/14447543-cd16-4c05-bbbc-7204895af9ba
```


###check stockfish app in xtremweb ok
 
check your stockfish app is register in xtremweb :
```
cd ~/iexecdev/xtremweb-hep/build/dist/${XTREMWEB_VERSION}/bin/
./xwapps
```
you should see an id as answer like :
```
UID='14447543-cd16-4c05-bbbc-7204895af9ba', NAME='stockfish'
```
check that a worker is register 
```
./xwworkers
```
you should see an id as answer like :
```
 UID='014c4e9b-5dea-43a1-8fad-a531ee59aba3', NAME='vagrant-ubuntu-trusty-64'
```

submit a test move to xtremweb :
```
./xwsubmit stockfish <~/iexecdev/bridge_stockfish/test/stockfishSimpleTest.txt

```
you should see an id as answer like :
```
xw://vagrant-ubuntu-trusty-64/83cfea36-a153-4c08-950c-8164a00741bf
```
check the status of the task :
```
./xwstatus xw://vagrant-ubuntu-trusty-64/83cfea36-a153-4c08-950c-8164a00741bf
```

The xwstatus command must end with PENDING -> RUNNING -> COMPLETED state
```
UID='2d34665e-78b8-43b1-96db-5940a4967866', STATUS='COMPLETED', COMPLETEDDATE='2017-08-13 19:18:43', LABEL=NULL
```

call xwdownload command to download and see the move result :
```
./xwdownload xw://vagrant-ubuntu-trusty-64/5dbfe0e9-3fde-4824-af36-c8fa49f0cba0
```

```
 UID='fbee2e9b-38a3-4a42-9abb-19e66a545f93', STATUS='COMPLETED', COMPLETEDDATE='2017-08-14 11:32:50', LABEL=NULL
[14/Aug/2017:11:32:51 +0000] [xtremweb.client.Client_main_1] INFO : Downloaded to : /home/vagrant/iexecdev/xtremweb-hep/build/dist/xwhep-10.6.0/bin/47683c61-3829-4fbc-8f5a-e627ddad8c55_stdout.txt.txt
vagrant@vagrant-ubuntu-trusty-64:~/iexecdev/xtremweb-hep/build/dist/xwhep-10.6.0/bin$ cat /home/vagrant/iexecdev/xtremweb-hep/build/dist/xwhep-10.6.0/bin/47683c61-3829-4fbc-8f5a-e627ddad8c55_stdout.txt.txt
Stockfish 140817 64 by T. Romstad, M. Costalba, J. Kiiski, G. Linscott
```





###Deploy and launch your local stockfish front end

in another console launch testrpc or your local ethereum node:
```
testrpc 
```

in another console  :
```
cd iexecdev/
git clone https://github.com/iExecBlockchainComputing/bridge_stockfish.git
cd ~/iexecdev/bridge_stockfish
npm install
./buildAndDeploy.sh  

```

wait for : 
```
Listening on http://0.0.0.0:8000
Document root is /home/vagrant/iexecdev/bridge_stockfish/build
Press Ctrl-C to quit.
```

### see and export your current stockfish deployed address
```
cat ~/iexecdev/bridge_stockfish/build/contracts/stockfish.json | grep "address\":"
export STOCKFISH_CONTRACT_ADDRESS=$(cat ~/iexecdev/bridge_stockfish/build/contracts/stockfish.json | grep "address\":" | cut -d: -f2 | cut -d\" -f2)
echo $STOCKFISH_CONTRACT_ADDRESS
```

### configure stockfish script to target local xwtremweb client
```
export XTREMWEB_VERSION=$(ls ~/iexecdev/xtremweb-hep/build/dist/)
sed -i "s/.*XWHEPDIR=.*/XWHEPDIR=\"\/home\/vagrant\/iexecdev\/xtremweb-hep\/build\/dist\/${XTREMWEB_VERSION}\"/g" ~/iexecdev/bridge_stockfish/stockfishback/run_stockfish_with_replication.sh

```


### run the stockfish backend
maj web3.eth.defaultAccount needed ?
```
sed -i "s/.*var contract_address =.*/var contract_address =\"${STOCKFISH_CONTRACT_ADDRESS}\";/g" ~/iexecdev/bridge_stockfish/stockfishback/stockfish.js 
pm2 restart ~/iexecdev/bridge_stockfish/stockfishback/stockfish.js 
```

### Play with stockfish 

enjoy at :

http://localhost:8000