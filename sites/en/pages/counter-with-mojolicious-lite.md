---
title: "Counter with Mojolicious Lite"
timestamp: 2017-07-31T20:30:01
tags:
  - Mojolicious::Lite
published: true
author: szabgab
archive: true
---


A simple [counter example](/counter) using [Mojolicious::Lite](/mojolicious).


{% include file="examples/mojo_lite_counter.pl" %}

We can start the application running

```
$ morbo mojo_lite_counter.pl

Server available at http://127.0.0.1:3000
```

Then we can open another terminal and use `curl` to fetch the page:

```
$ curl http://127.0.0.1:3000/
1
```

and again:

```
$ curl http://127.0.0.1:3000/
2
```

We can also write a Shell snippet to access the pages several times in a loop:

```
for i in {1..10}; do curl http://127.0.0.1:3000/; done
3
4
5
6
7
8
9
10
11
12
```

We can stop the server by pressing Ctrl-C in the window where we ran the server.
If we start the server again, the counting will start again from 1.


What if we have a lot of clients accessing the server at the same time?

We can try this by opening 2 or more windows and running the above shell snippet
in all of them.

This counter is very fast, so probably it would be able to handle a lot of clients
even using morbo which runs a single server.

If however this counting is part of a heavier process, we cannot rely on a single process.

I tried with two windows each execution 100 requests. The last number printed was 200, as expected.

Let's see how will this work with Hypnotoad.

## Counter with Hypnotoad

The same script, but this time we run

```
$ hypnotoad mojo_lite_counter.pl
```

It starts the process in the background and it listens by default on port 8080.

I ran the shell snippet again from 1 to 100. I did not even need to run it in two windows in
order to see the problem. The numbers got repeated:

```
1
1
2
1
3
1
2
2
3
4
4
3
2
5
5
6
3
...
28
25
22
29
30
26
23
27
28
```

The reason for this is that Hypnotoad forks several server processes and each process has its own `$counter` variable.

If we would like a single counter we have to find a different solution.

You can shut down the Hypnotoad server by running:

```
$ hypnotoad -s mojo_lite_counter.pl

```

