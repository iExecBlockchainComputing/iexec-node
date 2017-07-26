Build from source
=================

This directory contains everything to build a deployment from github last sources.

## Security
If you wish to deploy a production platform, don't forget to set your own configuration in _xwconfigure.values_ file.
Please refer to the [administrator guide](../../doc/xwhep-admin-guide.odt).

## Deployment

Launch build.sh like:
```
  build.sh
```

This script :
- prepare all Debian packages : server, worker and client;
- builds a new Docker image for the XWHEP server.

These Debian packages can avantageoulsy be used with [docker/server](../server), [docker/worker](../worker) and [docker/client](../client) to
create create Docker images for the worker and the client, respectively.

One may note that a Docker image for the server is created by build.sh script.
But using [docker/server](../server) would create a smaller Docker images since it will use Java JRE and not Java JDK.
