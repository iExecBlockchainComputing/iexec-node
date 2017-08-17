# VANITYGEN Beta

Vanitygen is a vanity bitcoin address generator.

## Table of Contents

- [Generate Vanity Address](#generate-vanity-address)
    - step 1: Get RLC token
    - step 2: Choose your letters
    - step 3: Get result

## Generate Vanity Address

### step 1: Get RLC token
![part1](https://user-images.githubusercontent.com/22321477/26879236-a405eccc-4b90-11e7-8e98-e46422a8b673.gif)

### step 2: Choose your letters
![part2](https://user-images.githubusercontent.com/22321477/26878943-86f175d0-4b8f-11e7-999c-a4872a05057f.gif)

### step 3: Get result
![part3](https://user-images.githubusercontent.com/22321477/26879217-8fdcedb8-4b90-11e7-95a0-3232056bdeb3.gif)


## Deploy vanity in your local vm vagrant


### Prerequisite:

init your iexec vagrant local vm see :
https://github.com/iExecBlockchainComputing/iexec-vagrant-devenv


### Configure ans start your local xtremweb server and worker

see : https://github.com/iExecBlockchainComputing/iexec-vagrant-devenv/discoverXtremweb.md




### Provision vanity app into xtremweb

```
cd ~/iexecdev/
git clone https://github.com/iExecBlockchainComputing/bridge_vanity.git
git checkout local-vagrant
ls -l ~/iexecdev/bridge_vanity/vanitybin/vanitygen_linux_amd64.bin
```
test vanity 
```
~/iexecdev/bridge_vanity/vanitybin/vanitygen_linux_amd64.bin 1Love
```

sent vanity to xtremweb
```
cd ~/iexecdev/xtremweb-hep/build/dist/${XTREMWEB_VERSION}/bin/
./xwsendapp vanitygen deployable Linux amd64 /home/vagrant/iexecdev/bridge_vanity/vanitybin/vanitygen_linux_amd64.bin
```

you should see an id as answer like :
```
xw://vagrant-ubuntu-trusty-64/14447543-cd16-4c05-bbbc-7204895af9ba
```


### Manually check that vanitygen app in xtremweb works well
 
check your vanity app is register in xtremweb :
```
cd ~/iexecdev/xtremweb-hep/build/dist/${XTREMWEB_VERSION}/bin/
./xwapps
```
you should see an id as answer like :
```
UID='2c1d75a4-b3fd-4688-894e-29e49e2c2de1', NAME='vanitygen'
```
check that a worker is register 
```
./xwworkers
```
you should see an id as answer like :
```
 UID='014c4e9b-5dea-43a1-8fad-a531ee59aba3', NAME='vagrant-ubuntu-trusty-64'
```

submit a vanity query to xtremweb :
```
./xwsubmit vanitygen 1Love

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
./xwdownload xw://vagrant-ubuntu-trusty-64/bf28a23b-b12b-4efb-8707-297a0db00b7b
```

```
 UID='bf28a23b-b12b-4efb-8707-297a0db00b7b', STATUS='COMPLETED', COMPLETEDDATE='2017-08-14 13:19:09', LABEL=NULL
.....
 INFO : Downloaded to : /home/vagrant/iexecdev/xtremweb-hep/build/dist/xwhep-10.5.2/bin/bcdc474c-5a5c-4cf5-bb6a-0ef132d930d4_ResultsOf_bf28a23b-b12b-4efb-8707-297a0db00b7b.zip
```

In the zip you must find a stdout.txt file wih the following content :
```                                                           
Pattern: 1Love                                                                   
Address: *******your Address here***********                                     
Privkey: *******your Privkey here***********
```

### Deploy and launch your local vanity front end and backend

in another console launch your local ethereum node or use testrpc
more details here :
https://github.com/iExecBlockchainComputing/iexec-vagrant-devenv/blob/master/discoverTruffleTestRpcGeth.md
```
cd gethUtils/
./mine42externalexposed.sh
```
when you see your miner active :
```
... 🔨 mined potential block,  ...
```
you can continue.

or 
```
testrpc
```
in another console launch vanity frontend:
```
cd ~/iexecdev/vanitygen
npm install
./buildAndDevDeploy.sh
```


launch vanity backend bridge  :
```
cd ~/iexecdev/bridge_vanity
npm install
./buildAndDevDeploy.sh

```
Access the vanity interface at :
```
http://localhost:8081/
```
