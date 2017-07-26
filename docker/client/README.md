# xtremweb-hep
Data driven volunteer cloud

### Status
[![Build Status](https://travis-ci.org/lodygens/xtremweb-hep.svg?branch=master)](https://travis-ci.org/lodygens/xtremweb-hep)

Docker deployment
=================

This directory contains everything to install a client inside a container from its Debian package.

The client Debian package can be generated from [docker/server-master](../server-master).

## Deployment

To create a client Docker image, launch startclien.sh like:
```
  startclien.sh
```

This script :
- builds a new Docker image for the XWHEP client.

