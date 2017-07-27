Docker deployment
=================

This directory contains everything to deploy an XWHEP.  
Each service in its own container:
- one server
- one worker
- one client

Docker images for all services must exist. 
You can create Docker images there:
- [server image](../server/)
- [worker image](../worker/)
- [client image](../client/)


# Docker deployment

Launch docker.sh like:
```
  docker.sh
```


# Docker-compose deployment

Launch docker-compose.sh like:
```
  docker-compose.sh
```
