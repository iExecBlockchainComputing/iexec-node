Docker XWHEP client
===================

This directory contains everything to start an XWHEP client inside a container from its Debian package.

The client Debian package can be generated from [docker/master](../master).

# Create Docker image

To create a Docker image for the client, please launch:
```
  build.sh
```

This script builds a new Docker image for the XWHEP client.

# Deployment

You can deploy your platform using [deployment scripts](../deployment/).
