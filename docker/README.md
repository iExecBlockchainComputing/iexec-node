Deploy XWHEP in Docker containers
=================================

# 1 - Introduction

We propose 4 Dockerfile to create images for the server, the client and the worker.
The 4th docker file in master creates the server image from the github repository.

These Dockerfile can help you to:
- [deploy your own platform](#2---deploy-your-own-platform)
- [connect to a deployed platform](#3---connect-to-a-platform)


# 2 - Deploy your own platform

There must be Docker images for the server, the worker and the client.
Please see [master](master/) to prepare all needed Debian packages
and create Docker images for the three services.

As soon as Docker images are ready, you can either make your deployment manually,
or use Docker compose.

## 2.1 - Docker deployment

Please see [deployment](deployment/).

## 2.2 - Composed deployment

This is not functional yet.


# 3 - Connect to a platform

You may want to connect to a deployed platform in order to user volunteer resources,
or to propose volunteer resources.

## 3.1 - Install the client

The XWHEP client aims to interact with an XWHEP deployment:
- register an application;
- register data;
- submit jobs;
- retrieve results.

If you want to use an XWHEP platform, you must first request the XWHEP client Debian package from the platform administrator.

We propose the following workflow:
- copy the client Debian package to [client/](client/).
  This Debian package is either provided by an XWHEP administrator or created by [master](master/).
- execute the [client/startclient.sh](client/startclient.sh) to create a Docker image.


## 3.2 - Provide your volunteer resource

The XWHEP worker aims to propose IT resource to an XWHEP deployment:
- propose its configuration (RAM, CPU etc);
- propose some shared assets, if any;
- ask for a job;
- download binary and data for the job;
- execute the job;
- return result;
- send heartbeat signal for coherency.

We propose the following workflow:
- copy the worker Debian package to [worker/](worker/). This Debian package is either provided by an XWHEP deployment administrator or created by [master](master/).
- execute the [worker/startworker.sh](worker/startworker.sh) to create a Docker image and launch the worker in a Docker container.

