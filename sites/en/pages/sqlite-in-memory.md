---
title: "SQLite in Memory"
timestamp: 2018-06-11T05:50:01
tags:
  - SQLite
  - memory
  - :memory:
published: true
author: szabgab
archive: true
---


There are many cases where we have some data we would like to interrogate where using SQL would make it easier to fetch data.
However we would like to make things fast. Having all the data in memory is always much faster than having it on disk.
Even with modern SSD-based disks.

[SQLite](http://sqlite.org/) allows us to create a database entirely in memory.

Of course this means the amount of data we can hold is limited to the available free memory and the data, in this format,
will be lost once the process ends.

Nevertheless it can be very useful as temporary data storage instead of using hashes, arrays.


In order to create an in-memory SQLite database we need to connect to the database using `:memory:` pseudo-name
instead of a filename.

{% include file="examples/sqlite_in_memory.pl" %}

Once we have the database handle (`$dbh`) we can do all the usual operations.
We will usually start by creating tables and indexes.
Then we can INSERT rows.

Except of the connection string our code is not aware that it is talking to an in-memory database.


See also the [counter example using Perl Dancer and an in-memory SQLite database](/counter-with-dancer-using-in-memory-sqlite-database)

## Comments

Hmmm.... been using sqlite for some time now and never even thought of using a memory only db. This could be very handy on an RPi connected to an Arduino where there might be smaller amounts of data which one does not need to store, but might need to display or analyze and then send on the results and subsequently get rid of. Nice! Thanks for pointing that out.

<hr>

Hi Gabor, have you ever compared the performance of this compared to standard hashes when doing thousands of queries?

<hr>

Would be nice to know how to do this with a web app. For example, various web users are querying data, so we'd need to know how to make the connection to the in-memory database persistent across multiple runs of the same Perl cgi script.

If you are using plain old CGI then you cannot do this as CGI will run a separate process for each request. If you use something like Dancer or Mojolicious then you can. See this example: https://perlmaven.com/counter-with-dancer-using-in-memory-sqlite-database
However I am not sure in which situation would that be useful.

My app would be a web-based chat app that would support 20 users for about 15 minutes.

The Dancer count example is unclear, that article doesn't accept comments, I'm referred to GitHub where it's painfully unclear how to comment.

What is unclear in the Dancer example?



