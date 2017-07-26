Deploy XWHEP in Docker containers
=================================

# Introduction

We propose 4 Dockerfile to create images for the server, the client and the worker.
The 4th docker file in server-master creates the server image from the github repository.

These Dockerfile can help you to:
- [deploy your own platform](#deploy-your-own-platform)
- [use a deployment](#install-the-client)
- [provide your volunteer resource](#provide-your-volunteer-resource)


# Deploy your own platform

We propose the following workflow:
- [server-master](server-master/) prepares all needed Debian packages to create Docker images. Please read [server-master/README.md](server-master/README.md)

# Install the client

The XWHEP client aims to interact with an XWHEP deployment:
- register an application;
- register data;
- submit jobs;
- retrieve results.

If you want to use an XWHEP platform, you must first request the XWHEP client Debian package from the platform administrator.

We propose the following workflow:
- copy the client Debian package to [client/](client/).
  This Debian package is either provided by an XWHEP administrator or created by [server-master](server-master/).
- execute the [client/startclient.sh](client/startclient.sh) to create a Docker image.


# Provide your volunteer resource

The XWHEP worker aims to propose IT resource to an XWHEP deployment:
- propose its configuration (RAM, CPU etc);
- propose some shared assets, if any;
- ask for a job;
- download binary and data for the job;
- execute the job;
- return result;
- send heartbeat signal for coherency.

We propose the following workflow:
- copy the worker Debian package to [worker/](worker/). This Debian package is either provided by an XWHEP deployment administrator or created by [server-master](server-master/).
- execute the [worker/startworker.sh](worker/startworker.sh) to create a Docker image and launch the worker in a Docker container.

