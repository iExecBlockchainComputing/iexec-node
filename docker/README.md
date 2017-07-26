Deploy XWHEP in Docker containers
=================================

# 1 - Introduction

We propose 4 Dockerfile to create images for the server, the client and the worker.
The 4th docker file in server-master creates the server image from the github repository.

These Dockerfile can help you to:
- [deploy your own platform](#2---deploy-your-own-platform)
- [connect to a deployed platform](#3---connect-to-a-platform)


# 2 - Deploy your own platform

There must be Docker images for the server, the worker and the client.
Please see [server-master](server-master/) to prepare all needed Debian packages
and create Docker images for the three services.
Don't be afraitd to read [server-master/README.md](server-master/)

As soon as Docker images are ready, you can either make your deployment manually,
or use Docker compose.

## 2.1 - Manual deployment

We propose the following workflow:
- launch a Docker container to run the XWHEP server  
 (in next example, the Docker image for the XWHEP server is "xwserverimg\_2017-07-26-15-32-39")
```
  docker run xwserverimg_2017-07-26-15-32-39
```
- retrieve the XWHEP server network
```
  docker inspect c46088ad8e94
...
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "39956f4f2af50f54d7923685865b567659c3e9b17850fe89a2f27a85bfffbc57",
                    "EndpointID": "8f3823be4396d80c072d7eab78c1ed0da166649f811c54490b313b7472b9e596",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null
                }
            }

...
```
- launch a worker within the same network  
(i.e. 39956f4f2af50f54d7923685865b567659c3e9b17850fe89a2f27a85bfffbc57)  
(in next example, the Docker image for the XWHEP worker is "xwworkerimg\_2017-07-26-15-30-12")
```
  docker run --network=39956f4f2af50f54d7923685865b567659c3e9b17850fe89a2f27a85bfffbc57 xwworkerimg_2017-07-26-15-30-12
```
- launch the client within the same network (i.e. 39956f4f2af50f54d7923685865b567659c3e9b17850fe89a2f27a85bfffbc57)
 (in next example, the Docker image for the XWHEP client is "xwclientimg\_2017-07-26-15-33-07")
```
  docker run -ti --network=39956f4f2af50f54d7923685865b567659c3e9b17850fe89a2f27a85bfffbc57 xwclientimg_2017-07-26-15-33-07 /bin/bash
```

## 2.2 - Composed deployment

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
  This Debian package is either provided by an XWHEP administrator or created by [server-master](server-master/).
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
- copy the worker Debian package to [worker/](worker/). This Debian package is either provided by an XWHEP deployment administrator or created by [server-master](server-master/).
- execute the [worker/startworker.sh](worker/startworker.sh) to create a Docker image and launch the worker in a Docker container.

