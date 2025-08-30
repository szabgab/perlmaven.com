---
title: "Hello World with Plack in CGI mode"
timestamp: 2017-07-01T09:30:01
tags:
  - Plack::Handler::CGI
published: true
books:
  - psgi
author: szabgab
archive: true
---


Recently I've started to work in an evironment where there are tons of CGI script without any mention of
[use strict; or use warnings](/always-use-strict-and-use-warnings). At this point I don't yet
have the political power to set up a PSGI based server, but as I hope one day I'll be I wanted to
write my new scripts using PSGI. The problem was, how could I run my PSGI script as CGI?


Luckily [Tatsuhiko Miyagawa](https://www.linkedin.com/in/miyagawa), the author of Plack and PSGI has
thought about similar needs and included the [Plack::Handler::CGI](https://metacpan.org/pod/Plack::Handler::CGI)
module in th main [Plack distribution](https://metacpan.org/release/Plack).

## Hello World!

{% include file="examples/plack-cgi-hello-world.pl" %}

You probably already know from the [Getting started with PSGI](/getting-started-with-psgi) article
that in the PSGI standard we are expected to create a subroutine and have it as the last expression in our main
Perl file. That subroutine will be called on every request from the web client and it is expected to return
an array reference with 3 values.

1. The first is the HTTP Status code which is 200 in case of success.
1. The second is a list of key-value pairs that will become the response header.
1. The third is the actual content of the page.

So that's what we have in our example. So far this was exactly the same as with any other PSGI code.

The difference is in the [Hash-bang](/hashbang) line. It points to `plackup`:

```
#!/usr/bin/env plackup
```

We can run this by typing in

`perl plack-cgi-hello-world.pl`

and it will launch a small web server on port 2000.

Alternatively, if we would like to run it as a CGI script,
we can convert it to be executable `chmod +x plack-cgi-hello-world.pl` on Unix/Linux systems,
and configure our web server (most likely Apache) to serve this script as a CGI script.

That's it. Now you have the skeleton of a PSGI based application, but running as a plain CGI script.

## Using with Plack on other port

When I tried the above using `perl plack-cgi-hello-world.pl` I got an error:

`failed to listen to port 5000: Address already in use at .../HTTP/Server/PSGI.pm line 94.`

This means I already have another application, probably another PSGI-based application running on that port.

The way to change this sctipt to run on a different port is by adding `--port` to the hashbang line.

{% include file="examples/plack-cgi-hello-world-port-2000.pl" %}

That is not enough though. If we run this as `perl plack-cgi-hello-world-port-2000.pl` it will still try
to open port 5000. We also need to add the eXecutable bit: `chmod +x plack-cgi-hello-world-port-2000.pl`
and run it as

```
./plack-cgi-hello-world-port-2000.pl
```

## Comments

how does demonstrate a cgi script that is being run under plack? to demo CGI becoming PSGI you would need a CGI.pm based script doing hello world.

---
CGI.pm is just one implementation of the Common Gateway Interface (aka. CGI). The whole point of this article is to show that you can do CGI with Plack as well.

---

Hello
I'm on Windows : Is there an alternative for : /usr/bin/env in the shebang.
thanks in advance

