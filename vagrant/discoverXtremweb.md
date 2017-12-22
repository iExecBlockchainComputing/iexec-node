# Discover Xtremweb

### Compile and install your local xtremweb
In your local vagrant
```
cd ~/iexecdev/

git clone https://github.com/iExecBlockchainComputing/xtremweb-hep.git

cd ~/iexecdev/xtremweb-hep/

./gradlew buildAll

export XTREMWEB_VERSION=$(ls ~/iexecdev/xtremweb-hep/build/dist/)

cp ~/iexecdev/iexec-node/vagrant/xwconfigure.values.vagrant  ~/iexecdev/xtremweb-hep/build/dist/${XTREMWEB_VERSION}/conf/xwconfigure.values

cd ~/iexecdev/xtremweb-hep/build/dist/${XTREMWEB_VERSION}/bin

./xwconfigure --yes --nopkg --rmdb 

```

wait for "That's all folks"

### Start your local xtremweb server manually

start your xtremweb server in a console :
```
sed -i 's/LAUNCHERURL=/#LAUNCHERURL=/g' ~/iexecdev/xtremweb-hep/build/dist/${XTREMWEB_VERSION}/conf/xtremweb.server.conf
sudo ~/iexecdev/xtremweb-hep/build/dist/${XTREMWEB_VERSION}/bin/xtremweb.server console
```

wait for "INFO : started, listening on port : 443"


### Start your local xtremweb worker manually

start your xtremweb server in another console :

```
sudo ~/iexecdev/xtremweb-hep/build/dist/${XTREMWEB_VERSION}/bin/xtremweb.worker console
```

wait for "INFO : Server gave no work to compute"

### Register and test a simple 'ls' app on xtremweb

in another console :
```
cd ~/iexecdev/xtremweb-hep/build/dist/${XTREMWEB_VERSION}/bin/
./xwsendapp ls DEPLOYABLE LINUX AMD64 /bin/ls

```
you should see an id as answer like :
```
xw://vagrant-ubuntu-trusty-64/14447543-cd16-4c05-bbbc-7204895af9ba
```

check ls app is register
```
./xwapps
 
```

check that the worker is register 
```
./xwworkers
```
you should see an id as answer like :
```
 UID='014c4e9b-5dea-43a1-8fad-a531ee59aba3', NAME='vagrant-ubuntu-trusty-64'
```

invoke ls app 
```
 ./xwsubmit ls
 
```
you should see an id as answer like :
```
xw://vagrant-ubuntu-trusty-64/fc271a20-fd0b-4f3e-93ab-45f011c4f361
```

check the status of the task :
```
./xwstatus xw://vagrant-ubuntu-trusty-64/fc271a20-fd0b-4f3e-93ab-45f011c4f361
```

The retunr status after some seconds must be COMPLETED (PENDING -> RUNNING -> COMPLETED) :
```
 UID='fc271a20-fd0b-4f3e-93ab-45f011c4f361', STATUS='COMPLETED', COMPLETEDDATE='2017-08-12 23:05:24', LABEL=NULL
```

Download the result :
```
./xwresults xw://vagrant-ubuntu-trusty-64/fc271a20-fd0b-4f3e-93ab-45f011c4f361
```
you will see the path where to find the result :

```
[12/Aug/2017:23:18:14 +0000] [xtremweb.client.Client_main_1] INFO : Downloaded to : /home/vagrant/iexecdev/xtremweb-hep/build/dist/xwhep-10.6.0/bin/11fa614f-50b8-42ed-b581-27855dd1b317_stdout.txt.txt
```

### Start your local xtremweb server and worker using docker and docker compose 

see [here](https://github.com/iExecBlockchainComputing/iexec-node/tree/master/docker)
