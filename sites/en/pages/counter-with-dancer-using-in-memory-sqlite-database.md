---
title: "Counter with Dancer using in-memory SQLite database"
timestamp: 2021-04-06T07:30:01
tags:
  - Dancer
  - DBI
  - SQLite
published: true
books:
  - dancer
author: szabgab
archive: true
show_related: true
---


A [counter example](https://code-maven.com/counter) using [Perl Dancer](/dancer) and an [in-memory SQLite database](/sqlite-in-memory).


{% include file="examples/dancer_counter_in_memory_sqlite.psgi" %}

In order to run this you'll have to have [Dancer2](https://metacpan.org/pod/Dancer2), [DBI](https://metacpan.org/pod/DBI), and [DBD::SQLite](https://metacpan.org/pod/DBD::SQLite) installed.

```
cpanm Dancer2 DBI DBD::SQLite
```

Then you can launch the development server:

```
plackup dancer_counter_in_memory_sqlite.psgi
```

and access the application via http://localhost:5000/

This was an interesting example to write, but I am not sure what would be the value of having an in-memory database for something like this as this means the data won't survive a restart of the application-server.

The data and the database is persistent among the requests that are served from the same process, but different processes will have different database (and in any real world situation you'll want to
have more than one process) and if you need to restart the application server (e.g. Starman) then you will lose all the data.

An external caching used by the application might make more sense.

[Using Redis](/counter-dancer2-redis-docker) for example provides persistence as well as atomic updates of the counter for performance via blocking incr().
