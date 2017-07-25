# xtremweb-hep
Data driven volunteer cloud

### Status
[![Build Status](https://travis-ci.org/lodygens/xtremweb-hep.svg?branch=master)](https://travis-ci.org/lodygens/xtremweb-hep)

Docker deployment
=================

This directory contains everything to deploy an XWHEP.
Each service in its own container:
- one server
- one worker
- one client

## Deployment

Launch xwdeploy.sh like:
```
  xwdeploy.sh
```

These Debian packages can avantageoulsy be used with [docker/worker](../worker) and [docker/client](../client) to
create and launch Docker containers that connect to the XWHEP server inside its container.
