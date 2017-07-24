# xtremweb-hep
Data driven volunteer cloud

### Status
[![Build Status](https://travis-ci.org/lodygens/xtremweb-hep.svg?branch=master)](https://travis-ci.org/lodygens/xtremweb-hep)

Quick start
===========

This directory contains everything to start your own deployment from last sources.

Launch xwdeploy.sh like:
```
  xwdeploy.sh
```

This script :
- builds a new Docker image for the XWHEP server;
- starts a new Docker container for the XWHEP server;
- copy XWHEP worker and client Debian packages from the running container.

These Debian packages can avantageoulsy be used with docker/worker and docker/client to
launch Docker containers that connect to the XWHEP server inside its container.
