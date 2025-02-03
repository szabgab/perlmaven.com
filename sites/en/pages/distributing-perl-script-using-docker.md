---
title: "Distributing a Perl script using Docker container"
timestamp: 2018-12-07T09:30:01
tags:
  - Docker
published: true
author: szabgab
archive: true
---


Earlier we saw how to [get started with Perl on Docker](/getting-started-with-perl-on-docker).

This time we'll have a simple script and distribute it using Docker.

If the simple script only uses standard Perl modules, then we might not need this extra work, but
in this example we'll have a script that uses [Image::Magick](https://metacpan.org/pod/Image::Magick).


## The script

This is the script I'd like to distribute:

{% include file="examples/perl-script/bin/script.pl" %}

It loads the `Image::Magick` library though it does not actually uses it. I did not want the script to be complex.

It also loads the [Getopt::Long](https://metacpan.org/pod/Getopt::Long) module to demonstrate how we can pass parameters
to the script.

There is really nothing fancy here.

## The Dockerfile

{% include file="examples/perl-script/Dockerfile" %}

In this example we rely on Ubuntu 18.04, but you can use any other image.

In this case I opted to use the system Perl and to install the necessary Perl modules using `apt-get`.
Alternatively you could download and compile your own version of Perl and then install modules using `cpanm`.
Which approach to use depends on your needs.

Using the `RUN` command we update and upgrade all the packages that came with the Docker image and then we install the
Perl module we need. (Note the `-y` parameters that will tell `apt-get` to say yes to its own questions.

Here you could install any other package distributed by Ubuntu.

Then we create a working directory and `COPY` the script from the directory on the host machine
to the `/opt` directory of the Docker image we are creating.

Unlike in the [get started](/getting-started-with-perl-on-docker) case when we wanted to have the script on the host machine to make it easy to edit it, this time we would like it to be part of the Docker image so we can distributed it easily.

Finally we use the `ENTRYPOINT` directive in the Dockerfile to tell docker what to execute when the container starts to run.


## Directory layout

Jut to be clear the directory layout for this project is:

```
project-root/
    Dockerfile
    bin/
        script.pl
```

## Building the Docker image

I assume you have already installed [Docker](https://www.docker.com/) and the daemon is running.

This command executed in the project-root directory where the Dockerfile can be found.
Th name "mydocker" is arbitrary. You can use anything there.

```
$ docker build -t mydocker .
```

## Running the script in the Docker image

The `--rm` option is needed so the container will be removed after the execution is finished.
The name we chose above when we build the image is needed here again.

After that we can pass the parameters we would want to pass to the script.

```
$ docker run --rm mydocker
running on 5.026001...
```

```
$ docker run --rm mydocker --verbose
running on 5.026001...
localhost
```

```
$ docker run --rm mydocker --verbose --server hello
running on 5.026001...
hello
```


## Distributing Private Docker Image

Once we created a Docker image we can distribute it privately to anyone.

Use the [save](https://docs.docker.com/engine/reference/commandline/save/) command to
create a tar file of the image. You can give any name to the tar file. Then zip it to make it smaller.

```
docker save mydocker -o my.tar
gzip my.tar
```

Copy the resulting "my.tar.gz" file to the target machine.

Then on the target machine, where you also have Docker installed and running, 
unzip the zip file and [load](https://docs.docker.com/engine/reference/commandline/load/) the image:

```
gunzip my.tar.gz
docker load my.tar
```

After that we can run the image as we did earlier.

## Comments

can run this script with localhost directly from browser ?
http://localhost:3000/script.pl

---

It's not a CGI script :)

For extra points make it a Catalyst app and EXPORT port 5000..

<hr>

I've followed this example up to running it with no arguments via "docker run myperleg2" fine, but when I add "--verbose" I got the baffling:

docker: Error response from daemon: OCI runtime create failed: container_linux.go:345: starting container process caused "exec: \"--verbose\": executable file not found in $PATH": unknown.

It seems to be trying to execute '--verbose'? This is with Docker version 18.09.7, build 2d0083d, on Ubuntu 18.04

EDIT: sorry, my mistake. I still had a CMD to run the Perl script, not an ENTRYPOINT. Forget I spoke:-)

