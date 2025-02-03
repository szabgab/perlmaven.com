---
title: "Counter Examples"
timestamp: 2015-03-28T15:40:01
tags:
  - counter
published: true
books:
  - counter
author: szabgab
---


In this project we are going to implement a counter with various front-ends and back-ends.


The simpler version of the counter script handles a single counter. Every time we run  the counter it will fetch the latest value from
the "back-end", increment it by one, display the new value, and save the new value back to the "back-end". An interaction might look like this:

```
$ count
  1
$ count
  2
$ count
  3
```

The slightly more complex version will receive a string as an input and for each string it will maintain a separate counter.
So an interaction might look like this:

```
$ count foo
  foo: 1
$ count foo
  foo: 2
$ count bar
  bar: 1
$ count foo
  foo: 3
```

The front-end can be command line, or web, or maybe some other GUI.

The back-end is some kind of a "database".  It can be a plain text file, some data serialization format, a relational database, a NoSQL database
and who knows what else.

This is going to be a long project, but it might help understand various techniques for data serialization.

* A [command-line counter script](/command-line-counter) that uses a plain file called `counter.txt` for a single counter.
* [On-load counter with JavaScript and local storage](https://code-maven.com/on-load-counter-with-javascript-and-local-storage)
* [Multiple command line counters with plain TSV text file back-end](/multiple-command-line-counters)
* [A command line counter with database back-end using DBIx::Class](/counter-with-database-backend-using-dbix-class)
* [Command line counter with JSON backend](/command-line-counter-with-json-backend)
* [Counter with Dancer session](/counter-with-dancer-sessions)
* [In-memory counter using AngularJS](https://code-maven.com/simple-in-memory-counter-with-angularjs)
* [Automatic counter using AngularJS](https://code-maven.com/automatic-counter-using-angularjs)
* [Several counters in MongoDB client](https://code-maven.com/counter-in-mongodb-client)
* [Command line counter with MongoDB as storage](/command-line-counter-with-mongodb)
* [Command-line counter in Python](http://code-maven.com/comman-line-counter-in-python) for a single counter.
* [Counter with Mojolicious Lite](/counter-with-mojolicious-lite)
* [Command line counter with Memcached](/command-line-counter-with-memchached)
* [increasing numbers in a text file](/increase-numbers-in-a-file)


<!--
## Front-end

* command line
* web based:
        <ul>
* plain CGI
* CGI with Ajax
* plain PSGI
* PSGI with Ajax
* Dancer
* Mojolicious
        </ul>
    

## Back-end

* several counters each one in its own file
* several counters in a .txt file in CSV format
* several counters in a yaml/json file
* 1 counter in SQLite
* several counters in SQLite
* 1 counter in MySQL
* several counters in MySQL
*   ? PostgreSQL
* 1 counter in MongoDB
* several counters in MongoDB
-->
