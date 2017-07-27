Docker XWHEP worker
====================

This directory contains everything to start a worker inside a container from its Debian package.

The worker Debian package can be generated from [docker/server-master](../server-master).

## Deployment

To start a worker, launch build.sh like:
```
  build.sh
```

This script :
- builds a new Docker image for the XWHEP worker;
- starts the XWHEP worker in a new Docker container.

