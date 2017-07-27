Docker XWHEP worker
===================

This directory contains everything to start an XWHEP worker inside a container from its Debian package.

The worker Debian package can be generated from [docker/worker-master](../worker-master).

# Create Docker image

To create a Docker image for the worker, please launch:
```
  build.sh
```

This script builds a new Docker image for the XWHEP worker.

# Deployment

You can deploy your platform using [deployment scripts](../deployment/).
