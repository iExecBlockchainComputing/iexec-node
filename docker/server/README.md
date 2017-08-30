Docker XWHEP server
===================

This directory contains everything to start an XWHEP server inside a container from its Debian package.

The server Debian package can be generated from [docker/master](../master).

# Create Docker image

To create a Docker image for the server, please launch:
```
  build.sh
```

This script builds a new Docker image for the XWHEP server.

# Deployment

You can deploy your platform using [deployment scripts](../deployment/).
