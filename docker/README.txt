We propose 4 Dockerfile to create images for the server, the client and the worker.
The 4th docker file in server-master creates the server image from the github repository

To build the client image, the dockerfile needs xwhep-client-10.5.0.deb
To build the worker image, the dockerfile needs xwhep-worker-10.5.0.deb
To build the server image, the dockerfile needs xwhep-server-10.5.0.deb and xwhep-server-conf-10.5.0.deb
To build the server-master image, the dockerfile needs xwconfigure.values

These debian packages are automatically created by the "xwconfigure" script

You must copy the debian package in the Dockerfile directory to build the image
