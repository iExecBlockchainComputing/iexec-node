Docker deployment
=================

This directory contains everything to deploy an XWHEP platform.

Docker images for all services must exist. 
You can create Docker images there:
- [server image](../server/)
- [worker image](../worker/)
- [client image](../client/)


# Docker deployment

We propose a script to automate a deployment made of a server, a worker and a client

Make your deployement by launching docker.sh like:
```
  docker.sh
```


# Docker-compose deployment


We propose a script to automate a deployment made of a server, a worker and a client

Make your deployement by launching xwdeploy.sh like:
```
  xwdeploy.sh
```

You have three containers running from now.
In order to use them, you have to launch a bash prompt inside the client container.
To do so, you need first of all to locate the container by doing:
```
  docker ps
```
Once you have located the container beginning by 'xwclientctn', you need to launch a bash command prompt to use it:
```
  docker exec -it [container name] bash
```
