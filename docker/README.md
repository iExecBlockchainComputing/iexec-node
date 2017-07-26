Deploy XWHEP in Docker containers
=================================

# Introduction

We propose 4 Dockerfile to create images for the server, the client and the worker.
The 4th docker file in server-master creates the server image from the github repository.

# Deploy your own platform

We propose the following workflow:
- [server-master](server-master/) prepares all needed Debian packages to create Docker images. Please read [server-master/README.md](server-master/README.md)
- deux
