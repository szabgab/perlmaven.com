---
title: "Moving from CGI to PSGI and Starman"
timestamp: 2021-04-08T16:30:01
tags:
  - CGI
  - PSGI
  - Plack
  - Starman
  - Apache
  - Rex
published: true
author: szabgab
archive: true
description: "Moving from an old CGI application to Plack/PSGI in CGI mode and to running it in the Starman application server."
show_related: true
---


There are still some organizations out there that run applications written in Perl using plain old CGI. While it is a reasonable way to run small applications,
there are a lot of benefits in moving to some of the new frameworks such as [Perl Dancer](/dancer) or [Mojolicious](/mojolicious).

However that move might need a lot of changes to the code-base. An intermediate step, that can often be enough to reap a lot of the benefits, is to
move to Plack/PSGI. That will make the code easier to test and it can be served by an application server such as ** Starman**.

In this article we take a simple CGI script and we'll convert it to use Plack/PSGI. We also demonstrate how the old script runs as a plain CGI script,
and how the new version can run both as a CGI script and loaded by the application server.


We used [Rex](https://www.rexify.org/) to deploy the application to an Ubuntu-based 20.04 [Digital Ocean](/digitalocean) Droplet.

## The layout of the project

To be clear this layout is not a requirement in any way, it was just convenient for the deployment with Rex.

The main script are located in files/var/cgi-bin/app.cgi and files/var/cgi-bin/app.psgi and they are deployed
to /var/cgi-bin/app.cgi and /var/cgi-bin/app.psgi  respectively.

The files/etc/apache2/sites-enabled/apache.conf is the configuration file we need for Apache, it is copied to /etc/apache2/sites-enabled/apache.conf

For the version with Starman we could have switched to Nginx, but there was not a lot of value in the additional headache.

file/etc/systemd/system/starman.service is copied to /etc/systemd/system/starman.service and it is used to configure Starman as a service. (aka. daemon)

There are two test files in the t/ directory to verify the CGI and Plack/PSGI scripts.

Finally there is the Rexfile that includes the deployment script.

Of course you can use any other tool for deployment, but including the one I used makes it easier for you to check the solution yourself and it was certainly easier
for me to develop it.

```
.
├── files
│   ├── etc
│   │   ├── apache2
│   │   │   └── sites-enabled
│   │   │       └── apache.conf
│   │   └── systemd
│   │       └── system
│   │           └── starman.service
│   └── var
│       └── cgi-bin
│           ├── app.cgi
│           └── app.psgi
├── Rexfile
└── t
    ├── cgi.t
    └── psgi.t
```

## The original CGI script

{% include file="examples/cgi-to-psgi/files/var/cgi-bin/app.cgi" %}

The script used the CGI.pm module.

It has two cases, if the parameter **pid** is passed to the server then it sends back the current process ID.
We are using this to show that a CGI script will create a new process on every invocation.

The second case is when pid is not supplied. The user can send a parameter called **name** with some content and the "application" will echo it back prefixing it with the word "Hello".

To make it simpler to read there is only one location that prints code.

## Test for the CGI script

{% include file="examples/cgi-to-psgi/t/cgi.t" %}

To verify that the code works properly we wrote a test script. It executes the CGI script on the command line passing values to it.
You can run it either as **perl t/cgi.t** or better yet as **prove t/cgi.t**

## The PSGI version

{% include file="examples/cgi-to-psgi/files/var/cgi-bin/app.psgi" %}

Getting the parameters supplied by the user is quite similar in the PSGI version as well, but instead of using the CGI.pm module we use the
[Plack::Request](https://metacpan.org/pod/Plack::Request) module and the whole thing is inside a function.

Then instead of printing the resulting HTML we return a 3-element array reference in which the first element is the HTTP status code, the
2nd element is the HTTP header, and the 3rd element is the HTML.

The first line has also changed as this application must be executed by the **plackup** command when running in CGI mode.

Now thinking about it, I am not sure how do you run this on Windows. There probably you need to associate the **.psgi** extension with **plackup**.

In order to try it on your own computer and during development you can run it with:

```
plackup files/var/cgi-bin/app.psgi
```

It will print

```
HTTP::Server::PSGI: Accepting connections at http://0:5000/
```

and then you can visit the application by browsing too **http://0:5000/**. You can stop it by pressing Ctrl-C.
You can also try **http://0.0.0.0:5000/?name=Foo** and also **http://0.0.0.0:5000/?pid=1**.

## Test for the PSGI version

{% include file="examples/cgi-to-psgi/t/psgi.t" %}

This is the test script for the PSGI version. We use load_psgi to load our application in the memory of the test script.
From that we create a test-object and then we use the test-object to send in various requests.

These tests demonstrate that it is quite easy to send in different date to a GET and a POST request and then to verify the results.

You can run it either as **perl t/psgi.t** or better yet as **prove t/psgi.t**

You could run all the tests by just typing

```
prove
```

## The Apache configuration file

{% include file="examples/cgi-to-psgi/files/etc/apache2/sites-enabled/apache.conf" %}

The lines with ProxyPass in them are only needed for the Starman-version. The /var/cgi-bin mapping is only needed for the
CGI version and for running the PSGI version in CGI mode.

## The Systemd configuration file

{% include file="examples/cgi-to-psgi/files/etc/systemd/system/starman.service" %}

This configuration file is needed to create a Starman service (or Daemon as it is usually called in the Unix/Linux world).

It has instruction on how to run the starman command. In this version Starman is configured to listen on port 81 for all the traffic.
This makes it easier to debug, but not a recommended choice for production.

On a real production environment it would either only listen to requests coming from the localhost or it would use a socket.

We also configured it with 3 workers so it will be able to handle 3 concurrent requests. (On the PerlMaven server we use 20 workers to handle the load.)

## The Rexfile to install it all

{% include file="examples/cgi-to-psgi/Rexfile" %}

In order to install the whole demo you need a Virtual Private Server (VPS) running Ubuntu.
I used Ubuntu 20.04 running at [Digital Ocean](/digitalocean). They call their VPS-es "droplets".

I installed [Rexify](https://www.rexify.org/) on my local computer. Inserted the IP address of the
newly created remote host in the Rexfile instead of the IP address you can see in the **group all** line.
Then ran the following command:

```
rex -g all setup
```

It takes a few minutes till it installs everything, but then it also verifies the installation.

I've added some comments to the Rexfile, basically we execute the "setup" task that will execute all the other tasks in a given order.


## Verify the results

Once the installation is done you can access the 4 versions (after replacing IP with the correct IP address) as:

```
http://IP/cgi-bin/app.cgi    - The regular CGI implementation.
http://IP/cgi-bin/app.psgi   - The PSGI implementation running in CGI mode.
http://IP:81                 - The Starman directly, enabled only for debugging.
http://IP/starman/           - The Starman via the Apache server using a Reverse Proxy setting.
```

To manually verify the proper working type in:

```
http://IP/cgi-bin/app.cgi?name=Foo Bar
http://IP/cgi-bin/app.psgi?name=Foo Bar

http://IP:81?name=Foo Bar
http://IP/starman/?name=Foo Bar
```

To check the persistence of the Plackup/PSGI/Starman solution vs. the CGI-mode solution try the following requests.
Try to reload each one several times. The first 2 will show an always changing (growing) number as each request is handled
by a separate process.

The 3rd and 4th will randomly show any of 3 fixed numbers as there are 3 workers waiting to handle the requests.

```
http://IP/cgi-bin/app.cgi?pid=1
http://IP/cgi-bin/app.psgi?pid=1

http://IP:81/?pid=1
http://IP/starman/?pid=1
```



