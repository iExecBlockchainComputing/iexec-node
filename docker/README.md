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

There must be Docker images for the server, the worker and the client.
Please see [server-master](server-master/) to prepare all needed Debian packages
and create Docker images for the three services.
Don't be afraitd to read [server-master/README.md](server-master/)

As soon as Docker images are ready, you can either make your deployment manually,
or use Docker compose.

## Manual deployment

We propose the following workflow:
- launch a Docker container to run the XWHEP server
 (in next example, the Docker image for the XWHEP server is "xwserverimg\_2017-07-26-15-32-39")
```
  docker run xwserverimg_2017-07-26-15-32-39
```
- check the XWHEP server network
```
  docker inspect c46088ad8e94
```
## Composed deployment

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

