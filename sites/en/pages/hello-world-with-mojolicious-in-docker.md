---
title: "Hello World with Mojolicious in Docker"
timestamp: 2020-10-06T09:30:01
tags:
  - Mojolicious
  - Docker
published: true
types:
  - screencast
books:
  - mojolicious
author: szabgab
archive: true
description: "Tiny experiment to show Hello World with Mojolicious in Docker."
show_related: true
---


Tiny experiment to show "Hello World" with [Mojolicious](/mojolicious) in [Docker](/docker).


{% youtube id="Ux3t7QuaH8o" file="english-mojolicious-hello-world-in-docker.mkv" %}


## Hello World

Taken from the [Mojolicious Tutorial](https://docs.mojolicious.org/Mojolicious/Guides/Tutorial)

{% include file="examples/docker-mojolicious-hello-world/demo.pl" %}

## Dockerfile

{% include file="examples/docker-mojolicious-hello-world/Dockerfile" %}

## Build the Docker image

```
$ docker build -t perldemo .
```

## Run the Docker container

```
$ docker run --rm -p3000:3000 perldemo
```

