---
title: "Counter using Dancer2 and Redis in a Docker container"
timestamp: 2021-04-18T07:30:01
tags:
  - Dancer2
  - Redis
  - Docker
  - docker-container
published: true
author: szabgab
archive: true
show_related: true
---


In this part of the [counter examples](https://code-maven.com/counter) series we have [Perl Dancer](/dancer) based application using [Redis](https://redis.io/)
as the in-memory cache/database to store the counter.

The code runs in a Docker container and we have another container running the Redis server.


For this example to work we need the 4 files that you can see below (app.psgi, cpanfile, Dockerfile, docker-compose.yml) in a folder and you have to be in
that forlder. You can download the individual files or you can clone the repository of the Perl Maven web site:

```
git clone https://github.com/szabgab/perlmaven.com.git
cd perlmaven.com/examples/redis_counter/
```

Install Docker and docker-compose then run the command:

```perl
docker-compose up
```

Then you can visit http://localhost:5001 and keep reloading it to see the counter increase.

Ctrl-C will stop the Docker compose.

## The Dancer code

{% include file="examples/redis_counter/app.psgi" %}

The name of the server "myredis" was defined in the docker-compose.yml file. See below.

## cpanfile listing Perl dependencies

{% include file="examples/redis_counter/cpanfile" %}

## Dockerfile for perl and the modules needed

{% include file="examples/redis_counter/Dockerfile" %}

We install the modules using --notest so the installation will be faster. In a real, non-demo application I'd not do that. I'd want the tests to run to verify that
the modules I install work properly on my installation.

## docker-compose file to bind them all together

{% include file="examples/redis_counter/docker-compose.yml" %}

## Disk usage

The volume  storing the redis data:

```
docker volume inspect redis_counter_redis-data
```

The containers created by docker-compose can be seen:

```
docker ps -a
```

They are called redis_counter_web_1 and  redis_counter_myredis_1.

## Cleanup

```
docker container rm redis_counter_myredis_1 redis_counter_web_1
docker volume rm redis_counter_redis-data
```

