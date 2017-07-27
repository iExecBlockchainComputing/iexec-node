Build from source
=================

This directory contains everything to build a deployment from [github](https://github.com/lodygens/xtremweb-hep).

# Security
If you wish to deploy a production platform, don't forget to set your own configuration in _xwconfigure.values_ file.
Please refer to the [administrator guide](../../doc/xwhep-admin-guide.odt).

# Network
You must set two variables in the _xwconfigure.values_ file:
- XWSERVER : the IP address or resolved name of the server;
- CERTCN : should be equal to XWSERVER. Please refer to [opensll documentation](https://www.openssl.org).

Default is "xwserver".


## Docker-compose
If you want to use [our docker compose deployment](../deployment/), you should:
- set XWSERVER and CERTCN to "xwserver" as explained in [network section](#network);
- or modify [deploy.sh](../deployment/deploy.sh) to reflect server name.


# Deployment

Launch build.sh like:
```
  build.sh
```

This script prepares all Debian packages : server, worker and client.

These Debian packages can avantageoulsy be used with [docker/server](../server), [docker/worker](../worker) and [docker/client](../client) to
create create Docker images for the worker and the client, respectively.

One may note that a Docker image for the server is created by build.sh script.
But using [docker/server](../server) creates a smaller Docker image since it installs Java JRE and not Java JDK.
