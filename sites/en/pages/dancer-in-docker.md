---
title: "Dancer in Docker"
timestamp: 2018-12-29T22:00:01
tags:
  - Dancer
  - Docker
published: true
books:
  - dancer
author: szabgab
archive: true
---


A simple case of developing and then running a Dancer (1) based application.



Install [Docker](https://www.docker.com/)

Create a new directory and put a file called **Dockerfile** with the following content:

```
FROM ubuntu:18.04
RUN apt-get update                      && \
    apt-get upgrade -y                  && \
    apt-get install -y less wget        && \
    apt-get install -y build-essential  && \
    apt-get install -y libdancer-perl   && \
    echo "DONE"
```

Build the Docker image and call it "dancer":

```
docker build -t dancer .
```

Launch the Docker container (that is a running Docker image):

```
docker run --rm -it -p 3001:3000 -v $(pwd):/opt dancer
```

This will run the docker image and map the internal port 3000 to the port 3001 of the host system.
It will also map the /opt directory of the container to the current directory of the host system.

It will show you a prompt like this:

```
root@6401bb1ec929:/#
```


Go to the shared directory and create a Dancer application called My::App. This will create a directory called
My-App on the filesystem of your host computer in the directory where you started the Docker container:

```
cd /opt
dancer -a My::App
```

```
perl My-App/bin/app.pl
```

Will launch the Dancer application in the container and you can visit it from your desktop by browsing to:
http://127.0.0.1:3001/


## Manual testing environment

Change the Dockerfile:

```
FROM ubuntu:18.04
RUN apt-get update                      && \
    apt-get upgrade -y                  && \
    apt-get install -y less wget        && \
    apt-get install -y build-essential  && \
    apt-get install -y libdancer-perl   && \
    echo "DONE"

ADD My-App /My-App

ENTRYPOINT perl /My-App/bin/app.pl
```

This will copy the Dancer application from the host filesytem to the Docker image which can be distributed.

It will also tell the Docker image to launch the Dancer application when the Docker container starts.


Launch the Docker instance:

```perl
docker run --rm -it -p 3001:3000 dancer
```

Internally, in the Docker instance, this will launch the Dancer application listening on port 3000.

Docker will map it to port 3001 of the host system.

You can now visit http://127.0.0.1:3001/ and see the site.


