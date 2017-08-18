Docker deployment
=================

This directory contains everything to deploy an XWHEP platform.

Docker images for all services must exist. 
You can create Docker images there:
- [server image](../server/)
- [worker image](../worker/)
- [client image](../client/)


 



# Docker-compose deployment

### Prerequiste 

Docker and Docker compose installed.

* Windows   
xwdeploy.sh not supported on Windows but you can download vagrant on your windows and [use our vagrant base image.](https://github.com/iExecBlockchainComputing/iexec-vagrant-devenv)

* Mac 
be sure you have realpath installed  (brew install coreutils)

* Linux 
be sure you have realpath installed  (sudo apt-get install -y realpath)
 

### Deploy


We propose a script to automate a deployment made of a server, a worker and a client

Make your deployement by launching xwdeploy.sh like:
```
  xwdeploy.sh
```

You have three containers running from now and you can see logs of the containers in your terminal.

In order to use it, you have to launch bash prompt inside the client container.
To do so, launch another terminal and you need first of all to locate the container ids by doing:
```
  docker ps
```
Once you have located the container beginning by 'xwclientctn', you need to launch a bash command prompt to use it:
```
  docker exec -it [container name] bash
```

Inside the xwclientctn container try to ping the xwtremweb server :
```
xwping

```
Inside the xwclientctn container check the worker is registered:
```
xwworkers

```
you will see the name equal to the worker docker container id 
