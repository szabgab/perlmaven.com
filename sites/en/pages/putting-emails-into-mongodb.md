---
title: "Putting the email in MongoDB - part 1"
timestamp: 2015-05-26T10:02:01
tags:
  - Email::Address
  - MongoDB
published: true
books:
  - mongodb
  - mbox
author: szabgab
---


Now that we have a some feeling of the fields we'll have to store let's go back to the From-fields, clean it up and store it in our database.


[Email::Address](https://metacpan.org/pod/Email::Address), another module by RJBS, can handle e-mail addresses. It has a method called `parse` that would take a string
and try to find all the e-mail address in that string. So we can pass the value of the From field to it and get back the list of, hopefully one,
address.

I took the script from [the previous article](/indexing-emails-in-an-mbox) and added the following code in the internal while-loop, then ran the script:

```perl
    my $from_string = $msg->header('From');
    my @from = Email::Address->parse($from_string);
    say $from[0]->address;
    say $from[0]->name;
```

It nicely printed out the e-mail addresses and the names of the sender.

## Some data validation

I am not sure how much I can trust these e-mail boxes and the parser, will there be cases when it
cannot recognize any e-mail addresses and will return an empty list?
Can there be cases when it returns more than one values?
We saw that there are tons of fields, most of them only in some of the messages. While `From` seems to be a
required field, can there be messages without a `From` field?

Let's be defensive here and check for all the possibilities:

```perl
    my $from_string = $msg->header('From');
        if (not defined $from_string) {
        warn "There is no From field in this message";
        next;
    }
    my @from = Email::Address->parse($from_string);
    if (@from > 1) {
        warn "Strange, there were more than one emails recognized in the From field: " . $msg->header('From');
    }
    if (not @from) {
        warn "Very strange. No email in the From field! " . $msg->header('From');
        next;
    }
    say $from[0]->address;
    say $from[0]->name;
```

In this first version, I just printed a warning and depending on the seriousness either let the loop continue,
or, if the From field was missing or could not be recognized, aborted the current iteration and went for the
`next` message. Later on we'll have to improve this reporting.

## Mail System Internal Data

As I noticed some (and strangely not all) the mail boxes have one e-mail at the beginning of the
box holding some internal data. Later I'll have to investigate why is the difference, but for now
let's just filter out these messages:

```perl
    if ($from[0]->name eq 'Mail System Internal Data') {
        next;
    }
```

## Adding to MongoDB

Now that we have the sender addresses from all the messages, let's start putting the data in MongoDB.

We load the [perl driver to MongoDB](https://metacpan.org/pod/MongoDB), connect to the server using the
[MongoDB::MongoClient](https://metacpan.org/pod/MongoDB::MongoClient).
Then we need to select the database using the `get_database` method.
(In MongoDB we don't need to create a database. It is enough just to add some data to it and
the MongoDB server will automatically create the database as well.)

From the database object we need to select one of the collections. This too, will be automatically created
when we store the first document. As we are going to store the e-mail messages, we'll just call the
collection "messages".

This is what we add at the beginning of the script:

```perl
use MongoDB;

my $client     = MongoDB::MongoClient->new(host => 'localhost', port => 27017);
my $database   = $client->get_database( 'mboxer' );
my $collection = $database->get_collection( 'messages' );
```

Then inside the internal while-loop, after we have parsed the From field and checked that we got
exactly one address back, we create a `document` that we'll store in MongoDB.

A document in MongoDB is just a Perl hash. So we create:

```perl
    my %doc = (
        From => {
            name => $from[0]->name,
            address => $from[0]->address,
        },
    );
```

and the store it in the database:

```perl
    $collection->insert(\%doc);
```

There is no need to do anything else.

We run the script `perl bin/mboxer.pl /home/gabor/mail`, and if everything worked well then it added a few documents to the database.
(Only a few as we still have the `exit if $count > 20;` in the loop to limit the run-time.

## MongoDB client

Let's check the results using the command-line client of MongoDB:

```
$ mongo
> show dbs
dev      0.203125GB
local    0.078125GB
mboxer   0.203125GB

> use mboxer
switched to db mboxer

> show collections
messages
system.indexes

> db.messages.find()
{ "_id" : ObjectId("52ea2aa6fde2dafe02000000"), "From" : { "name" : "Foo Bar", "address" : "foo@bar.com" } }
{ "_id" : ObjectId("52ea2aa6fde2dafe02000001"), "From" : { "name" : "Perti Bar", "address" : "peti@bar.org" } }
...
```

So far it looks good but we won't want to use this client every time we want to find an e-mail message.
Let's start to build another script that will help us finding e-mail messages.


```perl
use strict;
use warnings;
use 5.010;

use MongoDB;

my $client     = MongoDB::MongoClient->new(host => 'localhost', port => 27017);
my $database   = $client->get_database( 'mboxer' );
my $collection = $database->get_collection( 'messages' );

print "mail-boxer> ";
my $term = <STDIN>;
chomp $term;

my $messages = $collection->find({ 'From.address' => qr/$term/ } );
while (my $m = $messages->next) {
    say '';
    say $m->{From}{name};
    say $m->{From}{address};
}
```

In this script the user can type in a string that will be used as a regular expression matching
against the e-mail addresses in the database.
The `find` method receives the search path - the keys in the hash structure separated by dots -
and a regular expression to match against the field. The `next` calls in the iterator will
return the next document as we inserted in the other script.

In addition to the actual data we inserted, each hash also contains a key `_id` holding a
MongoDB::OID object. That's the unique id of the document.

## Adding Subject

Now that we can store and retrieve The From fields, let's add another field. The `Subject` field
seems to be simple as it is free text. So we change the document we create during the indexing and run the script again.

```perl
    my %doc = (
        From => {
            name => $from[0]->name,
            address => $from[0]->address,
        },
        Subject => $msg->header('Subject'),
    );
```

We also add line to the client script to display the content of the Subject:

```perl
   say $m->{Subject};
```

When we try to list the data, we'll notice that every message is stored twice.

That's because the collection was not cleaned before we started to collected the
data.

We can add

```perl
$database->drop;
```

immediately after we called `get_database`. This will remove the existing content of
the whole database, before we start to populate it again.

## Current version

The current version of the data collector script looks like this:

```perl
use strict;
use warnings;
use 5.010;

use Path::Iterator::Rule;
use Email::Folder;
use Email::Address;
use MongoDB;

my $path_to_dir = shift or die "Usage: $0 path/to/mail\n";

my $client     = MongoDB::MongoClient->new(host => 'localhost', port => 27017);
my $database   = $client->get_database( 'mboxer' );
$database->drop;
my $collection = $database->get_collection( 'messages' );

my $count = 0;

my $rule = Path::Iterator::Rule->new;
my $it = $rule->iter( $path_to_dir );
while ( my $file = $it->() ) {
    next if not -f $file;
    say $file;
    my $folder = Email::Folder->new($file);
    while (my $msg = $folder->next_message) {  # Email::Simple objects
        $count++;
        my $from_string = $msg->header('From');
        if (not defined $from_string) {
            warn "There is no From field in this message";
            next;
        }
        my @from = Email::Address->parse($from_string);
        if (@from > 1) {
            warn "Strange, there were more than one emails recognized in the From field: " . $msg->header('From');
        }
        if (not @from) {
            warn "Very strange. No email in the From field! " . $msg->header('From');
            next;
        }
        say $from[0]->address;
        say $from[0]->name;
        if ($from[0]->name eq 'Mail System Internal Data') {
            next;
        }
        my %doc = (
            From => {
                name => $from[0]->name,
                address => $from[0]->address,
            },
            Subject => $msg->header('Subject'),
        );
        $collection->insert(\%doc);
        exit if $count > 20;
    }
}
say $count;
```


