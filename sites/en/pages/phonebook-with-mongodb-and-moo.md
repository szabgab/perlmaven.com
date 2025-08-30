---
title: "Command line phonebook with MongoDB and Moo"
timestamp: 2015-05-13T07:30:01
tags:
  - MongoDB
  - Moo
  - MooX::Options
published: true
books:
  - mongodb
  - moo
author: szabgab
---


[MongoDB](http://www.mongodb.org/) is an open source NoSQL database.
In this example we'll write a small,
command line, phonebook. This is a simple example to see how to
[use MongoDB in Perl](/mongodb).



## Installation

Before getting started, we'll need to install MongoDB itself
and the [MongoDB Perl driver](https://metacpan.org/pod/MongoDB)

On Ubuntu, it means installing both the `mongodb` and
`mongodb-dev` packages.

On OSX I used homebrew to install the mongodb server and then I could
install the Perl driver using cpanm.


## The full example

```perl
use 5.010;
use Moo;
use MooX::Options;

use MongoDB ();
use Data::Dumper qw(Dumper);

option add   => (is => 'ro');
option list  => (is => 'ro');
option name  => (is => 'ro', format => 's');
option phone => (is => 'ro', format => 's');

sub run {
    my ($self) = @_;

    my $client = MongoDB::MongoClient->new(host => 'localhost', port => 27017);
    my $db   = $client->get_database( 'phonebook' );
    my $people_coll = $db->get_collection('people');

    say 'Processing ...';
    if ($self->add) {
        $people_coll->insert( {
            name => $self->name,
            phone => $self->phone,
        });
    } elsif ($self->list) {
        my %query;
        if ($self->name) {
            $query{name} = $self->name;
        }
        if ($self->phone) {
            $query{phone} = $self->phone;
        }
        my $people = $people_coll->find(\%query);
        while (my $p = $people->next) {
            printf "%s  %s\n", $p->{name}, $p->{phone};
        }
    } else {
        die "Missing --add or --list";
    }
}
 
main->new_with_options->run;
```


## The command line part

We are using the same technique explained in the article about
[command line scripts using Moo](/command-line-scripts-with-moo):

We turn the whole script into a Moo-based class by `use Moo;`
Load `use MooX::Options;` to allow us to declare options and
we declare 4 optional attributes. Two of them can accept strings:
`format => 's'` the other two are boolean options. (aka. flags).

The call to `main->new_with_options->run;` processes
the options and then calls the `run` method.

Inside the `run` method we'll have access to the values
provide by the user on the command line. 

Basically we expect to have two types of actions here:

Adding a new person:

`perl phonebook.pl --add --name 'Foo Bar' --phone 1234`

Listing all the people

`perl phonebook.pl --list`

Listing specific people:

`perl phonebook.pl --list --name Foo`

```perl
use 5.010;
use Moo;
use MooX::Options;

use Data::Dumper qw(Dumper);

option add   => (is => 'ro');
option list  => (is => 'ro');
option name  => (is => 'ro', format => 's');
option phone => (is => 'ro', format => 's');

sub run {
    my ($self) = @_;
    say $self->name;
    say $self->phone;
}

main->new_with_options->run;
```


## Setting up a MongoDB database

Besides making sure the MongoDB server runs,
and that we can connect to it, there is not much to
do in order to create a database:

```perl
use MongoDB ();
my $client = MongoDB::MongoClient->new(host => 'localhost', port => 27017);
my $db   = $client->get_database( 'phonebook' );
my $people_coll = $db->get_collection('people');
```

After loading the MongoDB driver with `use MongoDB ();`
we can connect to a running server using the `new`
constructor of the `MongoDB::MongoClient` module.

By default no authentication is required.

Then we fetch our database by providing its name:
`my $db   = $client->get_database( 'phonebook' );`

There is no need to create the database. Basically the first time
we add some data to it, the database will spring to existence.
Just like the [autovivification](/autovivification) in Perl.

The last step in this example is to fetch the object representing
the collection that will actually hold the list of people:
`my $people_coll = $db->get_collection('people');`

A collection in MongoDB is similar to a table in an SQL database.

In this case too, we don't need to make any special preparations.
Once we add the first entry, the collection will be created.


## Inserting a document

If the user supplied the `--add` flag
we take all the other data (in our case that is the name and
the phone), create a hash reference and pass it to the
`insert` method. No need to declare how the table looks like.
In fact the entries don't even need to have the same content.

```perl
    if ($self->add) {
        $people_coll->insert( {
            name => $self->name,
            phone => $self->phone,
        });
```

In our example we have not checked if the user has supplied the
necessary values and we don't check if the same name or the same
phone number already exists in the database.

## Listing the values

```perl
    } elsif ($self->list) {
        my %query;
        if ($self->name) {
            $query{name} = $self->name;
        }
        if ($self->phone) {
            $query{phone} = $self->phone;
        }
        my $people = $people_coll->find(\%query);
        while (my $p = $people->next) {
            printf "%s  %s\n", $p->{name}, $p->{phone};
        }
```

When the user supplied the `--list` flag we build a
query, which is basically just a hash and then call the
`find` method.

This is how we build the query:

```perl
    my %query;
    if ($self->name) {
        $query{name} = $self->name;
    }
    if ($self->phone) {
        $query{phone} = $self->phone;
    }
```
 

The `find` method will return an **iterable** object.
This means we can call the `next` method on the object
and it will return the data entries one by one.
When it exhausted all the answers it will return `undef`.
The data entries returned by the `next` call are the
same hash references we supplied to the `insert` method.

```perl
    my $people = $people_coll->find(\%query);
    while (my $p = $people->next) {
        printf "%s  %s\n", $p->{name}, $p->{phone};
    }
```

That's it. We can now use the the basics of MongoDB.


1. [Command line phonebook with MongoDB and Moo](/phonebook-with-mongodb-and-moo) (this article)
1. [Updating MongoDB using Perl](/updating-mongodb-with-perl)

