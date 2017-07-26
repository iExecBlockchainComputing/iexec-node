Docker XWHEP client
===================

This directory contains everything to install a client inside a container from its Debian package.

The client Debian package can be generated from [docker/server-master](../server-master).

# Deployment

To create a client Docker image, launch startclient.sh like:
```
  startclient.sh
```

This script :
- builds a new Docker image for the XWHEP client.

