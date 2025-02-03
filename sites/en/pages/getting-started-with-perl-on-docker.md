---
title: "Getting started with Perl on Docker"
timestamp: 2018-01-23T10:30:01
tags:
  - Docker
published: true
author: szabgab
archive: true
---


[Docker](https://www.docker.com/) is a containerization platform which means it is
a Linux box that needs less power than a full-blown Linux machine. You usually don't work "on" it,
but you let your software run in it. In this article we will see how to get started with it
for writing Perl code.

You can use it on top of Linux, Mac OSX, or Microsoft Windows.


## Install Docker

The first things is that you need to [download and install Docker](https://www.docker.com/products/docker).

## Launch the Docker Daemon

Then you need to launch the Docker Daemon. This can be done by clicking on the Docker icon that was installed.
(I admit, I only tried this on Mac. There I had an icon for Docker. Alternatively, running `open -a Docker`
also launched the daemon.)

## Command line

The rest of the commands will be given on the command line. A terminal window in Linux or OSX, the Command Prompt
in Windows.


## Tutorial

There is a nice [tutorial](https://www.docker.com/products/docker) to get started with Docker.
You can read that now, or you can go on with this article and read the tutorial later:

In this article I don't assume that you have read it.

## Empty Ubuntu image

We start by creating an empty Ubuntu image.

Create a new directory. In that directory create a file called `Dockerfile` with the following content:

```
FROM ubuntu:16.10
```

This means the foundation of our little toy will be version 16.10 of [Ubuntu](https://www.ubuntu.com/).

Then `cd` into that directory. Remember, we use the Terminal on Linux and OSX and the cmd on Windows for this.

Then run the following command: (note, there is a space and a dot at the end)

```
docker build -t mydocker .
```

The first time we run this, it will download the Ubuntu image and save it on the local disk, so the subsequent runs
won't have to download it.

After some output the last line should look like this:

```
Successfully built ab8e4d47cc70
```

though the code at the end will be different for you.

Congratulations. You've just built your first <b>Docker image</b>!

Note, the word "mydocker" is just the name I gave to it. You can use any name there, just remember it as we
will use the name in the following commands!

Now let's launch it.

```
$ docker run mydocker
```

Here we used the same name "mydocker" as we used to build the image.

Seemingly nothing happens. You get the prompt back. In reality, docker created a container
from the image and did what we told it to do: nothing.
Then it got shut down.

## Command to the empty Ubuntu Docker image

We can run commands on this image. Type

```
docker run mydocker ls -l /
```

you will see something like this:

```
total 64
drwxr-xr-x   1 root root 4096 Mar  1 15:23 bin
drwxr-xr-x   2 root root 4096 Oct  8 10:11 boot
drwxr-xr-x   5 root root  340 Mar  1 19:07 dev
drwxr-xr-x   1 root root 4096 Mar  1 19:07 etc
drwxr-xr-x   2 root root 4096 Oct  8 10:11 home
drwxr-xr-x   1 root root 4096 Mar  1 15:23 lib
drwxr-xr-x   2 root root 4096 Feb 24 08:27 lib64
drwxr-xr-x   2 root root 4096 Feb 24 08:26 media
drwxr-xr-x   2 root root 4096 Feb 24 08:26 mnt
drwxr-xr-x   2 root root 4096 Feb 24 08:26 opt
dr-xr-xr-x 119 root root    0 Mar  1 19:07 proc
drwx------   2 root root 4096 Feb 24 08:27 root
drwxr-xr-x   1 root root 4096 Feb 27 19:42 run
drwxr-xr-x   1 root root 4096 Mar  1 15:23 sbin
drwxr-xr-x   2 root root 4096 Feb 24 08:26 srv
dr-xr-xr-x  12 root root    0 Mar  1 19:07 sys
drwxrwxrwt   1 root root 4096 Mar  1 15:24 tmp
drwxr-xr-x   1 root root 4096 Feb 27 19:42 usr
drwxr-xr-x   1 root root 4096 Feb 27 19:42 var
```

If you know Linux or the command line of OSX, you already know that we executed the `ls -l /` command
which means list the content  of the root (`/`) directory. You can also see that the directory names
are very familiar. So yes, we have a small Linux system there, that we can use to execute commands on it
and it will shut down immediately after the command finished running.


## Perl on the Docker image of Ubuntu ?

```
docker run mydocker perl -v
```

The output will hopefully be familiar to you:

```

This is perl 5, version 22, subversion 2 (v5.22.2) built for x86_64-linux-gnu-thread-multi
(with 67 registered patches, see perl -V for more detail)

Copyright 1987-2015, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

That is. This Ubuntu image has Perl version 5.22.2 on it.

That's great so we have an image with perl on it! What else can we do with it?

## Perl on the command line

A slightly more complex command in Perl, but still a one-liner.

```
docker run mydocker perl -E 'say "hello from perl at " . localtime()'

hello from perl at Wed Mar  1 19:15:47 2017
```

That's lovely, but if we distribute this Docker image, the user will have
to type in the command. Can we bake that command into our Docker images?

Sure we can.

## Docker image with CMD

Let's change the `Dockerfile` to have the following content:

```
FROM ubuntu:16.10
CMD perl -E 'say "hello from perl at " . localtime()'
```

The `CMD` instruction will be executed when the container is launched.

Once we saved the file we need to rebuild our Docker image using the following command:

```
docker build -t mydocker .
```

and wait for the success at the end:

```
Successfully built dab2aef20fb7
```

This time the build will be much faster as we already have the Ubuntu image cached locally.

Then we can run our new Docker image:

```
docker run mydocker
```

and voila:

```
hello from perl at Wed Mar  1 19:21:29 2017
```

## Embedding a full Perl script in Docker image

The next step is to embed a full Perl script in the image.
So let's write a really simple script.

Create a file called <b>hello_world.pl</b> in the same directory
where we have the `Dockerfile` and put the following code in
the Perl file:

```perl
use 5.010;
use strict;
use warnings;

say 'Hello World from Perl script';
```

Change the `Dockerfile` to have the following content:

```
FROM ubuntu:16.10
COPY hello_world.pl /opt/
CMD  perl /opt/hello_world.pl
```

This will

<ol>
  <li>Create an image based on Ubuntu 16.10.</li>
  <li>It will copy the file <b>hello_world.pl</b> to the <b>/opt</b> directory of the Docker image.</li>
  <li>The `CMD` instruction tells Docker to run the script when we launch the container</li>
</ol>

We need to rebuild the image by running

```
docker build -t mydocker .
```

wait for the "success" and then run it using:

```
docker run mydocker
```

It will print "Hello World from Perl script" and then exit as expected.


OK. so we know how are we going to distribute our Perl script once it is done,
but how can we develop it? Certainly we would go crazy if after every change in the
Perl script we would need to build the image before we can run the script.

That would be almost like writing in a semi-compiled language such as Java or C#.

## Running perl script on the host filesystem

No, we can use our Docker image to run scripts that are only on the host filesystem.
For this we need to tell Docker to mount (share for people used to the Windows terminology)
one of the directories of the host filesystem to one of the directories of the Docker image.

We can do that when we launch the image using the `-v HOST_PATH:GUEST_PATH` option.

Before that however, we'd better remove that "hello_world.pl" from our image. So

change the `Dockerfile` to have the following:

```
FROM ubuntu:16.10
#COPY hello_world.pl /opt/
#CMD  perl /opt/hello_world.pl
```

Rebuild the image:

```
docker build -t mydocker .
```

Once it was build you can run the command that looks like this:

```
docker run -v /Users/gabor/work/mydocker:/opt/  mydocker perl /opt/hello_world.pl
```

Here you will have to replace "/Users/gabor/work/mydocker" by the path to your current directory
on the host operating system. 

This command will launch the Docker image called "mydocker" we have just created, and tell it
to run `perl /opt/hello_world.pl`.

You can edit the `hello_world.pl` and run it again without rebuilding the image.

The result should reflect your changes.

Enjoy Docker, and let me know what else would you like to know about Docker and Perl
in order to make the most out of it?


## Comments

Hi! Did you try to use official perl image? https://hub.docker.com/_/perl/

<hr>

Hi Gabor

Been using Perl for ages but have only started using Docker recently.

This is a great bit of info thanks!

<hr>

Thanks for the intro, Gabor. We started using this at work in the last few months on our Linux systems. I've wanted to try it out on a couple Mac Minis I'm using for my own projects so this is a great starting point.

<hr>

+1 to using the official perl images. You just pick your perl version so you would do "FROM perl:5.22" instead of "FROM ubuntu:16.10"

<hr>

Hello Gabor
Is it possible to pass parameters to a docker container like GetOptLong? I now I can use ENTRYPOINT like for example in
docker run -it <image> John
https://codewithyury.com/docker-run-vs-cmd-vs-entrypoint/

but what is If I have two parameters like name and age and I don't want to always use the same order when using docker images, lets say that I prefer to use -name Jonn -age 30, i. e.
docker run -it <image> -name Jonn -age 30
is it possible?
The real situation is that I have a get opt long script inside the docker and I dont now the best way to obtain the parameters.
Thank you!

---

Can't you just pass the parameters on the command line?

---

You can try `-e` option. Here is scrap from my Makefile:

docker run --name ${DOCKER_CONTAINER} -d -p ${DB_PORT}:5432 \
--user "$(id -u):$(id -g)" -v /etc/passwd:/etc/passwd:ro \
-v ${APP_ROOT}/db/pgdata:/var/lib/postgresql/data/pgdata \
-e PGDATA=/var/lib/postgresql/data/pgdata \
-e POSTGRES_PASSWORD=${DB_ROOT} \
postgres:10.4

If you run somethins inside container, you do this as usual:

docker exec -i ${DOCKER_CONTAINER} psql -U postgres -d ${DB_NAME}

NOTICE: -U postgres, -d ${DB_NAME}. This is same like `bash -c "your command here"`

man docker exec

docker exec [OPTIONS] CONTAINER COMMAND [ARG...]

<hr>
How to create a directory in docker container using perl script.
<hr>
Everybody can now use official docker image from Perl https://hub.docker.com/_/perl



