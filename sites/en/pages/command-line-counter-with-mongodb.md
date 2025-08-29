---
title: "Command line counter in Perl with MongoDB as storage"
timestamp: 2017-05-16T18:50:01
tags:
  - MongoDB
  - findAndModify
  - upsert
published: true
books:
  - mongodb
author: szabgab
archive: true
---


In the [counter](https://code-maven.com/counter) examples we have already seen command line solutions, but we have not used
MongoDB as the back-end storage.
There is a [counter with MongoDB client](http://code-maven.com/counter-in-mongodb-client)
and we are using the solution from there, but from Perl.


{% include file="examples/counter_mongodb.pl" %}

We assume MongoDB 1.0.1 (Version 1 introduces some changes so if you have an older version of the client this might not work.)

After connecting to the database server on localhost, accessing a `database` called 'test', we fetch an object to access the
`collection` called 'counter'. As usual, we don't need to create any of these. The first time we insert any value,
they will both spring to existance.

Then we call the `find_one_and_update` method.
The first hash is the locator. It will find the document where the `_id` is the name we gave on the command line.
The name of the counter.

The second hash is the actual update command. Here we say we would like to increment (`$inc`) the field 'val' by 1.

The third hash provides some additional parameters for runnin our request. `upsert` means we would like to `update`
the document if it could be found, and `insert` it if could not be found. The `new` field means we would like
the call to return the document **after** the update. (By default it would return the old version of the document.)
See also the documentation of [findAndModify](http://docs.mongodb.org/manual/reference/method/db.collection.findAndModify/)
for more options.

```perl
my $res = $col->find_one_and_update(
    { _id => $name },
    {'$inc' => { val => 1}},
    {'upsert' => 1, new => 1},
);
```


For further details check out the article on 
[creating and auto-increment field](http://docs.mongodb.org/manual/tutorial/create-an-auto-incrementing-field/).


## Comments

File with same columns but -- they do not line up vertically how does one line up the columns


