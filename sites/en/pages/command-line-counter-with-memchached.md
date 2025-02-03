---
title: "Command line counter with Memcached"
timestamp: 2018-05-27T10:30:01
tags:
  - Memcached::Client
  - Memcached::Server
  - NoSQL
published: true
author: szabgab
archive: true
---


[Memcached](https://memcached.org/) is a distributed memory object caching system originally written in Perl, then converted to C for high performance.

It can be used for caching data and reusing them among processes. It can also be used as an in-memory database. Today it falls in the key-value category of the NoSQL databases.

In this example we are going to use a pure Perl implementation of the server - because it is easy to install - and a pure Perl client. We are going to create a simple [counter](https://code-maven.com/counter) with it.


## Memcached::Server

The [Memcached::Server](https://metacpan.org/pod/Memcached::Server) is a pure Perl implementation of the server. One of the good things about that is that it is easy to install without being root. One can customize it in various ways, but it also come a default version of it that we can use as follows:

{% include file="examples/memcached_server.pl" %}

We launch this in one terminal.


## Memcached::Client

The counter is implemented in a separate script that uses the [Memcached::Client](https://metacpan.org/pod/Memcached::Client) module.

At first we need to connect to the server, then we can use various methods on the received object.
Here we use the `incr` method that will increment the value in the cache.
The first parameter of the `incr` method is the name of the key.
The second parameter is the amount with which we would like to increment the value.
It defaults to 1, but we need to set it here as we would like to pass the third parameter which is the initial value.

We need set the initial value to one as apparently this server is not "Perlish" enough to use the missing value as a 0. Moreover setting the initial value to 0 would not work either. I suspect this is a bug somewhere though I have not checked it deeply. 

That's the whole story here:

{% include file="examples/memcached_counter.pl" %}

Now we can run this script on the command line and on every run it will print a number one larger than the previous run did. Until we restart the server, in which case the counting starts again.

```
perl memcached_counter.pl
```

